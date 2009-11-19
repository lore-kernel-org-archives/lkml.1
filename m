Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZKSRVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZKSRVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZKSRVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbZKSRVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/28] FS-Cache: Allow the current state of all objects to be
	dumped
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:20 +0000
Message-ID: <20091119172120.1679.72080.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the current state of all fscache objects to be dumped by doing:

	cat /proc/fs/fscache/objects

By default, all objects and all fields will be shown.  This can be restricted
by adding a suitable key to one of the caller's keyrings (such as the session
keyring):

	keyctl add user fscache:objlist "<restrictions>" @s

The <restrictions> are:

	K	Show hexdump of object key (don't show if not given)
	A	Show hexdump of object aux data (don't show if not given)

And paired restrictions:

	C	Show objects that have a cookie
	c	Show objects that don't have a cookie
	B	Show objects that are busy
	b	Show objects that aren't busy
	W	Show objects that have pending writes
	w	Show objects that don't have pending writes
	R	Show objects that have outstanding reads
	r	Show objects that don't have outstanding reads
	S	Show objects that have slow work queued
	s	Show objects that don't have slow work queued

If neither side of a restriction pair is given, then both are implied.  For
example:

	keyctl add user fscache:objlist KB @s

shows objects that are busy, and lists their object keys, but does not dump
their auxiliary data.  It also implies "CcWwRrSs", but as 'B' is given, 'b' is
not implied.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |   81 +++++
 fs/cachefiles/interface.c                     |    1 
 fs/cachefiles/rdwr.c                          |    6 
 fs/fscache/Kconfig                            |    7 
 fs/fscache/Makefile                           |    1 
 fs/fscache/cache.c                            |    1 
 fs/fscache/cookie.c                           |    2 
 fs/fscache/internal.h                         |   13 +
 fs/fscache/object-list.c                      |  432 +++++++++++++++++++++++++
 fs/fscache/object.c                           |    2 
 fs/fscache/operation.c                        |    3 
 fs/fscache/page.c                             |    6 
 fs/fscache/proc.c                             |   13 +
 include/linux/fscache-cache.h                 |   13 +
 14 files changed, 578 insertions(+), 3 deletions(-)
 create mode 100644 fs/fscache/object-list.c

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 9e94b94..cf13cd3 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -299,6 +299,87 @@ proc files.
      jiffy range covered, and the SECS field the equivalent number of seconds.
 
 
+===========
+OBJECT LIST
+===========
+
+If CONFIG_FSCACHE_OBJECT_LIST is enabled, the FS-Cache facility will maintain a
+list of all the objects currently allocated and allow them to be viewed
+through:
+
+	/proc/fs/fscache/objects
+
+This will look something like:
+
+	[root@andromeda ~]# head /proc/fs/fscache/objects 
+	OBJECT   PARENT   STAT CHLDN OPS OOP IPR EX READS EM EV F S | NETFS_COOKIE_DEF TY FL NETFS_DATA       OBJECT_KEY, AUX_DATA
+	======== ======== ==== ===== === === === == ===== == == = = | ================ == == ================ ================
+	   17e4b        2 ACTV     0   0   0   0  0     0 7b  4 0 8 | NFS.fh           DT  0 ffff88001dd82820 010006017edcf8bbc93b43298fdfbe71e50b57b13a172c0117f38472, e567634700000000000000000000000063f2404a000000000000000000000000c9030000000000000000000063f2404a
+	   1693a        2 ACTV     0   0   0   0  0     0 7b  4 0 8 | NFS.fh           DT  0 ffff88002db23380 010006017edcf8bbc93b43298fdfbe71e50b57b1e0162c01a2df0ea6, 420ebc4a000000000000000000000000420ebc4a0000000000000000000000000e1801000000000000000000420ebc4a
+
+where the first set of columns before the '|' describe the object:
+
+	COLUMN	DESCRIPTION
+	=======	===============================================================
+	OBJECT	Object debugging ID (appears as OBJ%x in some debug messages)
+	PARENT	Debugging ID of parent object
+	STAT	Object state
+	CHLDN	Number of child objects of this object
+	OPS	Number of outstanding operations on this object
+	OOP	Number of outstanding child object management operations
+	IPR
+	EX	Number of outstanding exclusive operations
+	READS	Number of outstanding read operations
+	EM	Object's event mask
+	EV	Events raised on this object
+	F	Object flags
+	S	Object slow-work work item flags
+
+and the second set of columns describe the object's cookie, if present:
+
+	COLUMN		DESCRIPTION
+	===============	=======================================================
+	NETFS_COOKIE_DEF Name of netfs cookie definition
+	TY		Cookie type (IX - index, DT - data, hex - special)
+	FL		Cookie flags
+	NETFS_DATA	Netfs private data stored in the cookie
+	OBJECT_KEY	Object key	} 1 column, with separating comma
+	AUX_DATA	Object aux data	} presence may be configured
+
+The data shown may be filtered by attaching the a key to an appropriate keyring
+before viewing the file.  Something like:
+
+		keyctl add user fscache:objlist <restrictions> @s
+
+where <restrictions> are a selection of the following letters:
+
+	K	Show hexdump of object key (don't show if not given)
+	A	Show hexdump of object aux data (don't show if not given)
+
+and the following paired letters:
+
+	C	Show objects that have a cookie
+	c	Show objects that don't have a cookie
+	B	Show objects that are busy
+	b	Show objects that aren't busy
+	W	Show objects that have pending writes
+	w	Show objects that don't have pending writes
+	R	Show objects that have outstanding reads
+	r	Show objects that don't have outstanding reads
+	S	Show objects that have slow work queued
+	s	Show objects that don't have slow work queued
+
+If neither side of a letter pair is given, then both are implied.  For example:
+
+	keyctl add user fscache:objlist KB @s
+
+shows objects that are busy, and lists their object keys, but does not dump
+their auxiliary data.  It also implies "CcWwRrSs", but as 'B' is given, 'b' is
+not implied.
+
+By default all objects and all fields will be shown.
+
+
 =========
 DEBUGGING
 =========
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 431accd..dd7f852 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -331,6 +331,7 @@ static void cachefiles_put_object(struct fscache_object *_object)
 		}
 
 		cache = object->fscache.cache;
+		fscache_object_destroy(&object->fscache);
 		kmem_cache_free(cachefiles_object_jar, object);
 		fscache_object_destroyed(cache);
 	}
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index a69787e..3304646 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -333,7 +333,8 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
 
