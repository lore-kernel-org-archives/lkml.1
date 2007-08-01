Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXHAJHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXHAJHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXHAJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:07:13 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:50691 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbXHAJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:07:11 -0400
To: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [RFC PATCH] type safe allocator
Message-Id: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 11:06:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder why we don't have type safe object allocators a-la new() in
C++ or g_new() in glib?

  fooptr = k_new(struct foo, GFP_KERNEL);

is nicer and more descriptive than

  fooptr = kmalloc(sizeof(*fooptr), GFP_KERNEL);

and more safe than

  fooptr = kmalloc(sizeof(struct foo), GFP_KERNEL);

And we have zillions of both variants.

Note, I'm not advocating mass replacement, but using this in new code,
and gradually converting old ones whenever they need touching anyway.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux-2.6.22/include/linux/slab.h
===================================================================
--- linux-2.6.22.orig/include/linux/slab.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/include/linux/slab.h	2007-08-01 10:42:45.000000000 +0200
@@ -110,6 +110,38 @@ static inline void *kcalloc(size_t n, si
 	return __kzalloc(n * size, flags);
 }
 
+/**
+ * k_new - allocate given type object
+ * @type: the type of the object to allocate
+ * @flags: the type of memory to allocate.
+ */
+#define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))
+
+/**
+ * k_new0 - allocate given type object, zero out allocated space
+ * @type: the type of the object to allocate
+ * @flags: the type of memory to allocate.
+ */
+#define k_new0(type, flags) ((type *) kzalloc(sizeof(type), flags))
+
+/**
+ * k_new_array - allocate array of given type object
+ * @type: the type of the object to allocate
+ * @len: the length of the array
+ * @flags: the type of memory to allocate.
+ */
+#define k_new_array(type, len, flags) \
+	((type *) kmalloc(sizeof(type) * (len), flags))
+
+/**
+ * k_new0_array - allocate array of given type object, zero out allocated space
+ * @type: the type of the object to allocate
+ * @len: the length of the array
+ * @flags: the type of memory to allocate.
+ */
+#define k_new0_array(type, len, flags) \
+	((type *) kzalloc(sizeof(type) * (len), flags))
+
 /*
  * Allocator specific definitions. These are mainly used to establish optimized
  * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by selecting
