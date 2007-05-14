Return-Path: <linux-kernel-owner+w=401wt.eu-S966507AbXENLx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966507AbXENLx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966180AbXENLen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:34:43 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27936 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759350AbXENLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:34 -0400
Message-Id: <20070514110623.402888903@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:51 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 44/45] Switch to vfs_permission() in sys_fchdir()
Content-Disposition: inline; filename=sys_fchdir-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in sys_fchdir(): this
avoids calling permission() with a NULL nameidata here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/open.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -440,10 +440,8 @@ out:
 
 asmlinkage long sys_fchdir(unsigned int fd)
 {
+	struct nameidata nd;
 	struct file *file;
-	struct dentry *dentry;
-	struct inode *inode;
-	struct vfsmount *mnt;
 	int error;
 
 	error = -EBADF;
@@ -451,17 +449,17 @@ asmlinkage long sys_fchdir(unsigned int 
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
