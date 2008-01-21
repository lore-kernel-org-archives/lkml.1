Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYAUKDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYAUKDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbYAUKCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbYAUKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:01:57 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/58] [GFS2] Remove useless i_cache from inodes
Date: Mon, 21 Jan 2008 09:21:22 +0000
Message-Id: <12009073492811-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907348435-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
Message-Id: <fdfa2222cde4496cdff43faf8fa4722e53338f54.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The i_cache was designed to keep references to the indirect blocks
used during block mapping so that they didn't have to be looked
up continually. The idea failed because there are too many places
where the i_cache needs to be freed, and this has in the past been
the cause of many bugs.

In addition there was no performance benefit being gained since the
disk blocks in question were cached anyway. So this patch removes
it in order to simplify the code to prepare for other changes which
would otherwise have had to add further support for this feature.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 110f03d..ba12423 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -56,7 +56,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 		bd = list_entry(head->next, struct gfs2_bufdata,
 				bd_ail_gl_list);
 		bh = bd->bd_bh;
-		gfs2_remove_from_ail(NULL, bd);
+		gfs2_remove_from_ail(bd);
 		bd->bd_bh = NULL;
 		bh->b_private = NULL;
 		bd->bd_blkno = bh->b_blocknr;
@@ -287,23 +287,6 @@ static int inode_go_lock(struct gfs2_holder *gh)
 }
 
 /**
- * inode_go_unlock - operation done before an inode lock is unlocked by a
- *		     process
- * @gl: the glock
- * @flags:
- *
- */
-
-static void inode_go_unlock(struct gfs2_holder *gh)
-{
-	struct gfs2_glock *gl = gh->gh_gl;
-	struct gfs2_inode *ip = gl->gl_object;
-
-	if (ip)
-		gfs2_meta_cache_flush(ip);
-}
-
-/**
  * rgrp_go_demote_ok - Check to see if it's ok to unlock a RG's glock
  * @gl: the glock
  *
@@ -377,7 +360,6 @@ static void trans_go_xmote_bh(struct gfs2_glock *gl)
 
 	if (gl->gl_state != LM_ST_UNLOCKED &&
 	    test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
-		gfs2_meta_cache_flush(GFS2_I(sdp->sd_jdesc->jd_inode));
 		j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 		error = gfs2_find_jhead(sdp->sd_jdesc, &head);
@@ -437,7 +419,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_inval = inode_go_inval,
 	.go_demote_ok = inode_go_demote_ok,
 	.go_lock = inode_go_lock,
-	.go_unlock = inode_go_unlock,
 	.go_type = LM_TYPE_INODE,
 	.go_min_hold_time = HZ / 10,
 };
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 55c72f0..5662ff9 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -275,8 +275,6 @@ struct gfs2_inode {
 	spinlock_t i_spin;
 	struct rw_semaphore i_rw_mutex;
 	unsigned long i_last_pfault;
-
-	struct buffer_head *i_cache[GFS2_MAX_META_HEIGHT];
 };
 
 /*
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ad0fe37..af493fc 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -293,11 +293,6 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	return 0;
 }
 
-static void gfs2_inode_bh(struct gfs2_inode *ip, struct buffer_head *bh)
-{
-	ip->i_cache[0] = bh;
-}
-
 /**
  * gfs2_inode_refresh - Refresh the incore copy of the dinode
  * @ip: The GFS2 inode
@@ -965,7 +960,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	struct gfs2_inum_host inum = { .no_addr = 0, .no_formal_ino = 0 };
 	int error;
 	u64 generation;
-	struct buffer_head *bh=NULL;
+	struct buffer_head *bh = NULL;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1002,8 +997,6 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
-	gfs2_inode_bh(GFS2_I(inode), bh);
-
 	error = gfs2_inode_refresh(GFS2_I(inode));
 	if (error)
 		goto fail_gunlock2;
@@ -1020,6 +1013,8 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock2;
 
+	if (bh)
+		brelse(bh);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	return inode;
@@ -1031,6 +1026,8 @@ fail_gunlock2:
 fail_gunlock:
 	gfs2_glock_dq(ghs);
 fail:
+	if (bh)
+		brelse(bh);
 	return ERR_PTR(error);
 }
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 7df7024..70b404d 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -68,14 +68,12 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
  *
  */
 
-void gfs2_remove_from_ail(struct address_space *mapping, struct gfs2_bufdata *bd)
+void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 {
 	bd->bd_ail = NULL;
 	list_del_init(&bd->bd_ail_st_list);
 	list_del_init(&bd->bd_ail_gl_list);
 	atomic_dec(&bd->bd_gl->gl_ail_count);
-	if (mapping)
-		gfs2_meta_cache_flush(GFS2_I(mapping->host));
 	brelse(bd->bd_bh);
 }
 
@@ -248,7 +246,7 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 		bd = list_entry(head->prev, struct gfs2_bufdata,
 				bd_ail_st_list);
 		gfs2_assert(sdp, bd->bd_ail == ai);
-		gfs2_remove_from_ail(bd->bd_bh->b_page->mapping, bd);
+		gfs2_remove_from_ail(bd);
 	}
 }
 
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index dae2824..24e7161 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -59,7 +59,7 @@ struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 				      struct buffer_head *real);
 void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
 void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
