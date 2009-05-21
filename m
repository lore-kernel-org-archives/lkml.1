Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZEUJYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZEUJYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZEUJXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:23:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50327 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbZEUJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:23:22 -0400
Message-Id: <20090521092248.244832560@szeredi.hu>
References: <20090521092231.979256687@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 21 May 2009 11:22:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk
Subject: [patch 2/5] union-directory: Support for traversing the layers of a union-directory
Content-Disposition: inline; filename=union-directory-stack.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This adds follow_union_up() to travers from one layer to the next overlayed
mountpoint if given an union mounted mountpoint. This is basically the invert
of what follow_mount() is doing.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/Kconfig  |    8 ++++++++
 fs/Makefile |    2 ++
 fs/union.c  |   34 ++++++++++++++++++++++++++++++++++
 fs/union.h  |   25 +++++++++++++++++++++++++
 4 files changed, 69 insertions(+)

Index: linux-2.6/fs/Kconfig
===================================================================
--- linux-2.6.orig/fs/Kconfig	2009-05-20 15:05:15.000000000 +0200
+++ linux-2.6/fs/Kconfig	2009-05-20 15:09:52.000000000 +0200
@@ -62,6 +62,14 @@ source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
+config UNION_MOUNT
+       bool "Union mount support (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       ---help---
+         If you say Y here, you will be able to mount file systems as
+         union mount stacks. This is a VFS based implementation and
+         should work with all file systems. If unsure, say N.
+
 config GENERIC_ACL
 	bool
 	select FS_POSIX_ACL
Index: linux-2.6/fs/Makefile
===================================================================
--- linux-2.6.orig/fs/Makefile	2009-05-20 15:05:15.000000000 +0200
+++ linux-2.6/fs/Makefile	2009-05-20 15:09:52.000000000 +0200
@@ -51,6 +51,8 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
+obj-$(CONFIG_UNION_MOUNT)	+= union.o
+
 obj-y				+= quota/
 
 obj-$(CONFIG_PROC_FS)		+= proc/
Index: linux-2.6/fs/union.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/union.c	2009-05-20 15:09:52.000000000 +0200
@@ -0,0 +1,34 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include "union.h"
+
+/*
+ * follow_union_up - follow the union stack one layer "up"
+ *
+ * This is called to traverse the union stack from one layer to the next
+ * overlayed one. follow_union_up() is called by various lookup functions
+ * that are aware of union mounts.
+ *
+ * Returns non zero if followed to the next layer, zero otherwise.
+ */
+int follow_union_up(struct path *path)
+{
+	if (IS_MNT_UNION(path->mnt) && path->dentry == path->mnt->mnt_root)
+		return follow_up(&path->mnt, &path->dentry);
+
+	return 0;
+}
Index: linux-2.6/fs/union.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/union.h	2009-05-20 15:09:52.000000000 +0200
@@ -0,0 +1,25 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <linux/mount.h>
+
+struct path;
+
+extern int follow_union_up(struct path *path);
+
+#ifdef CONFIG_UNION_MOUNT
+#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+#else
+#define IS_MNT_UNION(x)		(0)
+#endif

--
