Return-Path: <linux-kernel-owner+w=401wt.eu-S964833AbYDQJlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbYDQJlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbYDQJZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933547AbYDQJZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:46 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/48] [GFS2] Eliminate gl_req_bh
Date: Thu, 17 Apr 2008 09:38:52 +0100
Message-Id: <12084216023999-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216003676-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch further reduces the memory needs of GFS2 by
eliminating the gl_req_bh variable from struct gfs2_glock.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 951cb91..a8387e0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -338,7 +338,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_ip = 0;
 	gl->gl_ops = glops;
 	gl->gl_req_gh = NULL;
-	gl->gl_req_bh = NULL;
 	gl->gl_vn = 0;
 	gl->gl_stamp = jiffies;
 	gl->gl_tchange = jiffies;
@@ -744,6 +743,50 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 }
 
 /**
+ * drop_bh - Called after a lock module unlock completes
+ * @gl: the glock
+ * @ret: the return status
+ *
+ * Doesn't wake up the process waiting on the struct gfs2_holder (if any)
+ * Doesn't drop the reference on the glock the top half took out
+ *
+ */
+
+static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
+{
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	struct gfs2_holder *gh = gl->gl_req_gh;
+
+	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
+	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
+	gfs2_assert_warn(sdp, !ret);
+
+	state_change(gl, LM_ST_UNLOCKED);
+
+	if (glops->go_inval)
+		glops->go_inval(gl, DIO_METADATA);
+
+	if (gh) {
+		spin_lock(&gl->gl_spin);
+		list_del_init(&gh->gh_list);
+		gh->gh_error = 0;
+		spin_unlock(&gl->gl_spin);
+	}
+
+	spin_lock(&gl->gl_spin);
+	gfs2_demote_wake(gl);
+	gl->gl_req_gh = NULL;
+	clear_bit(GLF_LOCK, &gl->gl_flags);
+	spin_unlock(&gl->gl_spin);
+
+	gfs2_glock_put(gl);
+
+	if (gh)
+		gfs2_holder_wake(gh);
+}
+
+/**
  * xmote_bh - Called after the lock module is done acquiring a lock
  * @gl: The glock in question
  * @ret: the int returned from the lock module
@@ -758,6 +801,11 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 	int prev_state = gl->gl_state;
 	int op_done = 1;
 
+	if ((ret & LM_OUT_ST_MASK) == LM_ST_UNLOCKED) {
+		drop_bh(gl, ret);
+		return;
+	}
+
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
 	gfs2_assert_warn(sdp, !(ret & LM_OUT_ASYNC));
@@ -783,7 +831,6 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 		} else {
 			spin_lock(&gl->gl_spin);
 			if (gl->gl_state != gl->gl_demote_state) {
-				gl->gl_req_bh = NULL;
 				spin_unlock(&gl->gl_spin);
 				gfs2_glock_drop_th(gl);
 				gfs2_glock_put(gl);
@@ -825,7 +872,6 @@ out:
 	if (op_done) {
 		spin_lock(&gl->gl_spin);
 		gl->gl_req_gh = NULL;
-		gl->gl_req_bh = NULL;
 		clear_bit(GLF_LOCK, &gl->gl_flags);
 		spin_unlock(&gl->gl_spin);
 	}
@@ -864,7 +910,6 @@ static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
 	gfs2_assert_warn(sdp, state != gl->gl_state);
 
 	gfs2_glock_hold(gl);
-	gl->gl_req_bh = xmote_bh;
 
 	lck_ret = gfs2_lm_lock(sdp, gl->gl_lock, gl->gl_state, state, lck_flags);
 
@@ -878,51 +923,6 @@ static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
 }
 
 /**
- * drop_bh - Called after a lock module unlock completes
- * @gl: the glock
- * @ret: the return status
- *
- * Doesn't wake up the process waiting on the struct gfs2_holder (if any)
- * Doesn't drop the reference on the glock the top half took out
- *
- */
-
-static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	struct gfs2_holder *gh = gl->gl_req_gh;
-
-	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
-	gfs2_assert_warn(sdp, !ret);
-
-	state_change(gl, LM_ST_UNLOCKED);
-
-	if (glops->go_inval)
-		glops->go_inval(gl, DIO_METADATA);
-
-	if (gh) {
-		spin_lock(&gl->gl_spin);
-		list_del_init(&gh->gh_list);
-		gh->gh_error = 0;
-		spin_unlock(&gl->gl_spin);
-	}
-
-	spin_lock(&gl->gl_spin);
-	gfs2_demote_wake(gl);
-	gl->gl_req_gh = NULL;
-	gl->gl_req_bh = NULL;
-	clear_bit(GLF_LOCK, &gl->gl_flags);
-	spin_unlock(&gl->gl_spin);
-
-	gfs2_glock_put(gl);
-
-	if (gh)
-		gfs2_holder_wake(gh);
-}
-
-/**
  * gfs2_glock_drop_th - call into the lock module to unlock a lock
  * @gl: the glock
  *
@@ -942,7 +942,6 @@ static void gfs2_glock_drop_th(struct gfs2_glock *gl)
 	gfs2_assert_warn(sdp, gl->gl_state != LM_ST_UNLOCKED);
 
 	gfs2_glock_hold(gl);
-	gl->gl_req_bh = drop_bh;
 
 	ret = gfs2_lm_unlock(sdp, gl->gl_lock, gl->gl_state);
 
@@ -971,8 +970,7 @@ static void do_cancels(struct gfs2_holder *gh)
 	while (gl->gl_req_gh != gh &&
 	       !test_bit(HIF_HOLDER, &gh->gh_iflags) &&
 	       !list_empty(&gh->gh_list)) {
-		if (gl->gl_req_bh && !(gl->gl_req_gh &&
-				     (gl->gl_req_gh->gh_flags & GL_NOCANCEL))) {
+		if (!(gl->gl_req_gh && (gl->gl_req_gh->gh_flags & GL_NOCANCEL))) {
 			spin_unlock(&gl->gl_spin);
 			gfs2_lm_cancel(gl->gl_sbd, gl->gl_lock);
 			msleep(100);
@@ -1042,7 +1040,6 @@ static int glock_wait_internal(struct gfs2_holder *gh)
 
 		spin_lock(&gl->gl_spin);
 		gl->gl_req_gh = NULL;
-		gl->gl_req_bh = NULL;
 		clear_bit(GLF_LOCK, &gl->gl_flags);
 		run_queue(gl);
 		spin_unlock(&gl->gl_spin);
@@ -1535,8 +1532,7 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
 		gl = gfs2_glock_find(sdp, &async->lc_name);
 		if (gfs2_assert_warn(sdp, gl))
 			return;
-		if (!gfs2_assert_warn(sdp, gl->gl_req_bh))
-			gl->gl_req_bh(gl, async->lc_ret);
+		xmote_bh(gl, async->lc_ret);
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 			gfs2_glock_put(gl);
 		up_read(&gfs2_umount_flush_sem);
@@ -1898,7 +1894,6 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 		print_dbg(gi, "  gl_owner = -1\n");
 	print_dbg(gi, "  gl_ip = %lu\n", gl->gl_ip);
 	print_dbg(gi, "  req_gh = %s\n", (gl->gl_req_gh) ? "yes" : "no");
-	print_dbg(gi, "  req_bh = %s\n", (gl->gl_req_bh) ? "yes" : "no");
 	print_dbg(gi, "  lvb_count = %d\n", atomic_read(&gl->gl_lvb_count));
 	print_dbg(gi, "  object = %s\n", (gl->gl_object) ? "yes" : "no");
 	print_dbg(gi, "  reclaim = %s\n",
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index fe14f6a..65aa46a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -191,7 +191,6 @@ struct gfs2_glock {
 	const struct gfs2_glock_operations *gl_ops;
 
 	struct gfs2_holder *gl_req_gh;
-	gfs2_glop_bh_t gl_req_bh;
 
 	void *gl_lock;
 	char *gl_lvb;
-- 
1.5.1.2

