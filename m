Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZLBHz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZLBHz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 02:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZLBHz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 02:55:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:40956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbZLBHzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 02:55:55 -0500
Message-ID: <4B161D7A.6040208@kernel.org>
Date: Wed, 02 Dec 2009 16:55:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, michal.simek@petalogix.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au> <4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au> <4B152D22.9070001@kernel.org> <alpine.DEB.2.00.0912010946340.8841@router.home> <20091201160119.GA10826@elte.hu> <4B15A5A6.2090200@kernel.org>
In-Reply-To: <4B15A5A6.2090200@kernel.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It will look like the following.

Thanks.

=========================================================================
Subject: workqueue: update cwq alignement

work->data field is used for two purposes.  It points to cwq it's
queued on and the lower bits are used for flags.  Currently, two bits
are reserved which is always safe as 4 byte alignment is guaranteed on
every architecture.  However, future changes will need more flag bits.

On SMP, the percpu allocator is capable of honoring larger alignment
(there are other users which depend on it) and larger alignment works
just fine.  On UP, percpu allocator is a thin wrapper around
kzalloc/kfree() and don't honor alignment request.

This patch introduces WORK_STRUCT_FLAG_BITS, aligns cwqs accordingly
and implements alloc/free_cwqs() which guarantees the alignment both
on SMP and UP.  On SMP, simply wrapping percpu allocator is enouhg.
On UP, extra space is allocated so that cwq can be aligned and the
original pointer can be stored after it which is used in the free
path.

While at it, as cwqs are now forced aligned, make sure the resulting
alignment is at least equal to or larger than that of long long.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/workqueue.h |    4 ++-
 kernel/workqueue.c        |   58 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 6 deletions(-)

Index: work/include/linux/workqueue.h
===================================================================
--- work.orig/include/linux/workqueue.h
+++ work/include/linux/workqueue.h
@@ -29,7 +29,9 @@ enum {
 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
 	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
 
-	WORK_STRUCT_FLAG_MASK	= 3UL,
+	WORK_STRUCT_FLAG_BITS	= 2,
+
+	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
 };
 
Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -46,7 +46,9 @@
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).
+ * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
+ * work_struct->data are used for flags and thus cwqs need to be
+ * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
 
@@ -58,7 +60,7 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	struct task_struct	*thread;
-} ____cacheline_aligned;
+} __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
  * The externally visible workqueue abstraction is an array of
@@ -932,6 +934,44 @@ int current_is_keventd(void)
 
 }
 
+static struct cpu_workqueue_struct *alloc_cwqs(void)
+{
+	const size_t size = sizeof(struct cpu_workqueue_struct);
+	const size_t align = __alignof__(struct cpu_workqueue_struct);
+	struct cpu_workqueue_struct *cwqs;
+#ifndef CONFIG_SMP
+	void *ptr;
+
+	/*
+	 * On UP, percpu allocator doesn't honor alignment parameter
+	 * and simply uses arch-dependent default.  Allocate enough
+	 * room to align cwq and put an extra pointer at the end
+	 * pointing back to the originally allocated pointer which
+	 * will be used for free.
+	 */
+	ptr = __alloc_percpu(size + align + sizeof(void *), 1);
+	cwqs = PTR_ALIGN(ptr, align);
+	*(void **)per_cpu_ptr(cwqs + 1, 0) = ptr;
+#else
+	/* On SMP, percpu allocator can do it itself */
+	cwqs = __alloc_percpu(size, align);
+#endif
+	/* just in case, make sure it's actually aligned */
+	BUG_ON(!IS_ALIGNED((unsigned long)cwqs, align));
+	return cwqs;
+}
+
+static void free_cwqs(struct cpu_workqueue_struct *cwqs)
+{
+#ifndef CONFIG_SMP
+	/* on UP, the pointer to free is stored right after the cwq */
+	if (cwqs)
+		free_percpu(*(void **)per_cpu_ptr(cwqs + 1, 0));
+#else
+	free_percpu(cwqs);
+#endif
+}
+
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct workqueue_struct *wq = cwq->wq;
@@ -977,7 +1017,7 @@ struct workqueue_struct *__create_workqu
 	if (!wq)
 		goto err;
 
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	wq->cpu_wq = alloc_cwqs();
 	if (!wq->cpu_wq)
 		goto err;
 
@@ -1023,7 +1063,7 @@ struct workqueue_struct *__create_workqu
 	return wq;
 err:
 	if (wq) {
-		free_percpu(wq->cpu_wq);
+		free_cwqs(wq->cpu_wq);
 		kfree(wq);
 	}
 	return NULL;
@@ -1074,7 +1114,7 @@ void destroy_workqueue(struct workqueue_
 	for_each_possible_cpu(cpu)
 		cleanup_workqueue_thread(get_cwq(cpu, wq));
 
-	free_percpu(wq->cpu_wq);
+	free_cwqs(wq->cpu_wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
@@ -1163,6 +1203,14 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
+	/*
+	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
+	 * Make sure that the alignment isn't lower than that of
+	 * unsigned long long.
+	 */
+	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
+		     __alignof__(unsigned long long));
+
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
