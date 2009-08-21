Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZHURsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZHURsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZHURsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:48:20 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33239 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZHURsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:48:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 21 Aug 2009 10:48:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [patch] anonfd - split interface into file creation and install
Message-ID: <alpine.DEB.2.00.0908211036220.25106@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch splits the anonfd interface into a bare file pointer 
creation one, and a file pointer creation plus install one.
There are cases, like the usage of eventfds inside other kernel 
interfaces, where the file pointer created by anonfd needs to be used 
inside the initialization of other structures.
As it is right now, as soon as anon_inode_getfd() returns, the kenrle can 
race with userspace closing the newly installed file descriptor.
This patch, while keeping the old anon_inode_getfd(), introduces a new 
anon_inode_getfile() (whose services are reused in anon_inode_getfd()) 
that allows to split the file creation phase and the fd install one.
Once all the kernel structures are initialized, the code can call the 
proper fd_install().
Gregory manifested the need for something like this inside KVM.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/anon_inodes.c            |   68 +++++++++++++++++++++++++++++++++-----------
 fs/eventfd.c                |   67 ++++++++++++++++++++++++++++++++++---------
 include/linux/anon_inodes.h |    3 +
 include/linux/eventfd.h     |    6 +++
 4 files changed, 114 insertions(+), 30 deletions(-)

Index: linux-2.6.mod/fs/anon_inodes.c
===================================================================
--- linux-2.6.mod.orig/fs/anon_inodes.c	2009-08-20 15:02:38.000000000 -0700
+++ linux-2.6.mod/fs/anon_inodes.c	2009-08-20 17:01:46.000000000 -0700
@@ -77,28 +77,24 @@ static const struct address_space_operat
  *
  * Creates a new file by hooking it on a single inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
- * All the files created with anon_inode_getfd() will share a single inode,
+ * All the files created with anon_inode_getfile() will share a single inode,
  * hence saving memory and avoiding code duplication for the file/inode/dentry
- * setup.  Returns new descriptor or -error.
+ * setup.  Returns the newly created file* or an error pointer.
  */
