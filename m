Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXJDJa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXJDJa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbXJDJSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759563AbXJDJST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:19 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 35/51] [GFS2] Move pin/unpin into lops.c, clean up locking
Date: Thu,  4 Oct 2007 09:49:28 +0100
Message-Id: <119148785427-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878521254-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

gfs2_pin and gfs2_unpin are only used in lops.c, despite being
defined in meta_io.c, so this patch moves them into lops.c and
makes them static. At the same time, its possible to clean up
the locking in the buf and databuf _lo_add() functions so that
we only need to grab the spinlock once. Also we have to move
lock_buffer() around the _lo_add() functions since we can't
do that in gfs2_pin() any more since we hold the spinlock
for the duration of that function.

As a result, the code shrinks by 12 lines and we do far fewer
operations when adding buffers to the log. It also makes the
code somewhat easier to read & understand.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 7ef3356..3ec5871 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -27,7 +27,71 @@
 #include "trans.h"
 #include "util.h"
 
-static void glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
+/**
+ * gfs2_pin - Pin a buffer in memory
+ * @sdp: The superblock
+ * @bh: The buffer to be pinned
+ *
+ * The log lock must be held when calling this function
+ */
+static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
+{
+	struct gfs2_bufdata *bd;
+
+	gfs2_assert_withdraw(sdp, test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags));
+
+	clear_buffer_dirty(bh);
+	if (test_set_buffer_pinned(bh))
+		gfs2_assert_withdraw(sdp, 0);
+	if (!buffer_uptodate(bh))
+		gfs2_io_error_bh(sdp, bh);
+	bd = bh->b_private;
+	/* If this buffer is in the AIL and it has already been written
+	 * to in-place disk block, remove it from the AIL.
+	 */
+	if (bd->bd_ail)
+		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
+	get_bh(bh);
+}
+
+/**
+ * gfs2_unpin - Unpin a buffer
+ * @sdp: the filesystem the buffer belongs to
+ * @bh: The buffer to unpin
+ * @ai:
+ *
+ */
+
+static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
+		       struct gfs2_ail *ai)
+{
+	struct gfs2_bufdata *bd = bh->b_private;
+
+	gfs2_assert_withdraw(sdp, buffer_uptodate(bh));
+
+	if (!buffer_pinned(bh))
+		gfs2_assert_withdraw(sdp, 0);
+
+	lock_buffer(bh);
+	mark_buffer_dirty(bh);
+	clear_buffer_pinned(bh);
+
+	gfs2_log_lock(sdp);
+	if (bd->bd_ail) {
+		list_del(&bd->bd_ail_st_list);
+		brelse(bh);
+	} else {
+		struct gfs2_glock *gl = bd->bd_gl;
+		list_add(&bd->bd_ail_gl_list, &gl->gl_ail_list);
+		atomic_inc(&gl->gl_ail_count);
+	}
+	bd->bd_ail = ai;
+	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
+}
+
+static void __glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 {
 	struct gfs2_glock *gl;
 	struct gfs2_trans *tr = current->journal_info;
@@ -38,15 +102,19 @@ static void glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(gl)))
 		return;
 
-	gfs2_log_lock(sdp);
-	if (!list_empty(&le->le_list)){
-		gfs2_log_unlock(sdp);
+	if (!list_empty(&le->le_list))
 		return;
-	}
+
 	gfs2_glock_hold(gl);
 	set_bit(GLF_DIRTY, &gl->gl_flags);
 	sdp->sd_log_num_gl++;
 	list_add(&le->le_list, &sdp->sd_log_le_gl);
+}
+
+static void glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
+{
+	gfs2_log_lock(sdp);
+	__glock_lo_add(sdp, le);
 	gfs2_log_unlock(sdp);
 }
 
@@ -71,30 +139,25 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
 	struct gfs2_trans *tr;
 
+	lock_buffer(bd->bd_bh);
 	gfs2_log_lock(sdp);
-	if (!list_empty(&bd->bd_list_tr)) {
-		gfs2_log_unlock(sdp);
-		return;
-	}
+	if (!list_empty(&bd->bd_list_tr))
+		goto out;
 	tr = current->journal_info;
 	tr->tr_touched = 1;
 	tr->tr_num_buf++;
 	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
-	gfs2_log_unlock(sdp);
-
 	if (!list_empty(&le->le_list))
