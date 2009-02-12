Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZBLMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZBLMHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZBLMHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:07:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:44446 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbZBLMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:07:31 -0500
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>, rusty <rusty@rustcorp.com.au>
In-Reply-To: <1234433770.23438.210.camel@twins>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
	 <20090212081801.GA22979@elte.hu> <20090212081923.GA26838@elte.hu>
	 <1234430564.23438.205.camel@twins>  <20090212100756.GA12790@elte.hu>
	 <1234433770.23438.210.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Feb 2009 13:09:14 +0100
Message-Id: <1234440554.23438.264.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 11:16 +0100, Peter Zijlstra wrote:
> On Thu, 2009-02-12 at 11:07 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, 2009-02-12 at 09:19 +0100, Ingo Molnar wrote:
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > hm, that's a complex one - we do kfree() from IPI context, [...]
> > > > 
> > > > The patch below might do the trick - it offloads this to a softirq.
> > > > Not tested yet.
> > > 
> > > The simple fix is something like:
> > > 
> > > ---
> > >  kernel/smp.c |    8 ++++++++
> > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > ok, i made it unconditional (not just a PREEMPT_RT hac) and did the
> > cleanup below on top of it.
> > 
> > I dont think repeat, queued IPIs are all that interesting from a
> > performance point of view. If they are, it will all be clearly
> > bisectable.
> 
> Right, except I really don't like the smp_call_function_many() slow path
> that's now the only path.
> 
> Rusty did that I think, but he also had some idea on how to fix it, I
> think it boiled down to sticking a count in the call data instead of the
> full cpumask.
> 
> So I'd rather we first fix that code, and then remove the kmalloc
> all-together like you propose here.

Right, I can't see a way around carrying that cpumask, there's just too
much that can go wrong without it.

So it put in unconditionally, how about this?


--
Subject: generic-smp: remove single ipi fallback for smp_call_function_many()

In preparation of removing the kmalloc() calls from the generic-ipi code
get rid of the single ipi fallback for smp_call_function_many().

Because we cannot get around carrying the cpumask in the data -- imagine
2 such calls with different but overlapping masks -- put in a full mask.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |   47 ++++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index bbedbb7..e6658e5 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -26,7 +26,7 @@ struct call_function_data {
 	spinlock_t lock;
 	unsigned int refs;
 	struct rcu_head rcu_head;
-	unsigned long cpumask_bits[];
+	struct cpumask cpumask;
 };
 
 struct call_single_queue {
@@ -111,13 +111,13 @@ void generic_smp_call_function_interrupt(void)
 	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
 		int refs;
 
-		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
+		if (!cpumask_test_cpu(cpu, &data->cpumask))
 			continue;
 
 		data->csd.func(data->csd.info);
 
 		spin_lock(&data->lock);
-		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
+		cpumask_clear_cpu(cpu, &data->cpumask);
 		WARN_ON(data->refs == 0);
 		data->refs--;
 		refs = data->refs;
@@ -137,8 +137,10 @@ void generic_smp_call_function_interrupt(void)
 			 */
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
-		}
-		if (data->csd.flags & CSD_FLAG_ALLOC)
+		} else if (data->csd.flags & CSD_FLAG_LOCK) {
+			smp_wmb();
+			data->csd.flags &= ~CSD_FLAG_LOCK;
+		} else if (data->csd.flags & CSD_FLAG_ALLOC)
 			call_rcu(&data->rcu_head, rcu_free_call_data);
 	}
 	rcu_read_unlock();
@@ -302,6 +304,8 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	arch_send_call_function_ipi(*(maskp))
 #endif
 
+static DEFINE_PER_CPU(struct call_function_data, cfd_data);
+
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on (only runs on online subset).
@@ -323,14 +327,14 @@ void smp_call_function_many(const struct cpumask *mask,
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu;
+	int cpu, next_cpu, me = smp_processor_id();
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
 
 	/* So, what's a CPU they want?  Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
-	if (cpu == smp_processor_id())
+	if (cpu == me)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
 	/* No online cpus?  We're done. */
 	if (cpu >= nr_cpu_ids)
@@ -338,7 +342,7 @@ void smp_call_function_many(const struct cpumask *mask,
 
 	/* Do we have another CPU which isn't us? */
 	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
-	if (next_cpu == smp_processor_id())
+	if (next_cpu == me)
 		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
 
 	/* Fastpath: do that cpu by itself. */
@@ -347,27 +351,24 @@ void smp_call_function_many(const struct cpumask *mask,
 		return;
 	}
 
-	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
-	if (unlikely(!data)) {
-		/* Slow path. */
-		for_each_online_cpu(cpu) {
-			if (cpu == smp_processor_id())
-				continue;
-			if (cpumask_test_cpu(cpu, mask))
-				smp_call_function_single(cpu, func, info, wait);
-		}
-		return;
+	data = kmalloc(sizeof(*data), GFP_ATOMIC);
+	if (data)
+		data->csd.flags = CSD_FLAG_ALLOC;
+	else {
+		data = &per_cpu(cfd_data, me);
+		while (data->csd.flags & CSD_FLAG_LOCK)
+			cpu_relax();
+		data->csd.flags = CSD_FLAG_LOCK;
 	}
 
 	spin_lock_init(&data->lock);
-	data->csd.flags = CSD_FLAG_ALLOC;
 	if (wait)
 		data->csd.flags |= CSD_FLAG_WAIT;
 	data->csd.func = func;
 	data->csd.info = info;
-	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
-	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
+	cpumask_and(&data->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &data->cpumask);
+	data->refs = cpumask_weight(&data->cpumask);
 
 	spin_lock_irqsave(&call_function_lock, flags);
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
@@ -379,7 +380,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(to_cpumask(data->cpumask_bits));
+	arch_send_call_function_ipi_mask(&data->cpumask);
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)

