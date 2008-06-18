Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbYFRIZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbYFRIZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYFRIZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:25:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50873 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYFRIZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:25:18 -0400
Date: Wed, 18 Jun 2008 10:25:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@osdl.org
Subject: Re: [PATCH -v2] ftrace: disable function tracing bringing up new
	CPU
Message-ID: <20080618082501.GE4135@elte.hu>
References: <Pine.LNX.4.58.0806051648380.13380@gandalf.stny.rr.com> <Pine.LNX.4.58.0806051916190.16872@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0806051916190.16872@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Peter Zijlstra found that taking down and bringing up a new CPU caused 
> ftrace to crash the kernel. This was due to some arch calls that were 
> being traced by the function tracer before the smp_processor_id was 
> set up. Since the function tracer uses smp_processor_id it caused a 
> triple fault.
> 
> Instead of adding notrace all over the architecture code to prevent 
> this problem, it is easier to simply disable the function tracer when 
> bringing up a new CPU.

this patch brought lockdep trouble - see below.

	Ingo

------------------->
calling  pcibios_irq_init+0x0/0x449
PCI: Using IRQ router PIIX/ICH [8086/2440] at 0000:00:1f.0

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc5-00070-g53ec472-dirty #697
-------------------------------------------------------
ftraced/27 is trying to acquire lock:
 (&cpu_hotplug.lock){--..}, at: [<c0125d44>] get_online_cpus+0x31/0x43

but task is already holding lock:
 (ftraced_lock){--..}, at: [<c014f6ad>] ftraced+0x47/0x136

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (ftraced_lock){--..}:
       [<c01412ff>] __lock_acquire+0x9f8/0xb5f
       [<c0141872>] lock_acquire+0x6a/0x90
       [<c06efb64>] mutex_lock_nested+0xdd/0x27a
       [<c014f6ad>] ftraced+0x47/0x136
       [<c0135820>] kthread+0x40/0x68
       [<c0103c27>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (ftrace_sysctl_lock){--..}:
       [<c01412ff>] __lock_acquire+0x9f8/0xb5f
       [<c0141872>] lock_acquire+0x6a/0x90
       [<c06efb64>] mutex_lock_nested+0xdd/0x27a
       [<c014e7ea>] ftrace_disable+0xf/0x25
       [<c06edb43>] _cpu_up+0x8a/0xf1
       [<c06edbf3>] cpu_up+0x49/0x59
       [<c0a3d599>] kernel_init+0x8e/0x264
       [<c0103c27>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (&cpu_hotplug.lock){--..}:
       [<c0141226>] __lock_acquire+0x91f/0xb5f
       [<c0141872>] lock_acquire+0x6a/0x90
       [<c06efb64>] mutex_lock_nested+0xdd/0x27a
       [<c0125d44>] get_online_cpus+0x31/0x43
       [<c0147c34>] stop_machine_run+0x16/0x3d
       [<c014f00a>] ftrace_update_code+0x2f/0x3a
       [<c014f6cc>] ftraced+0x66/0x136
       [<c0135820>] kthread+0x40/0x68
       [<c0103c27>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by ftraced/27:
 #0:  (ftrace_sysctl_lock){--..}, at: [<c014f6a1>] ftraced+0x3b/0x136
 #1:  (ftraced_lock){--..}, at: [<c014f6ad>] ftraced+0x47/0x136

stack backtrace:
Pid: 27, comm: ftraced Not tainted 2.6.26-rc5-00070-g53ec472-dirty #697
 [<c013f6b1>] print_circular_bug_tail+0x5b/0x66
 [<c013ef59>] ? print_circular_bug_entry+0x39/0x43
 [<c0141226>] __lock_acquire+0x91f/0xb5f
 [<c0141872>] lock_acquire+0x6a/0x90
 [<c0125d44>] ? get_online_cpus+0x31/0x43
 [<c06efb64>] mutex_lock_nested+0xdd/0x27a
 [<c0125d44>] ? get_online_cpus+0x31/0x43
 [<c0125d44>] ? get_online_cpus+0x31/0x43
 [<c014ec54>] ? __ftrace_update_code+0x0/0x12e
 [<c0125d44>] get_online_cpus+0x31/0x43
 [<c0147c34>] stop_machine_run+0x16/0x3d
 [<c014f666>] ? ftraced+0x0/0x136
 [<c014f00a>] ftrace_update_code+0x2f/0x3a
 [<c014f6cc>] ftraced+0x66/0x136
 [<c014f666>] ? ftraced+0x0/0x136
 [<c0135820>] kthread+0x40/0x68
 [<c01357e0>] ? kthread+0x0/0x68
 [<c0103c27>] kernel_thread_helper+0x7/0x10
 =======================
PCI->APIC IRQ transform: 0000:00:1f.2[D] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1f.3[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:1f.4[C] -> IRQ 23
PCI->APIC IRQ transform: 0000:00:1f.5[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 22
PCI->APIC IRQ transform: 0000:03:04.0[A] -> IRQ 18
