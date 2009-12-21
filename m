Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZLUU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZLUU7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbZLUU7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:59:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277AbZLUU7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:59:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=keYB/xnwECMw9WQyZs58JEvZndcI7p1AUjCW4zfm/yWPIa/nmp1ltFUBTL7R/cD/a
	oyrkv+tDerZCFzhbTbT6w==
MIME-Version: 1.0
In-Reply-To: <1261423869.4314.198.camel@laptop>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
	 <1261410040.4314.178.camel@laptop>
	 <bd4cb8900912211100n419ef5b1w5322656b034f909e@mail.gmail.com>
	 <1261423869.4314.198.camel@laptop>
Date: Mon, 21 Dec 2009 21:59:45 +0100
Message-ID: <bd4cb8900912211259u4316ec7ak8baf0da77ecd4793@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, perfmon2-devel@lists.sf.net,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 8:31 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-12-21 at 20:00 +0100, Stephane Eranian wrote:
>
>> >  perf_disable() <-- shut down the full pmu
>> >
>> >  pmu->disable() <-- hey someone got removed (easy free the reg)
>> >  pmu->enable()  <-- hey someone got added (harder, check constraints)
>> >
>> >  hw_perf_group_sched_in() <-- hey a full group got added
>> >                              (better than multiple ->enable)
>> >
>> >  perf_enable() <-- re-enable pmu
>> >
>> >
>> > So ->disable() is used to track freeing, ->enable is used to add
>> > individual counters, check constraints etc..
>> >
>> > hw_perf_group_sched_in() is used to optimize the full group enable.
>> >
>>
>> Does that mean that after a disable() I can assume that there won't
>> be an enable() without a group_sched_in()?
>>
>> I suspect not. In fact, there is a counter-example in perf_ctx_adjust_freq().
>
> Why would that be a problem?
>
> A perf_disable() will simply disable the pmu, but not alter its
> configuration, perf_enable() will program the pmu and re-enable it (with
> the obvious optimization that if the current state and the new state
> match we can skip the actual programming).
>
> If a ->disable() was observed between it will simply not re-enable that
> particular counter, that is it will remove that counters' config, and
> perf_enable() can do a smart reprogram by simply no re-enabling that
> counter.
>
> If an ->enable() or hw_perf_group_sched_in() was observed in between,
> you have to recompute the full state in order to validate the
> availability, if that fails, no state change, if it succeeds you have a
> new pmu state and perf_enable() will program that.
>

Ok, so what you are suggesting is that the assignment is actually done
incrementally in ->enable(). hw_group_sched_in() would simply validate
that a single group is sane (i.e., can be scheduled if it was alone).

> In the case of perf_ctx_adjust_freq():
>
>        if (!interrupts) {
>                perf_disable();
>                event->pmu->disable(event);
>                atomic64_set(&hwc->period_left, 0);
>                event->pmu->enable(event);
>                perf_enable();
>        }
>
> You'll very likely end up with the same state you had before, but if not
> who cares -- its supposed to be an unlikely case.
>
> That is, the ->disable() will clear the cpu_hw_events::used_mask bit.
> The ->enable() will want to place the counter on its last know reg,
> which (not so very surprisingly) will be available, hence it will

Not in the case I am looking at on AMD. The counter you need to grab
depends on what is going on on the other cores on the socket. So
there is no guarantee that you will get the same. Something similar
exists on Nehalem but it has to do with HT.

> trivially succeed, depending on its smarts it might or might not find
> that the 'new' counter's config is identical to the current hw state, if
> not it might set a cpu_hw_event::reprogram state.
>
> perf_enable() will, when it sees cpu_hw_event::reprogram, re-write the
> pmu config and re-enable the whole thing (global ctrl reg, or iterate
> individual EN bits).
