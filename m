Return-Path: <linux-kernel-owner+w=401wt.eu-S1765130AbYAUKVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765130AbYAUKVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbYAUKDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189AbYAUKDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:17 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 51/58] [GFS2] Reduce inode size by moving i_alloc out of line
Date: Mon, 21 Jan 2008 09:22:09 +0000
Message-Id: <12009074291130-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074271575-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
 <12009074103982-git-send-email-swhiteho@redhat.com>
 <12009074121930-git-send-email-swhiteho@redhat.com>
 <12009074142128-git-send-email-swhiteho@redhat.com>
 <12009074163163-git-send-email-swhiteho@redhat.com>
 <1200907417194-git-send-email-swhiteho@redhat.com>
 <12009074192015-git-send-email-swhiteho@redhat.com>
 <12009074213460-git-send-email-swhiteho@redhat.com>
 <12009074221447-git-send-email-swhiteho@redhat.com>
 <12009074243427-git-send-email-swhiteho@redhat.com>
 <12009074263736-git-send-email-swhiteho@redhat.com>
 <12009074271575-git-send-email-swhiteho@redhat.com>
Message-Id: <708a52fa14264415fbab6e6ba3d3630f464fa062.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

It is possible to reduce the size of GFS2 inodes by taking the i_alloc
structure out of the gfs2_inode. This patch allocates the i_alloc
structure whenever its needed, and frees it afterward. This decreases
the amount of low memory we use at the expense of requiring a memory
allocation for each page or partial page that we write. A quick test
with postmark shows that the overhead is not measurable and I also note
that OCFS2 use the same approach.

In the future I'd like to solve the problem by shrinking down the size
of the members of the i_alloc structure, but for now, this reduces the
immediate problem of using too much low-memory on x86 and doesn't add
too much overhead.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 2241141..73dfad7 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -683,7 +683,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	if (metadata)
 		revokes = (height) ? sdp->sd_inptrs : sdp->sd_diptrs;
 
-	error = gfs2_rindex_hold(sdp, &ip->i_alloc.al_ri_gh);
+	error = gfs2_rindex_hold(sdp, &ip->i_alloc->al_ri_gh);
 	if (error)
 		return error;
 
@@ -785,7 +785,7 @@ out_rg_gunlock:
 out_rlist:
 	gfs2_rlist_free(&rlist);
 out:
-	gfs2_glock_dq_uninit(&ip->i_alloc.al_ri_gh);
+	gfs2_glock_dq_uninit(&ip->i_alloc->al_ri_gh);
 	return error;
 }
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 9949bb7..57e2ed9 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1876,7 +1876,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (error)
 		goto out;
 
-	error = gfs2_rindex_hold(sdp, &dip->i_alloc.al_ri_gh);
+	error = gfs2_rindex_hold(sdp, &dip->i_alloc->al_ri_gh);
 	if (error)
 		goto out_qs;
 
@@ -1949,7 +1949,7 @@ out_rg_gunlock:
 	gfs2_glock_dq_m(rlist.rl_rgrps, rlist.rl_ghs);
 out_rlist:
 	gfs2_rlist_free(&rlist);
