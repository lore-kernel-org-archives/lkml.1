Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbYBMTgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbYBMTgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYBMTfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:35:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58525 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbYBMTfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:35:51 -0500
Date: Wed, 13 Feb 2008 20:35:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: print_vma_addr possible deadlock (was Re: Jeste jeden bug)
Message-ID: <20080213193538.GA16402@elte.hu>
References: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com> <Pine.LNX.4.64.0802131749460.30955@jikos.suse.cz> <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> > > [   68.379054]
> > > [   68.379056] Call Trace:
> > > [   68.379061]  <#DB>  [<ffffffff81064883>] ? __debug_show_held_locks+0x13/0x30
> > > [   68.379109]  [<ffffffff81036765>] __might_sleep+0xe5/0x110
> > > [   68.379123]  [<ffffffff812f2240>] down_read+0x20/0x70
> > > [   68.379137]  [<ffffffff8109cdca>] print_vma_addr+0x3a/0x110
> > > [   68.379152]  [<ffffffff8100f435>] do_trap+0xf5/0x170
> > > [   68.379168]  [<ffffffff8100f52b>] do_int3+0x7b/0xe0
> > > [   68.379180]  [<ffffffff812f4a6f>] int3+0x9f/0xd0
> > > [   68.379203]  <<EOE>>
> > > [   68.379229]  in libglib-2.0.so.0.1505.0[3d2c800000+dc000]

ouch. Could you try the fix below? This makes print_vma_addr() more 
robust and should fix the immediate bug.

The longer-term fix will be to not run int3 exception handlers in a 
non-preemptible context (like 32-bit does) - but that will need more 
testing.

	Ingo

---------------->
Subject: x86: fix "BUG: sleeping function called from invalid context" in print_vma_addr()
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Feb 13 20:21:06 CET 2008

Jiri Kosina reported the following deadlock scenario with
show_unhandled_signals enabled:

 [   68.379022] gnome-settings-[2941] trap int3 ip:3d2c840f34
 sp:7fff36f5d100 error:0<3>BUG: sleeping function called from invalid
 context at kernel/rwsem.c:21
 [   68.379039] in_atomic():1, irqs_disabled():0
 [   68.379044] no locks held by gnome-settings-/2941.
 [   68.379050] Pid: 2941, comm: gnome-settings- Not tainted 2.6.25-rc1 #30
 [   68.379054]
 [   68.379056] Call Trace:
 [   68.379061]  <#DB>  [<ffffffff81064883>] ? __debug_show_held_locks+0x13/0x30
 [   68.379109]  [<ffffffff81036765>] __might_sleep+0xe5/0x110
 [   68.379123]  [<ffffffff812f2240>] down_read+0x20/0x70
 [   68.379137]  [<ffffffff8109cdca>] print_vma_addr+0x3a/0x110
 [   68.379152]  [<ffffffff8100f435>] do_trap+0xf5/0x170
 [   68.379168]  [<ffffffff8100f52b>] do_int3+0x7b/0xe0
 [   68.379180]  [<ffffffff812f4a6f>] int3+0x9f/0xd0
 [   68.379203]  <<EOE>>
 [   68.379229]  in libglib-2.0.so.0.1505.0[3d2c800000+dc000]

and tracked it down to:

  commit 03252919b79891063cf99145612360efbdf9500b
  Author: Andi Kleen <ak@suse.de>
  Date:   Wed Jan 30 13:33:18 2008 +0100

      x86: print which shared library/executable faulted in segfault etc. messages

the problem is that we call down_read() from an atomic context.

Solve this by returning from print_vma_addr() if the preempt count is
elevated. Update preempt_conditional_sti / preempt_conditional_cli to
unconditionally lift the preempt count even on !CONFIG_PREEMPT.

Reported-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/traps_64.c |    4 ++--
 mm/memory.c                |    7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/traps_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/traps_64.c
+++ linux-x86.q/arch/x86/kernel/traps_64.c
@@ -84,7 +84,7 @@ static inline void conditional_sti(struc
 
 static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
-	preempt_disable();
+	inc_preempt_count();
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -95,7 +95,7 @@ static inline void preempt_conditional_c
 		local_irq_disable();
 	/* Make sure to not schedule here because we could be running
 	   on an exception stack. */
-	preempt_enable_no_resched();
+	dec_preempt_count();
 }
 
 int kstack_depth_to_print = 12;
Index: linux-x86.q/mm/memory.c
===================================================================
--- linux-x86.q.orig/mm/memory.c
+++ linux-x86.q/mm/memory.c
@@ -2711,6 +2711,13 @@ void print_vma_addr(char *prefix, unsign
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 
+	/*
+	 * Do not print if we are in atomic
+	 * contexts (in exception stacks, etc.):
+	 */
+	if (preempt_count())
+		return;
+
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, ip);
 	if (vma && vma->vm_file) {