-		return;
-
-	gfs2_trans_add_gl(bd->bd_gl);
-
+		goto out;
+	__glock_lo_add(sdp, &bd->bd_gl->gl_le);
 	gfs2_meta_check(sdp, bd->bd_bh);
 	gfs2_pin(sdp, bd->bd_bh);
-	gfs2_log_lock(sdp);
 	sdp->sd_log_num_buf++;
 	list_add(&le->le_list, &sdp->sd_log_le_buf);
-	gfs2_log_unlock(sdp);
-
 	tr->tr_num_buf_new++;
+out:
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bd->bd_bh);
 }
 
 static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
@@ -476,31 +539,29 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	struct address_space *mapping = bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
 
+	lock_buffer(bd->bd_bh);
 	gfs2_log_lock(sdp);
-	if (!list_empty(&bd->bd_list_tr)) {
-		gfs2_log_unlock(sdp);
-		return;
-	}
+	if (!list_empty(&bd->bd_list_tr))
+		goto out;
 	tr->tr_touched = 1;
 	if (gfs2_is_jdata(ip)) {
 		tr->tr_num_buf++;
 		list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 	}
-	gfs2_log_unlock(sdp);
 	if (!list_empty(&le->le_list))
-		return;
+		goto out;
 
-	gfs2_trans_add_gl(bd->bd_gl);
+	__glock_lo_add(sdp, &bd->bd_gl->gl_le);
 	if (gfs2_is_jdata(ip)) {
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
-	}
-	gfs2_log_lock(sdp);
-	if (gfs2_is_jdata(ip))
 		sdp->sd_log_num_jdata++;
+	}
 	sdp->sd_log_num_databuf++;
 	list_add(&le->le_list, &sdp->sd_log_le_databuf);
+out:
 	gfs2_log_unlock(sdp);
+	unlock_buffer(bd->bd_bh);
 }
 
 static int gfs2_check_magic(struct buffer_head *bh)
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 8da343b..d762e4f 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -298,76 +298,6 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 }
 
 /**
- * gfs2_pin - Pin a buffer in memory
- * @sdp: the filesystem the buffer belongs to
- * @bh: The buffer to be pinned
- *
- */
-
-void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
-{
-	struct gfs2_bufdata *bd = bh->b_private;
-
-	gfs2_assert_withdraw(sdp, test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags));
-
-	if (test_set_buffer_pinned(bh))
-		gfs2_assert_withdraw(sdp, 0);
-
-	wait_on_buffer(bh);
-
-	/* If this buffer is in the AIL and it has already been written
-	   to in-place disk block, remove it from the AIL. */
-
-	gfs2_log_lock(sdp);
-	if (bd->bd_ail && !buffer_in_io(bh))
-		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
-	gfs2_log_unlock(sdp);
-
-	clear_buffer_dirty(bh);
-	wait_on_buffer(bh);
-
-	if (!buffer_uptodate(bh))
-		gfs2_io_error_bh(sdp, bh);
-
-	get_bh(bh);
-}
-
-/**
- * gfs2_unpin - Unpin a buffer
- * @sdp: the filesystem the buffer belongs to
- * @bh: The buffer to unpin
- * @ai:
- *
- */
-
-void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
-	        struct gfs2_ail *ai)
-{
-	struct gfs2_bufdata *bd = bh->b_private;
-
-	gfs2_assert_withdraw(sdp, buffer_uptodate(bh));
-
-	if (!buffer_pinned(bh))
-		gfs2_assert_withdraw(sdp, 0);
-
-	mark_buffer_dirty(bh);
-	clear_buffer_pinned(bh);
-
-	gfs2_log_lock(sdp);
-	if (bd->bd_ail) {
-		list_del(&bd->bd_ail_st_list);
-		brelse(bh);
-	} else {
-		struct gfs2_glock *gl = bd->bd_gl;
-		list_add(&bd->bd_ail_gl_list, &gl->gl_ail_list);
-		atomic_inc(&gl->gl_ail_count);
-	}
-	bd->bd_ail = ai;
-	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
-	gfs2_log_unlock(sdp);
-}
-
-/**
  * gfs2_meta_wipe - make inode's buffers so they aren't dirty/pinned anymore
  * @ip: the inode who owns the buffers
  * @bstart: the first buffer in the run
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index 527bf19..fd67f07 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -50,9 +50,6 @@ int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh);
 
 void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 			 int meta);
-void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh);
-void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
-		struct gfs2_ail *ai);
 
 void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen);
 
-- 
1.5.1.2

