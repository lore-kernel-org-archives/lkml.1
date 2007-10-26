Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbXJZHP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbXJZHP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbXJZG7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:59:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:35001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762289AbXJZG7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:59:34 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:53 2007
Message-Id: <20071026064053.097110530@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:41:08 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 44/45] Switch to vfs_permission() in sys_fchdir()
Content-Disposition: inline; filename=sys_fchdir-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in sys_fchdir(): this
avoids calling permission() with a NULL nameidata here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/open.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -512,10 +512,8 @@ out:
 
 asmlinkage long sys_fchdir(unsigned int fd)
 {
+	struct nameidata nd;
 	struct file *file;
-	struct dentry *dentry;
-	struct inode *inode;
-	struct vfsmount *mnt;
 	int error;
 
 	error = -EBADF;
@@ -523,17 +521,17 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!file)
 		goto out;
 
-	dentry = file->f_path.dentry;
-	mnt = file->f_path.mnt;
-	inode = dentry->d_inode;
+	nd.dentry = file->f_path.dentry;
+	nd.mnt = file->f_path.mnt;
+	nd.flags = 0;
 
 	error = -ENOTDIR;
-	if (!S_ISDIR(inode->i_mode))
+	if (!S_ISDIR(nd.dentry->d_inode->i_mode))
 		goto out_putf;
 
-	error = file_permission(file, MAY_EXEC);
+	error = vfs_permission(&nd, MAY_EXEC);
 	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+		set_fs_pwd(current->fs, nd.mnt, nd.dentry);
 out_putf:
 	fput(file);
 out:

-- 

