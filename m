Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXDBFle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXDBFle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXDBFle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:41:34 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:36664 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbXDBFlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:41:32 -0400
Date: Mon, 2 Apr 2007 11:11:07 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 6/8] Make non-singlethreaded workqueues freezeable by default
Message-ID: <20070402054107.GF12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch
o Makes all non-singlethreaded workqueues freezeable by default.
o Introduces a new API for creating freeze_exempted workqueues.
o Uses the combination of cancel_delayed_work and cancel_work_sync
  in Slab during DOWN_PREPARE instead of cancel_rearming_delayed work, 
  which tries to flush_workqueue in vain, in a frozen context.

Note:
o The singlethreaded workqueues will not be frozen.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>
--
 include/linux/workqueue.h |   12 +++++-------
 kernel/workqueue.c        |   35 ++++++++++++++++++++++++++---------
 mm/slab.c                 |   10 +++-------
 3 files changed, 34 insertions(+), 23 deletions(-)

Index: linux-2.6.21-rc5/include/linux/workqueue.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/workqueue.h
+++ linux-2.6.21-rc5/include/linux/workqueue.h
@@ -9,7 +9,6 @@
 #include <linux/linkage.h>
 #include <linux/bitops.h>
 #include <asm/atomic.h>
-
 struct workqueue_struct;
 
 struct work_struct;
@@ -112,12 +111,11 @@ struct execute_work {
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
 
-extern struct workqueue_struct *__create_workqueue(const char *name,
-						    int singlethread,
-						    int freezeable);
-#define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
+extern struct workqueue_struct *create_workqueue(const char *name);
+
+extern struct workqueue_struct *create_freeze_exempted_workqueue(const char *name, int freeze_exempt_events);
+
+extern struct workqueue_struct *create_singlethread_workqueue(const char *name);
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
Index: linux-2.6.21-rc5/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/workqueue.c
+++ linux-2.6.21-rc5/kernel/workqueue.c
@@ -64,7 +64,7 @@ struct workqueue_struct {
 	struct list_head list;
 	const char *name;
 	int singlethread;
-	int freezeable;		/* Freeze threads during suspend */
+	int freeze_exempt_events;	/* Events not to freeze! */
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -294,8 +294,7 @@ static int worker_thread(void *__cwq)
 	DEFINE_WAIT(wait);
 	struct k_sigaction sa;
 
-	if (!cwq->wq->freezeable)
-		freezer_exempt(FE_ALL);
+	freezer_exempt(cwq->wq->freeze_exempt_events);
 
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
@@ -310,8 +309,7 @@ static int worker_thread(void *__cwq)
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
 	for (;;) {
-		if (cwq->wq->freezeable)
-			try_to_freeze();
+		try_to_freeze();
 
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (cwq->status == CWQ_RUNNING && list_empty(&cwq->worklist))
@@ -656,8 +654,9 @@ static int create_workqueue_thread(struc
 	return 0;
 }
 
-struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread, int freezeable)
+static struct workqueue_struct *__create_workqueue(const char *name,
+					    int singlethread,
+					    int freeze_exempt_events)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -675,7 +674,7 @@ struct workqueue_struct *__create_workqu
 
 	wq->name = name;
 	wq->singlethread = singlethread;
-	wq->freezeable = freezeable;
+	wq->freeze_exempt_events = freeze_exempt_events;
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
@@ -700,7 +699,25 @@ struct workqueue_struct *__create_workqu
 	}
 	return wq;
 }
-EXPORT_SYMBOL_GPL(__create_workqueue);
+
+struct workqueue_struct *create_workqueue(const char *name)
+{
+	return __create_workqueue(name, 0, FE_NONE);
+}
+EXPORT_SYMBOL_GPL(create_workqueue);
+
+struct workqueue_struct *create_freeze_exempted_workqueue(const char *name,
+							int freeze_exempt_events)
+{
+	return __create_workqueue(name, 0, freeze_exempt_events);
+}
+EXPORT_SYMBOL_GPL(create_freeze_exempted_workqueue);
+
+struct workqueue_struct *create_singlethread_workqueue(const char *name)
+{
+	return __create_workqueue(name, 1, FE_ALL);
+}
+EXPORT_SYMBOL_GPL(create_singlethread_workqueue);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
Index: linux-2.6.21-rc5/mm/slab.c
===================================================================
--- linux-2.6.21-rc5.orig/mm/slab.c
+++ linux-2.6.21-rc5/mm/slab.c
@@ -1277,13 +1277,9 @@ static int __cpuinit cpuup_callback(stru
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
   	case CPU_DOWN_PREPARE:
-		/*
-		 * Shutdown cache reaper. Note that the cache_chain_mutex is
-		 * held so that if cache_reap() is invoked it cannot do
-		 * anything expensive but will only modify reap_work
-		 * and reschedule the timer.
-		*/
-		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		/* we are in a frozen context. So this should be safe.*/
+		cancel_delayed_work(&per_cpu(reap_work, cpu));
+		cancel_work_sync(&per_cpu(reap_work, cpu).work);
 		/* Now the cache_reaper is guaranteed to be not running. */
 		per_cpu(reap_work, cpu).work.func = NULL;
   		break;
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
