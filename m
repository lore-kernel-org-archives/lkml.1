Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbZCMWll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbZCMWll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZCMWle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:41:34 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34073 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZCMWld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:41:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18874.57621.950179.972863@cargo.ozlabs.ibm.com>
Date: Sat, 14 Mar 2009 09:41:25 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
In-Reply-To: <1236948283.22447.36.camel@twins>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
	<1236939816.22914.3714.camel@twins>
	<18874.20538.785519.824803@cargo.ozlabs.ibm.com>
	<1236948283.22447.36.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> The issue I have with your approach is two-fold:
>  - it breaks the symmetry between software and hardware counters by
>    treating them differently.

So... I was about to restore that symmetry by implementing lazy PMU
context switching.  In the case where we have inherited counters, and
we are switching from one task to another that both have the same set
of inherited counters, we don't really need to do anything, because it
doesn't matter which set of counters the events get added into,
because they all get added together at the end anyway.

That is another situation where you can have counters that are active
when their associated task is not scheduled in, this time for hardware
counters as well as software counters.  So this is not just some weird
special case for software counters, but is actually going to be more
generally useful.

>  - it doesn't make much conceptual sense to me

It seems quite reasonable to me that things could happen that are
attributable to a task, but which happen when the task isn't running.
Not just context switches and migrations - there's a whole class of
things that the system does on behalf of a process that can happen
asynchronously.  I wouldn't want to say that those kind of things can
never be counted with software counters.

> For the context switch counter, we could count the event right before we
> schedule out, which would make it behave like expected.
> 
> The same for task migration, most migrations happen when they are in
> fact running, so there too we can account the migration either before we
> rip it off the src cpu, or after we place it on the dst cpu.
> 
> There are a few places where this isn't quite so, like affine wakeups,
> but there we can account after the placement.

Right - but how do you know whether to do that accounting or not?  At
the moment there simply isn't enough state information in the counter
to tell you whether or not you should be adding in those things that
happened while the task wasn't running.  At the moment you can't tell
whether a counter is inactive merely because its task is scheduled
out, or because it's in a group that won't currently fit on the PMU.

By the way, I notice that x86 will do the wrong thing if you have a
group where the leader is an interrupting hardware counter with
record_type == PERF_RECORD_GROUP and there is a software counter in
the group, because perf_handle_group calls x86_perf_counter_update on
each group member unconditionally, and x86_perf_counter_update assumes
its argument is a hardware counter.

Paul.
