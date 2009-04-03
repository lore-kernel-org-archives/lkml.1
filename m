Return-Path: <linux-kernel-owner+w=401wt.eu-S935455AbZDCQBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455AbZDCQBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934416AbZDCPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56542 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787AbZDCPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/41] FS-Cache: Add cache tag handling [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:38 +0100
Message-ID: <20090403155538.28714.72207.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement two features of FS-Cache:

 (1) The ability to request and release cache tags - names by which a cache may
     be known to a netfs, and thus selected for use.

 (2) An internal function by which a cache is selected by consulting the netfs,
     if the netfs wishes to be consulted.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/Makefile     |    1 
 fs/fscache/cache.c      |  166 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/internal.h   |   20 ++++++
 include/linux/fscache.h |    9 ++-
 4 files changed, 195 insertions(+), 1 deletions(-)
 create mode 100644 fs/fscache/cache.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index bc1f3b9..556708b 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -3,6 +3,7 @@
 #
 
 fscache-y := \
+	cache.o \
 	fsdef.o \
 	main.o
 
diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
new file mode 100644
index 0000000..1a28df3
--- /dev/null
+++ b/fs/fscache/cache.c
@@ -0,0 +1,166 @@
+/* FS-Cache cache handling
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
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
+#include <linux/slab.h>
+#include "internal.h"
+
+LIST_HEAD(fscache_cache_list);
+DECLARE_RWSEM(fscache_addremove_sem);
+
+static LIST_HEAD(fscache_cache_tag_list);
+
+/*
+ * look up a cache tag
+ */
+struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
+{
+	struct fscache_cache_tag *tag, *xtag;
+
+	/* firstly check for the existence of the tag under read lock */
+	down_read(&fscache_addremove_sem);
+
+	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
+		if (strcmp(tag->name, name) == 0) {
+			atomic_inc(&tag->usage);
+			up_read(&fscache_addremove_sem);
+			return tag;
+		}
+	}
+
+	up_read(&fscache_addremove_sem);
+
+	/* the tag does not exist - create a candidate */
+	xtag = kzalloc(sizeof(*xtag) + strlen(name) + 1, GFP_KERNEL);
+	if (!xtag)
+		/* return a dummy tag if out of memory */
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&xtag->usage, 1);
+	strcpy(xtag->name, name);
+
+	/* write lock, search again and add if still not present */
+	down_write(&fscache_addremove_sem);
+
+	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
+		if (strcmp(tag->name, name) == 0) {
+			atomic_inc(&tag->usage);
+			up_write(&fscache_addremove_sem);
+			kfree(xtag);
+			return tag;
+		}
+	}
+
+	list_add_tail(&xtag->link, &fscache_cache_tag_list);
+	up_write(&fscache_addremove_sem);
+	return xtag;
+}
+
+/*
+ * release a reference to a cache tag
+ */
+void __fscache_release_cache_tag(struct fscache_cache_tag *tag)
+{
+	if (tag != ERR_PTR(-ENOMEM)) {
+		down_write(&fscache_addremove_sem);
+
+		if (atomic_dec_and_test(&tag->usage))
+			list_del_init(&tag->link);
+		else
+			tag = NULL;
+
+		up_write(&fscache_addremove_sem);
+
+		kfree(tag);
+	}
+}
+
+/*
+ * select a cache in which to store an object
+ * - the cache addremove semaphore must be at least read-locked by the caller
+ * - the object will never be an index
+ */
+struct fscache_cache *fscache_select_cache_for_object(
+	struct fscache_cookie *cookie)
+{
+	struct fscache_cache_tag *tag;
+	struct fscache_object *object;
+	struct fscache_cache *cache;
+
+	_enter("");
+
+	if (list_empty(&fscache_cache_list)) {
+		_leave(" = NULL [no cache]");
+		return NULL;
+	}
+
+	/* we check the parent to determine the cache to use */
+	spin_lock(&cookie->lock);
+
+	/* the first in the parent's backing list should be the preferred
+	 * cache */
+	if (!hlist_empty(&cookie->backing_objects)) {
+		object = hlist_entry(cookie->backing_objects.first,
+				     struct fscache_object, cookie_link);
+
+		cache = object->cache;
+		if (object->state >= FSCACHE_OBJECT_DYING ||
+		    test_bit(FSCACHE_IOERROR, &cache->flags))
+			cache = NULL;
+
+		spin_unlock(&cookie->lock);
+		_leave(" = %p [parent]", cache);
+		return cache;
+	}
+
+	/* the parent is unbacked */
+	if (cookie->def->type != FSCACHE_COOKIE_TYPE_INDEX) {
+		/* cookie not an index and is unbacked */
+		spin_unlock(&cookie->lock);
+		_leave(" = NULL [cookie ub,ni]");
+		return NULL;
+	}
+
+	spin_unlock(&cookie->lock);
+
+	if (!cookie->def->select_cache)
+		goto no_preference;
+
+	/* ask the netfs for its preference */
+	tag = cookie->def->select_cache(cookie->parent->netfs_data,
+					cookie->netfs_data);
+	if (!tag)
+		goto no_preference;
+
+	if (tag == ERR_PTR(-ENOMEM)) {
+		_leave(" = NULL [nomem tag]");
+		return NULL;
+	}
+
+	if (!tag->cache) {
+		_leave(" = NULL [unbacked tag]");
+		return NULL;
+	}
+
+	if (test_bit(FSCACHE_IOERROR, &tag->cache->flags))
+		return NULL;
+
+	_leave(" = %p [specific]", tag->cache);
+	return tag->cache;
+
+no_preference:
+	/* netfs has no preference - just select first cache */
+	cache = list_entry(fscache_cache_list.next,
+			   struct fscache_cache, link);
+	_leave(" = %p [first]", cache);
+	return cache;
+}
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 4113af8..0a2069a 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -28,6 +28,15 @@
 #define FSCACHE_MAX_THREADS	32
 
 /*
+ * fsc-cache.c
+ */
+extern struct list_head fscache_cache_list;
+extern struct rw_semaphore fscache_addremove_sem;
+
+extern struct fscache_cache *fscache_select_cache_for_object(
+	struct fscache_cookie *);
+
+/*
  * fsc-fsdef.c
  */
 extern struct fscache_cookie fscache_fsdef_index;
