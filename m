Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbZFHPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbZFHPh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZFHPhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:37:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZFHPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:37:50 -0400
Date: Mon, 8 Jun 2009 11:37:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIP PULL] tracing/events/trace_stack: various
 fixes
In-Reply-To: <20090607082257.GA16761@elte.hu>
Message-ID: <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com>
References: <20090603151724.144915858@goodmis.org> <20090605145219.GA14830@elte.hu> <20090607082257.GA16761@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added Peter ]

On Sun, 7 Jun 2009, Ingo Molnar wrote:
> Testing tracer sched_switch: <6>Starting ring buffer hammer
> PASSED
> Testing tracer sysprof: PASSED
> Testing tracer function: PASSED
> Testing tracer irqsoff: 
> =============================================
> PASSED
> Testing tracer preemptoff: PASSED
> Testing tracer preemptirqsoff: [ INFO: possible recursive locking detected ]
> PASSED
> Testing tracer branch: 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
> ---------------------------------------------
> rb_consumer/431 is trying to acquire lock:
>  (&cpu_buffer->reader_lock){......}, at: [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70
> 
> but task is already holding lock:
>  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
> 
> other info that might help us debug this:
> 1 lock held by rb_consumer/431:
>  #0:  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0

Yes this definitely looks like ftrace is tracing the ring buffer benchmark 
test.

OK, how do I go about teaching lockdep that this reader lock is not the 
same reader lock as the one being taken?

-- Steve

> 
> stack backtrace:
> Pid: 431, comm: rb_consumer Not tainted 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
> Call Trace:
>  [<c1070940>] validate_chain+0xa20/0x1000
>  [<c1071240>] __lock_acquire+0x320/0x5f0
>  [<c107159f>] lock_acquire+0x8f/0x120
>  [<c109eef7>] ? ring_buffer_reset_cpu+0x37/0x70
>  [<c1739c76>] _spin_lock_irqsave+0x56/0x70
>  [<c109eef7>] ? ring_buffer_reset_cpu+0x37/0x70
>  [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70
>  [<c10a596e>] tracing_reset+0x3e/0x80
>  [<c109f4df>] ? rb_get_reader_page+0x11f/0x180
>  [<c106c90b>] ? trace_hardirqs_off+0xb/0x10
>  [<c10aa97f>] time_hardirqs_off+0xbf/0x110
>  [<c109f4df>] ? rb_get_reader_page+0x11f/0x180
>  [<c106c830>] trace_hardirqs_off_caller+0x20/0xf0
>  [<c106c90b>] trace_hardirqs_off+0xb/0x10
>  [<c109f4df>] rb_get_reader_page+0x11f/0x180
>  [<c109f624>] rb_buffer_peek+0x24/0xe0
>  [<c10a01ad>] ring_buffer_consume+0x8d/0xc0
>  [<c10a1585>] ring_buffer_consumer_thread+0xa5/0x440
>  [<c173a1c2>] ? _spin_unlock_irqrestore+0x62/0x80
>  [<c10306be>] ? complete+0x4e/0x60
>  [<c10a14e0>] ? ring_buffer_consumer_thread+0x0/0x440
>  [<c105c1e2>] kthread+0x52/0x80
>  [<c105c190>] ? kthread+0x0/0x80
>  [<c10047cb>] kernel_thread_helper+0x7/0x10
