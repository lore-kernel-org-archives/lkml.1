Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbYDVNKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbYDVNKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758953AbYDVNKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:10:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58481 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbYDVNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:10:18 -0400
Subject: Re: [Bug 10489] Kprobe smoke test lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       bugme-daemon@bugzilla.kernel.org,
       jean-marc LACROIX <jeanmarc.lacroix@free.Fr>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <480D1B14.7070806@redhat.com>
References: <20080421150656.GJ6011@cs181133002.pp.htv.fi>
	 <480D1B14.7070806@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 15:09:30 +0200
Message-Id: <1208869770.7115.265.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 18:54 -0400, Masami Hiramatsu wrote:
> Thank you for reporting.
> 
> Actually, kprobes tries to fixup thread's flags in post_kprobe_handler
> (which is called from kprobe_exceptions_notify) by
> trace_hardirqs_fixup_flags(pt_regs->flags). However, even the irq flag
> is set in pt_regs->flags, true hardirq is still off until returning
> from do_debug. Thus, lockdep assumes that hardirq is off without annotation.
> 
> IMHO, one possible solution is that fixing hardirq flags right after
> notify_die in do_debug instead of in post_kprobe_handler.

My reply to BZ 10489:


> [    2.707509] Kprobe smoke test started
> [    2.709300] ------------[ cut here ]------------
> [    2.709420] WARNING: at kernel/lockdep.c:2658 check_flags+0x4d/0x12c()
> [    2.709541] Modules linked in:
> [    2.709588] Pid: 1, comm: swapper Not tainted 2.6.25.jml.057 #1
> [    2.709588]  [<c0126acc>] warn_on_slowpath+0x41/0x51
> [    2.709588]  [<c010bafc>] ? save_stack_trace+0x1d/0x3b
> [    2.709588]  [<c0140a83>] ? save_trace+0x37/0x89
> [    2.709588]  [<c011987d>] ? kernel_map_pages+0x103/0x11c
> [    2.709588]  [<c0109803>] ? native_sched_clock+0xca/0xea
> [    2.709588]  [<c0142958>] ? mark_held_locks+0x41/0x5c
> [    2.709588]  [<c0382580>] ? kprobe_exceptions_notify+0x322/0x3af
> [    2.709588]  [<c0142aff>] ? trace_hardirqs_on+0xf1/0x119
> [    2.709588]  [<c03825b3>] ? kprobe_exceptions_notify+0x355/0x3af
> [    2.709588]  [<c0140823>] check_flags+0x4d/0x12c
> [    2.709588]  [<c0143c9d>] lock_release+0x58/0x195
> [    2.709588]  [<c038347c>] ? __atomic_notifier_call_chain+0x0/0x80
> [    2.709588]  [<c03834d6>] __atomic_notifier_call_chain+0x5a/0x80
> [    2.709588]  [<c0383508>] atomic_notifier_call_chain+0xc/0xe
> [    2.709588]  [<c013b6d4>] notify_die+0x2d/0x2f
> [    2.709588]  [<c038168a>] do_debug+0x67/0xfe
> [    2.709588]  [<c0381287>] debug_stack_correct+0x27/0x30
> [    2.709588]  [<c01564c0>] ? kprobe_target+0x1/0x34
> [    2.709588]  [<c0156572>] ? init_test_probes+0x50/0x186
> [    2.709588]  [<c04fae48>] init_kprobes+0x85/0x8c
> [    2.709588]  [<c04e947b>] kernel_init+0x13d/0x298
> [    2.709588]  [<c04e933e>] ? kernel_init+0x0/0x298
> [    2.709588]  [<c04e933e>] ? kernel_init+0x0/0x298
> [    2.709588]  [<c0105ef7>] kernel_thread_helper+0x7/0x10
> [    2.709588]  =======================
> [    2.709588] ---[ end trace 778e504de7e3b1e3 ]---
> [    2.709588] possible reason: unannotated irqs-off.
> [    2.709588] irq event stamp: 370065
> [    2.709588] hardirqs last  enabled at (370065): [<c0382580>] kprobe_exceptions_notify+0x322/0x3af
> [    2.709588] hardirqs last disabled at (370064): [<c0381bb7>] do_int3+0x1d/0x7d
> [    2.709588] softirqs last  enabled at (370050): [<c012b464>] __do_softirq+0xfa/0x100
> [    2.709588] softirqs last disabled at (370045): [<c0107438>] do_softirq+0x74/0xd9
> [    2.714751] Kprobe smoke test passed successfully

how I love this stuff...


Ok, do_debug() is a trap, this can happen at any time regardless of the
machine's IRQ state. So the first thing we do is fix up the IRQ state.
Then we call this die notifier stuff; and return with messed up IRQ
state... YAY.

So, kprobes fudges it..

  notify_die(DIE_DEBUG)
    kprobe_exceptions_notify()
      post_kprobe_handler()
        modify regs->flags
        trace_hardirqs_fixup_flags(regs->flags);  <--- must be it

So what's the use of modifying flags if they're not meant to take effect
at some point.

/me tries to reproduce issue; enable kprobes test thingy && boot

OK, that reproduces..

So the below makes it work - but I'm not getting this code; at the time
I wrote that stuff I CC'ed each and every kprobe maintainer listed in
the usual places but got no reposonse - can some please explain this
stuff to me?

Are the saved flags only for the TF bit or are they made in full effect
later (and if so, where) ?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 34a5912..fe71e64 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -865,7 +865,6 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 
        resume_execution(cur, regs, kcb);
        regs->flags |= kcb->kprobe_saved_flags;
-       trace_hardirqs_fixup_flags(regs->flags);
 
        /* Restore back the original saved kprobes variables and continue. */
        if (kcb->kprobe_status == KPROBE_REENTER) {



