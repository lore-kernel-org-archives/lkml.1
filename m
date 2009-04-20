Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZDTTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZDTTnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZDTTnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:43:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZDTTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:43:22 -0400
Date: Mon, 20 Apr 2009 15:43:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
In-Reply-To: <20090420192917.GB25629@elte.hu>
Message-ID: <alpine.DEB.2.00.0904201540400.26147@gandalf.stny.rr.com>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192917.GB25629@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Apr 2009, Ingo Molnar wrote:
> Running tests on all trace events:
> Testing all events: <4>Tracing recursion: HC[0]:SC[0]:NMI[0]

Recursion is wrong :-/

> ------------[ cut here ]------------
> WARNING: at kernel/trace/ring_buffer.c:1510 ring_buffer_lock_reserve+0xf7/0x1ce()
> Hardware name: To Be Filled By O.E.M.
> Pid: 1, comm: swapper Not tainted 2.6.30-rc2-tip-01538-ge8201b9-dirty #37740
> Call Trace:
>  <IRQ>  [<ffffffff80268a01>] warn_slowpath+0xcc/0x114
>  [<ffffffff80299ed3>] ? trace_hardirqs_on_caller+0x11d/0x179
>  [<ffffffff80299ba6>] ? mark_held_locks+0x60/0x95
>  [<ffffffff802ca335>] ring_buffer_lock_reserve+0xf7/0x1ce
>  [<ffffffff802ceb60>] trace_buffer_lock_reserve+0x34/0x7e
>  [<ffffffff810c8f97>] ? do_IRQ+0xf/0xe8
>  [<ffffffff802cf949>] trace_current_buffer_lock_reserve+0x36/0x4c
>  [<ffffffff802d9da4>] function_test_events_call+0x7e/0xe2
>  [<ffffffff80216313>] ? ret_from_intr+0x0/0x16
>  [<ffffffff80215616>] ftrace_call+0x5/0x2b
>  [<ffffffff8021630e>] ? common_interrupt+0xe/0x13
>  [<ffffffff810c8f9c>] ? do_IRQ+0x14/0xe8

The function tracer was called before we updated the hardirq_count :-/

I liked the fact that we can detect same level recursion. Perhaps I'll 
just make a depth test instead. Have a max of 16? times we can recurse 
(should be plenty) and then bug if we hit it?

-- Steve


>  [<ffffffff8021630e>] ? common_interrupt+0xe/0x13
>  [<ffffffff80216313>] ret_from_intr+0x0/0x16
>  <EOI>  [<ffffffff802c311c>] ? trace_clock_local+0x37/0x57
>  [<ffffffff80254b27>] ? __wake_up+0x57/0x7a
>  [<ffffffff802c9e60>] ? rb_reserve_next_event+0x73/0x319
>  [<ffffffff802f6106>] ? ftrace_raw_event_kmalloc+0x11/0xdd
>  [<ffffffff802d0ac8>] ? trace_wake_up+0x41/0x57
>  [<ffffffff802ca3ab>] ? ring_buffer_lock_reserve+0x16d/0x1ce
>  [<ffffffff802ceb60>] ? trace_buffer_lock_reserve+0x34/0x7e
>  [<ffffffff802c278d>] ? tracepoint_entry_add_probe+0xb3/0x12b
>  [<ffffffff802c278d>] ? tracepoint_entry_add_probe+0xb3/0x12b
>  [<ffffffff802cf949>] ? trace_current_buffer_lock_reserve+0x36/0x4c
>  [<ffffffff802c278d>] ? tracepoint_entry_add_probe+0xb3/0x12b
>  [<ffffffff802f615d>] ? ftrace_raw_event_kmalloc+0x68/0xdd
>  [<ffffffff802c278d>] ? tracepoint_entry_add_probe+0xb3/0x12b
>  [<ffffffff8031e265>] ? __kmalloc+0x268/0x298
>  [<ffffffff802969c6>] ? ftrace_event_lock_acquire+0x0/0x89
>  [<ffffffff802c278d>] ? tracepoint_entry_add_probe+0xb3/0x12b
>  [<ffffffff802c1e5f>] ? get_tracepoint+0x12/0x274
>  [<ffffffff802969c6>] ? ftrace_event_lock_acquire+0x0/0x89
>  [<ffffffff802c2875>] ? tracepoint_add_probe+0x70/0xf6
>  [<ffffffff802c2cf0>] ? tracepoint_probe_register+0x40/0xbc
>  [<ffffffff802968dd>] ? ftrace_reg_event_lock_acquire+0x2b/0x5c
>  [<ffffffff802d886f>] ? ftrace_event_enable_disable+0x43/0x59
>  [<ffffffff802d8cb4>] ? ftrace_set_clr_event+0x10c/0x15b
>  [<ffffffff81b70aa3>] ? event_trace_self_tests+0x39b/0x3e6
>  [<ffffffff81b70c52>] ? event_trace_self_tests_init+0x0/0x5f
>  [<ffffffff81b70c8d>] ? event_trace_self_tests_init+0x3b/0x5f
>  [<ffffffff8020a0b6>] ? do_one_initcall+0x84/0x1ad
>  [<ffffffff8029c513>] ? __lock_acquire+0x851/0x8d3
>  [<ffffffff8037d3de>] ? get_inode_number+0x61/0xc2
>  [<ffffffff8037d4f1>] ? proc_register+0xb2/0x139
>  [<ffffffff8037d553>] ? proc_register+0x114/0x139
>  [<ffffffff8021df9e>] ? native_sched_clock+0x25/0x9c
>  [<ffffffff8021df73>] ? sched_clock+0x33/0x39
>  [<ffffffff80297ccf>] ? lock_release_holdtime+0x2f/0x19d
>  [<ffffffff8037d553>] ? proc_register+0x114/0x139
>  [<ffffffff8029d44b>] ? __lock_release+0x177/0x196
>  [<ffffffff8037d4f1>] ? proc_register+0xb2/0x139
>  [<ffffffff80637f3e>] ? _raw_spin_unlock+0x14f/0x16e
>  [<ffffffff810c7e43>] ? _spin_unlock+0x3a/0x55
>  [<ffffffff8037d553>] ? proc_register+0x114/0x139
>  [<ffffffff8037d6de>] ? create_proc_entry+0x92/0xbe
>  [<ffffffff802b95a1>] ? register_irq_proc+0xc2/0xf2
>  [<ffffffff81b53140>] ? early_idt_handler+0x0/0x71
>  [<ffffffff81b53140>] ? early_idt_handler+0x0/0x71
>  [<ffffffff81b53aa8>] ? kernel_init+0xb2/0x11a
>  [<ffffffff81b53140>] ? early_idt_handler+0x0/0x71
>  [<ffffffff80216a4a>] ? child_rip+0xa/0x20
>  [<ffffffff802163d0>] ? restore_args+0x0/0x30
>  [<ffffffff81b539f6>] ? kernel_init+0x0/0x11a
>  [<ffffffff80216a40>] ? child_rip+0x0/0x20
> ---[ end trace 0d52030ff90bb47d ]---
