Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310Ab0ARRQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0ARRQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067Ab0ARRQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:06 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53275 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0ARRQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gmF6kC/ZjamXzTvV40NaN5YEbNdxe6IB+62pD4ZLbyCNv5MpUH+zl/x2OkgdigHSXa
         rZF9Ktms83oQp2oYB6csrK7AnfqQSJsfnvVtLomhAKVO5PV+tiMbYIl+qklv8bcT6hyX
         DpFX0oPqv89n1QQFR9LJrRdhnNC7Jtc5fFJ9A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:37 +0100
Message-Id: <20100118171437.14623.12197.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 06/64] pata_atiixp: add locking for parallel scanning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: add locking for parallel scanning

This is similar change as commit 60c3be3 for ata_piix host driver
and while pata_atiixp doesn't enable parallel scan yet the race
could probably also be triggered by requesting re-scanning of both
ports at the same time using SCSI sysfs interface.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -1,7 +1,7 @@
 /*
  * pata_atiixp.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  (C) 2009 Bartlomiej Zolnierkiewicz
+ *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * Based on
  *
@@ -71,6 +71,8 @@ static int atiixp_prereset(struct ata_li
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(atiixp_lock);
+
 /**
  *	atiixp_set_piomode	-	set PIO mode data
  *	@ap: ATA interface
@@ -85,12 +87,15 @@ static void atiixp_set_piomode(struct at
 	static u8 pio_timings[5] = { 0x5D, 0x47, 0x34, 0x22, 0x20 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	int dn = 2 * ap->port_no + adev->devno;
 	int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
 	int pio = adev->pio_mode - XFER_PIO_0;
 	u32 pio_timing_data;
 	u16 pio_mode_data;
 
+	spin_lock_irqsave(&atiixp_lock, flags);
+
 	pci_read_config_word(pdev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
 	pio_mode_data &= ~(0x7 << (4 * dn));
 	pio_mode_data |= pio << (4 * dn);
@@ -100,6 +105,8 @@ static void atiixp_set_piomode(struct at
 	pio_timing_data &= ~(0xFF << timing_shift);
 	pio_timing_data |= (pio_timings[pio] << timing_shift);
 	pci_write_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
+
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 /**
@@ -115,10 +122,13 @@ static void atiixp_set_dmamode(struct at
 	static u8 mwdma_timings[5] = { 0x77, 0x21, 0x20 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	int dma = adev->dma_mode;
 	int dn = 2 * ap->port_no + adev->devno;
 	u16 tmp16;
 
+	spin_lock_irqsave(&atiixp_lock, flags);
+
 	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
@@ -149,6 +159,8 @@ static void atiixp_set_dmamode(struct at
 	}
 
 	pci_write_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
+
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 static struct scsi_host_template atiixp_sht = {
