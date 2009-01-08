Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZAHMDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZAHMDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZAHMD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:03:28 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:40373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZAHMD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:03:27 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081101155958.GA28776@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 Jan 2009 01:57:21 +0100
Message-Id: <1231376241.3545.96.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-01 at 16:59 +0100, Jörn Engel wrote:

[btree library]

Alright, back to this. I'm going to need something like the patch below
(except the update facility, which I thought I needed but then changed
my mind) which is on top of your patch. Does that look sane?

One thing that seems a little odd is requiring a btree_init(), but not
having a btree_destroy(), but rather requiring managing the mempool in
the caller (which invariably leads to two mempool pointers being
required unless callers want to look into the btree struct details)...
Do you think this is required? Could we have a btree_init/btree_destroy
instead that take care of the mempool stuff?

Another thing that I need is a visitor that deletes _some_ entries. How
can I do that? Additionally, it would be nice to be able to abort a tree
walk, when you have determined that you can't continue for whatever
reason.

johannes
---
 include/linux/btree.h |   31 +++++++++++++++++++++++++-
 lib/Kconfig           |    2 -
 lib/btree.c           |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 2 deletions(-)

--- wireless-testing.orig/lib/Kconfig	2009-01-07 22:58:29.000000000 +0100
+++ wireless-testing/lib/Kconfig	2009-01-07 22:58:32.000000000 +0100
@@ -137,7 +137,7 @@ config PLIST
 	boolean
 
 config BTREE
-	boolean
+	tristate
 
 config HAS_IOMEM
 	boolean
--- wireless-testing.orig/lib/btree.c	2009-01-07 22:58:35.000000000 +0100
+++ wireless-testing/lib/btree.c	2009-01-08 00:50:37.000000000 +0100
@@ -47,6 +47,7 @@
 #include <linux/cache.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
@@ -55,17 +56,20 @@ struct btree_geo btree_geo32 = {
 	.keylen = 1,
 	.no_pairs = NODESIZE / sizeof(long) / 2,
 };
+EXPORT_SYMBOL_GPL(btree_geo32);
 
 #define LONG_PER_U64 (64 / BITS_PER_LONG)
 struct btree_geo btree_geo64 = {
 	.keylen = LONG_PER_U64,
 	.no_pairs = NODESIZE / sizeof(long) / (1 + LONG_PER_U64),
 };
+EXPORT_SYMBOL_GPL(btree_geo64);
 
 struct btree_geo btree_geo128 = {
 	.keylen = 2 * LONG_PER_U64,
 	.no_pairs = NODESIZE / sizeof(long) / (1 + 2 * LONG_PER_U64),
 };
+EXPORT_SYMBOL_GPL(btree_geo128);
 
 static struct kmem_cache *btree_cachep;
 