-	op->op.flags = FSCACHE_OP_FAST;
+	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
+	op->op.flags |= FSCACHE_OP_FAST;
 	op->op.processor = cachefiles_read_copier;
 
 	pagevec_init(&pagevec, 0);
@@ -639,7 +640,8 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 
 	pagevec_init(&pagevec, 0);
 
-	op->op.flags = FSCACHE_OP_FAST;
+	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
+	op->op.flags |= FSCACHE_OP_FAST;
 	op->op.processor = cachefiles_read_copier;
 
 	INIT_LIST_HEAD(&backpages);
diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index 9bbb8ce..864dac2 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -54,3 +54,10 @@ config FSCACHE_DEBUG
 	  enabled by setting bits in /sys/modules/fscache/parameter/debug.
 
 	  See Documentation/filesystems/caching/fscache.txt for more information.
+
+config FSCACHE_OBJECT_LIST
+	bool "Maintain global object list for debugging purposes"
+	depends on FSCACHE && PROC_FS
+	help
+	  Maintain a global list of active fscache objects that can be
+	  retrieved through /proc/fs/fscache/objects for debugging purposes
diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 91571b9..6d56153 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -15,5 +15,6 @@ fscache-y := \
 fscache-$(CONFIG_PROC_FS) += proc.o
 fscache-$(CONFIG_FSCACHE_STATS) += stats.o
 fscache-$(CONFIG_FSCACHE_HISTOGRAM) += histogram.o
+fscache-$(CONFIG_FSCACHE_OBJECT_LIST) += object-list.o
 
 obj-$(CONFIG_FSCACHE) := fscache.o
diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index e21985b..724384e 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -263,6 +263,7 @@ int fscache_add_cache(struct fscache_cache *cache,
 	spin_lock(&cache->object_list_lock);
 	list_add_tail(&ifsdef->cache_link, &cache->object_list);
 	spin_unlock(&cache->object_list_lock);
+	fscache_objlist_add(ifsdef);
 
 	/* add the cache's netfs definition index object to the top level index
 	 * cookie as a known backing object */
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 72fd18f..9b51873 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -349,6 +349,8 @@ static int fscache_attach_object(struct fscache_cookie *cookie,
 	object->cookie = cookie;
 	atomic_inc(&cookie->usage);
 	hlist_add_head(&object->cookie_link, &cookie->backing_objects);
+
+	fscache_objlist_add(object);
 	ret = 0;
 
 cant_attach_object:
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 1c34130..fe02973 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -88,11 +88,24 @@ extern int fscache_wait_bit_interruptible(void *);
 /*
  * object.c
  */
+extern const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5];
+
 extern void fscache_withdrawing_object(struct fscache_cache *,
 				       struct fscache_object *);
 extern void fscache_enqueue_object(struct fscache_object *);
 
 /*
+ * object-list.c
+ */
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+extern const struct file_operations fscache_objlist_fops;
+
+extern void fscache_objlist_add(struct fscache_object *);
+#else
+#define fscache_objlist_add(object) do {} while(0)
+#endif
+
+/*
  * operation.c
  */
 extern int fscache_submit_exclusive_op(struct fscache_object *,
diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
new file mode 100644
index 0000000..e590242
--- /dev/null
+++ b/fs/fscache/object-list.c
@@ -0,0 +1,432 @@
+/* Global fscache object list maintainer and viewer
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
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
+#include <linux/seq_file.h>
+#include <linux/key.h>
+#include <keys/user-type.h>
+#include "internal.h"
+
+static struct rb_root fscache_object_list;
+static DEFINE_RWLOCK(fscache_object_list_lock);
+
+struct fscache_objlist_data {
+	unsigned long	config;		/* display configuration */
+#define FSCACHE_OBJLIST_CONFIG_KEY	0x00000001	/* show object keys */
+#define FSCACHE_OBJLIST_CONFIG_AUX	0x00000002	/* show object auxdata */
+#define FSCACHE_OBJLIST_CONFIG_COOKIE	0x00000004	/* show objects with cookies */
+#define FSCACHE_OBJLIST_CONFIG_NOCOOKIE	0x00000008	/* show objects without cookies */
+#define FSCACHE_OBJLIST_CONFIG_BUSY	0x00000010	/* show busy objects */
+#define FSCACHE_OBJLIST_CONFIG_IDLE	0x00000020	/* show idle objects */
+#define FSCACHE_OBJLIST_CONFIG_PENDWR	0x00000040	/* show objects with pending writes */
+#define FSCACHE_OBJLIST_CONFIG_NOPENDWR	0x00000080	/* show objects without pending writes */
+#define FSCACHE_OBJLIST_CONFIG_READS	0x00000100	/* show objects with active reads */
+#define FSCACHE_OBJLIST_CONFIG_NOREADS	0x00000200	/* show objects without active reads */
+#define FSCACHE_OBJLIST_CONFIG_EVENTS	0x00000400	/* show objects with events */
+#define FSCACHE_OBJLIST_CONFIG_NOEVENTS	0x00000800	/* show objects without no events */
+#define FSCACHE_OBJLIST_CONFIG_WORK	0x00001000	/* show objects with slow work */
+#define FSCACHE_OBJLIST_CONFIG_NOWORK	0x00002000	/* show objects without slow work */
+
+	u8		buf[512];	/* key and aux data buffer */
+};
+
+/*
+ * Add an object to the object list
+ * - we use the address of the fscache_object structure as the key into the
+ *   tree
+ */
+void fscache_objlist_add(struct fscache_object *obj)
+{
+	struct fscache_object *xobj;
+	struct rb_node **p = &fscache_object_list.rb_node, *parent = NULL;
+
+	write_lock(&fscache_object_list_lock);
+
+	while (*p) {
+		parent = *p;
+		xobj = rb_entry(parent, struct fscache_object, objlist_link);
+
+		if (obj < xobj)
+			p = &(*p)->rb_left;
+		else if (obj > xobj)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&obj->objlist_link, parent, p);
+	rb_insert_color(&obj->objlist_link, &fscache_object_list);
+
+	write_unlock(&fscache_object_list_lock);
+}
+
+/**
+ * fscache_object_destroy - Note that a cache object is about to be destroyed
+ * @object: The object to be destroyed
+ *
+ * Note the imminent destruction and deallocation of a cache object record.
+ */
+void fscache_object_destroy(struct fscache_object *obj)
+{
+	write_lock(&fscache_object_list_lock);
+
+	BUG_ON(RB_EMPTY_ROOT(&fscache_object_list));
+	rb_erase(&obj->objlist_link, &fscache_object_list);
+
+	write_unlock(&fscache_object_list_lock);
+}
+EXPORT_SYMBOL(fscache_object_destroy);
+
+/*
+ * find the object in the tree on or after the specified index
+ */
+static struct fscache_object *fscache_objlist_lookup(loff_t *_pos)
+{
+	struct fscache_object *pobj, *obj, *minobj = NULL;
+	struct rb_node *p;
+	unsigned long pos;
+
+	if (*_pos >= (unsigned long) ERR_PTR(-ENOENT))
+		return NULL;
+	pos = *_pos;
+
+	/* banners (can't represent line 0 by pos 0 as that would involve
+	 * returning a NULL pointer) */
+	if (pos == 0)
+		return (struct fscache_object *) ++(*_pos);
+	if (pos < 3)
+		return (struct fscache_object *)pos;
+
+	pobj = (struct fscache_object *)pos;
+	p = fscache_object_list.rb_node;
+	while (p) {
+		obj = rb_entry(p, struct fscache_object, objlist_link);
+		if (pobj < obj) {
+			if (!minobj || minobj > obj)
+				minobj = obj;
+			p = p->rb_left;
+		} else if (pobj > obj) {
+			p = p->rb_right;
+		} else {
+			minobj = obj;
+			break;
+		}
+		obj = NULL;
+	}
+
+	if (!minobj)
+		*_pos = (unsigned long) ERR_PTR(-ENOENT);
+	else if (minobj != obj)
+		*_pos = (unsigned long) minobj;
+	return minobj;
+}
+
+/*
+ * set up the iterator to start reading from the first line
+ */
+static void *fscache_objlist_start(struct seq_file *m, loff_t *_pos)
+	__acquires(&fscache_object_list_lock)
+{
+	read_lock(&fscache_object_list_lock);
+	return fscache_objlist_lookup(_pos);
+}
+
+/*
+ * move to the next line
+ */
+static void *fscache_objlist_next(struct seq_file *m, void *v, loff_t *_pos)
+{
+	(*_pos)++;
+	return fscache_objlist_lookup(_pos);
+}
+
+/*
+ * clean up after reading
+ */
+static void fscache_objlist_stop(struct seq_file *m, void *v)
+	__releases(&fscache_object_list_lock)
+{
+	read_unlock(&fscache_object_list_lock);
+}
+
+/*
+ * display an object
+ */
+static int fscache_objlist_show(struct seq_file *m, void *v)
+{
+	struct fscache_objlist_data *data = m->private;
+	struct fscache_object *obj = v;
+	unsigned long config = data->config;
+	uint16_t keylen, auxlen;
+	char _type[3], *type;
+	bool no_cookie;
+	u8 *buf = data->buf, *p;
+
+	if ((unsigned long) v == 1) {
+		seq_puts(m, "OBJECT   PARENT   STAT CHLDN OPS OOP IPR EX READS"
+			 " EM EV F S"
+			 " | NETFS_COOKIE_DEF TY FL NETFS_DATA");
+		if (config & (FSCACHE_OBJLIST_CONFIG_KEY |
+			      FSCACHE_OBJLIST_CONFIG_AUX))
+			seq_puts(m, "       ");
+		if (config & FSCACHE_OBJLIST_CONFIG_KEY)
+			seq_puts(m, "OBJECT_KEY");
+		if ((config & (FSCACHE_OBJLIST_CONFIG_KEY |
+			       FSCACHE_OBJLIST_CONFIG_AUX)) ==
+		    (FSCACHE_OBJLIST_CONFIG_KEY | FSCACHE_OBJLIST_CONFIG_AUX))
+			seq_puts(m, ", ");
+		if (config & FSCACHE_OBJLIST_CONFIG_AUX)
+			seq_puts(m, "AUX_DATA");
+		seq_puts(m, "\n");
+		return 0;
+	}
+
+	if ((unsigned long) v == 2) {
+		seq_puts(m, "======== ======== ==== ===== === === === == ====="
+			 " == == = ="
+			 " | ================ == == ================");
+		if (config & (FSCACHE_OBJLIST_CONFIG_KEY |
+			      FSCACHE_OBJLIST_CONFIG_AUX))
+			seq_puts(m, " ================");
+		seq_puts(m, "\n");
+		return 0;
+	}
+
+	/* filter out any unwanted objects */
+#define FILTER(criterion, _yes, _no)					\
+	do {								\
+		unsigned long yes = FSCACHE_OBJLIST_CONFIG_##_yes;	\
+		unsigned long no = FSCACHE_OBJLIST_CONFIG_##_no;	\
+		if (criterion) {					\
+			if (!(config & yes))				\
+				return 0;				\
+		} else {						\
+			if (!(config & no))				\
+				return 0;				\
+		}							\
+	} while(0)
+
+	if (~config) {
+		FILTER(obj->cookie,
+		       COOKIE, NOCOOKIE);
+		FILTER(obj->state != FSCACHE_OBJECT_ACTIVE ||
+		       obj->n_ops != 0 ||
+		       obj->n_obj_ops != 0 ||
+		       obj->flags ||
+		       !list_empty(&obj->dependents),
+		       BUSY, IDLE);
+		FILTER(test_bit(FSCACHE_OBJECT_PENDING_WRITE, &obj->flags),
+		       PENDWR, NOPENDWR);
+		FILTER(atomic_read(&obj->n_reads),
+		       READS, NOREADS);
+		FILTER(obj->events & obj->event_mask,
+		       EVENTS, NOEVENTS);
+		FILTER(obj->work.flags & ~(1UL << SLOW_WORK_VERY_SLOW),
+		       WORK, NOWORK);
+	}
+
+	seq_printf(m,
+		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx %1lx | ",
+		   obj->debug_id,
+		   obj->parent ? obj->parent->debug_id : -1,
+		   fscache_object_states_short[obj->state],
+		   obj->n_children,
+		   obj->n_ops,
+		   obj->n_obj_ops,
+		   obj->n_in_progress,
+		   obj->n_exclusive,
+		   atomic_read(&obj->n_reads),
+		   obj->event_mask & FSCACHE_OBJECT_EVENTS_MASK,
+		   obj->events,
+		   obj->flags,
+		   obj->work.flags);
+
+	no_cookie = true;
+	keylen = auxlen = 0;
+	if (obj->cookie) {
+		spin_lock(&obj->lock);
+		if (obj->cookie) {
+			switch (obj->cookie->def->type) {
+			case 0:
+				type = "IX";
+				break;
+			case 1:
+				type = "DT";
+				break;
+			default:
+				sprintf(_type, "%02u",
+					obj->cookie->def->type);
+				type = _type;
+				break;
+			}
+
+			seq_printf(m, "%-16s %s %2lx %16p",
+				   obj->cookie->def->name,
+				   type,
+				   obj->cookie->flags,
+				   obj->cookie->netfs_data);
+
+			if (obj->cookie->def->get_key &&
+			    config & FSCACHE_OBJLIST_CONFIG_KEY)
+				keylen = obj->cookie->def->get_key(
+					obj->cookie->netfs_data,
+					buf, 400);
+
+			if (obj->cookie->def->get_aux &&
+			    config & FSCACHE_OBJLIST_CONFIG_AUX)
+				auxlen = obj->cookie->def->get_aux(
+					obj->cookie->netfs_data,
+					buf + keylen, 512 - keylen);
+
+			no_cookie = false;
+		}
+		spin_unlock(&obj->lock);
+
+		if (!no_cookie && (keylen > 0 || auxlen > 0)) {
+			seq_printf(m, " ");
+			for (p = buf; keylen > 0; keylen--)
+				seq_printf(m, "%02x", *p++);
+			if (auxlen > 0) {
+				if (config & FSCACHE_OBJLIST_CONFIG_KEY)
+					seq_printf(m, ", ");
+				for (; auxlen > 0; auxlen--)
+					seq_printf(m, "%02x", *p++);
+			}
+		}
+	}
+
+	if (no_cookie)
+		seq_printf(m, "<no_cookie>\n");
+	else
+		seq_printf(m, "\n");
+	return 0;
+}
+
+static const struct seq_operations fscache_objlist_ops = {
+	.start		= fscache_objlist_start,
+	.stop		= fscache_objlist_stop,
+	.next		= fscache_objlist_next,
+	.show		= fscache_objlist_show,
+};
+
+/*
+ * get the configuration for filtering the list
+ */
+static void fscache_objlist_config(struct fscache_objlist_data *data)
+{
+#ifdef CONFIG_KEYS
+	struct user_key_payload *confkey;
+	unsigned long config;
+	struct key *key;
+	const char *buf;
+	int len;
+
+	key = request_key(&key_type_user, "fscache:objlist", NULL);
+	if (IS_ERR(key))
+		goto no_config;
+
+	config = 0;
+	rcu_read_lock();
+
+	confkey = key->payload.data;
+	buf = confkey->data;
+
+	for (len = confkey->datalen - 1; len >= 0; len--) {
+		switch (buf[len]) {
+		case 'K': config |= FSCACHE_OBJLIST_CONFIG_KEY;		break;
+		case 'A': config |= FSCACHE_OBJLIST_CONFIG_AUX;		break;
+		case 'C': config |= FSCACHE_OBJLIST_CONFIG_COOKIE;	break;
+		case 'c': config |= FSCACHE_OBJLIST_CONFIG_NOCOOKIE;	break;
+		case 'B': config |= FSCACHE_OBJLIST_CONFIG_BUSY;	break;
+		case 'b': config |= FSCACHE_OBJLIST_CONFIG_IDLE;	break;
+		case 'W': config |= FSCACHE_OBJLIST_CONFIG_PENDWR;	break;
+		case 'w': config |= FSCACHE_OBJLIST_CONFIG_NOPENDWR;	break;
+		case 'R': config |= FSCACHE_OBJLIST_CONFIG_READS;	break;
+		case 'r': config |= FSCACHE_OBJLIST_CONFIG_NOREADS;	break;
+		case 'S': config |= FSCACHE_OBJLIST_CONFIG_WORK;	break;
+		case 's': config |= FSCACHE_OBJLIST_CONFIG_NOWORK;	break;
+		}
+	}
+
+	rcu_read_unlock();
+	key_put(key);
+
+	if (!(config & (FSCACHE_OBJLIST_CONFIG_COOKIE | FSCACHE_OBJLIST_CONFIG_NOCOOKIE)))
+	    config   |= FSCACHE_OBJLIST_CONFIG_COOKIE | FSCACHE_OBJLIST_CONFIG_NOCOOKIE;
+	if (!(config & (FSCACHE_OBJLIST_CONFIG_BUSY | FSCACHE_OBJLIST_CONFIG_IDLE)))
+	    config   |= FSCACHE_OBJLIST_CONFIG_BUSY | FSCACHE_OBJLIST_CONFIG_IDLE;
+	if (!(config & (FSCACHE_OBJLIST_CONFIG_PENDWR | FSCACHE_OBJLIST_CONFIG_NOPENDWR)))
+	    config   |= FSCACHE_OBJLIST_CONFIG_PENDWR | FSCACHE_OBJLIST_CONFIG_NOPENDWR;
+	if (!(config & (FSCACHE_OBJLIST_CONFIG_READS | FSCACHE_OBJLIST_CONFIG_NOREADS)))
+	    config   |= FSCACHE_OBJLIST_CONFIG_READS | FSCACHE_OBJLIST_CONFIG_NOREADS;
+	if (!(config & (FSCACHE_OBJLIST_CONFIG_EVENTS | FSCACHE_OBJLIST_CONFIG_NOEVENTS)))
+	    config   |= FSCACHE_OBJLIST_CONFIG_EVENTS | FSCACHE_OBJLIST_CONFIG_NOEVENTS;
+	if (!(config & (FSCACHE_OBJLIST_CONFIG_WORK | FSCACHE_OBJLIST_CONFIG_NOWORK)))
+	    config   |= FSCACHE_OBJLIST_CONFIG_WORK | FSCACHE_OBJLIST_CONFIG_NOWORK;
+
+	data->config = config;
+	return;
+
+no_config:
+#endif
+	data->config = ULONG_MAX;
+}
+
+/*
+ * open "/proc/fs/fscache/objects" to provide a list of active objects
+ * - can be configured by a user-defined key added to the caller's keyrings
+ */
+static int fscache_objlist_open(struct inode *inode, struct file *file)
+{
+	struct fscache_objlist_data *data;
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, &fscache_objlist_ops);
+	if (ret < 0)
+		return ret;
+
+	m = file->private_data;
+
+	/* buffer for key extraction */
+	data = kmalloc(sizeof(struct fscache_objlist_data), GFP_KERNEL);
+	if (!data) {
+		seq_release(inode, file);
+		return -ENOMEM;
+	}
+
+	/* get the configuration key */
+	fscache_objlist_config(data);
+
+	m->private = data;
+	return 0;
+}
+
+/*
+ * clean up on close
+ */
+static int fscache_objlist_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+
+	kfree(m->private);
+	m->private = NULL;
+	return seq_release(inode, file);
+}
+
+const struct file_operations fscache_objlist_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fscache_objlist_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= fscache_objlist_release,
+};
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 615b63d..ad1644f 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -34,7 +34,7 @@ const char *fscache_object_states[FSCACHE_OBJECT__NSTATES] = {
 };
 EXPORT_SYMBOL(fscache_object_states);
 
