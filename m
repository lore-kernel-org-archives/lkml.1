Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXG3QUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXG3QUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938308AbXG3QOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:58732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933493AbXG3QOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:09 -0400
Message-Id: <20070730161323.704939058@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:29 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 06/26] VFS: Make real_lookup() return a struct path
Content-Disposition: inline; filename=um/vfs-real_lookup-returns-path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes real_lookup() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |   77 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 29 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -462,10 +462,11 @@ ok:
  * make sure that nobody added the entry to the dcache in the meantime..
  * SMP-safe
  */
-static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+static int real_lookup(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
 {
-	struct dentry * result;
-	struct inode *dir = parent->d_inode;
+	struct inode *dir = nd->dentry->d_inode;
+	int res = 0;
 
 	mutex_lock(&dir->i_mutex);
 	/*
@@ -482,19 +483,27 @@ static struct dentry * real_lookup(struc
 	 *
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
-	result = d_lookup(parent, name);
-	if (!result) {
-		struct dentry * dentry = d_alloc(parent, name);
-		result = ERR_PTR(-ENOMEM);
+	path->dentry = d_lookup(nd->dentry, name);
+	path->mnt = nd->mnt;
+	if (!path->dentry) {
+		struct dentry *dentry = d_alloc(nd->dentry, name);
 		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
-			if (result)
+			path->dentry = dir->i_op->lookup(dir, dentry, nd);
+			if (path->dentry) {
 				dput(dentry);
-			else
-				result = dentry;
+				if (IS_ERR(path->dentry)) {
+					res = PTR_ERR(path->dentry);
+					path->dentry = NULL;
+					path->mnt = NULL;
+				}
+			} else
+				path->dentry = dentry;
+		} else {
+			res = -ENOMEM;
+			path->mnt = NULL;
 		}
 		mutex_unlock(&dir->i_mutex);
-		return result;
+		return res;
 	}
 
 	/*
@@ -502,12 +511,20 @@ static struct dentry * real_lookup(struc
 	 * we waited on the semaphore. Need to revalidate.
 	 */
 	mutex_unlock(&dir->i_mutex);
-	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
-		if (!result)
-			result = ERR_PTR(-ENOENT);
+	if (path->dentry->d_op && path->dentry->d_op->d_revalidate) {
+		path->dentry = do_revalidate(path->dentry, nd);
+		if (!path->dentry) {
+			res = -ENOENT;
+			path->mnt = NULL;
+		}
+		if (IS_ERR(path->dentry)) {
+			res = PTR_ERR(path->dentry);
+			path->dentry = NULL;
+			path->mnt = NULL;
+		}
 	}
-	return result;
+
+	return res;
 }
 
 static int __emul_lookup_dentry(const char *, struct nameidata *);
@@ -748,35 +765,37 @@ static __always_inline void follow_dotdo
 static int do_lookup(struct nameidata *nd, struct qstr *name,
 		     struct path *path)
 {
-	struct vfsmount *mnt = nd->mnt;
-	struct dentry *dentry = __d_lookup(nd->dentry, name);
+	int err;
 
-	if (!dentry)
+	path->dentry = __d_lookup(nd->dentry, name);
+	path->mnt = nd->mnt;
+	if (!path->dentry)
 		goto need_lookup;
-	if (dentry->d_op && dentry->d_op->d_revalidate)
+	if (path->dentry->d_op && path->dentry->d_op->d_revalidate)
 		goto need_revalidate;
+
 done:
-	path->mnt = mnt;
-	path->dentry = dentry;
 	__follow_mount(path);
 	return 0;
 
 need_lookup:
-	dentry = real_lookup(nd->dentry, name, nd);
-	if (IS_ERR(dentry))
+	err = real_lookup(nd, name, path);
+	if (err)
 		goto fail;
 	goto done;
 
 need_revalidate:
-	dentry = do_revalidate(dentry, nd);
-	if (!dentry)
+	path->dentry = do_revalidate(path->dentry, nd);
+	if (!path->dentry)
 		goto need_lookup;
-	if (IS_ERR(dentry))
+	if (IS_ERR(path->dentry)) {
+		err = PTR_ERR(path->dentry);
 		goto fail;
+	}
 	goto done;
 
 fail:
-	return PTR_ERR(dentry);
+	return err;
 }
 
 /*

-- 

