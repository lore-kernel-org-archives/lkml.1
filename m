Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761Ab0AHPJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0AHPJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554Ab0AHPJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:09:46 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:65009 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0AHPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:09:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=blfQK+geArL0uf+6yA5H8i2fNHoMKfjXsli1wyw9JbWv8UCiN5f+640NLAXoduvAFW
         UjPhip1ycW043yaQL4/4MsrlABhanjsHpJ+quJ6e/wTbgoRb87+rAg8i/EzD5sY5LWsT
         HoHgH3L/pqzzWRvoMaFU5kcrjLQhmu7bQWJV0=
Subject: [PATCH 6/9] mtd: common module for smartmedia/xD support
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
References: <1262963092.12577.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:09:40 +0200
Message-ID: <1262963380.12577.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7297f3c08c9cd19b5cca4073afc225e1e4e293fb Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 8 Jan 2010 16:00:56 +0200
Subject: [PATCH 6/9] mtd: common module for smartmedia/xD support
 This small module implements few helpers that are usefull
 for nand drivers for SmartMedia/xD card readers
 and for SmartMedia translation layer.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/Kconfig     |    9 ++
 drivers/mtd/Makefile    |    1 +
 drivers/mtd/sm_common.c |  227 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/sm_common.h |   50 ++++++++++
 4 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/sm_common.c
 create mode 100644 drivers/mtd/sm_common.h

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index ecf90f5..ebeabd6 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -25,6 +25,15 @@ config MTD_DEBUG_VERBOSE
 	help
 	  Determines the verbosity level of the MTD debugging messages.
 
+config MTD_NAND_SMARTMEDIA
+	boolean
+
+config MTD_SM_COMMON
+	depends on MTD_NAND
+	select MTD_NAND_SMARTMEDIA
+	tristate
+	default n
+
 config MTD_TESTS
 	tristate "MTD tests support"
 	depends on m
diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 82d1e4d..02c5b17 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_MTD)		+= mtd.o
 mtd-y				:= mtdcore.o mtdsuper.o mtdbdi.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
 
+obj-$(CONFIG_MTD_SM_COMMON) 	+= sm_common.o
 obj-$(CONFIG_MTD_CONCAT)	+= mtdconcat.o
 obj-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
 obj-$(CONFIG_MTD_CMDLINE_PARTS) += cmdlinepart.o
