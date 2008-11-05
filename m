Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYKENIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYKENIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYKENH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:07:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYKENH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:07:56 -0500
Date: Wed, 5 Nov 2008 08:07:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: bug: ftrace & lockdep badness
In-Reply-To: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0811050807220.8991@gandalf.stny.rr.com>
References: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Nov 2008, Heiko Carstens wrote:

> enabling preemptirqsoff tracing gives me this on a lockdep enabled kernel:
> 
> Badness at kernel/lockdep.c:2894
> Modules linked in:
> CPU: 0 Not tainted 2.6.28-rc3-00031-ga75952b-dirty #72
> Process sshd (pid: 2542, task: 000000003397d7a8, ksp: 0000000033abb618)
> Krnl PSW : 0404c00180000000 0000000000078770 (check_flags+0x12c/0x160)
>            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000dcda88 0000000000000000 000000000000000f
>            0000000000000000 0000000000000000 0000000000000002 0000000000000000
>            0000000000000000 0000000000000000 000000003fe7d428 0000000033abb170
>            0000000000557fb8 000000000038b210 0000000000078758 0000000033abb170
> Krnl Code: 0000000000078764: bf2f1000           icm     %r2,15,0(%r1)
>            0000000000078768: a774ffa7           brc     7,786b6
>            000000000007876c: a7f40001           brc     15,7876e
>           >0000000000078770: a7f4ffa3           brc     15,786b6
>            0000000000078774: c0e5000a53ea       brasl   %r14,1c2f48
>            000000000007877a: 1222               ltr     %r2,%r2
>            000000000007877c: a784000b           brc     8,78792
>            0000000000078780: c010006aa984       larl    %r1,dcda88
> Call Trace:
> ([<0000000033abb188>] 0x33abb188)
>  [<000000000007e76a>] lock_acquire+0x52/0xbc
>  [<000000000037618c>] _spin_lock_irqsave+0x6c/0xb0
>  [<000000000009d52e>] ring_buffer_reset_cpu+0x6e/0x114
>  [<00000000000a46c0>] tracing_reset+0x84/0xe8
>  [<00000000000a5632>] trace_preempt_off+0x112/0x178
>  [<0000000000378888>] add_preempt_count+0xa4/0x130
>  [<00000000000539e0>] __local_bh_disable+0x54/0xcc
>  [<0000000000053a82>] local_bh_disable+0x2a/0x38
>  [<0000000000376002>] _spin_lock_bh+0x2e/0xa4
>  [<00000000002a1baa>] lock_sock_nested+0x4a/0x118
>  [<00000000002e9e86>] tcp_sendmsg+0x42/0xdc0
>  [<000000000029cd3c>] sock_aio_write+0x130/0x180
>  [<00000000000ea36c>] do_sync_write+0xdc/0x134
>  [<00000000000eafe8>] vfs_write+0x154/0x15c
>  [<00000000000eb106>] sys_write+0x52/0xa8
>  [<000000000002a950>] sys32_write+0x2c/0x4c
>  [<0000000000026f80>] sysc_noemu+0x10/0x16
>  [<0000000077c5c186>] 0x77c5c186
> INFO: lockdep is turned off.
> 
> Seems to be that the following happens:
> 
> __local_bh_disable() calls add_preempt_count() which adds something to
> preempt_count().
> After this addition softirq_count() will return something != 0.
> However current->softirqs_enabled is still 1 since we haven't called
> trace_softirqs_off() yet.
> But we call trace_preempt_off() instead which will grab a lock in the
> ringbuffer code and that will trigger this check in lockdep.c:
> 
>         if (!hardirq_count()) {
>                 if (softirq_count())
>                         DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
> 
> I assume this is a known bug. Is there any fix available?


Actually this is the first time that I've seen this. I'm off to school, 
and will look at this when I get back (around 10:30 EST).

-- Steve

