Return-Path: <linux-kernel-owner+w=401wt.eu-S935200AbYDQJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200AbYDQJzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933574AbYDQJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933765AbYDQJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:49 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 46/48] [GFS2] Invalidate cache at correct point
Date: Thu, 17 Apr 2008 09:39:22 +0100
Message-Id: <12084216641014-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216611008-git-send-email-swhiteho@redhat.com>
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
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
 <1208421647805-git-send-email-swhiteho@redhat.com>
 <12084216494161-git-send-email-swhiteho@redhat.com>
 <12084216511207-git-send-email-swhiteho@redhat.com>
 <12084216533319-git-send-email-swhiteho@redhat.com>
 <12084216553542-git-send-email-swhiteho@redhat.com>
 <1208421657826-git-send-email-swhiteho@redhat.com>
 <12084216593910-git-send-email-swhiteho@redhat.com>
 <12084216611008-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 wasn't invalidating its cache before it called into the lock manager
with a request that could potentially drop a lock.  This was leaving a
window where the lock could be actually be held by another node, but the
file's page cache would still appear valid, causing coherency problems.
This patch moves the cache invalidation to before the lock manager call
when dropping a lock. It also adds the option to the lock_dlm lock
manager to not use conversion mode deadlock avoidance, which, on a
conversion from shared to exclusive, could internally drop the lock, and
then reacquire in. GFS2 now asks lock_dlm to not do this.  Instead, GFS2
manually drops the lock and reacquires it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 63981e2..d636b3e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -764,7 +764,7 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	struct gfs2_holder *gh = gl->gl_req_gh;
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
@@ -772,8 +772,14 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 
 	state_change(gl, LM_ST_UNLOCKED);
 
-	if (glops->go_inval)
-		glops->go_inval(gl, DIO_METADATA);
+	if (test_and_clear_bit(GLF_CONV_DEADLK, &gl->gl_flags)) {
+		spin_lock(&gl->gl_spin);
+		gh->gh_error = 0;
+		spin_unlock(&gl->gl_spin);
+		gfs2_glock_xmote_th(gl, gl->gl_req_gh);
+		gfs2_glock_put(gl);
+		return;
+	}
 
 	spin_lock(&gl->gl_spin);
 	gfs2_demote_wake(gl);
@@ -794,7 +800,6 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh = gl->gl_req_gh;
-	int prev_state = gl->gl_state;
 	int op_done = 1;
 
 	if (!gh && (ret & LM_OUT_ST_MASK) == LM_ST_UNLOCKED) {
@@ -808,16 +813,6 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 
 	state_change(gl, ret & LM_OUT_ST_MASK);
 
-	if (prev_state != LM_ST_UNLOCKED && !(ret & LM_OUT_CACHEABLE)) {
-		if (glops->go_inval)
-			glops->go_inval(gl, DIO_METADATA);
-	} else if (gl->gl_state == LM_ST_DEFERRED) {
-		/* We might not want to do this here.
-		   Look at moving to the inode glops. */
-		if (glops->go_inval)
-			glops->go_inval(gl, 0);
-	}
-
 	/*  Deal with each possible exit condition  */
 
 	if (!gh) {
@@ -837,6 +832,14 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 		}
 	} else {
 		spin_lock(&gl->gl_spin);
+		if (ret & LM_OUT_CONV_DEADLK) {
+			gh->gh_error = 0;
+			set_bit(GLF_CONV_DEADLK, &gl->gl_flags);
+			spin_unlock(&gl->gl_spin);
+			gfs2_glock_drop_th(gl);
+			gfs2_glock_put(gl);
+			return;
+		}
 		list_del_init(&gh->gh_list);
 		gh->gh_error = -EIO;
 		if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) 
@@ -910,6 +913,8 @@ static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
 
 	if (glops->go_xmote_th)
 		glops->go_xmote_th(gl);
+	if (state == LM_ST_DEFERRED && glops->go_inval)
+		glops->go_inval(gl, DIO_METADATA);
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
@@ -952,6 +957,8 @@ static void gfs2_glock_drop_th(struct gfs2_glock *gl)
 
 	if (glops->go_xmote_th)
 		glops->go_xmote_th(gl);
