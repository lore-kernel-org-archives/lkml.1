Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYDKO7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYDKO7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYDKO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:59:06 -0400
Received: from ozlabs.org ([203.10.76.45]:41418 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461AbYDKO7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:59:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] anon_inodes.c cleanups.
Date: Fri, 11 Apr 2008 08:35:07 +1000
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804110835.07989.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd pointed me at anon_inode_getfd(), and the code annoyed me enough
to send this patch.

Mainly because the init routine carefully checks for errors, then panics
(because we shouldn't run out of memory at boot).  Unfortunately, it's
actually worse than simply oopsing, where we'd know what had failed.

Davide, please consider parts of this patch, at least.

Cheers,
Rusty.
----
1) anon_inode_inode can be read_mostly, same as anon_inode_mnt.
2) The IS_ERR(anon_inode_inode) check is unneeded, since we panic on
   boot if that were true.
3) anon_inode_mkinode has one caller, so it's a little confusing.
4) Don't clean up before panic.
5) Panic gives less information than an oops would, plus is untested.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 51bdbdc4f199 fs/anon_inodes.c
--- a/fs/anon_inodes.c	Thu Apr 10 15:55:52 2008 +1000
+++ b/fs/anon_inodes.c	Fri Apr 11 08:12:51 2008 +1000
@@ -22,7 +22,7 @@
 #include <asm/uaccess.h>
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
-static struct inode *anon_inode_inode;
+static struct inode *anon_inode_inode __read_mostly;
 static const struct file_operations anon_inode_fops;
 
 static int anon_inodefs_get_sb(struct file_system_type *fs_type, int flags,
@@ -78,9 +78,6 @@ int anon_inode_getfd(int *pfd, struct in
 	struct dentry *dentry;
 	struct file *file;
 	int error, fd;
-
-	if (IS_ERR(anon_inode_inode))
-		return -ENODEV;
 
 	error = get_unused_fd();
 	if (error < 0)
@@ -138,19 +135,18 @@ err_put_unused_fd:
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
-/*
- * A single inode exists for all anon_inode files. Contrary to pipes,
- * anon_inode inodes have no associated per-instance data, so we need
- * only allocate one of them.
- */
-static struct inode *anon_inode_mkinode(void)
+static int __init anon_inode_init(void)
 {
-	struct inode *inode = new_inode(anon_inode_mnt->mnt_sb);
+	register_filesystem(&anon_inode_fs_type);
+	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
+	anon_inode_inode = new_inode(anon_inode_mnt->mnt_sb);
 
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
-	inode->i_fop = &anon_inode_fops;
+	/*
+	 * A single inode exists for all anon_inode files. Contrary to pipes,
+	 * anon_inode inodes have no associated per-instance data, so we need
+	 * only allocate one of them.
+	 */
+	anon_inode_inode->i_fop = &anon_inode_fops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
@@ -158,41 +154,15 @@ static struct inode *anon_inode_mkinode(
 	 * list because mark_inode_dirty() will think
 	 * that it already _is_ on the dirty list.
 	 */
-	inode->i_state = I_DIRTY;
-	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	return inode;
-}
-
-static int __init anon_inode_init(void)
-{
-	int error;
-
-	error = register_filesystem(&anon_inode_fs_type);
-	if (error)
-		goto err_exit;
-	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
-	if (IS_ERR(anon_inode_mnt)) {
-		error = PTR_ERR(anon_inode_mnt);
-		goto err_unregister_filesystem;
-	}
-	anon_inode_inode = anon_inode_mkinode();
-	if (IS_ERR(anon_inode_inode)) {
-		error = PTR_ERR(anon_inode_inode);
-		goto err_mntput;
-	}
+	anon_inode_inode->i_state = I_DIRTY;
+	anon_inode_inode->i_mode = S_IRUSR | S_IWUSR;
+	anon_inode_inode->i_uid = current->fsuid;
+	anon_inode_inode->i_gid = current->fsgid;
+	anon_inode_inode->i_atime =
+		anon_inode_inode->i_mtime =
+		anon_inode_inode->i_ctime = CURRENT_TIME;
 
 	return 0;
-
-err_mntput:
-	mntput(anon_inode_mnt);
-err_unregister_filesystem:
-	unregister_filesystem(&anon_inode_fs_type);
-err_exit:
-	panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
 }
 
 fs_initcall(anon_inode_init);
-
