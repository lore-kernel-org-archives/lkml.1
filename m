Return-Path: <linux-kernel-owner+w=401wt.eu-S935939AbZDCQJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935939AbZDCQJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934939AbZDCP5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934953AbZDCP5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/41] NFS: Register NFS for caching and retrieve the
	top-level index [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:00 +0100
Message-ID: <20090403155700.28714.58383.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register NFS for caching and retrieve the top-level cache index object cookie.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/Makefile        |    1 +
 fs/nfs/fscache-index.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h       |   35 ++++++++++++++++++++++++++++++++++
 fs/nfs/inode.c         |    8 ++++++++
 4 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 fs/nfs/fscache-index.c
 create mode 100644 fs/nfs/fscache.h


diff --git a/fs/nfs/Makefile b/fs/nfs/Makefile
index ac6170c..0e0bb6c 100644
--- a/fs/nfs/Makefile
+++ b/fs/nfs/Makefile
@@ -15,3 +15,4 @@ nfs-$(CONFIG_NFS_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4renewd.o \
 			   callback.o callback_xdr.o callback_proc.o \
 			   nfs4namespace.o
 nfs-$(CONFIG_SYSCTL) += sysctl.o
+nfs-$(CONFIG_NFS_FSCACHE) += fscache-index.o
diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
new file mode 100644
index 0000000..6d5bb5c
--- /dev/null
+++ b/fs/nfs/fscache-index.c
@@ -0,0 +1,49 @@
+/* NFS FS-Cache index structure definition
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/nfs_fs.h>
+#include <linux/nfs_fs_sb.h>
+#include <linux/in6.h>
+
+#include "internal.h"
+#include "fscache.h"
+
+#define NFSDBG_FACILITY		NFSDBG_FSCACHE
+
+/*
+ * Define the NFS filesystem for FS-Cache.  Upon registration FS-Cache sticks
+ * the cookie for the top-level index object for NFS into here.  The top-level
+ * index can than have other cache objects inserted into it.
+ */
+struct fscache_netfs nfs_fscache_netfs = {
+	.name		= "nfs",
+	.version	= 0,
+};
+
+/*
+ * Register NFS for caching
+ */
+int nfs_fscache_register(void)
+{
+	return fscache_register_netfs(&nfs_fscache_netfs);
+}
+
+/*
+ * Unregister NFS for caching
+ */
+void nfs_fscache_unregister(void)
+{
+	fscache_unregister_netfs(&nfs_fscache_netfs);
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
new file mode 100644
index 0000000..ccfcdc5
--- /dev/null
+++ b/fs/nfs/fscache.h
@@ -0,0 +1,35 @@
+/* NFS filesystem cache interface definitions
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _NFS_FSCACHE_H
+#define _NFS_FSCACHE_H
+
+#include <linux/nfs_fs.h>
+#include <linux/nfs_mount.h>
+#include <linux/nfs4_mount.h>
+#include <linux/fscache.h>
+
+#ifdef CONFIG_NFS_FSCACHE
+
+/*
+ * fscache-index.c
+ */
+extern struct fscache_netfs nfs_fscache_netfs;
+
+extern int nfs_fscache_register(void);
+extern void nfs_fscache_unregister(void);
+
+#else /* CONFIG_NFS_FSCACHE */
+static inline int nfs_fscache_register(void) { return 0; }
+static inline void nfs_fscache_unregister(void) {}
+
+#endif /* CONFIG_NFS_FSCACHE */
+#endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index a834d1d..cd29f41 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -46,6 +46,7 @@
 #include "delegation.h"
 #include "iostat.h"
 #include "internal.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
@@ -1436,6 +1437,10 @@ static int __init init_nfs_fs(void)
 {
 	int err;
 
+	err = nfs_fscache_register();
+	if (err < 0)
+		goto out7;
+
 	err = nfsiod_start();
 	if (err)
 		goto out6;
@@ -1488,6 +1493,8 @@ out4:
 out5:
 	nfsiod_stop();
 out6:
+	nfs_fscache_unregister();
+out7:
 	return err;
 }
 
@@ -1498,6 +1505,7 @@ static void __exit exit_nfs_fs(void)
 	nfs_destroy_readpagecache();
 	nfs_destroy_inodecache();
 	nfs_destroy_nfspagecache();
+	nfs_fscache_unregister();
 #ifdef CONFIG_PROC_FS
 	rpc_proc_unregister("nfs");
 #endif

