Return-Path: <linux-kernel-owner+w=401wt.eu-S935205AbZDCQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205AbZDCQA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765426AbZDCPzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479AbZDCPz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/41] FS-Cache: Add main configuration option,
	module entry points and debugging [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:23 +0100
Message-ID: <20090403155522.28714.73060.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the main configuration option, allowing FS-Cache to be selected; the
module entry and exit functions and the debugging stuff used by these patches.

The two configuration options added are:

	CONFIG_FSCACHE
	CONFIG_FSCACHE_DEBUG

The first enables the facility, and the second makes the debugging statements
enableable through the "debug" module parameter.  The value of this parameter
is a bitmask as described in:

	Documentation/filesystems/caching/fscache.txt

The module can be loaded at this point, but all it will do at this point in
the patch series is to start up the slow work facility and shut it down again.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/Kconfig            |    6 ++
 fs/Makefile           |    1 
 fs/fscache/Kconfig    |   22 +++++++
 fs/fscache/Makefile   |    8 ++
 fs/fscache/internal.h |  165 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/main.c     |   75 ++++++++++++++++++++++
 6 files changed, 277 insertions(+), 0 deletions(-)
 create mode 100644 fs/fscache/Kconfig
 create mode 100644 fs/fscache/Makefile
 create mode 100644 fs/fscache/internal.h
 create mode 100644 fs/fscache/main.c


diff --git a/fs/Kconfig b/fs/Kconfig
index cef8b18..3942df6 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -66,6 +66,12 @@ config GENERIC_ACL
 	bool
 	select FS_POSIX_ACL
 
+menu "Caches"
+
+source "fs/fscache/Kconfig"
+
+endmenu
+
 if BLOCK
 menu "CD-ROM/DVD Filesystems"
 
diff --git a/fs/Makefile b/fs/Makefile
index b5cd8e1..ff5a10d 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line
+obj-$(CONFIG_FSCACHE)		+= fscache/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT2_FS)		+= ext2/
diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
new file mode 100644
index 0000000..7c7bccd
--- /dev/null
+++ b/fs/fscache/Kconfig
@@ -0,0 +1,22 @@
+
+config FSCACHE
+	tristate "General filesystem local caching manager"
+	depends on EXPERIMENTAL
+	select SLOW_WORK
+	help
+	  This option enables a generic filesystem caching manager that can be
+	  used by various network and other filesystems to cache data locally.
+	  Different sorts of caches can be plugged in, depending on the
+	  resources available.
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_DEBUG
+	bool "Debug FS-Cache"
+	depends on FSCACHE
+	help
+	  This permits debugging to be dynamically enabled in the local caching
+	  management module.  If this is set, the debugging output may be
+	  enabled by setting bits in /sys/modules/fscache/parameter/debug.
+
+	  See Documentation/filesystems/caching/fscache.txt for more information.
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
new file mode 100644
index 0000000..f8038b8
--- /dev/null
+++ b/fs/fscache/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for general filesystem caching code
+#
+
+fscache-y := \
+	main.o
+
+obj-$(CONFIG_FSCACHE) := fscache.o
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
new file mode 100644
index 0000000..95dc92d
--- /dev/null
+++ b/fs/fscache/internal.h
@@ -0,0 +1,165 @@
+/* Internal definitions for FS-Cache
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * Lock order, in the order in which multiple locks should be obtained:
+ * - fscache_addremove_sem
+ * - cookie->lock
+ * - cookie->parent->lock
+ * - cache->object_list_lock
+ * - object->lock
+ * - object->parent->lock
+ * - fscache_thread_lock
+ *
+ */
+
+#include <linux/fscache-cache.h>
+#include <linux/sched.h>
+
+#define FSCACHE_MIN_THREADS	4
+#define FSCACHE_MAX_THREADS	32
+
+/*
+ * fsc-main.c
+ */
+extern unsigned fscache_defer_lookup;
+extern unsigned fscache_defer_create;
+extern unsigned fscache_debug;
+extern struct kobject *fscache_root;
+
+/*****************************************************************************/
+/*
+ * debug tracing
+ */
+#define dbgprintk(FMT, ...) \
+	printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
+
+/* make sure we maintain the format strings, even when debugging is disabled */
+static inline __attribute__((format(printf, 1, 2)))
+void _dbprintk(const char *fmt, ...)
+{
+}
+
+#define kenter(FMT, ...) dbgprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
+#define kdebug(FMT, ...) dbgprintk(FMT, ##__VA_ARGS__)
+
+#define kjournal(FMT, ...) _dbprintk(FMT, ##__VA_ARGS__)
+
+#ifdef __KDEBUG
+#define _enter(FMT, ...) kenter(FMT, ##__VA_ARGS__)
+#define _leave(FMT, ...) kleave(FMT, ##__VA_ARGS__)
+#define _debug(FMT, ...) kdebug(FMT, ##__VA_ARGS__)
+
+#elif defined(CONFIG_FSCACHE_DEBUG)
+#define _enter(FMT, ...)			\
+do {						\
+	if (__do_kdebug(ENTER))			\
+		kenter(FMT, ##__VA_ARGS__);	\
+} while (0)
+
+#define _leave(FMT, ...)			\
+do {						\
+	if (__do_kdebug(LEAVE))			\
+		kleave(FMT, ##__VA_ARGS__);	\
+} while (0)
+
+#define _debug(FMT, ...)			\
+do {						\
+	if (__do_kdebug(DEBUG))			\
+		kdebug(FMT, ##__VA_ARGS__);	\
+} while (0)
+
+#else
+#define _enter(FMT, ...) _dbprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define _leave(FMT, ...) _dbprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
+#define _debug(FMT, ...) _dbprintk(FMT, ##__VA_ARGS__)
+#endif
+
+/*
+ * determine whether a particular optional debugging point should be logged
+ * - we need to go through three steps to persuade cpp to correctly join the
+ *   shorthand in FSCACHE_DEBUG_LEVEL with its prefix
+ */
+#define ____do_kdebug(LEVEL, POINT) \
+	unlikely((fscache_debug & \
+		  (FSCACHE_POINT_##POINT << (FSCACHE_DEBUG_ ## LEVEL * 3))))
+#define ___do_kdebug(LEVEL, POINT) \
+	____do_kdebug(LEVEL, POINT)
+#define __do_kdebug(POINT) \
+	___do_kdebug(FSCACHE_DEBUG_LEVEL, POINT)
+
+#define FSCACHE_DEBUG_CACHE	0
+#define FSCACHE_DEBUG_COOKIE	1
+#define FSCACHE_DEBUG_PAGE	2
+#define FSCACHE_DEBUG_OPERATION	3
+
+#define FSCACHE_POINT_ENTER	1
+#define FSCACHE_POINT_LEAVE	2
+#define FSCACHE_POINT_DEBUG	4
+
+#ifndef FSCACHE_DEBUG_LEVEL
+#define FSCACHE_DEBUG_LEVEL CACHE
+#endif
+
+/*
+ * assertions
+ */
+#if 1 /* defined(__KDEBUGALL) */
+
+#define ASSERT(X)							\
+do {									\
+	if (unlikely(!(X))) {						\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		BUG();							\
+	}								\
+} while (0)
+
+#define ASSERTCMP(X, OP, Y)						\
+do {									\
+	if (unlikely(!((X) OP (Y)))) {					\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		       (unsigned long)(X), (unsigned long)(Y));		\
+		BUG();							\
+	}								\
+} while (0)
+
+#define ASSERTIF(C, X)							\
+do {									\
+	if (unlikely((C) && !(X))) {					\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		BUG();							\
+	}								\
+} while (0)
+
+#define ASSERTIFCMP(C, X, OP, Y)					\
+do {									\
+	if (unlikely((C) && !((X) OP (Y)))) {				\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
+		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		       (unsigned long)(X), (unsigned long)(Y));		\
+		BUG();							\
+	}								\
+} while (0)
+
+#else
+
+#define ASSERT(X)			do {} while (0)
+#define ASSERTCMP(X, OP, Y)		do {} while (0)
+#define ASSERTIF(C, X)			do {} while (0)
+#define ASSERTIFCMP(C, X, OP, Y)	do {} while (0)
+
+#endif /* assert or not */
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
new file mode 100644
index 0000000..76f7c69
--- /dev/null
+++ b/fs/fscache/main.c
@@ -0,0 +1,75 @@
+/* General filesystem local caching manager
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL CACHE
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+MODULE_DESCRIPTION("FS Cache Manager");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
+
+unsigned fscache_defer_lookup = 1;
+module_param_named(defer_lookup, fscache_defer_lookup, uint,
+		   S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_defer_lookup,
+		 "Defer cookie lookup to background thread");
+
+unsigned fscache_defer_create = 1;
+module_param_named(defer_create, fscache_defer_create, uint,
+		   S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_defer_create,
+		 "Defer cookie creation to background thread");
+
+unsigned fscache_debug;
+module_param_named(debug, fscache_debug, uint,
+		   S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(fscache_debug,
+		 "FS-Cache debugging mask");
+
+struct kobject *fscache_root;
+
+/*
+ * initialise the fs caching module
+ */
+static int __init fscache_init(void)
+{
+	int ret;
+
+	ret = slow_work_register_user();
+	if (ret < 0)
+		goto error_slow_work;
+
+	printk(KERN_NOTICE "FS-Cache: Loaded\n");
+	return 0;
+
+error_slow_work:
+	return ret;
+}
+
+fs_initcall(fscache_init);
+
+/*
+ * clean up on module removal
+ */
+static void __exit fscache_exit(void)
+{
+	_enter("");
+
+	slow_work_unregister_user();
+	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
+}
+
+module_exit(fscache_exit);

