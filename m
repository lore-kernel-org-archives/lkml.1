Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbZDCIOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbZDCIOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbZDCIOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:14:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47420 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZDCIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:14:18 -0400
Date: Fri, 3 Apr 2009 17:12:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 4/9] soft limit queue and priority
Message-Id: <20090403171248.df3e1b03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Softlimitq. for memcg.

Implements an array of queue to list memcgs, array index is determined by
the amount of memory usage excess the soft limit.

While Balbir's one uses RB-tree and my old one used a per-zone queue
(with round-robin), this is one of mixture of them.
(I'd like to use rotation of queue in later patches)

Priority is determined by following.
   Assume unit = total pages/1024. (the code uses different value)
   if excess is...
      < unit,          priority = 0, 
      < unit*2,        priority = 1,
      < unit*2*2,      priority = 2,
      ...
      < unit*2^9,      priority = 9,
      < unit*2^10,     priority = 10, (> 50% to total mem)

This patch just includes queue management part and not includes 
selection logic from queue. Some trick will be used for selecting victims at
soft limit in efficient way.

And this equips 2 queues, for anon and file. Inset/Delete of both list is
done at once but scan will be independent. (These 2 queues are used later.)

Major difference from Balbir's one other than RB-tree is bahavior under
hierarchy. This one adds all children to queue by checking hierarchical
priority. This is for helping per-zone usage check on victim-selection logic.

Changelog: v1->v2
 - fixed comments.
 - change base size to exponent.
 - some micro optimization to reduce code size.
 - considering memory hotplug, it's not good to record a value calculated
   from totalram_pages at boot and using it later is bad manner. Fixed it.
 - removed soft_limit_lock (spinlock) 
 - added soft_limit_update counter for avoiding mulptiple update at once.
   

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 117 insertions(+), 1 deletion(-)

Index: softlimit-test2/mm/memcontrol.c
===================================================================
--- softlimit-test2.orig/mm/memcontrol.c
+++ softlimit-test2/mm/memcontrol.c
@@ -192,7 +192,14 @@ struct mem_cgroup {
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
-
+	/*
+	 * For soft limit.
+	 */
+	int soft_limit_priority;
+	struct list_head soft_limit_list[2];
+#define SL_ANON (0)
+#define SL_FILE (1)
+	atomic_t soft_limit_update;
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -938,11 +945,115 @@ static bool mem_cgroup_soft_limit_check(
 	return ret;
 }
 
+/*
+ * Assume "base_amount", and excess = usage - soft limit.
+ *
+ * 0...... if excess < base_amount
+ * 1...... if excess < base_amount * 2
+ * 2...... if excess < base_amount * 2^2
+ * 3.......if excess < base_amount * 2^3
+ * ....
+ * 9.......if excess < base_amount * 2^9
+ * 10 .....if excess < base_amount * 2^10
+ *
+ * base_amount is detemined from total pages in the system.
+ */
+
+#define SLQ_MAXPRIO (11)
+static struct {
+	spinlock_t lock;
+	struct list_head queue[SLQ_MAXPRIO][2]; /* 0:anon 1:file */
+} softlimitq;
+
+#define SLQ_PRIO_FACTOR (1024) /* 2^10 */
+
+static int __calc_soft_limit_prio(unsigned long excess)
+{
+	unsigned long factor = totalram_pages /SLQ_PRIO_FACTOR;
+
+	return fls(excess/factor);
+}
+
+static int mem_cgroup_soft_limit_prio(struct mem_cgroup *mem)
+{
+	unsigned long excess, max_excess = 0;
+	struct res_counter *c = &mem->res;
+
+	do {
+		excess = res_counter_soft_limit_excess(c) >> PAGE_SHIFT;
+		if (max_excess < excess)
+			max_excess = excess;
+		c = c->parent;
+	} while (c);
+
+	return __calc_soft_limit_prio(max_excess);
+}
+
+static void __mem_cgroup_requeue(struct mem_cgroup *mem, int prio)
+{
+	/* enqueue to softlimit queue */
+	int i;
+
+	spin_lock(&softlimitq.lock);
+	if (prio != mem->soft_limit_priority) {
+		mem->soft_limit_priority = prio;
+		for (i = 0; i < 2; i++) {
+			list_del_init(&mem->soft_limit_list[i]);
+			list_add_tail(&mem->soft_limit_list[i],
+				      &softlimitq.queue[prio][i]);
+		}
+	}
+	spin_unlock(&softlimitq.lock);
+}
+
+static void __mem_cgroup_dequeue(struct mem_cgroup *mem)
+{
+	int i;
+
+	spin_lock(&softlimitq.lock);
+	for (i = 0; i < 2; i++)
+		list_del_init(&mem->soft_limit_list[i]);
+	spin_unlock(&softlimitq.lock);
+}
+
+static int
+__mem_cgroup_update_soft_limit_cb(struct mem_cgroup *mem, void *data)
+{
+	int priority;
+	/* If someone updates, we don't need more */
+	priority = mem_cgroup_soft_limit_prio(mem);
+
+	if (priority != mem->soft_limit_priority)
+		__mem_cgroup_requeue(mem, priority);
+	return 0;
+}
+
 static void mem_cgroup_update_soft_limit(struct mem_cgroup *mem)
 {
+	int priority;
+
+	/* check status change */
+	priority = mem_cgroup_soft_limit_prio(mem);
+	if (priority != mem->soft_limit_priority &&
+	    atomic_inc_return(&mem->soft_limit_update) > 1) {
+		mem_cgroup_walk_tree(mem, NULL,
+				     __mem_cgroup_update_soft_limit_cb);
+		atomic_set(&mem->soft_limit_update, 0);
+	}
 	return;
 }
 
+static void softlimitq_init(void)
+{
+	int i;
+
+	spin_lock_init(&softlimitq.lock);
+	for (i = 0; i < SLQ_MAXPRIO; i++) {
+		INIT_LIST_HEAD(&softlimitq.queue[i][SL_ANON]);
+		INIT_LIST_HEAD(&softlimitq.queue[i][SL_FILE]);
+	}
+}
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -2512,6 +2623,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (cont->parent == NULL) {
 		enable_swap_cgroup();
 		parent = NULL;
+		softlimitq_init();
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
@@ -2532,6 +2644,9 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
+	mem->soft_limit_priority = 0;
+	INIT_LIST_HEAD(&mem->soft_limit_list[SL_ANON]);
+	INIT_LIST_HEAD(&mem->soft_limit_list[SL_FILE]);
 	spin_lock_init(&mem->reclaim_param_lock);
 
 	if (parent)
@@ -2556,6 +2671,7 @@ static void mem_cgroup_destroy(struct cg
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
 
+	__mem_cgroup_dequeue(mem);
 	mem_cgroup_put(mem);
 }
 

