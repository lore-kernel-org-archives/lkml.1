Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZBQToj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZBQToj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZBQTn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:43:57 -0500
Received: from cmpxchg.org ([85.214.51.133]:38475 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbZBQTn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:43:56 -0500
Message-Id: <20090217184135.747921027@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: [patch 1/7] slab: introduce kzfree()
References: <20090217182615.897042724@cmpxchg.org>
Content-Disposition: inline; filename=slab-introduce-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzfree() is a wrapper for kfree() that additionally zeroes the
underlying memory before releasing it to the slab allocator.

Currently there is code which memset()s the memory region of an object
before releasing it back to the slab allocator to make sure
security-sensitive data are really zeroed out after use.

These callsites can then just use kzfree() which saves some code,
makes users greppable and allows for a stupid destructor that isn't
necessarily aware of the actual object size.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 include/linux/slab.h |    1 +
 mm/util.c            |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -127,6 +127,7 @@ int kmem_ptr_validate(struct kmem_cache 
 void * __must_check __krealloc(const void *, size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
+void kzfree(const void *);
 size_t ksize(const void *);
 
 /*
--- a/mm/util.c
+++ b/mm/util.c
@@ -129,6 +129,26 @@ void *krealloc(const void *p, size_t new
 }
 EXPORT_SYMBOL(krealloc);
 
+/**
+ * kzfree - like kfree but zero memory
+ * @p: object to free memory of
+ *
+ * The memory of the object @p points to is zeroed before freed.
+ * If @p is %NULL, kzfree() does nothing.
+ */
+void kzfree(const void *p)
+{
+	size_t ks;
+	void *mem = (void *)p;
+
+	if (unlikely(ZERO_OR_NULL_PTR(mem)))
+		return;
+	ks = ksize(mem);
+	memset(mem, 0, ks);
+	kfree(mem);
+}
+EXPORT_SYMBOL(kzfree);
+
 /*
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate


