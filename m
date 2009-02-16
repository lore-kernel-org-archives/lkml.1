Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZBPQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZBPQm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZBPQmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:42:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbZBPQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:42:06 -0500
Message-Id: <20090216164114.700407913@chello.nl>
References: <20090216163847.431174825@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 16 Feb 2009 17:38:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] generic-smp: clean up some of the csd->flags fiddling
Content-Disposition: inline; filename=smp-cleanup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out the WAIT and LOCK bit operations into functions and provide some
extra comments.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |  100 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 40 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -100,14 +100,50 @@ static int __cpuinit init_call_single_da
 }
 early_initcall(init_call_single_data);
 
-static void csd_flag_wait(struct call_single_data *data)
+/*
+ * csd_wait/csd_complete are used for synchronous ipi calls
+ */
+static void csd_wait_prepare(struct call_single_data *data)
+{
+	data->flags |= CSD_FLAG_WAIT;
+}
+
+static void csd_complete(struct call_single_data *data)
+{
+	/*
+	 * Serialize stores to data with the flag clear and wakeup.
+	 */
+	smp_wmb();
+	data->flags &= ~CSD_FLAG_WAIT;
+}
+
+static void csd_wait(struct call_single_data *data)
+{
+	while (data->flags & CSD_FLAG_WAIT)
+		cpu_relax();
+}
+
+/*
+ * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
+ *
+ * For non-synchronous ipi calls the csd can still be in use by the previous
+ * function call. For multi-cpu calls its even more interesting as we'll have
+ * to ensure no other cpu is observing our csd.
+ */
+static void csd_lock(struct call_single_data *data)
 {
-	/* Wait for response */
-	do {
-		if (!(data->flags & CSD_FLAG_WAIT))
-			break;
+	while (data->flags & CSD_FLAG_LOCK)
 		cpu_relax();
-	} while (1);
+	data->flags = CSD_FLAG_LOCK;
+}
+
+static void csd_unlock(struct call_single_data *data)
+{
+	/*
+	 * Serialize stores to data with the flags clear.
+	 */
+	smp_wmb();
+	data->flags &= ~CSD_FLAG_LOCK;
 }
 
 /*
@@ -134,7 +170,7 @@ static void generic_exec_single(int cpu,
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_flag_wait(data);
+		csd_wait(data);
 }
 
 /*
@@ -172,18 +208,17 @@ void generic_smp_call_function_interrupt
 		spin_lock(&call_function.lock);
 		list_add(&data->free_list, &call_function.free_list);
 		list_del_rcu(&data->csd.list);
+		/*
+		 * When the global queue is empty, its guaranteed that no cpu
+		 * is still observing any entry on the free_list, therefore
+		 * we can go ahead and unlock them.
+		 */
 		if (!--call_function.counter)
 			list_splice_init(&call_function.free_list, &free_list);
 		spin_unlock(&call_function.lock);
 
-		if (data->csd.flags & CSD_FLAG_WAIT) {
-			/*
-			 * serialize stores to data with the flag clear
-			 * and wakeup
-			 */
-			smp_wmb();
-			data->csd.flags &= ~CSD_FLAG_WAIT;
-		}
+		if (data->csd.flags & CSD_FLAG_WAIT)
+			csd_complete(&data->csd);
 
 		while (!list_empty(&free_list)) {
 			struct call_function_data *free;
@@ -192,12 +227,7 @@ void generic_smp_call_function_interrupt
 					struct call_function_data, free_list);
 
 			list_del(&data->free_list);
-			/*
-			 * serialize stores to data with the flags
-			 * clear
-			 */
-			smp_wmb();
-			free->csd.flags &= ~CSD_FLAG_LOCK;
+			csd_unlock(&free->csd);
 		}
 	}
 
@@ -242,13 +272,10 @@ void generic_smp_call_function_single_in
 
 			data->func(data->info);
 
-			if (data_flags & CSD_FLAG_WAIT) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_WAIT;
-			} else if (data_flags & CSD_FLAG_LOCK) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_LOCK;
-			}
+			if (data_flags & CSD_FLAG_WAIT)
+				csd_complete(data);
+			else if (data_flags & CSD_FLAG_LOCK)
+				csd_unlock(data);
 		}
 		/*
 		 * See comment on outer loop
@@ -308,12 +335,10 @@ int smp_call_function_single(int cpu, vo
 			 * data before a new caller will use it.
 			 */
 			data = &per_cpu(csd_data, me);
-			while (data->flags & CSD_FLAG_LOCK)
-				cpu_relax();
-			data->flags = CSD_FLAG_LOCK;
+			csd_lock(data);
 		} else {
 			data = &d;
-			data->flags = CSD_FLAG_WAIT;
+			csd_wait_prepare(data);
 		}
 
 		data->func = func;
@@ -398,16 +423,11 @@ void smp_call_function_many(const struct
 	}
 
 	data = &per_cpu(cfd_data, me);
-	/*
-	 * We need to wait for all previous users to go away.
-	 */
-	while (data->csd.flags & CSD_FLAG_LOCK)
-		cpu_relax();
-	data->csd.flags = CSD_FLAG_LOCK;
+	csd_lock(&data->csd);
 
 	spin_lock_init(&data->lock);
 	if (wait)
-		data->csd.flags |= CSD_FLAG_WAIT;
+		csd_wait_prepare(&data->csd);
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
@@ -429,7 +449,7 @@ void smp_call_function_many(const struct
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)
-		csd_flag_wait(&data->csd);
+		csd_wait(&data->csd);
 }
 EXPORT_SYMBOL(smp_call_function_many);
 

-- 

