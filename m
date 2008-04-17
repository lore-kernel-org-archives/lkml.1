Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbYDQJqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbYDQJqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933391AbYDQJ00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649AbYDQJ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:08 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/48] [GFS2] Update gfs2_trans_add_unrevoke to accept extents
Date: Thu, 17 Apr 2008 09:38:59 +0100
Message-Id: <1208421617421-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216153016-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

By adding an extra argument to gfs2_trans_add_unrevoke we can now
specify an extent length of blocks to unrevoke. This means that
we only need to make one pass through the list for each extent
rather than each block. Currently the only extent length which
is used is 1, but that will change in the future.

Also gfs2_trans_add_unrevoke is removed from gfs2_alloc_meta
since its the only difference between this and gfs2_alloc_data
which is left. This will allow a future patch to merge these
two functions into one (i.e. one call to allocate both data
and metadata in a single extent in the future).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 30d718b..651e532 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -138,7 +138,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 
 		if (isdir) {
 			block = gfs2_alloc_meta(ip);
-
+			gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), block, 1);
 			error = gfs2_dir_get_new_buffer(ip, block, &bh);
 			if (error)
 				goto out_brelse;
@@ -206,6 +206,7 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 
 	for(n = 0; n < new_height; n++) {
 		bn = gfs2_alloc_meta(ip);
+		gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, 1);
 		mp->mp_bh[n] = gfs2_meta_new(ip->i_gl, bn);
 		gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[n], 1);
 	}
@@ -370,8 +371,10 @@ static int lookup_block(struct gfs2_inode *ip, unsigned int height,
 
 	if (height == ip->i_height - 1 && !gfs2_is_dir(ip))
 		*block = gfs2_alloc_data(ip);
-	else
+	else {
 		*block = gfs2_alloc_meta(ip);
+		gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), *block, 1);
+	}
 
 	gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[height], 1);
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 081daa9..55514ee 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -810,7 +810,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	struct qstr name = { .name = "", .len = 0, .hash = 0 };
 	if (!bh)
 		return NULL;
-
+	gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, 1);
 	gfs2_trans_add_bh(ip->i_gl, bh, 1);
 	gfs2_metatype_set(bh, GFS2_METATYPE_LF, GFS2_FORMAT_LF);
 	leaf = (struct gfs2_leaf *)bh->b_data;
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 04febbc..c7fa0a8 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -585,7 +585,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	u64 block;
 
 	block = gfs2_alloc_meta(ip);
-
+	gfs2_trans_add_unrevoke(sdp, block, 1);
 	*bhp = gfs2_meta_new(ip->i_gl, block);
 	gfs2_trans_add_bh(ip->i_gl, *bhp, 1);
 	gfs2_metatype_set(*bhp, GFS2_METATYPE_EA, GFS2_FORMAT_EA);
@@ -644,7 +644,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			int mh_size = sizeof(struct gfs2_meta_header);
 
 			block = gfs2_alloc_meta(ip);
-
+			gfs2_trans_add_unrevoke(sdp, block, 1);
 			bh = gfs2_meta_new(ip->i_gl, block);
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
 			gfs2_metatype_set(bh, GFS2_METATYPE_ED, GFS2_FORMAT_ED);
@@ -968,7 +968,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		u64 blk;
 
 		blk = gfs2_alloc_meta(ip);
-
+		gfs2_trans_add_unrevoke(sdp, blk, 1);
 		indbh = gfs2_meta_new(ip->i_gl, blk);
 		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
 		gfs2_metatype_set(indbh, GFS2_METATYPE_IN, GFS2_FORMAT_IN);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index cc28845..9f28463 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1486,7 +1486,6 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 
 	gfs2_statfs_change(sdp, 0, -1, 0);
 	gfs2_quota_change(ip, +1, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	gfs2_trans_add_unrevoke(sdp, block);
 
 	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone--;
@@ -1528,7 +1527,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	al->al_alloced++;
 
 	gfs2_statfs_change(sdp, 0, -1, +1);
-	gfs2_trans_add_unrevoke(sdp, block);
+	gfs2_trans_add_unrevoke(sdp, block, 1);
 
 	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone--;
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 73e5d92..f677b8a 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -146,30 +146,25 @@ void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	lops_add(sdp, &bd->bd_le);
 }
 
-void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno)
+void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len)
 {
-	struct gfs2_bufdata *bd;
-	int found = 0;
+	struct gfs2_bufdata *bd, *tmp;
+	struct gfs2_trans *tr = current->journal_info;
+	unsigned int n = len;
 
 	gfs2_log_lock(sdp);
-
-	list_for_each_entry(bd, &sdp->sd_log_le_revoke, bd_le.le_list) {
-		if (bd->bd_blkno == blkno) {
+	list_for_each_entry_safe(bd, tmp, &sdp->sd_log_le_revoke, bd_le.le_list) {
+		if ((bd->bd_blkno >= blkno) && (bd->bd_blkno < (blkno + len))) {
 			list_del_init(&bd->bd_le.le_list);
 			gfs2_assert_withdraw(sdp, sdp->sd_log_num_revoke);
 			sdp->sd_log_num_revoke--;
-			found = 1;
-			break;
+			kmem_cache_free(gfs2_bufdata_cachep, bd);
+			tr->tr_num_revoke_rm++;
+			if (--n == 0)
+				break;
 		}
 	}
-
 	gfs2_log_unlock(sdp);
-
-	if (found) {
-		struct gfs2_trans *tr = current->journal_info;
-		kmem_cache_free(gfs2_bufdata_cachep, bd);
-		tr->tr_num_revoke_rm++;
-	}
 }
 
 void gfs2_trans_add_rg(struct gfs2_rgrpd *rgd)
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index e826f0d..edf9d4b 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -32,7 +32,7 @@ void gfs2_trans_end(struct gfs2_sbd *sdp);
 
 void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta);
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
-void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno);
+void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len);
 void gfs2_trans_add_rg(struct gfs2_rgrpd *rgd);
 
 #endif /* __TRANS_DOT_H__ */
-- 
1.5.1.2