@@ -73,11 +77,13 @@ void *btree_alloc(gfp_t gfp_mask, void *
 {
 	return kmem_cache_alloc(btree_cachep, gfp_mask);
 }
+EXPORT_SYMBOL_GPL(btree_alloc);
 
 void btree_free(void *element, void *pool_data)
 {
 	kmem_cache_free(btree_cachep, element);
 }
+EXPORT_SYMBOL_GPL(btree_free);
 
 static unsigned long *btree_node_alloc(struct btree_head *head)
 {
@@ -217,6 +223,7 @@ void btree_init(struct btree_head *head,
 	head->mempool = mempool;
 	head->gfp_mask = gfp;
 }
+EXPORT_SYMBOL_GPL(btree_init);
 
 unsigned long *btree_last(struct btree_head *head, struct btree_geo *geo)
 {
@@ -231,6 +238,7 @@ unsigned long *btree_last(struct btree_h
 
 	return bkey(geo, node, 0);
 }
+EXPORT_SYMBOL_GPL(btree_last);
 
 static int keycmp(struct btree_geo *geo, unsigned long *node, int pos,
 		unsigned long *key)
@@ -266,6 +274,39 @@ void *btree_lookup(struct btree_head *he
 			return (void *)bval(geo, node, i);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(btree_lookup);
+
+int btree_update(struct btree_head *head, struct btree_geo *geo,
+		 unsigned long *key, void *val)
+{
+	int i, height = head->height;
+	unsigned long *node = head->node;
+
+	if (height == 0)
+		return -ENOENT;
+
+	for ( ; height > 1; height--) {
+		for (i = 0; i < geo->no_pairs; i++)
+			if (keycmp(geo, node, i, key) <= 0)
+				break;
+		if (i == geo->no_pairs)
+			return -ENOENT;
+		node = (unsigned long *)bval(geo, node, i);
+		if (!node)
+			return -ENOENT;
+	}
+
+	if (!node)
+		return -ENOENT;
+
+	for (i = 0; i < geo->no_pairs; i++)
+		if (keycmp(geo, node, i, key) == 0) {
+			setval(geo, node, (unsigned long)val, i);
+			return 0;
+		}
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(btree_update);
 
 static int getpos(struct btree_geo *geo, unsigned long *node,
 		unsigned long *key)
@@ -417,6 +458,7 @@ int btree_insert(struct btree_head *head
 {
 	return btree_insert_level(head, geo, key, (unsigned long)val, 1);
 }
+EXPORT_SYMBOL_GPL(btree_insert);
 
 static void *btree_remove_level(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *key, int level);
@@ -527,6 +569,7 @@ void *btree_remove(struct btree_head *he
 
 	return btree_remove_level(head, geo, key, 1);
 }
+EXPORT_SYMBOL_GPL(btree_remove);
 
 int btree_merge(struct btree_head *target, struct btree_head *victim,
 		struct btree_geo *geo, unsigned long *duplicate)
@@ -560,6 +603,7 @@ int btree_merge(struct btree_head *targe
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(btree_merge);
 
 static size_t __btree_for_each(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *node, long opaque,
@@ -598,6 +642,7 @@ void visitorl(void *elem, long opaque, u
 
 	func(elem, opaque, *key, index);
 }
+EXPORT_SYMBOL_GPL(visitorl);
 
 void visitor32(void *elem, long opaque, unsigned long *__key, size_t index,
 		void *__func)
@@ -607,6 +652,7 @@ void visitor32(void *elem, long opaque, 
 
 	func(elem, opaque, *key, index);
 }
+EXPORT_SYMBOL_GPL(visitor32);
 
 void visitor64(void *elem, long opaque, unsigned long *__key, size_t index,
 		void *__func)
@@ -616,6 +662,7 @@ void visitor64(void *elem, long opaque, 
 
 	func(elem, opaque, *key, index);
 }
+EXPORT_SYMBOL_GPL(visitor64);
 
 void visitor128(void *elem, long opaque, unsigned long *__key, size_t index,
 		void *__func)
@@ -625,6 +672,7 @@ void visitor128(void *elem, long opaque,
 
 	func(elem, opaque, key[0], key[1], index);
 }
+EXPORT_SYMBOL_GPL(visitor128);
 
 size_t btree_visitor(struct btree_head *head, struct btree_geo *geo,
 		long opaque,
@@ -640,6 +688,7 @@ size_t btree_visitor(struct btree_head *
 				func2, 0, head->height, 0);
 	return count;
 }
+EXPORT_SYMBOL_GPL(btree_visitor);
 
 size_t btree_grim_visitor(struct btree_head *head, struct btree_geo *geo,
 		long opaque,
@@ -656,6 +705,7 @@ size_t btree_grim_visitor(struct btree_h
 	__btree_init(head);
 	return count;
 }
+EXPORT_SYMBOL_GPL(btree_grim_visitor);
 
 static int __init btree_module_init(void)
 {
@@ -664,5 +714,14 @@ static int __init btree_module_init(void
 	return 0;
 }
 
+static void __exit btree_module_exit(void)
+{
+	kmem_cache_destroy(btree_cachep);
+}
+
 /* If core code starts using btree, initialization should happen even earlier */
 module_init(btree_module_init);
+module_exit(btree_module_exit);
+
+MODULE_AUTHOR("Joern Engel <joern@logfs.org>");
+MODULE_LICENSE("GPL");
--- wireless-testing.orig/include/linux/btree.h	2009-01-07 23:16:54.000000000 +0100
+++ wireless-testing/include/linux/btree.h	2009-01-08 00:48:29.000000000 +0100
@@ -43,6 +43,8 @@ void *btree_lookup(struct btree_head *he
 		unsigned long *key);
 int btree_insert(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *key, void *val);
+int btree_update(struct btree_head *head, struct btree_geo *geo,
+		 unsigned long *key, void *val);
 void *btree_remove(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *key);
 int btree_merge(struct btree_head *target, struct btree_head *victim,
@@ -75,6 +77,12 @@ static inline int btree_insertl(struct b
 	return btree_insert(&head->h, &btree_geo32, &key, val);
 }
 
+static inline int btree_updatel(struct btree_headl *head, unsigned long key,
+		void *val)
+{
+	return btree_update(&head->h, &btree_geo32, &key, val);
+}
+
 static inline void *btree_removel(struct btree_headl *head, unsigned long key)
 {
 	return btree_remove(&head->h, &btree_geo32, &key);
@@ -124,6 +132,12 @@ static inline int btree_insert32(struct 
 	return btree_insert(&head->h, &btree_geo32, (unsigned long *)&key, val);
 }
 
+static inline int btree_update32(struct btree_head32 *head, u32 key,
+		void *val)
+{
+	return btree_update(&head->h, &btree_geo32, (unsigned long *)&key, val);
+}
+
 static inline void *btree_remove32(struct btree_head32 *head, u32 key)
 {
 	return btree_remove(&head->h, &btree_geo32, (unsigned long *)&key);
@@ -172,6 +186,12 @@ static inline int btree_insert64(struct 
 	return btree_insert(&head->h, &btree_geo64, (unsigned long *)&key, val);
 }
 
+static inline int btree_update64(struct btree_head64 *head, u64 key,
+		void *val)
+{
+	return btree_update(&head->h, &btree_geo64, (unsigned long *)&key, val);
+}
+
 static inline void *btree_remove64(struct btree_head64 *head, u64 key)
 {
 	return btree_remove(&head->h, &btree_geo64, (unsigned long *)&key);
@@ -220,7 +240,16 @@ static inline int btree_insert128(struct
 		void *val)
 {
 	u64 key[2] = {k1, k2};
-	return btree_insert(&head->h, &btree_geo128, (unsigned long *)&key, val);
+	return btree_insert(&head->h, &btree_geo128,
+			    (unsigned long *)&key, val);
+}
+
+static inline int btree_update128(struct btree_head128 *head, u64 k1, u64 k2,
+		void *val)
+{
+	u64 key[2] = {k1, k2};
+	return btree_update(&head->h, &btree_geo128,
+			    (unsigned long *)&key, val);
 }
 
 static inline void *btree_remove128(struct btree_head128 *head, u64 k1, u64 k2)


