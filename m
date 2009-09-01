Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZIANxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZIANxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZIANxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:53:23 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:8734 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZIANxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:53:22 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC46CF212@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
	 <20090818140022.GB13013@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
	 <1251810046.7547.13.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC46CF212@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 15:53:17 +0200
Message-Id: <1251813197.7547.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 14:32 +0100, Metzger, Markus T wrote:

> >> My current theory is that the BTS buffer fills up so quickly when tracing
> >> the kernel, that the kernel is busy handling overflows and reacting on
> >> other interrupts that pile up while we're handling the BTS overflow.
> >>
> >> When I trace user-mode branches, it works.
> >>
> >> When I do not copy the trace during overflow handling, the kernel does not hang.
> >
> >Agreed, that was my suspicion as well. Would you happen to know where to
> >get these USB debug port cables, and how to find out if a machine
> >supports this?
> 
> 
> I'm sorry but I don't understand what you mean with "these USB debug port cables".

Not sure either, whatever makes all the code from commit:
5c05917e7fe313a187ad6ebb94c1c6cf42862a0b usable I guess.

> >> I do need 3 buffers of 2048 entries = 3x48 pages per cpu, though.
> >
> >And those pages have to be contiguous too, right? That's an order-6
> >alloc, painful.
> 
> 
> According to an earlier discussion with Roland, they don't have to.
> They still need to be locked, though.
> According to some other discussion with Andrew and Ingo, I still use
> kmalloc to allocate those buffers.

Section 18.18.5 of book 3B says the DS buffer base is a linear address.
This suggests each buffer does need contiguous pages.

48 contiguous pages constitutes an order-6 allocation (64 pages), which
is unreliable at best.

> >> One buffer
> >> to switch in during overflow handling; another to switch in during sched_out
> >> (assuming that we need to schedule out the traced task before we may start
> >> the draining task). Even then, there's a chance that we will lose trace
> >> when the draining task may not start immediately. I would even say that
> >> this is quite likely.
> >
> >Right, is it possible to detect this loss?
> 
> It is. But in order to get the PERF_EVENT_LOST record into the correct place,
> I need to defer logging the lost trace;-)
> 
> And we would loose this very nice feature of fixed-size entries.

Well, if you don't defer there is no possibility of loosing data is
there? So we either defer and have to deal with lost data, or we do not.

> >This makes me wonder how much time it takes to drain these buffers, it
> >is at all possible to optimize that code path into oblivion, or will
> >nothing be fast enough?
> 
> 
> Are you saying that we should rather speed up that code path than try to
> defer all the work? There definitely is a lot of redundant work done on
> the generic path.
> 
> I did a few experiments where I would drain only parts of the buffer.
> I could not drain too much before the system would hang.
> Besides, that does not sound too robust to me. Would it sill work on
> a slower system? Or on a faster one? Or on a fully loaded one?

Base cpu speed is what counts, load is not interesting.

Also it seems a normalizing property, the slower the cpu the less
branches it can process per time unit, so less data to process.

But yes, I was suggesting to optimize this, since the current way of
calling perf_counter_output() multiple times is massively bloated.

> >> There already seems to be something in place regarding deferring work, i..e.
> >> perf_counter_do_pending(). Would it be OK if I added the deferred BTS buffer
> >> draining to that?
> >
> >Yes, note that this pending work runs from hardirq context as well. On
> >x86 we self-ipi to get into IRQ context ASAP after the NMI.
> >
> >So if the remote cpu is blocked waiting on an SMP call, doing the work
> >from hardirq context won't really help things.
> 
> 
> I can't use that, then.
> 
> When I use schedule_work() instead, how would I ensure that the work is done
> before the traced (or tracing) task is rescheduled?

No, basically the only thing left is softirqs, which can be preempted by
hardirqs, but that's a horrid hack too, esp since processing the BTS
outside of the handler will basically result in the BTS tracing its own
processing, generating even more data to process.

> I would need to ensure that the counter does not go away as long as draining
> work is scheduled. I would store a pointer to the counter in the work struct.
> Should perf_counter's be use-counted?

Yes, they currently rely on the reference counting of the filedesc
they're associated with, but that needs to be undone for in-kernel usage
anyway.

> There's some more review feedback from you that I have not integrated, yet.
> One is that BTS should return an error instead of falling back to generic
> counters.
> Another is that BTS does not provide a counter value.
> 
> How important are those?

Would be very nice to have.

