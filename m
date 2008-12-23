Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYLWITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYLWITT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 03:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYLWITJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:19:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbYLWITI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:19:08 -0500
Date: Tue, 23 Dec 2008 09:18:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: strip ending newlines
	on comments
Message-ID: <20081223081855.GA6009@elte.hu>
References: <494FD967.2000002@gmail.com> <20081223064804.GA24956@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223064804.GA24956@elte.hu>
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


btw., ftrace_printk() is not NMI safe:
x
BUG: spinlock recursion on CPU#1, loop_yield/3360
 lock: ffffffff807a0c60, .magic: dead4ead, .owner: loop_yield/3360, .owner_cpu: 1
Pid: 3360, comm: loop_yield Not tainted 2.6.28-rc9-tip #48
Call Trace:
 <NMI>  [<ffffffff8038ba23>] spin_bug+0xa2/0xaa
 [<ffffffff8038baf8>] _raw_spin_lock+0x42/0x134
 [<ffffffff8059f0fc>] _spin_lock_irqsave+0x44/0x50
 [<ffffffff802890c4>] ? trace_vprintk+0x8e/0x164
 [<ffffffff8059eeea>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff802890c4>] trace_vprintk+0x8e/0x164
 [<ffffffff802182a6>] ? __hw_perf_counter_set_period+0x1ed/0x280
 [<ffffffff802892ef>] __ftrace_printk+0x55/0x57
 [<ffffffff802182cc>] __hw_perf_counter_set_period+0x213/0x280
 [<ffffffff80218d8c>] __smp_perf_counter_interrupt+0x21c/0x3c2
 [<ffffffff805a043a>] perf_counter_nmi_handler+0x35/0x3f
 [<ffffffff805a1cc9>] notifier_call_chain+0x5e/0x92
 [<ffffffff805a1d5b>] __atomic_notifier_call_chain+0x5e/0x87
 [<ffffffff805a1cfd>] ? __atomic_notifier_call_chain+0x0/0x87
 [<ffffffff805a1d93>] atomic_notifier_call_chain+0xf/0x11
 [<ffffffff80258e9d>] notify_die+0x2e/0x30
 [<ffffffff8059fdd2>] do_nmi+0x9f/0x25f
 [<ffffffff8059f7fa>] nmi+0x1a/0x2c
 [<ffffffff80287104>] ? __rb_reserve_next+0x4b/0x3c8
 [<ffffffff802871dd>] ? __rb_reserve_next+0x124/0x3c8
 <<EOE>>  <IRQ>  [<ffffffff80287628>] rb_reserve_next_event+0x1a7/0x307
 [<ffffffff8028796c>] ring_buffer_lock_reserve+0x8b/0xd3
 [<ffffffff8028910b>] trace_vprintk+0xd5/0x164
 [<ffffffff80260fb3>] ? trace_hardirqs_on_caller+0xfd/0x138
 [<ffffffff8028dd2b>] ? __perf_counter_remove_from_context+0x60/0x179
 [<ffffffff802892ef>] __ftrace_printk+0x55/0x57
 [<ffffffff802180a6>] ? pmc_generic_disable+0x266/0x279
 [<ffffffff8028dd59>] __perf_counter_remove_from_context+0x8e/0x179
 [<ffffffff8026835d>] generic_smp_call_function_single_interrupt+0x87/0xc0
 [<ffffffff8021fd8d>] smp_call_function_single_interrupt+0x24/0x34
 [<ffffffff8020d053>] call_function_single_interrupt+0x13/0x20
 <EOI> 

caused by:

        spin_lock_irqsave(&trace_buf_lock, irq_flags);

which locking is necessiated by:

        static DEFINE_SPINLOCK(trace_buf_lock);
        static char trace_buf[TRACE_BUF_SIZE];

i think this should be changed to a PER_CPU data structure - and if an NMI 
context mixes up the buffer, that's not a big issue. (i'd not complicate 
it by using a NMI specific buffer)

	Ingo
