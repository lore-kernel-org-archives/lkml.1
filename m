Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZA1VNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZA1VNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZA1VNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:13:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbZA1VNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:13:05 -0500
Date: Wed, 28 Jan 2009 13:12:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, peterz@infradead.org, arjan@infradead.org,
       rusty@rustcorp.com.au, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Buggy IPI and MTRR code on low memory
Message-Id: <20090128131202.21757da6.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 11:38:14 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> While developing the RT git tree I came across this deadlock.
> 
> To avoid touching the memory allocator in smp_call_function_many I forced 
> the stack use case, the path that would be taken if data fails to 
> allocate.
> 
> Here's the current code in kernel/smp.c:
> 
> void smp_call_function_many(const struct cpumask *mask,
>                             void (*func)(void *), void *info,
>                             bool wait)
> {
>         struct call_function_data *data;
> [...]
>         data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
>         if (unlikely(!data)) {
>                 /* Slow path. */
>                 for_each_online_cpu(cpu) {
>                         if (cpu == smp_processor_id())
>                                 continue;
>                         if (cpumask_test_cpu(cpu, mask))
>                                 smp_call_function_single(cpu, func, info, 
> wait);
>                 }
>                 return;
>         }
> [...]
> 
> int smp_call_function_single(int cpu, void (*func) (void *info), void 
> *info,
>                              int wait)
> {
>         struct call_single_data d;
> [...]
>                 if (!wait) {
>                         data = kmalloc(sizeof(*data), GFP_ATOMIC);
>                         if (data)
>                                 data->flags = CSD_FLAG_ALLOC;
>                 }
>                 if (!data) {
>                         data = &d;
>                         data->flags = CSD_FLAG_WAIT;
>                 }
> 
> Note that if data failed to allocate, we force the wait state.
> 
> 
> This immediately caused a deadlock with the mtrr code:
> 
>  arch/x86/kernel/cpu/mtrr/main.c:
> 
> static void set_mtrr(unsigned int reg, unsigned long base,
>                      unsigned long size, mtrr_type type)
> {
>         struct set_mtrr_data data;
> [...]
>         /*  Start the ball rolling on other CPUs  */
>         if (smp_call_function(ipi_handler, &data, 0) != 0)
>                 panic("mtrr: timed out waiting for other CPUs\n");
> 
>         local_irq_save(flags);
> 
>         while(atomic_read(&data.count))
>                 cpu_relax();
> 
>         /* ok, reset count and toggle gate */
>         atomic_set(&data.count, num_booting_cpus() - 1);
>         smp_wmb();
>         atomic_set(&data.gate,1);
> 
> [...]
> 
> static void ipi_handler(void *info)
> /*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
>     [RETURNS] Nothing.
> */
> {
> #ifdef CONFIG_SMP
>         struct set_mtrr_data *data = info;
>         unsigned long flags;
> 
>         local_irq_save(flags);
> 
>         atomic_dec(&data->count);
>         while(!atomic_read(&data->gate))
>                 cpu_relax();
> 
> 
> The problem is that if we use the stack, then we must wait for the 
> function to finish. But in the mtrr code, the called functions are waiting 
> for the caller to do something after the smp_call_function. Thus we 
> deadlock! This mtrr code seems to have been there for a while. At least 
> longer than the git history.

My initial reaction is that the mtrr code is being stupid, but I guess
that strengthening the smp_call_function() stuff is good, and we _do_
have this "wait=0" contract.

> To get around this, I did the following hack. Now this may be good 
> enough to handle the case. I'm posting it for comments.
> 
> The patch creates another flag called CSD_FLAG_RELEASE. If we fail
> to alloc the data and the wait bit is not set, we still use the stack
> but we also set this flag instead of the wait flag. The receiving IPI 
> will copy the data locally, and if this flag is set, it will clear it. The 
> caller, after sending the IPI, will wait on this flag to be cleared.
> 
> The difference between this and the wait bit is that the release bit is 
> just a way to let the callee tell the caller that it copied the data and 
> is continuing. The data can be released with no worries. This prevents the 
> deadlock because the caller can continue without waiting for the functions 
> to be called.
> 
> I tested this patch by forcing the data to be null:
> 
> 	data = NULL; // kmalloc(...);
> 
> Also, when forcing data to be NULL on the latest git tree, without 
> applying the patch, I hit a deadlock in testing of the NMI watchdog. This 
> means there may be other areas in the kernel that think smp_call_function, 
> without the wait bit set, expects that function not to ever wait.

Concern 1: do all architectures actually call
generic_smp_call_function_single_interrupt()?  I don't think they
_have_ to at present, and if they don't, we now have inconsistent
behaviour between architectures.

Concern 2: not all architectures set CONFIG_USE_GENERIC_SMP_HELPERS=y. 
Those which do not set CONFIG_USE_GENERIC_SMP_HELPERS might need to
have similar changes made so that the behaviour remains consistent
across architectures.

Thought: do we need to do the kmalloc at all?  Perhaps we can instead
use a statically allocated per-cpu call_single_data local to
kernel/smp.c?  It would need a spinlock or something to protect it...


