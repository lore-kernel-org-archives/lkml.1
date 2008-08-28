Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYH1HkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYH1HkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYH1Hj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:39:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYH1Hj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:39:58 -0400
Date: Thu, 28 Aug 2008 09:39:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH] ftrace stack tracer
Message-ID: <20080828073935.GG21875@elte.hu>
References: <alpine.DEB.1.10.0808272324210.1782@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808272324210.1782@gandalf.stny.rr.com>
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

> This is another tracer using the ftrace infrastructure, that examines 
> at each function call the size of the stack. If the stack use is 
> greater than the previous max it is recorded.
> 
> You can always see (and set) the max stack size seen. By setting it to 
> zero will start the recording again. The backtrace is also available.
> 
> For example:
> 
> # cat /debug/tracing/stack_max_size 
> 1856
> 
> # cat /debug/tracing/stack_trace 
> [<c027764d>] stack_trace_call+0x8f/0x101
> [<c021b966>] ftrace_call+0x5/0x8
> [<c02553cc>] clocksource_get_next+0x12/0x48
> [<c02542a5>] update_wall_time+0x538/0x6d1
> [<c0245913>] do_timer+0x23/0xb0
> [<c0257657>] tick_do_update_jiffies64+0xd9/0xf1
> [<c02576b9>] tick_sched_timer+0x4a/0xad
> [<c0250fe6>] __run_hrtimer+0x3e/0x75
> [<c02518ed>] hrtimer_interrupt+0xf1/0x154
> [<c022c870>] smp_apic_timer_interrupt+0x71/0x84
> [<c021b7e9>] apic_timer_interrupt+0x2d/0x34
> [<c0238597>] finish_task_switch+0x29/0xa0
> [<c05abd13>] schedule+0x765/0x7be
> [<c05abfca>] schedule_timeout+0x1b/0x90
> [<c05ab4d4>] wait_for_common+0xab/0x101
> [<c05ab5ac>] wait_for_completion+0x12/0x14
> [<c033cfc3>] blk_execute_rq+0x84/0x99
> [<c0402470>] scsi_execute+0xc2/0x105
> [<c040250a>] scsi_execute_req+0x57/0x7f
> [<c043afe0>] sr_test_unit_ready+0x3e/0x97
> [<c043bbd6>] sr_media_change+0x43/0x205
> [<c046b59f>] media_changed+0x48/0x77
> [<c046b5ff>] cdrom_media_changed+0x31/0x37
> [<c043b091>] sr_block_media_changed+0x16/0x18
> [<c02b9e69>] check_disk_change+0x1b/0x63
> [<c046f4c3>] cdrom_open+0x7a1/0x806
> [<c043b148>] sr_block_open+0x78/0x8d
> [<c02ba4c0>] do_open+0x90/0x257
> [<c02ba869>] blkdev_open+0x2d/0x56
> [<c0296a1f>] __dentry_open+0x14d/0x23c
> [<c0296b32>] nameidata_to_filp+0x24/0x38
> [<c02a1c68>] do_filp_open+0x347/0x626
> [<c02967ef>] do_sys_open+0x47/0xbc
> [<c02968b0>] sys_open+0x23/0x2b
> [<c021aadd>] sysenter_do_call+0x12/0x26
> 
> I've tested this on both x86_64 and i386.

very nice!

This is even more efficient in practice i think than 'make stackcheck' 
type of analysis, because it measures the stack footprint in practice.

That way we can prove/disprove theories whether a regression was caused 
by stack overflow or not.

We can also do practical profiling of worst-case stack footprint - much 
like the latency tracer works. (just in a different 'space' of 
'latency'.)

A couple of suggestions:

 - could we somehow include the per stacktrace line stack frame size 
   information as well? This probably needs an extension to
   save_stack_trace() though.

 - it would be nice to introduce a treshold and automation to emit a
   WARN_ON() exactly once during bootup if this threshold is ever
   exceeded. That way automated testing efforts like randconfig
   testing would automatically do worst-case-stack-footprint testing as
   well.

 - please link this tracer plugin into the stack redzone check mechanism 
   we already have. Right now our stack overflow warnings are 
   statistical: they only happen if an irq handler happens to notice a 
   deep stack, or if task teardown happens to see corruption of a 
   specific area of the stack. Neither of which are particularly 
   efficient in practice. One thing to be careful about is when to 
   print: i'd suggest to introduce a stack overflow warning that uses 
   only early_printk() and not the regular printk. This is a truly 
   emergency mechanism and getting the message out in time (before we 
   self-destruct via corrupting the task structure) is important.

	Ingo