-int anon_inode_getfd(const char *name, const struct file_operations *fops,
-		     void *priv, int flags)
+struct file *anon_inode_getfile(const char *name,
+				const struct file_operations *fops,
+				void *priv, int flags)
 {
 	struct qstr this;
 	struct dentry *dentry;
 	struct file *file;
-	int error, fd;
+	int error;
 
 	if (IS_ERR(anon_inode_inode))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	if (fops->owner && !try_module_get(fops->owner))
-		return -ENOENT;
-
-	error = get_unused_fd_flags(flags);
-	if (error < 0)
-		goto err_module;
-	fd = error;
+		return ERR_PTR(-ENOENT);
 
 	/*
 	 * Link the inode to a directory entry by creating a unique name
@@ -110,7 +106,7 @@ int anon_inode_getfd(const char *name, c
 	this.hash = 0;
 	dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
 	if (!dentry)
-		goto err_put_unused_fd;
+		goto err_module;
 
 	/*
 	 * We know the anon_inode inode count is always greater than zero,
@@ -136,16 +132,54 @@ int anon_inode_getfd(const char *name, c
 	file->f_version = 0;
 	file->private_data = priv;
 
+	return file;
+
+err_dput:
+	dput(dentry);
+err_module:
+	module_put(fops->owner);
+	return ERR_PTR(error);
+}
+EXPORT_SYMBOL_GPL(anon_inode_getfile);
+
+/**
+ * anon_inode_getfd - creates a new file instance by hooking it up to an
+ *                    anonymous inode, and a dentry that describe the "class"
+ *                    of the file
+ *
+ * @name:    [in]    name of the "class" of the new file
+ * @fops:    [in]    file operations for the new file
+ * @priv:    [in]    private data for the new file (will be file's private_data)
+ * @flags:   [in]    flags
+ *
+ * Creates a new file by hooking it on a single inode. This is useful for files
+ * that do not need to have a full-fledged inode in order to operate correctly.
+ * All the files created with anon_inode_getfd() will share a single inode,
+ * hence saving memory and avoiding code duplication for the file/inode/dentry
+ * setup.  Returns new descriptor or an error code.
+ */
+int anon_inode_getfd(const char *name, const struct file_operations *fops,
+		     void *priv, int flags)
+{
+	int error, fd;
+	struct file *file;
+
+	error = get_unused_fd_flags(flags);
+	if (error < 0)
+		return error;
+	fd = error;
+
+	file = anon_inode_getfile(name, fops, priv, flags);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto err_put_unused_fd;
+	}
 	fd_install(fd, file);
 
 	return fd;
 
-err_dput:
-	dput(dentry);
 err_put_unused_fd:
 	put_unused_fd(fd);
-err_module:
-	module_put(fops->owner);
 	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-08-20 15:02:38.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-08-20 16:00:21.000000000 -0700
@@ -68,11 +68,16 @@ int eventfd_signal(struct eventfd_ctx *c
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+static void eventfd_free_ctx(struct eventfd_ctx *ctx)
+{
+	kfree(ctx);
+}
+
 static void eventfd_free(struct kref *kref)
 {
 	struct eventfd_ctx *ctx = container_of(kref, struct eventfd_ctx, kref);
 
-	kfree(ctx);
+	eventfd_free_ctx(ctx);
 }
 
 /**
@@ -298,9 +303,23 @@ struct eventfd_ctx *eventfd_ctx_fileget(
 }
 EXPORT_SYMBOL_GPL(eventfd_ctx_fileget);
 
-SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
+/**
+ * eventfd_file_create - Creates an eventfd file pointer.
+ * @count: Initial eventfd counter value.
+ * @flags: Flags for the eventfd file.
+ *
+ * This function creates an eventfd file pointer, w/out installing it into
+ * the fd table. This is useful when the eventfd file is used during the
+ * initialization of data structures that require extra setup after the eventfd
+ * creation. So the eventfd creation is split into the file pointer creation
+ * phase, and the file descriptor installation phase.
+ * In this way races with userspace closing the newly installed file descriptor
+ * can be avoided.
+ * Returns an eventfd file pointer, or a proper error pointer.
+ */
+struct file *eventfd_file_create(unsigned int count, int flags)
 {
-	int fd;
+	struct file *file;
 	struct eventfd_ctx *ctx;
 
 	/* Check the EFD_* constants for consistency.  */
@@ -308,26 +327,48 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
 
 	if (flags & ~EFD_FLAGS_SET)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
 
-	/*
-	 * When we call this, the initialization must be complete, since
-	 * anon_inode_getfd() will install the fd.
-	 */
-	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx,
-			      flags & EFD_SHARED_FCNTL_FLAGS);
-	if (fd < 0)
-		kfree(ctx);
+	file = anon_inode_getfile("[eventfd]", &eventfd_fops, ctx,
+				  flags & EFD_SHARED_FCNTL_FLAGS);
+	if (IS_ERR(file))
+		eventfd_free_ctx(ctx);
+
+	return file;
+}
+
+SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
+{
+	int fd, error;
+	struct file *file;
+
+	error = get_unused_fd_flags(flags & EFD_SHARED_FCNTL_FLAGS);
+	if (error < 0)
+		return error;
+	fd = error;
+
+	file = eventfd_file_create(count, flags);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto err_put_unused_fd;
+	}
+	fd_install(fd, file);
+
 	return fd;
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+
+	return error;
 }
 
 SYSCALL_DEFINE1(eventfd, unsigned int, count)
Index: linux-2.6.mod/include/linux/anon_inodes.h
===================================================================
--- linux-2.6.mod.orig/include/linux/anon_inodes.h	2009-08-20 15:02:38.000000000 -0700
+++ linux-2.6.mod/include/linux/anon_inodes.h	2009-08-20 15:05:22.000000000 -0700
@@ -8,6 +8,9 @@
 #ifndef _LINUX_ANON_INODES_H
 #define _LINUX_ANON_INODES_H
 
+struct file *anon_inode_getfile(const char *name,
+				const struct file_operations *fops,
+				void *priv, int flags);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags);
 
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-08-20 15:02:38.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-08-20 15:06:48.000000000 -0700
@@ -27,6 +27,7 @@
 
 #ifdef CONFIG_EVENTFD
 
+struct file *eventfd_file_create(unsigned int count, int flags);
 struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx);
 void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
@@ -40,6 +41,11 @@ int eventfd_signal(struct eventfd_ctx *c
  * Ugly ugly ugly error layer to support modules that uses eventfd but
  * pretend to work in !CONFIG_EVENTFD configurations. Namely, AIO.
  */
+static inline struct file *eventfd_file_create(unsigned int count, int flags)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 {
 	return ERR_PTR(-ENOSYS);
