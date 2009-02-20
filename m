Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZBTRK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZBTRK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbZBTRJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:09:57 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:18454 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086AbZBTRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=hsBbITTkW5/tTXADWT2/pndMpz6l1IQOwIZgVHW+BWDzivre2yGRVVZ4P2h751k5E2
         UNK21j4sCNtbmFc3lnrN3CrM/h2BGSuGWurVQkq7Peh/7l4wyFHnR0GC2WtqsqntNZmD
         1PmVB7TJ8lCbfuovE1jMAhMqHMqSN6ZVjWcV0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:11:47 +0100
Message-Id: <20090220171147.25429.26218.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/10] ide: add ->dma_clear method and remove ->dma_timeout one
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add ->dma_clear method and remove ->dma_timeout one

All custom ->dma_timeout implementations call the generic one thus it is
possible to have only an optional method for resetting DMA engine instead:

* Add ->dma_clear method and convert hpt366, pdc202xx_old and sl82c105
  host drivers to use it.

* Always use ide_dma_timeout() in ide_dma_timeout_retry() and remove
 ->dma_timeout method.

* Make ide_dma_timeout() static.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c     |    1 -
 drivers/ide/au1xxx-ide.c   |    1 -
 drivers/ide/cmd64x.c       |    3 ---
 drivers/ide/cs5536.c       |    1 -
 drivers/ide/hpt366.c       |   10 +---------
 drivers/ide/icside.c       |    1 -
 drivers/ide/ide-dma-sff.c  |    3 +--
 drivers/ide/ide-dma.c      |   10 ++++++----
 drivers/ide/it821x.c       |    3 +--
 drivers/ide/ns87415.c      |    1 -
 drivers/ide/pdc202xx_old.c |   10 ++--------
 drivers/ide/pmac.c         |    1 -
 drivers/ide/sc1200.c       |    1 -
 drivers/ide/scc_pata.c     |    1 -
 drivers/ide/sgiioc4.c      |    1 -
 drivers/ide/siimage.c      |    1 -
 drivers/ide/sl82c105.c     |    7 +++----
 drivers/ide/tc86c001.c     |    1 -
 drivers/ide/trm290.c       |    1 -
 drivers/ide/tx4939ide.c    |    1 -
 include/linux/ide.h        |    4 ++--
 21 files changed, 16 insertions(+), 47 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -509,7 +509,6 @@ static const struct ide_dma_ops ali_dma_
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -353,7 +353,6 @@ static const struct ide_dma_ops au1xxx_d
 	.dma_end		= auide_dma_end,
 	.dma_test_irq		= auide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -384,7 +384,6 @@ static const struct ide_dma_ops cmd64x_d
 	.dma_test_irq		= cmd64x_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -396,7 +395,6 @@ static const struct ide_dma_ops cmd646_r
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -408,7 +406,6 @@ static const struct ide_dma_ops cmd648_d
 	.dma_test_irq		= cmd648_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -236,7 +236,6 @@ static const struct ide_dma_ops cs5536_d
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info cs5536_info = {
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -835,12 +835,6 @@ static int hpt370_dma_end(ide_drive_t *d
 	return ide_dma_end(drive);
 }
 
-static void hpt370_dma_timeout(ide_drive_t *drive)
-{
-	hpt370_irq_timeout(drive);
-	ide_dma_timeout(drive);
-}
-
 /* returns 1 if DMA IRQ issued, 0 otherwise */
 static int hpt374_dma_test_irq(ide_drive_t *drive)
 {
@@ -1423,7 +1417,6 @@ static const struct ide_dma_ops hpt37x_d
 	.dma_test_irq		= hpt374_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -1435,7 +1428,7 @@ static const struct ide_dma_ops hpt370_d
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= hpt370_dma_timeout,
+	.dma_clear		= hpt370_irq_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -1447,7 +1440,6 @@ static const struct ide_dma_ops hpt36x_d
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -377,7 +377,6 @@ static const struct ide_dma_ops icside_v
 	.dma_start		= icside_dma_start,
 	.dma_end		= icside_dma_end,
 	.dma_test_irq		= icside_dma_test_irq,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
 #else
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -338,9 +338,8 @@ const struct ide_dma_ops sff_dma_ops = {
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 EXPORT_SYMBOL_GPL(sff_dma_ops);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -456,7 +456,7 @@ void ide_dma_lost_irq(ide_drive_t *drive
 }
 EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
-void ide_dma_timeout(ide_drive_t *drive)
+static void ide_dma_timeout(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
@@ -469,7 +469,6 @@ void ide_dma_timeout(ide_drive_t *drive)
 
 	hwif->dma_ops->dma_end(drive);
 }
-EXPORT_SYMBOL_GPL(ide_dma_timeout);
 
 /*
  * un-busy the port etc, and clear any pending DMA status. we want to
@@ -479,6 +478,7 @@ EXPORT_SYMBOL_GPL(ide_dma_timeout);
 ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 	struct request *rq;
 	ide_startstop_t ret = ide_stopped;
 
@@ -488,12 +488,14 @@ ide_startstop_t ide_dma_timeout_retry(id
 
 	if (error < 0) {
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
-		(void)hwif->dma_ops->dma_end(drive);
+		(void)dma_ops->dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		hwif->dma_ops->dma_timeout(drive);
+		if (dma_ops->dma_clear)
+			dma_ops->dma_clear(drive);
+		ide_dma_timeout(drive);
 	}
 
 	/*
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -512,9 +512,8 @@ static struct ide_dma_ops it821x_pass_th
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
-	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -306,7 +306,6 @@ static const struct ide_dma_ops ns87415_
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
 
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -258,12 +258,6 @@ static void pdc202xx_dma_lost_irq(ide_dr
 	ide_dma_lost_irq(drive);
 }
 
-static void pdc202xx_dma_timeout(ide_drive_t *drive)
-{
-	pdc202xx_reset(drive);
-	ide_dma_timeout(drive);
-}
-
 static int init_chipset_pdc202xx(struct pci_dev *dev)
 {
 	unsigned long dmabase = pci_resource_start(dev, 4);
@@ -336,7 +330,7 @@ static const struct ide_dma_ops pdc20246
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= pdc202xx_dma_timeout,
+	.dma_clear		= pdc202xx_reset,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
@@ -348,7 +342,7 @@ static const struct ide_dma_ops pdc2026x
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= pdc202xx_dma_timeout,
+	.dma_clear		= pdc202xx_reset,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1650,7 +1650,6 @@ static const struct ide_dma_ops pmac_dma
 	.dma_start		= pmac_ide_dma_start,
 	.dma_end		= pmac_ide_dma_end,
 	.dma_test_irq		= pmac_ide_dma_test_irq,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= pmac_ide_dma_lost_irq,
 };
 
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -291,7 +291,6 @@ static const struct ide_dma_ops sc1200_d
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -872,7 +872,6 @@ static const struct ide_dma_ops scc_dma_
 	.dma_end		= scc_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -533,7 +533,6 @@ static const struct ide_dma_ops sgiioc4_
 	.dma_end		= sgiioc4_dma_end,
 	.dma_test_irq		= sgiioc4_dma_test_irq,
 	.dma_lost_irq		= sgiioc4_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info sgiioc4_port_info __devinitconst = {
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -715,7 +715,6 @@ static const struct ide_dma_ops sil_dma_
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= siimage_dma_test_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -189,14 +189,13 @@ static void sl82c105_dma_start(ide_drive
 	ide_dma_start(drive);
 }
 
-static void sl82c105_dma_timeout(ide_drive_t *drive)
+static void sl82c105_dma_clear(ide_drive_t *drive)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 
-	DBG(("sl82c105_dma_timeout(drive:%s)\n", drive->name));
+	DBG(("sl82c105_dma_clear(drive:%s)\n", drive->name));
 
 	sl82c105_reset_host(dev);
-	ide_dma_timeout(drive);
 }
 
 static int sl82c105_dma_end(ide_drive_t *drive)
@@ -298,7 +297,7 @@ static const struct ide_dma_ops sl82c105
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= sl82c105_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= sl82c105_dma_timeout,
+	.dma_clear		= sl82c105_dma_clear,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -187,7 +187,6 @@ static const struct ide_dma_ops tc86c001
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -314,7 +314,6 @@ static struct ide_dma_ops trm290_dma_ops
 	.dma_end		= trm290_dma_end,
 	.dma_test_irq		= trm290_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info trm290_chipset __devinitdata = {
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -632,7 +632,6 @@ static const struct ide_dma_ops tx4939id
 	.dma_test_irq		= tx4939ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
-	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -715,8 +715,9 @@ struct ide_dma_ops {
 	int	(*dma_end)(struct ide_drive_s *);
 	int	(*dma_test_irq)(struct ide_drive_s *);
 	void	(*dma_lost_irq)(struct ide_drive_s *);
+	/* below ones are optional */
 	int	(*dma_timer_expiry)(struct ide_drive_s *);
-	void	(*dma_timeout)(struct ide_drive_s *);
+	void	(*dma_clear)(struct ide_drive_s *);
 	/*
 	 * The following method is optional and only required to be
 	 * implemented for the SFF-8038i compatible controllers.
@@ -1458,7 +1459,6 @@ static inline int config_drive_for_dma(i
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
 void ide_dma_lost_irq(ide_drive_t *);
-void ide_dma_timeout(ide_drive_t *);
 ide_startstop_t ide_dma_timeout_retry(ide_drive_t *, int);
 
 #else
