Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0AHPMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0AHPMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643Ab0AHPMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:12:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46565 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0AHPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HFMryajixZ/YLHe35QNMfwtM+pS1kUivqjOm91bjEGyWoRzsk+KryT8XR5rRx6Ty5O
         1ysX7+1m1lmr/vk8wg+RbrSTI0HHZdvx+gFR/sdWejGqRc4pb/1qRvcHwuIyRMywry8F
         NA1Z0qL0zCAV63DVMkgCeTjC/GpQs89mZjFVE=
Subject: [PATCH 9/9] mtd: Add new SmartMedia/xD FTL
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
References: <1262963092.12577.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:12:04 +0200
Message-ID: <1262963524.12577.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 743f723b6e7134cf9d99a158f3ac920c180d406a Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 8 Jan 2010 16:44:07 +0200
Subject: [PATCH 9/9] mtd: Add new SmartMedia/xD FTL

This implements new readwrite SmartMedia/xd FTL.

It depends on nand driver to define proper oob layout that excludes
all ecc areas and nothing more.

Support for very old 256 byte/page devices is not yet enabled/complete.
For these devices, all ecc handling will be done inside this FTL
due to wierd oob layout.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/Kconfig  |   12 +
 drivers/mtd/Makefile |    1 +
 drivers/mtd/sm_ftl.c | 1043 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/sm_ftl.h |   75 ++++
 4 files changed, 1131 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/sm_ftl.c
 create mode 100644 drivers/mtd/sm_ftl.h

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index ebeabd6..e13bf41 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -313,6 +313,18 @@ config SSFDC
 	  This enables read only access to SmartMedia formatted NAND
 	  flash. You can mount it with FAT file system.
 
+
+config SM_FTL
+	tristate "SmartMedia/xD new translation layer"
+	depends on EXPERIMENTAL
+	select MTD_SM_COMMON
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
index 02c5b17..02f6375 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_NFTL)		+= nftl.o
 obj-$(CONFIG_INFTL)		+= inftl.o
 obj-$(CONFIG_RFD_FTL)		+= rfd_ftl.o
 obj-$(CONFIG_SSFDC)		+= ssfdc.o
+obj-$(CONFIG_SM_FTL)		+= sm_ftl.o
 obj-$(CONFIG_MTD_OOPS)		+= mtdoops.o
 
 nftl-objs		:= nftlcore.o nftlmount.o
diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
new file mode 100644
index 0000000..b72c30b
--- /dev/null
+++ b/drivers/mtd/sm_ftl.c
@@ -0,0 +1,1043 @@
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
+#include "sm_common.h"
+#include "sm_ftl.h"
+
+static u8 tmp_buffer[SM_SECTOR_SIZE];
+static int cache_size = 5;
+
+module_param(cache_size, int, S_IRUGO);
+MODULE_PARM_DESC(cache_size,
+		"Number of blocks to hold in the cache (5 default)");
+
+
+static void sm_erase_callback(struct erase_info *self);
+static void sm_erase_block(struct sm_ftl *ftl, int zone_num, s16 block,
+								int put_free);
+static void sm_mark_block_bad(struct sm_ftl *ftl, int zone_num, int block);
+static int sm_cache_flush_thread(void *data);
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
+		if (!mtd->writesize == SM_SMALL_PAGE) {
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
+
+	if (offset >= ftl->zone_count)
+		dbg("sm_break_offset: try to access a zone %lx",
+						(long unsigned int)offset);
+
+	*zone = offset >= ftl->zone_count ? -1 : offset;
+}
+
+/* Reads a sector + oob*/
+static int sm_read_sector(struct sm_ftl *ftl,
+		int zone, int block, int boffset,
+				u8 *buffer, struct sm_oob *oob)
+{
+	struct mtd_oob_ops ops;
+	struct sm_oob tmp_oob;
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int ret;
+	loff_t offset;
+
+	ops.len = SM_SECTOR_SIZE;
+	ops.datbuf = buffer;
+
+	if (!oob)
+		oob = &tmp_oob;
+
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooboffs = 0;
+	ops.ooblen = sizeof(struct sm_oob);
+	ops.oobbuf = (void *)oob;
+
+	/* FTL can contain -1 entries that are by default filled with bits */
+	if (block == -1) {
+
+		if (buffer)
+			memset(buffer, 0xFF, SM_SECTOR_SIZE);
+		memset(oob, 0xFF, sizeof(struct sm_oob));
+		return 0;
+	}
+
+	offset = sm_mkoffset(ftl, zone, block, boffset);
+	ret = mtd->read_oob(mtd, offset, &ops);
+
+	if (ret) {
+		return -EIO;
+		dbg("read of sector at 0x%lx failed with error %d",
+					(long unsigned int)offset, ret);
+	}
+
+	if (ops.oobretlen != sizeof(struct sm_oob)) {
+		dbg("read of sector at 0x%lx failed with wrong oob len %d",
+				(long unsigned int)offset, (int)ops.oobretlen);
+		return -EIO;
+	}
+
+	if (buffer && sm_sector_valid(oob)) {
+		dbg("read of sector at 0x%lxfailed because "
+			"it is marked as invalid",
+						(long unsigned int)offset);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/* Write a block using data and lba */
+static int sm_write_block(struct sm_ftl *ftl, u8 *buf,
+					int zone_num, int block, int lba)
+{
+	struct mtd_oob_ops ops;
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int boffset;
+	loff_t offset;
+	int retry;
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
+
+	ops.len = SM_SECTOR_SIZE;
+
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
+
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
+/*
+ * Erase a block within a zone
+ * If erase succedes, it updates free block fifo
+ */
+static void sm_erase_block(struct sm_ftl *ftl, int zone_num, s16 block,
+								int put_free)
+{
+	struct ftl_zone *zone = &ftl->zones[zone_num];
+	struct erase_info erase;
+	struct mtd_info *mtd = ftl->trans->mtd;
+
+	erase.mtd = ftl->trans->mtd;
+	erase.callback = sm_erase_callback;
+	erase.addr = sm_mkoffset(ftl, zone_num, block, 0);
+	erase.len = ftl->block_size;
+	erase.priv = (u_long)ftl;
+
+	if (zone_num == 0 && (block == ftl->cis_block || block == 0)) {
+		dbg("attempted to erase the CIS!");
+		return;
+	}
+
+	if (ftl->trans->mtd->erase(ftl->trans->mtd, &erase)) {
+		dbg("erase of block %d in zone %d failed in mtd->erase call",
+			block, zone_num);
+		goto error;
+	}
+
+	wait_for_completion(&ftl->erase_completion);
+
+	if (ftl->erase_error) {
+		dbg("erase of block %d in zone %d failed after wait",
+			block, zone_num);
+		goto error;
+	}
+
+	if (put_free)
+		kfifo_in(&zone->free_sectors, (const unsigned char *)&block, 2);
+	return;
+
+error:
+	sm_mark_block_bad(ftl, zone_num, block);
+	return;
+}
+
+static void sm_erase_callback(struct erase_info *self)
+{
+	struct sm_ftl *ftl = (struct sm_ftl *)self->priv;
+	ftl->erase_error = (self->state == MTD_ERASE_FAILED);
+	complete(&ftl->erase_completion);
+}
+
+
+/*
+ * Throughtly test that block is valid and belongs
+ * to specified LBA. Tries to erase it if not
+ */
+static int sm_check_block_lba(struct sm_ftl *ftl, int zone, int block, int lba)
+{
+	int boffset;
+	struct sm_oob oob;
+	int tmp;
+
+	for (boffset = 0; boffset < ftl->block_size;
+					boffset += SM_SECTOR_SIZE) {
+
+		if (sm_read_sector(ftl, zone, block, boffset, tmp_buffer,
+								&oob)) {
+			dbg("block check: fail in sector %d in zone %d",
+				block, zone);
+			goto erase;
+		}
+
+		if (sm_block_valid(&oob) || sm_sector_valid(&oob)) {
+			dbg("block check: block/sector status invalid"
+				" for sector %d in zone %d",
+				block, zone);
+			goto erase;
+		}
+
+		tmp = sm_read_lba(&oob);
+
+		if (tmp != lba) {
+			dbg("block check: block offset %d, we get "
+				"different LBA (%d), should get %d",
+				boffset, tmp, lba);
+			goto erase;
+		}
+	}
+	return 0;
+erase:
+	sm_erase_block(ftl, zone, block, 1);
+	return -EIO;
+}
+
+/* Mark whole block at offset 'offs' as bad.
+ */
+static void sm_mark_block_bad(struct sm_ftl *ftl, int zone_num, int block)
+{
+	struct mtd_oob_ops ops;
+	struct sm_oob oob;
+	int boffset;
+	int offset = sm_mkoffset(ftl, zone_num, block, 0);
+	struct mtd_info *mtd = ftl->trans->mtd;
+
+	dbg("marking block %d of zone %d as bad", block, zone_num);
+	memset(&oob, 0xFF, sizeof(oob));
+	oob.block_status = 0xF0;
+
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooboffs = 0;
+	ops.ooblen = sizeof(struct sm_oob);
+	ops.oobbuf = (void *)&oob;
+	ops.datbuf = NULL;
+
+	/* We aren't checking the return value, because we don't care */
+	for (boffset = 0; boffset < ftl->block_size; boffset += SM_SECTOR_SIZE)
+		mtd->write_oob(mtd, offset + boffset, &ops);
+}
+
+/* Initialize FTL mapping for one zone */
+struct ftl_zone *sm_initialize_zone(struct sm_ftl *ftl, int zone_num)
+{
+	struct sm_oob oob;
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
+		if (zone_num == 0 && block <= ftl->cis_block) {
+
+			if (block != ftl->cis_block)
+				dbg("skipping block %d because"
+					" it is before the CIS (%d)",
+						block, ftl->cis_block);
+			continue;
+		}
+
+		/* Not much that we can do with blocks without
+		 * even readable oob... - skip*/
+		/* Shouldn't happen though */
+		if (sm_read_sector(ftl, zone_num, block, 0, NULL, &oob)) {
+			dbg("skipping block %d because it's "
+				"oob was unreadable", block);
+			continue;
+		}
+
+		/* Blocks with 0xFFs in the oob area are assumed free -
+			add to free table*/
+		lba = sm_read_lba(&oob);
+		if (lba == -1) {
+			kfifo_in(&zone->free_sectors,
+				(unsigned char *)&block, 2);
+			continue;
+		}
+
+		/* Blocks that are marked as invalid aren't for sure usable */
+		/* If such block has correct LBA and no other block has it,
+			return errors on read */
+		if (sm_block_valid(&oob)) {
+			if (lba >= 0 && lba < ftl->max_lba)
+				zone->lba_to_phys_table[lba] = -2;
+			dbg("skipping block %d because it was marked bad",
+									block);
+			continue;
+		}
+
+		/* Try to erase blocks that have invalid LBA,
+			but marked as valid */
+		if (lba >= ftl->max_lba || lba == -2) {
+			dbg("erasing block %d because it has invalid LBA (%d)",
+				 block, lba);
+
+			sm_erase_block(ftl, zone_num, block, 1);
+			continue;
+		}
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
+		/* Otherwise, carefully see if one of them is invalid*/
+		if (sm_check_block_lba(ftl, zone_num, block, lba))
+			continue;
+
+		if (sm_check_block_lba(ftl, zone_num,
+				zone->lba_to_phys_table[lba], lba))
+			continue;
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
+	return zone;
+
+	/* Randomize first block we write to */
+	get_random_bytes(&i, 2);
+	i %= (kfifo_len(&zone->free_sectors) / 2);
+
+
+	while (i--) {
+		kfifo_out(&zone->free_sectors, (unsigned char *)&block, 2);
+		kfifo_in(&zone->free_sectors, (const unsigned char *)&block, 2);
+	}
+	return zone;
+}
+
+/* Write one cached block to hardware */
+int sm_cache_block_write(struct sm_ftl *ftl, struct cached_block *cache_entry)
+{
+	struct ftl_zone *zone;
+
+	int sector_num;
+	u16 write_sector;
+	int zone_num = cache_entry->zone;
+	int block_num;
+
+	BUG_ON(cache_entry->zone < 0);
+	zone = &ftl->zones[cache_entry->zone];
+	block_num = zone->lba_to_phys_table[cache_entry->lba];
+
+
+	/* Read all unread areas of the cache block*/
+	for_each_bit(sector_num, &cache_entry->data_invalid_bitmap,
+		ftl->block_size / SM_SECTOR_SIZE) {
+
+
+		if (sm_read_sector(ftl,
+			zone_num, block_num, sector_num * SM_SECTOR_SIZE,
+			cache_entry->data + sector_num * SM_SECTOR_SIZE, NULL))
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
+	if (sm_write_block(ftl, cache_entry->data, zone_num, write_sector,
+							cache_entry->lba))
+			goto restart;
+
+	/* Update the FTL table */
+	zone->lba_to_phys_table[cache_entry->lba] = write_sector;
+
+	/* Write succesfull, so erase and free the old block */
+	if (block_num > 0)
+		sm_erase_block(ftl, zone_num, block_num, 1);
+	return 0;
+}
+
+/* Initialize new/used cache entry */
+static int sm_cache_block_init(struct sm_ftl *ftl,
+				struct cached_block *cache_entry)
+{
+	if (!cache_entry->data)
+		cache_entry->data = kmalloc(ftl->block_size, GFP_KERNEL);
+
+	if (!cache_entry->data)
+		return -ENOMEM;
+
+	cache_entry->data_invalid_bitmap = 0xFFFFFFFF;
+	cache_entry->lba = -1;
+	cache_entry->zone = -1;
+	return 0;
+}
+
+/* Flushes write cache, have to be run with ->cache_lock held */
+static int __sm_cache_flush(struct sm_ftl *ftl)
+{
+	struct cached_block *cache_entry = NULL, *tmp_entry;
+	struct mtd_info *mtd = ftl->trans->mtd;
+	int error;
+
+	if (ftl->readonly)
+		return  -EROFS;
+
+	if (list_empty(&ftl->cache))
+		return 0;
+
+	list_for_each_entry_safe(cache_entry, tmp_entry, &ftl->cache,
+								list_member) {
+		/* Write should never fail, unless media is worn out */
+		if (sm_cache_block_write(ftl, cache_entry)) {
+			dbg("sm_ftl: failed to write block %d at zone %d",
+				(int)cache_entry->lba, cache_entry->zone);
+			ftl->readonly = 1;
+			return -EIO;
+		}
+
+		list_del(&cache_entry->list_member);
+		list_add(&cache_entry->list_member, &ftl->free_cache);
+
+		error = sm_cache_block_init(ftl, cache_entry);
+		if (error)
+			return error;
+	}
+	return 0;
+}
+
+
+/* Flushes the write cache */
+static int sm_cache_flush(struct sm_ftl *ftl)
+{
+	int retval;
+	mutex_lock(&ftl->cache_mutex);
+	retval = __sm_cache_flush(ftl);
+	mutex_unlock(&ftl->cache_mutex);
+	return retval;
+}
+
+/* Frees the write cache */
+static void sm_free_cache(struct sm_ftl *ftl)
+{
+	struct cached_block *cache_entry;
+
+	mutex_lock(&ftl->cache_mutex);
+	while (!list_empty(&ftl->free_cache)) {
+		cache_entry = list_first_entry(&ftl->free_cache,
+				struct cached_block, list_member);
+
+		kfree(cache_entry->data);
+		list_del(&cache_entry->list_member);
+		kfree(cache_entry);
+	}
+	mutex_unlock(&ftl->cache_mutex);
+}
+
+
+/* outside interface: open the device */
+static int sm_open(struct mtd_blktrans_dev *dev)
+{
+	struct sm_ftl *ftl = dev->priv;
+	ftl->flush_thread = kthread_run(sm_cache_flush_thread,
+				ftl, "smflush%d", dev->mtd->index);
+
+	if (IS_ERR(ftl->flush_thread))
+		return PTR_ERR(ftl->flush_thread);
+	return 0;
+}
+
+/* outside interface: read a sector */
+static int sm_read(struct mtd_blktrans_dev *dev,
+				unsigned long sect_no, char *buf)
+{
+	struct sm_ftl *ftl = dev->priv;
+	struct ftl_zone *zone;
+	struct cached_block *cache_entry = NULL;
+	int error = 0;
+	int cache_found = 0;
+
+	int zone_num, block, boffset;
+
+	sm_break_offset(ftl, sect_no << 9, &zone_num, &block, &boffset);
+
+	zone = sm_initialize_zone(ftl, zone_num);
+	if (IS_ERR(zone))
+		return PTR_ERR(zone);
+
+	mutex_lock(&ftl->cache_mutex);
+
+	/* Have to look at cache first */
+	list_for_each_entry(cache_entry, &ftl->cache, list_member)
+		if (cache_entry->zone == zone_num &&
+			cache_entry->lba == block &&
+
+			!test_bit(boffset / SM_SECTOR_SIZE,
+				&cache_entry->data_invalid_bitmap)) {
+
+			memcpy(buf, cache_entry->data + boffset,
+							SM_SECTOR_SIZE);
+			goto unlock;
+		}
+
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
+		dbg("read block %d of zone %d marked invalid in the ftl",
+							block, zone_num);
+		error = -EIO;
+		goto unlock;
+	}
+
+	/* Do the read. The below relies on proper ftl setup and underlying
+	  driver to check at least the ecc
+	*/
+	if (sm_read_sector(ftl, zone_num, block, boffset, buf, NULL)) {
+		error = -EIO;
+		goto unlock;
+	}
+
+	/* If we already have the cache entry, then add the data there, because
+		we will need it anyway..*/
+	if (cache_found) {
+		memcpy(cache_entry->data + boffset, buf, SM_SECTOR_SIZE);
+		clear_bit(boffset / SM_SECTOR_SIZE,
+				&cache_entry->data_invalid_bitmap);
+	}
+unlock:
+	mutex_unlock(&ftl->cache_mutex);
+	return error;
+}
+
+
+/* outside interface: write a sector */
+static int sm_write(struct mtd_blktrans_dev *dev,
+				unsigned long sec_no, char *buf)
+{
+	struct sm_ftl *ftl = dev->priv;
+	struct ftl_zone *zone;
+	struct cached_block *cache_entry = NULL;
+	int error;
+	int zone_num, block, boffset;
+	int cache_found = 0;
+
+	if (ftl->readonly)
+		return -EROFS;
+
+	/* Try to write the cache if possible */
+	mutex_lock(&ftl->cache_mutex);
+
+	sm_break_offset(ftl, sec_no << 9, &zone_num, &block, &boffset);
+
+	zone = sm_initialize_zone(ftl, zone_num);
+	if (IS_ERR(zone))
+		return PTR_ERR(zone);
+
+
+	/* Try to find existing cache entry */
+	list_for_each_entry(cache_entry, &ftl->cache, list_member)
+		if (cache_entry->zone == zone_num &&
+				cache_entry->lba == block) {
+			cache_found = 1;
+			break;
+		}
+
+	/* Entry not in the cache, create new cache entry */
+	if (!cache_found) {
+
+		/* Flush the cache if full */
+		if (list_empty(&ftl->free_cache)) {
+
+			error = __sm_cache_flush(ftl);
+
+			if (error)
+				goto unlock;
+		}
+
+		BUG_ON(list_empty(&ftl->free_cache));
+
+		cache_entry = list_first_entry(&ftl->free_cache,
+			struct cached_block, list_member);
+
+		cache_entry->lba = block;
+		cache_entry->zone = zone_num;
+
+		list_del(&cache_entry->list_member);
+		list_add(&cache_entry->list_member, &ftl->cache);
+	}
+
+	/* And finally put data there */
+	memcpy(cache_entry->data + boffset, buf, SM_SECTOR_SIZE);
+	clear_bit(boffset / SM_SECTOR_SIZE, &cache_entry->data_invalid_bitmap);
+unlock:
+	mutex_unlock(&ftl->cache_mutex);
+	return error;
+}
+
+/* outside interface: flush everything */
+static int sm_flush(struct mtd_blktrans_dev *dev)
+{
+	struct sm_ftl *ftl = dev->priv;
+	return sm_cache_flush(ftl);
+}
+
+/* outside interface: last user has quit using the device,
+						also called on removal */
+static int sm_release(struct mtd_blktrans_dev *dev)
+{
+	struct sm_ftl *ftl = dev->priv;
+	sm_cache_flush(ftl);
+	kthread_stop(ftl->flush_thread);
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
+
+/* Periodic cache flush thread */
+static int sm_cache_flush_thread(void *data)
+{
+	struct sm_ftl *ftl = (struct sm_ftl *)data;
+
+	set_freezable();
+	while (!kthread_should_stop()) {
+
+		try_to_freeze();
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(500));
+		sm_cache_flush(ftl);
+	}
+
+	return 0;
+}
+
+static const u8 cis_signature[] = {
+	0x01, 0x03, 0xD9, 0x01, 0xFF, 0x18, 0x02, 0xDF, 0x01, 0x20
+};
+
+/* Locate the CIS */
+static int sm_find_cis(struct sm_ftl *ftl)
+{
+	int block, boffset;
+	struct sm_oob oob;
+	int block_found = 0;
+
+
+	/* Scan for first valid block */
+	for (block = 0 ; block < ftl->zone_size - ftl->max_lba ; block++) {
+		if (sm_read_sector(ftl, 0, block, 0, NULL, &oob))
+			continue;
+
+		if (sm_block_valid(&oob))
+			continue;
+
+		block_found = 1;
+		break;
+	}
+
+	if (!block_found)
+		return -EIO;
+
+	/* Block might be still partially damaged, so scan for first valid
+		sector */
+	for (boffset = 0 ; boffset < ftl->block_size;
+					boffset += SM_SECTOR_SIZE) {
+
+		if (sm_read_sector(ftl, 0, block, boffset, tmp_buffer, &oob))
+			continue;
+
+		if (!memcmp(tmp_buffer, cis_signature, sizeof(cis_signature)))
+			goto found;
+
+		if (!memcmp(tmp_buffer + SM_SECTOR_SIZE / 2, cis_signature,
+							sizeof(cis_signature)))
+			goto found;
+		return -EIO;
+	}
+found:
+	ftl->cis_block = block;
+	dbg("CIS block found at offset %d", block * ftl->block_size + boffset);
+	return 0;
+}
+
+/* external interface: main initialization function */
+static void sm_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
+{
+	struct mtd_blktrans_dev *trans;
+	struct sm_ftl *ftl;
+	int i;
+	struct cached_block *cache_entry;
+
+
+	/* Allocate & initialize our private structure */
+	ftl = kzalloc(sizeof(struct sm_ftl), GFP_KERNEL);
+	if (!ftl)
+		goto error1;
+
+	INIT_LIST_HEAD(&ftl->cache);
+	INIT_LIST_HEAD(&ftl->free_cache);
+	mutex_init(&ftl->cache_mutex);
+	init_completion(&ftl->erase_completion);
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
+	/* Allocate write cache */
+	INIT_LIST_HEAD(&ftl->cache);
+	INIT_LIST_HEAD(&ftl->free_cache);
+
+	for (i = 0 ; i < cache_size ; i++) {
+		cache_entry = kzalloc(sizeof(struct cached_block),
+								GFP_KERNEL);
+		if (!cache_entry)
+			break;
+
+		if (sm_cache_block_init(ftl, cache_entry)) {
+			kfree(cache_entry);
+			break;
+		}
+		list_add(&cache_entry->list_member, &ftl->free_cache);
+	}
+
+	if (list_empty(&ftl->free_cache))
+		goto error3;
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
+	sm_free_cache(ftl);
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
+	dbg("removing the ftl device");
+	del_mtd_blktrans_dev(dev);
+	kfree(ftl->zones);
+	sm_free_cache(ftl);
+	kfree(ftl); /* WE free that here, but the ->release can still
+			be called after ..... fuck */
+}
+
+static struct mtd_blktrans_ops sm_ftl_ops = {
+	.name		= "smblk",
+	.major		= -1,
+	.part_bits	= SM_FTL_PARTN_BITS,
+	.blksize	= SM_SECTOR_SIZE,
+	.getgeo		= sm_getgeo,
+	.readsect	= sm_read,
+	.writesect	= sm_write,
+	.add_mtd	= sm_add_mtd,
+	.remove_dev	= sm_remove_dev,
+	.open 		= sm_open,
+	.release	= sm_release,
+	.flush		= sm_flush,
+	.owner		= THIS_MODULE,
+};
+
+static __init int sm_module_init(void)
+{
+	return register_mtd_blktrans(&sm_ftl_ops);
+}
+
+static void __exit sm_module_exit(void)
+{
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
index 0000000..d86d00e
--- /dev/null
+++ b/drivers/mtd/sm_ftl.h
@@ -0,0 +1,75 @@
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
+#include <linux/mtd/nand.h>
+#include <linux/mtd/blktrans.h>
+#include <linux/list.h>
+#include <linux/kfifo.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+
+
+struct ftl_zone {
+	int initialized;
+	s16 *lba_to_phys_table;		/* LBA to physical table */
+	struct kfifo free_sectors;	/* queue of free sectors */
+};
+
+struct cached_block {
+	int zone;
+	unsigned long lba;
+	unsigned char *data;
+	long unsigned int data_invalid_bitmap;
+	struct list_head list_member;
+};
+
+struct sm_ftl {
+	struct mtd_blktrans_dev *trans;
+	struct ftl_zone *zones;
+	struct list_head cache;
+	struct list_head free_cache;
+	struct mutex cache_mutex;
+	struct completion erase_completion;
+	struct task_struct *flush_thread;
+	int erase_error;
+
+	int block_size;		/* block size in bytes */
+	int zone_size;		/* zone size in blocks */
+	int zone_count;		/* number of zones */
+	int max_lba;		/* maximum lba in a zone */
+	int smallpagenand;	/* 256 bytes/page nand */
+
+	int readonly;
+
+	/* geometry stuff */
+	int heads;
+	int sectors;
+	int cylinders;
+
+	/*Misc */
+	int cis_block;
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



