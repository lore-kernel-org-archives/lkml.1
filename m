Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYG0G3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYG0G3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYG0G25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:28:57 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:35709 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541AbYG0G24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=gibjlfY5jUYvS0aCJV2/I16WNsisWHQPxTl3ljP6pO+RZSN1xhfjf5vbjnZU+TWRE7
         D2QjevOyt2R8L8YBsUFXIP7FduDfxmzBUUwZbbKc5iyiduzbxxSkk8/ntmeNK9OBoTfl
         D5uiS3j8seKVi1nstg/XWlgVnCgocQKcLyFeU=
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/7] [MTD] Blackfin NFC Driver: add support for the ECC layout the Blackfin bootrom uses
Date: Sun, 27 Jul 2008 14:27:55 +0800
Message-Id: <1217140079-20014-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
References: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/Kconfig      |   12 ++++++++++++
 drivers/mtd/nand/bf5xx_nand.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 5076faf..6ca1ec0 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -110,6 +110,18 @@ config MTD_NAND_BF5XX_HWECC
 	  Enable the use of the BF5XX's internal ECC generator when
 	  using NAND.
 
+config MTD_NAND_BF5XX_BOOTROM_ECC
+	bool "Use Blackfin BootROM ECC Layout"
+	default n
+	depends on MTD_NAND_BF5XX_HWECC
+	help
+	  If you wish to modify NAND pages and allow the Blackfin on-chip
+	  BootROM to boot from them, say Y here.  This is only necessary
+	  if you are booting U-Boot out of NAND and you wish to update
+	  U-Boot from Linux' userspace.  Otherwise, you should say N here.
+
+	  If unsure, say N.
+
 config MTD_NAND_RTC_FROM4
 	tristate "Renesas Flash ROM 4-slot interface board (FROM_BOARD4)"
 	depends on SH_SOLUTION_ENGINE
diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index fc58afe..3555f6b 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -91,6 +91,41 @@ static const unsigned short bfin_nfc_pin_req[] =
 	 P_NAND_ALE,
 	 0};
 
+#ifdef CONFIG_MTD_NAND_BF5XX_BOOTROM_ECC
+static uint8_t bbt_pattern[] = { 0xff };
+
+static struct nand_bbt_descr bootrom_bbt = {
+	.options = 0,
+	.offs = 63,
+	.len = 1,
+	.pattern = bbt_pattern,
+};
+
+static struct nand_ecclayout bootrom_ecclayout = {
+	.eccbytes = 24,
+	.eccpos = {
+		0x8 * 0, 0x8 * 0 + 1, 0x8 * 0 + 2,
+		0x8 * 1, 0x8 * 1 + 1, 0x8 * 1 + 2,
+		0x8 * 2, 0x8 * 2 + 1, 0x8 * 2 + 2,
+		0x8 * 3, 0x8 * 3 + 1, 0x8 * 3 + 2,
+		0x8 * 4, 0x8 * 4 + 1, 0x8 * 4 + 2,
+		0x8 * 5, 0x8 * 5 + 1, 0x8 * 5 + 2,
+		0x8 * 6, 0x8 * 6 + 1, 0x8 * 6 + 2,
+		0x8 * 7, 0x8 * 7 + 1, 0x8 * 7 + 2
+	},
+	.oobfree = {
+		{ 0x8 * 0 + 3, 5 },
+		{ 0x8 * 1 + 3, 5 },
+		{ 0x8 * 2 + 3, 5 },
+		{ 0x8 * 3 + 3, 5 },
+		{ 0x8 * 4 + 3, 5 },
+		{ 0x8 * 5 + 3, 5 },
+		{ 0x8 * 6 + 3, 5 },
+		{ 0x8 * 7 + 3, 5 },
+	}
+};
+#endif
+
 /*
  * Data structures for bf5xx nand flash controller driver
  */
@@ -712,6 +747,11 @@ static int bf5xx_nand_probe(struct platform_device *pdev)
 
 	/* setup hardware ECC data struct */
 	if (hardware_ecc) {
+#ifdef CONFIG_MTD_NAND_BF5XX_BOOTROM_ECC
+		chip->badblock_pattern = &bootrom_bbt;
+		chip->ecc.layout = &bootrom_ecclayout;
+#endif
+
 		if (plat->page_size == NFC_PG_SIZE_256) {
 			chip->ecc.bytes = 3;
 			chip->ecc.size = 256;
-- 
1.5.6

