Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXDSFrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXDSFrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 01:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXDSFrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 01:47:13 -0400
Received: from mx12.go2.pl ([193.17.41.142]:41212 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161071AbXDSFrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 01:47:12 -0400
Date: Thu, 19 Apr 2007 07:52:48 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -mm] workqueue: debug possible lockups in flush_workqueue
Message-ID: <20070419055247.GA1782@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is my patch proposal for detecting possible lockups,
when flush_workqueue caller holds a lock (e.g. rtnl_lock)
also used in work functions.

Regards,
Jarek P.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc6-mm1-/kernel/workqueue.c 2.6.21-rc6-mm1/kernel/workqueue.c
--- 2.6.21-rc6-mm1-/kernel/workqueue.c	2007-04-18 20:07:45.000000000 +0200
+++ 2.6.21-rc6-mm1/kernel/workqueue.c	2007-04-18 21:29:50.000000000 +0200
@@ -67,6 +67,12 @@ struct workqueue_struct {
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
 static DEFINE_MUTEX(workqueue_mutex);
+
+#ifdef CONFIG_PROVE_LOCKING
+/* Detect possible flush_workqueue() lockup with circular dependency check. */
+static struct lockdep_map flush_dep_map = { .name = "flush_dep_map" };
+#endif
+
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
@@ -247,8 +253,15 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+#ifdef CONFIG_PROVE_LOCKING
+		/* lockdep dependency: flush_dep_map (read) before any lock: */
+		lock_acquire(&flush_dep_map, 0, 0, 1, 2, _THIS_IP_);
+#endif
 		f(work);
 
+#ifdef CONFIG_PROVE_LOCKING
+		lock_release(&flush_dep_map, 1, _THIS_IP_);
+#endif
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
 					"%s/0x%08x/%d\n",
@@ -389,6 +402,14 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+#ifdef CONFIG_PROVE_LOCKING
+	/*
+	 * Add lockdep dependency: flush_dep_map (exclusive)
+	 * after any held mutex or rwsem.
+	 */
+	lock_acquire(&flush_dep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&flush_dep_map, 1, _THIS_IP_);
+#endif
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
