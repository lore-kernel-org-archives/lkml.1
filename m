Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZBPQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZBPQnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZBPQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:42:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbZBPQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:42:10 -0500
Message-Id: <20090216164114.521787803@chello.nl>
References: <20090216163847.431174825@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 16 Feb 2009 17:38:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] generic-smp: remove kmalloc usage
Content-Disposition: inline; filename=smp-remove-kmalloc.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there is no strict need for kmalloc anymore, and nobody seems to
rely it for the queueing behaviour, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |   66 ++++++++++++++++-------------------------------------------
 1 file changed, 19 insertions(+), 47 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -32,18 +32,14 @@ static struct {
 
 enum {
 	CSD_FLAG_WAIT		= 0x01,
-	CSD_FLAG_ALLOC		= 0x02,
-	CSD_FLAG_LOCK		= 0x04,
+	CSD_FLAG_LOCK		= 0x02,
 };
 
 struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	union {
-		struct rcu_head rcu_head;
-		struct list_head free_list;
-	};
+	struct list_head free_list;
 	struct cpumask cpumask;
 };
 
@@ -103,15 +99,6 @@ static void generic_exec_single(int cpu,
 		csd_flag_wait(data);
 }
 
-static void rcu_free_call_data(struct rcu_head *head)
-{
-	struct call_function_data *data;
-
-	data = container_of(head, struct call_function_data, rcu_head);
-
-	kfree(data);
-}
-
 /*
  * Invoked by arch to handle an IPI for call function. Must be called with
  * interrupts disabled.
@@ -159,8 +146,6 @@ void generic_smp_call_function_interrupt
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
 		}
-		if (data->csd.flags & CSD_FLAG_ALLOC)
-			call_rcu(&data->rcu_head, rcu_free_call_data);
 
 		while (!list_empty(&free_list)) {
 			struct call_function_data *free;
@@ -225,8 +210,7 @@ void generic_smp_call_function_single_in
 			} else if (data_flags & CSD_FLAG_LOCK) {
 				smp_wmb();
 				data->flags &= ~CSD_FLAG_LOCK;
-			} else if (data_flags & CSD_FLAG_ALLOC)
-				kfree(data);
+			}
 		}
 		/*
 		 * See comment on outer loop
@@ -271,13 +255,11 @@ int smp_call_function_single(int cpu, vo
 			/*
 			 * We are calling a function on a single CPU
 			 * and we are not going to wait for it to finish.
-			 * We first try to allocate the data, but if we
-			 * fail, we fall back to use a per cpu data to pass
-			 * the information to that CPU. Since all callers
-			 * of this code will use the same data, we must
-			 * synchronize the callers to prevent a new caller
-			 * from corrupting the data before the callee
-			 * can access it.
+			 * We use a per cpu data to pass the information to
+			 * that CPU. Since all callers of this code will
+			 * use the same data, we must synchronize the
+			 * callers to prevent a new caller from corrupting
+			 * the data before the callee can access it.
 			 *
 			 * The CSD_FLAG_LOCK is used to let us know when
 			 * the IPI handler is done with the data.
@@ -287,15 +269,10 @@ int smp_call_function_single(int cpu, vo
 			 * will make sure the callee is done with the
 			 * data before a new caller will use it.
 			 */
-			data = kmalloc(sizeof(*data), GFP_ATOMIC);
-			if (data)
-				data->flags = CSD_FLAG_ALLOC;
-			else {
-				data = &per_cpu(csd_data, me);
-				while (data->flags & CSD_FLAG_LOCK)
-					cpu_relax();
-				data->flags = CSD_FLAG_LOCK;
-			}
+			data = &per_cpu(csd_data, me);
+			while (data->flags & CSD_FLAG_LOCK)
+				cpu_relax();
+			data->flags = CSD_FLAG_LOCK;
 		} else {
 			data = &d;
 			data->flags = CSD_FLAG_WAIT;
@@ -384,18 +361,13 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	data = kmalloc(sizeof(*data), GFP_ATOMIC);
-	if (data)
-		data->csd.flags = CSD_FLAG_ALLOC;
-	else {
-		data = &per_cpu(cfd_data, me);
-		/*
-		 * We need to wait for all previous users to go away.
-		 */
-		while (data->csd.flags & CSD_FLAG_LOCK)
-			cpu_relax();
-		data->csd.flags = CSD_FLAG_LOCK;
-	}
+	data = &per_cpu(cfd_data, me);
+	/*
+	 * We need to wait for all previous users to go away.
+	 */
+	while (data->csd.flags & CSD_FLAG_LOCK)
+		cpu_relax();
+	data->csd.flags = CSD_FLAG_LOCK;
 
 	spin_lock_init(&data->lock);
 	if (wait)

-- 