-	gfs2_glock_dq_uninit(&dip->i_alloc.al_ri_gh);
+	gfs2_glock_dq_uninit(&dip->i_alloc->al_ri_gh);
 out_qs:
 	gfs2_quota_unhold(dip);
 out:
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 2a7435b..bee9970 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -1418,7 +1418,7 @@ out:
 static int ea_dealloc_block(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd;
 	struct buffer_head *dibh;
 	int error;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c85f4fd..bd92a6d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -264,7 +264,7 @@ struct gfs2_inode {
 	struct gfs2_glock *i_gl; /* Move into i_gh? */
 	struct gfs2_holder i_iopen_gh;
 	struct gfs2_holder i_gh; /* for prepare/commit_write only */
-	struct gfs2_alloc i_alloc;
+	struct gfs2_alloc *i_alloc;
 	u64 i_last_rg_alloc;
 
 	spinlock_t i_spin;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 53bca99..c84764a 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -711,9 +711,10 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	int error;
 
-	gfs2_alloc_get(dip);
+	if (gfs2_alloc_get(dip) == NULL)
+		return -ENOMEM;
 
-	dip->i_alloc.al_requested = RES_DINODE;
+	dip->i_alloc->al_requested = RES_DINODE;
 	error = gfs2_inplace_reserve(dip);
 	if (error)
 		goto out;
@@ -900,7 +901,7 @@ fail_end_trans:
 	gfs2_trans_end(sdp);
 
 fail_ipreserv:
-	if (dip->i_alloc.al_rgd)
+	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
 
 fail_quota_locks:
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 653fd5a..88686fc 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -31,6 +31,7 @@ static void gfs2_init_inode_once(struct kmem_cache *cachep, void *foo)
 	inode_init_once(&ip->i_inode);
 	spin_lock_init(&ip->i_spin);
 	init_rwsem(&ip->i_rw_mutex);
+	ip->i_alloc = NULL;
 }
 
 static void gfs2_init_glock_once(struct kmem_cache *cachep, void *foo)
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 37406a3..38dbe99 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -646,7 +646,6 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	if (error)
 		goto out_unlock;
 
-	ip->i_alloc.al_requested = 0;
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
 
@@ -823,7 +822,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *dibh;
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_dinode *di;
 	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
 	unsigned int to = from + len;
@@ -861,7 +860,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	brelse(dibh);
 	gfs2_trans_end(sdp);
 failed:
-	if (al->al_requested) {
+	if (al) {
 		gfs2_inplace_release(ip);
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 597f7ff..d7f4726 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -364,9 +364,11 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
 	if (ret || !alloc_required)
 		goto out_unlock;
-
-	ip->i_alloc.al_requested = 0;
+	ret = -ENOMEM;
 	al = gfs2_alloc_get(ip);
+	if (al == NULL)
+		goto out_unlock;
+
 	ret = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (ret)
 		goto out_alloc_put;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 8386ab3..9f71372 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -61,7 +61,7 @@ static int gfs2_create(struct inode *dir, struct dentry *dentry,
 		inode = gfs2_createi(ghs, &dentry->d_name, S_IFREG | mode, 0);
 		if (!IS_ERR(inode)) {
 			gfs2_trans_end(sdp);
-			if (dip->i_alloc.al_rgd)
+			if (dip->i_alloc->al_rgd)
 				gfs2_inplace_release(dip);
 			gfs2_quota_unlock(dip);
 			gfs2_alloc_put(dip);
@@ -376,7 +376,7 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 	}
 
 	gfs2_trans_end(sdp);
-	if (dip->i_alloc.al_rgd)
+	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
 	gfs2_alloc_put(dip);
@@ -452,7 +452,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	gfs2_assert_withdraw(sdp, !error); /* dip already pinned */
 
 	gfs2_trans_end(sdp);
-	if (dip->i_alloc.al_rgd)
+	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
 	gfs2_alloc_put(dip);
@@ -558,7 +558,7 @@ static int gfs2_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	}
 
 	gfs2_trans_end(sdp);
-	if (dip->i_alloc.al_rgd)
+	if (dip->i_alloc->al_rgd)
 		gfs2_inplace_release(dip);
 	gfs2_quota_unlock(dip);
 	gfs2_alloc_put(dip);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 60cc50f..a08dabd 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -453,7 +453,7 @@ static void qdsb_put(struct gfs2_quota_data *qd)
 int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_quota_data **qd = al->al_qd;
 	int error;
 
@@ -501,7 +501,7 @@ out:
 void gfs2_quota_unhold(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	unsigned int x;
 
 	gfs2_assert_warn(sdp, !test_bit(GIF_QD_LOCKED, &ip->i_flags));
@@ -853,7 +853,7 @@ fail:
 int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	unsigned int x;
 	int error = 0;
 
@@ -921,7 +921,7 @@ static int need_sync(struct gfs2_quota_data *qd)
 
 void gfs2_quota_unlock(struct gfs2_inode *ip)
 {
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_quota_data *qda[4];
 	unsigned int count = 0;
 	unsigned int x;
@@ -969,7 +969,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_quota_data *qd;
 	s64 value;
 	unsigned int x;
@@ -1013,7 +1013,7 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 		       u32 uid, u32 gid)
 {
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_quota_data *qd;
 	unsigned int x;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 68c4bf3..3552110 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -819,11 +819,9 @@ void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
 
 struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
 {
-	struct gfs2_alloc *al = &ip->i_alloc;
-
-	/* FIXME: Should assert that the correct locks are held here... */
-	memset(al, 0, sizeof(*al));
-	return al;
+	BUG_ON(ip->i_alloc != NULL);
+	ip->i_alloc = kzalloc(sizeof(struct gfs2_alloc), GFP_KERNEL);
+	return ip->i_alloc;
 }
 
 /**
@@ -1061,7 +1059,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	struct inode *inode = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	int flags = LM_FLAG_TRY;
 	int skipped = 0;
 	int loops = 0;
@@ -1176,7 +1174,7 @@ out:
 int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct inode *inode;
 	int error = 0;
 	u64 last_unlinked = NO_BLOCK;
@@ -1222,7 +1220,7 @@ try_again:
 void gfs2_inplace_release(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 
 	if (gfs2_assert_warn(sdp, al->al_alloced <= al->al_requested) == -1)
 		fs_warn(sdp, "al_alloced = %u, al_requested = %u "
@@ -1412,7 +1410,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 u64 gfs2_alloc_data(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd = al->al_rgd;
 	u32 goal, blk;
 	u64 block;
@@ -1457,7 +1455,7 @@ u64 gfs2_alloc_data(struct gfs2_inode *ip)
 u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = &ip->i_alloc;
+	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd = al->al_rgd;
 	u32 goal, blk;
 	u64 block;
@@ -1503,7 +1501,7 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct gfs2_alloc *al = &dip->i_alloc;
+	struct gfs2_alloc *al = dip->i_alloc;
 	struct gfs2_rgrpd *rgd = al->al_rgd;
 	u32 blk;
 	u64 block;
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index b4c6adf..149bb16 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -32,7 +32,9 @@ void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd);
 struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
 static inline void gfs2_alloc_put(struct gfs2_inode *ip)
 {
-	return; /* So we can see where ip->i_alloc is used */
+	BUG_ON(ip->i_alloc == NULL);
+	kfree(ip->i_alloc);
+	ip->i_alloc = NULL;
 }
 
 int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
-- 
1.5.1.2

