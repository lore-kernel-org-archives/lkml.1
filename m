Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYB0TQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYB0TQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYB0TQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:16:20 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:16536 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbYB0TQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:16:19 -0500
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, akpm@linux-foundation.org
Subject: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 11:16:02 -0800
In-Reply-To: <20080225191043.GA32342@lst.de> (Christoph Hellwig's message of "Mon, 25 Feb 2008 20:10:43 +0100")
Message-ID: <adak5kqyzv1.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 19:16:05.0089 (UTC) FILETIME=[32D31D10:01C87975]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The anonymous inodes interface anon_inode_getfd() calls fd_install()
for the newly created fd, which does not work for some use cases where
the caller must do futher initialization before exposing the file to
userspace.  This is also probably not the safest interface, since the
caller must be sure that it is OK if userspace closes the fd before
anon_inode_getfd() even returns.

Therefore, change the anonymous inodes interface so that the caller is
responsible for calling fd_install(), and change the name of the
function from anon_inode_getfd() to anon_inode_allocfd() so that any
code using the old interface breaks at compilation rather than failing
in a strange way.  Fix up all the in-kernel users to use the new
interface.

This change will allow drivers/infiniband/uverbs_main.c to use
anonymous inodes and drop a chunk of virtual filesystem code
(including the last modular caller of get_empty_filp()).

This also allows us to fix a (probably never triggered) race in the
kvm code.  In create_vcpu_fd(), if userspace guessed the the fd that
was about to be returned and closed it immediately then
kvm_vcpu_release() could run and do:

	fput(vcpu->kvm->filp);

before the increment of the refcount in create_vcpu_fd():

	atomic_inc(&vcpu->kvm->filp->f_count);

which seems to leave some room for problems.  (This race at least
shows how the existing anonymous inode interface is tricky to use)

Tested with kvm and with an app that uses the epoll interface.  The
signalfd and timerfd changes are untested but are trivial enough (just
adding an fd_install() call) that they are almost certainly OK.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 fs/anon_inodes.c            |   20 +++++++++++---------
 fs/eventfd.c                |   12 +++++-------
 fs/eventpoll.c              |    6 ++++--
 fs/signalfd.c               |   10 ++++------
 fs/timerfd.c                |    5 +++--
 include/linux/anon_inodes.h |    6 +++---
 virt/kvm/kvm_main.c         |    9 ++++++---
 7 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 2332188..733054d 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -53,9 +53,9 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
 };
 
 /**
- * anon_inode_getfd - creates a new file instance by hooking it up to an
- *                    anonymous inode, and a dentry that describe the "class"
- *                    of the file
+ * anon_inode_allocfd - creates a new file instance by hooking it up to an
+ *                      anonymous inode, and a dentry that describe the "class"
+ *                      of the file
  *
  * @pfd:     [out]   pointer to the file descriptor
  * @dpinode: [out]   pointer to the inode
@@ -69,10 +69,14 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
  * All the files created with anon_inode_getfd() will share a single inode,
  * hence saving memory and avoiding code duplication for the file/inode/dentry
  * setup.
+ *
+ * Unlike the earlier anon_inode_allocfd() interface, this function does not
+ * call fd_install(), since the caller may have further initialization to do
+ * before it is safe to expose the file to userspace.
  */
-int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
-		     const char *name, const struct file_operations *fops,
-		     void *priv)
+int anon_inode_allocfd(int *pfd, struct inode **pinode, struct file **pfile,
+		       const char *name, const struct file_operations *fops,
+		       void *priv)
 {
 	struct qstr this;
 	struct dentry *dentry;
@@ -125,8 +129,6 @@ int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 	file->f_version = 0;
 	file->private_data = priv;
 
-	fd_install(fd, file);
-
 	*pfd = fd;
 	*pinode = anon_inode_inode;
 	*pfile = file;
@@ -138,7 +140,7 @@ err_put_filp:
 	put_filp(file);
 	return error;
 }
