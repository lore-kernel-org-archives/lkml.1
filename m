Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbXJDJcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbXJDJcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXJDJSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759591AbXJDJS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:27 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 40/51] [GFS2] Clean up gfs2_trans_add_revoke()
Date: Thu,  4 Oct 2007 09:49:33 +0100
Message-Id: <11914878632211-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487861683-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The following alters gfs2_trans_add_revoke() to take a struct
gfs2_bufdata as an argument. This eliminates the memory allocation which
was previously required by making use of the already existing struct
gfs2_bufdata. It makes some sanity checks to ensure that the
gfs2_bufdata has been removed from all the lists before its recycled as
a revoke structure. This saves one memory allocation and one free per
revoke structure.

Also as a result, and to simplify the locking, since there is no longer
any blocking code in gfs2_trans_add_revoke() we must hold the log lock
whenever this function is called. This reduces the amount of times we
take and unlock the log lock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index b17346a..4670dcb 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -41,7 +41,6 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	struct list_head *head = &gl->gl_ail_list;
 	struct gfs2_bufdata *bd;
 	struct buffer_head *bh;
-	u64 blkno;
 	int error;
 
 	blocks = atomic_read(&gl->gl_ail_count);
@@ -57,15 +56,12 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 		bd = list_entry(head->next, struct gfs2_bufdata,
 				bd_ail_gl_list);
 		bh = bd->bd_bh;
-		blkno = bh->b_blocknr;
-		gfs2_assert_withdraw(sdp, !buffer_busy(bh));
-
 		gfs2_remove_from_ail(NULL, bd);
-		gfs2_log_unlock(sdp);
-
-		gfs2_trans_add_revoke(sdp, blkno);
-
-		gfs2_log_lock(sdp);
+		bd->bd_bh = NULL;
+		bh->b_private = NULL;
+		bd->bd_blkno = bh->b_blocknr;
+		gfs2_assert_withdraw(sdp, !buffer_busy(bh));
+		gfs2_trans_add_revoke(sdp, bd);
 	}
 	gfs2_assert_withdraw(sdp, !atomic_read(&gl->gl_ail_count));
 	gfs2_log_unlock(sdp);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 20fa528..4d04e6f 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -71,8 +71,8 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 void gfs2_remove_from_ail(struct address_space *mapping, struct gfs2_bufdata *bd)
 {
 	bd->bd_ail = NULL;
-	list_del(&bd->bd_ail_st_list);
-	list_del(&bd->bd_ail_gl_list);
+	list_del_init(&bd->bd_ail_st_list);
+	list_del_init(&bd->bd_ail_gl_list);
 	atomic_dec(&bd->bd_gl->gl_ail_count);
 	if (mapping)
 		gfs2_meta_cache_flush(GFS2_I(mapping->host));
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 4cbef4c..342c10e 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -343,11 +343,8 @@ static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	tr = current->journal_info;
 	tr->tr_touched = 1;
 	tr->tr_num_revoke++;
-
-	gfs2_log_lock(sdp);
 	sdp->sd_log_num_revoke++;
 	list_add(&le->le_list, &sdp->sd_log_le_revoke);
-	gfs2_log_unlock(sdp);
 }
 
 static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index d762e4f..19097bc 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -313,42 +313,31 @@ void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	while (blen) {
 		bh = getbuf(ip->i_gl, bstart, NO_CREATE);
 		if (bh) {
-			struct gfs2_bufdata *bd = bh->b_private;
+			struct gfs2_bufdata *bd;
 
+			lock_buffer(bh);
+			gfs2_log_lock(sdp);
+			bd = bh->b_private;
 			if (test_clear_buffer_pinned(bh)) {
 				struct gfs2_trans *tr = current->journal_info;
-				struct gfs2_inode *bh_ip =
-					GFS2_I(bh->b_page->mapping->host);
-
-				gfs2_log_lock(sdp);
 				list_del_init(&bd->bd_le.le_list);
 				gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
 				sdp->sd_log_num_buf--;
-				gfs2_log_unlock(sdp);
-				if (bh_ip->i_inode.i_private != NULL)
-					tr->tr_num_databuf_rm++;
-				else
-					tr->tr_num_buf_rm++;
+				tr->tr_num_buf_rm++;
 				brelse(bh);
 			}
 			if (bd) {
-				gfs2_log_lock(sdp);
 				if (bd->bd_ail) {
-					u64 blkno = bh->b_blocknr;
-					bd->bd_ail = NULL;
-					list_del(&bd->bd_ail_st_list);
-					list_del(&bd->bd_ail_gl_list);
-					atomic_dec(&bd->bd_gl->gl_ail_count);
-					brelse(bh);
-					gfs2_log_unlock(sdp);
-					gfs2_trans_add_revoke(sdp, blkno);
-				} else
-					gfs2_log_unlock(sdp);
+					gfs2_remove_from_ail(NULL, bd);
+					bh->b_private = NULL;
+					bd->bd_bh = NULL;
+					bd->bd_blkno = bh->b_blocknr;
+					gfs2_trans_add_revoke(sdp, bd);
+				}
 			}
-
-			lock_buffer(bh);
 			clear_buffer_dirty(bh);
 			clear_buffer_uptodate(bh);
+			gfs2_log_unlock(sdp);
 			unlock_buffer(bh);
 
 			brelse(bh);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 01cc27f..717983e 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -142,12 +142,12 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 	lops_add(sdp, &bd->bd_le);
 }
 
-void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, u64 blkno)
+void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	struct gfs2_bufdata *bd = kmem_cache_alloc(gfs2_bufdata_cachep,
-					  GFP_NOFS | __GFP_NOFAIL);
+	BUG_ON(!list_empty(&bd->bd_le.le_list));
+	BUG_ON(!list_empty(&bd->bd_ail_st_list));
+	BUG_ON(!list_empty(&bd->bd_ail_gl_list));
 	lops_init_le(&bd->bd_le, &gfs2_revoke_lops);
-	bd->bd_blkno = blkno;
 	lops_add(sdp, &bd->bd_le);
 }
 
@@ -160,7 +160,7 @@ void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno)
 
 	list_for_each_entry(bd, &sdp->sd_log_le_revoke, bd_le.le_list) {
 		if (bd->bd_blkno == blkno) {
-			list_del(&bd->bd_le.le_list);
+			list_del_init(&bd->bd_le.le_list);
 			gfs2_assert_withdraw(sdp, sdp->sd_log_num_revoke);
 			sdp->sd_log_num_revoke--;
 			found = 1;
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index 23d4cbe..043d5f4 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -32,7 +32,7 @@ void gfs2_trans_end(struct gfs2_sbd *sdp);
 
 void gfs2_trans_add_gl(struct gfs2_glock *gl);
 void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta);
-void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, u64 blkno);
+void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno);
 void gfs2_trans_add_rg(struct gfs2_rgrpd *rgd);
 
-- 
1.5.1.2

