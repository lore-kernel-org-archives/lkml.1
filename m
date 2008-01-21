Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbYAUKHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbYAUKHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbYAUKCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464AbYAUKCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:14 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/58] [GFS2] Reorder writeback for glock sync
Date: Mon, 21 Jan 2008 09:21:33 +0000
Message-Id: <12009073671755-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073662309-git-send-email-swhiteho@redhat.com>
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
Message-Id: <9e33b02006aaf5de7a99571d6c2da48141b68475.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Previously we were doing (write data, wait for data, write metadata, wait
for metadata). After this patch we so (write metadata, write data, wait for
data, wait for metadata) which should be more efficient.

Also I noticed that the drop_bh and xmote_bh functions were almost
identical. In fact the only difference was a single test, and that
test is such that in the drop_bh case, it would always evaluate to
the correct result. As such we can use the xmote_bh functions in
all the places where we were using the drop_bh function and remove
the drop_bh functions.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 159a547..e668808 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -947,8 +947,8 @@ static void gfs2_glock_drop_th(struct gfs2_glock *gl)
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	unsigned int ret;
 
-	if (glops->go_drop_th)
-		glops->go_drop_th(gl);
+	if (glops->go_xmote_th)
+		glops->go_xmote_th(gl);
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
@@ -1252,12 +1252,11 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	list_del_init(&gh->gh_list);
 
 	if (list_empty(&gl->gl_holders)) {
-		spin_unlock(&gl->gl_spin);
-
-		if (glops->go_unlock)
+		if (glops->go_unlock) {
+			spin_unlock(&gl->gl_spin);
 			glops->go_unlock(gh);
-
-		spin_lock(&gl->gl_spin);
+			spin_lock(&gl->gl_spin);
+		}
 		gl->gl_stamp = jiffies;
 	}
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index ba12423..c663b7a 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -138,44 +138,34 @@ static void meta_go_inval(struct gfs2_glock *gl, int flags)
 static void inode_go_sync(struct gfs2_glock *gl)
 {
 	struct gfs2_inode *ip = gl->gl_object;
+	struct address_space *metamapping = gl->gl_aspace->i_mapping;
+	int error;
+
+	if (gl->gl_state != LM_ST_UNLOCKED)
+		gfs2_pte_inval(gl);
+	if (gl->gl_state != LM_ST_EXCLUSIVE)
+		return;
 
 	if (ip && !S_ISREG(ip->i_inode.i_mode))
 		ip = NULL;
 
 	if (test_bit(GLF_DIRTY, &gl->gl_flags)) {
-		if (ip && !gfs2_is_jdata(ip))
-			filemap_fdatawrite(ip->i_inode.i_mapping);
 		gfs2_log_flush(gl->gl_sbd, gl);
-		if (ip && gfs2_is_jdata(ip))
-			filemap_fdatawrite(ip->i_inode.i_mapping);
-		gfs2_meta_sync(gl);
+		filemap_fdatawrite(metamapping);
 		if (ip) {
 			struct address_space *mapping = ip->i_inode.i_mapping;
-			int error = filemap_fdatawait(mapping);
+			filemap_fdatawrite(mapping);
+			error = filemap_fdatawait(mapping);
 			mapping_set_error(mapping, error);
 		}
+		error = filemap_fdatawait(metamapping);
+		mapping_set_error(metamapping, error);
 		clear_bit(GLF_DIRTY, &gl->gl_flags);
 		gfs2_ail_empty_gl(gl);
 	}
 }
 
 /**
- * inode_go_xmote_th - promote/demote a glock
- * @gl: the glock
- * @state: the requested state
- * @flags:
- *
- */
-
-static void inode_go_xmote_th(struct gfs2_glock *gl)
-{
-	if (gl->gl_state != LM_ST_UNLOCKED)
-		gfs2_pte_inval(gl);
-	if (gl->gl_state == LM_ST_EXCLUSIVE)
-		inode_go_sync(gl);
-}
-
-/**
  * inode_go_xmote_bh - After promoting/demoting a glock
  * @gl: the glock
  *
@@ -196,22 +186,6 @@ static void inode_go_xmote_bh(struct gfs2_glock *gl)
 }
 
 /**
- * inode_go_drop_th - unlock a glock
- * @gl: the glock
- *
- * Invoked from rq_demote().
- * Another node needs the lock in EXCLUSIVE mode, or lock (unused for too long)
- * is being purged from our node's glock cache; we're dropping lock.
- */
-
-static void inode_go_drop_th(struct gfs2_glock *gl)
-{
-	gfs2_pte_inval(gl);
-	if (gl->gl_state == LM_ST_EXCLUSIVE)
-		inode_go_sync(gl);
-}
-
-/**
  * inode_go_inval - prepare a inode glock to be released
  * @gl: the glock
  * @flags:
@@ -326,14 +300,14 @@ static void rgrp_go_unlock(struct gfs2_holder *gh)
 }
 
 /**
- * trans_go_xmote_th - promote/demote the transaction glock
+ * trans_go_sync - promote/demote the transaction glock
  * @gl: the glock
  * @state: the requested state
  * @flags:
  *
  */
 
-static void trans_go_xmote_th(struct gfs2_glock *gl)
+static void trans_go_sync(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 
@@ -377,24 +351,6 @@ static void trans_go_xmote_bh(struct gfs2_glock *gl)
 }
 
 /**
- * trans_go_drop_th - unlock the transaction glock
- * @gl: the glock
- *
- * We want to sync the device even with localcaching.  Remember
- * that localcaching journal replay only marks buffers dirty.
- */
-
-static void trans_go_drop_th(struct gfs2_glock *gl)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-
-	if (test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
-		gfs2_meta_syncfs(sdp);
-		gfs2_log_shutdown(sdp);
-	}
-}
-
-/**
  * quota_go_demote_ok - Check to see if it's ok to unlock a quota glock
  * @gl: the glock
  *
@@ -408,14 +364,12 @@ static int quota_go_demote_ok(struct gfs2_glock *gl)
 
 const struct gfs2_glock_operations gfs2_meta_glops = {
 	.go_xmote_th = meta_go_sync,
-	.go_drop_th = meta_go_sync,
 	.go_type = LM_TYPE_META,
 };
 
 const struct gfs2_glock_operations gfs2_inode_glops = {
-	.go_xmote_th = inode_go_xmote_th,
+	.go_xmote_th = inode_go_sync,
 	.go_xmote_bh = inode_go_xmote_bh,
-	.go_drop_th = inode_go_drop_th,
 	.go_inval = inode_go_inval,
 	.go_demote_ok = inode_go_demote_ok,
 	.go_lock = inode_go_lock,
@@ -425,7 +379,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_xmote_th = meta_go_sync,
-	.go_drop_th = meta_go_sync,
 	.go_inval = meta_go_inval,
 	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
@@ -435,9 +388,8 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
-	.go_xmote_th = trans_go_xmote_th,
+	.go_xmote_th = trans_go_sync,
 	.go_xmote_bh = trans_go_xmote_bh,
-	.go_drop_th = trans_go_drop_th,
 	.go_type = LM_TYPE_NONDISK,
 };
 
-- 
1.5.1.2

