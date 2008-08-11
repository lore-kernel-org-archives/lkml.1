Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYHKNXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYHKNXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYHKNXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:23:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYHKNXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:23:08 -0400
Date: Mon, 11 Aug 2008 15:22:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de,
       linux-kernel <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] stack and rcu interaction bug in
	smp_call_function_mask()
Message-ID: <20080811132239.GA14474@elte.hu>
References: <20080808193753.GA21964@linux-os.sc.intel.com> <200808101624.15112.nickpiggin@yahoo.com.au> <200808111349.30463.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808111349.30463.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Sunday 10 August 2008 16:24, Nick Piggin wrote:
> 
> > I'd suggest something like the attached (untested) patch as the simple
> > fix for now.
> >
> > I expect the benefits from the less synchronized, 
> > multiple-in-flight-data global queue will still outweigh the costs 
> > of dynamic allocations. But if worst comes to worst then we just go 
> > back to a globally synchronous one-at-a-time implementation, but 
> > that would be pretty sad!
> 
> Just needed a little fix and it appears to boot now. I think it does 
> the right thing...

nice find! I've queued it up in tip/core/urgent and started testing it. 
Full commit is quoted below.

	Ingo

------------------------>
>From cc7a486cac78f6fc1a24e8cd63036bae8d2ab431 Mon Sep 17 00:00:00 2001
From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Mon, 11 Aug 2008 13:49:30 +1000
Subject: [PATCH] generic-ipi: fix stack and rcu interaction bug in smp_call_function_mask()

* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Found a OOPS on a big SMP box during an overnight reboot test with
> upstream git.
>
> Suresh and I looked at the oops and looks like the root cause is in
> generic_smp_call_function_interrupt() and smp_call_function_mask() with
> wait parameter.
>
> The actual oops looked like
>
> [   11.277260] BUG: unable to handle kernel paging request at ffff8802ffffffff
> [   11.277815] IP: [<ffff8802ffffffff>] 0xffff8802ffffffff
> [   11.278155] PGD 202063 PUD 0
> [   11.278576] Oops: 0010 [1] SMP
> [   11.279006] CPU 5
> [   11.279336] Modules linked in:
> [   11.279752] Pid: 0, comm: swapper Not tainted 2.6.27-rc2-00020-g685d87f #290
> [   11.280039] RIP: 0010:[<ffff8802ffffffff>]  [<ffff8802ffffffff>] 0xffff8802ffffffff
> [   11.280692] RSP: 0018:ffff88027f1f7f70  EFLAGS: 00010086
> [   11.280976] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 0000000000000000
> [   11.281264] RDX: 0000000000004f4e RSI: 0000000000000001 RDI: 0000000000000000
> [   11.281624] RBP: ffff88027f1f7f98 R08: 0000000000000001 R09: ffffffff802509af
> [   11.281925] R10: ffff8800280c2780 R11: 0000000000000000 R12: ffff88027f097d48
> [   11.282214] R13: ffff88027f097d70 R14: 0000000000000005 R15: ffff88027e571000
> [   11.282502] FS:  0000000000000000(0000) GS:ffff88027f1c3340(0000) knlGS:0000000000000000
> [   11.283096] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   11.283382] CR2: ffff8802ffffffff CR3: 0000000000201000 CR4: 00000000000006e0
> [   11.283760] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   11.284048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   11.284337] Process swapper (pid: 0, threadinfo ffff88027f1f2000, task ffff88027f1f0640)
> [   11.284936] Stack:  ffffffff80250963 0000000000000212 0000000000ee8c78 0000000000ee8a66
> [   11.285802]  ffff88027e571550 ffff88027f1f7fa8 ffffffff8021adb5 ffff88027f1f3e40
> [   11.286599]  ffffffff8020bdd6 ffff88027f1f3e40 <EOI>  ffff88027f1f3ef8 0000000000000000
> [   11.287120] Call Trace:
> [   11.287768]  <IRQ>  [<ffffffff80250963>] ? generic_smp_call_function_interrupt+0x61/0x12c
> [   11.288354]  [<ffffffff8021adb5>] smp_call_function_interrupt+0x17/0x27
> [   11.288744]  [<ffffffff8020bdd6>] call_function_interrupt+0x66/0x70
> [   11.289030]  <EOI>  [<ffffffff8024ab3b>] ? clockevents_notify+0x19/0x73
> [   11.289380]  [<ffffffff803b9b75>] ? acpi_idle_enter_simple+0x18b/0x1fa
> [   11.289760]  [<ffffffff803b9b6b>] ? acpi_idle_enter_simple+0x181/0x1fa
> [   11.290051]  [<ffffffff8053aeca>] ? cpuidle_idle_call+0x70/0xa2
> [   11.290338]  [<ffffffff80209f61>] ? cpu_idle+0x5f/0x7d
> [   11.290723]  [<ffffffff8060224a>] ? start_secondary+0x14d/0x152
> [   11.291010]
> [   11.291287]
> [   11.291654] Code:  Bad RIP value.
> [   11.292041] RIP  [<ffff8802ffffffff>] 0xffff8802ffffffff
> [   11.292380]  RSP <ffff88027f1f7f70>
> [   11.292741] CR2: ffff8802ffffffff
> [   11.310951] ---[ end trace 137c54d525305f1c ]---
>
> The problem is with the following sequence of events:
>
> - CPU A calls smp_call_function_mask() for CPU B with wait parameter
> - CPU A sets up the call_function_data on the stack and does an rcu add to
>   call_function_queue
> - CPU A waits until the WAIT flag is cleared
> - CPU B gets the call function interrupt and starts going through the
>   call_function_queue
> - CPU C also gets some other call function interrupt and starts going through
>   the call_function_queue
> - CPU C, which is also going through the call_function_queue, starts referencing
>   CPU A's stack, as that element is still in call_function_queue
> - CPU B finishes the function call that CPU A set up and as there are no other
>   references to it, rcu deletes the call_function_data (which was from CPU A
>   stack)
> - CPU B sees the wait flag and just clears the flag (no call_rcu to free)
> - CPU A which was waiting on the flag continues executing and the stack
>   contents change
>
> - CPU C is still in rcu_read section accessing the CPU A's stack sees
>   inconsistent call_funation_data and can try to execute
>   function with some random pointer, causing stack corruption for A
>   (by clearing the bits in mask field) and oops.

