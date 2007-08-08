Return-Path: <linux-kernel-owner+w=401wt.eu-S936305AbXHHQ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936305AbXHHQ0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936227AbXHHQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:24:49 -0400
Received: from lazybastard.de ([212.112.238.170]:42398 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936208AbXHHQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:24:46 -0400
Date: Wed, 8 Aug 2007 18:20:50 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 12/18] fs/logfs/segment.c
Message-ID: <20070808162050.GN15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/segment.c	2007-08-08 03:09:41.000000000 +0200
@@ -0,0 +1,602 @@
+/*
+ * fs/logfs/segment.c	- Handling the Object Store
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ *
+ * Object store or ostore makes up the complete device with exception of
+ * the superblock and journal areas.  Apart from its own metadata it stores
+ * three kinds of objects: inodes, dentries and blocks, both data and indirect.
+ */
+#include "logfs.h"
+
+int logfs_erase_segment(struct super_block *sb, u32 index)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	super->s_gec++;
+
+	super->s_devops->sync(sb);
+	return super->s_devops->erase(sb, (u64)index << super->s_segshift,
+			super->s_segsize);
+}
+
+static s64 logfs_get_free_bytes(struct logfs_area *area, size_t bytes)
+{
+	s32 ofs;
+	int ret;
+
+	ret = logfs_open_area(area);
+	BUG_ON(ret>0);
+	if (ret)
+		return ret;
+
+	ofs = area->a_used_bytes;
+	area->a_used_bytes += bytes;
+	BUG_ON(area->a_used_bytes >= logfs_super(area->a_sb)->s_segsize);
+
+	return dev_ofs(area->a_sb, area->a_segno, ofs);
+}
+
+static void __logfs_set_blocks(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_inode *li = logfs_inode(inode);
+
+	inode->i_blocks = ULONG_MAX;
+	if (li->li_used_bytes >> sb->s_blocksize_bits < ULONG_MAX)
+		inode->i_blocks = ALIGN(li->li_used_bytes, 512) >> 9;
+}
+
+void logfs_set_blocks(struct inode *inode, u64 bytes)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	li->li_used_bytes = bytes;
+	__logfs_set_blocks(inode);
+}
+
+static void logfs_consume_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	struct logfs_inode *li = logfs_inode(inode);
+
+	BUG_ON(li->li_used_bytes + bytes < bytes);
+	super->s_free_bytes	-= bytes;
+	super->s_used_bytes	+= bytes;
+	li->li_used_bytes	+= bytes;
+	__logfs_set_blocks(inode);
+}
+
+static void logfs_remove_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	struct logfs_inode *li = logfs_inode(inode);
+
+	BUG_ON(li->li_used_bytes < bytes);
+	super->s_free_bytes	+= bytes;
+	super->s_used_bytes	-= bytes;
+	li->li_used_bytes	-= bytes;
+	__logfs_set_blocks(inode);
+}
+
+void logfs_buf_write(struct logfs_area *area, u64 ofs, void *data, size_t len)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = logfs_super(sb);
+	long write_mask = super->s_writesize - 1;
+	u64 buf_start;
+	size_t space, buf_ofs;
+
+	buf_ofs = (long)ofs & write_mask;
+	if (buf_ofs) {
+		/* buf already used - fill it */
+		space = super->s_writesize - buf_ofs;
+		if (len < space) {
+			/* not enough to fill it - just copy */
+			memcpy(area->a_wbuf + buf_ofs, data, len);
+			return;
+		}
+		/* enough data to fill and flush the buffer */
+		memcpy(area->a_wbuf + buf_ofs, data, space);
+		buf_start = ofs & ~write_mask;
+		super->s_devops->write(sb, buf_start, super->s_writesize, area->a_wbuf);
+		ofs += space;
+		data += space;
+		len -= space;
+	}
+
+	/* write complete hunks */
+	space = len & ~write_mask;
+	if (space) {
+		super->s_devops->write(sb, ofs, space, data);
+		ofs += space;
+		data += space;
+		len -= space;
+	}
+
+	/* store anything remaining in wbuf */
+	if (len)
+		memcpy(area->a_wbuf, data, len);
+}
+
+static struct logfs_area *get_area(struct super_block *sb, int level)
+{
+	return logfs_super(sb)->s_area[level];
+}
+
+static s64 __logfs_segment_write(struct inode *inode, void *buf, u64 pos,
+		int level, int alloc, int len, int compr)
+{
+	struct logfs_area *area;
+	struct super_block *sb = inode->i_sb;
+	s64 ofs;
+	struct logfs_object_header h;
+
+	h.len	= cpu_to_be16(len);
+	h.type	= OBJ_BLOCK;
+	h.compr	= compr;
+	h.ino	= cpu_to_be64(inode->i_ino);
+	h.pos	= cpu_to_be64(pos);
+	h.crc	= logfs_crc32(&h, sizeof(h) - 4, 4);
+	h.data_crc = logfs_crc32(buf, len, 0);
+
+	area = get_area(sb, level);
+	ofs = logfs_get_free_bytes(area, len + LOGFS_HEADERSIZE);
+	LOGFS_BUG_ON(ofs <= 0, sb);
+
+	logfs_buf_write(area, ofs, &h, sizeof(h));
+	logfs_buf_write(area, ofs + LOGFS_HEADERSIZE, buf, len);
+	if (alloc) {
+		int acc_len = (level==0) ? len : sb->s_blocksize;
+		logfs_consume_bytes(inode, acc_len + LOGFS_HEADERSIZE);
+	}
+
+	/* FIXME merge with open_area */
+	logfs_close_area(area);
+
+	return ofs;
+}
+
+static s64 logfs_segment_write_compress(struct inode *inode, void *buf, u64 pos,
+		int level, int alloc)
+{
+	struct super_block *sb = inode->i_sb;
+	void *compressor_buf = logfs_super(sb)->s_compressed_je;
+	int bs = sb->s_blocksize;
+	size_t compr_len;
+	s64 ofs;
+
+	mutex_lock(&logfs_super(sb)->s_journal_mutex);
+	compr_len = logfs_compress(buf, compressor_buf, bs, bs);
+
+	if (compr_len >= 0) {
+		ofs = __logfs_segment_write(inode, compressor_buf, pos, level,
+				alloc, compr_len, COMPR_ZLIB);
+	} else {
+		ofs = __logfs_segment_write(inode, buf, pos, level, alloc, bs,
+				COMPR_NONE);
+	}
+	mutex_unlock(&logfs_super(sb)->s_journal_mutex);
+	return ofs;
+}
+
+static int adj_level(u64 ino, int level)
+{
+	BUG_ON(level >= LOGFS_MAX_LEVELS);
+
+	if (ino == LOGFS_INO_MASTER) {
+		/* ifile has seperate areas */
+		level += LOGFS_MAX_LEVELS;
+	}
+	return level;
+}
+
+s64 logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
+		int alloc)
+{
+	struct super_block *sb = inode->i_sb;
+	int bs = sb->s_blocksize;
+	int do_compress;
+	s64 ofs;
+
+	level = adj_level(inode->i_ino, level);
+
+	do_compress = logfs_inode(inode)->li_flags & LOGFS_IF_COMPRESSED;
+	if (level != 0) {
+		/* temporarily disable compression for indirect blocks */
+		do_compress = 0;
+	}
+
+	if (do_compress)
+		ofs = logfs_segment_write_compress(inode, buf, pos, level,
+				alloc);
+	else
+		ofs = __logfs_segment_write(inode, buf, pos, level, alloc, bs,
+				COMPR_NONE);
+
+	/* this BUG_ON did catch a locking bug.  useful */
+	BUG_ON(!(ofs & (logfs_super(sb)->s_segsize - 1)));
+	return ofs;
+}
+
+/* FIXME: all this mess should get replaced by using the page cache */
+static void fixup_from_wbuf(struct super_block *sb, struct logfs_area *area,
+		void *read, u64 ofs, size_t readlen)
+{
+	struct logfs_super *super = logfs_super(sb);
+	u32 read_start = ofs & (super->s_segsize - 1);
+	u32 read_end = read_start + readlen;
+	u32 writemask = super->s_writesize - 1;
+	u32 buf_start = area->a_used_bytes & ~writemask;
+	u32 buf_end = area->a_used_bytes;
+	void *buf = area->a_wbuf;
+	size_t buflen = buf_end - buf_start;
+
+	if (read_end < buf_start)
+		return;
+	if ((ofs & (super->s_segsize - 1)) >= area->a_used_bytes) {
+		memset(read, 0xff, readlen);
+		return;
+	}
+
+	if (buf_start > read_start) {
+		read += buf_start - read_start;
+		readlen -= buf_start - read_start;
+	} else {
+		buf += read_start - buf_start;
+		buflen -= read_start - buf_start;
+	}
+	memcpy(read, buf, min(readlen, buflen));
+	if (buflen < readlen)
+		memset(read + buflen, 0xff, readlen - buflen);
+}
+
+int wbuf_read(struct super_block *sb, u64 ofs, size_t len, void *buf)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_area *area;
+	u32 segno = ofs >> super->s_segshift;
+	int i, err;
+
+	err = super->s_devops->read(sb, ofs, len, buf);
+	if (err)
+		return err;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = super->s_area[i];
+		if (area->a_segno == segno) {
+			fixup_from_wbuf(sb, area, buf, ofs, len);
+			break;
+		}
+	}
+	return 0;
+}
+
+static u64 logfs_block_mask[] = {
+	~0,
+	~(I1_BLOCKS-1),
+	~(I2_BLOCKS-1),
+	~(I3_BLOCKS-1)
+};
+
+/*
+ * The "position" of indirect blocks is ambiguous.  It can be the position
+ * of any data block somewhere behind this indirect block.  So we need to
+ * normalize the positions through logfs_block_mask[level] before comparing.
+ */
+static int check_pos(struct super_block *sb, u64 pos1, u64 pos2, int level)
+{
+	return	(pos1 & logfs_block_mask[level]) !=
+		(pos2 & logfs_block_mask[level]);
+}
+
+int logfs_segment_read(struct inode *inode, void *buf, u64 ofs, u64 pos,
+		u8 level)
+{
+	struct super_block *sb = inode->i_sb;
+	void *compressor_buf = logfs_super(sb)->s_compressed_je;
+	struct logfs_object_header h;
+	__be32 crc;
+	u16 len;
+	int err, bs = sb->s_blocksize;
+
+	err = wbuf_read(sb, ofs, LOGFS_HEADERSIZE, &h);
+	if (err)
+		goto out_err;
+	err = -EIO;
+	crc = logfs_crc32(&h, sizeof(h) - 4, 4);
+	if (crc != h.crc) {
+		printk(KERN_ERR"LOGFS: header crc error at %llx: expected %x, "
+				"got %x\n", ofs, be32_to_cpu(h.crc),
+				be32_to_cpu(crc));
+		goto out_err;
+	}
+
+	if (be64_to_cpu(h.ino) != inode->i_ino
+			|| check_pos(sb, be64_to_cpu(h.pos), pos, level)) {
+		printk(KERN_ERR"LOGFS: (ino, pos) don't match at %llx: "
+				"expected (%lx, %llx), got %llx, %llx)\n",
+				ofs, inode->i_ino, pos,
+				be64_to_cpu(h.ino), be64_to_cpu(h.pos));
+		goto out_err;
+	}
+
+	len = be16_to_cpu(h.len);
+
+	switch (h.compr) {
+	case COMPR_NONE:
+		err = wbuf_read(sb, ofs + LOGFS_HEADERSIZE, len, buf);
+		if (err)
+			goto out_err;
+		crc = logfs_crc32(buf, len, 0);
+		if (crc != h.data_crc) {
+			printk(KERN_ERR"LOGFS: uncompressed data crc error at "
+					"%llx: expected %x, got %x\n", ofs,
+					be32_to_cpu(h.data_crc),
+					be32_to_cpu(crc));
+			goto out_err;
+		}
+		break;
+	case COMPR_ZLIB:
+		mutex_lock(&logfs_super(sb)->s_journal_mutex);
+		err = wbuf_read(sb, ofs + LOGFS_HEADERSIZE, len,compressor_buf);
+		if (err) {
+			mutex_unlock(&logfs_super(sb)->s_journal_mutex);
+			goto out_err;
+		}
+		crc = logfs_crc32(compressor_buf, len, 0);
+		if (crc != h.data_crc) {
+			printk(KERN_ERR"LOGFS: compressed data crc error at "
+					"%llx: expected %x, got %x\n", ofs,
+					be32_to_cpu(h.data_crc),
+					be32_to_cpu(crc));
+			mutex_unlock(&logfs_super(sb)->s_journal_mutex);
+			goto out_err;
+		}
+		err = logfs_uncompress(compressor_buf, buf, len, bs);
+		mutex_unlock(&logfs_super(sb)->s_journal_mutex);
+		if (err) {
+			printk(KERN_ERR"LOGFS: uncompress error at %llx\n",ofs);
+			goto out_err;
+		}
+		break;
+	default:
+		LOGFS_BUG(sb);
+		err = -EIO;
+	}
+	return 0;
+
+out_err:
+	LOGFS_BUG(sb);
+	return err;
+}
+
+int logfs_segment_delete(struct inode *inode, u64 ofs, u64 pos, int level)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_object_header h;
+	u16 len;
+	int err;
+
+
+	err = wbuf_read(sb, ofs, sizeof(h), &h);
+	LOGFS_BUG_ON(err, sb);
+	len = be16_to_cpu(h.len);
+	LOGFS_BUG_ON(check_pos(sb, pos, be64_to_cpu(h.pos), level), sb);
+
+	level = adj_level(inode->i_ino, level);
+	len = (level==0) ? len : sb->s_blocksize;
+	logfs_remove_bytes(inode, len + sizeof(h));
+	return 0;
+}
+
+static int logfs_mark_segment_bad(struct super_block *sb, u32 segno)
+{
+	struct btree_head *head = &logfs_super(sb)->s_reserved_segments;
+	int err;
+
+	err = btree_insert(head, segno, (void*)1);
+	if (err)
+		return err;
+	logfs_super(sb)->s_bad_segments++;
+	/* FIXME: write to journal */
+	return 0;
+}
+
+int logfs_open_area(struct logfs_area *area)
+{
+	size_t writesize = logfs_super(area->a_sb)->s_writesize;
+	int err;
+
+	if (area->a_is_open)
+		return 0;
+
+again:
+	area->a_ops->get_free_segment(area);
+	area->a_used_bytes = 0;
+	area->a_ops->get_erase_count(area);
+
+	if (area->a_wbuf)
+		memset(area->a_wbuf, 0, writesize);
+	area->a_is_open = 1;
+
+	err = area->a_ops->erase_segment(area);
+	if (unlikely(err)) {
+		printk(KERN_WARNING "LogFS: Error erasing segment %x\n",
+				area->a_segno);
+		logfs_mark_segment_bad(area->a_sb, area->a_segno);
+		goto again;
+	}
+	return 0;
+}
+
+void logfs_close_area(struct logfs_area *area)
+{
+	if (!area->a_is_open)
+		return;
+
+	area->a_ops->finish_area(area);
+}
+
+/*
+ * Pick a free segment to be used for this area.  Effectively takes a
+ * candidate from the free list (not really a candidate anymore).
+ */
+static void ostore_get_free_segment(struct logfs_area *area)
+{
+	struct logfs_super *super = logfs_super(area->a_sb);
+	struct gc_candidate *cand;
+
+	BUG_ON(list_empty(&super->s_free_list));
+
+	cand = list_entry(super->s_free_list.prev, struct gc_candidate, list);
+	list_del(&cand->list);
+	area->a_segno = cand->segno;
+	kfree(cand);
+	super->s_free_count -= 1;
+	if (super->s_free_count < 5)
+		pr_debug("use segment #%02x, %2x remaining\n", area->a_segno,
+				super->s_free_count);
+}
+
+static void ostore_get_erase_count(struct logfs_area *area)
+{
+	struct logfs_segment_header h;
+	int err;
+
+	err = device_read(area->a_sb, area->a_segno, 0, sizeof(h), &h);
+	BUG_ON(err);
+	area->a_erase_count = be32_to_cpu(h.ec) + 1;
+}
+
+static int ostore_erase_segment(struct logfs_area *area)
+{
+	struct logfs_segment_header h;
+	u64 ofs;
+	int err;
+
+	err = logfs_erase_segment(area->a_sb, area->a_segno);
+	if (err)
+		return err;
+
+	h.pad = 0;
+	h.type = OBJ_OSTORE;
+	h.level = area->a_level;
+	h.segno = cpu_to_be32(area->a_segno);
+	h.ec = cpu_to_be32(area->a_erase_count);
+	h.gec = cpu_to_be64(logfs_super(area->a_sb)->s_gec);
+	h.crc = logfs_crc32(&h, sizeof(h), 4);
+
+	ofs = dev_ofs(area->a_sb, area->a_segno, 0);
+	area->a_used_bytes = sizeof(h);
+	logfs_buf_write(area, ofs, &h, sizeof(h));
+	return 0;
+}
+
+static void flush_buf(struct logfs_area *area)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = logfs_super(sb);
+	u32 used, free;
+	u64 ofs;
+	u32 writemask = super->s_writesize - 1;
+	int err;
+
+	ofs = dev_ofs(sb, area->a_segno, area->a_used_bytes);
+	ofs &= ~writemask;
+	used = area->a_used_bytes & writemask;
+	free = super->s_writesize - area->a_used_bytes;
+	free &= writemask;
+	if (used == 0)
+		return;
+
+	memset(area->a_wbuf + used, 0xff, free);
+	err = super->s_devops->write(sb, ofs, super->s_writesize, area->a_wbuf);
+	LOGFS_BUG_ON(err, sb);
+}
+
+static void ostore_finish_area(struct logfs_area *area)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = logfs_super(sb);
+	u32 remaining = super->s_segsize - area->a_used_bytes;
+	u32 needed = sb->s_blocksize + sizeof(struct logfs_segment_header);
+
+	if (remaining > needed)
+		return;
+
+	flush_buf(area);
+
+	area->a_segno = 0;
+	area->a_is_open = 0;
+}
+
+static const struct logfs_area_ops ostore_area_ops = {
+	.get_free_segment	= ostore_get_free_segment,
+	.get_erase_count	= ostore_get_erase_count,
+	.erase_segment		= ostore_erase_segment,
+	.finish_area		= ostore_finish_area,
+};
+
+static void free_area(struct logfs_area *area)
+{
+	if (area)
+		kfree(area->a_wbuf);
+	kfree(area);
+}
+
+static struct logfs_area *alloc_area(struct super_block *sb)
+{
+	struct logfs_area *area;
+	size_t writesize = logfs_super(sb)->s_writesize;
+
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
+	if (!area)
+		return NULL;
+
+	area->a_sb = sb;
+	if (writesize > 1) {
+		area->a_wbuf = kmalloc(writesize, GFP_KERNEL);
+		if (!area->a_wbuf) {
+			kfree(area);
+			return NULL;
+		}
+	}
+	return area;
+}
+
+int logfs_init_areas(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	super->s_journal_area = alloc_area(sb);
+	if (!super->s_journal_area)
+		return -ENOMEM;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		super->s_area[i] = alloc_area(sb);
+		if (!super->s_area[i])
+			goto err;
+		super->s_area[i]->a_level = i;
+		super->s_area[i]->a_ops = &ostore_area_ops;
+	}
+	return 0;
+
+err:
+	for (i--; i>=0; i--)
+		free_area(super->s_area[i]);
+	free_area(super->s_journal_area);
+	return -ENOMEM;
+}
+
+void logfs_cleanup_areas(struct logfs_super *super)
+{
+	int i;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++)
+		free_area(super->s_area[i]);
+	kfree(super->s_journal_area);
+}
