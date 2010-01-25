Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489Ab0AYR75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0AYR75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399Ab0AYR74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:59:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0AYR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:59:55 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v6 
 incremental)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
In-Reply-To: <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
	 <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
	 <1264440342.4283.1936.camel@laptop>
	 <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 18:59:41 +0100
Message-ID: <1264442381.4283.1944.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 18:48 +0100, stephane eranian wrote:

> >> It seems a solution would be to call x86_pmu_disable() before
> >> assigning an event to a new counter for all events which are
> >> moving. This is because we cannot assume all events have been
> >> previously disabled individually. Something like
> >>
> >> if (!match_prev_assignment(hwc, cpuc, i)) {
> >>    if (hwc->idx != -1)
> >>       x86_pmu.disable(hwc, hwc->idx);
> >>    x86_assign_hw_event(event, cpuc, cpuc->assign[i]);
> >>    x86_perf_event_set_period(event, hwc, hwc->idx);
> >> }
> >
> > Yes and no, my worry is not that its not counting, but that we didn't
> > store the actual counter value before over-writing it with the new
> > configuration.
> >
> > As to your suggestion,
> >  1) we would have to do x86_pmu_disable() since that does
> > x86_perf_event_update().
> >  2) I worried about the case where we basically switch two counters,
> > there we cannot do the x86_perf_event_update() in a single pass since
> > programming the first counter will destroy the value of the second.
> >
> > Now possibly the scenario in 2 isn't possible because the event
> > scheduling is stable enough for this never to happen, but I wasn't
> > feeling too sure about that, so I skipped this part for now.
> >
> I think what adds to the complexity here is that there are two distinct
> disable() mechanisms: perf_disable() and x86_pmu.disable(). They
> don't operate the same way. You would think that by calling hw_perf_disable()
> you would stop individual events as well (thus saving their values). That
> means that if you do perf_disable() and then read the count, you will not
> get the up-to-date value in event->count. you need pmu->disable(event)
> to ensure that.

No, a read is actually good enough, it does x86_perf_event_update(), but
we're not guaranteeing that read is present.

So yes, perf_disable() is basically a local_irq_disable() but for perf
events, all it has to do is ensure there's no concurrency. ->disable()
will really tear the configuration down.

Either ->disable() or ->read() will end up calling
x86_perf_event_update() which is needed to read the actual hw counter
value and propagate it into event storage.

> So my understanding is that perf_disable() is meant for a temporary stop,
> thus no need to save the count.
> 
> As for 2, I believe this can happen if you add 2 new events which have more
> restrictions. For instance on Core, you were measuring cycles, inst in generic
> counters, then you add 2 events which can only be measured on generic counters.
> That will cause cycles, inst to be moved to fixed counters.
> 
> So we have to modify hw_perf_enable() to first disable all events
> which are moving,
> then reprogram them. I suspect it may be possible to optimize this if
> we detect that
> those events had already been stopped individually (as opposed to
> perf_disable()), i.e.,
> already had their counts saved.

Right, I see no fundamentally impossible things at all, we just need to
be careful here.

Anyway, I poked at the stack I've got now and it seems to hold up when I
poke at it with various combinations of constraint events, so I'll push
that off to Ingo and then we can go from there.

Thanks for working on this!

