Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbZFPUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbZFPUlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbZFPUj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:39:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbZFPUj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:39:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/17] VFS: Implement handling for pathless pioctls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:01 +0100
Message-ID: <20090616203901.4526.200.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Lei <wang840925@gmail.com>

Implement handling for pathless pioctls.  Because these take no path argument,
there's no way to know for certain which filesystem they're aimed at, so we
have to switch on command number instead.  This patch allows interested parties
to register handlers.  Each registered handler function is tried in turn until
one doesn't return -EOPNOTSUPP.

This is required because OpenAFS implemented a number of AFS calls that don't
get given a path as they're aimed at AFS in general, and not at a particular
file, volume or cell in the AFS world.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat_pioctl.c     |   14 ++++--
 fs/pioctl.c            |  114 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/pioctl.h |   12 +++++
 3 files changed, 130 insertions(+), 10 deletions(-)


diff --git a/fs/compat_pioctl.c b/fs/compat_pioctl.c
index 9f2de77..36b0553 100644
--- a/fs/compat_pioctl.c
+++ b/fs/compat_pioctl.c
@@ -75,11 +75,15 @@ long compat_sys_pioctl(const char __user *filename, int cmd,
 		kargs.out = NULL;
 	}
 
-	error = user_path(filename, &path);
-	if (!error) {
-		if (path.dentry->d_inode)
-			error = vfs_pioctl(path.dentry, cmd, &kargs);
-		path_put(&path);
+	if (!filename) {
+		error = vfs_pioctl(NULL, cmd, &kargs);
+	} else {
+		error = user_path(filename, &path);
+		if (!error) {
+			if (path.dentry->d_inode)
+				error = vfs_pioctl(path.dentry, cmd, &kargs);
+			path_put(&path);
+		}
 	}
 	kfree(kargs.in);
 
diff --git a/fs/pioctl.c b/fs/pioctl.c
index c17f220..1fe4bf8 100644
--- a/fs/pioctl.c
+++ b/fs/pioctl.c
@@ -1,5 +1,6 @@
 /* Path-based I/O control
  *
+ * Copyright (C) 2009 Wang Lei <wang840925@gmail.com>
  * Copyright (C) 2009 David Howells <dhowells@redhat.com>
  * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
  *
@@ -12,15 +13,47 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/namei.h>
 #include <linux/pioctl.h>
 #include <linux/slab.h>
 
+static struct pathless_pioctl_handler *pathless_pioctls;
+static DECLARE_RWSEM(pathless_pioctls_rwsem);
+
+/*
+ * Traverse the pathless pioctl handlers list, to find the appropriate handler
+ */
+static long pathless_pioctl(int cmd, struct vice_ioctl *arg)
+{
+	struct pathless_pioctl_handler *p;
+	long ret;
+
+	down_read(&pathless_pioctls_rwsem);
+	p = pathless_pioctls;
+	while (p) {
+		if (try_module_get(p->owner)) {
+			ret = p->pioctl(cmd, arg);
+			module_put(p->owner);
+			if (ret != -EOPNOTSUPP) {
+				up_write(&pathless_pioctls_rwsem);
+				return ret;
+			}
+		}
+		p = p->next;
+	}
+	up_read(&pathless_pioctls_rwsem);
+	return -EOPNOTSUPP;
+}
+
 /*
  * VFS entry point for path-based I/O control
  */
 long vfs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 {
+	if (!dentry)
+		return pathless_pioctl(cmd, arg);
+
 	if (!dentry->d_inode->i_op || !dentry->d_inode->i_op->pioctl)
 		return -EPERM;
 
@@ -28,6 +61,73 @@ long vfs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 }
 
 /*
+ * Find the pointer to an pathless pioctl handler or the point at which it
+ * should be inserted
+ */
+static struct pathless_pioctl_handler **find_pathless_pioctl(
+			struct pathless_pioctl_handler *handler)
+{
+	struct pathless_pioctl_handler **p;
+
+	for (p = &pathless_pioctls; *p; p = &(*p)->next)
+		if ((*p) == handler)
+			break;
+	return p;
+}
+
+/**
+ * pathless_pioctl_register - Register a pathless pioctl handler
+ * @handler: The handler to be registered
+ *
+ * Add a handler to the list of pathless pioctl handlers, making sure that the
+ * handler is not already registered.
+ */
+int pathless_pioctl_register(struct pathless_pioctl_handler *handler)
+{
+	int res = 0;
+	struct pathless_pioctl_handler **p;
+
+	if (handler->next)
+		return -EBUSY;
+
+	down_write(&pathless_pioctls_rwsem);
+	p = find_pathless_pioctl(handler);
+	if (*p)
+		res = -EBUSY;
+	else
+		*p = handler;
+	up_write(&pathless_pioctls_rwsem);
+	return res;
+}
+EXPORT_SYMBOL(pathless_pioctl_register);
+
+/**
+ * pathless_pioctl_unregister - Unregister a pathless pioctl handler
+ * @handler: The handler to be unregistered
+ *
+ * Remove the special handler from the list of pathless pioctl handlers, making
+ * sure that the handler is already registered.
+ */
+int pathless_pioctl_unregister(struct pathless_pioctl_handler *handler)
+{
+	struct pathless_pioctl_handler **p;
+
+	down_write(&pathless_pioctls_rwsem);
+	for (p = &pathless_pioctls; *p; p = &(*p)->next) {
+		if (*p == handler) {
+			*p = handler->next;
+			handler->next = NULL;
+			up_write(&pathless_pioctls_rwsem);
+			return 0;
+		}
+		
+	}
+	up_write(&pathless_pioctls_rwsem);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pathless_pioctl_unregister);
+
+/*
  * Path-based I/O control system call
  */
 SYSCALL_DEFINE4(pioctl,
@@ -82,11 +182,15 @@ SYSCALL_DEFINE4(pioctl,
 		kargs.out = NULL;
 	}
 
-	error = user_path(filename, &path);
-	if (!error) {
-		if (path.dentry->d_inode)
-			error = vfs_pioctl(path.dentry, cmd, &kargs);
-		path_put(&path);
+	if (!filename) {
+		error = vfs_pioctl(NULL, cmd, &kargs);
+	} else {
+		error = user_path(filename, &path);
+		if (!error) {
+			if (path.dentry->d_inode)
+				error = vfs_pioctl(path.dentry, cmd, &kargs);
+			path_put(&path);
+		}
 	}
 	kfree(kargs.in);
 
diff --git a/include/linux/pioctl.h b/include/linux/pioctl.h
index 8e979f4..a4c1082 100644
--- a/include/linux/pioctl.h
+++ b/include/linux/pioctl.h
@@ -41,6 +41,18 @@ struct vice_ioctl {
  */
 extern long vfs_pioctl(struct dentry *, int, struct vice_ioctl *);
 
+/*
+ * Pathless pioctl handler type
+ */
+struct pathless_pioctl_handler {
+	struct module *owner;
+	struct pathless_pioctl_handler *next;
+	long (*pioctl)(int cmd, struct vice_ioctl *);
+};
+
+extern int pathless_pioctl_register(struct pathless_pioctl_handler *);
+extern int pathless_pioctl_unregister(struct pathless_pioctl_handler *);
+
 #else
 
 /*

