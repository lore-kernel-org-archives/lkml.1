Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbYB0WJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbYB0WJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbYB0WI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:08:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:47795 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719AbYB0WIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=iCt6KC80ATXd9doiUiEdVBpnDgctn8IYnRKPzCMbBxW3gYa7fY5o022UUF6RvlOWrnmOBQe8rIjcWlO8eB0OV/5lGXgUnPZUvZVxnV4XOKzyUk4sMuNxGGP26lfbe/YK73vkYsb8YLqQ4+NHVxWih7KWS89OZ7I5qGJ1PzysFcY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] ide: remove ->noprobe field from ide_hwif_t
Date: Wed, 27 Feb 2008 23:19:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802272319.48121.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update IDE PMAC host driver to use drive->noprobe instead of hwif->noprobe
and remove hwif->noprobe completely (it is always set to zero now).

There should be no functional changes caused by this patch.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c |    1 -
 drivers/ide/ide-probe.c  |    3 +--
 drivers/ide/ide.c        |    4 ----
 drivers/ide/mips/swarm.c |    1 -
 drivers/ide/ppc/pmac.c   |   15 ++++++++++-----
 include/linux/ide.h      |    1 -
 6 files changed, 11 insertions(+), 14 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -424,7 +424,6 @@ icside_setup(void __iomem *base, struct 
 		}
 		hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)base + info->ctrloffset;
 		hwif->irq     = ec->irq;
-		hwif->noprobe = 0;
 		hwif->chipset = ide_acorn;
 		hwif->gendev.parent = &ec->dev;
 		hwif->dev = &ec->dev;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -773,8 +773,7 @@ static int ide_probe_port(ide_hwif_t *hw
 
 	BUG_ON(hwif->present);
 
-	if (hwif->noprobe ||
-	    (hwif->drives[0].noprobe && hwif->drives[1].noprobe))
+	if (hwif->drives[0].noprobe && hwif->drives[1].noprobe)
 		return -EACCES;
 
 	/*
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -456,7 +456,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 {
 	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
-	hwif->noprobe = 0;
 	hwif->chipset = hw->chipset;
 	hwif->gendev.parent = hw->dev;
 	hwif->ack_intr = hw->ack_intr;
@@ -1016,14 +1015,12 @@ static int __init ide_setup(char *s)
 				goto done;
 			case -3: /* "nowerr" */
 				drive->bad_wstat = BAD_R_STAT;
-				hwif->noprobe = 0;
 				goto done;
 			case -4: /* "cdrom" */
 				drive->present = 1;
 				drive->media = ide_cdrom;
 				/* an ATAPI device ignores DRDY */
 				drive->ready_stat = 0;
-				hwif->noprobe = 0;
 				goto done;
 			case -5: /* nodma */
 				drive->nodma = 1;
@@ -1054,7 +1051,6 @@ static int __init ide_setup(char *s)
 				drive->sect	= drive->bios_sect = vals[2];
 				drive->present	= 1;
 				drive->forced_geom = 1;
-				hwif->noprobe = 0;
 				goto done;
 			default:
 				goto bad_option;
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -113,7 +113,6 @@ static int __devinit swarm_ide_probe(str
 	/* Prevent resource map manipulation.  */
 	hwif->mmio = 1;
 	hwif->chipset = ide_generic;
-	hwif->noprobe = 0;
 
 	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
 		hwif->io_ports[i] =
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1049,17 +1049,22 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	hwif->mmio = 1;
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
-	hwif->noprobe = pmif->mediabay;
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 
 	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
 	       pmif->mediabay ? " (mediabay)" : "", hwif->irq);
-			
+
+	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
-	if (pmif->mediabay && check_media_bay_by_base(pmif->regbase, MB_CD) == 0)
-		hwif->noprobe = 0;
-#endif /* CONFIG_PMAC_MEDIABAY */
+		if (check_media_bay_by_base(pmif->regbase, MB_CD)) {
+#else
+		if (1) {
+#endif
+			hwif->drives[0].noprobe = 1;
+			hwif->drives[1].noprobe = 1;
+		}
+	}
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 	if (pmif->cable_80 == 0)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -516,7 +516,6 @@ typedef struct hwif_s {
 	unsigned long	extra_base;	/* extra addr for dma ports */
 	unsigned	extra_ports;	/* number of extra dma ports */
 
-	unsigned	noprobe    : 1;	/* don't probe for this interface */
 	unsigned	present    : 1;	/* this interface exists */
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
