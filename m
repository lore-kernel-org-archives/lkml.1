Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYKTOst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYKTOst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYKTOnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:43:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbYKTOnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:43:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/45] FS-Cache: Provide a slab for cookie allocation [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:42:57 +0000
Message-ID: <20081120144257.10667.71514.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
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
---

 fs/fscache/Makefile       |    1 +
 fs/fscache/fsc-cookie.c   |   56 +++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/fsc-internal.h |    8 ++++++
 fs/fscache/fsc-main.c     |   17 +++++++++++++-
 4 files changed, 81 insertions(+), 1 deletions(-)
 create mode 100644 fs/fscache/fsc-cookie.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 85d1dd4..51c91e4 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -4,6 +4,7 @@
 
 fscache-y := \
 	fsc-cache.o \
+	fsc-cookie.o \
 	fsc-fsdef.o \
 	fsc-main.o \
 	fsc-proc.o \
diff --git a/fs/fscache/fsc-cookie.c b/fs/fscache/fsc-cookie.c
new file mode 100644
index 0000000..321da16
--- /dev/null
+++ b/fs/fscache/fsc-cookie.c
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
+#include "fsc-internal.h"
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
diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
index ffd2c88..8f1beb5 100644
--- a/fs/fscache/fsc-internal.h
+++ b/fs/fscache/fsc-internal.h
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
diff --git a/fs/fscache/fsc-main.c b/fs/fscache/fsc-main.c
index e88117b..5ecbaa7 100644
--- a/fs/fscache/fsc-main.c
+++ b/fs/fscache/fsc-main.c
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
@@ -64,7 +76,9 @@ static int __init fscache_init(void)
 	return 0;
 
 error_kobj:
- 	fscache_proc_cleanup();
+	kmem_cache_destroy(fscache_cookie_jar);
+error_cookie_jar:
+	fscache_proc_cleanup();
 error_proc:
 	slow_work_unregister_user();
 error_slow_work:
@@ -81,6 +95,7 @@ static void __exit fscache_exit(void)
 	_enter("");
 
 	kobject_put(fscache_root);
+	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
 	slow_work_unregister_user();
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");

