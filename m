Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZCCNql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZCCNql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZCCNqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:46:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZCCNqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:46:04 -0500
Message-ID: <49AD3439.4000602@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:25 +0800
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
Subject: [PATCH -mm 2/6] slob: introduce __kfree_rcu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce __kfree_rcu() for kfree_rcu()

The object pointer is stored in head->func instead of the
function pointer, and these rcu head(which are the same batch)
are queued in a list. When a batch's grace period is completed,
the objects in this batch are freed, and then we proccess the
next batch(if next batch not empty).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slob.c b/mm/slob.c
index 52bc8a2..e703295 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -618,6 +618,57 @@ unsigned int kmem_cache_size(struct kmem_cache *c)
 }
 EXPORT_SYMBOL(kmem_cache_size);
 
+static DEFINE_SPINLOCK(kfree_rcu_lock);
+static struct rcu_head kfree_rcu_head;
+static struct rcu_head *curr_head;
+static struct rcu_head *next_head, **next_tail = &next_head;
+static void kfree_rcu_advance_batch(void);
+
+static void kfree_rcu_batch_callback(struct rcu_head *unused)
+{
+	unsigned long flags;
+	struct rcu_head *list;
+
+	spin_lock_irqsave(&kfree_rcu_lock, flags);
+	list = curr_head;
+	curr_head = NULL;
+	kfree_rcu_advance_batch();
+	spin_unlock_irqrestore(&kfree_rcu_lock, flags);
+
+	while (list) {
+		struct rcu_head *next = list->next;
+		prefetch(next);
+		kfree((void *)(unsigned long)list->func);
+		list = next;
+	}
+}
+
+static void kfree_rcu_advance_batch(void)
+{
+	if (!curr_head && next_head) {
+		curr_head = next_head;
+		next_head = NULL;
+		next_tail = &next_head;
+
+		call_rcu(&kfree_rcu_head, kfree_rcu_batch_callback);
+	}
+}
+
+void __kfree_rcu(const void *obj, struct rcu_head *rcu)
+{
+	unsigned long flags;
+
+	rcu->func = (typeof(rcu->func))(unsigned long)obj;
+	rcu->next = NULL;
+
+	spin_lock_irqsave(&kfree_rcu_lock, flags);
+	*next_tail = rcu;
+	next_tail = &rcu->next;
+	kfree_rcu_advance_batch();
+	spin_unlock_irqrestore(&kfree_rcu_lock, flags);
+}
+EXPORT_SYMBOL(__kfree_rcu);
+
 const char *kmem_cache_name(struct kmem_cache *c)
 {
 	return c->name;