-static const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5] = {
+const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5] = {
 	[FSCACHE_OBJECT_INIT]		= "INIT",
 	[FSCACHE_OBJECT_LOOKING_UP]	= "LOOK",
 	[FSCACHE_OBJECT_CREATING]	= "CRTN",
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 91bbe6f..09e43b6 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -322,6 +322,9 @@ void fscache_put_operation(struct fscache_operation *op)
 
 	object = op->object;
 
+	if (test_bit(FSCACHE_OP_DEC_READ_CNT, &op->flags))
+		atomic_dec(&object->n_reads);
+
 	/* now... we may get called with the object spinlock held, so we
 	 * complete the cleanup here only if we can immediately acquire the
 	 * lock, and defer it otherwise */
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index e8bbc39..c5973e3 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -275,6 +275,9 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 	ASSERTCMP(object->state, >, FSCACHE_OBJECT_LOOKING_UP);
 
+	atomic_inc(&object->n_reads);
+	set_bit(FSCACHE_OP_DEC_READ_CNT, &op->op.flags);
+
 	if (fscache_submit_op(object, &op->op) < 0)
 		goto nobufs_unlock;
 	spin_unlock(&cookie->lock);
@@ -386,6 +389,9 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	object = hlist_entry(cookie->backing_objects.first,
 			     struct fscache_object, cookie_link);
 
+	atomic_inc(&object->n_reads);
+	set_bit(FSCACHE_OP_DEC_READ_CNT, &op->op.flags);
+
 	if (fscache_submit_op(object, &op->op) < 0)
 		goto nobufs_unlock;
 	spin_unlock(&cookie->lock);
diff --git a/fs/fscache/proc.c b/fs/fscache/proc.c
index beeab44..1d9e495 100644
--- a/fs/fscache/proc.c
+++ b/fs/fscache/proc.c
@@ -37,10 +37,20 @@ int __init fscache_proc_init(void)
 		goto error_histogram;
 #endif
 
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+	if (!proc_create("fs/fscache/objects", S_IFREG | 0444, NULL,
+			 &fscache_objlist_fops))
+		goto error_objects;
+#endif
+
 	_leave(" = 0");
 	return 0;
 
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+error_objects:
+#endif
 #ifdef CONFIG_FSCACHE_HISTOGRAM
+	remove_proc_entry("fs/fscache/histogram", NULL);
 error_histogram:
 #endif
 #ifdef CONFIG_FSCACHE_STATS
@@ -58,6 +68,9 @@ error_dir:
  */
 void fscache_proc_cleanup(void)
 {
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+	remove_proc_entry("fs/fscache/objects", NULL);
+#endif
 #ifdef CONFIG_FSCACHE_HISTOGRAM
 	remove_proc_entry("fs/fscache/histogram", NULL);
 #endif
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 7a9847c..184cbdf 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -91,6 +91,8 @@ struct fscache_operation {
 #define FSCACHE_OP_WAITING	4	/* cleared when op is woken */
 #define FSCACHE_OP_EXCLUSIVE	5	/* exclusive op, other ops must wait */
 #define FSCACHE_OP_DEAD		6	/* op is now dead */
+#define FSCACHE_OP_DEC_READ_CNT	7	/* decrement object->n_reads on destruction */
+#define FSCACHE_OP_KEEP_FLAGS	0xc0	/* flags to keep when repurposing an op */
 
 	atomic_t		usage;
 	unsigned		debug_id;	/* debugging ID */
@@ -357,6 +359,7 @@ struct fscache_object {
 	int			n_obj_ops;	/* number of object ops outstanding on object */
 	int			n_in_progress;	/* number of ops in progress */
 	int			n_exclusive;	/* number of exclusive ops queued */
+	atomic_t		n_reads;	/* number of read ops in progress */
 	spinlock_t		lock;		/* state and operations lock */
 
 	unsigned long		lookup_jif;	/* time at which lookup started */
@@ -370,6 +373,7 @@ struct fscache_object {
 #define FSCACHE_OBJECT_EV_RELEASE	4	/* T if netfs requested object release */
 #define FSCACHE_OBJECT_EV_RETIRE	5	/* T if netfs requested object retirement */
 #define FSCACHE_OBJECT_EV_WITHDRAW	6	/* T if cache requested object withdrawal */
+#define FSCACHE_OBJECT_EVENTS_MASK	0x7f	/* mask of all events*/
 
 	unsigned long		flags;
 #define FSCACHE_OBJECT_LOCK		0	/* T if object is busy being processed */
@@ -385,6 +389,9 @@ struct fscache_object {
 	struct list_head	dependents;	/* FIFO of dependent objects */
 	struct list_head	dep_link;	/* link in parent's dependents list */
 	struct list_head	pending_ops;	/* unstarted operations on this object */
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+	struct rb_node		objlist_link;	/* link in global object list */
+#endif
 	pgoff_t			store_limit;	/* current storage limit */
 };
 
@@ -434,6 +441,12 @@ void fscache_object_init(struct fscache_object *object,
 extern void fscache_object_lookup_negative(struct fscache_object *object);
 extern void fscache_obtained_object(struct fscache_object *object);
 
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+extern void fscache_object_destroy(struct fscache_object *object);
+#else
+#define fscache_object_destroy(object) do {} while(0)
+#endif
+
 /**
  * fscache_object_destroyed - Note destruction of an object in a cache
  * @cache: The cache from which the object came

