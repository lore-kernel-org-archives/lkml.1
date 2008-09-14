Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYINTRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYINTRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYINTKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:10:33 -0400
Received: from sh.osrg.net ([192.16.179.4]:53344 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbYINTJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:09:32 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Koji Sato <sato.koji@lab.ntt.co.jp>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 06/27] nilfs2: direct block mapping
Date: Mon, 15 Sep 2008 04:08:03 +0900
Message-Id: <1221419304-18572-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1221419304-18572-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koji Sato <sato.koji@lab.ntt.co.jp>

This adds block mappings using direct pointers which are stored in the
i_bmap array of inode.

Signed-off-by: Koji Sato <sato.koji@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/direct.c |  429 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/direct.h |   78 ++++++++++
 2 files changed, 507 insertions(+), 0 deletions(-)
 create mode 100644 fs/nilfs2/direct.c
 create mode 100644 fs/nilfs2/direct.h

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
new file mode 100644
index 0000000..303d7f1
--- /dev/null
+++ b/fs/nilfs2/direct.c
@@ -0,0 +1,429 @@
+/*
+ * direct.c - NILFS direct block pointer.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/errno.h>
+#include "nilfs.h"
+#include "page.h"
+#include "direct.h"
+#include "alloc.h"
+
+static inline __le64 *nilfs_direct_dptrs(const struct nilfs_direct *direct)
+{
+	return (__le64 *)
+		((struct nilfs_direct_node *)direct->d_bmap.b_u.u_data + 1);
+}
+
+static inline __u64
+nilfs_direct_get_ptr(const struct nilfs_direct *direct, __u64 key)
+{
+	return nilfs_bmap_dptr_to_ptr(*(nilfs_direct_dptrs(direct) + key));
+}
+
+static inline void nilfs_direct_set_ptr(struct nilfs_direct *direct,
+					__u64 key, __u64 ptr)
+{
+	*(nilfs_direct_dptrs(direct) + key) = nilfs_bmap_ptr_to_dptr(ptr);
+}
+
+static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
+			       __u64 key, int level, __u64 *ptrp)
+{
+	struct nilfs_direct *direct;
+	__u64 ptr;
+
+	direct = (struct nilfs_direct *)bmap;
+	if ((key > NILFS_DIRECT_KEY_MAX) ||
+	    (level != 1) ||	/* XXX: use macro for level 1 */
+	    ((ptr = nilfs_direct_get_ptr(direct, key)) ==
+	     NILFS_BMAP_INVALID_PTR))
+		return -ENOENT;
+
+	if (ptrp != NULL)
+		*ptrp = ptr;
+	return 0;
+}
+
+static __u64
+nilfs_direct_find_target_v(const struct nilfs_direct *direct, __u64 key)
+{
+	__u64 ptr;
+
+	ptr = nilfs_bmap_find_target_seq(&direct->d_bmap, key);
+	if (ptr != NILFS_BMAP_INVALID_PTR)
+		/* sequential access */
+		return ptr;
+	else
+		/* block group */
+		return nilfs_bmap_find_target_in_group(&direct->d_bmap);
+}
+
+static void nilfs_direct_set_target_v(struct nilfs_direct *direct,
+				      __u64 key, __u64 ptr)
+{
+	direct->d_bmap.b_last_allocated_key = key;
+	direct->d_bmap.b_last_allocated_ptr = ptr;
+}
+
+static int nilfs_direct_prepare_insert(struct nilfs_direct *direct,
+				       __u64 key,
+				       union nilfs_bmap_ptr_req *req,
+				       struct nilfs_bmap_stats *stats)
+{
+	int ret;
+
+	if (direct->d_ops->dop_find_target != NULL)
+		req->bpr_ptr = (*direct->d_ops->dop_find_target)(direct, key);
+	ret = (*direct->d_bmap.b_pops->bpop_prepare_alloc_ptr)(&direct->d_bmap,
+							       req);
+	if (ret < 0)
+		return ret;
+
+	stats->bs_nblocks = 1;
+	return 0;
+}
+
+static void nilfs_direct_commit_insert(struct nilfs_direct *direct,
+				       union nilfs_bmap_ptr_req *req,
+				       __u64 key, __u64 ptr)
+{
+	struct buffer_head *bh;
+
+	/* ptr must be a pointer to a buffer head. */
+	bh = (struct buffer_head *)((unsigned long)ptr);
+	set_buffer_nilfs_volatile(bh);
+
+	if (direct->d_bmap.b_pops->bpop_commit_alloc_ptr != NULL)
+		(*direct->d_bmap.b_pops->bpop_commit_alloc_ptr)(
+			&direct->d_bmap, req);
+	nilfs_direct_set_ptr(direct, key, req->bpr_ptr);
+
+	if (!nilfs_bmap_dirty(&direct->d_bmap))
+		nilfs_bmap_set_dirty(&direct->d_bmap);
+
+	if (direct->d_ops->dop_set_target != NULL)
+		(*direct->d_ops->dop_set_target)(direct, key, req->bpr_ptr);
+}
+
+static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
+{
+	struct nilfs_direct *direct;
+	union nilfs_bmap_ptr_req req;
+	struct nilfs_bmap_stats stats;
+	int ret;
+
+	direct = (struct nilfs_direct *)bmap;
+	if (key > NILFS_DIRECT_KEY_MAX)
+		return -ENOENT;
+	if (nilfs_direct_get_ptr(direct, key) != NILFS_BMAP_INVALID_PTR)
+		return -EEXIST;
+
+	ret = nilfs_direct_prepare_insert(direct, key, &req, &stats);
+	if (ret < 0)
+		return ret;
+	nilfs_direct_commit_insert(direct, &req, key, ptr);
+	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
+
+	return 0;
+}
+
+static int nilfs_direct_prepare_delete(struct nilfs_direct *direct,
+				       union nilfs_bmap_ptr_req *req,
+				       __u64 key,
+				       struct nilfs_bmap_stats *stats)
+{
+	int ret;
+
+	if (direct->d_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
+		req->bpr_ptr = nilfs_direct_get_ptr(direct, key);
+		ret = (*direct->d_bmap.b_pops->bpop_prepare_end_ptr)(
+			&direct->d_bmap, req);
+		if (ret < 0)
+			return ret;
+	}
+
+	stats->bs_nblocks = 1;
+	return 0;
+}
+
+static void nilfs_direct_commit_delete(struct nilfs_direct *direct,
+				       union nilfs_bmap_ptr_req *req,
+				       __u64 key)
+{
+	if (direct->d_bmap.b_pops->bpop_commit_end_ptr != NULL)
+		(*direct->d_bmap.b_pops->bpop_commit_end_ptr)(
+			&direct->d_bmap, req);
+	nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
+}
+
+static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
+{
+	struct nilfs_direct *direct;
+	union nilfs_bmap_ptr_req req;
+	struct nilfs_bmap_stats stats;
+	int ret;
+
+	direct = (struct nilfs_direct *)bmap;
+	if ((key > NILFS_DIRECT_KEY_MAX) ||
+	    nilfs_direct_get_ptr(direct, key) == NILFS_BMAP_INVALID_PTR)
+		return -ENOENT;
+
+	ret = nilfs_direct_prepare_delete(direct, &req, key, &stats);
+	if (ret < 0)
+		return ret;
+	nilfs_direct_commit_delete(direct, &req, key);
+	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
+
+	return 0;
+}
+
+static int nilfs_direct_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
+{
+	struct nilfs_direct *direct;
+	__u64 key, lastkey;
+
+	direct = (struct nilfs_direct *)bmap;
+	lastkey = NILFS_DIRECT_KEY_MAX + 1;
+	for (key = NILFS_DIRECT_KEY_MIN; key <= NILFS_DIRECT_KEY_MAX; key++)
+		if (nilfs_direct_get_ptr(direct, key) !=
+		    NILFS_BMAP_INVALID_PTR)
+			lastkey = key;
+
+	if (lastkey == NILFS_DIRECT_KEY_MAX + 1)
+		return -ENOENT;
+
+	BUG_ON(keyp == NULL);
+	*keyp = lastkey;
+
+	return 0;
+}
+
+static int nilfs_direct_check_insert(const struct nilfs_bmap *bmap, __u64 key)
+{
+	return key > NILFS_DIRECT_KEY_MAX;
+}
+
+static int nilfs_direct_gather_data(struct nilfs_bmap *bmap,
+				    __u64 *keys, __u64 *ptrs, int nitems)
+{
+	struct nilfs_direct *direct;
+	__u64 key;
+	__u64 ptr;
+	int n;
+
+	direct = (struct nilfs_direct *)bmap;
+	if (nitems > NILFS_DIRECT_NBLOCKS)
+		nitems = NILFS_DIRECT_NBLOCKS;
+	n = 0;
+	for (key = 0; key < nitems; key++) {
+		ptr = nilfs_direct_get_ptr(direct, key);
+		if (ptr != NILFS_BMAP_INVALID_PTR) {
+			keys[n] = key;
+			ptrs[n] = ptr;
+			n++;
+		}
+	}
+	return n;
+}
+
+int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
+				    __u64 key, __u64 *keys, __u64 *ptrs,
+				    int n, __u64 low, __u64 high)
+{
+	struct nilfs_direct *direct;
+	__le64 *dptrs;
+	int ret, i, j;
+
+	/* no need to allocate any resource for conversion */
+
+	/* delete */
+	ret = (*bmap->b_ops->bop_delete)(bmap, key);
+	if (ret < 0)
+		return ret;
+
+	/* free resources */
+	if (bmap->b_ops->bop_clear != NULL)
+		(*bmap->b_ops->bop_clear)(bmap);
+
+	/* convert */
+	direct = (struct nilfs_direct *)bmap;
+	dptrs = nilfs_direct_dptrs(direct);
+	for (i = 0, j = 0; i < NILFS_DIRECT_NBLOCKS; i++) {
+		if ((j < n) && (i == keys[j])) {
+			dptrs[i] = (i != key) ?
+				nilfs_bmap_ptr_to_dptr(ptrs[j]) :
+				NILFS_BMAP_INVALID_PTR;
+			j++;
+		} else
+			dptrs[i] = NILFS_BMAP_INVALID_PTR;
+	}
+
+	nilfs_direct_init(bmap, low, high);
+
+	return 0;
+}
+
+static int nilfs_direct_propagate_v(struct nilfs_direct *direct,
+				    struct buffer_head *bh)
+{
+	union nilfs_bmap_ptr_req oldreq, newreq;
+	__u64 key;
+	__u64 ptr;
+	int ret;
+
+	key = nilfs_bmap_data_get_key(&direct->d_bmap, bh);
+	ptr = nilfs_direct_get_ptr(direct, key);
+	if (!buffer_nilfs_volatile(bh)) {
+		oldreq.bpr_ptr = ptr;
+		newreq.bpr_ptr = ptr;
+		ret = nilfs_bmap_prepare_update(&direct->d_bmap, &oldreq,
+						&newreq);
+		if (ret < 0)
+			return ret;
+		nilfs_bmap_commit_update(&direct->d_bmap, &oldreq, &newreq);
+		set_buffer_nilfs_volatile(bh);
+		nilfs_direct_set_ptr(direct, key, newreq.bpr_ptr);
+	} else
+		ret = nilfs_bmap_mark_dirty(&direct->d_bmap, ptr);
+
+	return ret;
+}
+
+static int nilfs_direct_propagate(const struct nilfs_bmap *bmap,
+				  struct buffer_head *bh)
+{
+	struct nilfs_direct *direct;
+
+	direct = (struct nilfs_direct *)bmap;
+	return (direct->d_ops->dop_propagate != NULL) ?
+		(*direct->d_ops->dop_propagate)(direct, bh) :
+		0;
+}
+
+static int nilfs_direct_assign_v(struct nilfs_direct *direct,
+				 __u64 key, __u64 ptr,
+				 struct buffer_head **bh,
+				 sector_t blocknr,
+				 union nilfs_binfo *binfo)
+{
+	union nilfs_bmap_ptr_req req;
+	int ret;
+
+	req.bpr_ptr = ptr;
+	ret = (*direct->d_bmap.b_pops->bpop_prepare_start_ptr)(
+		&direct->d_bmap, &req);
+	if (ret < 0)
+		return ret;
+	(*direct->d_bmap.b_pops->bpop_commit_start_ptr)(&direct->d_bmap,
+							&req, blocknr);
+
+	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
+	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+
+	return 0;
+}
+
+static int nilfs_direct_assign_p(struct nilfs_direct *direct,
+				 __u64 key, __u64 ptr,
+				 struct buffer_head **bh,
+				 sector_t blocknr,
+				 union nilfs_binfo *binfo)
+{
+	nilfs_direct_set_ptr(direct, key, blocknr);
+
+	binfo->bi_dat.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_dat.bi_level = 0;
+
+	return 0;
+}
+
+static int nilfs_direct_assign(struct nilfs_bmap *bmap,
+			       struct buffer_head **bh,
+			       sector_t blocknr,
+			       union nilfs_binfo *binfo)
+{
+	struct nilfs_direct *direct;
+	__u64 key;
+	__u64 ptr;
+
+	direct = (struct nilfs_direct *)bmap;
+	key = nilfs_bmap_data_get_key(bmap, *bh);
+	BUG_ON(key > NILFS_DIRECT_KEY_MAX);
+	ptr = nilfs_direct_get_ptr(direct, key);
+	BUG_ON(ptr == NILFS_BMAP_INVALID_PTR);
+
+	return (*direct->d_ops->dop_assign)(direct, key, ptr, bh,
+					    blocknr, binfo);
+}
+
+static const struct nilfs_bmap_operations nilfs_direct_ops = {
+	.bop_lookup		=	nilfs_direct_lookup,
+	.bop_insert		=	nilfs_direct_insert,
+	.bop_delete		=	nilfs_direct_delete,
+	.bop_clear		=	NULL,
+
+	.bop_propagate		=	nilfs_direct_propagate,
+
+	.bop_lookup_dirty_buffers	=	NULL,
+
+	.bop_assign		=	nilfs_direct_assign,
+	.bop_mark		=	NULL,
+
+	.bop_last_key		=	nilfs_direct_last_key,
+	.bop_check_insert	=	nilfs_direct_check_insert,
+	.bop_check_delete	=	NULL,
+	.bop_gather_data	=	nilfs_direct_gather_data,
+};
+
+
+static const struct nilfs_direct_operations nilfs_direct_ops_v = {
+	.dop_find_target	=	nilfs_direct_find_target_v,
+	.dop_set_target		=	nilfs_direct_set_target_v,
+	.dop_propagate		=	nilfs_direct_propagate_v,
+	.dop_assign		=	nilfs_direct_assign_v,
+};
+
+static const struct nilfs_direct_operations nilfs_direct_ops_p = {
+	.dop_find_target	=	NULL,
+	.dop_set_target		=	NULL,
+	.dop_propagate		=	NULL,
+	.dop_assign		=	nilfs_direct_assign_p,
+};
+
+int nilfs_direct_init(struct nilfs_bmap *bmap, __u64 low, __u64 high)
+{
+	struct nilfs_direct *direct;
+
+	direct = (struct nilfs_direct *)bmap;
+	bmap->b_ops = &nilfs_direct_ops;
+	bmap->b_low = low;
+	bmap->b_high = high;
+	switch (bmap->b_inode->i_ino) {
+	case NILFS_DAT_INO:
+		direct->d_ops = &nilfs_direct_ops_p;
+		break;
+	default:
+		direct->d_ops = &nilfs_direct_ops_v;
+		break;
+	}
+
+	return 0;
+}
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
new file mode 100644
index 0000000..45d2c5c
--- /dev/null
+++ b/fs/nilfs2/direct.h
@@ -0,0 +1,78 @@
+/*
+ * direct.h - NILFS direct block pointer.
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_DIRECT_H
+#define _NILFS_DIRECT_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include "bmap.h"
+
+
+struct nilfs_direct;
+
+/**
+ * struct nilfs_direct_operations - direct mapping operation table
+ */
+struct nilfs_direct_operations {
+	__u64 (*dop_find_target)(const struct nilfs_direct *, __u64);
+	void (*dop_set_target)(struct nilfs_direct *, __u64, __u64);
+	int (*dop_propagate)(struct nilfs_direct *, struct buffer_head *);
+	int (*dop_assign)(struct nilfs_direct *, __u64, __u64,
+			  struct buffer_head **, sector_t,
+			  union nilfs_binfo *);
+};
+
+/**
+ * struct nilfs_direct_node - direct node
+ * @dn_flags: flags
+ * @dn_pad: padding
+ */
+struct nilfs_direct_node {
+	__u8 dn_flags;
+	__u8 pad[7];
+};
+
+/**
+ * struct nilfs_direct - direct mapping
+ * @d_bmap: bmap structure
+ * @d_ops: direct mapping operation table
+ */
+struct nilfs_direct {
+	struct nilfs_bmap d_bmap;
+
+	/* direct-mapping-specific members */
+	const struct nilfs_direct_operations *d_ops;
+};
+
+
+#define NILFS_DIRECT_NBLOCKS	(NILFS_BMAP_SIZE / sizeof(__le64) - 1)
+#define NILFS_DIRECT_KEY_MIN	0
+#define NILFS_DIRECT_KEY_MAX	(NILFS_DIRECT_NBLOCKS - 1)
+
+
+int nilfs_direct_init(struct nilfs_bmap *, __u64, __u64);
+int nilfs_direct_delete_and_convert(struct nilfs_bmap *, __u64, __u64 *,
+				    __u64 *, int, __u64, __u64);
+
+
+#endif	/* _NILFS_DIRECT_H */
-- 
1.5.6.3