-void gfs2_remove_from_ail(struct address_space *mapping, struct gfs2_bufdata *bd);
+void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
 
 void gfs2_log_shutdown(struct gfs2_sbd *sdp);
 void gfs2_meta_syncfs(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 7ecfe0d..653fd5a 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -31,7 +31,6 @@ static void gfs2_init_inode_once(struct kmem_cache *cachep, void *foo)
 	inode_init_once(&ip->i_inode);
 	spin_lock_init(&ip->i_spin);
 	init_rwsem(&ip->i_rw_mutex);
-	memset(ip->i_cache, 0, sizeof(ip->i_cache));
 }
 
 static void gfs2_init_glock_once(struct kmem_cache *cachep, void *foo)
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 4da4239..01ef902 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -317,7 +317,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	}
 	if (bd) {
 		if (bd->bd_ail) {
-			gfs2_remove_from_ail(NULL, bd);
+			gfs2_remove_from_ail(bd);
 			bh->b_private = NULL;
 			bd->bd_bh = NULL;
 			bd->bd_blkno = bh->b_blocknr;
@@ -358,32 +358,6 @@ void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen)
 }
 
 /**
- * gfs2_meta_cache_flush - get rid of any references on buffers for this inode
- * @ip: The GFS2 inode
- *
- * This releases buffers that are in the most-recently-used array of
- * blocks used for indirect block addressing for this inode.
- */
-
-void gfs2_meta_cache_flush(struct gfs2_inode *ip)
-{
-	struct buffer_head **bh_slot;
-	unsigned int x;
-
-	spin_lock(&ip->i_spin);
-
-	for (x = 0; x < GFS2_MAX_META_HEIGHT; x++) {
-		bh_slot = &ip->i_cache[x];
-		if (*bh_slot) {
-			brelse(*bh_slot);
-			*bh_slot = NULL;
-		}
-	}
-
-	spin_unlock(&ip->i_spin);
-}
-
-/**
  * gfs2_meta_indirect_buffer - Get a metadata buffer
  * @ip: The GFS2 inode
  * @height: The level of this buf in the metadata (indir addr) tree (if any)
@@ -391,8 +365,6 @@ void gfs2_meta_cache_flush(struct gfs2_inode *ip)
  * @new: Non-zero if we may create a new buffer
  * @bhp: the buffer is returned here
  *
- * Try to use the gfs2_inode's MRU metadata tree cache.
- *
  * Returns: errno
  */
 
@@ -401,58 +373,25 @@ int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_glock *gl = ip->i_gl;
-	struct buffer_head *bh = NULL, **bh_slot = ip->i_cache + height;
-	int in_cache = 0;
-
-	BUG_ON(!gl);
-	BUG_ON(!sdp);
-
-	spin_lock(&ip->i_spin);
-	if (*bh_slot && (*bh_slot)->b_blocknr == num) {
-		bh = *bh_slot;
-		get_bh(bh);
-		in_cache = 1;
-	}
-	spin_unlock(&ip->i_spin);
-
-	if (!bh)
-		bh = getbuf(gl, num, CREATE);
-
-	if (!bh)
-		return -ENOBUFS;
+	struct buffer_head *bh;
+	int ret = 0;
 
 	if (new) {
-		if (gfs2_assert_warn(sdp, height))
-			goto err;
-		meta_prep_new(bh);
+		BUG_ON(height == 0);
+		bh = gfs2_meta_new(gl, num);
 		gfs2_trans_add_bh(ip->i_gl, bh, 1);
 		gfs2_metatype_set(bh, GFS2_METATYPE_IN, GFS2_FORMAT_IN);
 		gfs2_buffer_clear_tail(bh, sizeof(struct gfs2_meta_header));
 	} else {
 		u32 mtype = height ? GFS2_METATYPE_IN : GFS2_METATYPE_DI;
-		if (!buffer_uptodate(bh)) {
-			ll_rw_block(READ_META, 1, &bh);
-			if (gfs2_meta_wait(sdp, bh))
-				goto err;
+		ret = gfs2_meta_read(gl, num, DIO_WAIT, &bh);
+		if (ret == 0 && gfs2_metatype_check(sdp, bh, mtype)) {
+			brelse(bh);
+			ret = -EIO;
 		}
-		if (gfs2_metatype_check(sdp, bh, mtype))
-			goto err;
-	}
-
-	if (!in_cache) {
-		spin_lock(&ip->i_spin);
-		if (*bh_slot)
-			brelse(*bh_slot);
-		*bh_slot = bh;
-		get_bh(bh);
-		spin_unlock(&ip->i_spin);
 	}
-
 	*bhp = bh;
-	return 0;
-err:
-	brelse(bh);
-	return -EIO;
+	return ret;
 }
 
 /**
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index b704822..73e3b1c 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -56,7 +56,6 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr,
 
 void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen);
 
-void gfs2_meta_cache_flush(struct gfs2_inode *ip);
 int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
 			      int new, struct buffer_head **bhp);
 
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 1696e5d..4c4ef7f 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -154,7 +154,6 @@ static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
 	error = block_write_full_page(page, gfs2_get_block_noalloc, wbc);
 	if (done_trans)
 		gfs2_trans_end(sdp);
-	gfs2_meta_cache_flush(ip);
 	return error;
 
 out_ignore:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index dd3e737..5183dfb 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -543,7 +543,6 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	if (error)
 		return error;
 
-	gfs2_meta_cache_flush(ip);
 	j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head);
-- 
1.5.1.2

