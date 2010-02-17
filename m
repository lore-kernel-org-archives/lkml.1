Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab0BQNl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:41:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38175 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043Ab0BQNl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:41:27 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/5] Subject: [PATCH] pata_atiixp: add locking for parallel
	scanning
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:17:31 +0000
Message-ID: <20100217131703.16884.70560.stgit@localhost.localdomain>
In-Reply-To: <20100217131532.16884.21696.stgit@localhost.localdomain>
References: <20100217131532.16884.21696.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This is similar change as commit 60c3be3 for ata_piix host driver
and while pata_atiixp doesn't enable parallel scan yet the race
could probably also be triggered by requesting re-scanning of both
ports at the same time using SCSI sysfs interface.

[Ported to current tree without other patch dependancies by Alan Cox]

Original is
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This one is
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_atiixp.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)


diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index ec44a12..7143cb0 100644
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
@@ -46,6 +46,8 @@ static int atiixp_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA40;
 }
 
+static DEFINE_SPINLOCK(atiixp_lock);
+
 /**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -88,7 +90,10 @@ static void atiixp_set_pio_timing(struct ata_port *ap, struct ata_device *adev,
 
 static void atiixp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&atiixp_lock, flags);
 	atiixp_set_pio_timing(ap, adev, adev->pio_mode - XFER_PIO_0);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 /**
@@ -108,6 +113,9 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	int dma = adev->dma_mode;
 	int dn = 2 * ap->port_no + adev->devno;
 	int wanted_pio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&atiixp_lock, flags);
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		u16 udma_mode_data;
@@ -145,6 +153,7 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	if (adev->pio_mode != wanted_pio)
 		atiixp_set_pio_timing(ap, adev, wanted_pio);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 /**

