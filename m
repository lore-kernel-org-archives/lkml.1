Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbZEGSGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbZEGSGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZEGSF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:05:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZEGSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:05:58 -0400
Date: Thu, 7 May 2009 14:05:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/ring-buffer: updates to tip
In-Reply-To: <20090507175028.GA26354@elte.hu>
Message-ID: <alpine.DEB.2.00.0905071404240.28378@gandalf.stny.rr.com>
References: <20090507162221.413243886@goodmis.org> <20090507173801.GF10313@elte.hu> <20090507175028.GA26354@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 May 2009, Ingo Molnar wrote:

> 
> hm, i turned the self-test back on, and almost immediately got the 
> lockdep assert below.
> 
> config attached.
> 
> 	Ingo
> 
> [    1.779027] calling  init_irqsoff_tracer+0x0/0x14 @ 1
> [    1.780020] Testing tracer irqsoff: 
> [    1.780516] =============================================
> [    1.781146] PASSED
> [    1.781151] initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 976 usecs
> [    1.781155] calling  init_wakeup_tracer+0x0/0x22 @ 1
> [    1.781160] Testing tracer wakeup: [ INFO: possible recursive locking detected ]
> [    1.808746] 2.6.30-rc4-tip #39622
> [    1.812064] ---------------------------------------------
> [    1.817481] rb_consumer/942 is trying to acquire lock:
> [    1.822608]  (&cpu_buffer->reader_lock){......}, at: [<ffffffff804cedd7>] ring_buffer_reset_cpu+0xe4/0x173
> [    1.832342] 
> [    1.832342] but task is already holding lock:
> [    1.838177]  (&cpu_buffer->reader_lock){......}, at: [<ffffffff804d1144>] ring_buffer_consume+0xf9/0x189
> [    1.847734] 
> [    1.847734] other info that might help us debug this:
> [    1.854275] 1 lock held by rb_consumer/942:
> [    1.858460]  #0:  (&cpu_buffer->reader_lock){......}, at: [<ffffffff804d1144>] ring_buffer_consume+0xf9/0x189
> [    1.868472] 
> [    1.868472] stack backtrace:
> [    1.872862] Pid: 942, comm: rb_consumer Not tainted 2.6.30-rc4-tip #39622
> [    1.879646] Call Trace:
> [    1.882093]  [<ffffffff804ab1b2>] print_deadlock_bug+0xe3/0xf2
> [    1.887924]  [<ffffffff8043ae10>] ? sched_clock+0x33/0x39
> [    1.893345]  [<ffffffff804ab2f7>] check_deadlock+0x136/0x163
> [    1.899012]  [<ffffffff804ac97d>] validate_chain+0x614/0x620
> [    1.904667]  [<ffffffff8043af56>] ? native_sched_clock+0x7d/0x98
> [    1.910668]  [<ffffffff804ad139>] __lock_acquire+0x7b0/0x826
> [    1.916337]  [<ffffffff804a9b45>] ? trace_hardirqs_off+0xd/0xf
> [    1.922162]  [<ffffffff804d049e>] ? rb_move_tail+0x274/0x34b
> [    1.927823]  [<ffffffff8043af56>] ? native_sched_clock+0x7d/0x98
> [    1.933816]  [<ffffffff804ad2ab>] lock_acquire+0xfc/0x128
> [    1.939203]  [<ffffffff804cedd7>] ? ring_buffer_reset_cpu+0xe4/0x173
> [    1.945563]  [<ffffffff811541db>] _spin_lock_irqsave+0x59/0x91
> [    1.951396]  [<ffffffff804cedd7>] ? ring_buffer_reset_cpu+0xe4/0x173
> [    1.957760]  [<ffffffff804cedd7>] ring_buffer_reset_cpu+0xe4/0x173
> [    1.963964]  [<ffffffff804d95ff>] tracing_reset+0x46/0x9a
> [    1.969336]  [<ffffffff80434114>] ? restore_args+0x0/0x30
> [    1.974757]  [<ffffffff804dda2e>] time_hardirqs_off+0x100/0x152
> [    1.980673]  [<ffffffff804cfa17>] ? rb_get_reader_page+0x2c/0x272
> [    1.986747]  [<ffffffff804a9b45>] ? trace_hardirqs_off+0xd/0xf
> [    1.992579]  [<ffffffff804cfa17>] ? rb_get_reader_page+0x2c/0x272
> [    1.998694]  [<ffffffff804a9aac>] trace_hardirqs_off_caller+0x1f/0xab
> [    2.005112]  [<ffffffff804a9b45>] trace_hardirqs_off+0xd/0xf
> [    2.010770]  [<ffffffff804cfa17>] rb_get_reader_page+0x2c/0x272
> [    2.016691]  [<ffffffff804d00f8>] rb_buffer_peek+0x111/0x11c
> [    2.022391]  [<ffffffff804d1157>] ring_buffer_consume+0x10c/0x189
> [    2.028475]  [<ffffffff804d2fd6>] ring_buffer_consumer+0x43/0x1f0
> [    2.034546]  [<ffffffff804d3183>] ? ring_buffer_consumer_thread+0x0/0x8d
> [    2.041249]  [<ffffffff804d31a4>] ring_buffer_consumer_thread+0x21/0x8d
> [    2.047859]  [<ffffffff8049a2a0>] kthread+0x5b/0x88
> [    2.052747]  [<ffffffff804347ba>] child_rip+0xa/0x20
> [    2.057704]  [<ffffffff804758d0>] ? finish_task_switch+0x40/0x152
> [    2.063818]  [<ffffffff80434114>] ? restore_args+0x0/0x30
> [    2.069206]  [<ffffffff8115045c>] ? schedule+0x19d/0x8fd
> [    2.074533]  [<ffffffff8049a245>] ? kthread+0x0/0x88
> [    2.079501]  [<ffffffff804347b0>] ? child_rip+0x0/0x20
> [    2.409100] PASSED
> [    2.410017] Testing tracer wakeup_rt: PASSED
> [    2.613891] initcall init_wakeup_tracer+0x0/0x22 returned 0 after 812500 usecs


Ah! This is the first use that we are using two ring buffers. We have the 
spin lock of one buffer, and are taking a spin lock of another buffer. I 
guess I need to teach lockdep about the nesting here :-/

-- Steve

