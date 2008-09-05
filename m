Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYIEVDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYIEVDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYIEVDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:03:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYIEVDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:03:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent:from;
	b=VVKO1E4CvAxOr8wzG7b6+jQ4XN4SohHM+zhSmEljf3Z76YidRKOQBZhCP6L3Sq5Yv
	1TQaklVhU7P1mxHYvWgJw==
Date: Fri, 5 Sep 2008 14:01:10 -0700
To: bzolnier@gmail.com, sshtylyov@ru.mvista.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix pointer arithmetic in hpt3xx driver code (2nd attempt)
Message-ID: <20080905210110.GE26371@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: masouds@google.com (Masoud Sharbiani)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there, 
git commit 74811f355f4f69a187fa74892dcf2a684b84ce99 causes crash at
module load (or boot) time on my machine with a hpt374 controller.
Sergei says this is due to the pointer arithmatic. This patch fixes that
and makes my machine boot again.
cheers, 
Masoud
Signed-Off-By: Masoud Sharbiani <masouds@google.com>

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index eb107ee..4e04d0a 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 	return 0;
 }
 
+static struct hpt_info *hpt3xx_get_info(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct ide_host *host	= pci_get_drvdata(pci_dev);
+	struct hpt_info *info	= (struct hpt_info *)host->host_priv;
+	return dev == host->dev[1] ? info + 1 : info;
+}
+
 /*
  * The Marvell bridge chips used on the HighPoint SATA cards do not seem
  * to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
@@ -621,9 +629,7 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
@@ -662,9 +668,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
 	switch (info->chip_type) {
 	case HPT372 :
@@ -700,8 +704,7 @@ static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
@@ -743,9 +746,8 @@ static void hpt3xx_quirkproc(ide_drive_t *drive)
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct pci_dev  *dev    = to_pci_dev(hwif->dev);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
 	if (drive->quirk_list) {
 		if (info->chip_type >= HPT370) {
@@ -973,8 +975,7 @@ static int __devinit hpt37x_calibrate_dpll(struct pci_dev *dev, u16 f_low, u16 f
 static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(&dev->dev);
 	const char *name	= DRV_NAME;
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
 	u8 chip_type;
@@ -1217,8 +1218,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	u8 chip_type		= info->chip_type;
 	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 
@@ -1262,8 +1262,7 @@ static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
 	u8  new_mcr, old_mcr	= 0;