+	if (glops->go_inval)
+		glops->go_inval(gl, DIO_METADATA);
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4ba2ea6..9c2c0b9 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -167,6 +167,7 @@ enum {
 	GLF_DEMOTE_IN_PROGRESS	= 6,
 	GLF_LFLUSH		= 7,
 	GLF_WAITERS2		= 8,
+	GLF_CONV_DEADLK		= 9,
 };
 
 struct gfs2_glock {
diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index 542a797..53a6ab3 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -137,7 +137,8 @@ static inline unsigned int make_flags(struct gdlm_lock *lp,
 
 		/* Conversion deadlock avoidance by DLM */
 
-		if (!test_bit(LFL_FORCE_PROMOTE, &lp->flags) &&
+		if (!(lp->ls->fsflags & LM_MFLAG_CONV_NODROP) &&
+		    !test_bit(LFL_FORCE_PROMOTE, &lp->flags) &&
 		    !(lkf & DLM_LKF_NOQUEUE) &&
 		    cur > DLM_LOCK_NL && req > DLM_LOCK_NL && cur != req)
 			lkf |= DLM_LKF_CONVDEADLK;
diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
index 521694f..e53db6f 100644
--- a/fs/gfs2/locking/dlm/thread.c
+++ b/fs/gfs2/locking/dlm/thread.c
@@ -135,7 +135,15 @@ static void process_complete(struct gdlm_lock *lp)
 			 lp->lksb.sb_status, lp->lockname.ln_type,
 			 (unsigned long long)lp->lockname.ln_number,
 			 lp->flags);
-		return;
+		if (lp->lksb.sb_status == -EDEADLOCK &&
+		    lp->ls->fsflags & LM_MFLAG_CONV_NODROP) {
+			lp->req = lp->cur;
+			acb.lc_ret |= LM_OUT_CONV_DEADLK;
+			if (lp->cur == DLM_LOCK_IV)
+				lp->lksb.sb_lkid = 0;
+			goto out;
+		} else
+			return;
 	}
 
 	/*
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5b518f7..ef9c6c4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -723,7 +723,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 {
 	char *proto = sdp->sd_proto_name;
 	char *table = sdp->sd_table_name;
-	int flags = 0;
+	int flags = LM_MFLAG_CONV_NODROP;
 	int error;
 
 	if (sdp->sd_args.ar_spectator)
diff --git a/include/linux/lm_interface.h b/include/linux/lm_interface.h
index 1418fdc..f274997 100644
--- a/include/linux/lm_interface.h
+++ b/include/linux/lm_interface.h
@@ -21,9 +21,15 @@ typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
  * modify the filesystem.  The lock module shouldn't assign a journal to the FS
  * mount.  It shouldn't send recovery callbacks to the FS mount.  If the node
  * dies or withdraws, all locks can be wiped immediately.
+ *
+ * LM_MFLAG_CONV_NODROP
+ * Do not allow the dlm to internally resolve conversion deadlocks by demoting
+ * the lock to unlocked and then reacquiring it in the requested mode. Instead,
+ * it should cancel the request and return LM_OUT_CONV_DEADLK.
  */
 
 #define LM_MFLAG_SPECTATOR	0x00000001
+#define LM_MFLAG_CONV_NODROP	0x00000002
 
 /*
  * lm_lockstruct flags
@@ -110,6 +116,9 @@ typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
  *
  * LM_OUT_ASYNC
  * The result of the request will be returned in an LM_CB_ASYNC callback.
+ *
+ * LM_OUT_CONV_DEADLK
+ * The lock request was canceled do to a conversion deadlock.
  */
 
 #define LM_OUT_ST_MASK		0x00000003
@@ -117,6 +126,7 @@ typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
 #define LM_OUT_CANCELED		0x00000008
 #define LM_OUT_ASYNC		0x00000080
 #define LM_OUT_ERROR		0x00000100
+#define LM_OUT_CONV_DEADLK	0x00000200
 
 /*
  * lm_callback_t types
-- 
1.5.1.2

