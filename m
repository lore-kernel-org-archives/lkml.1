Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYC1UZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYC1UZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYC1UZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:25:12 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:48177 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756783AbYC1UZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:25:09 -0400
Date: Fri, 28 Mar 2008 22:25:00 +0200
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com
Subject: mmiotrace bug: recursive probe hit
Message-ID: <20080328222500.21863a44@daedalus.pq.iki.fi>
In-Reply-To: <20080309164050.2194461e@daedalus.pq.iki.fi>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

jb17some reported a recursive probe hit when mmiotracing the nvidia
proprietary driver (the blob) on SMP. I'll introduce the basic mechanisms
in mmiotrace, provide some test results and then ask the question:
Why does disarm_kmmio_fault_page() occasionally not do its job on SMP?

Mmiotrace works by hooking into __ioremap() and marks the returned pages
as not present. Any access to these pages, specifically memory mapped IO
access, triggers a page fault. The fault handler, kmmio_handler(), marks
the hit page as present by calling disarm_kmmio_fault_page(), and sets
the TR flag. It also clears IF flag to prevent interrupts being enabled
when returning from the fault. The faulting instruction is re-executed,
this time without a fault, and the debug trap is hit. The debug trap
handler, post_kmmio_handler() re-arms the page and restores cpu flags.

kmmio_handler() and post_kmmio_handler() need to share some state, and
they must be called strictly in pairs, hence clearing IF and holding locks
from the first handler to the second. This is a per-cpu requirement,
different cpus are allowed to run concurrently here.

Here is the relevant code, quoted from my preview 2 email.

> +/** Mark the given page as not present. Access to it will trigger a fault. */
> +static void arm_kmmio_fault_page(unsigned long page, int *page_level)
> +{
> +	unsigned long address = page & PAGE_MASK;
> +	int level;
> +	pte_t *pte = lookup_address(address, &level);
> +
> +	if (!pte) {
> +		pr_err("kmmio: Error in %s: no pte for page 0x%08lx\n",
> +							__func__, page);
> +		return;
> +	}
> +
> +	if (level == PG_LEVEL_2M) {
> +		pmd_t *pmd = (pmd_t *)pte;
> +		set_pmd(pmd, __pmd(pmd_val(*pmd) & ~_PAGE_PRESENT));
> +	} else {
> +		/* PG_LEVEL_4K */
> +		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
> +	}
> +
> +	if (page_level)
> +		*page_level = level;
> +
> +	__flush_tlb_one(page);
> +}
> +
> +/** Mark the given page as present. */
> +static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
> +{
> +	unsigned long address = page & PAGE_MASK;
> +	int level;
> +	pte_t *pte = lookup_address(address, &level);
> +
> +	if (!pte) {
> +		pr_err("kmmio: Error in %s: no pte for page 0x%08lx\n",
> +							__func__, page);
> +		return;
> +	}
> +
> +	if (level == PG_LEVEL_2M) {
> +		pmd_t *pmd = (pmd_t *)pte;
> +		set_pmd(pmd, __pmd(pmd_val(*pmd) | _PAGE_PRESENT));
> +	} else {
> +		/* PG_LEVEL_4K */
> +		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
> +	}
> +
> +	if (page_level)
> +		*page_level = level;
> +
> +	__flush_tlb_one(page);
> +}
> +
> +/*
> + * This is being called from do_page_fault().
> + *
> + * We may be in an interrupt or a critical section. Also prefecthing may
> + * trigger a page fault. We may be in the middle of process switch.
> + * We cannot take any locks, because we could be executing especially
> + * within a kmmio critical section.
> + *
> + * Local interrupts are disabled, so preemption cannot happen.
> + * Do not enable interrupts, do not sleep, and watch out for other CPUs.
> + */
> +/*
> + * Interrupts are disabled on entry as trap3 is an interrupt gate
> + * and they remain disabled thorough out this function.
> + */
> +int kmmio_handler(struct pt_regs *regs, unsigned long addr)
> +{
> +	struct kmmio_context *ctx;
> +	struct kmmio_fault_page *faultpage;
> +
> +	/*
> +	 * Preemption is now disabled to prevent process switch during
> +	 * single stepping. We can only handle one active kmmio trace
> +	 * per cpu, so ensure that we finish it before something else
> +	 * gets to run. We also hold the RCU read lock over single
> +	 * stepping to avoid looking up the probe and kmmio_fault_page
> +	 * again.
> +	 */
> +	preempt_disable();
> +	rcu_read_lock();
> +
> +	faultpage = get_kmmio_fault_page(addr);
> +	if (!faultpage) {
> +		/*
> +		 * Either this page fault is not caused by kmmio, or
> +		 * another CPU just pulled the kmmio probe from under
> +		 * our feet. In the latter case all hell breaks loose.
> +		 */
> +		goto no_kmmio;
> +	}
> +
> +	ctx = &get_cpu_var(kmmio_ctx);
> +	if (ctx->active) {
> +		/*
> +		 * Prevent overwriting already in-flight context.
> +		 * If this page fault really was due to kmmio trap,
> +		 * all hell breaks loose.
> +		 */
> +		pr_emerg("kmmio: recursive probe hit on CPU %d, "
> +					"for address 0x%08lx. Ignoring.\n",
> +					smp_processor_id(), addr);
> +		goto no_kmmio_ctx;
> +	}
> +	ctx->active++;
> +
> +	ctx->fpage = faultpage;
> +	ctx->probe = get_kmmio_probe(addr);
> +	ctx->saved_flags = (regs->flags & (TF_MASK|IF_MASK));
> +	ctx->addr = addr;
> +
> +	if (ctx->probe && ctx->probe->pre_handler)
> +		ctx->probe->pre_handler(ctx->probe, regs, addr);
> +
> +	/*
> +	 * Enable single-stepping and disable interrupts for the faulting
> +	 * context. Local interrupts must not get enabled during stepping.
> +	 */
> +	regs->flags |= TF_MASK;
> +	regs->flags &= ~IF_MASK;
> +
> +	/* Now we set present bit in PTE and single step. */
> +	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
> +
> +	/*
> +	 * If another cpu accesses the same page while we are stepping,
> +	 * the access will not be caught. It will simply succeed and the
> +	 * only downside is we lose the event. If this becomes a problem,
> +	 * the user should drop to single cpu before tracing.
> +	 */
> +
> +	put_cpu_var(kmmio_ctx);
> +	return 1;
> +
> +no_kmmio_ctx:
> +	put_cpu_var(kmmio_ctx);
> +no_kmmio:
> +	rcu_read_unlock();
> +	preempt_enable_no_resched();
> +	return 0; /* page fault not handled by kmmio */
> +}
> +
> +/*
> + * Interrupts are disabled on entry as trap1 is an interrupt gate
> + * and they remain disabled thorough out this function.
> + * This must always get called as the pair to kmmio_handler().
> + */
> +static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
> +{
> +	int ret = 0;
> +	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
> +
> +	if (!ctx->active)
> +		goto out;
> +
> +	if (ctx->probe && ctx->probe->post_handler)
> +		ctx->probe->post_handler(ctx->probe, condition, regs);
> +
> +	arm_kmmio_fault_page(ctx->fpage->page, NULL);
> +
> +	regs->flags &= ~TF_MASK;
> +	regs->flags |= ctx->saved_flags;
> +
> +	/* These were acquired in kmmio_handler(). */
> +	ctx->active--;
> +	BUG_ON(ctx->active);
> +	rcu_read_unlock();
> +	preempt_enable_no_resched();
> +
> +	/*
> +	 * if somebody else is singlestepping across a probe point, flags
> +	 * will have TF set, in which case, continue the remaining processing
> +	 * of do_debug, as if this is not a probe hit.
> +	 */
> +	if (!(regs->flags & TF_MASK))
> +		ret = 1;
> +out:
> +	put_cpu_var(kmmio_ctx);
> +	return ret;
> +}

