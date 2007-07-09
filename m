Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbXGIQgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbXGIQgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbXGIQYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360AbXGIQYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:22 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Fix deallocation issues
Date: Mon,  9 Jul 2007 17:02:45 +0100
Message-Id: <1183997067333-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970653759-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

There were two issues during deallocation of unlinked inodes. The
first was relating to the use of a "try" lock which in the case of
the inode lock wasn't trying hard enough to deallocate in all
circumstances (now changed to a normal glock) and in the case of
the iopen lock didn't wait for the demotion of the shared lock before
attempting to get the exclusive lock, and thereby sometimes (timing dependent)
not completing the deallocation when it should have done.

The second issue related to the lack of a way to invalidate dcache entries
on remote nodes (now fixed by this patch) which meant that unlinks were
taking a long time to return disk space to the fs. By adding some code to
invalidate the dcache entries across the cluster for unlinked inodes, that
is now fixed.

This patch was written jointly by Abhijith Das and Steven Whitehouse.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b3ed585..384cae6 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -422,11 +422,11 @@ void gfs2_holder_uninit(struct gfs2_holder *gh)
 static void gfs2_holder_wake(struct gfs2_holder *gh)
 {
 	clear_bit(HIF_WAIT, &gh->gh_iflags);
-	smp_mb();
+	smp_mb__after_clear_bit();
 	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
 }
 
-static int holder_wait(void *word)
+static int just_schedule(void *word)
 {
         schedule();
         return 0;
@@ -435,7 +435,20 @@ static int holder_wait(void *word)
 static void wait_on_holder(struct gfs2_holder *gh)
 {
 	might_sleep();
-	wait_on_bit(&gh->gh_iflags, HIF_WAIT, holder_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&gh->gh_iflags, HIF_WAIT, just_schedule, TASK_UNINTERRUPTIBLE);
+}
+
+static void gfs2_demote_wake(struct gfs2_glock *gl)
+{
+        clear_bit(GLF_DEMOTE, &gl->gl_flags);
+        smp_mb__after_clear_bit();
+        wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
+}
+
+static void wait_on_demote(struct gfs2_glock *gl)
+{
+	might_sleep();
+	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, just_schedule, TASK_UNINTERRUPTIBLE);
 }
 
 /**
@@ -528,7 +541,7 @@ static int rq_demote(struct gfs2_glock *gl)
 
 	if (gl->gl_state == gl->gl_demote_state ||
 	    gl->gl_state == LM_ST_UNLOCKED) {
-		clear_bit(GLF_DEMOTE, &gl->gl_flags);
+		gfs2_demote_wake(gl);
 		return 0;
 	}
 	set_bit(GLF_LOCK, &gl->gl_flags);
@@ -666,12 +679,22 @@ static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
  * practise: LM_ST_SHARED and LM_ST_UNLOCKED
  */
 
-static void handle_callback(struct gfs2_glock *gl, unsigned int state)
+static void handle_callback(struct gfs2_glock *gl, unsigned int state, int remote)
 {
 	spin_lock(&gl->gl_spin);
 	if (test_and_set_bit(GLF_DEMOTE, &gl->gl_flags) == 0) {
 		gl->gl_demote_state = state;
 		gl->gl_demote_time = jiffies;
+		if (remote && gl->gl_ops->go_type == LM_TYPE_IOPEN &&
+		    gl->gl_object) {
+			struct inode *inode = igrab(gl->gl_object);
+			spin_unlock(&gl->gl_spin);
+			if (inode) {
+				d_prune_aliases(inode);
+				iput(inode);
+			}
+			return;
+		}
 	} else if (gl->gl_demote_state != LM_ST_UNLOCKED) {
 		gl->gl_demote_state = state;
 	}
@@ -740,7 +763,7 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 		if (ret & LM_OUT_CANCELED)
 			op_done = 0;
 		else
-			clear_bit(GLF_DEMOTE, &gl->gl_flags);
+			gfs2_demote_wake(gl);
 	} else {
 		spin_lock(&gl->gl_spin);
 		list_del_init(&gh->gh_list);
@@ -848,7 +871,7 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	gfs2_assert_warn(sdp, !ret);
 
 	state_change(gl, LM_ST_UNLOCKED);
-	clear_bit(GLF_DEMOTE, &gl->gl_flags);
+	gfs2_demote_wake(gl);
 
 	if (glops->go_inval)
 		glops->go_inval(gl, DIO_METADATA);
@@ -1174,7 +1197,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 
 	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED);
