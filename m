Return-Path: <linux-kernel-owner+w=401wt.eu-S935580AbZDCQCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935580AbZDCQCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934540AbZDCP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:56:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56552 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934352AbZDCPzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/41] FS-Cache: Provide a slab for cookie allocation [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:48 +0100
Message-ID: <20090403155548.28714.55124.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a slab from which can be allocated the FS-Cache cookies that will be
presented to the netfs.

Also provide a slab constructor and a function to recursively discard a cookie
and its ancestor chain.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/Makefile   |    1 +
 fs/fscache/cookie.c   |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/internal.h |    8 +++++++
 fs/fscache/main.c     |   15 +++++++++++++
 4 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100644 fs/fscache/cookie.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 556708b..f88ac17 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -4,6 +4,7 @@
 
 fscache-y := \
 	cache.o \
+	cookie.o \
 	fsdef.o \
 	main.o
 
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
new file mode 100644
index 0000000..47fd75b
--- /dev/null
+++ b/fs/fscache/cookie.c
@@ -0,0 +1,56 @@
+/* netfs cookie management
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
+#define FSCACHE_DEBUG_LEVEL COOKIE
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+struct kmem_cache *fscache_cookie_jar;
+
+/*
+ * initialise an cookie jar slab element prior to any use
+ */
+void fscache_cookie_init_once(void *_cookie)
+{
+	struct fscache_cookie *cookie = _cookie;
+
+	memset(cookie, 0, sizeof(*cookie));
+	spin_lock_init(&cookie->lock);
+	INIT_HLIST_HEAD(&cookie->backing_objects);
+}
+
+/*
+ * destroy a cookie
+ */
+void __fscache_cookie_put(struct fscache_cookie *cookie)
+{
+	struct fscache_cookie *parent;
+
+	_enter("%p", cookie);
+
+	for (;;) {
+		_debug("FREE COOKIE %p", cookie);
+		parent = cookie->parent;
+		BUG_ON(!hlist_empty(&cookie->backing_objects));
+		kmem_cache_free(fscache_cookie_jar, cookie);
+
+		if (!parent)
+			break;
+
+		cookie = parent;
+		BUG_ON(atomic_read(&cookie->usage) <= 0);
+		if (!atomic_dec_and_test(&cookie->usage))
+			break;
+	}
+
+	_leave("");
+}
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 0a2069a..4c6ba56 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -37,6 +37,14 @@ extern struct fscache_cache *fscache_select_cache_for_object(
 	struct fscache_cookie *);
 
 /*
+ * fsc-cookie.c
+ */
+extern struct kmem_cache *fscache_cookie_jar;
+
+extern void fscache_cookie_init_once(void *);
+extern void __fscache_cookie_put(struct fscache_cookie *);
+
+/*
  * fsc-fsdef.c
  */
 extern struct fscache_cookie fscache_fsdef_index;
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index c2f3e63..48b79d2 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -56,6 +56,18 @@ static int __init fscache_init(void)
 	if (ret < 0)
 		goto error_proc;
 
+	fscache_cookie_jar = kmem_cache_create("fscache_cookie_jar",
+					       sizeof(struct fscache_cookie),
+					       0,
+					       0,
+					       fscache_cookie_init_once);
+	if (!fscache_cookie_jar) {
+		printk(KERN_NOTICE
+		       "FS-Cache: Failed to allocate a cookie jar\n");
+		ret = -ENOMEM;
+		goto error_cookie_jar;
+	}
+
 	fscache_root = kobject_create_and_add("fscache", kernel_kobj);
 	if (!fscache_root)
 		goto error_kobj;
@@ -64,6 +76,8 @@ static int __init fscache_init(void)
 	return 0;
 
 error_kobj:
+	kmem_cache_destroy(fscache_cookie_jar);
+error_cookie_jar:
 	fscache_proc_cleanup();
 error_proc:
 	slow_work_unregister_user();
@@ -81,6 +95,7 @@ static void __exit fscache_exit(void)
 	_enter("");
 
 	kobject_put(fscache_root);
+	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
 	slow_work_unregister_user();
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");

