Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbZLKL7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbZLKL7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZLKL7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:59:11 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:65084 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZLKL7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=jNQ1kFWKiYCEjeUA03r0juPh9nK7+1sJE6BdptmrqagMeDIuYK0oRgmO1/hBxobTUt
         bZqUVzB/WS8EzBTMY9WFr0WdBY9wY/VdUoHKHQtHLaFqoIM1/30dZJ/aAA0hVR1Uzcsm
         6+v2V561EQusw5a2WJVuJKG9l7SIqLHQCosAA=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
Date: Fri, 11 Dec 2009 12:59:16 +0100
Message-ID: <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>,
       eranian@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>>> @@ -1120,9 +1136,15 @@ static void amd_pmu_disable_all(void)
>>>
>>>  void hw_perf_disable(void)
>>>  {
>>> +     struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>> +
>>>       if (!x86_pmu_initialized())
>>>               return;
>>> -     return x86_pmu.disable_all();
>>> +
>>> +     if (cpuc->enabled)
>>> +             cpuc->n_events = 0;
>>> +
>>> +     x86_pmu.disable_all();
>>>  }
>>
>> Right, so I cannot directly see the above being correct. You fully erase
>> the PMU state when we disable it, but things like single counter
>> add/remove doesn't reprogram the full PMU afaict.
>>

>>> +int hw_perf_group_sched_in(struct perf_event *leader,
>>> +            struct perf_cpu_context *cpuctx,
>>> +            struct perf_event_context *ctx, int cpu)
>>> +{
>>> +     struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
>>> +     int n, ret;
>>> +
>>> +     n = collect_events(cpuhw, leader);
>>> +     if (n < 0)
>>> +             return n;
>>> +
>>> +     ret = schedule_events(cpuhw, n, true);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     /* 0 means successful and enable each event in caller */
>>> +     return 0;
>>> +}
>>
>> This is where powerpc does n_added += n, and it delays the
>> schedule_events() bit to hw_perf_enable() conditional on n_added > 0.
>> When you remove events it simply keeps the current layout and disables
>> the one.
>>
There is a major difference between PPC and X86 here. PPC has a centralized
register to control start/stop. This register  uses bitmask  to enable
or disable counters. Thus, in hw_perf_enable(), if n_added=0, then you
just need to
use the pre-computed bitmask. Otherwise, you need to recompute the bitmask to
include the new registers. The assignment of events and validation is done in
hw_group_sched_in().

In X86, assignment and validation is done in hw_group_sched_in(). Activation is
done individually for each counter. There is no centralized register
used here, thus
no bitmask to update.

Disabling a counter does not trigger a complete reschedule of events.
This happens
only when hw_group_sched_in() is called.

The n_events = 0 in hw_perf_disable() is used to signal that something
is changing.
It should not be here but here. The problem is that
hw_group_sched_in() needs a way
to know that it is called for a completely new series of group
scheduling so it can
discard any previous assignment. This goes back to the issue I raised
in my previous
email. You could add a parameter to hw_group_sched_in() that would
indicate this is
the first group. that would cause n_events =0 and the function would
start accumulating
events for the new scheduling period.
