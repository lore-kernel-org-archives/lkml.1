Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbXFCSux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbXFCSux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXFCSuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:50:44 -0400
Received: from lazybastard.de ([212.112.238.170]:55759 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXFCSum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:50:42 -0400
Date: Sun, 3 Jun 2007 20:46:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: [Patch 09/18] fs/logfs/gc.c
Message-ID: <20070603184604.GJ8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-03-13 19:15:28.862769062 +0100
+++ linux-2.6.21logfs/fs/logfs/gc.c	2007-06-03 19:18:57.000000000 +0200
@@ -0,0 +1,352 @@
+/*
+ * fs/logfs/gc.c	- garbage collection code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel
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
+/* Only valid objects are accounted as valid bytes, including their headers */
+static u32 logfs_valid_bytes(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_object_header h;
+	u64 ofs, ino, pos;
+	u32 seg_ofs, valid, size;
+	void *reserved;
+	int i, err;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	if (reserved)
+		return super->s_segsize;
+
+	/* Currently open segments */
+	/* FIXME: just reserve open areas and remove this code */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		struct logfs_area *area = super->s_area[i];
+		if (area->a_is_open && (area->a_segno == segno)) {
+			return super->s_segsize;
+		}
+	}
+
+	err = device_read(sb, segno, 0, sizeof(h), &h);
+	BUG_ON(err);
+	if (!memchr_inv(&h, 0xff, sizeof(h)))
+		return 0;
+
+	valid = 0;
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		err = device_read(sb, segno, seg_ofs, sizeof(h), &h);
+		BUG_ON(err);
+		if (!memchr_inv(&h, 0xff, sizeof(h)))
+			break;
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		size = (u32)be16_to_cpu(h.len) + sizeof(h);
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
+	struct logfs_object_header h;
+	struct logfs_segment_header *sh;
+	u64 ofs, ino, pos;
+	u32 seg_ofs;
+	int level, err;
+
+	err = device_read(sb, segno, 0, sizeof(h), &h);
+	BUG_ON(err);
+	sh = (void*)&h;
+	level = sh->level;
+
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		err = device_read(sb, segno, seg_ofs, sizeof(h), &h);
+		BUG_ON(err);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		if (logfs_is_valid_block(sb, ofs, ino, pos))
+			logfs_cleanse_block(sb, ofs, ino, pos, level);
+		seg_ofs += sizeof(h);
+		seg_ofs += be16_to_cpu(h.len);
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
+		int valid)
+{
+	struct gc_candidate *cand;
+
+	cand = kzalloc(sizeof(*cand), GFP_KERNEL);
+	if (!cand)
+		return;
+
+	cand->segno = segno;
+	cand->valid = valid;
+	list_add(&cand->list, list);
+	*count += 1;
+}
+
+static void add_segment(struct list_head *list, int *count, u32 segno,
+		int valid)
+{
+	struct gc_candidate *cand;
+
+	list_for_each_entry(cand, list, list)
+		if (cand->segno == segno)
+			return;
+	__add_segment(list, count, segno, valid);
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
+static void add_free_segment(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = logfs_super(sb);
+	add_segment(&super->s_free_list, &super->s_free_count, segno, 0);
+}
+
+static void add_low_segment(struct super_block *sb, u32 segno, int valid)
+{
+	struct logfs_super *super = logfs_super(sb);
+	add_segment(&super->s_low_list, &super->s_low_count, segno, valid);
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
+
+	valid = logfs_valid_bytes(sb, segno);
+	if (valid == 0) {
+		del_low_segment(sb, segno);
+		add_free_segment(sb, segno);
+	} else if (valid < full)
+		add_low_segment(sb, segno, valid);
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
+static void logfs_gc_once(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct gc_candidate *cand, *next;
+	unsigned min_valid = super->s_segsize;
+	u32 segno;
+
+	BUG_ON(list_empty(&super->s_low_list));
+	list_for_each_entry_safe(cand, next, &super->s_low_list, list) {
+		if (cand->valid >= min_valid)
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
+	segno = cand->segno;
+	logfs_gc_segment(sb, segno);
+	kfree(cand);
+	add_free_segment(sb, segno);
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
+		if (super->s_free_count >= super->s_total_levels)
+			return;
+		if (super->s_free_count < 3)
+			logfs_scan_pass(sb);
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
+	INIT_LIST_HEAD(&super->s_free_list);
+	INIT_LIST_HEAD(&super->s_low_list);
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
