Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbZCCNrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbZCCNrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZCCNqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:46:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZCCNqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:46:16 -0500
Message-ID: <49AD3448.6050105@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:40 +0800
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
Subject: [PATCH -mm 5/6] slqb: introduce __kfree_rcu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce __kfree_rcu() for kfree_rcu()

It like __kfree_rcu() in slab.c, slub.c
We can calculate the object poiter from a poiter inside this
object in slqb.c, so we can use it for rcu callback and free
the object.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slqb.c b/mm/slqb.c
index 48bdf3b..c258ddc 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -2482,6 +2484,23 @@ void kfree(const void *object)
 }
 EXPORT_SYMBOL(kfree);
 
+static void kfree_rcu_callback(struct rcu_head *rcu)
+{
+	void *portion = rcu;
+	struct slqb_page *page = virt_to_head_slqb_page(portion);
+	struct kmem_cache *s = page->list->cache;
+	unsigned int index = (portion - page->s_mem) / s->size;
+	void *object = page->s_mem + s->size * index;
+
+	slab_free(s, page, object);
+}
+
+void __kfree_rcu(const void *objp, struct rcu_head *rcu)
+{
+	call_rcu(rcu, kfree_rcu_callback);
+}
+EXPORT_SYMBOL(__kfree_rcu);
+
 static void kmem_cache_trim_percpu(void *arg)
 {
 	int cpu = smp_processor_id();





