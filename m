Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbZIDQVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbZIDQVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933706AbZIDQUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:49 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:63494 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933655AbZIDQUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:20:46 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, Ian Molton <spyro@f2s.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       vimal singh <vimal.newwork@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] txx9ndfmc: Transfer 512 byte at a time if possible
Date: Sat,  5 Sep 2009 01:20:45 +0900
Message-Id: <1252081245-11895-3-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __nand_correct_data() helper function, this driver can read 512
byte (with 6 byte ECC) at a time.  This results minor performance
improvement.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/nand/txx9ndfmc.c |   52 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index 488088e..73af832 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -189,18 +189,43 @@ static int txx9ndfmc_calculate_ecc(struct mtd_info *mtd, const uint8_t *dat,
 				   uint8_t *ecc_code)
 {
 	struct platform_device *dev = mtd_to_platdev(mtd);
+	struct nand_chip *chip = mtd->priv;
+	int eccbytes;
 	u32 mcr = txx9ndfmc_read(dev, TXX9_NDFMCR);
 
 	mcr &= ~TXX9_NDFMCR_ECC_ALL;
 	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_OFF, TXX9_NDFMCR);
 	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_READ, TXX9_NDFMCR);
-	ecc_code[1] = txx9ndfmc_read(dev, TXX9_NDFDTR);
-	ecc_code[0] = txx9ndfmc_read(dev, TXX9_NDFDTR);
-	ecc_code[2] = txx9ndfmc_read(dev, TXX9_NDFDTR);
+	for (eccbytes = chip->ecc.bytes; eccbytes > 0; eccbytes -= 3) {
+		ecc_code[1] = txx9ndfmc_read(dev, TXX9_NDFDTR);
+		ecc_code[0] = txx9ndfmc_read(dev, TXX9_NDFDTR);
+		ecc_code[2] = txx9ndfmc_read(dev, TXX9_NDFDTR);
+		ecc_code += 3;
+	}
 	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_OFF, TXX9_NDFMCR);
 	return 0;
 }
 
+static int txx9ndfmc_correct_data(struct mtd_info *mtd, unsigned char *buf,
+		unsigned char *read_ecc, unsigned char *calc_ecc)
+{
+	struct nand_chip *chip = mtd->priv;
+	int eccsize;
+	int corrected = 0;
+	int stat;
+
+	for (eccsize = chip->ecc.size; eccsize > 0; eccsize -= 256) {
+		stat = __nand_correct_data(buf, read_ecc, calc_ecc, 256);
+		if (stat < 0)
+			return stat;
+		corrected += stat;
+		buf += 256;
+		read_ecc += 3;
+		calc_ecc += 3;
+	}
+	return corrected;
+}
+
 static void txx9ndfmc_enable_hwecc(struct mtd_info *mtd, int mode)
 {
 	struct platform_device *dev = mtd_to_platdev(mtd);
@@ -244,6 +269,22 @@ static void txx9ndfmc_initialize(struct platform_device *dev)
 #define TXX9NDFMC_NS_TO_CYC(gbusclk, ns) \
 	DIV_ROUND_UP((ns) * DIV_ROUND_UP(gbusclk, 1000), 1000000)
 
+static int txx9ndfmc_nand_scan(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = mtd->priv;
+	int ret;
+
+	ret = nand_scan_ident(mtd, 1);
+	if (!ret) {
+		if (mtd->writesize >= 512) {
+			chip->ecc.size = mtd->writesize;
+			chip->ecc.bytes = 3 * (mtd->writesize / 256);
+		}
+		ret = nand_scan_tail(mtd);
+	}
+	return ret;
+}
+
 static int __init txx9ndfmc_probe(struct platform_device *dev)
 {
 	struct txx9ndfmc_platform_data *plat = dev->dev.platform_data;
@@ -321,9 +362,10 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 		chip->cmd_ctrl = txx9ndfmc_cmd_ctrl;
 		chip->dev_ready = txx9ndfmc_dev_ready;
 		chip->ecc.calculate = txx9ndfmc_calculate_ecc;
-		chip->ecc.correct = nand_correct_data;
+		chip->ecc.correct = txx9ndfmc_correct_data;
 		chip->ecc.hwctl = txx9ndfmc_enable_hwecc;
 		chip->ecc.mode = NAND_ECC_HW;
+		/* txx9ndfmc_nand_scan will overwrite ecc.size and ecc.bytes */
 		chip->ecc.size = 256;
 		chip->ecc.bytes = 3;
 		chip->chip_delay = 100;
@@ -349,7 +391,7 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 		if (plat->wide_mask & (1 << i))
 			chip->options |= NAND_BUSWIDTH_16;
 
-		if (nand_scan(mtd, 1)) {
+		if (txx9ndfmc_nand_scan(mtd)) {
 			kfree(txx9_priv->mtdname);
 			kfree(txx9_priv);
 			continue;
-- 
1.5.6.5

