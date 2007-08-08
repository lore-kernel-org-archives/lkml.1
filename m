Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbXHHRVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbXHHRVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936479AbXHHRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:37166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934565AbXHHRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:03 -0400
Message-Id: <20070808171644.042011544@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:27 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 05/10] Use vfs_permission instead of file_permission in sys_fchdir
Content-Disposition: inline; filename=sys_fchdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a temporary vfs_lookup object, and use vfs_permission instead
of file_permission() in sys_fchdir().

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/open.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -501,9 +501,7 @@ out:
 asmlinkage long sys_fchdir(unsigned int fd)
 {
 	struct file *file;
-	struct dentry *dentry;
-	struct inode *inode;
-	struct vfsmount *mnt;
+	struct vfs_lookup lookup;
 	int error;
 
 	error = -EBADF;
@@ -511,17 +509,16 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!file)
 		goto out;
 
-	dentry = file->f_path.dentry;
-	mnt = file->f_path.mnt;
-	inode = dentry->d_inode;
+	lookup.path = file->f_path;
+	lookup.flags = 0;
 
 	error = -ENOTDIR;
-	if (!S_ISDIR(inode->i_mode))
+	if (!S_ISDIR(lookup.path.dentry->d_inode->i_mode))
 		goto out_putf;
 
-	error = file_permission(file, MAY_EXEC);
+	error = vfs_permission(&lookup, MAY_EXEC);
 	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+		set_fs_pwd(current->fs, lookup.path.mnt, lookup.path.dentry);
 out_putf:
 	fput(file);
 out:

