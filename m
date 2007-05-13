Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXEMVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXEMVRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXEMVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:17:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbXEMVRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:17:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Sun, 13 May 2007 23:22:09 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <200705132132.08546.rjw@sisk.pl> <200705132250.26277.rjw@sisk.pl> <20070513205057.GA3171@tv-sign.ru>
In-Reply-To: <20070513205057.GA3171@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132322.10032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 22:50, Oleg Nesterov wrote:
> On 05/13, Rafael J. Wysocki wrote:
> >
> > On Sunday, 13 May 2007 22:30, Oleg Nesterov wrote:
> > > > 
> > > > > --- linux-2.6.22-rc1.orig/kernel/workqueue.c
> > > > > +++ linux-2.6.22-rc1/kernel/workqueue.c
> > > > > @@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
> > > > >  	struct cpu_workqueue_struct *cwq;
> > > > >  	struct workqueue_struct *wq;
> > > > >  
> > > > > -	action &= ~CPU_TASKS_FROZEN;
> > > > > -
> > > > > -	switch (action) {
> > > > > +	switch (action & ~CPU_TASKS_FROZEN) {
> > > > 
> > > > Confused. How can we see, say CPU_UP_PREPARE_FROZEN, if we cleared
> > > > CPU_TASKS_FROZEN bit?
> > > 
> > > So, unless I missed something stupid, this patch is not 100% right.
> > 
> > Well, it isn't, but for a different reason (see [*] below).
> 
> Yes, I missed something stupid :)
> 
> > > I think the better fix (at least for now) is
> > > 
> > > 	- #define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
> > > 	+ #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
> > > 
> > > Alex, do you really need a multithreaded wq?
> > > 
> > > Rafael, what do you think?
> > 
> > That would be misleading if the driver needs the threads to be frozen.
> 
> Hm? The thread will be frozen, the "patch" above changes "singlethread", not
> "freezeable".

Ah, I'm sorry.

> > [*] Getting back to the patch, it seems to me that we should do something like
> > take_over_work() before thawing the frozen thread, because there may be a queue
> > to process and the device is suspended at that point.
> 
> Yes, exactly because the driver wants this wq to be frozen.
> 
> So, could you take a second look at the "patch" above ?

Sure, if a singlethread workqueue is sufficient for Alex, I agree that this
would be preferable.

Anyway, I've added take_over_work() to the patch (appended), just in case. ;-)

Rafael


---
Prevent freezable worqueues from deadlocking with CPU hotplug during a
suspend/hibernation by thawing their worker threads before they get stopped.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/workqueue.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc1/kernel/workqueue.c
===================================================================
--- linux-2.6.22-rc1.orig/kernel/workqueue.c
+++ linux-2.6.22-rc1/kernel/workqueue.c
@@ -791,6 +791,32 @@ void destroy_workqueue(struct workqueue_
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
+	while (!list_empty(&list)) {
+		printk("Taking work for %s\n", wq->name);
+		work = list_entry(list.next,struct work_struct,entry);
+		list_del(&work->entry);
+		__queue_work(per_cpu_ptr(wq->cpu_wq, smp_processor_id()), work);
+	}
+	spin_unlock_irq(&cwq->lock);
+}
+
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
@@ -799,9 +825,7 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
-	action &= ~CPU_TASKS_FROZEN;
-
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
 		return NOTIFY_OK;
@@ -819,20 +843,31 @@ static int __devinit workqueue_cpu_callb
 
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
 
