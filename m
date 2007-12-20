Return-Path: <linux-kernel-owner+w=401wt.eu-S965144AbXLTO3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144AbXLTO3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbXLTONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:13:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137AbXLTONH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:13:07 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:47 2007
Message-Id: <20071220140947.172211344@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:48 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 38/47] Switch to vfs_permission() in sys_fchdir()
Content-Disposition: inline; filename=sys_fchdir-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from file_permission() to vfs_permission() in sys_fchdir(): this
avoids calling permission() with a NULL nameidata here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/open.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -512,8 +512,8 @@ out:
 
 asmlinkage long sys_fchdir(unsigned int fd)
 {
+	struct nameidata nd;
 	struct file *file;
-	struct inode *inode;
 	int error;
 
 	error = -EBADF;
@@ -521,15 +521,16 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!file)
 		goto out;
 
-	inode = file->f_path.dentry->d_inode;
+	nd.path = file->f_path;
+	nd.flags = 0;
 
 	error = -ENOTDIR;
-	if (!S_ISDIR(inode->i_mode))
+	if (!S_ISDIR(nd.path.dentry->d_inode->i_mode))
 		goto out_putf;
 
-	error = file_permission(file, MAY_EXEC);
+	error = vfs_permission(&nd, MAY_EXEC);
 	if (!error)
-		set_fs_pwd(current->fs, &file->f_path);
+		set_fs_pwd(current->fs, &nd.path);
 out_putf:
 	fput(file);
 out:

-- 

