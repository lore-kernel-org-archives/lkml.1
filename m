Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZBBMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZBBMgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZBBMf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:35:57 -0500
Received: from ozlabs.org ([203.10.76.45]:44080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbZBBMf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:35:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Mon, 2 Feb 2009 23:05:50 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901310829.17099.rusty@rustcorp.com.au> <20090130141744.007fe725.akpm@linux-foundation.org>
In-Reply-To: <20090130141744.007fe725.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902022305.51344.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009 08:47:44 Andrew Morton wrote:
> Just as an example, take a look at allocate_threshold_blocks().  That
> function way down in the innards of x86 has blotted out large amounts of
> kernel code, so that code can now not use work_on_cpu().  Anything which
> happens inside ext3 commit (the entire block layer and all drivers
> underneath it).  Large lumps of networking code.  Parts of the page
> allocator and the VFS which I haven't started to think about yet.

Yes, you're right.  Any infrastructure which does callouts holding a lock
has the same problem.  We have several of those, as I pointed out, but the
problem comes when invoking any two; more likely when they're general.

And I did so much under work_on_cpu here (Mike is credited, but it looks like
my work) precisely because I have no idea what this code is doing, so chose
the simplest conversion.

AFAICT, it just wants to rdmsr on a particular CPU.  rdmsr_on_cpu() is pretty
easy to implement which would fix *this* case (and IIRC, would be useful
elsewhere)

If we want a general work_on_cpu(), we need this:

Subject: work_on_cpu: __work_on_cpu and singlethread work_on_cpu

Andrew Morton points out two problems with the current work_on_cpu
implementation.  Firstly, it adds a thread per cpu, which is wasteful.
Secondly, by holding a lock across a generic callback, it creates more
potential for lock inversion: any lock grabbed by the callback is a
lock which another unrelated caller to work_on_cpu() can't hold.

(A similar issue has plagued kevent).

This patch does two things: firstly, it changes to a singlethread
workqueue which simply moves itself to the appropriate CPU.  Secondly,
it adds an __work_on_cpu() for callbacks which need to grab locks:
this allows them to use their own independent workqueue.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/workqueue.h |    7 +++++
 kernel/workqueue.c        |   59 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -257,7 +257,14 @@ static inline long work_on_cpu(unsigned 
 {
 	return fn(arg);
 }
+static inline long __work_on_cpu(struct workqueue_struct *swq,
+				 unsigned cpu, long (*fn)(void *), void *arg)
+{
+	return fn(arg);
+}
 #else
+long __work_on_cpu(struct workqueue_struct *swq,
+		   unsigned int cpu, long (*fn)(void *), void *arg);
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
 #endif /* CONFIG_SMP */
 #endif
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -977,6 +977,7 @@ struct work_for_cpu {
 	struct work_struct work;
 	long (*fn)(void *);
 	void *arg;
+	unsigned int cpu;
 	long ret;
 };
 
@@ -984,8 +985,48 @@ static void do_work_for_cpu(struct work_
 {
 	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
 
+	if (set_cpus_allowed_ptr(current, cpumask_of(wfc->cpu)) != 0)
+		WARN(1, "work_on_cpu on offline cpu %u?\n", wfc->cpu);
 	wfc->ret = wfc->fn(wfc->arg);
 }
+
+
+/**
+ * __work_on_cpu - run a function in a workqueue on a particular cpu
+ * @swq: the (singlethreaded) workqueue
+ * @cpu: the cpu to run on
+ * @fn: the function to run
+ * @arg: the function arg
+ *
+ * This will return the value @fn returns.
+ * It is up to the caller to ensure that the cpu doesn't go offline.
+ *
+ * Example:
+ *	int ret;
+ *	struct workqueue_struct *wq = create_singlethread_workqueue("myq");
+ *	if (unlikely(!wq))
+ *		ret = -ENOMEM;
+ *	else {
+ *		ret = __work_on_cpu(wq, cpu, fn, arg);
+ *		destroy_workqueue(wq);
+ *	}
+ */
+long __work_on_cpu(struct workqueue_struct *swq,
+		   unsigned int cpu, long (*fn)(void *), void *arg)
+{
+	struct work_for_cpu wfc;
+
+	INIT_WORK(&wfc.work, do_work_for_cpu);
+	wfc.fn = fn;
+	wfc.arg = arg;
+	wfc.cpu = cpu;
+	BUG_ON(!swq->singlethread);
+	queue_work(swq, &wfc.work);
+	flush_work(&wfc.work);
+
+	return wfc.ret;
+}
+EXPORT_SYMBOL_GPL(__work_on_cpu);
 
 /**
  * work_on_cpu - run a function in user context on a particular cpu
@@ -995,18 +1036,16 @@ static void do_work_for_cpu(struct work_
  *
  * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
+ *
+ * @fn is called with a lock held (the work_on_cpu workqueue's lock):
+ * if it grabs any externally-visible locks, you might get a locking
+ * inversion against others who grab those locks then call
+ * work_on_cpu().  You can use your own private workqueue to avoid
+ * this.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct work_for_cpu wfc;
-
-	INIT_WORK(&wfc.work, do_work_for_cpu);
-	wfc.fn = fn;
-	wfc.arg = arg;
-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
-	flush_work(&wfc.work);
-
-	return wfc.ret;
+	return __work_on_cpu(work_on_cpu_wq, cpu, fn, arg);
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
 #endif /* CONFIG_SMP */
@@ -1022,7 +1061,7 @@ void __init init_workqueues(void)
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
 #ifdef CONFIG_SMP
-	work_on_cpu_wq = create_workqueue("work_on_cpu");
+	work_on_cpu_wq = create_singlethread_workqueue("work_on_cpu");
 	BUG_ON(!work_on_cpu_wq);
 #endif
 }

