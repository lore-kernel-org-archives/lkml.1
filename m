Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXENFwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXENFwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 01:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXENFwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 01:52:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbXENFwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 01:52:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Mon, 14 May 2007 07:57:32 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <200705132132.08546.rjw@sisk.pl> <200705132322.10032.rjw@sisk.pl> <20070513213424.GA3198@tv-sign.ru>
In-Reply-To: <20070513213424.GA3198@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705140757.33746.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 23:34, Oleg Nesterov wrote:
> On 05/13, Rafael J. Wysocki wrote:
> >
[--snip--]
> 
> > @@ -819,20 +843,31 @@ static int __devinit workqueue_cpu_callb
> >  
> > +
> > +		case CPU_DEAD_FROZEN:
> > +			if (wq->freezeable) {
> > +				take_over_work(wq, cpu);
> > +				thaw_process(cwq->thread);
> 
> Suppose that PF_NOFREEZE task T does flush_workqueue(), and CPU 1 has pending
> works. T does flush_cpu_workqueue(0), CPU_DEAD_FROZEN moves works from CPU 1
> to CPU 0, T does flush_cpu_workqueue(1) and finds nothing.

I think I have solved this particular problem without any locking:

Define an atomic field in workqueue_struct (let's call it 'switch'), initially
equal to 0.  Whenever work is taken from an offlined CPU, take_over_work()
increases 'switch' by 1.  In turn, flush_workqueue() reads 'switch' before
looping over CPUs and saves its value in a local variable.  On exit, it
compares the current value of 'switch' with the saved one and if they differ,
it repeats the loop over CPUs.

Updated patch follows.

Rafael

---
 kernel/workqueue.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc1/kernel/workqueue.c
===================================================================
--- linux-2.6.22-rc1.orig/kernel/workqueue.c
+++ linux-2.6.22-rc1/kernel/workqueue.c
@@ -62,6 +62,9 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+	atomic_t work_sw;	/* Used to indicate that some work has been
+				 * moved from one CPU to another
+				 */
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -381,10 +384,15 @@ void fastcall flush_workqueue(struct wor
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
+	int val;
 
 	might_sleep();
+ start:
+	val = atomic_read(&wq->work_sw);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+	if (unlikely(val != atomic_read(&wq->work_sw)))
+		goto start;
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -710,6 +718,7 @@ struct workqueue_struct *__create_workqu
 	wq->name = name;
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
+	atomic_set(&wq->work_sw, 0);
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
@@ -791,6 +800,40 @@ void destroy_workqueue(struct workqueue_
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
+/**
+ * take_over_work - if the workqueue is freezable and CPUs are being taken down
+ * due to a hibernation/suspend, we need to take the work out of their worker
+ * threads, because they might need to use some devices to do the work and
+ * the devices are suspended at this point.
+ * @wq: target workqueue
+ * @cpu: CPU being offlined
+ */
+static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
+{
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct list_head list;
+	struct work_struct *work;
+
+	spin_lock_irq(&cwq->lock);
+	list_replace_init(&cwq->worklist, &list);
+
+	if (!list_empty(&list)) {
+		/*
+		 * Tell flush_workqueue() that it should repeat the loop over
+		 * CPUs
+		 */
+		atomic_inc(&wq->work_sw);
+		while (!list_empty(&list)) {
+			printk("Taking work for %s\n", wq->name);
+			work = list_entry(list.next, struct work_struct, entry);
+			list_del(&work->entry);
+			__queue_work(per_cpu_ptr(wq->cpu_wq,
+					smp_processor_id()), work);
+		}
+	}
+	spin_unlock_irq(&cwq->lock);
+}
+
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
@@ -799,9 +842,7 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
-	action &= ~CPU_TASKS_FROZEN;
-
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
 		return NOTIFY_OK;
@@ -819,20 +860,31 @@ static int __devinit workqueue_cpu_callb
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+		case CPU_UP_PREPARE_FROZEN:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue for %i failed\n", cpu);
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			start_workqueue_thread(cwq, cpu);
 			break;
 
 		case CPU_UP_CANCELED:
+		case CPU_UP_CANCELED_FROZEN:
 			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
+
+		case CPU_DEAD_FROZEN:
+			if (wq->freezeable) {
+				take_over_work(wq, cpu);
+				thaw_process(cwq->thread);
+			}
+			cleanup_workqueue_thread(cwq, cpu);
+			break;
 		}
 	}
 
