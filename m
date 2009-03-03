Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZCCNq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZCCNq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZCCNp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:45:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZCCNp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:45:56 -0500
Message-ID: <49AD3433.9000001@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/6] slab: introduce __kfree_rcu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce __kfree_rcu() for kfree_rcu()

We can calculate the object poiter from a poiter inside this
object in slab.c, so we can use a portion_to_obj() to instead
various container_of() for rcu callback and free the object.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slab.c b/mm/slab.c
index 4d00855..a067d3f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -634,6 +634,17 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
+static inline void *portion_to_obj(void *portion)
+{
+	struct page *page = virt_to_head_page(portion);
+	struct slab *slab = page_get_slab(page);
+	struct kmem_cache *cache = page_get_cache(page);
+	unsigned int offset = portion - slab->s_mem;
+	unsigned int index = offset / cache->buffer_size;
+
+	return index_to_obj(cache, slab, index);
+}
+
 /*
  * These are the default caches for kmalloc. Custom caches can have other sizes.
  */
@@ -3728,6 +3739,17 @@ void kfree(const void *objp)
 }
 EXPORT_SYMBOL(kfree);
 
+static void kfree_rcu_callback(struct rcu_head *rcu)
+{
+	kfree(portion_to_obj(rcu));
+}
+
+void __kfree_rcu(const void *objp, struct rcu_head *rcu)
+{
+	call_rcu(rcu, kfree_rcu_callback);
+}
+EXPORT_SYMBOL(__kfree_rcu);
+
 unsigned int kmem_cache_size(struct kmem_cache *cachep)
 {
 	return obj_size(cachep);









