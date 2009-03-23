Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZCWP7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZCWP7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZCWP7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:59:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:48444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZCWP7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:59:36 -0400
Date: Mon, 23 Mar 2009 15:57:27 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237759847-21025-2-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/ftrace] debugfs: function to know if debugfs is initialized
Message-ID: <tip-c0f92ba99bdeaf35f9c580291b4e1a657c67fbd4@git.kernel.org>
Git-Commit-ID: c0f92ba99bdeaf35f9c580291b4e1a657c67fbd4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:57:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0f92ba99bdeaf35f9c580291b4e1a657c67fbd4
Gitweb:     http://git.kernel.org/tip/c0f92ba99bdeaf35f9c580291b4e1a657c67fbd4
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 23:10:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:25:46 +0100

debugfs: function to know if debugfs is initialized

Impact: add new debugfs API

With ftrace, some tracers are registered in early initcalls
and attempt to create files on the debugfs filesystem.
Depending on when they are activated, they can try to create their
file at any time. Some checks can be done on the tracing area
but providing a helper to know if debugfs is registered make it
really more easy.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237759847-21025-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/debugfs/inode.c      |   16 ++++++++++++++++
 include/linux/debugfs.h |    8 ++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 81ae9ea..0662ba6 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -30,6 +30,7 @@
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
+static bool debugfs_registered;
 
 static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 {
@@ -496,6 +497,16 @@ exit:
 }
 EXPORT_SYMBOL_GPL(debugfs_rename);
 
+/**
+ * debugfs_initialized - Tells whether debugfs has been registered
+ */
+bool debugfs_initialized(void)
+{
+	return debugfs_registered;
+}
+EXPORT_SYMBOL_GPL(debugfs_initialized);
+
+
 static struct kobject *debug_kobj;
 
 static int __init debugfs_init(void)
@@ -509,11 +520,16 @@ static int __init debugfs_init(void)
 	retval = register_filesystem(&debug_fs_type);
 	if (retval)
 		kobject_put(debug_kobj);
+	else
+		debugfs_registered = true;
+
 	return retval;
 }
 
 static void __exit debugfs_exit(void)
 {
+	debugfs_registered = false;
+
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	unregister_filesystem(&debug_fs_type);
 	kobject_put(debug_kobj);
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index af0e01d..eb5c2ba 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -71,6 +71,9 @@ struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
 				  struct debugfs_blob_wrapper *blob);
+
+bool debugfs_initialized(void);
+
 #else
 
 #include <linux/err.h>
@@ -183,6 +186,11 @@ static inline struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline bool debugfs_initialized(void)
+{
+	return false;
+}
+
 #endif
 
 #endif