Nice debugging work.

I'd suggest something like the attached (boot tested) patch as the simple
fix for now.

I expect the benefits from the less synchronized, multiple-in-flight-data
global queue will still outweigh the costs of dynamic allocations. But
if worst comes to worst then we just go back to a globally synchronous
one-at-a-time implementation, but that would be pretty sad!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 96fc7c0..e6084f6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -260,6 +260,41 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	generic_exec_single(cpu, data);
 }
 
+/* Dummy function */
+static void quiesce_dummy(void *unused)
+{
+}
+
+/*
+ * Ensure stack based data used in call function mask is safe to free.
+ *
+ * This is needed by smp_call_function_mask when using on-stack data, because
+ * a single call function queue is shared by all CPUs, and any CPU may pick up
+ * the data item on the queue at any time before it is deleted. So we need to
+ * ensure that all CPUs have transitioned through a quiescent state after
+ * this call.
+ *
+ * This is a very slow function, implemented by sending synchronous IPIs to
+ * all possible CPUs. For this reason, we have to alloc data rather than use
+ * stack based data even in the case of synchronous calls. The stack based
+ * data is then just used for deadlock/oom fallback which will be very rare.
+ *
+ * If a faster scheme can be made, we could go back to preferring stack based
+ * data -- the data allocation/free is non-zero cost.
+ */
+static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
+{
+	struct call_single_data data;
+	int cpu;
+
+	data.func = quiesce_dummy;
+	data.info = NULL;
+	data.flags = CSD_FLAG_WAIT;
+
+	for_each_cpu_mask(cpu, mask)
+		generic_exec_single(cpu, &data);
+}
+
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.
@@ -285,6 +320,7 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
+	int slowpath = 0;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -306,15 +342,16 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 		return smp_call_function_single(cpu, func, info, wait);
 	}
 
-	if (!wait) {
-		data = kmalloc(sizeof(*data), GFP_ATOMIC);
-		if (data)
-			data->csd.flags = CSD_FLAG_ALLOC;
-	}
-	if (!data) {
+	data = kmalloc(sizeof(*data), GFP_ATOMIC);
+	if (data) {
+		data->csd.flags = CSD_FLAG_ALLOC;
+		if (wait)
+			data->csd.flags |= CSD_FLAG_WAIT;
+	} else {
 		data = &d;
 		data->csd.flags = CSD_FLAG_WAIT;
 		wait = 1;
+		slowpath = 1;
 	}
 
 	spin_lock_init(&data->lock);
@@ -331,8 +368,11 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	arch_send_call_function_ipi(mask);
 
 	/* optionally wait for the CPUs to complete */
-	if (wait)
+	if (wait) {
 		csd_flag_wait(&data->csd);
+		if (unlikely(slowpath))
+			smp_call_function_mask_quiesce_stack(allbutself);
+	}
 
 	return 0;
 }
