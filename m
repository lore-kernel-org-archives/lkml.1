Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab0BDXbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:31:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:32260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab0BDXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:31:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e+uVdJGEwD2OhKL6YwAoCywabLwVbef3kkdroePb8/b4gf3dcHtxLbxYMGAKbtl4CT
         ZEwQPsMY218LbpKnGYnDd7tIQAtBRUJX/WwXdjOAW2qT0z0fR30b0FBNauutw95u9bfl
         2IcCqqJyDYQp6qRFm1DdU+MqEN1Q8WRSBb2QQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 14/17] MTD: common module for smartmedia/xD support
Date: Fri,  5 Feb 2010 01:30:54 +0200
Message-Id: <1265326257-4446-15-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small module implements few helpers that are usefull
for nand drivers for SmartMedia/xD card readers.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/Kconfig     |    9 +++
 drivers/mtd/nand/Makefile    |    1 +
 drivers/mtd/nand/sm_common.c |  126 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/sm_common.h |   61 ++++++++++++++++++++
 4 files changed, 197 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/nand/sm_common.c
 create mode 100644 drivers/mtd/nand/sm_common.h

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 677cd53..13c1fb2 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -18,6 +18,10 @@ config MTD_NAND_VERIFY_WRITE
 	  device thinks the write was successful, a bit could have been
 	  flipped accidentally due to device wear or something else.
 
+config MTD_NAND_SMARTMEDIA
+	boolean
+	default n
+
 config MTD_NAND_ECC_SMC
 	bool "NAND ECC Smart Media byte order"
 	default n
@@ -25,6 +29,11 @@ config MTD_NAND_ECC_SMC
 	  Software ECC according to the Smart Media Specification.
 	  The original Linux implementation had byte 0 and 1 swapped.
 
+config MTD_SM_COMMON
+	select MTD_NAND_SMARTMEDIA
+	tristate
+	default n
+
 config MTD_NAND_MUSEUM_IDS
 	bool "Enable chip ids for obsolete ancient NAND devices"
 	depends on MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 1407bd1..09891f6 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_MTD_NAND)			+= nand.o nand_ecc.o
 obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o
+obj-$(CONFIG_MTD_SM_COMMON) 		+= sm_common.o
 
 obj-$(CONFIG_MTD_NAND_CAFE)		+= cafe_nand.o
 obj-$(CONFIG_MTD_NAND_SPIA)		+= spia.o
diff --git a/drivers/mtd/nand/sm_common.c b/drivers/mtd/nand/sm_common.c
new file mode 100644
index 0000000..aa7e740
--- /dev/null
+++ b/drivers/mtd/nand/sm_common.c
@@ -0,0 +1,126 @@
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
+		{.offset = 6 , .length = 2}, /* LBA1 */
+		{.offset = 11, .length = 2}  /* LBA2 */
+	}
+};
+
+/* Tests if block (more correctly page) is bad */
+static int sm_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct mtd_oob_ops ops;
+	struct sm_oob oob;
+	int bad = 0, ret;
+
+	ops.mode = MTD_OOB_PLACE;
+	ops.ooboffs = 0;
+	ops.ooblen = SM_OOB_SIZE;
+	ops.oobbuf = (void *)&oob;
+	ops.datbuf = NULL;
+
+	if (getchip) {
+		nand_get_device(chip, mtd, FL_READING);
+		chip->select_chip(mtd, 0);
+	}
+
+	ret = nand_do_read_oob(mtd, ofs, &ops);
+	if (ret < 0 || ops.oobretlen != SM_OOB_SIZE)
+		goto out;
+
+	if (!sm_sector_valid(&oob) || !sm_block_valid(&oob)) {
+		bad = 1;
+		goto out;
+	}
+out:
+	if (getchip)
+		nand_release_device(mtd);
+	return bad;
+}
+
+/* Marks block as bad */
+static int sm_block_markbad(struct mtd_info *mtd, loff_t ofs)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct mtd_oob_ops ops;
+	struct sm_oob oob;
+	int ret, error = 0;
+
+	memset(&oob, -1, SM_OOB_SIZE);
+	oob.data_status = 0;
+
+	ops.mode = MTD_OOB_PLACE;
+	ops.ooboffs = 0;
+	ops.ooblen = SM_OOB_SIZE;
+	ops.oobbuf = (void *)&oob;
+	ops.datbuf = NULL;
+
+	nand_get_device(chip, mtd, FL_WRITING);
+
+	ret = nand_do_write_oob(mtd, ofs, &ops);
+	if (ret < 0 || ops.oobretlen != SM_OOB_SIZE) {
+		printk(KERN_NOTICE
+			"sm_common: can't mark sector at %i as bad\n",
+								(int)ofs);
+		error = -EIO;
+	} else
+		mtd->ecc_stats.badblocks++;
+
+	nand_release_device(mtd);
+	return error;
+}
+
+int sm_register_device(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	int ret;
+
+	chip->options |= NAND_SKIP_BBTSCAN | NAND_SMARTMEDIA;
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
+	/* SmartMedia on small page nand, has page depedent oob layout,
+		thus let FTL do that hard job */
+	} else if (mtd->writesize != SM_SMALL_PAGE)
+		return -ENODEV;
+
+	ret = nand_scan_tail(mtd);
+	if (ret)
+		return ret;
+
+	ret = add_mtd_device(mtd);
+	if (ret)
+		return ret;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sm_register_device);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
+MODULE_DESCRIPTION("Common SmartMedia/xD functions");
diff --git a/drivers/mtd/nand/sm_common.h b/drivers/mtd/nand/sm_common.h
new file mode 100644
index 0000000..a579fb6
--- /dev/null
+++ b/drivers/mtd/nand/sm_common.h
@@ -0,0 +1,61 @@
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
+struct sm_oob {
+	u32 reserved;
+	u8  data_status;
+	u8  block_status;
+	u8 lba_copy1[2];
+	u8  ecc2[3];
+	u8 lba_copy2[2];
+	u8  ecc1[3];
+} __attribute__((packed));
+
+
+/* one sector is always 512 bytes, but it can consist of two nand pages */
+#define SM_SECTOR_SIZE		512
+
+/* oob area is also 16 bytes, but might be from two pages */
+#define SM_OOB_SIZE		16
+
+/* This is maximum zone size, and all devices that have more that one zone
+   have this size */
+#define SM_MAX_ZONE_SIZE 	1024
+
+/* support for small page nand */
+#define SM_SMALL_PAGE 		256
+#define SM_SMALL_OOB_SIZE	8
+
+
+extern int sm_register_device(struct mtd_info *mtd);
+
+
+inline int sm_sector_valid(struct sm_oob *oob)
+{
+	return hweight16(oob->data_status) >= 5;
+}
+
+inline int sm_block_valid(struct sm_oob *oob)
+{
+	return hweight16(oob->block_status) >= 7;
+}
+
+inline int sm_block_erased(struct sm_oob *oob)
+{
+	static const u32 erased_pattern[4] = {
+		0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF };
+
+	/* First test for erased block */
+	if (!memcmp(oob, erased_pattern, sizeof(*oob)))
+		return 1;
+	return 0;
+}
-- 
1.6.3.3

