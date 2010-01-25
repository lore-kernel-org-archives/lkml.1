Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554Ab0AYRsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0AYRsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464Ab0AYRsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:48:15 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:21595 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0AYRsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:48:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=RCHnYsvJihDALNfcsYE7C7mJ8h3NJ3xJe5OM2vzEoTnxI/+DPKp+QnY+Pdsjt3Uz1X
         todPn7WNTE7F6C46IYndQYZa0UlGC+ONiXe87W1EE7M4M5/HrwI3R/cgBjDOaJ4BX2UD
         LFhTuH0g5aOwvRhqBxX9ymmH7KWBAQc+KvN/o=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1264440342.4283.1936.camel@laptop>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
	 <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
	 <1264440342.4283.1936.camel@laptop>
Date: Mon, 25 Jan 2010 18:48:11 +0100
Message-ID: <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v6 
	incremental)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 6:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-25 at 18:12 +0100, stephane eranian wrote:
>> On Fri, Jan 22, 2010 at 9:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2010-01-21 at 17:39 +0200, Stephane Eranian wrote:
>> >> @@ -1395,40 +1430,28 @@ void hw_perf_enable(void)
>> >>                  * apply assignment obtained either from
>> >>                  * hw_perf_group_sched_in() or x86_pmu_enable()
>> >>                  *
>> >> -                * step1: save events moving to new counters
>> >> -                * step2: reprogram moved events into new counters
>> >> +                * We either re-enable or re-program and re-enable.
>> >> +                * All events are disabled by the time we come here.
>> >> +                * That means their state has been saved already.
>> >>                  */
>> >
>> > I'm not seeing how it is true.
>>
>> > Suppose a core2 with counter0 active counting a non-restricted event,
>> > say cpu_cycles. Then we do:
>> >
>> > perf_disable()
>> >  hw_perf_disable()
>> >    intel_pmu_disable_all
>> >      wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> >
>> everything is disabled globally, yet individual counter0 is not.
>> But that's enough to stop it.
>>
>> > ->enable(MEM_LOAD_RETIRED) /* constrained to counter0 */
>> >  x86_pmu_enable()
>> >    collect_events()
>> >    x86_schedule_events()
>> >    n_added = 1
>> >
>> >    /* also slightly confused about this */
>> >    if (hwc->idx != -1)
>> >      x86_perf_event_set_period()
>> >
>>
>> In x86_pmu_enable(), we have not yet actually assigned the
>> counter to hwc->idx. This is only accomplished by hw_perf_enable().
>> Yet, x86_perf_event_set_period() is going to write the MSR.
>>
>> My understanding is that you never call enable(event) in code
>> outside of a perf_disable()/perf_enable() section.
>
> That should be so yes, last time I verified that is was. Hence I'm a bit
> puzzled by that set_period(), hw_perf_enable() will assign ->idx and do
> set_period() so why also do it here...
>

Ok, so I think we can drop set_period() from enable(event).

>> > perf_enable()
>> >  hw_perf_enable()
>> >
>> >    /* and here we'll assign the new event to counter0
>> >     * except we never disabled it... */
>> >
>> You will have two events, scheduled, cycles in counter1
>> and mem_load_retired in counter0. Neither hwc->idx
>> will match previous state and thus both will be rewritten.
>
> And by programming mem_load_retires you just wiped the counter value of
> the cycle counter, there should be an x86_perf_event_update() in between
> stopping the counter and moving that configuration.
>
>> I think the case you are worried about is different. It is the
>> case where you would move an event to a new counter
>> without replacing it with a new event. Given that the individual
>> MSR.en would still be 1 AND that enable_all() enables all
>> counters (even the ones not actively used), then we would
>> get a runaway counter so to speak.
>>
>> It seems a solution would be to call x86_pmu_disable() before
>> assigning an event to a new counter for all events which are
>> moving. This is because we cannot assume all events have been
>> previously disabled individually. Something like
>>
>> if (!match_prev_assignment(hwc, cpuc, i)) {
>>    if (hwc->idx != -1)
>>       x86_pmu.disable(hwc, hwc->idx);
>>    x86_assign_hw_event(event, cpuc, cpuc->assign[i]);
>>    x86_perf_event_set_period(event, hwc, hwc->idx);
>> }
>
> Yes and no, my worry is not that its not counting, but that we didn't
> store the actual counter value before over-writing it with the new
> configuration.
>
> As to your suggestion,
>  1) we would have to do x86_pmu_disable() since that does
> x86_perf_event_update().
>  2) I worried about the case where we basically switch two counters,
> there we cannot do the x86_perf_event_update() in a single pass since
> programming the first counter will destroy the value of the second.
>
> Now possibly the scenario in 2 isn't possible because the event
> scheduling is stable enough for this never to happen, but I wasn't
> feeling too sure about that, so I skipped this part for now.
>
I think what adds to the complexity here is that there are two distinct
disable() mechanisms: perf_disable() and x86_pmu.disable(). They
don't operate the same way. You would think that by calling hw_perf_disable()
you would stop individual events as well (thus saving their values). That
means that if you do perf_disable() and then read the count, you will not
get the up-to-date value in event->count. you need pmu->disable(event)
to ensure that.

So my understanding is that perf_disable() is meant for a temporary stop,
thus no need to save the count.

As for 2, I believe this can happen if you add 2 new events which have more
restrictions. For instance on Core, you were measuring cycles, inst in generic
counters, then you add 2 events which can only be measured on generic counters.
That will cause cycles, inst to be moved to fixed counters.

So we have to modify hw_perf_enable() to first disable all events
which are moving,
then reprogram them. I suspect it may be possible to optimize this if
we detect that
those events had already been stopped individually (as opposed to
perf_disable()), i.e.,
already had their counts saved.



>
