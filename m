Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0BRS7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:59:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:4680 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165Ab0BRS7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ETXgfrat9QSmN2Pk1fHaSwJxYD/W7AZmBeJ7T9cLDEpc355G3qfgK7zMtmLALZhfaJ
         zm9wSN6huZ4tO1U1r0fmuReDa6ZqjFMp5h6wht4tPG2t0jAqdt1cArqUaTWZD4CDx5+4
         b6spLxZ6UABPxaU0ky7CSZM6f88ZuUXuSgI/E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 18 Feb 2010 19:59:28 +0100
Message-Id: <20100218185928.16594.4054.sendpatchset@localhost>
In-Reply-To: <20100218185914.16594.61415.sendpatchset@localhost>
References: <20100218185914.16594.61415.sendpatchset@localhost>
Subject: [PATCH 2/3] pata_oldpiix: add locking for parallel scanning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_oldpiix: add locking for parallel scanning

Add an extra locking for parallel scanning.

This is similar change as commit 60c3be3 for ata_piix host driver
and while pata_oldpiix doesn't enable parallel scan yet the race
could probably also be triggered by requesting re-scanning of both
ports at the same time using SCSI sysfs interface.

Fix documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_oldpiix.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -1,7 +1,8 @@
 /*
- *    pata_oldpiix.c - Intel PATA/SATA controllers
+ *    pata_oldpiix.c - older Intel PATA controllers
  *
  *	(C) 2005 Red Hat
+ *	(C) 2010 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -50,10 +51,13 @@ static int oldpiix_pre_reset(struct ata_
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(piix_lock);
+
 static void oldpiix_set_timings(struct ata_port *ap, struct ata_device *adev,
 				u8 pio, bool use_mwdma)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
 	u16 idetm_data;
 	int control = 0;
@@ -84,6 +88,8 @@ static void oldpiix_set_timings(struct a
 		/* Enable DMA timing only */
 		control |= 8;	/* PIO cycles in PIO0 */
 
+	spin_lock_irqsave(&piix_lock, flags);
+
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
 	/*
@@ -101,6 +107,8 @@ static void oldpiix_set_timings(struct a
 			(timings[pio][1] << 8);
 	pci_write_config_word(dev, idetm_port, idetm_data);
 
+	spin_unlock_irqrestore(&piix_lock, flags);
+
 	/* Track which port is configured */
 	ap->private_data = adev;
 }
