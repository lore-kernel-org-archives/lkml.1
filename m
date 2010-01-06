Return-Path: <linux-kernel-owner+w=401wt.eu-S932914Ab0AFVvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab0AFVvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896Ab0AFVvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:51:54 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43295 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab0AFVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BZgPJwoNKK7mbuuUp4qwEtVUJJjjQJ2SKzLp3C+GeMwyMoypGpz466D+SUdx77X72K
         CQCoyyDCnlzEyazUr11Ngq1amNCyOyMZ7aYdtmbaNj3mRS2NliXLbDO9mt7FA3HCGFqK
         0VcTVlVVnbcSFObHvIRXnWk+np+Sq0pjemlY8=
Subject: [PATCH 6/9] mtd: common module for smartmedia/xD support
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262814216.14552.22.camel@maxim-laptop>
References: <1262814216.14552.22.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 23:51:48 +0200
Message-ID: <1262814708.14552.32.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 06cb6f7fa6d9c708ca0a208b33c6e3b5969aab44 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Wed, 6 Jan 2010 22:52:56 +0200
Subject: [PATCH 6/9] mtd: common module for smartmedia/xD support

---
 drivers/mtd/Kconfig     |    9 ++
 drivers/mtd/Makefile    |    1 +
 drivers/mtd/sm_common.c |  208 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/sm_common.h |   31 +++++++
 4 files changed, 249 insertions(+), 0 deletions(-)
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
index 0000000..3d57f40
--- /dev/null
+++ b/drivers/mtd/sm_common.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * Common routines & support for xD format
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/log2.h>
+#include "sm_common.h"
+
+#if 0
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
+#endif
+
+static struct nand_ecclayout nand_oob_sm = {
+	.eccbytes = 0,
+	.oobfree = {
+		{.offset = 0 , .length = 16}, /* reserved */
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
+	if (hweight16(*(u16*)lba) & 1)
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
+	static const u32 erased_pattern[4] =
+		{ 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF };
+
+	u16 lba_test;
+	int lba;
+	//int i;
+
+	/* First test for erased block */
+	if (!memcmp(oob, erased_pattern, sizeof(erased_pattern)))
+		return -1;
+
+	/* Now check is both copies of the LBA differ too much */
+	lba_test = *(u16*)oob->lba_copy1 ^ *(u16*)oob->lba_copy2;
+	if (lba_test && !is_power_of_2(lba_test))
+		return -2;
+
+
+	/* And read it */
+	if ((lba = sm_get_lba(oob->lba_copy1)) == -2)
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
+	if(hweight16(*(u16*)tmp) & 0x01)
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
+
+
+/* Nand interface helpers */
+static int sm_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct mtd_oob_ops ops;
+	struct sm_oob oob;
+	int ret;
+
+	ops.mode = MTD_OOB_RAW;
+	ops.ooboffs = 0;
+	ops.ooblen = SM_OOB_SIZE;
+	ops.oobbuf = (void*)&oob;
+	ops.datbuf = NULL;
+
+	/* TODO: This doesn't take controller lock,
+		but we know that all xD cards are single chip. */
+	if (getchip)
+		chip->select_chip(mtd, 0);
+
+	ret = nand_do_read_oob(mtd, ofs, &ops);
+	if (ret < 0 || ops.oobretlen != SM_OOB_SIZE)
+		goto out;
+
+	ret = sm_block_valid(&oob) ? 1 : 0;
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
+	memset (&oob, -1, sizeof(oob));
+	oob.block_status = 0xF0;
+
+	ops.mode = MTD_OOB_RAW;
+	ops.ooboffs = 0;
+	ops.ooblen = SM_OOB_SIZE;
+	ops.oobbuf = (void*)&oob;
+	ops.datbuf = NULL;
+
+	ret = nand_do_write_oob(mtd, ofs, &ops);
+	if (ret < 0 || ops.oobretlen != SM_OOB_SIZE) {
+		printk(KERN_NOTICE "sm_common: can't mark sector at %i as bad\n",
+					(int)ofs);
+		return 1;
+	}
+
+	return 0;
+}
+
+int sm_register_device(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+
+	chip->options |= NAND_SKIP_BBTSCAN | NAND_NO_AUTOINCR;
+
+	chip->block_bad = sm_block_bad;
+	chip->block_markbad = sm_block_markbad;
+	chip->ecc.layout = &nand_oob_sm;
+
+	if (nand_scan(mtd, 1))
+		return -ENODEV;
+
+	/* TODO: support small page devices */
+	if (mtd->writesize != 512)
+		return -ENODEV;
+
+
+	if (add_mtd_device(mtd))
+		return -ENODEV;
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(sm_register_device);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
+MODULE_DESCRIPTION("Common SmartMedia/xD functions");
\ No newline at end of file
diff --git a/drivers/mtd/sm_common.h b/drivers/mtd/sm_common.h
new file mode 100644
index 0000000..d546770
--- /dev/null
+++ b/drivers/mtd/sm_common.h
@@ -0,0 +1,31 @@
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
+#define SM_SECTOR_SIZE	512
+#define SM_OOB_SIZE	16
+#define SM_SMALL_PAGE 256
+
+extern int sm_register_device(struct mtd_info *mtd);
+extern int sm_read_lba(struct sm_oob *oob);
+extern void sm_write_lba(struct sm_oob *oob, u16 lba);
+extern int sm_block_valid(struct sm_oob *oob);
+extern int sm_sector_valid(struct sm_oob *oob);
\ No newline at end of file
-- 
1.6.3.3



