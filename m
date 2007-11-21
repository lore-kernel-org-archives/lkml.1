Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXKUH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXKUH3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbXKUH3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:29:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbXKUH3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:29:08 -0500
Date: Wed, 21 Nov 2007 02:28:50 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711210728.lAL7SoCw015055@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv5 5/5] FD_CLOEXEC support for eventfd, signalfd, timerfd
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to set the FD_CLOEXEC flag for the file descriptors
returned by eventfd, signalfd, timerfd.

 fs/anon_inodes.c              |   15 +++++++++++----
 fs/eventfd.c                  |    5 +++--
 fs/signalfd.c                 |    6 ++++--
 fs/timerfd.c                  |    6 ++++--
 include/asm-x86/ia32_unistd.h |    3 +++
 include/linux/anon_inodes.h   |    3 +++
 include/linux/indirect.h      |    3 +++
 7 files changed, 31 insertions(+), 10 deletions(-)


--- linux/include/linux/indirect.h
+++ linux/include/linux/indirect.h
@@ -40,5 +40,8 @@ union indirect_params {
 #if INDSYSCALL(socketpair)
   case INDSYSCALL(socketpair):
 #endif
+  case INDSYSCALL(eventfd):
+  case INDSYSCALL(signalfd):
+  case INDSYSCALL(timerfd):
 
 #endif
--- linux/fs/anon_inodes.c
+++ linux/fs/anon_inodes.c
@@ -70,9 +70,9 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
  * hence saving memory and avoiding code duplication for the file/inode/dentry
  * setup.
  */
-int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
-		     const char *name, const struct file_operations *fops,
-		     void *priv)
+int anon_inode_getfd_flags(int *pfd, struct inode **pinode, struct file **pfile,
+			   const char *name, const struct file_operations *fops,
+			   void *priv, int flags)
 {
 	struct qstr this;
 	struct dentry *dentry;
@@ -85,7 +85,7 @@ int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 	if (!file)
 		return -ENFILE;
 
-	error = get_unused_fd();
+	error = get_unused_fd_flags(flags);
 	if (error < 0)
 		goto err_put_filp;
 	fd = error;
@@ -138,6 +138,13 @@ err_put_filp:
 	put_filp(file);
 	return error;
 }
+
+int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+		     const char *name, const struct file_operations *fops,
+		     void *priv)
+{
+	return anon_inode_getfd_flags(pfd, pinode, pfile, name, fops, priv, 0);
+}
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
 /*
--- linux/include/linux/anon_inodes.h
+++ linux/include/linux/anon_inodes.h
@@ -8,6 +8,9 @@
 #ifndef _LINUX_ANON_INODES_H
 #define _LINUX_ANON_INODES_H
 
+int anon_inode_getfd_flags(int *pfd, struct inode **pinode, struct file **pfile,
+			   const char *name, const struct file_operations *fops,
+			   void *priv, int flags);
 int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 		     const char *name, const struct file_operations *fops,
 		     void *priv);
--- linux/fs/eventfd.c
+++ linux/fs/eventfd.c
@@ -215,8 +215,9 @@ asmlinkage long sys_eventfd(unsigned int count)
 	 * When we call this, the initialization must be complete, since
 	 * anon_inode_getfd() will install the fd.
 	 */
-	error = anon_inode_getfd(&fd, &inode, &file, "[eventfd]",
-				 &eventfd_fops, ctx);
+	error = anon_inode_getfd_flags(&fd, &inode, &file, "[eventfd]",
+				       &eventfd_fops, ctx,
+				       INDIRECT_PARAM(file_flags, flags));
 	if (!error)
 		return fd;
 
--- linux/fs/signalfd.c
+++ linux/fs/signalfd.c
@@ -224,8 +224,10 @@ asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemas
 		 * When we call this, the initialization must be complete, since
 		 * anon_inode_getfd() will install the fd.
 		 */
-		error = anon_inode_getfd(&ufd, &inode, &file, "[signalfd]",
-					 &signalfd_fops, ctx);
+		error = anon_inode_getfd_flags(&ufd, &inode, &file,
+					       "[signalfd]", &signalfd_fops,
+					       ctx, INDIRECT_PARAM(file_flags,
+								   flags));
 		if (error)
 			goto err_fdalloc;
 	} else {
--- linux/fs/timerfd.c
+++ linux/fs/timerfd.c
@@ -182,8 +182,10 @@ asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 		 * When we call this, the initialization must be complete, since
 		 * anon_inode_getfd() will install the fd.
 		 */
-		error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
-					 &timerfd_fops, ctx);
+		error = anon_inode_getfd_flags(&ufd, &inode, &file, "[timerfd]",
+					       &timerfd_fops, ctx,
+					       INDIRECT_PARAM(file_flags,
+							      flags));
 		if (error)
 			goto err_tmrcancel;
 	} else {
--- linux/include/asm-x86/ia32_unistd.h
+++ linux/include/asm-x86/ia32_unistd.h
@@ -15,5 +15,8 @@
 #define __NR_ia32_socketcall	102
 #define __NR_ia32_sigreturn	119
 #define __NR_ia32_rt_sigreturn	173
+#define __NR_ia32_signalfd	321
+#define __NR_ia32_timerfd	322
+#define __NR_ia32_eventfd	323
 
 #endif /* _ASM_X86_64_IA32_UNISTD_H_ */
