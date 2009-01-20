Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbZATIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbZATIS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZATIST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:18:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZATISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:18:17 -0500
Date: Tue, 20 Jan 2009 09:17:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Nick Piggin <npiggin@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
Message-ID: <20090120081759.GA30394@elte.hu>
References: <49756F44.6040801@cn.fujitsu.com> <20090120075440.GA29426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120075440.GA29426@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > I was using mmotm 2009-01-16-16-18, and I ran into this BUG,
> > the line is:
> > 	BUG_ON(cpumask_empty(cpumask));
> > 
> > I suspect it is caused by:
> > 
> > commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
> > Author: Rusty Russell <rusty@rustcorp.com.au>
> > Date:   Sat Jan 10 21:58:09 2009 -0800
> > 
> >     x86: change flush_tlb_others to take a const struct cpumask
> > 
> >     Impact: reduce stack usage, use new cpumask API.
> 
> Jaswinder reported a similar crash.
> 
> Mike, Rusty, what's going on with this commit? Why does this code:
> 
> +       if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
> +               flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
> 
> Assume that mm->cpu_vm_mask wont change? TLB flushes go async and the 
> MM's schedulability is not locked during that. I.e. mm->cpu_vm_mask can 
> change under you while the TLB flush IPIs are flying around - while when 
> the cpumask was passed on-stack this wouldnt happen.

okay, a testsystem of mine just triggered this crash too.

Li Zefan, Jaswinder, does the patch below fix it for you?

	Ingo

--------------->
>From 5766b842b23c6b40935a5f3bd435b2bcdaff2143 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Jan 2009 09:13:15 +0100
Subject: [PATCH] x86, cpumask: fix tlb flush race

Impact: fix bootup crash

The cpumask is now passed in as a reference to mm->cpu_vm_mask, not on
the stack - hence it is not constant anymore during the TLB flush.

That way it could race and some static sanity checks would trigger:

[  238.154287] ------------[ cut here ]------------
[  238.156039] kernel BUG at arch/x86/kernel/tlb_32.c:130!
[  238.156039] invalid opcode: 0000 [#1] SMP
[  238.156039] last sysfs file: /sys/class/net/eth2/address
[  238.156039] Modules linked in:
[  238.156039]
[  238.156039] Pid: 6493, comm: ifup-eth Not tainted (2.6.29-rc2-tip #1) P4DC6
[  238.156039] EIP: 0060:[<c0118f87>] EFLAGS: 00010202 CPU: 2
[  238.156039] EIP is at native_flush_tlb_others+0x35/0x158
[  238.156039] EAX: c0ef972c EBX: f6143301 ECX: 00000000 EDX: 00000000
[  238.156039] ESI: f61433a8 EDI: f6143200 EBP: f34f3e00 ESP: f34f3df0
[  238.156039]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  238.156039] Process ifup-eth (pid: 6493, ti=f34f2000 task=f399ab00 task.ti=f34f2000)
[  238.156039] Stack:
[  238.156039]  ffffffff f61433a8 ffffffff f6143200 f34f3e18 c0118e9c 00000000 f6143200
[  238.156039]  f61433a8 f5bec738 f34f3e28 c0119435 c2b5b830 f6143200 f34f3e34 c01c2dc3
[  238.156039]  bffd9000 f34f3e60 c01c3051 00000000 ffffffff f34f3e4c 00000000 00000071
[  238.156039] Call Trace:
[  238.156039]  [<c0118e9c>] ? flush_tlb_others+0x52/0x5b
[  238.156039]  [<c0119435>] ? flush_tlb_mm+0x7f/0x8b
[  238.156039]  [<c01c2dc3>] ? tlb_finish_mmu+0x2d/0x55
[  238.156039]  [<c01c3051>] ? exit_mmap+0x124/0x170
[  238.156039]  [<c013e965>] ? mmput+0x40/0xf5
[  238.156039]  [<c01e4788>] ? flush_old_exec+0x640/0x94b
[  238.156039]  [<c01ddb4e>] ? fsnotify_access+0x37/0x39
[  238.156039]  [<c01e3435>] ? kernel_read+0x39/0x4b
[  238.156039]  [<c021bc8a>] ? load_elf_binary+0x4a1/0x11bb
[  238.156039]  [<c01c0af9>] ? might_fault+0x51/0x9c
[  238.156039]  [<c010a2cc>] ? paravirt_read_tsc+0x20/0x4f
[  238.156039]  [<c010a406>] ? native_sched_clock+0x5d/0x60
[  238.156039]  [<c01e2fda>] ? search_binary_handler+0xab/0x2c4
[  238.156039]  [<c021b7e9>] ? load_elf_binary+0x0/0x11bb
[  238.156039]  [<c04ae9a5>] ? _raw_read_unlock+0x21/0x46
[  238.156039]  [<c021b7e9>] ? load_elf_binary+0x0/0x11bb
[  238.156039]  [<c01e2fe1>] ? search_binary_handler+0xb2/0x2c4
[  238.156039]  [<c01e4076>] ? do_execve+0x21c/0x2ee
[  238.156039]  [<c01029b7>] ? sys_execve+0x51/0x8c
[  238.156039]  [<c0103eaf>] ? sysenter_do_call+0x12/0x43

Fix it by not assuming that the cpumask is constant.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_32.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index ec53818..d37bbfc 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -125,9 +125,8 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 			     struct mm_struct *mm, unsigned long va)
 {
 	/*
-	 * - mask must exist :)
+	 * mm must exist :)
 	 */
-	BUG_ON(cpumask_empty(cpumask));
 	BUG_ON(!mm);
 
 	/*
@@ -138,14 +137,18 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	spin_lock(&tlbstate_lock);
 
 	cpumask_andnot(flush_cpumask, cpumask, cpumask_of(smp_processor_id()));
-#ifdef CONFIG_HOTPLUG_CPU
-	/* If a CPU which we ran on has gone down, OK. */
 	cpumask_and(flush_cpumask, flush_cpumask, cpu_online_mask);
+
+	/*
+	 * If a task whose mm mask we are looking at has descheduled and
+	 * has cleared its presence from the mask, or if a CPU which we ran
+	 * on has gone down then there might be no flush work left:
+	 */
 	if (unlikely(cpumask_empty(flush_cpumask))) {
 		spin_unlock(&tlbstate_lock);
 		return;
 	}
-#endif
+
 	flush_mm = mm;
 	flush_va = va;
 
