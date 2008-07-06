Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYGFRiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYGFRiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbYGFRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:34:56 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:41596 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbYGFReu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=MUypd79b72nx3xnSfOQn3oBLsx+NAM3UNABv4ys0P1X7hpj1BQ6QtLUAHLkZ942VN3
         vhxNiUZJD5hdorpzxn7teXFKteImg8PuJiNxIihm/VagE+pspMmEwx25sOd/KSZuFdAl
         OUYTt33XgUWxt7yY6DJRuphy9c25tDVjInFaI=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:19 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 09/50] hpt366: convert to use ->host_priv
Content-Disposition: inline; filename=hpt366-convert-to-use-host_priv.patch
Message-ID: <48710238.1ade660a.3458.627b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

* Allocate both struct hpt_info instances at once.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Sergei: we may also consider using only one struct hpt_info instance
for both PCI devices on HPT366 with split PCI config space and HPT374
but I'm leaving this to your judgement.

 drivers/ide/pci/hpt366.c |   72 ++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -620,7 +620,8 @@ static u8 hpt3xx_udma_filter(ide_drive_t
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
@@ -660,7 +661,8 @@ static u8 hpt3xx_mdma_filter(ide_drive_t
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 
 	switch (info->chip_type) {
 	case HPT372 :
@@ -694,8 +696,10 @@ static u32 get_speed_setting(u8 speed, s
 
 static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	struct pci_dev  *dev	= to_pci_dev(drive->hwif->dev);
-	struct hpt_info	*info	= pci_get_drvdata(dev);
+	ide_hwif_t *hwif	= drive->hwif;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
@@ -738,7 +742,8 @@ static void hpt3xx_maskproc(ide_drive_t 
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 
 	if (drive->quirk_list) {
 		if (info->chip_type >= HPT370) {
@@ -965,22 +970,13 @@ static int __devinit hpt37x_calibrate_dp
 
 static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const char *name)
 {
-	struct hpt_info *info	= kmalloc(sizeof(struct hpt_info), GFP_KERNEL);
 	unsigned long io_base	= pci_resource_start(dev, 4);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
 	u8 chip_type;
 	enum ata_clock	clock;
 
-	if (info == NULL) {
-		printk(KERN_ERR "%s: out of memory!\n", name);
-		return -ENOMEM;
-	}
-
-	/*
-	 * Copy everything from a static "template" structure
-	 * to just allocated per-chip hpt_info structure.
-	 */
-	memcpy(info, pci_get_drvdata(dev), sizeof(struct hpt_info));
 	chip_type = info->chip_type;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
@@ -1142,7 +1138,6 @@ static unsigned int __devinit init_chips
 
 		if (info->timings->clock_table[clock] == NULL) {
 			printk(KERN_ERR "%s: unknown bus timing!\n", name);
-			kfree(info);
 			return -EIO;
 		}
 
@@ -1169,7 +1164,6 @@ static unsigned int __devinit init_chips
 		}
 		if (adjust == 8) {
 			printk(KERN_ERR "%s: DPLL did not stabilize!\n", name);
-			kfree(info);
 			return -EIO;
 		}
 
@@ -1186,9 +1180,6 @@ static unsigned int __devinit init_chips
 	info->pci_clk	= pci_clk;
 	info->clock	= clock;
 
-	/* Point to this chip's own instance of the hpt_info structure. */
-	pci_set_drvdata(dev, info);
-
 	if (chip_type >= HPT370) {
 		u8  mcr1, mcr4;
 
@@ -1218,7 +1209,8 @@ static unsigned int __devinit init_chips
 static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	u8 chip_type		= info->chip_type;
 	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 
@@ -1262,7 +1254,8 @@ static u8 __devinit hpt3xx_cable_detect(
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct hpt_info *info	= pci_get_drvdata(dev);
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
 	u8  new_mcr, old_mcr	= 0;
@@ -1542,10 +1535,12 @@ static const struct ide_port_info hpt366
 static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct hpt_info *info = NULL;
+	struct hpt_info *dyn_info;
 	struct pci_dev *dev2 = NULL;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
 	u8 rev = dev->revision;
+	int ret;
 
 	if ((idx == 0 || idx == 4) && (PCI_FUNC(dev->devfn) & 1))
 		return -ENODEV;
@@ -1591,15 +1586,24 @@ static int __devinit hpt366_init_one(str
 	if (info == &hpt370 || info == &hpt370a)
 		d.dma_ops = &hpt370_dma_ops;
 
-	pci_set_drvdata(dev, (void *)info);
-
 	if (info == &hpt36x || info == &hpt374)
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
 
-	if (dev2) {
-		int ret;
+	dyn_info = kzalloc(sizeof(*dyn_info) * (dev2 ? 2 : 1), GFP_KERNEL);
+	if (dyn_info == NULL) {
+		printk(KERN_ERR "%s: out of memory!\n", d.name);
+		pci_dev_put(dev2);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Copy everything from a static "template" structure
+	 * to just allocated per-chip hpt_info structure.
+	 */
+	memcpy(dyn_info, info, sizeof(*dyn_info));
 
-		pci_set_drvdata(dev2, (void *)info);
+	if (dev2) {
+		memcpy(dyn_info + 1, info, sizeof(*dyn_info));
 
 		if (info == &hpt374)
 			hpt374_init(dev, dev2);
@@ -1608,13 +1612,19 @@ static int __devinit hpt366_init_one(str
 				d.host_flags &= ~IDE_HFLAG_NON_BOOTABLE;
 		}
 
-		ret = ide_pci_init_two(dev, dev2, &d, NULL);
-		if (ret < 0)
+		ret = ide_pci_init_two(dev, dev2, &d, dyn_info);
+		if (ret < 0) {
 			pci_dev_put(dev2);
+			kfree(dyn_info);
+		}
 		return ret;
 	}
 
-	return ide_pci_init_one(dev, &d, NULL);
+	ret = ide_pci_init_one(dev, &d, dyn_info);
+	if (ret < 0)
+		kfree(dyn_info);
+
+	return ret;
 }
 
 static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {

-- 

