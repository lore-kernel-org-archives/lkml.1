Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZFJJkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZFJJkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZFJJiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090AbZFJJiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/24] GFS2: Improve resource group error handling
Date: Wed, 10 Jun 2009 09:30:52 +0100
Message-Id: <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the error handling in the case where we
discover that the summary information in the resource group
doesn't match the bitmap information while in the process of
allocating blocks. Originally this resulted in a kernel bug,
but this patch changes that so that we return -EIO and print
some messages explaining what went wrong, and how to fix it.

We also remember locally not to try and allocate from the
same rgrp again, so that a subsequent allocation in a
different rgrp should succeed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 3a5d3f8..253e1a3 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -136,7 +136,9 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 		   and write it out to disk */
 
 		unsigned int n = 1;
-		block = gfs2_alloc_block(ip, &n);
+		error = gfs2_alloc_block(ip, &block, &n);
+		if (error)
+			goto out_brelse;
 		if (isdir) {
 			gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), block, 1);
 			error = gfs2_dir_get_new_buffer(ip, block, &bh);
@@ -476,8 +478,11 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	blks = dblks + iblks;
 	i = sheight;
 	do {
+		int error;
 		n = blks - alloced;
-		bn = gfs2_alloc_block(ip, &n);
+		error = gfs2_alloc_block(ip, &bn, &n);
+		if (error)
+			return error;
 		alloced += n;
 		if (state != ALLOC_DATA || gfs2_is_jdata(ip))
 			gfs2_trans_add_unrevoke(sdp, bn, n);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index aef4d0c..297d7e5 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -803,13 +803,20 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int n = 1;
-	u64 bn = gfs2_alloc_block(ip, &n);
-	struct buffer_head *bh = gfs2_meta_new(ip->i_gl, bn);
+	u64 bn;
+	int error;
+	struct buffer_head *bh;
 	struct gfs2_leaf *leaf;
 	struct gfs2_dirent *dent;
 	struct qstr name = { .name = "", .len = 0, .hash = 0 };
+
+	error = gfs2_alloc_block(ip, &bn, &n);
+	if (error)
+		return NULL;
+	bh = gfs2_meta_new(ip->i_gl, bn);
 	if (!bh)
 		return NULL;
+
 	gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, 1);
 	gfs2_trans_add_bh(ip->i_gl, bh, 1);
 	gfs2_metatype_set(bh, GFS2_METATYPE_LF, GFS2_FORMAT_LF);
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 899763a..07ea952 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -582,8 +582,11 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	struct gfs2_ea_header *ea;
 	unsigned int n = 1;
 	u64 block;
+	int error;
 
-	block = gfs2_alloc_block(ip, &n);
+	error = gfs2_alloc_block(ip, &block, &n);
+	if (error)
+		return error;
 	gfs2_trans_add_unrevoke(sdp, block, 1);
 	*bhp = gfs2_meta_new(ip->i_gl, block);
 	gfs2_trans_add_bh(ip->i_gl, *bhp, 1);
@@ -617,6 +620,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 		    struct gfs2_ea_request *er)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	int error;
 
 	ea->ea_data_len = cpu_to_be32(er->er_data_len);
 	ea->ea_name_len = er->er_name_len;
@@ -642,7 +646,9 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			int mh_size = sizeof(struct gfs2_meta_header);
 			unsigned int n = 1;
 
