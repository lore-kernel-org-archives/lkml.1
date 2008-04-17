Return-Path: <linux-kernel-owner+w=401wt.eu-S935274AbYDQJtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935274AbYDQJtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933725AbYDQJ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765943AbYDQJ0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:23 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 34/48] [GFS2] Fix a page lock / glock deadlock
Date: Thu, 17 Apr 2008 09:39:10 +0100
Message-Id: <12084216391215-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216372363-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We've previously been using a "try lock" in readpage on the basis that
it would prevent deadlocks due to the inverted lock ordering (our normal
lock ordering is glock first and then page lock). Unfortunately tests
have shown that this isn't enough. If the glock has a demote request
queued such that run_queue() in the glock code tries to do a demote when
its called under readpage then it will try and write out all the dirty
pages which requires locking them. This then deadlocks with the page
locked by readpage.

The solution is to always require two calls into readpage. The first
unlocks the page, gets the glock and returns AOP_TRUNCATED_PAGE, the
second does the actual readpage and unlocks the glock & page as
required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index ace5770..cdad3e6 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -32,24 +32,23 @@
 #define GLR_TRYFAILED		13
 #define GLR_CANCELED		14
 
-static inline int gfs2_glock_is_locked_by_me(struct gfs2_glock *gl)
+static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *gl)
 {
 	struct gfs2_holder *gh;
-	int locked = 0;
 	struct pid *pid;
 
 	/* Look in glock's list of holders for one with current task as owner */
 	spin_lock(&gl->gl_spin);
 	pid = task_pid(current);
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
-		if (gh->gh_owner_pid == pid) {
-			locked = 1;
-			break;
-		}
+		if (gh->gh_owner_pid == pid)
+			goto out;
 	}
+	gh = NULL;
+out:
 	spin_unlock(&gl->gl_spin);
 
-	return locked;
+	return gh;
 }
 
 static inline int gfs2_glock_is_held_excl(struct gfs2_glock *gl)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5f50dd5..810ff02 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -493,7 +493,7 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 		return dir;
 	}
 
-	if (gfs2_glock_is_locked_by_me(dip->i_gl) == 0) {
+	if (gfs2_glock_is_locked_by_me(dip->i_gl) == NULL) {
 		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
 		if (error)
 			return ERR_PTR(error);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 7523999..fbb4a6a 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -508,23 +508,26 @@ static int __gfs2_readpage(void *file, struct page *page)
 static int gfs2_readpage(struct file *file, struct page *page)
 {
 	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
-	struct gfs2_holder gh;
+	struct gfs2_holder *gh;
 	int error;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME|LM_FLAG_TRY_1CB, &gh);
-	error = gfs2_glock_nq_atime(&gh);
-	if (unlikely(error)) {
+	gh = gfs2_glock_is_locked_by_me(ip->i_gl);
+	if (!gh) {
+		gh = kmalloc(sizeof(struct gfs2_holder), GFP_NOFS);
+		if (!gh)
+			return -ENOBUFS;
+		gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, gh);
 		unlock_page(page);
-		goto out;
+		error = gfs2_glock_nq_atime(gh);
+		if (likely(error != 0))
+			goto out;
+		return AOP_TRUNCATED_PAGE;
 	}
 	error = __gfs2_readpage(file, page);
-	gfs2_glock_dq(&gh);
+	gfs2_glock_dq(gh);
 out:
-	gfs2_holder_uninit(&gh);
-	if (error == GLR_TRYFAILED) {
-		yield();
-		return AOP_TRUNCATED_PAGE;
-	}
+	gfs2_holder_uninit(gh);
+	kfree(gh);
 	return error;
 }
 
@@ -826,7 +829,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	unsigned int to = from + len;
 	int ret;
 
-	BUG_ON(gfs2_glock_is_locked_by_me(ip->i_gl) == 0);
+	BUG_ON(gfs2_glock_is_locked_by_me(ip->i_gl) == NULL);
 
 	ret = gfs2_meta_inode_buffer(ip, &dibh);
 	if (unlikely(ret)) {
diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
index 793e334..4a5e676 100644
--- a/fs/gfs2/ops_dentry.c
+++ b/fs/gfs2/ops_dentry.c
@@ -43,7 +43,7 @@ static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
 	struct gfs2_holder d_gh;
 	struct gfs2_inode *ip = NULL;
 	int error;
-	int had_lock=0;
+	int had_lock = 0;
 
 	if (inode) {
 		if (is_bad_inode(inode))
@@ -54,7 +54,7 @@ static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
 	if (sdp->sd_args.ar_localcaching)
 		goto valid;
 
-	had_lock = gfs2_glock_is_locked_by_me(dip->i_gl);
+	had_lock = (gfs2_glock_is_locked_by_me(dip->i_gl) != NULL);
 	if (!had_lock) {
 		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
 		if (error)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 301c945..af7097a 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -898,7 +898,7 @@ static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 	int error;
 	int unlock = 0;
 
-	if (gfs2_glock_is_locked_by_me(ip->i_gl) == 0) {
+	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
 		if (error)
 			return error;
@@ -1065,7 +1065,7 @@ static int gfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	int error;
 	int unlock = 0;
 
-	if (gfs2_glock_is_locked_by_me(ip->i_gl) == 0) {
+	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
 		if (error)
 			return error;
-- 
1.5.1.2

