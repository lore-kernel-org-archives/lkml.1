Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXBEO1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXBEO1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXBEO1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:27:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911AbXBEO1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:27:53 -0500
Subject: [GFS2] Tidy up glops calls [34/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:35:56 +0000
Message-Id: <1170686156.11001.339.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From dfa37e755f86caee54447efb24ffc4b3bcf4d837 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 22 Jan 2007 12:15:34 -0500
Subject: [PATCH] [GFS2] Tidy up glops calls

This patch doesn't make any changes to the ordering of the various
operations related to glocking, but it does tidy up the calls to the
glops.c functions to make the structure more obvious.

The two functions: gfs2_glock_xmote_th() and gfs2_glock_drop_th() can be
made static within glock.c since they are called by every set of glock
operations. The xmote_th and drop_th glock operations are then made
conditional upon those two routines existing and called from the
previously mentioned functions in glock.c respectively.

Also it can be seen that the go_sync operation isn't needed since it can
easily be replaced by calls to xmote_bh and drop_bh respectively. This
results in no longer (confusingly) calling back into routines in glock.c
from glops.c and also reducing the glock operations by one member.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1345c3d..5b772bb 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -43,6 +43,8 @@ typedef void (*glock_examiner) (struct gfs2_glock * gl);
 static int gfs2_dump_lockstate(struct gfs2_sbd *sdp);
 static int dump_glock(struct gfs2_glock *gl);
 static int dump_inode(struct gfs2_inode *ip);
+static void gfs2_glock_xmote_th(struct gfs2_holder *gh);
+static void gfs2_glock_drop_th(struct gfs2_glock *gl);
 
 #define GFS2_GL_HASH_SHIFT      15
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
@@ -524,7 +526,6 @@ static int rq_promote(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
 
 	if (!relaxed_state_ok(gl->gl_state, gh->gh_state, gh->gh_flags)) {
 		if (list_empty(&gl->gl_holders)) {
@@ -539,7 +540,7 @@ static int rq_promote(struct gfs2_holder *gh)
 				gfs2_reclaim_glock(sdp);
 			}
 
-			glops->go_xmote_th(gl, gh->gh_state, gh->gh_flags);
+			gfs2_glock_xmote_th(gh);
 			spin_lock(&gl->gl_spin);
 		}
 		return 1;
@@ -577,7 +578,6 @@ static int rq_promote(struct gfs2_holder *gh)
 static int rq_demote(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
 
 	if (!list_empty(&gl->gl_holders))
 		return 1;
@@ -595,9 +595,9 @@ static int rq_demote(struct gfs2_holder *gh)
 
 		if (gh->gh_state == LM_ST_UNLOCKED ||
 		    gl->gl_state != LM_ST_EXCLUSIVE)
-			glops->go_drop_th(gl);
+			gfs2_glock_drop_th(gl);
 		else
-			glops->go_xmote_th(gl, gh->gh_state, gh->gh_flags);
+			gfs2_glock_xmote_th(gh);
 
 		spin_lock(&gl->gl_spin);
 	}
@@ -909,23 +909,26 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
  *
  */
 
-void gfs2_glock_xmote_th(struct gfs2_glock *gl, unsigned int state, int flags)
+void gfs2_glock_xmote_th(struct gfs2_holder *gh)
 {
+	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
+	int flags = gh->gh_flags;
+	unsigned state = gh->gh_state;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	int lck_flags = flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB |
 				 LM_FLAG_NOEXP | LM_FLAG_ANY |
 				 LM_FLAG_PRIORITY);
 	unsigned int lck_ret;
 
+	if (glops->go_xmote_th)
+		glops->go_xmote_th(gl);
+
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
 	gfs2_assert_warn(sdp, state != LM_ST_UNLOCKED);
 	gfs2_assert_warn(sdp, state != gl->gl_state);
 
-	if (gl->gl_state == LM_ST_EXCLUSIVE && glops->go_sync)
-		glops->go_sync(gl);
-
 	gfs2_glock_hold(gl);
 	gl->gl_req_bh = xmote_bh;
 
@@ -994,19 +997,19 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
  *
  */
 
-void gfs2_glock_drop_th(struct gfs2_glock *gl)
+static void gfs2_glock_drop_th(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	unsigned int ret;
 
+	if (glops->go_drop_th)
+		glops->go_drop_th(gl);
+
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
 	gfs2_assert_warn(sdp, gl->gl_state != LM_ST_UNLOCKED);
 
-	if (gl->gl_state == LM_ST_EXCLUSIVE && glops->go_sync)
-		glops->go_sync(gl);
-
 	gfs2_glock_hold(gl);
 	gl->gl_req_bh = drop_bh;
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 1eaeacd..f50e40c 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -82,10 +82,6 @@ void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 void gfs2_holder_reinit(unsigned int state, unsigned flags,
 			struct gfs2_holder *gh);
 void gfs2_holder_uninit(struct gfs2_holder *gh);
-
-void gfs2_glock_xmote_th(struct gfs2_glock *gl, unsigned int state, int flags);
-void gfs2_glock_drop_th(struct gfs2_glock *gl);
-
 int gfs2_glock_nq(struct gfs2_holder *gh);
 int gfs2_glock_poll(struct gfs2_holder *gh);
 int gfs2_glock_wait(struct gfs2_holder *gh);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index dda6858..c4b0391 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -117,12 +117,14 @@ static void gfs2_pte_inval(struct gfs2_glock *gl)
 
 static void meta_go_sync(struct gfs2_glock *gl)
 {
+	if (gl->gl_state != LM_ST_EXCLUSIVE)
+		return;
+
 	if (test_and_clear_bit(GLF_DIRTY, &gl->gl_flags)) {
 		gfs2_log_flush(gl->gl_sbd, gl);
 		gfs2_meta_sync(gl);
 		gfs2_ail_empty_gl(gl);
 	}
-
 }
 
 /**
@@ -142,6 +144,37 @@ static void meta_go_inval(struct gfs2_glock *gl, int flags)
 }
 
 /**
+ * inode_go_sync - Sync the dirty data and/or metadata for an inode glock
+ * @gl: the glock protecting the inode
+ *
+ */
+
+static void inode_go_sync(struct gfs2_glock *gl)
+{
+	struct gfs2_inode *ip = gl->gl_object;
+
+	if (ip && !S_ISREG(ip->i_inode.i_mode))
+		ip = NULL;
+
+	if (test_bit(GLF_DIRTY, &gl->gl_flags)) {
+		gfs2_log_flush(gl->gl_sbd, gl);
+		if (ip)
+			filemap_fdatawrite(ip->i_inode.i_mapping);
+		gfs2_meta_sync(gl);
+		if (ip) {
+			struct address_space *mapping = ip->i_inode.i_mapping;
+			int error = filemap_fdatawait(mapping);
+			if (error == -ENOSPC)
+				set_bit(AS_ENOSPC, &mapping->flags);
+			else if (error)
+				set_bit(AS_EIO, &mapping->flags);
+		}
+		clear_bit(GLF_DIRTY, &gl->gl_flags);
+		gfs2_ail_empty_gl(gl);
+	}
+}
+
+/**
  * inode_go_xmote_th - promote/demote a glock
  * @gl: the glock
  * @state: the requested state
@@ -149,12 +182,12 @@ static void meta_go_inval(struct gfs2_glock *gl, int flags)
  *
  */
 
-static void inode_go_xmote_th(struct gfs2_glock *gl, unsigned int state,
-			      int flags)
+static void inode_go_xmote_th(struct gfs2_glock *gl)
 {
 	if (gl->gl_state != LM_ST_UNLOCKED)
 		gfs2_pte_inval(gl);
-	gfs2_glock_xmote_th(gl, state, flags);
+	if (gl->gl_state == LM_ST_EXCLUSIVE)
+		inode_go_sync(gl);
 }
 
 /**
@@ -189,38 +222,8 @@ static void inode_go_xmote_bh(struct gfs2_glock *gl)
 static void inode_go_drop_th(struct gfs2_glock *gl)
 {
 	gfs2_pte_inval(gl);
-	gfs2_glock_drop_th(gl);
-}
-
-/**
- * inode_go_sync - Sync the dirty data and/or metadata for an inode glock
- * @gl: the glock protecting the inode
- *
- */
-
-static void inode_go_sync(struct gfs2_glock *gl)
-{
-	struct gfs2_inode *ip = gl->gl_object;
-
-	if (ip && !S_ISREG(ip->i_inode.i_mode))
-		ip = NULL;
-
-	if (test_bit(GLF_DIRTY, &gl->gl_flags)) {
-		gfs2_log_flush(gl->gl_sbd, gl);
-		if (ip)
-			filemap_fdatawrite(ip->i_inode.i_mapping);
-		gfs2_meta_sync(gl);
-		if (ip) {
-			struct address_space *mapping = ip->i_inode.i_mapping;
-			int error = filemap_fdatawait(mapping);
-			if (error == -ENOSPC)
-				set_bit(AS_ENOSPC, &mapping->flags);
-			else if (error)
-				set_bit(AS_EIO, &mapping->flags);
-		}
-		clear_bit(GLF_DIRTY, &gl->gl_flags);
-		gfs2_ail_empty_gl(gl);
-	}
+	if (gl->gl_state == LM_ST_EXCLUSIVE)
+		inode_go_sync(gl);
 }
 
 /**
@@ -365,8 +368,7 @@ static void rgrp_go_unlock(struct gfs2_holder *gh)
  *
  */
 
-static void trans_go_xmote_th(struct gfs2_glock *gl, unsigned int state,
-			      int flags)
+static void trans_go_xmote_th(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 
@@ -375,8 +377,6 @@ static void trans_go_xmote_th(struct gfs2_glock *gl, unsigned int state,
 		gfs2_meta_syncfs(sdp);
 		gfs2_log_shutdown(sdp);
 	}
-
-	gfs2_glock_xmote_th(gl, state, flags);
 }
 
 /**
@@ -428,8 +428,6 @@ static void trans_go_drop_th(struct gfs2_glock *gl)
 		gfs2_meta_syncfs(sdp);
 		gfs2_log_shutdown(sdp);
 	}
-
-	gfs2_glock_drop_th(gl);
 }
 
 /**
@@ -445,8 +443,8 @@ static int quota_go_demote_ok(struct gfs2_glock *gl)
 }
 
 const struct gfs2_glock_operations gfs2_meta_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
+	.go_xmote_th = meta_go_sync,
+	.go_drop_th = meta_go_sync,
 	.go_type = LM_TYPE_META,
 };
 
@@ -454,7 +452,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_xmote_th = inode_go_xmote_th,
 	.go_xmote_bh = inode_go_xmote_bh,
 	.go_drop_th = inode_go_drop_th,
-	.go_sync = inode_go_sync,
 	.go_inval = inode_go_inval,
 	.go_demote_ok = inode_go_demote_ok,
 	.go_lock = inode_go_lock,
@@ -463,9 +460,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
-	.go_sync = meta_go_sync,
 	.go_inval = meta_go_inval,
 	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
@@ -481,33 +475,23 @@ const struct gfs2_glock_operations gfs2_trans_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_iopen_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
 	.go_type = LM_TYPE_IOPEN,
 };
 
 const struct gfs2_glock_operations gfs2_flock_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
 	.go_type = LM_TYPE_FLOCK,
 };
 
 const struct gfs2_glock_operations gfs2_nondisk_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
 	.go_type = LM_TYPE_NONDISK,
 };
 
 const struct gfs2_glock_operations gfs2_quota_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
 	.go_demote_ok = quota_go_demote_ok,
 	.go_type = LM_TYPE_QUOTA,
 };
 
 const struct gfs2_glock_operations gfs2_journal_glops = {
-	.go_xmote_th = gfs2_glock_xmote_th,
-	.go_drop_th = gfs2_glock_drop_th,
 	.go_type = LM_TYPE_JOURNAL,
 };
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 1acbcc2..12c80fd 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -101,11 +101,10 @@ struct gfs2_bufdata {
 };
 
 struct gfs2_glock_operations {
-	void (*go_xmote_th) (struct gfs2_glock *gl, unsigned int state, int flags);
+	void (*go_xmote_th) (struct gfs2_glock *gl);
 	void (*go_xmote_bh) (struct gfs2_glock *gl);
 	void (*go_drop_th) (struct gfs2_glock *gl);
 	void (*go_drop_bh) (struct gfs2_glock *gl);
-	void (*go_sync) (struct gfs2_glock *gl);
 	void (*go_inval) (struct gfs2_glock *gl, int flags);
 	int (*go_demote_ok) (struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
-- 
1.4.4.2



