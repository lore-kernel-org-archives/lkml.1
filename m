Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbYAUKI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbYAUKI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbYAUKC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbYAUKCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:21 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/58] [GFS2] Don't add glocks to the journal
Date: Mon, 21 Jan 2008 09:21:37 +0000
Message-Id: <1200907374616-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073722253-git-send-email-swhiteho@redhat.com>
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
Message-Id: <1d5e5b3757b8692881c10e0e47665de9a1b6d247.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The only reason for adding glocks to the journal was to keep track
of which locks required a log flush prior to release. We add a
flag to the glock to allow this check to be made in a simpler way.

This reduces the size of a glock (by 12 bytes on i386, 24 on x86_64)
and means that we can avoid extra work during the journal flush.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5fbd9d3..d83df68 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -346,7 +346,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_object = NULL;
 	gl->gl_sbd = sdp;
 	gl->gl_aspace = NULL;
-	lops_init_le(&gl->gl_le, &gfs2_glock_lops);
 	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
 
 	/* If this glock protects actual on-disk data or metadata blocks,
@@ -1900,8 +1899,6 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 	print_dbg(gi, "  req_bh = %s\n", (gl->gl_req_bh) ? "yes" : "no");
 	print_dbg(gi, "  lvb_count = %d\n", atomic_read(&gl->gl_lvb_count));
 	print_dbg(gi, "  object = %s\n", (gl->gl_object) ? "yes" : "no");
-	print_dbg(gi, "  le = %s\n",
-		   (list_empty(&gl->gl_le.le_list)) ? "no" : "yes");
 	print_dbg(gi, "  reclaim = %s\n",
 		   (list_empty(&gl->gl_reclaim)) ? "no" : "yes");
 	if (gl->gl_aspace)
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 478023e..911822d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -168,6 +168,7 @@ enum {
 	GLF_PENDING_DEMOTE	= 4,
 	GLF_DIRTY		= 5,
 	GLF_DEMOTE_IN_PROGRESS	= 6,
+	GLF_LFLUSH		= 7,
 };
 
 struct gfs2_glock {
@@ -208,7 +209,6 @@ struct gfs2_glock {
 	struct gfs2_sbd *gl_sbd;
 
 	struct inode *gl_aspace;
-	struct gfs2_log_element gl_le;
 	struct list_head gl_ail_list;
 	atomic_t gl_ail_count;
 	struct delayed_work gl_work;
@@ -584,13 +584,11 @@ struct gfs2_sbd {
 	unsigned int sd_log_commited_databuf;
 	unsigned int sd_log_commited_revoke;
 
-	unsigned int sd_log_num_gl;
 	unsigned int sd_log_num_buf;
 	unsigned int sd_log_num_revoke;
 	unsigned int sd_log_num_rg;
 	unsigned int sd_log_num_databuf;
 
-	struct list_head sd_log_le_gl;
 	struct list_head sd_log_le_buf;
 	struct list_head sd_log_le_revoke;
 	struct list_head sd_log_le_rg;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 532784e..92959d0 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -362,7 +362,8 @@ int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out_rg_gunlock;
 
-	gfs2_trans_add_gl(ip->i_gl);
+	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
+	set_bit(GLF_LFLUSH, &ip->i_gl->gl_flags);
 
 	gfs2_free_di(rgd, ip);
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 1e1fe8d..d246843 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -692,20 +692,16 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
  *
  */
 
-void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
+void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 {
 	struct gfs2_ail *ai;
 
 	down_write(&sdp->sd_log_flush_lock);
 
-	if (gl) {
-		gfs2_log_lock(sdp);
-		if (list_empty(&gl->gl_le.le_list)) {
-			gfs2_log_unlock(sdp);
-			up_write(&sdp->sd_log_flush_lock);
-			return;
-		}
-		gfs2_log_unlock(sdp);
+	/* Log might have been flushed while we waited for the flush lock */
+	if (gl && !test_bit(GLF_LFLUSH, &gl->gl_flags)) {
+		up_write(&sdp->sd_log_flush_lock);
+		return;
 	}
 
 	ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS | __GFP_NOFAIL);
@@ -823,7 +819,6 @@ void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 	down_write(&sdp->sd_log_flush_lock);
 
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_blks_reserved);
-	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_gl);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_buf);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_rg);
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 24e7161..4babd43 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -57,7 +57,14 @@ void gfs2_log_incr_head(struct gfs2_sbd *sdp);
 struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp);
 struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 				      struct buffer_head *real);
