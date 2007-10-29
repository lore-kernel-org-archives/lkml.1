Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbXJ2Amj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbXJ2Amj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 20:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXJ2Al3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 20:41:29 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46433 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbXJ2AlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 20:41:23 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names
Date: Sun, 28 Oct 2007 20:40:56 -0400
Message-Id: <11936184592699-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11936184581182-git-send-email-ezk@cs.sunysb.edu>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename old vfs_ioctl to do_ioctl, because the comment above it clearly
indicates that it is an internal function not to be exported to modules;
therefore it should have a more traditional do_XXX name.  The new do_ioctl
is exported in fs.h but not to modules.

Rename the old do_ioctl to vfs_ioctl because the names vfs_XXX should
preferably be reserved to callable VFS functions which modules may call, as
many other vfs_XXX functions already do.  Export the new vfs_ioctl to GPL
modules so others can use it (including Unionfs and eCryptfs).  Add DocBook
for new vfs_ioctl.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/compat_ioctl.c  |    2 +-
 fs/ioctl.c         |   30 ++++++++++++++++++++++--------
 include/linux/fs.h |    3 ++-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a4284cc..a1604ce 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2972,7 +2972,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	}
 
  do_ioctl:
-	error = vfs_ioctl(filp, fd, cmd, arg);
+	error = do_ioctl(filp, fd, cmd, arg);
  out_fput:
 	fput_light(filp, fput_needed);
  out:
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 652cacf..34e3f58 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -16,8 +16,21 @@
 
 #include <asm/ioctls.h>
 
-static long do_ioctl(struct file *filp, unsigned int cmd,
-		unsigned long arg)
+/**
+ * vfs_ioctl - call filesystem specific ioctl methods
+ *
+ * @filp: [in]     open file to invoke ioctl method on
+ * @cmd:  [in]     ioctl command to execute
+ * @arg:  [in/out] command-specific argument for ioctl
+ *
+ * Invokes filesystem specific ->unlock_ioctl, if one exists; otherwise
+ * invokes * filesystem specific ->ioctl method.  If neither method exists,
+ * returns -ENOTTY.
+ *
+ * Returns 0 on success, -errno on error.
+ */
+long vfs_ioctl(struct file *filp, unsigned int cmd,
+	       unsigned long arg)
 {
 	int error = -ENOTTY;
 
@@ -39,6 +52,7 @@ static long do_ioctl(struct file *filp, unsigned int cmd,
  out:
 	return error;
 }
+EXPORT_SYMBOL_GPL(vfs_ioctl);
 
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
@@ -72,18 +86,18 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 		return put_user(i_size_read(inode) - filp->f_pos, p);
 	}
 
-	return do_ioctl(filp, cmd, arg);
+	return vfs_ioctl(filp, cmd, arg);
 }
 
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
- * vfs_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
+ * do_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
  * It's just a simple helper for sys_ioctl and compat_sys_ioctl.
  */
-int vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
-	      unsigned long arg)
+int do_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
+	     unsigned long arg)
 {
 	unsigned int flag;
 	int on, error = 0;
@@ -152,7 +166,7 @@ int vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
 		else
-			error = do_ioctl(filp, cmd, arg);
+			error = vfs_ioctl(filp, cmd, arg);
 		break;
 	}
 	return error;
@@ -172,7 +186,7 @@ asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
 	if (error)
 		goto out_fput;
 
-	error = vfs_ioctl(filp, fd, cmd, arg);
+	error = do_ioctl(filp, fd, cmd, arg);
  out_fput:
 	fput_light(filp, fput_needed);
  out:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..c0c5d36 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1924,7 +1924,8 @@ extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 
-extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
+extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+extern int do_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
 
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
-- 
1.5.2.2

