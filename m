Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbZBLKI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbZBLKI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZBLKIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:08:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbZBLKIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:08:15 -0500
Date: Thu, 12 Feb 2009 11:07:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: [patch] generic-ipi: remove kmalloc, cleanup
Message-ID: <20090212100756.GA12790@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212081801.GA22979@elte.hu> <20090212081923.GA26838@elte.hu> <1234430564.23438.205.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234430564.23438.205.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: csd.info]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-02-12 at 09:19 +0100, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > hm, that's a complex one - we do kfree() from IPI context, [...]
> > 
> > The patch below might do the trick - it offloads this to a softirq.
> > Not tested yet.
> 
> The simple fix is something like:
> 
> ---
>  kernel/smp.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

ok, i made it unconditional (not just a PREEMPT_RT hac) and did the
cleanup below on top of it.

I dont think repeat, queued IPIs are all that interesting from a
performance point of view. If they are, it will all be clearly
bisectable.

	Ingo

--------------->
Subject: generic-ipi: remove kmalloc, cleanup
From: Ingo Molnar <mingo@elte.hu>

Now that we dont use the kmalloc() sequence anymore, remove
CSD_FLAG_ALLOC and all its dependencies.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |   86 +++++++++++------------------------------------------------
 1 file changed, 17 insertions(+), 69 deletions(-)

Index: tip/kernel/smp.c
===================================================================
--- tip.orig/kernel/smp.c
+++ tip/kernel/smp.c
@@ -17,8 +17,7 @@ __cacheline_aligned_in_smp DEFINE_RAW_SP
 
 enum {
 	CSD_FLAG_WAIT		= 0x01,
-	CSD_FLAG_ALLOC		= 0x02,
-	CSD_FLAG_LOCK		= 0x04,
+	CSD_FLAG_LOCK		= 0x02,
 };
 
 struct call_function_data {
@@ -85,15 +84,6 @@ static void generic_exec_single(int cpu,
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
@@ -138,8 +128,6 @@ void generic_smp_call_function_interrupt
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
 		}
-		if (data->csd.flags & CSD_FLAG_ALLOC)
-			call_rcu(&data->rcu_head, rcu_free_call_data);
 	}
 	rcu_read_unlock();
 
@@ -190,8 +178,7 @@ void generic_smp_call_function_single_in
 			} else if (data_flags & CSD_FLAG_LOCK) {
 				smp_wmb();
 				data->flags &= ~CSD_FLAG_LOCK;
-			} else if (data_flags & CSD_FLAG_ALLOC)
-				kfree(data);
+			}
 		}
 		/*
 		 * See comment on outer loop
@@ -236,13 +223,11 @@ int smp_call_function_single(int cpu, vo
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
+			 * that CPU. Since all callers of this code will use
+			 * the same data, we must synchronize the callers to
+			 * prevent a new caller from corrupting the data before
+			 * the callee can access it.
 			 *
 			 * The CSD_FLAG_LOCK is used to let us know when
 			 * the IPI handler is done with the data.
@@ -252,15 +237,10 @@ int smp_call_function_single(int cpu, vo
 			 * will make sure the callee is done with the
 			 * data before a new caller will use it.
 			 */
-			data = NULL;
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
@@ -321,8 +301,6 @@ void smp_call_function_many(const struct
 			    void (*func)(void *), void *info,
 			    bool wait)
 {
-	struct call_function_data *data;
-	unsigned long flags;
 	int cpu, next_cpu;
 
 	/* Can deadlock when called with interrupts disabled */
@@ -347,43 +325,13 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	data = NULL;
-	if (unlikely(!data)) {
-		/* Slow path. */
-		for_each_online_cpu(cpu) {
-			if (cpu == smp_processor_id())
-				continue;
-			if (cpumask_test_cpu(cpu, mask))
-				smp_call_function_single(cpu, func, info, wait);
-		}
-		return;
+	/* Slow path. */
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+		if (cpumask_test_cpu(cpu, mask))
+			smp_call_function_single(cpu, func, info, wait);
 	}
-
-	spin_lock_init(&data->lock);
-	data->csd.flags = CSD_FLAG_ALLOC;
-	if (wait)
-		data->csd.flags |= CSD_FLAG_WAIT;
-	data->csd.func = func;
-	data->csd.info = info;
-	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
-	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
-
-	spin_lock_irqsave(&call_function_lock, flags);
-	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-	spin_unlock_irqrestore(&call_function_lock, flags);
-
-	/*
-	 * Make the list addition visible before sending the ipi.
-	 */
-	smp_mb();
-
-	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(to_cpumask(data->cpumask_bits));
-
-	/* optionally wait for the CPUs to complete */
-	if (wait)
-		csd_flag_wait(&data->csd);
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