-EXPORT_SYMBOL_GPL(anon_inode_getfd);
+EXPORT_SYMBOL_GPL(anon_inode_allocfd);
 
 /*
  * A single inode exists for all anon_inode files. Contrary to pipes,
diff --git a/fs/eventfd.c b/fs/eventfd.c
index a9f130c..76e9cd2 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -212,14 +212,12 @@ asmlinkage long sys_eventfd(unsigned int count)
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 
-	/*
-	 * When we call this, the initialization must be complete, since
-	 * anon_inode_getfd() will install the fd.
-	 */
-	error = anon_inode_getfd(&fd, &inode, &file, "[eventfd]",
-				 &eventfd_fops, ctx);
-	if (!error)
+	error = anon_inode_allocfd(&fd, &inode, &file, "[eventfd]",
+				   &eventfd_fops, ctx);
+	if (!error) {
+		fd_install(fd, file);
 		return fd;
+	}
 
 	kfree(ctx);
 	return error;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a415f42..9edf018 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1089,11 +1089,13 @@ asmlinkage long sys_epoll_create(int size)
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure, and inode and a free file descriptor.
 	 */
-	error = anon_inode_getfd(&fd, &inode, &file, "[eventpoll]",
-				 &eventpoll_fops, ep);
+	error = anon_inode_allocfd(&fd, &inode, &file, "[eventpoll]",
+				   &eventpoll_fops, ep);
 	if (error)
 		goto error_free;
 
+	fd_install(fd, file);
+
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
 		     current, size, fd));
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index cb2b63a..16f71da 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -221,14 +221,12 @@ asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemas
 
 		ctx->sigmask = sigmask;
 
-		/*
-		 * When we call this, the initialization must be complete, since
-		 * anon_inode_getfd() will install the fd.
-		 */
-		error = anon_inode_getfd(&ufd, &inode, &file, "[signalfd]",
-					 &signalfd_fops, ctx);
+		error = anon_inode_allocfd(&ufd, &inode, &file, "[signalfd]",
+					   &signalfd_fops, ctx);
 		if (error)
 			goto err_fdalloc;
+
+		fd_install(ufd, file);
 	} else {
 		file = fget(ufd);
 		if (!file)
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 10c80b5..6ce63e1 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -199,13 +199,14 @@ asmlinkage long sys_timerfd_create(int clockid, int flags)
 	ctx->clockid = clockid;
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
-	error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
-				 &timerfd_fops, ctx);
+	error = anon_inode_allocfd(&ufd, &inode, &file, "[timerfd]",
+				   &timerfd_fops, ctx);
 	if (error) {
 		kfree(ctx);
 		return error;
 	}
 
+	fd_install(ufd, file);
 	return ufd;
 }
 
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index b2e1ba3..35f7ecb 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -8,9 +8,9 @@
 #ifndef _LINUX_ANON_INODES_H
 #define _LINUX_ANON_INODES_H
 
-int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
-		     const char *name, const struct file_operations *fops,
-		     void *priv);
+int anon_inode_allocfd(int *pfd, struct inode **pinode, struct file **pfile,
+		       const char *name, const struct file_operations *fops,
+		       void *priv);
 
 #endif /* _LINUX_ANON_INODES_H */
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 32fbf80..a0bf208 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -720,11 +720,12 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	struct inode *inode;
 	struct file *file;
 
-	r = anon_inode_getfd(&fd, &inode, &file,
-			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
+	r = anon_inode_allocfd(&fd, &inode, &file,
+			       "kvm-vcpu", &kvm_vcpu_fops, vcpu);
 	if (r)
 		return r;
 	atomic_inc(&vcpu->kvm->filp->f_count);
+	fd_install(fd, file);
 	return fd;
 }
 
@@ -1021,7 +1022,7 @@ static int kvm_dev_ioctl_create_vm(void)
 	kvm = kvm_create_vm();
 	if (IS_ERR(kvm))
 		return PTR_ERR(kvm);
-	r = anon_inode_getfd(&fd, &inode, &file, "kvm-vm", &kvm_vm_fops, kvm);
+	r = anon_inode_allocfd(&fd, &inode, &file, "kvm-vm", &kvm_vm_fops, kvm);
 	if (r) {
 		kvm_destroy_vm(kvm);
 		return r;
@@ -1029,6 +1030,8 @@ static int kvm_dev_ioctl_create_vm(void)
 
 	kvm->filp = file;
 
+	fd_install(fd, file);
+
 	return fd;
 }
 
-- 
1.5.4.2

