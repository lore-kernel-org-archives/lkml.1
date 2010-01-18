Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643Ab0AROM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0AROM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170Ab0AROM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:12:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0AROM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:12:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Kw2ZK5pJvq8nEXXMYwF4jaRyIfCDYgTmVFyMUsjcN8ru61Vy7YYv3Y0dTTKhFKXk1
	pCm/VakSJWvyilHlDHLzA==
MIME-Version: 1.0
In-Reply-To: <1263822898.4283.558.camel@laptop>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
Date: Mon, 18 Jan 2010 15:12:54 +0100
Message-ID: <bd4cb8901001180612g29369150h9db09470fa6000af@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 2:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-18 at 14:43 +0100, Frederic Weisbecker wrote:
>>
>> Shouldn't we actually use the core based pmu->enable(),disable()
>> model called from kernel/perf_event.c:event_sched_in(),
>> like every other events, where we can fill up the queue of hardware
>> events to be scheduled, and then call a hw_check_constraints()
>> when we finish a group scheduling?
>
> Well the thing that makes hw_perf_group_sched_in() useful is that you
> can add a bunch of events and not have to reschedule for each one, but
> instead do a single schedule pass.
>
That's right.

> That said you do have a point, maybe we can express this particular
> thing differently.. maybe a pre and post group call like:
>
>  void hw_perf_group_sched_in_begin(struct pmu *pmu)
>  int  hw_perf_group_sched_in_end(struct pmu *pmu)
>
The issue with hw_perf_group_sched_in() is that because we do not know
when we are done scheduling, we have to defer actual activation until
hw_perf_enable(). But  we have to still mark the events as ACTIVE,
otherwise things go wrong in the generic layer and for non-PMU events.
That leads to partial duplication of event_sched_in()/event_sched_out()
in the PMU specific layer.

As Frederic pointed out, the more natural way would be to simply rely
on event_sched_in()/event_sched_out() and the rollback logic and just
drop hw_perf_group_sched_in() which is there as an optimization and
not for correctness. Scheduling can be done incrementally from the
event_sched_in() function.

> That way we know we need to track more state for rollback and can give
> the pmu implementation leeway to delay scheduling/availablility tests.
>
Rollback would still be handled by the generic code, wouldn't it?

> Paul, would that work for you too?
>
> Then there's still the question of having events of multiple hw pmus in
> a single group, I'd be perfectly fine with saying that's not allowed,
> what to others think?
>
I have seen requests for measuring both core and uncore PMU events
together for instance. It all depends on how uncore PMU will be managed.
