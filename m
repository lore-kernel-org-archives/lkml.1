Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZCCNq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZCCNq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZCCNqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:46:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52459 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbZCCNqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:46:07 -0500
Message-ID: <49AD343E.6010903@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:30 +0800
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
Subject: [PATCH -mm 3/6] slub: introduce __kfree_rcu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce __kfree_rcu() for kfree_rcu()

It like __kfree_rcu() in slab.c.
We can calculate the object poiter from a poiter inside this
object in slub.c, so we can use it for rcu callback and free
the object.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slub.c b/mm/slub.c
index 0280eee..b438ec5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2756,6 +2756,30 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+static void kfree_rcu_callback(struct rcu_head *rcu)
+{
+	void *portion = rcu;
+	struct page *page = virt_to_head_page(portion);
+
+	if (unlikely(!PageSlab(page))) {
+		BUG_ON(!PageCompound(page));
+		put_page(page);
+	} else {
+		struct kmem_cache *s = page->slab;
+		void *start = page_address(page);
+		unsigned int index = (portion - start) / s->size;
+		void *object = start + s->size * index;
+
+		slab_free(s, page, object, _RET_IP_);
+	}
+}
+
+void __kfree_rcu(const void *x, struct rcu_head *rcu)
+{
+	call_rcu(rcu, kfree_rcu_callback);
+}
+EXPORT_SYMBOL(__kfree_rcu);
+
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
  * the remaining slabs by the number of items in use. The slabs with the