@@ -168,6 +177,17 @@ extern const struct file_operations fscache_stats_fops;
 #define fscache_stat(stat) do {} while (0)
 #endif
 
+/*
+ * raise an event on an object
+ * - if the event is not masked for that object, then the object is
+ *   queued for attention by the thread pool.
+ */
+static inline void fscache_raise_event(struct fscache_object *object,
+				       unsigned event)
+{
+	BUG();  // TODO
+}
+
 /*****************************************************************************/
 /*
  * debug tracing
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index feb3b0e..9584c09 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -173,6 +173,8 @@ struct fscache_netfs {
  * - these are undefined symbols when FS-Cache is not configured and the
  *   optimiser takes care of not using them
  */
+extern struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *);
+extern void __fscache_release_cache_tag(struct fscache_cache_tag *);
 
 /**
  * fscache_register_netfs - Register a filesystem as desiring caching services
@@ -218,7 +220,10 @@ void fscache_unregister_netfs(struct fscache_netfs *netfs)
 static inline
 struct fscache_cache_tag *fscache_lookup_cache_tag(const char *name)
 {
-	return NULL;
+	if (fscache_available())
+		return __fscache_lookup_cache_tag(name);
+	else
+		return NULL;
 }
 
 /**
@@ -233,6 +238,8 @@ struct fscache_cache_tag *fscache_lookup_cache_tag(const char *name)
 static inline
 void fscache_release_cache_tag(struct fscache_cache_tag *tag)
 {
+	if (fscache_available())
+		__fscache_release_cache_tag(tag);
 }
 
 /**

