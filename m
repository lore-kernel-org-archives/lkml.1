Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbZDCQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbZDCQDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934579AbZDCP4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:56:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56556 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934503AbZDCPz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/41] FS-Cache: Add netfs registration [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:53 +0100
Message-ID: <20090403155553.28714.28144.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to register and unregister a network filesystem or other client
of the FS-Cache service.  This allocates and releases the cookie representing
the top-level index for a netfs, and makes it available to the netfs.

If the FS-Cache facility is disabled, then the calls are optimised away at
compile time.

Note that whilst this patch may appear to work with FS-Cache enabled and a
netfs attempting to use it, it will leak the cookie it allocates for the netfs
as fscache_relinquish_cookie() is implemented in a later patch.  This will
cause the slab code to emit a warning when the module is removed.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/Makefile     |    3 +
 fs/fscache/netfs.c      |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fscache.h |    9 ++++
 3 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 fs/fscache/netfs.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index f88ac17..ecf6946 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -6,7 +6,8 @@ fscache-y := \
 	cache.o \
 	cookie.o \
 	fsdef.o \
-	main.o
+	main.o \
+	netfs.o
 
 fscache-$(CONFIG_PROC_FS) += proc.o
 fscache-$(CONFIG_FSCACHE_STATS) += stats.o
diff --git a/fs/fscache/netfs.c b/fs/fscache/netfs.c
new file mode 100644
index 0000000..e028b8e
--- /dev/null
+++ b/fs/fscache/netfs.c
@@ -0,0 +1,103 @@
+/* FS-Cache netfs (client) registration
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
+#define FSCACHE_DEBUG_LEVEL COOKIE
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+static LIST_HEAD(fscache_netfs_list);
+
+/*
+ * register a network filesystem for caching
+ */
+int __fscache_register_netfs(struct fscache_netfs *netfs)
+{
+	struct fscache_netfs *ptr;
+	int ret;
+
+	_enter("{%s}", netfs->name);
+
+	INIT_LIST_HEAD(&netfs->link);
+
+	/* allocate a cookie for the primary index */
+	netfs->primary_index =
+		kmem_cache_zalloc(fscache_cookie_jar, GFP_KERNEL);
+
+	if (!netfs->primary_index) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	/* initialise the primary index cookie */
+	atomic_set(&netfs->primary_index->usage, 1);
+	atomic_set(&netfs->primary_index->n_children, 0);
+
+	netfs->primary_index->def		= &fscache_fsdef_netfs_def;
+	netfs->primary_index->parent		= &fscache_fsdef_index;
+	netfs->primary_index->netfs_data	= netfs;
+
+	atomic_inc(&netfs->primary_index->parent->usage);
+	atomic_inc(&netfs->primary_index->parent->n_children);
+
+	spin_lock_init(&netfs->primary_index->lock);
+	INIT_HLIST_HEAD(&netfs->primary_index->backing_objects);
+
+	/* check the netfs type is not already present */
+	down_write(&fscache_addremove_sem);
+
+	ret = -EEXIST;
+	list_for_each_entry(ptr, &fscache_netfs_list, link) {
+		if (strcmp(ptr->name, netfs->name) == 0)
+			goto already_registered;
+	}
+
+	list_add(&netfs->link, &fscache_netfs_list);
+	ret = 0;
+
+	printk(KERN_NOTICE "FS-Cache: Netfs '%s' registered for caching\n",
+	       netfs->name);
+
+already_registered:
+	up_write(&fscache_addremove_sem);
+
+	if (ret < 0) {
+		netfs->primary_index->parent = NULL;
+		__fscache_cookie_put(netfs->primary_index);
+		netfs->primary_index = NULL;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL(__fscache_register_netfs);
+
+/*
+ * unregister a network filesystem from the cache
+ * - all cookies must have been released first
+ */
+void __fscache_unregister_netfs(struct fscache_netfs *netfs)
+{
+	_enter("{%s.%u}", netfs->name, netfs->version);
+
+	down_write(&fscache_addremove_sem);
+
+	list_del(&netfs->link);
+	fscache_relinquish_cookie(netfs->primary_index, 0);
+
+	up_write(&fscache_addremove_sem);
+
+	printk(KERN_NOTICE "FS-Cache: Netfs '%s' unregistered from caching\n",
+	       netfs->name);
+
+	_leave("");
+}
+EXPORT_SYMBOL(__fscache_unregister_netfs);
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 9584c09..b195c2e 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -173,6 +173,8 @@ struct fscache_netfs {
  * - these are undefined symbols when FS-Cache is not configured and the
  *   optimiser takes care of not using them
  */
+extern int __fscache_register_netfs(struct fscache_netfs *);
+extern void __fscache_unregister_netfs(struct fscache_netfs *);
 extern struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *);
 extern void __fscache_release_cache_tag(struct fscache_cache_tag *);
 
@@ -188,7 +190,10 @@ extern void __fscache_release_cache_tag(struct fscache_cache_tag *);
 static inline
 int fscache_register_netfs(struct fscache_netfs *netfs)
 {
-	return 0;
+	if (fscache_available())
+		return __fscache_register_netfs(netfs);
+	else
+		return 0;
 }
 
 /**
@@ -205,6 +210,8 @@ int fscache_register_netfs(struct fscache_netfs *netfs)
 static inline
 void fscache_unregister_netfs(struct fscache_netfs *netfs)
 {
+	if (fscache_available())
+		__fscache_unregister_netfs(netfs);
 }
 
 /**

