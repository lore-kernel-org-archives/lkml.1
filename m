Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbZCPJ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbZCPJ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbZCPJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:57:00 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:6042 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761479AbZCPJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:56:59 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18874.57621.950179.972863@cargo.ozlabs.ibm.com>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
	 <1236939816.22914.3714.camel@twins>
	 <18874.20538.785519.824803@cargo.ozlabs.ibm.com>
	 <1236948283.22447.36.camel@twins>
	 <18874.57621.950179.972863@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 10:56:43 +0100
Message-Id: <1237197403.7818.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 09:41 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > The issue I have with your approach is two-fold:
> >  - it breaks the symmetry between software and hardware counters by
> >    treating them differently.
> 
> So... I was about to restore that symmetry by implementing lazy PMU
> context switching.  In the case where we have inherited counters, and
> we are switching from one task to another that both have the same set
> of inherited counters, we don't really need to do anything, because it
> doesn't matter which set of counters the events get added into,
> because they all get added together at the end anyway.

That is only true for actual counting counters, not the sampling kind.

> That is another situation where you can have counters that are active
> when their associated task is not scheduled in, this time for hardware
> counters as well as software counters.  So this is not just some weird
> special case for software counters, but is actually going to be more
> generally useful.
> 
> >  - it doesn't make much conceptual sense to me
> 
> It seems quite reasonable to me that things could happen that are
> attributable to a task, but which happen when the task isn't running.
> Not just context switches and migrations - there's a whole class of
> things that the system does on behalf of a process that can happen
> asynchronously.  I wouldn't want to say that those kind of things can
> never be counted with software counters.

I've been thinking too much about sampling I think. It makes absolutely
no sense in that light to have events that occur when the task isn't
running, quite simply because its impossible to relate it to whatever
the task is doing at that moment.

However for simple counting events it might make sense to have something
like that.

Still HW counters can simply never do anything like that, and the lazy
PMU thing you propose, while cool for simple stuff like perfstat, is
something all-together different -- it doesn't keep counters enabled
while their task is gone from the cpu, it avoids a counter update
between related tasks.

> > For the context switch counter, we could count the event right before we
> > schedule out, which would make it behave like expected.
> > 
> > The same for task migration, most migrations happen when they are in
> > fact running, so there too we can account the migration either before we
> > rip it off the src cpu, or after we place it on the dst cpu.
> > 
> > There are a few places where this isn't quite so, like affine wakeups,
> > but there we can account after the placement.
> 
> Right - but how do you know whether to do that accounting or not?  At
> the moment there simply isn't enough state information in the counter
> to tell you whether or not you should be adding in those things that
> happened while the task wasn't running.  At the moment you can't tell
> whether a counter is inactive merely because its task is scheduled
> out, or because it's in a group that won't currently fit on the PMU.

Well, for things like the migration count its easy, we already always
count those, so fudging the perf counter interface isn't too hard. Other
things, yeah, that'll be a tad tricky.

> By the way, I notice that x86 will do the wrong thing if you have a
> group where the leader is an interrupting hardware counter with
> record_type == PERF_RECORD_GROUP and there is a software counter in
> the group, because perf_handle_group calls x86_perf_counter_update on
> each group member unconditionally, and x86_perf_counter_update assumes
> its argument is a hardware counter.

Ah, right, I fixed that for the generic swcounter stuff but then didn't
do the x86 part.. d'oh.