+		handle_callback(gl, LM_ST_UNLOCKED, 0);
 
 	gfs2_glmutex_lock(gl);
 
@@ -1196,6 +1219,13 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	spin_unlock(&gl->gl_spin);
 }
 
+void gfs2_glock_dq_wait(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+	gfs2_glock_dq(gh);
+	wait_on_demote(gl);
+}
+
 /**
  * gfs2_glock_dq_uninit - dequeue a holder from a glock and initialize it
  * @gh: the holder structure
@@ -1456,7 +1486,7 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 	if (!gl)
 		return;
 
-	handle_callback(gl, state);
+	handle_callback(gl, state, 1);
 
 	spin_lock(&gl->gl_spin);
 	run_queue(gl);
@@ -1596,7 +1626,7 @@ void gfs2_reclaim_glock(struct gfs2_sbd *sdp)
 	if (gfs2_glmutex_trylock(gl)) {
 		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
-			handle_callback(gl, LM_ST_UNLOCKED);
+			handle_callback(gl, LM_ST_UNLOCKED, 0);
 		gfs2_glmutex_unlock(gl);
 	}
 
@@ -1709,7 +1739,7 @@ static void clear_glock(struct gfs2_glock *gl)
 	if (gfs2_glmutex_trylock(gl)) {
 		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED)
-			handle_callback(gl, LM_ST_UNLOCKED);
+			handle_callback(gl, LM_ST_UNLOCKED, 0);
 		gfs2_glmutex_unlock(gl);
 	}
 }
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index b3e152d..7721ca3 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -87,6 +87,7 @@ int gfs2_glock_nq(struct gfs2_holder *gh);
 int gfs2_glock_poll(struct gfs2_holder *gh);
 int gfs2_glock_wait(struct gfs2_holder *gh);
 void gfs2_glock_dq(struct gfs2_holder *gh);
+void gfs2_glock_dq_wait(struct gfs2_holder *gh);
 
 void gfs2_glock_dq_uninit(struct gfs2_holder *gh);
 int gfs2_glock_nq_num(struct gfs2_sbd *sdp,
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 366235d..792d64f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -114,6 +114,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned in
 		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 		if (unlikely(error))
 			goto fail_iopen;
+		ip->i_iopen_gh.gh_gl->gl_object = ip;
 
 		gfs2_glock_put(io_gl);
 
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 485ce3d..603d940 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -326,8 +326,10 @@ static void gfs2_clear_inode(struct inode *inode)
 		gfs2_glock_schedule_for_reclaim(ip->i_gl);
 		gfs2_glock_put(ip->i_gl);
 		ip->i_gl = NULL;
-		if (ip->i_iopen_gh.gh_gl)
+		if (ip->i_iopen_gh.gh_gl) {
+			ip->i_iopen_gh.gh_gl->gl_object = NULL;
 			gfs2_glock_dq_uninit(&ip->i_iopen_gh);
+		}
 	}
 }
 
@@ -422,13 +424,13 @@ static void gfs2_delete_inode(struct inode *inode)
 	if (!inode->i_private)
 		goto out;
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, LM_FLAG_TRY_1CB, &gh);
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	if (unlikely(error)) {
 		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 		goto out;
 	}
 
-	gfs2_glock_dq(&ip->i_iopen_gh);
+	gfs2_glock_dq_wait(&ip->i_iopen_gh);
 	gfs2_holder_reinit(LM_ST_EXCLUSIVE, LM_FLAG_TRY_1CB | GL_NOCACHE, &ip->i_iopen_gh);
 	error = gfs2_glock_nq(&ip->i_iopen_gh);
 	if (error)
-- 
1.5.1.2