A recursive probe hit means that kmmio_handler() is called twice without a
a call to post_kmmio_handler() in between. This situation is explicitly
checked for (if (ctx->active)), and the current solution is to ignore the
fault and fall through to do_page_fault() triggering an error there.
According to experience, this does not happen on a uniprocessor machine.

However, on an SMP machine this can occasionally occur. I have reproduced
it on my Core 2 Duo laptop while tracing the blob. Recursive probe hit
is very rare compared to the events logged, I can run two glxgears at the
same time for half an hour generating at least millions of events and never
hit it. Repeatedly start and stop a single glxgears, and I have a fairly
good chance of hitting it. It is random, but reproducible.

Here is a kernel oops log via netconsole:

kmmio: recursive probe hit on CPU 0, for address 0xffffc20004500140. Ignoring.
BUG: unable to handle kernel paging request at ffffc20004500140
IP: [<ffffffffa04e7b38>] :nvidia:_nv003832rm+0x1d/0x22
PGD 3e8d9067 PUD 3e8da067 PMD 3cd58067 PTE 80000000d600017a
Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0 
Modules linked in: nvidia(P) netconsole snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss sha256_generic cpufreq_stats
acpi_cpufreq video output fan button arc4 ecb snd_hda_intel snd_pcm snd_timer
snd snd_page_alloc iwl4965 mac80211 ehci_hcd uhci_hcd usbcore ohci1394
ieee1394 psmouse e1000 pcspkr sg i2c_i801 i2c_core yenta_socket
rsrc_nonstatic [last unloaded: nvidia]
Pid: 0, comm: swapper Tainted: P	 2.6.25-rc6-sched-devel.git-x86-latest.git #2
RIP: 0010:[<ffffffffa04e7b38>]  [<ffffffffa04e7b38>] :nvidia:_nv003832rm+0x1d/0x22
RSP: 0018:ffffffff806cfe38  EFLAGS: 00010106
RAX: 0000000000000050 RBX: ffff810019a49000 RCX: 0000000000000140
RDX: ffffc20004500000 RSI: ffff810019a49000 RDI: ffff81001ae5a7f0
RBP: ffff810019b1f148 R08: ffff81001ad6a000 R09: ffffffff806cfe18
R10: ffffffff80428f60 R11: ffff81003cc63140 R12: ffff81001ae5a7f0
R13: 0000000000000140 R14: 0000000000000001 R15: ffff8100194b3000
FS:  0000000000000000(0000) GS:ffffffff80662000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffc20004500140 CR3: 000000001af2a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff80684000, task ffffffff8061f4e0)
Stack:  ffffffffa03b978e ffff810019a49000 ffff81001ad6ebf0 ffffc200040b0000
 0000000000000001 ffff8100194b3000 ffffffffa04e8655 ffffc200040b0000
 ffff810019a49000 ffffc200040b0000 ffff810019b1c180 ffffffff806cff18
