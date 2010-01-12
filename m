Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808Ab0ALThZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0ALThZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776Ab0ALThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:37:23 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35290 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0ALThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:37:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QSQYsZ6pXV08rje59sB6PVoqec1uJSH6JalmoCWdxxW2VhcIVOgTyxNEj31aY7cqeT
         V8UEZfKkkG2AwDeS05J0qYSUjhG9mqi41GLpFVp8mJbfOKH6nUzrJNCW7fDR9ot3dj5i
         lXHKB18huIyO9NcsLxqAYCGSrIUsWR9mn3Sso=
Subject: [PATCH 9/9] MTD: Add new SmartMedia/xD FTL
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, joern <joern@logfs.org>,
       Alex Dubov <oakad@yahoo.com>
In-Reply-To: <1263324518.6236.18.camel@maxim-laptop>
References: <1263324518.6236.18.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 21:37:15 +0200
Message-ID: <1263325035.6236.27.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 764ff2c5d8f563f5acb9bb7e6b20112652769714 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Tue, 12 Jan 2010 21:09:35 +0200
Subject: [PATCH 9/9] MTD: Add new SmartMedia/xD FTL

This implements new readwrite SmartMedia/xd FTL.

To work properly, nand driver must define an oob layout that
contains reserved area and both copies of the LBA
(8 bytes total)
Also mtd driver should support proper ECC and badblock verification
based on hidden oob parts

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/Kconfig  |   11 +
 drivers/mtd/Makefile |    1 +
 drivers/mtd/sm_ftl.c | 1019 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/sm_ftl.h |   70 ++++
 4 files changed, 1101 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/sm_ftl.c
 create mode 100644 drivers/mtd/sm_ftl.h

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index ecf90f5..00d2fe4 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -304,6 +304,17 @@ config SSFDC
 	  This enables read only access to SmartMedia formatted NAND
 	  flash. You can mount it with FAT file system.
 
+
+config SM_FTL
+	tristate "SmartMedia/xD new translation layer"
+	depends on EXPERIMENTAL
+	help
+	  This enables new and very EXPERMENTAL support for SmartMedia/xD
+	  FTL (Flash tanslation layer)
+	  Write support isn't yet well tested, therefore this code IS likely to
+	  eat your card, so please don't use it together with valuable data.
+	  Use readonly driver (CONFIG_SSFDC) instead.
+
 config MTD_OOPS
 	tristate "Log panic/oops to an MTD buffer"
 	depends on MTD
diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 82d1e4d..d53357b 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_NFTL)		+= nftl.o
 obj-$(CONFIG_INFTL)		+= inftl.o
 obj-$(CONFIG_RFD_FTL)		+= rfd_ftl.o
 obj-$(CONFIG_SSFDC)		+= ssfdc.o
+obj-$(CONFIG_SM_FTL)		+= sm_ftl.o
 obj-$(CONFIG_MTD_OOPS)		+= mtdoops.o
 
 nftl-objs		:= nftlcore.o nftlmount.o
diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
new file mode 100644
index 0000000..b72e84b
--- /dev/null
+++ b/drivers/mtd/sm_ftl.c
@@ -0,0 +1,1019 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * SmartMedia/xD translation layer
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/hdreg.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/bitops.h>
+#include "nand/sm_common.h"
+#include "sm_ftl.h"
+
+static u8 tmp_buffer[SM_SECTOR_SIZE];
+struct workqueue_struct *cache_flush_workqueue;
+
+static int force_load;
+module_param(force_load, bool, S_IRUGO);
+MODULE_PARM_DESC(force_load, "(Dangerous) force load even if CIS not found");
+
+
+static int cache_timeout = 1000;
+module_param(cache_timeout, bool, S_IRUGO);
+MODULE_PARM_DESC(cache_timeout, "Timeout in ms for cache flush (1000 default");
+
+
+
+static void sm_erase_callback(struct erase_info *self);
+static int sm_erase_block(struct sm_ftl *ftl, int zone_num, s16 block,
+								int put_free);
+static void sm_mark_block_bad(struct sm_ftl *ftl, int zone_num, int block);
+
+
+static const struct chs_entry chs_table[] = {
+	{ 1,    125,  4,  4  },
+	{ 2,    125,  4,  8  },
+	{ 4,    250,  4,  8  },
+	{ 8,    250,  4,  16 },
+	{ 16,   500,  4,  16 },
+	{ 32,   500,  8,  16 },
+	{ 64,   500,  8,  32 },
+	{ 128,  500,  16, 32 },
+	{ 256,  1000, 16, 32 },
+	{ 512,  1015, 32, 63 },
+	{ 1024, 985,  33, 63 },
+	{ 2048, 985,  33, 63 },
+	{ 0 },
+};
+
+/* Find out media parameters.
+ * This ideally has to be based on nand id, but for now device size is enough */
+int sm_get_media_info(struct sm_ftl *ftl, struct mtd_info *mtd)
+{
+	int i;
+	int size_in_megs = mtd->size / (1024 * 1024);
+	ftl->readonly = mtd->type == MTD_ROM;
+
+	/* Manual settings for very old devices */
+	ftl->zone_count = 1;
+	ftl->smallpagenand = 0;
+
+	switch (size_in_megs) {
+	case 1:
+		/* 1 Mb flas/rom SmartMedia card (256 byte pages)*/
+		ftl->zone_size = 256;
+		ftl->max_lba = 250;
+		ftl->block_size = 8 * SM_SECTOR_SIZE;
+		ftl->smallpagenand = 1;
+
+		break;
+	case 2:
+		/* 2 Mb flash SmartMedia (256 byte pages)*/
+		if (mtd->writesize == SM_SMALL_PAGE) {
+			ftl->zone_size = 512;
+			ftl->max_lba = 500;
+			ftl->block_size = 8 * SM_SECTOR_SIZE;
+			ftl->smallpagenand = 1;
+		/* 2 Mb rom SmartMedia */
+		} else {
+			ftl->zone_size = 256;
+			ftl->max_lba = 250;
+			ftl->block_size = 16 * SM_SECTOR_SIZE;
+		}
+		break;
+	case 4:
+		/* 4 Mb flash/rom SmartMedia device */
+		ftl->zone_size = 512;
+		ftl->max_lba = 500;
+		ftl->block_size = 16 * SM_SECTOR_SIZE;
+		break;
+	case 8:
+		/* 8 Mb flash/rom SmartMedia device */
+		ftl->zone_size = 1024;
+		ftl->max_lba = 1000;
+		ftl->block_size = 16 * SM_SECTOR_SIZE;
+	}
+
+	/* Minimum xD size is 16M, and thus all xD cards have standard zone
+	   sizes. SmartMedia cards exist up to 128 Mb and have same layout*/
+	if (size_in_megs >= 16) {
+		ftl->zone_count = size_in_megs / 16;
+		ftl->zone_size = 1024;
+		ftl->max_lba = 1000;
+		ftl->block_size = 32 * SM_SECTOR_SIZE;
+	}
+
+	/* Test for proper write and erase sizes */
+	if (mtd->erasesize > ftl->block_size)
+		return -ENODEV;
+
+	if (mtd->writesize > SM_SECTOR_SIZE)
+		return -ENODEV;
+
+	if (mtd->oobavail < sizeof(struct sm_oob))
+		return -ENODEV;
+
+	/* For now, don't support small page nand */
+	if (ftl->smallpagenand)
+		return -ENODEV;
+
+	/* This shouldn't happen */
+	if (ftl->zone_count * ftl->zone_size * ftl->block_size != mtd->size)
+		return -ENODEV;
+
+	/* Find geometry information */
+	for (i = 0 ; i < ARRAY_SIZE(chs_table) ; i++) {
+		if (chs_table[i].size == size_in_megs) {
+			ftl->cylinders = chs_table[i].cyl;
+			ftl->heads = chs_table[i].head;
+			ftl->sectors = chs_table[i].sec;
+			return 0;
+		}
+	}
+
+	ftl->cylinders = 985;
+	ftl->heads =  33;
+	ftl->sectors = 63;
+	return 0;
+}
+
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
+static int sm_read_lba(struct sm_oob *oob)
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
+
+static void sm_write_lba(struct sm_oob *oob, u16 lba)
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
+
+
+/* Make offset from parts */
+static loff_t sm_mkoffset(struct sm_ftl *ftl, int zone, int block, int boffset)
+{
+	WARN_ON(boffset & (SM_SECTOR_SIZE - 1));
+	WARN_ON(zone < 0 || zone >= ftl->zone_count);
+	WARN_ON(block >= ftl->zone_size);
+	WARN_ON(boffset > ftl->block_size);
+
+	if (block == -1)
+		return -1;
+
+	return (zone * SM_MAX_ZONE_SIZE + block) * ftl->block_size + boffset;
+}
+
+/* Breaks offset into parts */
+static void sm_break_offset(struct sm_ftl *ftl, loff_t offset,
+					int *zone, int *block, int *boffset)
+{
+	*boffset = offset % ftl->block_size;
+	offset /= ftl->block_size;
+	*block = offset % ftl->max_lba;
+	offset /= ftl->max_lba;
+	*zone = offset >= ftl->zone_count ? -1 : offset;
+}
+
+
+/* Reads a sector*/
+static int sm_read_sector(struct sm_ftl *ftl, int zone, int block, int boffset,
+								u8 *buffer)
+{
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int ret;
+	size_t retlen;
+	loff_t offset;
+
+	/* FTL can contain -1 entries that are by default filled with bits */
+	if (block == -1) {
+		memset(buffer, 0xFF, SM_SECTOR_SIZE);
+		return 0;
+	}
+
+	offset = sm_mkoffset(ftl, zone, block, boffset);
+	ret = mtd->read(mtd, offset, SM_SECTOR_SIZE, &retlen, buffer);
+
+	if (ret || retlen != SM_SECTOR_SIZE) {
+		return -EIO;
+		dbg("read of block %d at zone %d failed with error %d",
+					block, zone, ret);
+	}
+	return 0;
+}
+
+/* Reads OOB of an sector */
+static int sm_read_sector_oob(struct sm_ftl *ftl,
+		int zone, int block, int boffset, struct sm_oob *oob)
+{
+	struct mtd_oob_ops ops;
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int ret;
+	loff_t offset;
+
+
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooboffs = 0;
+	ops.ooblen = sizeof(struct sm_oob);
+	ops.oobbuf = (void *)oob;
+	ops.datbuf = NULL;
+
+	offset = sm_mkoffset(ftl, zone, block, boffset);
+	ret = mtd->read_oob(mtd, offset, &ops);
+
+	if (ret) {
+		dbg("can't read oob of sector %d of block %d in zone %d "
+			"(error %d)",
+			boffset / SM_SECTOR_SIZE, block, zone, ret);
+		return -EIO;
+	}
+
+	if (ops.oobretlen != sizeof(struct sm_oob)) {
+		dbg("can't read oob of sector %d of block %d in zone %d "
+			"(less that expected oob returned (%d))",
+			boffset / SM_SECTOR_SIZE, block, zone,
+				(int)ops.oobretlen);
+		return -EIO;
+	}
+	return 0;
+}
+
+/* Write a block using data and lba */
+static int sm_write_block(struct sm_ftl *ftl, u8 *buf,
+					int zone_num, int block, int lba)
+{
+	struct mtd_oob_ops ops;
+	int boffset;
+	loff_t offset;
+	int retry = 0;
+
+	struct sm_oob oob;
+	memset(&oob, 0xFF, sizeof(oob));
+	sm_write_lba(&oob, lba);
+
+	if (zone_num == 0 && (block == ftl->cis_block || block == 0)) {
+		dbg("attempted to write the CIS!");
+		return -EIO;
+	}
+
+	ops.len = SM_SECTOR_SIZE;
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooboffs = 0;
+	ops.ooblen = sizeof(struct sm_oob);
+	ops.oobbuf = (void *)&oob;
+
+	/* Use write_oob here because some xD cards only accept writes that
+		contain both page and oob write. These cards most likely
+		do their own ftl */
+
+	offset = sm_mkoffset(ftl, zone_num, block, 0);
+restart:
+	for (boffset = 0; boffset < ftl->block_size;
+				boffset += SM_SECTOR_SIZE) {
+
+		ops.datbuf = buf + boffset;
+
+		if (!ftl->trans->mtd->write_oob(ftl->trans->mtd,
+						offset + boffset, &ops))
+			continue;
+
+		if (!retry) {
+			dbg("write of block %d in zone %d failed, erasing it",
+							block, zone_num);
+
+			/* If write fails. try to erase the block */
+			sm_erase_block(ftl, zone_num, block, 0);
+			retry = 1;
+			goto restart;
+		} else {
+			dbg("write of block %d in zone %d failed again"
+				", marking as bad", block, zone_num);
+
+			sm_mark_block_bad(ftl, zone_num, block);
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+/* Tests if block is marked as bad */
+static int sm_block_bad(struct sm_ftl *ftl, int zone_num, int block)
+{
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int boffset;
+	loff_t offset = sm_mkoffset(ftl, zone_num, block, 0);
+
+	for (boffset = 0; boffset < ftl->block_size ; boffset += SM_SECTOR_SIZE)
+		if (mtd->block_isbad(mtd, offset + boffset))
+			return 1;
+	return 0;
+}
+
+/* Returns offset of first good sector in a block, or -1 if none */
+static int sm_block_good_sector(struct sm_ftl *ftl, int zone_num, int block)
+{
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int boffset;
+	loff_t offset = sm_mkoffset(ftl, zone_num, block, 0);
+
+	for (boffset = 0; boffset < ftl->block_size ; boffset += SM_SECTOR_SIZE)
+		if (!mtd->block_isbad(mtd, offset + boffset))
+			return boffset;
+
+	return -1;
+}
+
+/* Mark whole block at offset 'offs' as bad. */
+static void sm_mark_block_bad(struct sm_ftl *ftl, int zone_num, int block)
+{
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int offset = sm_mkoffset(ftl, zone_num, block, 0);
+	int boffset;
+
+	dbg("marking block %d of zone %d as bad", block, zone_num);
+
+	/* We aren't checking the return value, because we don't care */
+	for (boffset = 0; boffset < ftl->block_size; boffset += SM_SECTOR_SIZE)
+		mtd->block_markbad(mtd, offset + boffset);
+}
+
+/*
+ * Erase a block within a zone
+ * If erase succedes, it updates free block fifo
+ */
+static int sm_erase_block(struct sm_ftl *ftl, int zone_num, s16 block,
+								int put_free)
+{
+	struct ftl_zone *zone = &ftl->zones[zone_num];
+	struct erase_info erase;
+
+	erase.mtd = ftl->trans->mtd;
+	erase.callback = sm_erase_callback;
+	erase.addr = sm_mkoffset(ftl, zone_num, block, 0);
+	erase.len = ftl->block_size;
+	erase.priv = (u_long)ftl;
+
+	ftl->erase_error = -1;
+
+	if (zone_num == 0 && (block == ftl->cis_block || block == 0)) {
+		dbg("attempted to erase the CIS!");
+		return -EIO;
+	}
+
+	if (ftl->trans->mtd->erase(ftl->trans->mtd, &erase)) {
+		dbg("erase of block %d in zone %d failed in mtd->erase call",
+			block, zone_num);
+		goto error;
+	}
+
+	if (erase.state == MTD_ERASE_PENDING)
+		wait_for_completion(&ftl->erase_completion);
+
+	if (ftl->erase_error || erase.state != MTD_ERASE_DONE) {
+		dbg("erase of block %d in zone %d failed after wait",
+			block, zone_num);
+		goto error;
+	}
+
+	if (put_free)
+		kfifo_in(&zone->free_sectors, (const unsigned char *)&block, 2);
+	return 0;
+
+error:
+	sm_mark_block_bad(ftl, zone_num, block);
+	return -EIO;
+}
+
+
+static void sm_erase_callback(struct erase_info *self)
+{
+	struct sm_ftl *ftl = (struct sm_ftl *)self->priv;
+	ftl->erase_error = (self->state == MTD_ERASE_FAILED);
+	complete(&ftl->erase_completion);
+}
+
+
+/* Throughtly test that block is valid. Tries to erase it if not */
+/* Returns LBA of the block if valid, -1 if free, and -2 if invalid */
+static int sm_check_block(struct sm_ftl *ftl, int zone, int block, int quick)
+{
+	int boffset;
+	struct sm_oob oob;
+	int first_lba = 0, test_lba;
+
+	for (boffset = 0; boffset < ftl->block_size;
+					boffset += SM_SECTOR_SIZE) {
+
+		/* This shoudn't happen anyway */
+		if (sm_read_sector_oob(ftl, zone, block, boffset, &oob))
+			return -2;
+
+		test_lba = sm_read_lba(&oob);
+
+		/* We have here bad LBA, we can ether erase the block,
+			or mark it as bad... */
+		if (test_lba == -2 || test_lba >= ftl->max_lba)
+			goto erase;
+
+		if (!boffset) {
+			first_lba = test_lba;
+			continue;
+		}
+
+		/* Found sector with different LBA that first.
+			Mostly likely result of partial write */
+		if (first_lba != test_lba)
+			goto erase;
+
+		if (quick)
+			continue;
+
+		if (sm_read_sector(ftl, zone, block, boffset, tmp_buffer))
+			goto erase;
+	}
+	return first_lba;
+erase:
+	if (!sm_erase_block(ftl, zone, block, 1))
+		return -1;
+	return -2;
+}
+
+/* Initialize FTL mapping for one zone */
+struct ftl_zone *sm_get_zone(struct sm_ftl *ftl, int zone_num)
+{
+	struct ftl_zone *zone;
+	u16 block;
+	int lba;
+	int i = 0;
+
+	BUG_ON(zone_num >= ftl->zone_count);
+	zone = &ftl->zones[zone_num];
+	if (zone->initialized)
+		return zone;
+
+	dbg("initializing zone %d", zone_num);
+
+	zone->lba_to_phys_table = kmalloc(ftl->max_lba * 2, GFP_KERNEL);
+
+	if (!zone->lba_to_phys_table)
+		return ERR_PTR(-ENOMEM);
+
+	if (kfifo_alloc(&zone->free_sectors, ftl->zone_size * 2, GFP_KERNEL)) {
+		kfree(zone->lba_to_phys_table);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memset(zone->lba_to_phys_table, -1, ftl->max_lba * 2);
+
+	for (block = 0 ; block < ftl->zone_size ; block++) {
+
+		/* Skip blocks till the CIS (including) */
+		if (zone_num == 0 && block <= ftl->cis_block)
+			continue;
+
+
+		/* If one of sectors is marked as bad, nothing to do */
+		if (sm_block_bad(ftl, zone_num, block))
+			continue;
+
+		lba = sm_check_block(ftl, zone_num, block, 1);
+		if (lba == -1) {
+			kfifo_in(&zone->free_sectors,
+				(unsigned char *)&block, 2);
+			continue;
+		}
+
+		/* This block is really bad,
+			and probably now is marked as such */
+		if (lba == -2)
+			continue;
+
+
+		/* If there is no collision,
+			just put the sector in the FTL table */
+		if (zone->lba_to_phys_table[lba] < 0) {
+			/*dbg("LBA %04d -> PH %04d", lba, block);*/
+			zone->lba_to_phys_table[lba] = block;
+			continue;
+		}
+
+		dbg("collision of LBA %d between blocks %d and %d in zone %d",
+			lba, zone->lba_to_phys_table[lba], block, zone_num);
+
+		/* Test carefully that this block is valid*/
+		if (sm_check_block(ftl, zone_num, block, 0) < 0)
+			continue;
+
+		/* Recheck carefilly that old block is valid */
+		if (sm_check_block(ftl, zone_num,
+				zone->lba_to_phys_table[lba], 0) < 0) {
+			zone->lba_to_phys_table[lba] = block;
+			continue;
+		}
+
+		/* Now both blocks are valid and share same LBA...
+		   I guess only solution is to throw a dice.... */
+		dbg("erasing the later");
+		sm_erase_block(ftl, zone_num, block, 1);
+	}
+
+	dbg("zone initialized");
+	zone->initialized = 1;
+
+	/* No free sectors, means that the zone is heavily damaged, write won't
+		work, but it can still can be (partially) read */
+	if (!kfifo_len(&zone->free_sectors)) {
+		dbg("no free blocks in zone %d", zone_num);
+		return zone;
+	}
+
+	/* Randomize first block we write to */
+	get_random_bytes(&i, 2);
+	i %= (kfifo_len(&zone->free_sectors) / 2);
+
+	while (i--) {
+		kfifo_out(&zone->free_sectors, (unsigned char *)&block, 2);
+		kfifo_in(&zone->free_sectors, (const unsigned char *)&block, 2);
+	}
+	return zone;
+}
+
+
+/********************* cache handling ****************************************/
+
+/* Initialize the one block cache */
+void sm_cache_init(struct sm_ftl *ftl)
+{
+	ftl->cache_data_invalid_bitmap = 0xFFFFFFFF;
+	ftl->cache_clean = 1;
+	ftl->cache_zone = -1;
+	ftl->cache_block = -1;
+	/*memset(ftl->cache_data, 0xAA, ftl->block_size);*/
+}
+
+/* Put sector in one block cache */
+void sm_cache_put(struct sm_ftl *ftl, char *buffer, int boffset)
+{
+	memcpy(ftl->cache_data + boffset, buffer, SM_SECTOR_SIZE);
+	clear_bit(boffset / SM_SECTOR_SIZE, &ftl->cache_data_invalid_bitmap);
+	ftl->cache_clean = 0;
+}
+
+/* Read a sector from the cache */
+int sm_cache_get(struct sm_ftl *ftl, char *buffer, int boffset)
+{
+	if (test_bit(boffset / SM_SECTOR_SIZE,
+		&ftl->cache_data_invalid_bitmap))
+			return -1;
+
+	memcpy(buffer, ftl->cache_data + boffset, SM_SECTOR_SIZE);
+	return 0;
+}
+
+/* Write the cache to hardware */
+int sm_cache_flush(struct sm_ftl *ftl)
+{
+	struct ftl_zone *zone;
+
+	int sector_num;
+	u16 write_sector;
+	int zone_num = ftl->cache_zone;
+	int block_num;
+
+	if (ftl->cache_clean)
+		return 0;
+
+	BUG_ON(zone_num < 0);
+	zone = &ftl->zones[zone_num];
+	block_num = zone->lba_to_phys_table[ftl->cache_block];
+
+
+	/* Read all unread areas of the cache block*/
+	for_each_bit(sector_num, &ftl->cache_data_invalid_bitmap,
+		ftl->block_size / SM_SECTOR_SIZE) {
+
+		if (sm_read_sector(ftl,
+			zone_num, block_num, sector_num * SM_SECTOR_SIZE,
+			ftl->cache_data + sector_num * SM_SECTOR_SIZE))
+			return -EIO;
+	}
+restart:
+	/* No spare blocks */
+	/* We could still continue by erasing the current block,
+		but for such worn out media it doesn't worth the trouble,
+			and the dangers */
+
+	if (!kfifo_len(&zone->free_sectors)) {
+		dbg("no free sectors for write!");
+		return -EIO;
+	}
+
+	kfifo_out(&zone->free_sectors, (unsigned char *)&write_sector, 2);
+
+	if (sm_write_block(ftl, ftl->cache_data, zone_num, write_sector,
+							ftl->cache_block))
+			goto restart;
+
+	/* Update the FTL table */
+	zone->lba_to_phys_table[ftl->cache_block] = write_sector;
+
+	/* Write succesfull, so erase and free the old block */
+	if (block_num > 0)
+		sm_erase_block(ftl, zone_num, block_num, 1);
+
+	sm_cache_init(ftl);
+	return 0;
+}
+
+
+/* flush timer, runs a second aftet last write */
+static void sm_cache_flush_timer(unsigned long data)
+{
+	struct sm_ftl *ftl = (struct sm_ftl *)data;
+	queue_work(cache_flush_workqueue, &ftl->flush_work);
+}
+
+/* cache flush work, kicked by timer */
+static void sm_cache_flush_work(struct work_struct *work)
+{
+	struct sm_ftl *ftl = container_of(work, struct sm_ftl, flush_work);
+	mutex_lock(&ftl->mutex);
+	sm_cache_flush(ftl);
+	mutex_unlock(&ftl->mutex);
+	return;
+}
+
+
+static const u8 cis_signature[] = {
+	0x01, 0x03, 0xD9, 0x01, 0xFF, 0x18, 0x02, 0xDF, 0x01, 0x20
+};
+
+/* Locate the CIS */
+static int sm_find_cis(struct sm_ftl *ftl)
+{
+	int block, boffset;
+
+	for (block = 0 ; block < ftl->zone_size - ftl->max_lba ; block++) {
+
+		boffset = sm_block_good_sector(ftl, 0, block);
+
+		if (boffset < 0)
+			continue;
+
+		if (sm_read_sector(ftl, 0, block, boffset, tmp_buffer))
+			break;
+
+		if (!memcmp(tmp_buffer, cis_signature, sizeof(cis_signature)))
+			goto found;
+
+		if (!memcmp(tmp_buffer + SM_SECTOR_SIZE / 2, cis_signature,
+							sizeof(cis_signature)))
+			goto found;
+
+		break;
+	}
+
+	if (force_load) {
+		dbg("WARNING: CIS block not found, "
+			"media is ether uncompatable or damaged");
+		ftl->cis_block = 0;
+		return 0;
+	}
+
+	return -EIO;
+found:
+	ftl->cis_block = block;
+	dbg("CIS block found at offset %d", block * ftl->block_size + boffset);
+	return 0;
+}
+
+/******************* outside interface ****************************************/
+
+/* outside interface: read a sector */
+static int sm_read(struct mtd_blktrans_dev *dev,
+				unsigned long sect_no, char *buf)
+{
+	struct sm_ftl *ftl = dev->priv;
+	struct ftl_zone *zone;
+	int error = 0, in_cache = 0;
+	int zone_num, block, boffset;
+
+	sm_break_offset(ftl, sect_no << 9, &zone_num, &block, &boffset);
+
+	zone = sm_get_zone(ftl, zone_num);
+	if (IS_ERR(zone))
+		return PTR_ERR(zone);
+
+	mutex_lock(&ftl->mutex);
+
+	/* Have to look at cache first */
+	if (ftl->cache_zone == zone_num && ftl->cache_block == block) {
+		in_cache = 1;
+		if (!sm_cache_get(ftl, buf, boffset))
+			return 0;
+	}
+
+	/* Translate the block and return if doesn't exist in the table */
+	block = zone->lba_to_phys_table[block];
+
+	if (block == -1) {
+		memset(buf, 0xFF, SM_SECTOR_SIZE);
+		goto unlock;
+	}
+
+	if (block == -2) {
+		error = -EIO;
+		goto unlock;
+	}
+
+	if (sm_read_sector(ftl, zone_num, block, boffset, buf)) {
+		error = -EIO;
+		goto unlock;
+	}
+
+	if (in_cache)
+		sm_cache_put(ftl, buf, boffset);
+unlock:
+	mutex_unlock(&ftl->mutex);
+	return error;
+}
+
+/* outside interface: write a sector */
+static int sm_write(struct mtd_blktrans_dev *dev,
+				unsigned long sec_no, char *buf)
+{
+	struct sm_ftl *ftl = dev->priv;
+	struct ftl_zone *zone;
+	int error, zone_num, block, boffset;
+
+	if (ftl->readonly)
+		return -EROFS;
+
+	sm_break_offset(ftl, sec_no << 9, &zone_num, &block, &boffset);
+
+	/* No need in flush thread running now */
+	del_timer(&ftl->timer);
+	mutex_lock(&ftl->mutex);
+
+	zone = sm_get_zone(ftl, zone_num);
+	if (IS_ERR(zone))
+		return PTR_ERR(zone);
+
+	/* If entry is not in cache, flush it */
+	if (ftl->cache_block != block || ftl->cache_zone != zone_num) {
+
+		error = sm_cache_flush(ftl);
+		if (error)
+			goto unlock;
+
+		ftl->cache_block = block;
+		ftl->cache_zone = zone_num;
+	}
+
+	sm_cache_put(ftl, buf, boffset);
+unlock:
+	mod_timer(&ftl->timer, jiffies + msecs_to_jiffies(cache_timeout));
+	mutex_unlock(&ftl->mutex);
+	return error;
+}
+
+/* outside interface: flush everything */
+static int sm_flush(struct mtd_blktrans_dev *dev)
+{
+	struct sm_ftl *ftl = dev->priv;
+	int retval;
+
+	mutex_lock(&ftl->mutex);
+	retval =  sm_cache_flush(ftl);
+	mutex_unlock(&ftl->mutex);
+	return retval;
+}
+
+/* outside interface: device is released */
+static int sm_release(struct mtd_blktrans_dev *dev)
+{
+	struct sm_ftl *ftl = dev->priv;
+
+	mutex_lock(&ftl->mutex);
+	del_timer_sync(&ftl->timer);
+	cancel_work_sync(&ftl->flush_work);
+	sm_cache_flush(ftl);
+	mutex_unlock(&ftl->mutex);
+	return 0;
+}
+
+/* outside interface: get geometry */
+static int sm_getgeo(struct mtd_blktrans_dev *dev, struct hd_geometry *geo)
+{
+	struct sm_ftl *ftl = dev->priv;
+	geo->heads = ftl->heads;
+	geo->sectors = ftl->sectors;
+	geo->cylinders = ftl->cylinders;
+	return 0;
+}
+
+/* external interface: main initialization function */
+static void sm_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
+{
+	struct mtd_blktrans_dev *trans;
+	struct sm_ftl *ftl;
+
+	/* Allocate & initialize our private structure */
+	ftl = kzalloc(sizeof(struct sm_ftl), GFP_KERNEL);
+	if (!ftl)
+		goto error1;
+
+	mutex_init(&ftl->mutex);
+	setup_timer(&ftl->timer, sm_cache_flush_timer, (unsigned long)ftl);
+	INIT_WORK(&ftl->flush_work, sm_cache_flush_work);
+	init_completion(&ftl->erase_completion);
+
+
+	/* Read media information */
+	if (sm_get_media_info(ftl, mtd))
+		goto error2;
+
+	/* Allocate zone array, it will be initialized on demand */
+	ftl->zones = kzalloc(sizeof(struct ftl_zone) * ftl->zone_count,
+								GFP_KERNEL);
+	if (!ftl->zones)
+		goto error2;
+
+	/* Allocate the cache*/
+	ftl->cache_data = kmalloc(ftl->block_size, GFP_KERNEL);
+
+	if (!ftl->cache_data)
+		goto error3;
+
+	sm_cache_init(ftl);
+
+	/* Allocate upper layer structure and initialize it */
+	trans = kzalloc(sizeof(struct mtd_blktrans_dev), GFP_KERNEL);
+	if (!trans)
+		goto error4;
+
+	ftl->trans = trans;
+	trans->priv = ftl;
+
+	trans->tr = tr;
+	trans->mtd = mtd;
+	trans->devnum = -1;
+	trans->size = (ftl->block_size * ftl->max_lba * ftl->zone_count) >> 9;
+	trans->readonly = ftl->readonly;
+
+	if (sm_find_cis(ftl))
+		goto error4;
+
+	/* Register device*/
+	if (add_mtd_blktrans_dev(trans))
+		goto error5;
+
+	dbg("Found %d MiB SmartMedia/xD card on %s",
+		(int)(mtd->size / (1024 * 1024)), mtd->name);
+
+	dbg("FTL layout:");
+	dbg("%d zones, each consists of %d blocks (+%d spares)",
+		ftl->zone_count, ftl->max_lba,
+		ftl->zone_size - ftl->max_lba);
+	dbg("each block consists of %d bytes",
+		ftl->block_size);
+
+	return;
+error5:
+	kfree(trans);
+error4:
+	kfree(ftl->cache_data);
+error3:
+	kfree(ftl->zones);
+error2:
+	kfree(ftl);
+error1:
+	return;
+}
+
+/* main interface: device {surprise,} removal */
+static void sm_remove_dev(struct mtd_blktrans_dev *dev)
+{
+	struct sm_ftl *ftl = dev->priv;
+	int i;
+
+	del_mtd_blktrans_dev(dev);
+
+	for (i = 0 ; i < ftl->zone_count; i++) {
+
+		if (!ftl->zones[i].initialized)
+			continue;
+
+		kfree(ftl->zones[i].lba_to_phys_table);
+		kfifo_free(&ftl->zones[i].free_sectors);
+	}
+
+	kfree(ftl->zones);
+	kfree(ftl->cache_data);
+	kfree(ftl);
+}
+
+static struct mtd_blktrans_ops sm_ftl_ops = {
+	.name		= "smblk",
+	.major		= -1,
+	.part_bits	= SM_FTL_PARTN_BITS,
+	.blksize	= SM_SECTOR_SIZE,
+	.getgeo		= sm_getgeo,
+
+	.add_mtd	= sm_add_mtd,
+	.remove_dev	= sm_remove_dev,
+
+	.readsect	= sm_read,
+	.writesect	= sm_write,
+
+	.flush		= sm_flush,
+	.release	= sm_release,
+
+	.owner		= THIS_MODULE,
+};
+
+static __init int sm_module_init(void)
+{
+	int error = 0;
+	cache_flush_workqueue = create_freezeable_workqueue("smflush");
+
+	if (IS_ERR(cache_flush_workqueue))
+		return PTR_ERR(cache_flush_workqueue);
+
+	error = register_mtd_blktrans(&sm_ftl_ops);
+	if (error)
+		destroy_workqueue(cache_flush_workqueue);
+
+	return error;
+
+}
+
+static void __exit sm_module_exit(void)
+{
+	destroy_workqueue(cache_flush_workqueue);
+	deregister_mtd_blktrans(&sm_ftl_ops);
+}
+
+module_init(sm_module_init);
+module_exit(sm_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
+MODULE_DESCRIPTION("Smartmedia/xD mtd translation layer");
diff --git a/drivers/mtd/sm_ftl.h b/drivers/mtd/sm_ftl.h
new file mode 100644
index 0000000..7b7722f
--- /dev/null
+++ b/drivers/mtd/sm_ftl.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2009 - Maxim Levitsky
+ * SmartMedia/xD translation layer
+ *
+ * Based loosly on ssfdc.c which is
+ *  (c) 2005 Eptar srl
+ *  Author: Claudio Lanconelli <lanconelli.claudio@eptar.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mtd/blktrans.h>
+#include <linux/kfifo.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+
+struct ftl_zone {
+	int initialized;
+	s16 *lba_to_phys_table;		/* LBA to physical table */
+	struct kfifo free_sectors;	/* queue of free sectors */
+};
+
+struct sm_ftl {
+	struct mtd_blktrans_dev *trans;
+
+	struct mutex mutex;		/* protects the structure */
+	struct ftl_zone *zones;		/* FTL tables for each zone */
+
+	/* Media information */
+	int block_size;			/* block size in bytes */
+	int zone_size;			/* zone size in blocks */
+	int zone_count;			/* number of zones */
+	int max_lba;			/* maximum lba in a zone */
+	int smallpagenand;		/* 256 bytes/page nand */
+	int readonly;			/* is FS readonly */
+	int cis_block;			/* CIS block location */
+
+	/* Cache */
+	int cache_block;		/* block number of cached block */
+	int cache_zone;			/* zone of cached block */
+	unsigned char *cache_data;	/* cached block data */
+	long unsigned int cache_data_invalid_bitmap;
+	int cache_clean;
+	struct work_struct flush_work;
+	struct timer_list timer;
+
+	/* Async erase stuff */
+	struct completion erase_completion;
+	int erase_error;
+
+	/* Geometry stuff */
+	int heads;
+	int sectors;
+	int cylinders;
+};
+
+struct chs_entry {
+	unsigned long size;
+	unsigned short cyl;
+	unsigned char head;
+	unsigned char sec;
+};
+
+
+#define SM_FTL_PARTN_BITS	3
+
+#define dbg(format, ...) \
+	printk(KERN_ERR "sm_ftl" ": " format "\n", ## __VA_ARGS__)
-- 
1.6.3.3