-void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
+void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
+
+static inline void gfs2_log_flush(struct gfs2_sbd *sbd, struct gfs2_glock *gl)
+{
+	if (!gl || test_bit(GLF_LFLUSH, &gl->gl_flags))
+		__gfs2_log_flush(sbd, gl);
+}
+
 void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
 void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index e901f8f..fae59d6 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -87,6 +87,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	}
 	bd->bd_ail = ai;
 	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
 }
@@ -124,49 +125,6 @@ static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
 	return bh;
 }
 
-static void __glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
-{
-	struct gfs2_glock *gl;
-	struct gfs2_trans *tr = current->journal_info;
-
-	tr->tr_touched = 1;
-
-	gl = container_of(le, struct gfs2_glock, gl_le);
-	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(gl)))
-		return;
-
-	if (!list_empty(&le->le_list))
-		return;
-
-	gfs2_glock_hold(gl);
-	set_bit(GLF_DIRTY, &gl->gl_flags);
-	sdp->sd_log_num_gl++;
-	list_add(&le->le_list, &sdp->sd_log_le_gl);
-}
-
-static void glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
-{
-	gfs2_log_lock(sdp);
-	__glock_lo_add(sdp, le);
-	gfs2_log_unlock(sdp);
-}
-
-static void glock_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
-{
-	struct list_head *head = &sdp->sd_log_le_gl;
-	struct gfs2_glock *gl;
-
-	while (!list_empty(head)) {
-		gl = list_entry(head->next, struct gfs2_glock, gl_le.le_list);
-		list_del_init(&gl->gl_le.le_list);
-		sdp->sd_log_num_gl--;
-
-		gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(gl));
-		gfs2_glock_put(gl);
-	}
-	gfs2_assert_warn(sdp, !sdp->sd_log_num_gl);
-}
-
 static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 {
 	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
@@ -182,7 +140,8 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 	if (!list_empty(&le->le_list))
 		goto out;
-	__glock_lo_add(sdp, &bd->bd_gl->gl_le);
+	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	gfs2_meta_check(sdp, bd->bd_bh);
 	gfs2_pin(sdp, bd->bd_bh);
 	sdp->sd_log_num_buf++;
@@ -568,8 +527,8 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	if (!list_empty(&le->le_list))
 		goto out;
 
-	if (tr)
-		__glock_lo_add(sdp, &bd->bd_gl->gl_le);
+	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	if (gfs2_is_jdata(ip)) {
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
@@ -776,12 +735,6 @@ static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 }
 
 
-const struct gfs2_log_operations gfs2_glock_lops = {
-	.lo_add = glock_lo_add,
-	.lo_after_commit = glock_lo_after_commit,
-	.lo_name = "glock",
-};
-
 const struct gfs2_log_operations gfs2_buf_lops = {
 	.lo_add = buf_lo_add,
 	.lo_incore_commit = buf_lo_incore_commit,
@@ -819,7 +772,6 @@ const struct gfs2_log_operations gfs2_databuf_lops = {
 };
 
 const struct gfs2_log_operations *gfs2_log_ops[] = {
-	&gfs2_glock_lops,
 	&gfs2_databuf_lops,
 	&gfs2_buf_lops,
 	&gfs2_rg_lops,
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 17de58e..52aaba9 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -77,7 +77,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	spin_lock_init(&sdp->sd_log_lock);
 
-	INIT_LIST_HEAD(&sdp->sd_log_le_gl);
 	INIT_LIST_HEAD(&sdp->sd_log_le_buf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
 	INIT_LIST_HEAD(&sdp->sd_log_le_rg);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 717983e..73e5d92 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -114,11 +114,6 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 		gfs2_log_flush(sdp, NULL);
 }
 
-void gfs2_trans_add_gl(struct gfs2_glock *gl)
-{
-	lops_add(gl->gl_sbd, &gl->gl_le);
-}
-
 /**
  * gfs2_trans_add_bh - Add a to-be-modified buffer to the current transaction
  * @gl: the glock the buffer belongs to
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index 043d5f4..e826f0d 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -30,7 +30,6 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 
 void gfs2_trans_end(struct gfs2_sbd *sdp);
 
-void gfs2_trans_add_gl(struct gfs2_glock *gl);
 void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta);
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno);
-- 
1.5.1.2