Call Trace:
 <IRQ>  [<ffffffffa03b978e>] ? :nvidia:_nv008123rm+0x2a/0xc7
 [<ffffffffa04e8655>] ? :nvidia:_nv003822rm+0x163/0x256
 [<ffffffffa04e6b82>] ? :nvidia:_nv003815rm+0x4f/0x76
 [<ffffffffa04edc13>] ? :nvidia:rm_isr+0xaa/0x10a
 [<ffffffffa059ac61>] ? :nvidia:nv_kern_isr+0x7d/0xb1
 [<ffffffff8025f567>] ? handle_IRQ_event+0x20/0x55
 [<ffffffff802609c5>] ? handle_fasteoi_irq+0x9c/0xdc
 [<ffffffff8020e95a>] ? do_IRQ+0x105/0x17f
 [<ffffffff8020b7e6>] ? ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80421c12>] ? poll_idle+0x16/0x63
 [<ffffffff80421c17>] ? poll_idle+0x1b/0x63
 [<ffffffff80421c12>] ? poll_idle+0x16/0x63
 [<ffffffff80422039>] ? cpuidle_idle_call+0x7e/0xad
 [<ffffffff80421fbb>] ? cpuidle_idle_call+0x0/0xad
 [<ffffffff8020a1f5>] ? cpu_idle+0x92/0xd0
 [<ffffffff804c6025>] ? rest_init+0x69/0x6b

Code: 89 c8 d1 e8 89 c0 0f b7 04 42 0f b7 c0 c3 89 d1 b8 00 00 00 00 39 96
0c 02 00 00 76 11 48 8b 96 40 02 00 00 89 c8 c1 e8 02 89 c0 <8b> 04 82 f3
c3 39 96 14 02 00 00 76 0c 89 d2 48 8b 86 58 02 00 
RIP  [<ffffffffa04e7b38>] :nvidia:_nv003832rm+0x1d/0x22
 RSP <ffffffff806cfe38>
CR2: ffffc20004500140
---[ end trace 0a8c36f3081eaf7e ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!


Next, after discussion with Enberg and Nossum, I tried the following patch:

@@ -272,6 +272,9 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
                pr_emerg("kmmio: recursive probe hit on CPU %d, "
                                        "for address 0x%08lx. Ignoring.\n",
                                        smp_processor_id(), addr);
+               pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
+                                       ctx->addr);
+               disarm_kmmio_fault_page(faultpage->page, NULL);
                goto no_kmmio_ctx;
        }
        ctx->active++;
@@ -322,8 +325,11 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
        int ret = 0;
        struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
-       if (!ctx->active)
+       if (!ctx->active) {
+               pr_notice("kmmio: spurious debug trap on CPU %d.\n",
+                                       smp_processor_id());
                goto out;
+       }

The result is occasional two lines:

kmmio: recursive probe hit on CPU 1, for address 0xffffc20004400140. Ignoring.
kmmio: previous hit was at 0xffffc20004400140.

The addresses vary, but are always the same for a pair of lines.
The "spurious debug trap" is never seen, and no kernel oopses. Note, that I
(unintentionally) still fall through to do_page_fault() after disarming.

Hypothesis 1:
Something gets to run on this cpu between exiting kmmio_handler() and
entering post_kmmio_handler(), and it triggers a new kmmio probe hit.
This is unlikely, as there should be a spurious debug trap afterwards.

Hypothesis 2:
disarm_kmmio_fault_page() does not work.
But it works most of the time, and on UP it seems to work always.

If hypothesis 2 is true, when the faulted instruction is re-executed,
it faults again. This is supported by the fault address being the same
at both times.

Could something else (apart from NMI) get to run in between fault and
debug handlers?

Is there something wrong in arm/disarm_kmmio_fault_page() functions?
Could it be a race between cpus?
Does the fall through to do_page_fault() trigger a proper fix to page
tables in case my disarming is bad?
Is the debugging hack an acceptable workaround?

I hope using a binary blob as a test case does not offend anyone, but
the main purpose of mmiotrace is to reverse engineer binary blobs.

I would appreciate any insight to the problem.


Thanks,
Pekka.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
