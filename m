Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYKTOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYKTOmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYKTOl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:41:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40968 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbYKTOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:41:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/45] Make slow-work thread pool actually dynamic [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:41:50 +0000
Message-ID: <20081120144150.10667.42993.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the slow-work thread pool actually dynamic in the number of threads it
contains.  With this patch, it will both create additional threads when it has
extra work to do, and cull excess threads that aren't doing anything.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/slow-work.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 139 insertions(+), 1 deletions(-)


diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 590fc7b..313640c 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -16,6 +16,14 @@
 #include <linux/wait.h>
 #include <asm/system.h>
 
+#define SLOW_WORK_CULL_TIMEOUT (5 * HZ)	/* cull threads 5s after running out of
+					 * things to do */
+#define SLOW_WORK_OOM_TIMEOUT (5 * HZ)	/* can't start new threads for 5s after
+					 * OOM */
+
+static void slow_work_cull_timeout(unsigned long);
+static void slow_work_oom_timeout(unsigned long);
+
 /*
  * The pool of threads has at least min threads in it as long as someone is
  * using the facility, and may have as many as max.
@@ -29,6 +37,12 @@ static unsigned vslow_work_proportion = 50; /* % of threads that may process
 static atomic_t slow_work_thread_count;
 static atomic_t vslow_work_executing_count;
 
+static bool slow_work_may_not_start_new_thread;
+static bool slow_work_cull; /* cull a thread due to lack of activity */
+static DEFINE_TIMER(slow_work_cull_timer, slow_work_cull_timeout, 0, 0);
+static DEFINE_TIMER(slow_work_oom_timer, slow_work_oom_timeout, 0, 0);
+static struct slow_work slow_work_new_thread; /* new thread starter */
+
 /*
  * The queues of work items and the lock governing access to them.  These are
  * shared between all the CPUs.  It doesn't make sense to have per-CPU queues
@@ -89,6 +103,14 @@ static bool slow_work_execute(void)
 
 	vsmax = slow_work_calc_vsmax();
 
+	/* see if we can schedule a new thread to be started if we're not
+	 * keeping up with the work */
+	if (!waitqueue_active(&slow_work_thread_wq) &&
+	    (!list_empty(&slow_work_queue) || !list_empty(&vslow_work_queue)) &&
+	    atomic_read(&slow_work_thread_count) < slow_work_max_threads &&
+	    !slow_work_may_not_start_new_thread)
+		slow_work_enqueue(&slow_work_new_thread);
+
 	/* find something to execute */
 	spin_lock_irq(&slow_work_queue_lock);
 	if (!list_empty(&vslow_work_queue) &&
@@ -223,6 +245,33 @@ cant_get_ref:
 EXPORT_SYMBOL(slow_work_enqueue);
 
 /*
+ * Worker thread culling algorithm
+ */
+static bool slow_work_cull_thread(void)
+{
+	unsigned long flags;
+	bool do_cull = false;
+
+	spin_lock_irqsave(&slow_work_queue_lock, flags);
+
+	if (slow_work_cull) {
+		slow_work_cull = false;
+
+		if (list_empty(&slow_work_queue) &&
+		    list_empty(&vslow_work_queue) &&
+		    atomic_read(&slow_work_thread_count) >
+		    slow_work_min_threads) {
+			mod_timer(&slow_work_cull_timer,
+				  jiffies + SLOW_WORK_CULL_TIMEOUT);
+			do_cull = true;
+		}
+	}
+
+	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	return do_cull;
+}
+
+/*
  * Worker thread dispatcher
  */
 static int slow_work_thread(void *_data)
@@ -248,7 +297,8 @@ static int slow_work_thread(void *_data)
 				TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
 		    !slow_work_threads_should_exit &&
-		    !slow_work_available(vsmax))
+		    !slow_work_available(vsmax) &&
+		    !slow_work_cull)
 			schedule();
 		finish_wait(&slow_work_thread_wq, &wait);
 
