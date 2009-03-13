Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbZCMBFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbZCMBFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZCMBFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:05:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36220 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZCMBFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:05:01 -0400
Date: Fri, 13 Mar 2009 02:04:58 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: some ARM fixes for 2.6.29-rc7-rt1
Message-ID: <20090313010458.GB1192@pengutronix.de>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 12, 2009 at 08:17:50PM +0100, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series. It contains only one new patch:
>    
>    - port forward to 2.6.29-rc7
>    - disable CONFIG_MAXCPUS for now (undebugged runtime bug)
>    - fix CONFIG_HIGHMEM problems
>    - fix netfilter problems
>    - make debugobjects -rt safe
>    - various build fixes
on top of 2.6.29-rc7-rc1 I did some ARM related fixes that you can find
at

	git://git.pengutronix.de/git/ukl/linux-2.6.git v2.6.29-rc7-rt1-pu

The top commit currently isn't pretty as it contains several independant
fixes.  Some of them are netX specific so you probably don't need them,
but they shouldn't hurt you either.

I will update this branch as I continue working in a non-fast-forward
manner.  I use TopGit to manage this branch, you might want to use it,
too, if you intend to follow my work.

My status quo is:

	Testing tracer sched_switch: PASSED
	Testing tracer function: PASSED
	Testing tracer irqsoff: .. no entries found ..FAILED!
	Testing tracer preemptoff: .. no entries found ..FAILED!
	Testing tracer preemptirqsoff: .. no entries found ..<4>------------[ cut here ]------------
	WARNING: at /ptx/work/octopus/WORK_2_A/ukl/gsrc/linux-2.6/kernel/trace/trace.c:683 warn_slowpath+0x18/0xa0()
	Modules linked in:
	[<c0244d40>] (dump_stack+0x0/0x18) from [<c003787c>] (warn_slowpath+0x6c/0xa0)
	[<c0037810>] (warn_slowpath+0x0/0xa0) from [<c00750d0>] (tracing_start+0x60/0xdc)
	 r3:ffffffff r2:00000000
	 r7:c074aaf0 r6:c0748a0c r5:60000013 r4:c074aac8
	[<c0075070>] (tracing_start+0x0/0xdc) from [<c0076430>] (trace_selftest_startup_preemptirqsoff+0x1ac/0x1d8)
	 r5:c1c1a000 r4:ffffffff
	[<c0076284>] (trace_selftest_startup_preemptirqsoff+0x0/0x1d8) from [<c00760c4>] (register_tracer+0x118/0x240)
	[<c0075fac>] (register_tracer+0x0/0x240) from [<c000ebbc>] (init_irqsoff_tracer+0x24/0x38)
	 r7:c000eb98 r6:00000000 r5:c001c44c r4:c001c2b8
	[<c000eb98>] (init_irqsoff_tracer+0x0/0x38) from [<c00232c4>] (__exception_text_end+0x5c/0x1a4)
	[<c0023268>] (__exception_text_end+0x0/0x1a4) from [<c00085a4>] (kernel_init+0x90/0x1c0)
	 r8:00000000 r7:00000000 r6:00000000 r5:c001c44c r4:c001c2b8
	[<c0008514>] (kernel_init+0x0/0x1c0) from [<c003aebc>] (do_exit+0x0/0x798)
	 r5:00000000 r4:00000000
	---[ end trace da227214a82491b7 ]---
	FAILED!

The warning is triggered here because tracing_start is called twice in
trace_selftest_startup_preemptirqsoff's error path[1].

I researched for some time now why the tracers doesn't pass the
self-tests, but without success.  It's bed time and any hints are
welcome.

Other than that my machine boots and reports from time to time

	scheduling while atomic

and

	sleeping function called from invalid context at kernel/rtmutex.c:683

Both errors probably happen because some spin_locks need to be converted
to raw_spin_locks.  Will look later.

I provide this uncooked state to prevent duplicate work, so please
excuse the bad code and commit history.  If it upsets you, please send
patches :-)

Best regards
Uwe

[1] if trace_test_buffer sets count = 0 or returns != 0 in
kernel/trace/trace_selftest.c:440, the code flow is:

	tracing_start()
	goto out;

	...
out:
	trace->reset(tr);
	tracing_start();

I think the last tracing_start is wrong, but I didn't check deeply.

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
