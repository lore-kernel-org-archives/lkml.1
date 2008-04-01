Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYDCRMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYDCRMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYDCRKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:10:41 -0400
Received: from lazybastard.de ([212.112.238.170]:43599 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026AbYDCRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:33 -0400
Message-Id: <20080401181332.853833007@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 7/15] fs/logfs/gc.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-03-30 12:15:48.586669308 +0200
+++ linux-2.6.24logfs/fs/logfs/gc.c	2008-04-01 19:48:36.066470483 +0200
@@ -0,0 +1,729 @@
+/*
+ * fs/logfs/gc.c	- garbage collection code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ *
+ * GC design as it should be (and isn't, as of 15.3.07):
+ * 1. Pick a good candidate for GC, constrained by the number of currently
+ *    free segments.
+ * 2. Move all valid blocks in this segment until
+ *   a) they are all gone, or
+ *   b) the number of currently free segments drops too low.
+ * 3. Mark the segment as GC-pending or so, because not all indirect blocks
+ *    have been written yet.
+ * 4. Either
+ *   a) goto 1. or
+ *   b) write dirty indirect blocks directly
+ *
+ * Sooner or later 4b) should be taken, causing a number of segments to be
+ * freed.  2b) will consume free segments until this point is reached.  Overall
+ * progress will be made, even though less than a full segment may be gained.
+ *
+ * Crucial question is when to choose 4b) over 4a.
+ */
+#include "logfs.h"
+#include <linux/sched.h>
+
+#define SCAN_RATIO 16	/* number of scanned segments per gc'd segment */
+#define LIST_SIZE 16	/* base size of candidate lists */
+#define SCAN_ROUNDS 128	/* maximum number of complete medium scans */
+#define SCAN_ROUNDS_HIGH 4 /* maximum number of higher-level scans */
+
+static void __logfs_gc_pass(struct super_block *sb, int target);
+
+/* journal has distance -1, top-most ifile layer distance 0 */
+static u8 root_distance(struct super_block *sb, u8 level)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	switch (level) {
+	case 0: /* fall through */
+	case 1: /* fall through */
+	case 2: /* fall through */
+	case 3:
+		/* file data or indirect blocks */
+		return super->s_ifile_levels + super->s_iblock_levels - level;
+	case 6: /* fall through */
+	case 7: /* fall through */
+	case 8: /* fall through */
+	case 9:
+		/* inode file data or indirect blocks */
+		return super->s_ifile_levels - (level-6);
+	default:
+		printk(KERN_ERR"LOGFS: segment of unknown level %x found\n",
+				level);
+		WARN_ON(1);
+		return super->s_ifile_levels + super->s_iblock_levels;
+	}
+}
+
+int logfs_safe_to_write_block(struct super_block *sb, u8 level)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	return root_distance(sb, level) <= super->s_free_list.count;
+}
+
+static int segment_is_reserved(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_area *area;
+	struct gc_candidate *cand;
+	void *reserved;
+	int i;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	if (reserved)
+		return 1;
+
+	/* Currently open segments */
+	for_each_area(i) {
+		area = super->s_area[i];
+		if (area->a_is_open && area->a_segno == segno)
+			return 1;
+	}
+
+	/* On the free list */
+	list_for_each_entry(cand, &super->s_free_list.list, list)
+		if (cand->segno == segno)
+			return 1;
+
+	return 0;
+}
+
+static void logfs_mark_segment_bad(struct super_block *sb, u32 segno)
+{
+	BUG();
+}
+
+/*
+ * Count the bytes consumed by valid objects in this segment.  Object headers
+ * are counted, the segment header is not.
+ */
+static u32 logfs_valid_bytes(struct super_block *sb, u32 segno, u32 *ec,
+		u8 *level, u64 *segment_gec)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_segment_header sh;
+	struct logfs_object_header oh;
+	u64 ofs, ino, bix;
+	u32 seg_ofs, valid, size;
+	int err;
+
+	err = device_read(sb, segno, 0, sizeof(sh), &sh);
+	BUG_ON(err);
+	if (!memchr_inv(&sh, 0xff, sizeof(sh)))
+		return 0;
+
+	*level = sh.level;
+	*ec = be32_to_cpu(sh.ec);
+	*segment_gec = be64_to_cpu(sh.gec);
+	if (sh.crc != logfs_crc32(&sh, sizeof(sh), 4)) {
+		logfs_mark_segment_bad(sb, segno);
+		return super->s_segsize - 1;
+	}
+
+	valid = 0;
+	for (seg_ofs = LOGFS_SEGMENT_HEADERSIZE;
+			seg_ofs + sizeof(oh) < super->s_segsize;) {
+		err = device_read(sb, segno, seg_ofs, sizeof(oh), &oh);
+		BUG_ON(err);
+		if (!memchr_inv(&oh, 0xff, sizeof(oh)))
+			break;
+
+		if (oh.crc != logfs_crc32(&oh, sizeof(oh) - 4, 4)) {
+			logfs_mark_segment_bad(sb, segno);
+			return super->s_segsize - 1;
+		}
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(oh.ino);
+		bix = be64_to_cpu(oh.bix);
+		size = (u32)be16_to_cpu(oh.len) + sizeof(oh);
+
+		if (logfs_is_valid_block(sb, ofs, ino, bix, *level))
+			valid += size;
+		seg_ofs += size;
+	}
+	pr_debug(KERN_INFO "LOGFS valid(%x) = %x\n", segno, valid);
+	return valid;
+}
+
+/* FIXME: check for off-by-one on max_dist */
+/*
+ * GC distance N:
+ * while (valid blocks in segment) {
+ * 	rewrite one block
+ * 	if (fewer than N free segments)
+ * 		GC distance N-1
+ * }
+ * While (N > 1) {
+ * 	N--;
+ * 	flush dirty list N
+ * }
+ * Exit criterium: free segments >= N
+ *
+ * flush dirty list N:
+ * while (dirty blocks on level) {
+ * 	write block
+ * 	if (fewer then N free segments)
+ * 		GC distance N-1
+ * }
+ */
+
+/*
+ * Move all block from the gc_dirty lists to a private one, then recursively
+ * call into GC again to free some segments on higher layers.
+ */
+static void recursive_backoff(struct super_block *sb, int max_dist)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_block *block, *tmp;
+	int i;
+	LIST_HEAD(backoff_list);
+
+	for_each_area(i) {
+		if (i > max_dist)
+			break;
+		list_for_each_entry_safe(block, tmp, &super->s_gc_dirty_list[i], dirty_list) {
+			list_move_tail(&block->dirty_list, &backoff_list);
+		}
+	}
+	__logfs_gc_pass(sb, max_dist);
+	list_for_each_entry_safe(block, tmp, &backoff_list, dirty_list)
+		logfs_dirty_for_gc(sb, block);
+}
+
+/* Write back any indirect/inode blocks dirtied during the GC run. */
+static void flush_gc_dirty_list(struct super_block *sb, int dist)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_block *block;
+	struct page *page;
+	struct inode *inode;
+	long flags;
+	int err;
+
+	for (;;) {
+		if (dist < 0)
+			break;
+		if (list_empty(&super->s_gc_dirty_list[dist])) {
+			dist--;
+			continue;
+		}
+
+		block = list_entry(super->s_gc_dirty_list[dist].next,
+				struct logfs_block, dirty_list);
+		page = block->page;
+		inode = page->mapping->host;
+		if (super->s_free_list.count < dist) {
+			/* We ran out of room on this level. */
+			/* Interestingly enough, this case is possible in
+			 * theory, but never triggered in practice.
+			 */
+			recursive_backoff(sb, dist);
+			continue;
+		}
+
+		flags = WF_GC;
+		if (super->s_free_bytes < dist * LOGFS_MAX_OBJECTSIZE
+				+ super->s_gc_reserve
+				+ super->s_dirty_free_bytes)
+			flags |= WF_SYNC;
+		err = logfs_write_buf(inode, page, NULL, WF_GC);
+		BUG_ON(err);
+	}
+}
+
+void logfs_dirty_for_gc(struct super_block *sb, struct logfs_block *block)
+{
+	struct page *page;
+	struct inode *inode;
+	u64 bix;
+	u8 level, dist;
+
+	page = block->page;
+	inode = page->mapping->host;
+	logfs_unpack_index(block->page->index, &bix, &level);
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		level += LOGFS_MAX_LEVELS;
+
+	dist = root_distance(sb, level);
+	list_move_tail(&block->dirty_list, &logfs_super(sb)->s_gc_dirty_list[dist]);
+}
+
+static void logfs_cleanse_block(struct super_block *sb, u64 ofs, u64 ino,
+		u64 bix, int level, long flags)
+{
+	struct inode *inode;
+	int err, cookie;
+
+	inode = logfs_iget(sb, ino, &cookie);
+	BUG_ON(!inode);
+	err = logfs_rewrite_block(inode, bix, ofs, level, flags);
+	BUG_ON(err);
+	logfs_iput(inode, cookie);
+}
+
+static u32 logfs_gc_segment(struct super_block *sb, u32 segno, u8 dist)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_segment_header sh;
+	struct logfs_object_header oh;
+	u64 ofs, ino, bix;
+	u32 seg_ofs, cleaned = 0;
+	int level, err, len, valid;
+	long flags;
+
+	LOGFS_BUG_ON(segment_is_reserved(sb, segno), sb);
+
+	btree_insert(&super->s_reserved_segments, segno, (void *)1);
+	err = device_read(sb, segno, 0, sizeof(sh), &sh);
+	BUG_ON(err);
+	level = sh.level;
+	if (sh.crc != logfs_crc32(&sh, sizeof(sh), 4)) {
+		logfs_mark_segment_bad(sb, segno);
+		cleaned = -1;
+		goto out;
+	}
+
+	for (seg_ofs = LOGFS_SEGMENT_HEADERSIZE;
+			seg_ofs + sizeof(oh) < super->s_segsize; ) {
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		err = device_read(sb, segno, seg_ofs, sizeof(oh), &oh);
+		BUG_ON(err);
+
+		if (!memchr_inv(&oh, 0xff, sizeof(oh)))
+			break;
+
+		if (oh.crc != logfs_crc32(&oh, sizeof(oh) - 4, 4)) {
+			logfs_mark_segment_bad(sb, segno);
+			cleaned = super->s_segsize - 1;
+			goto out;
+		}
+
+		ino = be64_to_cpu(oh.ino);
+		bix = be64_to_cpu(oh.bix);
+		len = sizeof(oh) + be16_to_cpu(oh.len);
+		valid = logfs_is_valid_block(sb, ofs, ino, bix, level);
+		if (valid) {
+			/* Garbage collection may consume further free segments.
+			 * If space gets too tight, abort and continue with a
+			 * higher level segment for the moment. */
+			if (super->s_free_list.count < dist)
+				recursive_backoff(sb, dist);
+
+			flags = WF_GC;
+			if (super->s_free_bytes < dist * LOGFS_MAX_OBJECTSIZE
+					+ super->s_gc_reserve
+					+ super->s_dirty_free_bytes)
+				flags |= WF_SYNC;
+			logfs_cleanse_block(sb, ofs, ino, bix, level, flags);
+			cleaned += len;
+		}
+		seg_ofs += len;
+	}
+
+	flush_gc_dirty_list(sb, dist - 1);
+out:
+	btree_remove(&super->s_reserved_segments, segno);
+	return cleaned;
+}
+
+static struct gc_candidate *add_list(struct gc_candidate *cand,
+		struct candidate_list *list)
+{
+	struct gc_candidate *cur, *removed = NULL;
+	int cont;
+
+	/* insert sorted */
+	list_for_each_entry(cur, &list->list, list) {
+		if (list->sort_by_ec)
+			cont = cur->erase_count < cand->erase_count;
+		else
+			cont = cur->valid < cand->valid;
+		if (cont)
+			continue;
+		list_add(&cand->list, &cur->list);
+		cand = NULL;
+		break;
+	}
+	/* if list is empty or candidate is worse than entire list */
+	if (cand)
+		list_add_tail(&cand->list, &list->list);
+
+	/* remove worst entry if list is full */
+	if (list->count >= list->maxcount) {
+		removed = list_entry(list->list.prev,
+				struct gc_candidate, list);
+		list_del(&removed->list);
+	} else
+		list->count++;
+
+	return removed;
+}
+
+struct gc_candidate *get_best_cand(struct candidate_list *list)
+{
+	struct gc_candidate *cand;
+
+	if (list->count == 0)
+		return NULL;
+
+	cand = list_entry(list->list.next, struct gc_candidate, list);
+	list_del(&cand->list);
+	list->count--;
+	return cand;
+}
+
+/*
+ * We try to stuff the candidate in several lists in order.  Any list may
+ * either reject it or evict another candidate when full.  Anything left after
+ * trying the last list gets freed.
+ */
+static void __add_candidate(struct super_block *sb, struct gc_candidate *cand)
+{
+	struct logfs_super *super = logfs_super(sb);
+	u32 full = super->s_segsize - LOGFS_SEGMENT_RESERVE;
+
+	/* 100% free segments */
+	if (cand->valid == 0)
+		cand = add_list(cand, &super->s_free_list);
+	/* good candidates for Garbage Collection */
+	if (cand && cand->valid < full)
+		cand = add_list(cand, &super->s_low_list[cand->dist]);
+	/* good candidates for wear leveling,
+	 * segments that were recently written get ignored */
+	if (cand && cand->gec < super->s_gec + 2*super->s_no_segs)
+		cand = add_list(cand, &super->s_ec_list);
+
+	kfree(cand);
+}
+
+static int add_candidate(struct super_block *sb, u32 segno, u32 valid, u32 ec,
+		u8 dist, u64 segment_gec)
+{
+	struct gc_candidate *cand;
+
+	cand = kmalloc(sizeof(*cand), GFP_KERNEL);
+	if (!cand)
+		return -ENOMEM;
+
+	cand->segno = segno;
+	cand->valid = valid;
+	cand->erase_count = ec;
+	cand->dist = dist;
+	cand->gec = segment_gec;
+
+	/* FIXME: add to btree */
+	__add_candidate(sb, cand);
+	return 0;
+}
+
+int add_free_segments_from_journal(struct super_block *sb,
+		struct logfs_je_free_segments *segs, int count)
+{
+	int i, err;
+
+	for (i = 0; i < count; i++) {
+		u32 segno = be32_to_cpu(segs[i].segno);
+		u32 ec = be32_to_cpu(segs[i].ec);
+		err = add_candidate(sb, segno, 0, ec, 0, 0);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static void __del_segment(struct candidate_list *list, u32 segno)
+{
+	struct gc_candidate *cand;
+
+	list_for_each_entry(cand, &list->list, list)
+		if (cand->segno == segno) {
+			list_del(&cand->list);
+			list->count -= 1;
+			kfree(cand);
+			return;
+		}
+}
+
+static void del_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	__del_segment(&super->s_free_list, segno);
+	for_each_area(i)
+		__del_segment(&super->s_low_list[i], segno);
+	__del_segment(&super->s_ec_list, segno);
+}
+
+static void scan_segment(struct super_block *sb, u32 segno)
+{
+	u64 segment_gec = 0;
+	u32 valid, ec = 0;
+	u8 dist, level = 0;
+
+	if (segment_is_reserved(sb, segno))
+		return;
+
+	del_segment(sb, segno);
+	valid = logfs_valid_bytes(sb, segno, &ec, &level, &segment_gec);
+	dist = root_distance(sb, level);
+	add_candidate(sb, segno, valid, ec, dist, segment_gec);
+}
+
+static struct gc_candidate *first_in_list(struct candidate_list *list)
+{
+	if (list->count == 0)
+		return NULL;
+	return list_entry(list->list.next, struct gc_candidate, list);
+}
+
+static struct gc_candidate *get_wl_candidate(struct super_block *sb,
+		int max_dist)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct gc_candidate *cand;
+	u64 cand_gec;
+
+	if (super->s_gec & 0xf)
+		return NULL;
+
+	cand = first_in_list(&super->s_ec_list);
+	if (!cand)
+		return NULL;
+	if (cand->dist > max_dist)
+		return NULL;
+
+	/* instead of comparing candidate erasecount to average erasecount,
+	 * which would involve a 64bit division we multiply candidate erasecount
+	 * with the number of segment..  In effect, the comparison is:
+	 * if (cand->erase_count + 20 > average_erasecount)
+	 */
+	cand_gec = cand->erase_count;
+	cand_gec += 20; /* FIXME: should be a superblock variable */
+	cand_gec *= super->s_no_segs;
+	if (cand_gec > super->s_gec)
+		return NULL;
+
+	list_del(&cand->list);
+	super->s_ec_list.count--;
+	return cand;
+}
+
+static struct gc_candidate *get_candidate(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i, max_dist;
+	struct gc_candidate *cand = NULL, *this;
+
+	max_dist = min(super->s_free_list.count, LOGFS_NO_AREAS);
+
+	cand = get_wl_candidate(sb, max_dist);
+	if (cand)
+		return cand;
+
+	for (i = 0; i <= max_dist; i++) {
+		this = first_in_list(&super->s_low_list[i]);
+		if (!this)
+			continue;
+		if (!cand)
+			cand = this;
+		if (this->valid < cand->valid)
+			cand = this;
+	}
+	if (cand) {
+		list_del(&cand->list);
+		super->s_low_list[cand->dist].count--;
+	}
+	return cand;
+}
+
+static int logfs_gc_once(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct gc_candidate *cand;
+	u64 segment_gec;
+	u32 cleaned, valid, segno, ec;
+	u8 dist;
+
+	cand = get_candidate(sb);
+	if (!cand)
+		return 0;
+
+	valid = cand->valid;
+	segno = cand->segno;
+	dist = cand->dist;
+	ec = cand->erase_count;
+	segment_gec = cand->gec;
+	kfree(cand);
+	pr_debug("GC segment #%02x at %x, %x required, %x free, %x valid, %llx free, %llx reserve\n",
+			segno, segno << super->s_segshift,
+			dist, super->s_free_list.count, valid,
+			super->s_free_bytes, super->s_gc_reserve);
+	cleaned = logfs_gc_segment(sb, segno, dist);
+	pr_debug("GC segment #%02x complete\n", segno);
+	add_candidate(sb, segno, valid - cleaned, ec, dist, segment_gec);
+	return 1;
+}
+
+/* returns 1 if a wrap occurs, 0 otherwise */
+static int logfs_scan_some(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	u32 segno;
+	int i, ret = 0;
+
+	segno = super->s_sweeper;
+	for (i = SCAN_RATIO; i > 0; i--) {
+		segno++;
+		if (segno >= super->s_no_segs) {
+			segno = 0;
+			ret = 1;
+		}
+
+		scan_segment(sb, segno);
+	}
+	super->s_sweeper = segno;
+	return ret;
+}
+
+/*
+ * In principle, this function should loop forever, looking for GC candidates
+ * and moving data.  LogFS is designed in such a way that this loop is
+ * guaranteed to terminate.
+ *
+ * Limiting the loop to some iterations serves purely to catch cases when
+ * these guarantees have failed.  An actual endless loop is an obvious bug
+ * and should be reported as such.
+ */
+static void __logfs_gc_pass(struct super_block *sb, int target)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int round, progress, last_progress = 0;
+
+	pr_debug("__logfs_gc_pass(%x)\n", target);
+	for (round = 0; round < SCAN_ROUNDS; ) {
+		if (super->s_free_list.count >= target)
+			return;
+		round += logfs_scan_some(sb);
+		if (super->s_free_list.count >= target)
+			return;
+		progress = logfs_gc_once(sb);
+		if (progress)
+			last_progress = round;
+		else if (round - last_progress > 2)
+			break;
+	}
+	LOGFS_BUG(sb);
+}
+
+void logfs_gc_pass(struct super_block *sb)
+{
+	__logfs_gc_pass(sb, logfs_super(sb)->s_total_levels);
+}
+
+static int check_area(struct super_block *sb, int i)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_area *area = super->s_area[i];
+	struct logfs_object_header h;
+	u32 segno = area->a_segno;
+	u32 ofs = area->a_used_bytes;
+	__be32 crc;
+	int err;
+
+	if (!area->a_is_open)
+		return 0;
+
+	for (ofs = area->a_used_bytes;
+	    ofs <= super->s_segsize - sizeof(h);
+	    ofs += (u32)be16_to_cpu(h.len) + sizeof(h)) {
+		err = device_read(sb, segno, ofs, sizeof(h), &h);
+		if (err)
+			return err;
+
+		if (!memchr_inv(&h, 0xff, sizeof(h)))
+			break;
+
+		crc = logfs_crc32(&h, sizeof(h) - 4, 4);
+		if (crc != h.crc) {
+			printk(KERN_INFO "interrupted header at %llx\n",
+					dev_ofs(sb, segno, ofs));
+			return 0;
+		}
+	}
+	if (ofs > super->s_segsize - LOGFS_MAX_OBJECTSIZE) {
+		printk(KERN_INFO "%x bytes unaccounted data found at %llx - closing it\n",
+				ofs - area->a_used_bytes,
+				dev_ofs(sb, segno, ofs));
+		area->a_segno = 0;
+		area->a_is_open = 0;
+	} else if (ofs != area->a_used_bytes) {
+		printk(KERN_INFO "%x bytes unaccounted data found at %llx\n",
+				ofs - area->a_used_bytes,
+				dev_ofs(sb, segno, ofs));
+		area->a_used_bytes = ofs;
+	}
+	return 0;
+}
+
+int logfs_check_areas(struct super_block *sb)
+{
+	int i, err;
+
+	for_each_area(i) {
+		err = check_area(sb, i);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static void logfs_init_candlist(struct candidate_list *list, int maxcount,
+		int sort_by_ec)
+{
+	list->count = 0;
+	list->maxcount = maxcount;
+	list->sort_by_ec = sort_by_ec;
+	INIT_LIST_HEAD(&list->list);
+}
+
+int logfs_init_gc(struct logfs_super *super)
+{
+	int i;
+
+	logfs_init_candlist(&super->s_free_list, 4*LIST_SIZE, 1);
+	for_each_area(i)
+		logfs_init_candlist(&super->s_low_list[i], LIST_SIZE, 0);
+	logfs_init_candlist(&super->s_ec_list, LIST_SIZE, 1);
+	return 0;
+}
+
+static void logfs_cleanup_list(struct candidate_list *list)
+{
+	struct gc_candidate *cand, *next;
+
+	list_for_each_entry_safe(cand, next, &list->list, list) {
+		list_del(&cand->list);
+		kfree(cand);
+	}
+}
+
+void logfs_cleanup_gc(struct logfs_super *super)
+{
+	int i;
+
+	if (!super->s_free_list.list.next)
+		return;
+
+	logfs_cleanup_list(&super->s_free_list);
+	for_each_area(i)
+		logfs_cleanup_list(&super->s_low_list[i]);
+	logfs_cleanup_list(&super->s_ec_list);
+}

