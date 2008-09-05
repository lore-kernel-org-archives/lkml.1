Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYIERtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYIERtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIERtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:49:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYIERtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:49:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent:from;
	b=TxMBM3d57RGKFHCHoR3cgQO5lbZquk+Xx1c5rIeSoOvViPb01rmcj7lhPZlLfFSv9
	KWlCAZvy26MKtSTC9giNA==
Date: Fri, 5 Sep 2008 10:48:34 -0700
To: sshtylyov@ru.mvista.com, bzolnier@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix pointer arithmetic in hpt3xx driver code
Message-ID: <20080905174834.GD26371@google.com>
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

Signed-Off-By: Masoud Sharbiani <masouds@google.com>

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index eb107ee..f41f3fd 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 	return 0;
 }
 
+static struct hpt_info *hpt3xx_get_info(void *host_priv, struct device *hwif_dev, struct device *host_dev)
+{
+	struct hpt_info *info = (struct hpt_info *)host_priv;
+	if (hwif_dev == host_dev)
+		info++;
+	return info;
+}
+
 /*
  * The Marvell bridge chips used on the HighPoint SATA cards do not seem
  * to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
@@ -623,7 +631,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, hwif->dev, host->dev[1]);
 	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
@@ -664,7 +672,7 @@ static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, hwif->dev, host->dev[1]);
 
 	switch (info->chip_type) {
 	case HPT372 :
@@ -701,7 +709,7 @@ static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, hwif->dev, host->dev[1]);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
 	u32 old_itr		= 0;
@@ -745,7 +753,7 @@ static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, hwif->dev, host->dev[1]);
 
 	if (drive->quirk_list) {
 		if (info->chip_type >= HPT370) {
@@ -974,7 +982,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, &dev->dev, host->dev[1]);
 	const char *name	= DRV_NAME;
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
 	u8 chip_type;
@@ -1218,7 +1226,7 @@ static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, hwif->dev, host->dev[1]);
 	u8 chip_type		= info->chip_type;
 	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 
@@ -1263,7 +1271,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
-	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
+	struct hpt_info *info	= hpt3xx_get_info(host->host_priv, hwif->dev, host->dev[1]);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
 	u8  new_mcr, old_mcr	= 0;

