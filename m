Return-Path: <linux-kernel-owner+w=401wt.eu-S933759AbXJPKhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759AbXJPKhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXJPKh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:37:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36529 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539AbXJPKh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:37:27 -0400
Date: Tue, 16 Oct 2007 16:07:21 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: [RFC PATCH 4/4] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Message-ID: <20071016103721.GD16570@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016103308.GA9907@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup_workqueue_thread() in the CPU_DEAD and CPU_UP_CANCELLED path
will cause a deadlock if the worker thread is executing a work item
which is blocked on get_online_cpus(). This will lead to a irrecoverable
hang. 

Solution is not to cleanup the worker thread. Instead let it remain
even after the cpu goes offline. Since no one can queue any work
on an offlined cpu, this thread will be forever sleeping, untill
someone onlines the cpu.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/workqueue.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6.23/kernel/workqueue.c
===================================================================
--- linux-2.6.23.orig/kernel/workqueue.c
+++ linux-2.6.23/kernel/workqueue.c
@@ -30,6 +30,7 @@
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
 #include <linux/freezer.h>
+#include <linux/cpumask.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
@@ -679,6 +680,7 @@ init_cpu_workqueue(struct workqueue_stru
 	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
+	cwq->thread = NULL;
 
 	return cwq;
 }
@@ -712,7 +714,7 @@ static void start_workqueue_thread(struc
 
 	if (p != NULL) {
 		if (cpu >= 0)
-			kthread_bind(p, cpu);
+			set_cpus_allowed(p, cpumask_of_cpu(cpu));
 		wake_up_process(p);
 	}
 }
@@ -848,6 +850,9 @@ static int __devinit workqueue_cpu_callb
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+			if (likely(cwq->thread != NULL &&
+					!IS_ERR(cwq->thread)))
+				break;
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
@@ -858,12 +863,6 @@ static int __devinit workqueue_cpu_callb
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
 			break;
-
-		case CPU_UP_CANCELED:
-			start_workqueue_thread(cwq, -1);
-		case CPU_DEAD:
-			cleanup_workqueue_thread(cwq, cpu);
-			break;
 		}
 	}
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
