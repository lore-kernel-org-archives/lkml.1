Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360Ab0AYRMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0AYRMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300Ab0AYRMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:12:24 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:52330 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0AYRMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:12:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=av1sf5LLyK4ufAblxNWios+hzzUPi+ZodSqHZSKJqU+DvWKbWu1NlZgUw7uSY9E5Nf
         B0tNMQg7mxbTewMK4wpPvDArNO+BYEM8RuliHmuR974vF1jfCd7+c1DcGtAInnhInaVc
         KoeggLH3D6NGTU6gcbRWw0Emh5w2vKGMN+qhc=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1264192074.4283.1602.camel@laptop>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
Date: Mon, 25 Jan 2010 18:12:21 +0100
Message-ID: <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
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

On Fri, Jan 22, 2010 at 9:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 17:39 +0200, Stephane Eranian wrote:
>> @@ -1395,40 +1430,28 @@ void hw_perf_enable(void)
>>                  * apply assignment obtained either from
>>                  * hw_perf_group_sched_in() or x86_pmu_enable()
>>                  *
>> -                * step1: save events moving to new counters
>> -                * step2: reprogram moved events into new counters
>> +                * We either re-enable or re-program and re-enable.
>> +                * All events are disabled by the time we come here.
>> +                * That means their state has been saved already.
>>                  */
>
> I'm not seeing how it is true.

> Suppose a core2 with counter0 active counting a non-restricted event,
> say cpu_cycles. Then we do:
>
> perf_disable()
>  hw_perf_disable()
>    intel_pmu_disable_all
>      wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>
everything is disabled globally, yet individual counter0 is not.
But that's enough to stop it.

> ->enable(MEM_LOAD_RETIRED) /* constrained to counter0 */
>  x86_pmu_enable()
>    collect_events()
>    x86_schedule_events()
>    n_added = 1
>
>    /* also slightly confused about this */
>    if (hwc->idx != -1)
>      x86_perf_event_set_period()
>

In x86_pmu_enable(), we have not yet actually assigned the
counter to hwc->idx. This is only accomplished by hw_perf_enable().
Yet, x86_perf_event_set_period() is going to write the MSR.

My understanding is that you never call enable(event) in code
outside of a perf_disable()/perf_enable() section.

> perf_enable()
>  hw_perf_enable()
>
>    /* and here we'll assign the new event to counter0
>     * except we never disabled it... */
>
You will have two events, scheduled, cycles in counter1
and mem_load_retired in counter0. Neither hwc->idx
will match previous state and thus both will be rewritten.

I think the case you are worried about is different. It is the
case where you would move an event to a new counter
without replacing it with a new event. Given that the individual
MSR.en would still be 1 AND that enable_all() enables all
counters (even the ones not actively used), then we would
get a runaway counter so to speak.

It seems a solution would be to call x86_pmu_disable() before
assigning an event to a new counter for all events which are
moving. This is because we cannot assume all events have been
previously disabled individually. Something like

if (!match_prev_assignment(hwc, cpuc, i)) {
   if (hwc->idx != -1)
      x86_pmu.disable(hwc, hwc->idx);
   x86_assign_hw_event(event, cpuc, cpuc->assign[i]);
   x86_perf_event_set_period(event, hwc, hwc->idx);
}

>    intel_pmu_enable_all()
>      wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, intel_ctrl)
>
> Or am I missing something?
>
