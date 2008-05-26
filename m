Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYEZMZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYEZMZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYEZMXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:23:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56962 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbYEZMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:23:37 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 09/29] UBIFS: add superblock and master node
Date: Mon, 26 May 2008 17:05:23 +0300
Message-Id: <1211810743-18936-10-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 May 2008 12:23:33.0088 (UTC) FILETIME=[503F3E00:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the superblock and master node implementations.
The UBIFS superblock is read-only and contains only static data like
the default compression type. The superblock sits at the fixed
position and may be changed only with user-space tools. The master
node contains dynamic information like the position of the root
indexing node of the UBIFS indexing B-tree, and so on. The master
node is updated out-of-place.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/master.c |  387 ++++++++++++++++++++++++++++++++++
 fs/ubifs/sb.c     |  609 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 996 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/master.c b/fs/ubifs/master.c
new file mode 100644
index 0000000..d9dfc95
--- /dev/null
+++ b/fs/ubifs/master.c
@@ -0,0 +1,387 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/* This file implements reading and writing the master node */
+
+#include "ubifs.h"
+
+/**
+ * scan_for_master - search the valid master node.
+ * @c: UBIFS file-system description object
+ *
+ * This function scans the master node LEBs and search for the latest master
+ * node. Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+static int scan_for_master(struct ubifs_info *c)
+{
+	struct ubifs_scan_leb *sleb;
+	struct ubifs_scan_node *snod;
+	int lnum, offs = 0, nodes_cnt;
+
+	lnum = UBIFS_MST_LNUM;
+
+	sleb = ubifs_scan(c, lnum, 0, c->sbuf);
+	if (IS_ERR(sleb))
+		return PTR_ERR(sleb);
+	nodes_cnt = sleb->nodes_cnt;
+	if (nodes_cnt > 0) {
+		snod = list_entry(sleb->nodes.prev, struct ubifs_scan_node,
+				  list);
+		if (snod->type != UBIFS_MST_NODE)
+			goto out;
+		memcpy(c->mst_node, snod->node, snod->len);
+		offs = snod->offs;
+	}
+	ubifs_scan_destroy(sleb);
+
+	lnum += 1;
+
+	sleb = ubifs_scan(c, lnum, 0, c->sbuf);
+	if (IS_ERR(sleb))
+		return PTR_ERR(sleb);
+	if (sleb->nodes_cnt != nodes_cnt)
+		goto out;
+	if (!sleb->nodes_cnt)
+		goto out;
+	snod = list_entry(sleb->nodes.prev, struct ubifs_scan_node, list);
+	if (snod->type != UBIFS_MST_NODE)
+		goto out;
+	if (snod->offs != offs)
+		goto out;
+	if (memcmp((void *)c->mst_node + UBIFS_CH_SZ,
+		   (void *)snod->node + UBIFS_CH_SZ,
+		   UBIFS_MST_NODE_SZ - UBIFS_CH_SZ))
+		goto out;
+	c->mst_offs = offs;
+	ubifs_scan_destroy(sleb);
+	return 0;
+
+out:
+	ubifs_scan_destroy(sleb);
+	return -EINVAL;
+}
+
+/**
+ * validate_master - validate master node.
+ * @c: UBIFS file-system description object
+ *
+ * This function validates data which was read from master node. Returns zero
+ * if the data is all right and %-EINVAL if not.
+ */
+static int validate_master(const struct ubifs_info *c)
+{
+	unsigned long long main_sz;
+	int err;
+
+	if (c->max_sqnum >= SQNUM_WATERMARK) {
+		err = 1;
+		goto out;
+	}
+
+	if (c->cmt_no >= c->max_sqnum) {
+		err = 2;
+		goto out;
+	}
+
+	if (c->highest_inum >= INUM_WATERMARK) {
+		err = 3;
+		goto out;
+	}
+
+	if (c->lhead_lnum < UBIFS_LOG_LNUM ||
+	    c->lhead_lnum >= UBIFS_LOG_LNUM + c->log_lebs ||
+	    c->lhead_offs < 0 || c->lhead_offs >= c->leb_size ||
+	    c->lhead_offs & (c->min_io_size - 1)) {
+		err = 4;
+		goto out;
+	}
+
+	if (c->zroot.lnum >= c->leb_cnt || c->zroot.lnum < c->main_first ||
+	    c->zroot.offs >= c->leb_size || c->zroot.offs & 7) {
+		err = 5;
+		goto out;
+	}
+
+	if (c->zroot.len < c->ranges[UBIFS_IDX_NODE].min_len ||
+	    c->zroot.len > c->ranges[UBIFS_IDX_NODE].max_len) {
+		err = 6;
+		goto out;
+	}
+
+	if (c->gc_lnum >= c->leb_cnt || c->gc_lnum < c->main_first) {
+		err = 7;
+		goto out;
+	}
+
+	if (c->ihead_lnum >= c->leb_cnt || c->ihead_lnum < c->main_first ||
+	    c->ihead_offs % c->min_io_size || c->ihead_offs < 0 ||
+	    c->ihead_offs > c->leb_size || c->ihead_offs & 7) {
+		err = 8;
+		goto out;
+	}
+
+	main_sz = c->main_lebs * (unsigned long long)c->leb_size;
+	if (c->old_idx_sz & 7 || c->old_idx_sz >= main_sz) {
+		err = 9;
+		goto out;
+	}
+
+	if (c->lpt_lnum < c->lpt_first || c->lpt_lnum > c->lpt_last ||
+	    c->lpt_offs < 0 || c->lpt_offs + c->nnode_sz > c->leb_size) {
+		err = 10;
+		goto out;
+	}
+
+	if (c->nhead_lnum < c->lpt_first || c->nhead_lnum > c->lpt_last ||
+	    c->nhead_offs < 0 || c->nhead_offs % c->min_io_size ||
+	    c->nhead_offs > c->leb_size) {
+		err = 11;
+		goto out;
+	}
+
+	if (c->ltab_lnum < c->lpt_first || c->ltab_lnum > c->lpt_last ||
+	    c->ltab_offs < 0 ||
+	    c->ltab_offs + c->ltab_sz > c->leb_size) {
+		err = 12;
+		goto out;
+	}
+
+	if (c->big_lpt && (c->lsave_lnum < c->lpt_first ||
+	    c->lsave_lnum > c->lpt_last || c->lsave_offs < 0 ||
+	    c->lsave_offs + c->lsave_sz > c->leb_size)) {
+		err = 13;
+		goto out;
+	}
+
+	if (c->lscan_lnum < c->main_first || c->lscan_lnum >= c->leb_cnt) {
+		err = 14;
+		goto out;
+	}
+
+	if (c->lst.empty_lebs < 0 || c->lst.empty_lebs > c->main_lebs - 2) {
+		err = 15;
+		goto out;
+	}
+
+	if (c->lst.idx_lebs < 0 || c->lst.idx_lebs > c->main_lebs - 1) {
+		err = 16;
+		goto out;
+	}
+
+	if (c->lst.total_free < 0 || c->lst.total_free > main_sz ||
+	    c->lst.total_free & 7) {
+		err = 17;
+		goto out;
+	}
+
+	if (c->lst.total_dirty < 0 || (c->lst.total_dirty & 7)) {
+		err = 18;
+		goto out;
+	}
+
+	if (c->lst.total_used < 0 || (c->lst.total_used & 7)) {
+		err = 19;
+		goto out;
+	}
+
+	if (c->lst.total_free + c->lst.total_dirty +
+	    c->lst.total_used > main_sz) {
+		err = 20;
+		goto out;
+	}
+
+	if (c->lst.total_dead + c->lst.total_dark +
+	    c->lst.total_used + c->old_idx_sz > main_sz) {
+		err = 21;
+		goto out;
+	}
+
+	if (c->lst.total_dead < 0 ||
+	    c->lst.total_dead > c->lst.total_free + c->lst.total_dirty ||
+	    c->lst.total_dead & 7) {
+		err = 22;
+		goto out;
+	}
+
+	if (c->lst.total_dark < 0 ||
+	    c->lst.total_dark > c->lst.total_free + c->lst.total_dirty ||
+	    c->lst.total_dark & 7) {
+		err = 23;
+		goto out;
+	}
+
+	return 0;
+
+out:
+	ubifs_err("bad master node at offset %d error %d", c->mst_offs, err);
+	dbg_dump_node(c, c->mst_node);
+	return -EINVAL;
+}
+
+/**
+ * ubifs_read_master - read master node.
+ * @c: UBIFS file-system description object
+ *
+ * This function finds and reads the master node during file-system mount. If
+ * the flash is empty, it creates default master node as well. Returns zero in
+ * case of success and a negative error code in case of failure.
+ */
+int ubifs_read_master(struct ubifs_info *c)
+{
+	int err, old_leb_cnt;
+
+	c->mst_node = kzalloc(c->mst_node_alsz, GFP_KERNEL);
+	if (!c->mst_node)
+		return -ENOMEM;
+
+	err = scan_for_master(c);
+	if (err) {
+		err = ubifs_recover_master_node(c);
+		if (err)
+			/*
+			 * Note, we do not free 'c->mst_node' here because the
+			 * unmount routine will take care of this.
+			 */
+			return err;
+	}
+
+	/* Make sure that the recovery flag is clear */
+	c->mst_node->flags &= cpu_to_le32(~UBIFS_MST_RCVRY);
+
+	c->max_sqnum       = le64_to_cpu(c->mst_node->ch.sqnum);
+	c->highest_inum    = le64_to_cpu(c->mst_node->highest_inum);
+	c->cmt_no          = le64_to_cpu(c->mst_node->cmt_no);
+	c->zroot.lnum      = le32_to_cpu(c->mst_node->root_lnum);
+	c->zroot.offs      = le32_to_cpu(c->mst_node->root_offs);
+	c->zroot.len       = le32_to_cpu(c->mst_node->root_len);
+	c->lhead_lnum      = le32_to_cpu(c->mst_node->log_lnum);
+	c->gc_lnum         = le32_to_cpu(c->mst_node->gc_lnum);
+	c->ihead_lnum      = le32_to_cpu(c->mst_node->ihead_lnum);
+	c->ihead_offs      = le32_to_cpu(c->mst_node->ihead_offs);
+	c->old_idx_sz      = le64_to_cpu(c->mst_node->index_size);
+	c->lpt_lnum        = le32_to_cpu(c->mst_node->lpt_lnum);
+	c->lpt_offs        = le32_to_cpu(c->mst_node->lpt_offs);
+	c->nhead_lnum      = le32_to_cpu(c->mst_node->nhead_lnum);
+	c->nhead_offs      = le32_to_cpu(c->mst_node->nhead_offs);
+	c->ltab_lnum       = le32_to_cpu(c->mst_node->ltab_lnum);
+	c->ltab_offs       = le32_to_cpu(c->mst_node->ltab_offs);
+	c->lsave_lnum      = le32_to_cpu(c->mst_node->lsave_lnum);
+	c->lsave_offs      = le32_to_cpu(c->mst_node->lsave_offs);
+	c->lscan_lnum      = le32_to_cpu(c->mst_node->lscan_lnum);
+	c->lst.empty_lebs  = le32_to_cpu(c->mst_node->empty_lebs);
+	c->lst.idx_lebs    = le32_to_cpu(c->mst_node->idx_lebs);
+	old_leb_cnt        = le32_to_cpu(c->mst_node->leb_cnt);
+	c->lst.total_free  = le64_to_cpu(c->mst_node->total_free);
+	c->lst.total_dirty = le64_to_cpu(c->mst_node->total_dirty);
+	c->lst.total_used  = le64_to_cpu(c->mst_node->total_used);
+	c->lst.total_dead  = le64_to_cpu(c->mst_node->total_dead);
+	c->lst.total_dark  = le64_to_cpu(c->mst_node->total_dark);
+
+	c->calc_idx_sz = c->old_idx_sz;
+
+	if (c->mst_node->flags & cpu_to_le32(UBIFS_MST_NO_ORPHS))
+		c->no_orphs = 1;
+
+	if (old_leb_cnt != c->leb_cnt) {
+		/* The file system has been resized */
+		int growth = c->leb_cnt - old_leb_cnt;
+
+		if (c->leb_cnt < old_leb_cnt ||
+		    c->leb_cnt < UBIFS_MIN_LEB_CNT) {
+			ubifs_err("bad leb_cnt on master node");
+			dbg_dump_node(c, c->mst_node);
+			return -EINVAL;
+		}
+
+		dbg_mnt("Auto resizing (master) from %d LEBs to %d LEBs",
+			old_leb_cnt, c->leb_cnt);
+		c->lst.empty_lebs += growth;
+		c->lst.total_free += growth * (long long)c->leb_size;
+		c->lst.total_dark += growth * (long long)c->dark_wm;
+
+		/*
+		 * Reflect changes back onto the master node. N.B. the master
+		 * node gets written immediately whenever mounting (or
+		 * remounting) in read-write mode, so we do not need to write it
+		 * here.
+		 */
+		c->mst_node->leb_cnt = cpu_to_le32(c->leb_cnt);
+		c->mst_node->empty_lebs = cpu_to_le32(c->lst.empty_lebs);
+		c->mst_node->total_free = cpu_to_le64(c->lst.total_free);
+		c->mst_node->total_dark = cpu_to_le64(c->lst.total_dark);
+	}
+
+	err = validate_master(c);
+	if (err)
+		return err;
+
+	err = dbg_old_index_check_init(c, &c->zroot);
+
+	return err;
+}
+
+/**
+ * ubifs_write_master - write master node.
+ * @c: UBIFS file-system description object
+ *
+ * This function writes the master node. The caller has to take the
+ * @c->mst_mutex lock before calling this function. Returns zero in case of
+ * success and a negative error code in case of failure. The master node is
+ * written twice to enable recovery.
+ */
+int ubifs_write_master(struct ubifs_info *c)
+{
+	int err, lnum, offs, len;
+
+	if (c->ro_media)
+		return -EINVAL;
+
+	lnum = UBIFS_MST_LNUM;
+	offs = c->mst_offs + c->mst_node_alsz;
+	len = UBIFS_MST_NODE_SZ;
+
+	if (offs + UBIFS_MST_NODE_SZ > c->leb_size) {
+		err = ubifs_leb_unmap(c, lnum);
+		if (err)
+			return err;
+		offs = 0;
+	}
+
+	c->mst_offs = offs;
+	c->mst_node->highest_inum = cpu_to_le64(c->highest_inum);
+
+	err = ubifs_write_node(c, c->mst_node, len, lnum, offs, UBI_SHORTTERM);
+	if (err)
+		return err;
+
+	lnum += 1;
+
+	if (offs == 0) {
+		err = ubifs_leb_unmap(c, lnum);
+		if (err)
+			return err;
+	}
+	err = ubifs_write_node(c, c->mst_node, len, lnum, offs, UBI_SHORTTERM);
+
+	return err;
+}
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
new file mode 100644
index 0000000..cd08ecc
--- /dev/null
+++ b/fs/ubifs/sb.c
@@ -0,0 +1,609 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This file implements UBIFS superblock. The superblock is stored at the first
+ * LEB of the volume and is never changed by UBIFS. Only user-space tools may
+ * change it. The superblock node mostly contains geometry information.
+ */
+
+#include "ubifs.h"
+
+/*
+ * Default journal size in logical eraseblocks as a percent of total
+ * flash size.
+ */
+#define DEFAULT_JNL_PERCENT 5
+
+/* Default maximum journal size in bytes */
+#define DEFAULT_MAX_JNL (32*1024*1024)
+
+/* Default indexing tree fanout */
+#define DEFAULT_FANOUT 8
+
+/* Default number of LEBs for orphan information */
+#ifdef CONFIG_UBIFS_FS_DEBUG
+#define DEFAULT_ORPHAN_LEBS 2 /* 2 is better for testing */
+#else
+#define DEFAULT_ORPHAN_LEBS 1
+#endif
+
+/* Default number of journal heads */
+#define DEFAULT_JHEADS_CNT 1
+
+/* Default positions of different LEBs in the main area */
+#define DEFAULT_IDX_LEB  0
+#define DEFAULT_DATA_LEB 1
+#define DEFAULT_GC_LEB   2
+
+/* Default number of LEB numbers in LPT's save table */
+#define DEFAULT_LSAVE_CNT 256
+
+/* Default reserved pool size as a percent of maximum free space */
+#define DEFAULT_RP_PERCENT 5
+
+/* The default maximum size of reserved pool in bytes */
+#define DEFAULT_MAX_RP_SIZE (5*1024*1024)
+
+/* Default time granularity in nanoseconds */
+#define DEFAULT_TIME_GRAN 1000000000
+
+/**
+ * create_default_filesystem - format empty UBI volume.
+ * @c: UBIFS file-system description object
+ *
+ * This function creates default empty file-system. Returns zero in case of
+ * success and a negative error code in case of failure.
+ */
+static int create_default_filesystem(struct ubifs_info *c)
+{
+	struct ubifs_sb_node *sup;
+	struct ubifs_mst_node *mst;
+	struct ubifs_idx_node *idx;
+	struct ubifs_branch *br;
+	struct ubifs_ino_node *ino;
+	struct ubifs_cs_node *cs;
+	union ubifs_key key;
+	int err, tmp, jnl_lebs, log_lebs, max_buds, main_lebs, main_first;
+	int lpt_lebs, lpt_first, orph_lebs, big_lpt, ino_waste, sup_flags = 0;
+	uint64_t tmp64, main_bytes;
+
+	/* Some functions called from here depend on the @c->key_len filed */
+	c->key_len = UBIFS_SK_LEN;
+
+	/*
+	 * First of all, we have to calculate default file-system geometry -
+	 * log size, journal size, etc.
+	 */
+	c->max_leb_cnt = c->leb_cnt;
+	if (c->leb_cnt < 0x7FFFFFFF / DEFAULT_JNL_PERCENT)
+		/* We can first multiply then divide and have no overflow */
+		jnl_lebs = c->leb_cnt * DEFAULT_JNL_PERCENT / 100;
+	else
+		jnl_lebs = (c->leb_cnt / 100) * DEFAULT_JNL_PERCENT;
+
+	if (jnl_lebs < UBIFS_MIN_JNL_LEBS)
+		jnl_lebs = UBIFS_MIN_JNL_LEBS;
+	if (jnl_lebs * c->leb_size > DEFAULT_MAX_JNL)
+		jnl_lebs = DEFAULT_MAX_JNL / c->leb_size;
+
+	/*
+	 * The log should be large enough to fit reference nodes for all bud
+	 * LEBs. Because buds do not have to start from the beginning of LEBs
+	 * (half of the LEB may contain committed data), the log should
+	 * generally be larger, make it twice as large.
+	 */
+	tmp = 2 * (c->ref_node_alsz * jnl_lebs) + c->leb_size - 1;
+	log_lebs = tmp / c->leb_size;
+	/* Plus one LEB reserved for commit */
+	log_lebs += 1;
+	/* And some extra space to allow writes while committing */
+	log_lebs += 1;
+
+	max_buds = jnl_lebs - log_lebs;
+	if (max_buds < UBIFS_MIN_BUD_LEBS)
+		max_buds = UBIFS_MIN_BUD_LEBS;
+
+	/*
+	 * Orphan nodes are stored in a separate area. One node can store a lot
+	 * of orphan inode numbers, but when new orphan comes we just add a new
+	 * orphan node. At some point the nodes are consolidated into one
+	 * orphan node.
+	 */
+	orph_lebs = DEFAULT_ORPHAN_LEBS;
+
+	main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS - log_lebs;
+	main_lebs -= orph_lebs;
+
+	lpt_first = UBIFS_LOG_LNUM + log_lebs;
+	c->lsave_cnt = DEFAULT_LSAVE_CNT;
+	err = ubifs_create_dflt_lpt(c, &main_lebs, lpt_first, &lpt_lebs,
+				    &big_lpt);
+	if (err)
+		return err;
+
+	dbg_gen("LEB Properties Tree created (LEBs %d-%d)", lpt_first,
+		lpt_first + lpt_lebs - 1);
+
+	main_first = c->leb_cnt - main_lebs;
+
+	/* Create default superblock */
+	tmp = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);
+	sup = kzalloc(tmp, GFP_KERNEL);
+	if (!sup)
+		return -ENOMEM;
+
+	tmp64 = (uint64_t)max_buds * c->leb_size;
+	if (big_lpt)
+		sup_flags |= UBIFS_FLG_BIGLPT;
+
+	sup->ch.node_type  = UBIFS_SB_NODE;
+	sup->key_hash      = UBIFS_KEY_HASH_R5;
+	sup->flags         = cpu_to_le32(sup_flags);
+	sup->min_io_size   = cpu_to_le32(c->min_io_size);
+	sup->leb_size      = cpu_to_le32(c->leb_size);
+	sup->leb_cnt       = cpu_to_le32(c->leb_cnt);
+	sup->max_leb_cnt   = cpu_to_le32(c->max_leb_cnt);
+	sup->max_bud_bytes = cpu_to_le64(tmp64);
+	sup->log_lebs      = cpu_to_le32(log_lebs);
+	sup->lpt_lebs      = cpu_to_le32(lpt_lebs);
+	sup->orph_lebs     = cpu_to_le32(orph_lebs);
+	sup->jhead_cnt     = cpu_to_le32(DEFAULT_JHEADS_CNT);
+	sup->fanout        = cpu_to_le32(DEFAULT_FANOUT);
+	sup->lsave_cnt     = cpu_to_le32(c->lsave_cnt);
+	sup->fmt_vers      = cpu_to_le32(UBIFS_FORMAT_VERSION);
+	sup->default_compr = cpu_to_le16(UBIFS_COMPR_LZO);
+	sup->time_gran     = cpu_to_le32(DEFAULT_TIME_GRAN);
+
+	main_bytes = (uint64_t)main_lebs * c->leb_size;
+	tmp64 = main_bytes * DEFAULT_RP_PERCENT;
+	do_div(tmp64, 100);
+	if (tmp64 > DEFAULT_MAX_RP_SIZE)
+		tmp64 = DEFAULT_MAX_RP_SIZE;
+	sup->rp_size = cpu_to_le64(tmp64);
+
+	err = ubifs_write_node(c, sup, UBIFS_SB_NODE_SZ, 0, 0, UBI_LONGTERM);
+	kfree(sup);
+	if (err)
+		return err;
+
+	dbg_gen("default superblock created at LEB 0:0");
+
+	/* Create default master node */
+	mst = kzalloc(c->mst_node_alsz, GFP_KERNEL);
+	if (!mst)
+		return -ENOMEM;
+
+	mst->ch.node_type = UBIFS_MST_NODE;
+	mst->log_lnum     = cpu_to_le32(UBIFS_LOG_LNUM);
+	mst->highest_inum = cpu_to_le64(UBIFS_FIRST_INO);
+	mst->cmt_no       = cpu_to_le64(0);
+	mst->root_lnum    = cpu_to_le32(main_first + DEFAULT_IDX_LEB);
+	mst->root_offs    = cpu_to_le32(0);
+	tmp = ubifs_idx_node_sz(c, 1);
+	mst->root_len     = cpu_to_le32(tmp);
+	mst->gc_lnum      = cpu_to_le32(main_first + DEFAULT_GC_LEB);
+	mst->ihead_lnum   = cpu_to_le32(main_first + DEFAULT_IDX_LEB);
+	mst->ihead_offs   = cpu_to_le32(ALIGN(tmp, c->min_io_size));
+	mst->index_size   = cpu_to_le64(ALIGN(tmp, 8));
+	mst->lpt_lnum     = cpu_to_le32(c->lpt_lnum);
+	mst->lpt_offs     = cpu_to_le32(c->lpt_offs);
+	mst->nhead_lnum   = cpu_to_le32(c->nhead_lnum);
+	mst->nhead_offs   = cpu_to_le32(c->nhead_offs);
+	mst->ltab_lnum    = cpu_to_le32(c->ltab_lnum);
+	mst->ltab_offs    = cpu_to_le32(c->ltab_offs);
+	mst->lsave_lnum   = cpu_to_le32(c->lsave_lnum);
+	mst->lsave_offs   = cpu_to_le32(c->lsave_offs);
+	mst->lscan_lnum   = cpu_to_le32(main_first);
+	mst->empty_lebs   = cpu_to_le32(main_lebs - 2);
+	mst->idx_lebs     = cpu_to_le32(1);
+	mst->leb_cnt      = cpu_to_le32(c->leb_cnt);
+
+	/* Calculate lprops statistics */
+	tmp64 = main_bytes;
+	tmp64 -= ALIGN(ubifs_idx_node_sz(c, 1), c->min_io_size);
+	tmp64 -= ALIGN(UBIFS_INO_NODE_SZ, c->min_io_size);
+	mst->total_free = cpu_to_le64(tmp64);
+
+	tmp64 = ALIGN(ubifs_idx_node_sz(c, 1), c->min_io_size);
+	ino_waste = ALIGN(UBIFS_INO_NODE_SZ, c->min_io_size) -
+			  UBIFS_INO_NODE_SZ;
+	tmp64 += ino_waste;
+	tmp64 -= ALIGN(ubifs_idx_node_sz(c, 1), 8);
+	mst->total_dirty = cpu_to_le64(tmp64);
+
+	/*  The indexing LEB does not contribute to dark space */
+	tmp64 = (c->main_lebs - 1) * c->dark_wm;
+	mst->total_dark = cpu_to_le64(tmp64);
+
+	mst->total_used = cpu_to_le64(UBIFS_INO_NODE_SZ);
+
+	err = ubifs_write_node(c, mst, UBIFS_MST_NODE_SZ, UBIFS_MST_LNUM, 0,
+			       UBI_UNKNOWN);
+	if (err) {
+		kfree(mst);
+		return err;
+	}
+	err = ubifs_write_node(c, mst, UBIFS_MST_NODE_SZ, UBIFS_MST_LNUM + 1, 0,
+			       UBI_UNKNOWN);
+	kfree(mst);
+	if (err)
+		return err;
+
+	dbg_gen("default master node created at LEB %d:0", UBIFS_MST_LNUM);
+
+	/* Create the root indexing node */
+	tmp = ubifs_idx_node_sz(c, 1);
+	idx = kzalloc(ALIGN(tmp, c->min_io_size), GFP_KERNEL);
+	if (!idx)
+		return -ENOMEM;
+
+	c->key_fmt = UBIFS_SIMPLE_KEY_FMT;
+	c->key_hash = key_r5_hash;
+
+	idx->ch.node_type = UBIFS_IDX_NODE;
+	idx->child_cnt = cpu_to_le16(1);
+	ino_key_init(c, &key, UBIFS_ROOT_INO);
+	br = ubifs_idx_branch(c, idx, 0);
+	key_write_idx(c, &key, &br->key);
+	br->lnum = cpu_to_le32(main_first + DEFAULT_DATA_LEB);
+	br->len  = cpu_to_le32(UBIFS_INO_NODE_SZ);
+	err = ubifs_write_node(c, idx, tmp, main_first + DEFAULT_IDX_LEB, 0,
+			       UBI_UNKNOWN);
+	kfree(idx);
+	if (err)
+		return err;
+
+	dbg_gen("default root indexing node created LEB %d:0",
+		main_first + DEFAULT_IDX_LEB);
+
+	/* Create default root inode */
+	tmp = ALIGN(UBIFS_INO_NODE_SZ, c->min_io_size);
+	ino = kzalloc(tmp, GFP_KERNEL);
+	if (!ino)
+		return -ENOMEM;
+
+	ino_key_init_flash(c, &ino->key, UBIFS_ROOT_INO);
+	ino->ch.node_type = UBIFS_INO_NODE;
+	ino->creat_sqnum = cpu_to_le64(++c->max_sqnum);
+	ino->nlink = cpu_to_le32(2);
+	tmp = cpu_to_le64(CURRENT_TIME_SEC.tv_sec);
+	ino->atime_sec   = tmp;
+	ino->ctime_sec   = tmp;
+	ino->mtime_sec   = tmp;
+	ino->atime_nsec  = 0;
+	ino->ctime_nsec  = 0;
+	ino->mtime_nsec  = 0;
+	ino->mode = cpu_to_le32(S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO);
+	ino->size = cpu_to_le64(UBIFS_INO_NODE_SZ);
+
+	/* Set compression enabled by default */
+	ino->flags = cpu_to_le32(UBIFS_COMPR_FL);
+
+	err = ubifs_write_node(c, ino, UBIFS_INO_NODE_SZ,
+			       main_first + DEFAULT_DATA_LEB, 0,
+			       UBI_UNKNOWN);
+	kfree(ino);
+	if (err)
+		return err;
+
+	dbg_gen("root inode created at LEB %d:0",
+		main_first + DEFAULT_DATA_LEB);
+
+	/*
+	 * The first node in the log has to be the commit start node. This is
+	 * always the case during normal file-system operation. Write a fake
+	 * commit start node to the log.
+	 */
+	tmp = ALIGN(UBIFS_CS_NODE_SZ, c->min_io_size);
+	cs = kzalloc(tmp, GFP_KERNEL);
+	if (!cs)
+		return -ENOMEM;
+
+	cs->ch.node_type = UBIFS_CS_NODE;
+	err = ubifs_write_node(c, cs, UBIFS_CS_NODE_SZ, UBIFS_LOG_LNUM,
+			       0, UBI_UNKNOWN);
+	kfree(cs);
+
+	ubifs_msg("default file-system created");
+	return 0;
+}
+
+/**
+ * validate_sb - validate superblock node.
+ * @c: UBIFS file-system description object
+ * @sup: superblock node
+ *
+ * This function validates superblock node @sup. Since most of data was read
+ * from the superblock and stored in @c, the function validates fields in @c
+ * instead. Returns zero in case of success and %-EINVAL in case of validation
+ * failure.
+ */
+static int validate_sb(struct ubifs_info *c, struct ubifs_sb_node *sup)
+{
+	long long max_bytes;
+	int err = 1;
+
+	if (!c->key_hash) {
+		err = 2;
+		goto failed;
+	}
+
+	if (sup->key_fmt != UBIFS_SIMPLE_KEY_FMT) {
+		err = 3;
+		goto failed;
+	}
+
+	if (le32_to_cpu(sup->min_io_size) != c->min_io_size) {
+		ubifs_err("min. I/O unit mismatch: %d in superblock, %d real",
+			  le32_to_cpu(sup->min_io_size), c->min_io_size);
+		goto failed;
+	}
+
+	if (le32_to_cpu(sup->leb_size) != c->leb_size) {
+		ubifs_err("LEB size mismatch: %d in superblock, %d real",
+			  le32_to_cpu(sup->leb_size), c->leb_size);
+		goto failed;
+	}
+
+	if (c->leb_cnt < UBIFS_MIN_LEB_CNT || c->leb_cnt > c->vi.size) {
+		ubifs_err("bad LEB count: %d in superblock, %d on UBI volume, "
+			  "%d minimum required", c->leb_cnt, c->vi.size,
+			  UBIFS_MIN_LEB_CNT);
+		goto failed;
+	}
+
+	if (c->max_leb_cnt < c->leb_cnt) {
+		ubifs_err("max. LEB count %d less than LEB count %d",
+			  c->max_leb_cnt, c->leb_cnt);
+		goto failed;
+	}
+
+	if (c->log_lebs < UBIFS_MIN_LOG_LEBS ||
+	    c->lpt_lebs < UBIFS_MIN_LPT_LEBS ||
+	    c->orph_lebs < UBIFS_MIN_ORPH_LEBS ||
+	    c->main_lebs < UBIFS_MIN_MAIN_LEBS) {
+		err = 6;
+		goto failed;
+	}
+
+	if (c->main_lebs < UBIFS_MIN_MAIN_LEBS) {
+		err = 7;
+		goto failed;
+	}
+
+	if (c->max_bud_bytes < (long long)c->leb_size * UBIFS_MIN_BUD_LEBS ||
+	    c->max_bud_bytes > (long long)c->leb_size * c->main_lebs) {
+		err = 8;
+		goto failed;
+	}
+
+	if (c->jhead_cnt < NONDATA_JHEADS_CNT + 1 ||
+	    c->jhead_cnt > NONDATA_JHEADS_CNT + UBIFS_MAX_JHEADS) {
+		err = 9;
+		goto failed;
+	}
+
+	if (c->fanout < UBIFS_MIN_FANOUT ||
+	    ubifs_idx_node_sz(c, c->fanout) > c->leb_size) {
+		err = 10;
+		goto failed;
+	}
+
+	if (c->lsave_cnt < 0 || (c->lsave_cnt > DEFAULT_LSAVE_CNT &&
+	    c->lsave_cnt > c->max_leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS -
+	    c->log_lebs - c->lpt_lebs - c->orph_lebs)) {
+		err = 11;
+		goto failed;
+	}
+
+	if (UBIFS_SB_LEBS + UBIFS_MST_LEBS + c->log_lebs + c->lpt_lebs +
+	    c->orph_lebs + c->main_lebs != c->leb_cnt) {
+		err = 12;
+		goto failed;
+	}
+
+	if (c->default_compr < 0 || c->default_compr >= UBIFS_COMPR_TYPES_CNT) {
+		err = 13;
+		goto failed;
+	}
+
+	max_bytes = c->main_lebs * (long long)c->leb_size;
+	if (c->rp_size < 0 || max_bytes < c->rp_size) {
+		err = 14;
+		goto failed;
+	}
+
+	if (le32_to_cpu(sup->time_gran) > 1000000000 ||
+	    le32_to_cpu(sup->time_gran) < 1) {
+		err = 15;
+		goto failed;
+	}
+
+	return 0;
+
+failed:
+	ubifs_err("bad superblock, error %d", err);
+	dbg_dump_node(c, sup);
+	return -EINVAL;
+}
+
+/**
+ * ubifs_read_sb_node - read superblock node.
+ * @c: UBIFS file-system description object
+ *
+ * This function returns a pointer to the superblock node or a negative error
+ * code.
+ */
+struct ubifs_sb_node *ubifs_read_sb_node(struct ubifs_info *c)
+{
+	struct ubifs_sb_node *sup;
+	int err;
+
+	sup = kmalloc(ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size), GFP_NOFS);
+	if (!sup)
+		return ERR_PTR(-ENOMEM);
+
+	err = ubifs_read_node(c, sup, UBIFS_SB_NODE, UBIFS_SB_NODE_SZ,
+			      UBIFS_SB_LNUM, 0);
+	if (err) {
+		kfree(sup);
+		return ERR_PTR(err);
+	}
+
+	return sup;
+}
+
+/**
+ * ubifs_write_sb_node - write superblock node.
+ * @c: UBIFS file-system description object
+ * @sup: superblock node read with 'ubifs_read_sb_node()'
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+int ubifs_write_sb_node(struct ubifs_info *c, struct ubifs_sb_node *sup)
+{
+	int len = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);
+
+	ubifs_prepare_node(c, sup, UBIFS_SB_NODE_SZ, 1);
+	return ubi_leb_change(c->ubi, UBIFS_SB_LNUM, sup, len, UBI_LONGTERM);
+}
+
+/**
+ * ubifs_read_superblock - read superblock.
+ * @c: UBIFS file-system description object
+ *
+ * This function finds, reads and checks the superblock. If an empty UBI volume
+ * is being mounted, this function creates default superblock. Returns zero in
+ * case of success, and a negative error code in case of failure.
+ */
+int ubifs_read_superblock(struct ubifs_info *c)
+{
+	int err, sup_flags;
+	struct ubifs_sb_node *sup;
+
+	if (c->empty) {
+		err = create_default_filesystem(c);
+		if (err)
+			return err;
+	}
+
+	sup = ubifs_read_sb_node(c);
+	if (IS_ERR(sup))
+		return PTR_ERR(sup);
+
+	/*
+	 * The software supports all previous versions but not future versions,
+	 * due to the unavailability of time-travelling equipment.
+	 */
+	c->fmt_vers = le32_to_cpu(sup->fmt_vers);
+	if (c->fmt_vers > UBIFS_FORMAT_VERSION) {
+		ubifs_err("on-flash format version is %d, but software only "
+			  "supports up to version %d", c->fmt_vers,
+			  UBIFS_FORMAT_VERSION);
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (c->fmt_vers == 1) {
+		ubifs_err("this on-flash format is not supported");
+		err = -EINVAL;
+		goto out;
+	}
+
+	switch (sup->key_hash) {
+	case UBIFS_KEY_HASH_R5:
+		c->key_hash = key_r5_hash;
+		c->key_hash_type = UBIFS_KEY_HASH_R5;
+		break;
+
+	case UBIFS_KEY_HASH_TEST:
+		c->key_hash = key_test_hash;
+		c->key_hash_type = UBIFS_KEY_HASH_TEST;
+		break;
+	};
+
+	c->key_fmt = sup->key_fmt;
+
+	switch (c->key_fmt) {
+	case UBIFS_SIMPLE_KEY_FMT:
+		c->key_len = UBIFS_SK_LEN;
+		break;
+	default:
+		ubifs_err("unsupported key format");
+		err = -EINVAL;
+		goto out;
+	}
+
+	c->leb_cnt       = le32_to_cpu(sup->leb_cnt);
+	c->max_leb_cnt   = le32_to_cpu(sup->max_leb_cnt);
+	c->max_bud_bytes = le64_to_cpu(sup->max_bud_bytes);
+	c->log_lebs      = le32_to_cpu(sup->log_lebs);
+	c->lpt_lebs      = le32_to_cpu(sup->lpt_lebs);
+	c->orph_lebs     = le32_to_cpu(sup->orph_lebs);
+	c->jhead_cnt     = le32_to_cpu(sup->jhead_cnt) + NONDATA_JHEADS_CNT;
+	c->fanout        = le32_to_cpu(sup->fanout);
+	c->lsave_cnt     = le32_to_cpu(sup->lsave_cnt);
+	c->default_compr = le16_to_cpu(sup->default_compr);
+	c->rp_size       = le64_to_cpu(sup->rp_size);
+	c->rp_uid        = le32_to_cpu(sup->rp_uid);
+	c->rp_gid        = le32_to_cpu(sup->rp_gid);
+	sup_flags        = le32_to_cpu(sup->flags);
+
+	c->vfs_sb->s_time_gran = le32_to_cpu(sup->time_gran);
+
+	c->big_lpt = !!(sup_flags & UBIFS_FLG_BIGLPT);
+
+	/* Automatically increase file system size to the maximum size */
+	c->old_leb_cnt = c->leb_cnt;
+	if (c->leb_cnt < c->vi.size && c->leb_cnt < c->max_leb_cnt) {
+		c->leb_cnt = min_t(int, c->max_leb_cnt, c->vi.size);
+		if (c->vfs_sb->s_flags & MS_RDONLY)
+			dbg_mnt("Auto resizing (ro) from %d LEBs to %d LEBs",
+				c->old_leb_cnt,	c->leb_cnt);
+		else {
+			dbg_mnt("Auto resizing (sb) from %d LEBs to %d LEBs",
+				c->old_leb_cnt, c->leb_cnt);
+			sup->leb_cnt = cpu_to_le32(c->leb_cnt);
+			err = ubifs_write_sb_node(c, sup);
+			if (err)
+				goto out;
+			c->old_leb_cnt = c->leb_cnt;
+		}
+	}
+
+	c->log_bytes = (long long)c->log_lebs * c->leb_size;
+	c->log_last = UBIFS_LOG_LNUM + c->log_lebs - 1;
+	c->lpt_first = UBIFS_LOG_LNUM + c->log_lebs;
+	c->lpt_last = c->lpt_first + c->lpt_lebs - 1;
+	c->orph_first = c->lpt_last + 1;
+	c->orph_last = c->orph_first + c->orph_lebs - 1;
+	c->main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS;
+	c->main_lebs -= c->log_lebs + c->lpt_lebs + c->orph_lebs;
+	c->main_first = c->leb_cnt - c->main_lebs;
+	c->report_rp_size = ubifs_reported_space(c, c->rp_size);
+
+	err = validate_sb(c, sup);
+out:
+	kfree(sup);
+	return err;
+}
-- 
1.5.4.1

