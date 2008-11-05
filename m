Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYKEQEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYKEQEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYKEQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:04:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYKEQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:04:40 -0500
Date: Wed, 5 Nov 2008 11:04:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: bug: ftrace & lockdep badness
In-Reply-To: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0811051054430.11900@gandalf.stny.rr.com>
References: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Nov 2008, Heiko Carstens wrote:

> Hi Steven,
> 
> enabling preemptirqsoff tracing gives me this on a lockdep enabled kernel:
> 
> Badness at kernel/lockdep.c:2894

[...]

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

[...]

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

Yes, this does seem to be the case.

Perhaps Peter or Ingo can come up with some ideas on how to solve this. 
Let me try to rephrase the problem.

In __local_bh_disable() we call add_preempt_count(SOFTIRQ_OFFSET)

in add_preempt_count (in sched.c)

  preempt_count() += val;
  if (preempt_count() == val)
	trace_preempt_off(...)

in trace_preempt_off we record into the ring buffer. But the ring buffer 
will call spin_lock_irqsave (it use to be raw_spin_lock, where this was 
not an issue). Note, there is development to make the ring buffer 
lockless, but until that time, we need to come up with a real solution.

Now we enter the lockdep code, but we are not in a full state transition 
and we get a WARN_ON triggered by the lockdep code (have SOFTIRQ_OFFSET 
set but we did not yet tell lockdep we are in a softirq).

This is the type of problems we deal with when we have the tracer tracing 
lockdep code at the same time the lockdep code is checking the tracer.

-- Steve