-			block = gfs2_alloc_block(ip, &n);
+			error = gfs2_alloc_block(ip, &block, &n);
+			if (error)
+				return error;
 			gfs2_trans_add_unrevoke(sdp, block, 1);
 			bh = gfs2_meta_new(ip->i_gl, block);
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
@@ -963,7 +969,9 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	} else {
 		u64 blk;
 		unsigned int n = 1;
-		blk = gfs2_alloc_block(ip, &n);
+		error = gfs2_alloc_block(ip, &blk, &n);
+		if (error)
+			return error;
 		gfs2_trans_add_unrevoke(sdp, blk, 1);
 		indbh = gfs2_meta_new(ip->i_gl, blk);
 		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 70f87f4..d5e4ab1 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -310,24 +310,6 @@ static void rgrp_go_unlock(struct gfs2_holder *gh)
 }
 
 /**
- * rgrp_go_dump - print out an rgrp
- * @seq: The iterator
- * @gl: The glock in question
- *
- */
-
-static int rgrp_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
-{
-	const struct gfs2_rgrpd *rgd = gl->gl_object;
-	if (rgd == NULL)
-		return 0;
-	gfs2_print_dbg(seq, " R: n:%llu f:%02x b:%u/%u i:%u\n",
-		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
-		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes);
-	return 0;
-}
-
-/**
  * trans_go_sync - promote/demote the transaction glock
  * @gl: the glock
  * @state: the requested state
@@ -410,7 +392,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
 	.go_unlock = rgrp_go_unlock,
-	.go_dump = rgrp_go_dump,
+	.go_dump = gfs2_rgrp_dump,
 	.go_type = LM_TYPE_RGRP,
 	.go_min_hold_time = HZ / 5,
 };
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0060e95..de50d86 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -92,9 +92,10 @@ struct gfs2_rgrpd {
 	unsigned int rd_bh_count;
 	u32 rd_last_alloc;
 	unsigned char rd_flags;
-#define GFS2_RDF_CHECK        0x01      /* Need to check for unlinked inodes */
-#define GFS2_RDF_NOALLOC      0x02      /* rg prohibits allocation */
-#define GFS2_RDF_UPTODATE     0x04      /* rg is up to date */
+#define GFS2_RDF_CHECK		0x10000000 /* check for unlinked inodes */
+#define GFS2_RDF_UPTODATE	0x20000000 /* rg is up to date */
+#define GFS2_RDF_ERROR		0x40000000 /* error in rg */
+#define GFS2_RDF_MASK		0xf0000000 /* mask for internal flags */
 };
 
 enum gfs2_state_bits {
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5650382..fbacf09 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -701,10 +701,7 @@ static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 	u32 rg_flags;
 
 	rg_flags = be32_to_cpu(str->rg_flags);
-	if (rg_flags & GFS2_RGF_NOALLOC)
-		rgd->rd_flags |= GFS2_RDF_NOALLOC;
-	else
-		rgd->rd_flags &= ~GFS2_RDF_NOALLOC;
+	rg_flags &= ~GFS2_RDF_MASK;
 	rgd->rd_free = be32_to_cpu(str->rg_free);
 	rgd->rd_dinodes = be32_to_cpu(str->rg_dinodes);
 	rgd->rd_igeneration = be64_to_cpu(str->rg_igeneration);
@@ -713,11 +710,8 @@ static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 {
 	struct gfs2_rgrp *str = buf;
-	u32 rg_flags = 0;
 
-	if (rgd->rd_flags & GFS2_RDF_NOALLOC)
-		rg_flags |= GFS2_RGF_NOALLOC;
-	str->rg_flags = cpu_to_be32(rg_flags);
+	str->rg_flags = cpu_to_be32(rgd->rd_flags & ~GFS2_RDF_MASK);
 	str->rg_free = cpu_to_be32(rgd->rd_free);
 	str->rg_dinodes = cpu_to_be32(rgd->rd_dinodes);
 	str->__pad = cpu_to_be32(0);
@@ -942,7 +936,7 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	int ret = 0;
 
-	if (rgd->rd_flags & GFS2_RDF_NOALLOC)
+	if (rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
 		return 0;
 
 	spin_lock(&sdp->sd_rindex_spin);
@@ -1435,13 +1429,33 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 }
 
 /**
- * gfs2_alloc_block - Allocate a block
+ * gfs2_rgrp_dump - print out an rgrp
+ * @seq: The iterator
+ * @gl: The glock in question
+ *
+ */
+
+int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl)
+{
+	const struct gfs2_rgrpd *rgd = gl->gl_object;
+	if (rgd == NULL)
+		return 0;
+	gfs2_print_dbg(seq, " R: n:%llu f:%02x b:%u/%u i:%u\n",
+		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
+		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes);
+	return 0;
+}
+
+/**
+ * gfs2_alloc_block - Allocate one or more blocks
  * @ip: the inode to allocate the block for
+ * @bn: Used to return the starting block number
+ * @n: requested number of blocks/extent length (value/result)
  *
- * Returns: the allocated block
+ * Returns: 0 or error
  */
 
-u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
+int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
@@ -1457,7 +1471,10 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 		goal = rgd->rd_last_alloc;
 
 	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED, n);
