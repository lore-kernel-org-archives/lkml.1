Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYKQWTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYKQWTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYKQWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:19:47 -0500
Received: from ozlabs.org ([203.10.76.45]:34813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYKQWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:19:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18721.60712.438025.564030@cargo.ozlabs.ibm.com>
Date: Tue, 18 Nov 2008 09:16:08 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> Here's my stack after boot up with CONFIG_IRQSTACKS set. Seems that 
> softirqs still use the same stack as the process.

They shouldn't.  I don't see do_softirq in the trace, though.  Which
functions did you think would be run in a softirq?  It looks to me
like the deepest 10 or so functions are called at hard irq level,
within hrtimer_interrupt called from timer_interrupt.

> root@electra ~> cat /debug/tracing/stack_trace 
>         Depth   Size      Location    (59 entries)
>         -----   ----      --------
>   0)    12384     192   ftrace_call+0x4/0x14
>   1)    12192     128   .sched_clock+0x20/0x60
>   2)    12064     128   .sched_clock_cpu+0x34/0x50
>   3)    11936     144   .cpu_clock+0x3c/0xa0
>   4)    11792     144   .get_timestamp+0x2c/0x50
>   5)    11648     144   .__touch_softlockup_watchdog+0x3c/0x60
>   6)    11504     192   .softlockup_tick+0xe4/0x220
>   7)    11312     128   .run_local_timers+0x34/0x50
>   8)    11184     160   .update_process_times+0x44/0xb0
>   9)    11024     176   .tick_sched_timer+0x8c/0x120
>  10)    10848     160   .__run_hrtimer+0xd8/0x130
>  11)    10688     240   .hrtimer_interrupt+0x16c/0x220
>  12)    10448     160   .timer_interrupt+0xcc/0x110
>  13)    10288      96   decrementer_common+0xe0/0x100

Paul.
