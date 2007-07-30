Return-Path: <linux-kernel-owner+w=401wt.eu-S966257AbXG3QY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbXG3QY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938814AbXG3QPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:15:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:40571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765283AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161325.179356484@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:45 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 22/26] union-mount: white-out changes for copy-on-open
Content-Disposition: inline; filename=um/union-mount-coo-whiteout.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When files on an upper layer of the union stack are removed we need to
white-out the removed filename.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2253,6 +2253,13 @@ do_last:
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode || S_ISWHT(path.dentry->d_inode->i_mode)) {
+		if (path.dentry->d_parent != dir) {
+			dput_path(&path, nd);
+			path.dentry = __lookup_hash_kern(&nd->last, dir, nd);
+			path.mnt = nd->mnt;
+			goto do_last;
+		}
+
 		error = open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
@@ -2373,6 +2380,16 @@ int lookup_create(struct nameidata *nd, 
 {
 	int err = -EEXIST;
 
+	if (is_unionized(nd->dentry, nd->mnt)) {
+		err = union_relookup_topmost(nd, nd->flags & ~LOOKUP_PARENT);
+		if (err) {
+			/* FIXME: This really sucks */
+			mutex_lock_nested(&nd->dentry->d_inode->i_mutex,
+					  I_MUTEX_PARENT);
+			goto fail;
+		}
+	}
+
 	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
 	 * Yucky last component or no last component at all?
@@ -2391,6 +2408,16 @@ int lookup_create(struct nameidata *nd, 
 	if (err)
 		goto fail;
 
+	/* Special case - we found a whiteout */
+	if (path->dentry->d_inode && S_ISWHT(path->dentry->d_inode->i_mode)) {
+		if (path->dentry->d_parent != nd->dentry) {
+			dput_path(path, nd);
+			path->dentry = __lookup_hash_kern(&nd->last, nd->dentry,
+							  nd);
+			path->mnt = nd->mnt;
+		}
+	}
+
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
 	 * From the vfs_mknod() POV we just have a negative dentry -
@@ -2682,6 +2709,15 @@ static int do_whiteout(struct nameidata 
 	if (isdir && !directory_is_empty(path->dentry, path->mnt))
 		goto out;
 
+	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+	err = union_relookup_topmost(nd, nd->flags & ~LOOKUP_PARENT);
+	if (err) {
+		mutex_lock_nested(&nd->dentry->d_inode->i_mutex,
+				  I_MUTEX_PARENT);
+		goto out;
+	}
+	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+
 	/* safe the name for a later lookup */
 	err = -ENOMEM;
 	name.name = kmalloc(dentry->d_name.len, GFP_KERNEL);
@@ -3012,7 +3048,10 @@ static long do_rmdir(int dfd, const char
 	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (error)
 		goto exit2;
-	error = vfs_rmdir(nd.dentry->d_inode, path.dentry);
+	if (is_unionized(nd.dentry, nd.mnt))
+		error = do_whiteout(&nd, &path, 1);
+	else
+		error = vfs_rmdir(nd.dentry->d_inode, path.dentry);
 	dput_path(&path, &nd);
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
@@ -3091,7 +3130,10 @@ static long do_unlinkat(int dfd, const c
 		inode = path.dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = vfs_unlink(nd.dentry->d_inode, path.dentry);
+		if (is_unionized(nd.dentry, nd.mnt))
+			error = do_whiteout(&nd, &path, 0);
+		else
+			error = vfs_unlink(nd.dentry->d_inode, path.dentry);
 	exit2:
 		dput_path(&path, &nd);
 	}

-- 

