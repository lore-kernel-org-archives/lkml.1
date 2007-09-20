Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXITT4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXITT4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXITTxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41910 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXITTxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:08 -0400
Subject: [PATCH 08/25] elevate writer count for chown and friends
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:52:58 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195258.EAC06921@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


chown/chmod,etc... don't call permission in the same way
that the normal "open for write" calls do.  They still
write to the filesystem, so bump the write count during
these operations.

This conflicts with the current (~2.6.23-rc7) audit 
git tree in -mm.  wiggle'ing the patch merges it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---

 lxc-dave/fs/open.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/open.c~elevate-writer-count-for-chown-and-friends fs/open.c
--- lxc/fs/open.c~elevate-writer-count-for-chown-and-friends	2007-09-20 12:16:13.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-20 12:16:13.000000000 -0700
@@ -571,12 +571,12 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, inode);
 
-	err = -EROFS;
-	if (IS_RDONLY(inode))
+	err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		goto out_putf;
 	err = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_putf;
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -585,6 +585,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(file->f_vfsmnt);
 out_putf:
 	fput(file);
 out:
@@ -604,13 +606,13 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(nd.mnt);
+	if (error)
 		goto dput_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto out_drop_write;
 
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
@@ -620,6 +622,8 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = notify_change(nd.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
@@ -642,9 +646,6 @@ static int chown_common(struct dentry * 
 		printk(KERN_ERR "chown_common: NULL inode\n");
 		goto out;
 	}
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto out;
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
@@ -674,7 +675,12 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.dentry, user, group);
+	mnt_drop_write(nd.mnt);
+out_release:
 	path_release(&nd);
 out:
 	return error;
@@ -694,7 +700,12 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.dentry, user, group);
+	mnt_drop_write(nd.mnt);
+out_release:
 	path_release(&nd);
 out:
 	return error;
@@ -708,7 +719,12 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.dentry, user, group);
+	mnt_drop_write(nd.mnt);
+out_release:
 	path_release(&nd);
 out:
 	return error;
@@ -725,9 +741,14 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
+	error = mnt_want_write(file->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry->d_inode);
 	error = chown_common(dentry, user, group);
+	mnt_drop_write(file->f_vfsmnt);
+out_fput:
 	fput(file);
 out:
 	return error;
_
