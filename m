Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZECUQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZECUQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZECUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:16:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33201 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZECUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:16:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 May 2009 13:11:39 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <20090503190136.GY8633@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0905031252540.7899@makko.or.mcafeemobile.com>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090503064432.GS8633@ZenIV.linux.org.uk> <alpine.DEB.1.10.0905031103290.7899@makko.or.mcafeemobile.com>
 <20090503190136.GY8633@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Al Viro wrote:

> IOW, the sane solution would be to export something that returns your
> struct file *.  And stop playing with fd completely.

This builds but it's not tested at all.

- Make all the work of the old anon_inode_getfd(), done by a new 
  anon_inode_getfile(), with anon_inode_getfd() using its services

- Make all the work done by sys_eventfd(), done by a new 
  eventfd_file_create() (which in turn uses anon_inode_getfile()), with 
  sys_eventfd() using its services

IRQfd can use eventfd_file_create(), fget(), get_unused_fd_flags() and 
fd_install() just before returning.
Is that what you had in mind?



- Davide


---
 fs/anon_inodes.c            |   68 +++++++++++++++++++++++++++++++++-----------
 fs/eventfd.c                |   44 +++++++++++++++++++++-------
 include/linux/anon_inodes.h |    3 +
 include/linux/eventfd.h     |    6 +++
 4 files changed, 92 insertions(+), 29 deletions(-)

Index: linux-2.6.mod/fs/anon_inodes.c
===================================================================
--- linux-2.6.mod.orig/fs/anon_inodes.c	2009-05-03 12:21:09.000000000 -0700
+++ linux-2.6.mod/fs/anon_inodes.c	2009-05-03 12:54:02.000000000 -0700
@@ -64,28 +64,24 @@ static const struct dentry_operations an
  *
  * Creates a new file by hooking it on a single inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
- * All the files created with anon_inode_getfd() will share a single inode,
+ * All the files created with anon_inode_getfile() will share a single inode,
  * hence saving memory and avoiding code duplication for the file/inode/dentry
- * setup.  Returns new descriptor or -error.
+ * setup.  Returns the newly created file* or error.
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
@@ -97,7 +93,7 @@ int anon_inode_getfd(const char *name, c
 	this.hash = 0;
 	dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
 	if (!dentry)
-		goto err_put_unused_fd;
+		goto err_module;
 
 	/*
 	 * We know the anon_inode inode count is always greater than zero,
@@ -123,16 +119,54 @@ int anon_inode_getfd(const char *name, c
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
+ * setup.  Returns new descriptor or -error.
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
--- linux-2.6.mod.orig/fs/eventfd.c	2009-05-03 12:21:09.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-05-03 12:54:07.000000000 -0700
@@ -198,9 +198,9 @@ struct file *eventfd_fget(int fd)
 	return file;
 }
 
-SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
+struct file *eventfd_file_create(unsigned int count, int flags)
 {
-	int fd;
+	struct file *file;
 	struct eventfd_ctx *ctx;
 
 	/* Check the EFD_* constants for consistency.  */
@@ -208,25 +208,47 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
 
 	if (flags & ~EFD_FLAGS_SET)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
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
+	file = anon_inode_getfile("[eventfd]", &eventfd_fops, ctx,
+				  flags & EFD_SHARED_FCNTL_FLAGS);
+	if (IS_ERR(file))
 		kfree(ctx);
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
--- linux-2.6.mod.orig/include/linux/anon_inodes.h	2009-05-03 12:21:09.000000000 -0700
+++ linux-2.6.mod/include/linux/anon_inodes.h	2009-05-03 12:48:08.000000000 -0700
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
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-05-03 12:21:09.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-05-03 12:43:54.000000000 -0700
@@ -29,12 +29,16 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+struct file *eventfd_file_create(unsigned int count, int flags);
 
 #else /* CONFIG_EVENTFD */
 
-#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
+static inline struct file *eventfd_fget(int fd)
+{ ERR_PTR(-ENOSYS); }
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+struct file *eventfd_file_create(unsigned int count, int flags)
+{ ERR_PTR(-ENOSYS); }
 
 #endif /* CONFIG_EVENTFD */
 
