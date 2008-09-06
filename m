Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYIFRTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYIFRTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYIFRTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:19:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYIFRTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:19:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent:from;
	b=RTLdYd76LtmapwfBAKUhsV7Nca0fwv58Cs++o2o5gYwKO16IOX9mnmGAQo81hF2/F
	HGbP3kcRVCFGvS21DeHTA==
Date: Sat, 6 Sep 2008 10:18:50 -0700
To: sshtylyov@ru.mvista.com, bzolnier@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix pointer arithmetic in hpt3xx driver code (3rd try)
Message-ID: <20080906171850.GF26371@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: masouds@google.com (Masoud Sharbiani)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git commit 74811f355f4f69a187fa74892dcf2a684b84ce99 causes crash at
module load (or boot) time on my machine with a hpt374 controller.
The reason for this is that for initializing second controller which sets
(hwif->dev == host->dev[1]) to true (1), adds 1 to a void ptr, which
advances it by one byte instead of advancing it by sizeof(hpt_info) bytes.
Because of this, all initialization functions get corrupted data in info
variable which causes a crash at boot time.

This patch fixes that and makes my machine boot again.

The card itself is a HPT374 raid conroller: Here is the lspci -v output:
03:06.0 RAID bus controller: HighPoint Technologies, Inc. HPT374 (rev
07)
        Subsystem: HighPoint Technologies, Inc. Unknown device 0001
        Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 28
        I/O ports at 8000 [size=8]
        I/O ports at 7800 [size=4]
        I/O ports at 7400 [size=8]
        I/O ports at 7000 [size=4]
        I/O ports at 6800 [size=256]
        Expansion ROM at fe8e0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2

03:06.1 RAID bus controller: HighPoint Technologies, Inc. HPT374 (rev
07)
        Subsystem: HighPoint Technologies, Inc. Unknown device 0001
        Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 28
        I/O ports at 9800 [size=8]
        I/O ports at 9400 [size=4]
        I/O ports at 9000 [size=8]
        I/O ports at 8800 [size=4]
        I/O ports at 8400 [size=256]
        Capabilities: [60] Power Management version 2


Signed-Off-By: Masoud Sharbiani <masouds@google.com>

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index eb107ee..4eae284 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 	return 0;
 }
 
+static struct hpt_info *hpt3xx_get_info(struct device *dev)
+{
+	struct ide_host *host	= pci_get_drvdata(to_pci_dev(pci_dev));
+	struct hpt_info *info	= (struct hpt_info *)host->host_priv;
+
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
@@ -744,8 +747,7 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
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

