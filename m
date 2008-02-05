Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbYBEVlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbYBEVlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761874AbYBEViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:38:16 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36271 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779AbYBEVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:37:50 -0500
Message-Id: <20080205213705.120219893@szeredi.hu>
References: <20080205213616.343721693@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 05 Feb 2008 22:36:23 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/10] unprivileged mounts: add sysctl tunable for "safe" property
Content-Disposition: inline; filename=unprivileged-mounts-add-sysctl-tunable-for-safe-property.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add the following:

  /proc/sys/fs/types/${FS_TYPE}/usermount_safe

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/filesystems.c
===================================================================
--- linux.orig/fs/filesystems.c	2008-02-04 23:47:46.000000000 +0100
+++ linux/fs/filesystems.c	2008-02-04 23:48:04.000000000 +0100
@@ -12,6 +12,7 @@
 #include <linux/kmod.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 #include <asm/uaccess.h>
 
 /*
@@ -51,6 +52,57 @@ static struct file_system_type **find_fi
 	return p;
 }
 
+#define MAX_FILESYSTEM_VARS 1
+
+struct filesystem_sysctl_table {
+	struct ctl_table_header *header;
+	struct ctl_table table[MAX_FILESYSTEM_VARS + 1];
+};
+
+/*
+ * Create /sys/fs/types/${FSNAME} directory with per fs-type tunables.
+ */
+static int filesystem_sysctl_register(struct file_system_type *fs)
+{
+	struct filesystem_sysctl_table *t;
+	struct ctl_path path[] = {
+		{ .procname = "fs", .ctl_name = CTL_FS },
+		{ .procname = "types", .ctl_name = CTL_UNNUMBERED },
+		{ .procname = fs->name, .ctl_name = CTL_UNNUMBERED },
+		{ }
+	};
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return -ENOMEM;
+
+
+	t->table[0].ctl_name = CTL_UNNUMBERED;
+	t->table[0].procname = "usermount_safe";
+	t->table[0].maxlen = sizeof(int);
+	t->table[0].data = &fs->fs_safe;
+	t->table[0].mode = 0644;
+	t->table[0].proc_handler = &proc_dointvec;
+
+	t->header = register_sysctl_paths(path, t->table);
+	if (!t->header) {
+		kfree(t);
+		return -ENOMEM;
+	}
+
+	fs->sysctl_table = t;
+
+	return 0;
+}
+
+static void filesystem_sysctl_unregister(struct file_system_type *fs)
+{
+	struct filesystem_sysctl_table *t = fs->sysctl_table;
+
+	unregister_sysctl_table(t->header);
+	kfree(t);
+}
+
 /**
  *	register_filesystem - register a new filesystem
  *	@fs: the file system structure
@@ -80,6 +132,13 @@ int register_filesystem(struct file_syst
 	else
 		*p = fs;
 	write_unlock(&file_systems_lock);
+
+	if (res == 0) {
+		res = filesystem_sysctl_register(fs);
+		if (res != 0)
+			unregister_filesystem(fs);
+	}
+
 	return res;
 }
 
@@ -108,6 +167,7 @@ int unregister_filesystem(struct file_sy
 			*tmp = fs->next;
 			fs->next = NULL;
 			write_unlock(&file_systems_lock);
+			filesystem_sysctl_unregister(fs);
 			return 0;
 		}
 		tmp = &(*tmp)->next;
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2008-02-04 23:48:02.000000000 +0100
+++ linux/include/linux/fs.h	2008-02-04 23:48:04.000000000 +0100
@@ -1444,6 +1444,7 @@ struct file_system_type {
 	struct module *owner;
 	struct file_system_type * next;
 	struct list_head fs_supers;
+	struct filesystem_sysctl_table *sysctl_table;
 
 	struct lock_class_key s_lock_key;
 	struct lock_class_key s_umount_key;
Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2008-02-04 23:47:58.000000000 +0100
+++ linux/Documentation/filesystems/proc.txt	2008-02-04 23:48:04.000000000 +0100
@@ -44,6 +44,7 @@ Table of Contents
   2.14	/proc/<pid>/io - Display the IO accounting fields
   2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
   2.16	/proc/<pid>/mountinfo - Information about mounts
+  2.17	/proc/sys/fs/types - File system type specific parameters
 
 ------------------------------------------------------------------------------
 Preface
@@ -2392,4 +2393,34 @@ For more information see:
   Documentation/filesystems/sharedsubtree.txt
 
 
+2.17 /proc/sys/fs/types/ - File system type specific parameters
+----------------------------------------------------------------
+
+There's a separate directory /proc/sys/fs/types/<type>/ for each
+filesystem type, containing the following files:
+
+usermount_safe
+--------------
+
+Setting this to non-zero will allow filesystems of this type to be
+mounted by unprivileged users (note, that there are other
+prerequisites as well).
+
+Fuse has been designed to be as safe as possible, and some
+distributions already ship with unprivileged fuse mounts enabled by
+default.  There are still some situations (multi-user systems with
+untrusted users in particular), where enabling this for fuse might not
+be appropriate.  For more details, see Documentation/filesystems/fuse.txt
+
+Procfs is also safe, but unprivileged mounting of it is not usually
+necessary (bind mounting is equivalent).
+
+Most other filesystems are unsafe.  Here are just some of the issues,
+that must be resolved before a filesystem can be declared safe:
+
+ - no strict input checking (buffer overruns, directory loops, etc)
+ - network filesystem deadlocks when mounting from localhost
+ - no permission checking when opening the device
+ - changing mount options when mounting a new instance of a filesystem
+
 ------------------------------------------------------------------------------

--
