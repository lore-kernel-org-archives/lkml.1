Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXFZX0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXFZX0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbXFZXNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:13:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:53861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760378AbXFZXNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:13:00 -0400
Message-Id: <20070626231212.623772996@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:39 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 43/44] Switch to vfs_permission() in sys_fchdir()
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
