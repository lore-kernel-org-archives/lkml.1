Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbZJOGFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbZJOGFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934352AbZJOGE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:04:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:35372 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933969AbZJOGE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:57 -0400
Message-Id: <20091015050048.165912589@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:28 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 2/6] fs: no games with DCACHE_UNHASHED
References: <20091015044026.319860788@suse.de>
Content-Disposition: inline; filename=unhashed-d_delete.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this is in -mm)

Filesystems outside the regular namespace do not have to clear DCACHE_UNHASHED
in order to have a working /proc/$pid/fd/XXX. Nothing in proc prevents the
fd link from being used if its dentry is not in the hash.

Also, it does not get put into the dcache hash if DCACHE_UNHASHED is clear;
that depends on the filesystem calling d_add or d_rehash.

So delete the misleading comments and needless code.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/anon_inodes.c |   16 ----------------
 fs/pipe.c        |   18 ------------------
 net/socket.c     |   19 -------------------
 3 files changed, 53 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c
+++ linux-2.6/fs/pipe.c
@@ -887,17 +887,6 @@ void free_pipe_info(struct inode *inode)
 }
 
 static struct vfsmount *pipe_mnt __read_mostly;
-static int pipefs_delete_dentry(struct dentry *dentry)
-{
-	/*
-	 * At creation time, we pretended this dentry was hashed
-	 * (by clearing DCACHE_UNHASHED bit in d_flags)
-	 * At delete time, we restore the truth : not hashed.
-	 * (so that dput() can proceed correctly)
-	 */
-	dentry->d_flags |= DCACHE_UNHASHED;
-	return 0;
-}
 
 /*
  * pipefs_dname() is called from d_path().
@@ -909,7 +898,6 @@ static char *pipefs_dname(struct dentry
 }
 
 static const struct dentry_operations pipefs_dentry_operations = {
-	.d_delete	= pipefs_delete_dentry,
 	.d_dname	= pipefs_dname,
 };
 
@@ -969,12 +957,6 @@ struct file *create_write_pipe(int flags
 		goto err_inode;
 
 	dentry->d_op = &pipefs_dentry_operations;
-	/*
-	 * We dont want to publish this dentry into global dentry hash table.
-	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
-	 * This permits a working /proc/$pid/fd/XXX on pipes
-	 */
-	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
 
 	err = -ENFILE;
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -306,18 +306,6 @@ static struct file_system_type sock_fs_t
 	.kill_sb =	kill_anon_super,
 };
 
-static int sockfs_delete_dentry(struct dentry *dentry)
-{
-	/*
-	 * At creation time, we pretended this dentry was hashed
-	 * (by clearing DCACHE_UNHASHED bit in d_flags)
-	 * At delete time, we restore the truth : not hashed.
-	 * (so that dput() can proceed correctly)
-	 */
-	dentry->d_flags |= DCACHE_UNHASHED;
-	return 0;
-}
-
 /*
  * sockfs_dname() is called from d_path().
  */
@@ -328,7 +316,6 @@ static char *sockfs_dname(struct dentry
 }
 
 static const struct dentry_operations sockfs_dentry_operations = {
-	.d_delete = sockfs_delete_dentry,
 	.d_dname  = sockfs_dname,
 };
 
@@ -377,12 +364,6 @@ static int sock_attach_fd(struct socket
 		return -ENOMEM;
 
 	dentry->d_op = &sockfs_dentry_operations;
-	/*
-	 * We dont want to push this dentry into global dentry hash table.
-	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
-	 * This permits a working /proc/$pid/fd/XXX on sockets
-	 */
-	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, SOCK_INODE(sock));
 
 	sock->file = file;
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c
+++ linux-2.6/fs/anon_inodes.c
@@ -35,24 +35,11 @@ static int anon_inodefs_get_sb(struct fi
 			     mnt);
 }
 
-static int anon_inodefs_delete_dentry(struct dentry *dentry)
-{
-	/*
-	 * We faked vfs to believe the dentry was hashed when we created it.
-	 * Now we restore the flag so that dput() will work correctly.
-	 */
-	dentry->d_flags |= DCACHE_UNHASHED;
-	return 1;
-}
-
 static struct file_system_type anon_inode_fs_type = {
 	.name		= "anon_inodefs",
 	.get_sb		= anon_inodefs_get_sb,
 	.kill_sb	= kill_anon_super,
 };
-static const struct dentry_operations anon_inodefs_dentry_operations = {
-	.d_delete	= anon_inodefs_delete_dentry,
-};
 
 /*
  * nop .set_page_dirty method so that people can use .page_mkwrite on
@@ -117,9 +104,6 @@ struct file *anon_inode_getfile(const ch
 	 */
 	atomic_inc(&anon_inode_inode->i_count);
 
-	dentry->d_op = &anon_inodefs_dentry_operations;
-	/* Do not publish this dentry inside the global dentry hash table */
-	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, anon_inode_inode);
 
 	error = -ENFILE;