@@ -260,11 +310,20 @@ static int slow_work_thread(void *_data)
 
 		if (slow_work_available(vsmax) && slow_work_execute()) {
 			cond_resched();
+			if (list_empty(&slow_work_queue) &&
+			    list_empty(&vslow_work_queue) &&
+			    atomic_read(&slow_work_thread_count) >
+			    slow_work_min_threads)
+				mod_timer(&slow_work_cull_timer,
+					  jiffies + SLOW_WORK_CULL_TIMEOUT);
 			continue;
 		}
 
 		if (slow_work_threads_should_exit)
 			break;
+
+		if (slow_work_cull && slow_work_cull_thread())
+			break;
 	}
 
 	if (atomic_dec_and_test(&slow_work_thread_count))
@@ -272,6 +331,79 @@ static int slow_work_thread(void *_data)
 	return 0;
 }
 
+/*
+ * Handle thread cull timer expiration
+ */
+static void slow_work_cull_timeout(unsigned long data)
+{
+	slow_work_cull = true;
+	wake_up(&slow_work_thread_wq);
+}
+
+/*
+ * Get a reference on slow work thread starter
+ */
+static int slow_work_new_thread_get_ref(struct slow_work *work)
+{
+	return 0;
+}
+
+/*
+ * Drop a reference on slow work thread starter
+ */
+static void slow_work_new_thread_put_ref(struct slow_work *work)
+{
+}
+
+/*
+ * Start a new slow work thread
+ */
+static void slow_work_new_thread_execute(struct slow_work *work)
+{
+	struct task_struct *p;
+
+	if (slow_work_threads_should_exit)
+		return;
+
+	if (atomic_read(&slow_work_thread_count) >= slow_work_max_threads)
+		return;
+
+	if (!mutex_trylock(&slow_work_user_lock))
+		return;
+
+	slow_work_may_not_start_new_thread = true;
+	atomic_inc(&slow_work_thread_count);
+	p = kthread_create(slow_work_thread, NULL, "kslowd");
+	if (!p) {
+		printk(KERN_DEBUG "Slow work thread pool: OOM\n");
+		if (atomic_dec_and_test(&slow_work_thread_count))
+			BUG(); /* we're running on a slow work thread... */
+		mod_timer(&slow_work_oom_timer,
+			  jiffies + SLOW_WORK_OOM_TIMEOUT);
+	} else {
+		wake_up_process(p);
+
+		/* ratelimit the starting of new threads */
+		mod_timer(&slow_work_oom_timer, jiffies + 1);
+	}
+
+	mutex_unlock(&slow_work_user_lock);
+}
+
+static const struct slow_work_ops slow_work_new_thread_ops = {
+	.get_ref	= slow_work_new_thread_get_ref,
+	.put_ref	= slow_work_new_thread_put_ref,
+	.execute	= slow_work_new_thread_execute,
+};
+
+/*
+ * post-OOM new thread start suppression expiration
+ */
+static void slow_work_oom_timeout(unsigned long data)
+{
+	slow_work_may_not_start_new_thread = false;
+}
+
 /**
  * slow_work_register_user - Register a user of the facility
  *
@@ -291,6 +423,10 @@ int slow_work_register_user(void)
 		init_completion(&slow_work_last_thread_exited);
 
 		slow_work_threads_should_exit = false;
+		slow_work_init(&slow_work_new_thread,
+			       &slow_work_new_thread_ops);
+		slow_work_may_not_start_new_thread = false;
+		slow_work_cull = false;
 
 		/* start the minimum number of threads */
 		for (loop = 0; loop < slow_work_min_threads; loop++) {
@@ -346,6 +482,8 @@ void slow_work_unregister_user(void)
 		       " Shut down complete\n");
 	}
 
+	del_timer_sync(&slow_work_cull_timer);
+
 	mutex_unlock(&slow_work_user_lock);
 }
 EXPORT_SYMBOL(slow_work_unregister_user);