diff --git a/drivers/mtd/sm_common.c b/drivers/mtd/sm_common.c
new file mode 100644
index 0000000..45b577f
--- /dev/null
+++ b/drivers/mtd/sm_common.c
@@ -0,0 +1,227 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * Common routines & support for xD format
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/log2.h>
+#include "sm_common.h"
+
+static struct nand_ecclayout nand_oob_sm = {
+	.eccbytes = 6,
+	.eccpos = {8, 9, 10, 13, 14, 15},
+	.oobfree = {
+		{.offset = 0 , .length = 4}, /* reserved */
+		{.offset = 4 , .length = 2}, /* data & block status */
+		{.offset = 6 , .length = 2}, /* LBA1 */
+		{.offset = 11, .length = 2}  /* LBA2 */
+	}
+};
+
+static struct nand_ecclayout nand_oob_sm_smallpage = {
+	.eccbytes = 0,
+	.oobfree = {
+		{.offset = 0 , .length = 8},
+	}
+};
+
+static int sm_get_lba(u8 *lba)
+{
+	/* check fixed bits */
+	if ((lba[0] & 0xF8) != 0x10)
+		return -2;
+
+	/* check parity - endianess doesn't matter */
+	if (hweight16(*(u16 *)lba) & 1)
+		return -2;
+
+	return (lba[1] >> 1) | ((lba[0] & 0x07) << 7);
+}
+
+
+/*
+ * Read LBA asscociated with block
+ * returns -1, if block is erased
+ * returns -2 if error happens
+ */
+int sm_read_lba(struct sm_oob *oob)
+{
+	static const u32 erased_pattern[4] = {
+		0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF };
+
+	u16 lba_test;
+	int lba;
+
+	/* First test for erased block */
+	if (!memcmp(oob, erased_pattern, sizeof(struct sm_oob)))
+		return -1;
+
+	/* Now check is both copies of the LBA differ too much */
+	lba_test = *(u16 *)oob->lba_copy1 ^ *(u16*)oob->lba_copy2;
+	if (lba_test && !is_power_of_2(lba_test))
+		return -2;
+
+	/* And read it */
+	lba = sm_get_lba(oob->lba_copy1);
+
+	if (lba == -2)
+		lba = sm_get_lba(oob->lba_copy2);
+
+	return lba;
+}
+EXPORT_SYMBOL_GPL(sm_read_lba);
+
+void sm_write_lba(struct sm_oob *oob, u16 lba)
+{
+	u8 tmp[2];
+
+	WARN_ON(lba > 1000);
+
+	tmp[0] = 0x10 | ((lba >> 7) & 0x07);
+	tmp[1] = (lba << 1) & 0xFF;
+
+	if (hweight16(*(u16 *)tmp) & 0x01)
+		tmp[1] |= 1;
+
+	oob->lba_copy1[0] = oob->lba_copy2[0] = tmp[0];
+	oob->lba_copy1[1] = oob->lba_copy2[1] = tmp[1];
+}
+EXPORT_SYMBOL_GPL(sm_write_lba);
+
+/* Test if whole block is valid, or at least is marked as such...*/
+int sm_block_valid(struct sm_oob *oob)
+{
+	/* test block status */
+	if (hweight16(oob->block_status) < 7)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sm_block_valid);
+
+/* Test if sector is valid */
+int sm_sector_valid(struct sm_oob *oob)
+{
+	/* test data status */
+	if (hweight16(oob->data_status) < 5)
+		return -EIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sm_sector_valid);
+
+/* Nand interface helpers */
+static int sm_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct mtd_oob_ops ops;
+	struct sm_oob oob;
+	int ret;
+
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooboffs = 0;
+	ops.ooblen = sizeof(struct sm_oob);
+	ops.oobbuf = (void *)&oob;
+	ops.datbuf = NULL;
+
+	/* TODO: This doesn't take controller lock,
+		but we know that all xD cards are single chip. */
+	if (getchip)
+		chip->select_chip(mtd, 0);
+
+	ret = nand_do_read_oob(mtd, ofs, &ops);
+	if (ret < 0 || ops.oobretlen != sizeof(struct sm_oob))
+		goto out;
+
+	ret = (sm_block_valid(&oob) || sm_sector_valid(&oob)) ? 1 : 0;
+out:
+	if (getchip)
+		chip->select_chip(mtd, -1);
+
+	if (ret)
+		printk(KERN_NOTICE "sm_common: bad sector at %i\n", (int)ofs);
+	return ret;
+}
+
+static int sm_block_markbad(struct mtd_info *mtd, loff_t ofs)
+{
+	struct mtd_oob_ops ops;
+	struct sm_oob oob;
+	int ret;
+
+	memset(&oob, -1, sizeof(oob));
+	oob.block_status = 0xF0;
+
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooboffs = 0;
+	ops.ooblen = sizeof(struct sm_oob);
+	ops.oobbuf = (void *)&oob;
+	ops.datbuf = NULL;
+
+	ret = nand_do_write_oob(mtd, ofs, &ops);
+	if (ret < 0 || ops.oobretlen != sizeof(struct sm_oob)) {
+		printk(KERN_NOTICE "sm_common: can't mark sector at %i as bad\n",
+					(int)ofs);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sm_block_bad_dummy(struct mtd_info *mtd, loff_t ofs, int getchip)
+{
+	return 0;
+}
+
+static int sm_block_markbad_dummy(struct mtd_info *mtd, loff_t ofs)
+{
+	return -EIO;
+}
+
+int sm_register_device(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	int ret;
+
+	chip->options |= NAND_SKIP_BBTSCAN | NAND_NO_AUTOINCR;
+
+	/* Scan for card properties */
+	ret = nand_scan_ident(mtd, 1);
+
+	if (ret)
+		return ret;
+
+	/* Set oob handling functions. */
+	if (mtd->writesize == SM_SECTOR_SIZE) {
+		chip->block_bad = sm_block_bad;
+		chip->block_markbad = sm_block_markbad;
+		chip->ecc.layout = &nand_oob_sm;
+
+	/* SmartMedia on small page nand has page depedent oob layout,
+		thus let FTL do that hard job */
+	} else if (mtd->writesize == SM_SMALL_PAGE) {
+		chip->block_bad = sm_block_bad_dummy;
+		chip->block_markbad = sm_block_markbad_dummy;
+		chip->ecc.layout = &nand_oob_sm_smallpage;
+	} else
+		return -ENODEV;
+
+	ret = nand_scan_tail(mtd);
+	if (ret)
+		return ret;
+
+	ret = add_mtd_device(mtd);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sm_register_device);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
+MODULE_DESCRIPTION("Common SmartMedia/xD functions");
diff --git a/drivers/mtd/sm_common.h b/drivers/mtd/sm_common.h
new file mode 100644
index 0000000..42d94b2
--- /dev/null
+++ b/drivers/mtd/sm_common.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * Common routines & support for SmartMedia/xD format
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mtd/nand.h>
+
+/* Full oob structure as written on the flash */
+struct sm_oob_raw {
+	u32 reserved;
+	u8  data_status;
+	u8  block_status;
+	u8 lba_copy1[2];
+	u8  ecc2[3];
+	u8 lba_copy2[2];
+	u8  ecc1[3];
+} __attribute__((packed));
+
+/* oob structure without ecc fields, used by external interfaces */
+struct sm_oob {
+	u32 reserved;
+	u8  data_status;
+	u8  block_status;
+	u8 lba_copy1[2];
+	u8 lba_copy2[2];
+} __attribute__((packed));
+
+
+/* one sector is always 512 bytes, but it can consist of two nand pages */
+#define SM_SECTOR_SIZE		512
+
+/* minumum size of the page */
+#define SM_SMALL_PAGE 		256
+
+/* oob area is also 16 bytes, but might be from two pages */
+#define SM_OOB_SIZE		16
+
+/* This is maximum zone size, and all devices that have more that one zone
+   have this size */
+#define SM_MAX_ZONE_SIZE 	1024
+
+extern int sm_register_device(struct mtd_info *mtd);
+extern int sm_read_lba(struct sm_oob *oob);
+extern void sm_write_lba(struct sm_oob *oob, u16 lba);
+extern int sm_block_valid(struct sm_oob *oob);
+extern int sm_sector_valid(struct sm_oob *oob);
-- 
1.6.3.3



