Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZCVWL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZCVWL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZCVWKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:10:55 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52538 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZCVWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XJ+wZYcbfmgp/8AQ4RsRIkpASmtnsByQU30lq25k1sf6xXI5YHPHTW6rhEbi4Fg+kS
         uOVcCFTBPG14Qwx+eLa724wOxFG5IMfaJzX7nYQanMVUhMarU0X+5uCOsXXas+RY1fPz
         hcIlEgW+demrIYIMrUKv+lDDDunQtw7U7kH4o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] debugfs: function to know if debugfs is initialized
Date: Sun, 22 Mar 2009 23:10:44 +0100
Message-Id: <1237759847-21025-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ftrace, some tracers are registered in early initcalls
and attempt to create files on the debugfs filesystem.
Depending on when they are activated, they can try to create their
file at any time. Some checks can be done on the tracing area
but providing a helper to know if debugfs is registered make it
really more easy.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.1