-	BUG_ON(blk == BFITNOENT);
+
+	/* Since all blocks are reserved in advance, this shouldn't happen */
+	if (blk == BFITNOENT)
+		goto rgrp_error;
 
 	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
@@ -1469,7 +1486,9 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 		di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_goal);
 		brelse(dibh);
 	}
-	gfs2_assert_withdraw(sdp, rgd->rd_free >= *n);
+	if (rgd->rd_free < *n)
+		goto rgrp_error;
+
 	rgd->rd_free -= *n;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
@@ -1484,7 +1503,16 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 	rgd->rd_free_clone -= *n;
 	spin_unlock(&sdp->sd_rindex_spin);
 
-	return block;
+	*bn = block;
+	return 0;
+
+rgrp_error:
+	fs_warn(sdp, "rgrp %llu has an error, marking it readonly until umount\n",
+	        (unsigned long long)rgd->rd_addr);
+	fs_warn(sdp, "umount on all nodes and run fsck.gfs2 to fix the error\n");
+	gfs2_rgrp_dump(NULL, rgd->rd_gl);
+	rgd->rd_flags |= GFS2_RDF_ERROR;
+	return -EIO;
 }
 
 /**
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 3181c7e..1e76ff0 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -14,22 +14,22 @@ struct gfs2_rgrpd;
 struct gfs2_sbd;
 struct gfs2_holder;
 
-void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd);
+extern void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd);
 
 struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk);
 struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp);
 struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd);
 
-void gfs2_clear_rgrpd(struct gfs2_sbd *sdp);
-int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh);
+extern void gfs2_clear_rgrpd(struct gfs2_sbd *sdp);
+extern int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh);
 
-int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd);
-void gfs2_rgrp_bh_hold(struct gfs2_rgrpd *rgd);
-void gfs2_rgrp_bh_put(struct gfs2_rgrpd *rgd);
+extern int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd);
+extern void gfs2_rgrp_bh_hold(struct gfs2_rgrpd *rgd);
+extern void gfs2_rgrp_bh_put(struct gfs2_rgrpd *rgd);
 
-void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd);
+extern void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd);
 
-struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
+extern struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
 static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 {
 	BUG_ON(ip->i_alloc == NULL);
@@ -37,22 +37,22 @@ static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 	ip->i_alloc = NULL;
 }
 
-int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
-			 char *file, unsigned int line);
+extern int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file,
+				  unsigned int line);
 #define gfs2_inplace_reserve(ip) \
 gfs2_inplace_reserve_i((ip), __FILE__, __LINE__)
 
-void gfs2_inplace_release(struct gfs2_inode *ip);
+extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
-unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block);
+extern unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block);
 
-u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n);
-u64 gfs2_alloc_di(struct gfs2_inode *ip, u64 *generation);
+extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
+extern u64 gfs2_alloc_di(struct gfs2_inode *ip, u64 *generation);
 
-void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
-void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
-void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip);
-void gfs2_unlink_di(struct inode *inode);
+extern void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
+extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
+extern void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip);
+extern void gfs2_unlink_di(struct inode *inode);
 
 struct gfs2_rgrp_list {
 	unsigned int rl_rgrps;
@@ -61,10 +61,11 @@ struct gfs2_rgrp_list {
 	struct gfs2_holder *rl_ghs;
 };
 
-void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
-		    u64 block);
-void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
-void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
-u64 gfs2_ri_total(struct gfs2_sbd *sdp);
+extern void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
+			   u64 block);
+extern void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
+extern void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
+extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
+extern int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl);
 
 #endif /* __RGRP_DOT_H__ */
-- 
1.6.0.6

