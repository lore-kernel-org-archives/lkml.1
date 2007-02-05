Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbXBEO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbXBEO0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXBEO0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:26:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbXBEO0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:26:32 -0500
Subject: [GFS2] Remove local exclusive glock mode [32/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:34:37 +0000
Message-Id: <1170686077.11001.335.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From aadcc809aad4d4bb8915384a3725097ee3e47405 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 22 Jan 2007 12:10:39 -0500
Subject: [PATCH] [GFS2] Remove local exclusive glock mode

Here is a patch for GFS2 to remove the local exclusive flag. In
the places it was used, mutex's are always held earlier in the
call path, so it appears redundant in the LM_ST_SHARED case.

Also, the GFS2 holders were setting local exclusive in any case where
the requested lock was LM_ST_EXCLUSIVE. So the other places in the glock
code where the flag was tested have been replaced with tests for the
lock state being LM_ST_EXCLUSIVE in order to ensure the logic is the
same as before (i.e. LM_ST_EXCLUSIVE is always locally exclusive as well
as globally exclusive).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8e4b55a..1345c3d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -391,10 +391,6 @@ void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 	gh->gh_flags = flags;
 	gh->gh_error = 0;
 	gh->gh_iflags = 0;
-
-	if (gh->gh_state == LM_ST_EXCLUSIVE)
-		gh->gh_flags |= GL_LOCAL_EXCL;
-
 	gfs2_glock_hold(gl);
 }
 
@@ -412,9 +408,6 @@ void gfs2_holder_reinit(unsigned int state, unsigned flags, struct gfs2_holder *
 {
 	gh->gh_state = state;
 	gh->gh_flags = flags;
-	if (gh->gh_state == LM_ST_EXCLUSIVE)
-		gh->gh_flags |= GL_LOCAL_EXCL;
-
 	gh->gh_iflags &= 1 << HIF_ALLOCED;
 	gh->gh_ip = (unsigned long)__builtin_return_address(0);
 }
@@ -557,11 +550,11 @@ static int rq_promote(struct gfs2_holder *gh)
 		set_bit(GLF_LOCK, &gl->gl_flags);
 	} else {
 		struct gfs2_holder *next_gh;
-		if (gh->gh_flags & GL_LOCAL_EXCL)
+		if (gh->gh_state == LM_ST_EXCLUSIVE)
 			return 1;
 		next_gh = list_entry(gl->gl_holders.next, struct gfs2_holder,
 				     gh_list);
-		if (next_gh->gh_flags & GL_LOCAL_EXCL)
+		if (next_gh->gh_state == LM_ST_EXCLUSIVE)
 			 return 1;
 	}
 
@@ -1363,10 +1356,7 @@ static int glock_compare(const void *arg_a, const void *arg_b)
 		return 1;
 	if (a->ln_number < b->ln_number)
 		return -1;
-	if (gh_a->gh_state == LM_ST_SHARED && gh_b->gh_state == LM_ST_EXCLUSIVE)
-		return 1;
-	if (!(gh_a->gh_flags & GL_LOCAL_EXCL) && (gh_b->gh_flags & GL_LOCAL_EXCL))
-		return 1;
+	BUG_ON(gh_a->gh_gl->gl_ops->go_type == gh_b->gh_gl->gl_ops->go_type);
 	return 0;
 }
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index ddc56dc..1eaeacd 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -20,7 +20,6 @@
 #define LM_FLAG_ANY		0x00000008
 #define LM_FLAG_PRIORITY	0x00000010 */
 
-#define GL_LOCAL_EXCL		0x00000020
 #define GL_ASYNC		0x00000040
 #define GL_EXACT		0x00000080
 #define GL_SKIP			0x00000100
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index e4da26f..dda6858 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -295,7 +295,7 @@ static int inode_go_lock(struct gfs2_holder *gh)
 
 	if ((ip->i_di.di_flags & GFS2_DIF_TRUNC_IN_PROG) &&
 	    (gl->gl_state == LM_ST_EXCLUSIVE) &&
-	    (gh->gh_flags & GL_LOCAL_EXCL))
+	    (gh->gh_state == LM_ST_EXCLUSIVE))
 		error = gfs2_truncatei_resume(ip);
 
 	return error;
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index fbf5506..4855e8c 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -216,8 +216,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 	}
 
 	error = gfs2_glock_nq_num(sdp, inum->no_addr, &gfs2_inode_glops,
-				  LM_ST_SHARED, LM_FLAG_ANY | GL_LOCAL_EXCL,
-				  &i_gh);
+				  LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
 	if (error)
 		return ERR_PTR(error);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ce5353a..70f424f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -354,8 +354,7 @@ int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 	mutex_lock(&sdp->sd_jindex_mutex);
 
 	for (;;) {
-		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED,
-					   GL_LOCAL_EXCL, ji_gh);
+		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, ji_gh);
 		if (error)
 			break;
 
@@ -524,8 +523,7 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	struct gfs2_log_header_host head;
 	int error;
 
-	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED,
-				   GL_LOCAL_EXCL, &t_gh);
+	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &t_gh);
 	if (error)
 		return error;
 
@@ -578,9 +576,8 @@ int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	gfs2_quota_sync(sdp);
 	gfs2_statfs_sync(sdp);
 
-	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED,
-				GL_LOCAL_EXCL | GL_NOCACHE,
-				&t_gh);
+	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, GL_NOCACHE,
+				   &t_gh);
 	if (error && !test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
 		return error;
 
-- 
1.4.4.2



