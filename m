Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZDUQWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZDUQWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZDUQW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:22:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48556 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZDUQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:22:25 -0400
Date: Tue, 21 Apr 2009 12:22:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] ring-buffer: only warn on wrap if buffer is
 bigger than two pages
In-Reply-To: <20090421143509.GA5243@elte.hu>
Message-ID: <alpine.DEB.2.00.0904211208490.10097@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904210954090.10097@gandalf.stny.rr.com> <20090421143509.GA5243@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Apr 2009, Ingo Molnar wrote:

> 
> here's a new one:
> 
>  Testing event sched_kthread_stop: <4>------------[ cut here ]------------
>  WARNING: at kernel/fork.c:988 copy_process+0x147/0xf7d()
>  Modules linked in:
> 
> config attached, bootlog below. This warning has the signs of some 
> sort of lockdep interaction. (this too is a new one - it never 
> triggered before)
> 
> 	Ingo
> 

> Testing event sched_process_fork: OK

Interesting, with your config I hit the bug here. But it was the 
hardirqs_enabled that was hit (was that the same you had?)

I noticed that you do not have the DEBUG_LOCKDEP set. I turned it on and 
it booted fine :-/

-- Steve

> Testing event sched_signal_send: OK
> Running tests on trace event systems:
> Testing event system skb: OK
> Testing event system kmem: OK
> Testing event system irq: OK
> Testing event system lockdep: OK
> Testing event system sched: OK
> Running tests on all trace events:
> Testing all events: OK
> Running tests again, along with the function tracer
> Running tests on trace events:
> Testing event kfree_skb: OK
> Testing event kmalloc: OK
> Testing event kmem_cache_alloc: OK
> Testing event kmalloc_node: OK
> Testing event kmem_cache_alloc_node: OK
> Testing event kfree: OK
> Testing event kmem_cache_free: OK
> Testing event irq_handler_exit: OK
> Testing event irq_handler_entry: OK
> Testing event softirq_entry: OK
> Testing event softirq_exit: OK
> Testing event lock_acquired: OK
> Testing event lock_acquire: OK
> Testing event lock_release: OK
> Testing event lock_contended: OK
> Testing event sched_kthread_stop: <4>------------[ cut here ]------------
> WARNING: at kernel/fork.c:988 copy_process+0x147/0xf7d()
> Modules linked in:
> Pid: 2, comm: kthreadd Not tainted 2.6.30-rc2-tip-01581-gf4879a9-dirty #34509
> Call Trace:
>  [<ffffffff80249801>] warn_slowpath+0x96/0xca
>  [<ffffffff8026f200>] ? trace_hardirqs_on_caller+0xff/0x14c
>  [<ffffffff8026f25a>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff80261cb6>] ? __mutex_init+0x5a/0x64
>  [<ffffffff802accdf>] ? perf_counter_init_task+0x65/0x17b
>  [<ffffffff80247ca6>] copy_process+0x147/0xf7d
>  [<ffffffff80211d57>] ? trace+0x3a/0x73
>  [<ffffffff80248c7b>] do_fork+0x19f/0x478
>  [<ffffffff8025f03c>] ? kthreadd+0xb8/0x11c
>  [<ffffffff80212f12>] kernel_thread+0x82/0xe0
>  [<ffffffff808cbad4>] ? schedule+0x11f/0x5e1
>  [<ffffffff8025f0a0>] ? kthread+0x0/0x80
>  [<ffffffff80212f70>] ? child_rip+0x0/0x20
>  [<ffffffff8025f050>] ? kthreadd+0xcc/0x11c
>  [<ffffffff80fde140>] ? early_idt_handler+0x0/0x71
>  [<ffffffff80212f7a>] child_rip+0xa/0x20
>  [<ffffffff80212a52>] ? restore_args+0x0/0x30
>  [<ffffffff8025ef84>] ? kthreadd+0x0/0x11c
>  [<ffffffff80212f70>] ? child_rip+0x0/0x20
> ---[ end trace 0843ba422c5d704e ]---
> OK
> Testing event sched_kthread_stop_ret: OK
> Testing event sched_wait_task: OK
> Testing event sched_wakeup: OK
> Testing event sched_wakeup_new: OK
> Testing event sched_switch: OK
> Testing event sched_migrate_task: OK
> Testing event sched_process_free: OK
> Testing event sched_process_exit: OK
> Testing event sched_process_wait: OK
> Testing event sched_process_fork: OK
> Testing event sched_signal_send: OK
> Running tests on trace event systems:
> Testing event system skb: OK
> Testing event system kmem: OK
> Testing event system irq: OK
> Testing event system lockdep: OK
> Testing event system sched: OK
> Running tests on all trace events:
> Testing all events: OK
> initcall event_trace_self_tests_init+0x0/0x38 returned 0 after 444440 usecs
> calling  fail_page_alloc_debugfs+0x0/0xe4 @ 1
> initcall fail_page_alloc_debugfs+0x0/0xe4 returned 0 after 78 usecs
> calling  max_swapfiles_check+0x0/0x8 @ 1
> initcall max_swapfiles_check+0x0/0x8 returned 0 after 1 usecs
> 
