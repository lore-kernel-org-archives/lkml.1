Return-Path: <linux-kernel-owner+w=401wt.eu-S935524AbXHHQWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524AbXHHQWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765240AbXHHQVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:21:55 -0400
Received: from lazybastard.de ([212.112.238.170]:42363 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbXHHQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:21:53 -0400
Date: Wed, 8 Aug 2007 18:17:57 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 07/18] fs/logfs/gc.c
Message-ID: <20070808161757.GI15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/gc.c	2007-08-08 02:57:37.000000000 +0200
@@ -0,0 +1,404 @@
+/*
+ * fs/logfs/gc.c	- garbage collection code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+
+#if 0
+/*
+ * When deciding which segment to use next, calculate the resistance
+ * of each segment and pick the lowest.  Segments try to resist usage
+ * if
+ * o they are full,
+ * o they have a high erase count or
+ * o they have recently been written.
+ *
+ * Full segments should not get reused, as there is little space to
+ * gain from them.  Segments with high erase count should be left
+ * aside as they can wear out sooner than others.  Freshly-written
+ * segments contain many blocks that will get obsoleted fairly soon,
+ * so it helps to wait a little before reusing them.
+ *
+ * Total resistance is expressed in erase counts.  Formula is:
+ *
+ * R = EC + K1*F + K2*e^(-t/theta)
+ *
+ * R:	Resistance
+ * EC:	Erase count
+ * K1:	Constant, 10,000 might be a good value
+ * K2:	Constant,  1,000 might be a good value
+ * F:	Segment fill level
+ * t:	Time since segment was written to (in number of segments written)
+ * theta: Time constant.  Total number of segments might be a good value
+ *
+ * Since the kernel is not allowed to use floating point, the function
+ * decay() is used to approximate exponential decay in fixed point.
+ */
+static long decay(long t0, long t, long theta)
+{
+	long shift, fac;
+
+	if (t >= 32*theta)
+		return 0;
+
+	shift = t/theta;
+	fac = theta - (t%theta)/2;
+	return (t0 >> shift) * fac / theta;
+}
+#endif
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
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = super->s_area[i];
+		if (area->a_is_open && area->a_segno == segno)
+			return 1;
+	}
+
+	/* On the free list */
+	list_for_each_entry(cand, &super->s_free_list, list)
+		if (cand->segno == segno)
+			return 1;
+
+	return 0;
+}
+
+/*
+ * Count the bytes consumed by valid objects in this segment.  Object headers
+ * are counted, the segment header is not.
+ */
+static u32 logfs_valid_bytes(struct super_block *sb, u32 segno, u8 *level)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_segment_header sh;
+	struct logfs_object_header oh;
+	u64 ofs, ino, pos;
+	u32 seg_ofs, valid, size;
+	int err;
+
+	if (segment_is_reserved(sb, segno))
+		return super->s_segsize;
+
+	err = device_read(sb, segno, 0, sizeof(sh), &sh);
+	BUG_ON(err);
+	if (!memchr_inv(&sh, 0xff, sizeof(sh)))
+		return 0;
+
+	*level = sh.level;
+
+	valid = 0;
+	for (seg_ofs = LOGFS_SEGMENT_HEADERSIZE;
+			seg_ofs + sizeof(oh) < super->s_segsize;) {
+		err = device_read(sb, segno, seg_ofs, sizeof(oh), &oh);
+		BUG_ON(err);
+		if (!memchr_inv(&oh, 0xff, sizeof(oh)))
+			break;
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(oh.ino);
+		pos = be64_to_cpu(oh.pos);
+		size = (u32)be16_to_cpu(oh.len) + sizeof(oh);
+		if (logfs_is_valid_block(sb, ofs, ino, pos))
+			valid += size;
+		seg_ofs += size;
+	}
+	pr_debug(KERN_INFO "LOGFS valid(%x) = %x\n", segno, valid);
+	return valid;
+}
+
+static void logfs_cleanse_block(struct super_block *sb, u64 ofs, u64 ino,
+		u64 pos, int level)
+{
+	struct inode *inode;
+	int err, cookie;
+
+	inode = logfs_iget(sb, ino, &cookie);
+	BUG_ON(!inode);
+	err = logfs_rewrite_block(inode, pos, ofs, level);
+	BUG_ON(err);
+	logfs_iput(inode, cookie);
+}
+
+static void __logfs_gc_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_segment_header sh;
+	struct logfs_object_header oh;
+	u64 ofs, ino, pos;
+	u32 seg_ofs;
+	int level, err;
+
+	err = device_read(sb, segno, 0, sizeof(sh), &sh);
+	BUG_ON(err);
+	level = sh.level;
+
+	for (seg_ofs = LOGFS_SEGMENT_HEADERSIZE;
+			seg_ofs + sizeof(oh) < super->s_segsize; ) {
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		err = device_read(sb, segno, seg_ofs, sizeof(oh), &oh);
+		BUG_ON(err);
+		ino = be64_to_cpu(oh.ino);
+		pos = be64_to_cpu(oh.pos);
+		if (logfs_is_valid_block(sb, ofs, ino, pos))
+			logfs_cleanse_block(sb, ofs, ino, pos, level);
+		seg_ofs += sizeof(oh);
+		seg_ofs += be16_to_cpu(oh.len);
+	}
+}
+
+static void logfs_gc_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+	void *reserved;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	LOGFS_BUG_ON(reserved, sb);
+
+	/* Currently open segments */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		struct logfs_area *area = super->s_area[i];
+		BUG_ON(area->a_is_open && (area->a_segno == segno));
+	}
+	__logfs_gc_segment(sb, segno);
+}
+
+static void __add_segment(struct list_head *list, int *count, u32 segno,
+		u8 level, int valid)
+{
+	struct gc_candidate *cand;
+
+	cand = kzalloc(sizeof(*cand), GFP_KERNEL);
+	if (!cand)
+		return;
+
+	cand->segno = segno;
+	cand->valid = valid;
+	cand->level = level;
+	list_add(&cand->list, list);
+	*count += 1;
+}
+
+static void add_segment(struct list_head *list, int *count, u32 segno, u8 level,
+		int valid)
+{
+	struct gc_candidate *cand;
+
+	list_for_each_entry(cand, list, list)
+		if (cand->segno == segno)
+			return;
+	__add_segment(list, count, segno, level, valid);
+}
+
+static void del_segment(struct list_head *list, int *count, u32 segno)
+{
+	struct gc_candidate *cand;
+
+	list_for_each_entry(cand, list, list)
+		if (cand->segno == segno) {
+			list_del(&cand->list);
+			*count -= 1;
+			kfree(cand);
+			return;
+		}
+}
+
+static void add_free_segment(struct super_block *sb, u32 segno, u8 level)
+{
+	struct logfs_super *super = logfs_super(sb);
+	add_segment(&super->s_free_list, &super->s_free_count, segno, level, 0);
+}
+
+static void add_low_segment(struct super_block *sb, u32 segno, u8 level,
+		int valid)
+{
+	struct logfs_super *super = logfs_super(sb);
+	add_segment(&super->s_low_list, &super->s_low_count, segno, level,
+			valid);
+}
+
+static void del_low_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	del_segment(&super->s_low_list, &super->s_low_count, segno);
+}
+
+static void scan_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	u32 full = super->s_segsize - LOGFS_SEGMENT_RESERVE;
+	int valid;
+	u8 level = 0; /* shut up, gcc! */
+
+	del_low_segment(sb, segno);
+	valid = logfs_valid_bytes(sb, segno, &level);
+	if (valid == 0)
+		add_free_segment(sb, segno, level);
+	else if (valid < full)
+		add_low_segment(sb, segno, level, valid);
+}
+
+static void logfs_scan_pass(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	for (i = super->s_sweeper+1; i != super->s_sweeper; i++) {
+		if (i >= super->s_no_segs)
+			i = 0;
+
+		scan_segment(sb, i);
+
+		if (super->s_free_count >= super->s_total_levels) {
+			super->s_sweeper = i;
+			return;
+		}
+	}
+	scan_segment(sb, super->s_sweeper);
+}
+
+static u8 root_distance(struct super_block *sb, u8 level)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	switch (level) {
+	case 0:
+	case 1:
+	case 2:
+	case 3:
+		return super->s_ifile_levels + super->s_data_levels - level;
+	case 6:
+	case 7:
+	case 8:
+		return super->s_ifile_levels - (level-6);
+	default:
+		BUG();
+	}
+}
+
+static void logfs_gc_once(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct gc_candidate *cand, *next;
+	u32 min_valid = super->s_segsize;
+	u32 segno;
+	u8 level;
+
+	LOGFS_BUG_ON(list_empty(&super->s_low_list), sb);
+	list_for_each_entry_safe(cand, next, &super->s_low_list, list) {
+		if (cand->valid >= min_valid)
+			continue;
+		if (root_distance(sb, cand->level) > super->s_free_count)
+			continue;
+		min_valid = cand->valid;
+		list_del(&cand->list);
+		list_add(&cand->list, &super->s_low_list);
+	}
+
+	cand = list_entry(super->s_low_list.next, struct gc_candidate, list);
+	list_del(&cand->list);
+	super->s_low_count -= 1;
+
+	min_valid = cand->valid;
+	segno = cand->segno;
+	level = cand->level;
+	kfree(cand);
+	pr_debug("GC segment #%02x, level %x, %x required, %x free, %x valid\n",
+			segno, level, root_distance(sb, level),
+			super->s_free_count, min_valid);
+	logfs_gc_segment(sb, segno);
+	add_free_segment(sb, segno, level);
+}
+
+/* GC all the low-count segments.  If necessary, rescan the medium.
+ * If we made enough room, return */
+static void logfs_gc_several(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int rounds;
+
+	rounds = super->s_low_count;
+
+	for (; rounds; rounds--) {
+		if (super->s_free_count < 5 || !super->s_low_count)
+			logfs_scan_pass(sb);
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		logfs_gc_once(sb);
+	}
+}
+
+/*
+ * In principle, this function should loop forever, looking for GC candidates
+ * and moving data.  LogFS is designed in such a way that this loop is
+ * guaranteed to terminate.
+ *
+ * Limiting the loop to four iterations serves purely to catch cases when
+ * these guarantees have failed.  An actual endless loop is an obvious bug
+ * and should be reported as such.
+ *
+ * But there is another nasty twist to this.  As I have described in my LCA
+ * presentation, Garbage collection would have to limit itself to higher
+ * levels if the number of available free segments goes down.  This code
+ * doesn't and should fail spectacularly.  Yet - hard as I tried I haven't
+ * been able to make it fail (short of a bug elsewhere).
+ *
+ * So in a way this code is intentionally wrong as a desperate cry for a
+ * better testcase.  And I do expect to get blamed for it one day. :(
+ */
+void logfs_gc_pass(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i;
+
+	for (i=4; i; i--) {
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		logfs_scan_pass(sb);
+
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		logfs_gc_several(sb);
+		cond_resched();
+	}
+	logfs_fsck(sb);
+	LOGFS_BUG(sb);
+}
+
+int logfs_init_gc(struct logfs_super *super)
+{
+	super->s_free_count = 0;
+	super->s_low_count = 0;
+
+	return 0;
+}
+
+void logfs_cleanup_gc(struct logfs_super *super)
+{
+	struct gc_candidate *cand, *next;
+
+	list_for_each_entry_safe(cand, next, &super->s_free_list, list) {
+		list_del(&cand->list);
+		kfree(cand);
+	}
+	list_for_each_entry_safe(cand, next, &super->s_low_list, list) {
+		list_del(&cand->list);
+		kfree(cand);
+	}
+}
