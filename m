Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZLUTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZLUTA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZLUTAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:00:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZLUTAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:00:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rIWZkcgoF1wf1NRDmn9ZPuQyTEqQNAKf+1p4mcv4uRi5A6OUUBjPb8NuLY+I/QHFo
	Y2Y+lOTqQBEzAp3Hibe7A==
MIME-Version: 1.0
In-Reply-To: <1261410040.4314.178.camel@laptop>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
	 <1261410040.4314.178.camel@laptop>
Date: Mon, 21 Dec 2009 20:00:19 +0100
Message-ID: <bd4cb8900912211100n419ef5b1w5322656b034f909e@mail.gmail.com>
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

Hi,

[Repost because of HTML]

On Mon, Dec 21, 2009 at 4:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, 2009-12-11 at 12:59 +0100, stephane eranian wrote:
>
> > There is a major difference between PPC and X86 here. PPC has a
> > centralized register to control start/stop. This register  uses
> > bitmask to enable or disable counters. Thus, in hw_perf_enable(), if
> > n_added=0, then you just need to use the pre-computed bitmask.
> > Otherwise, you need to recompute the bitmask to include the new
> > registers. The assignment of events and validation is done in
> > hw_group_sched_in().
> >
> > In X86, assignment and validation is done in hw_group_sched_in().
> > Activation is done individually for each counter. There is no
> > centralized register used here, thus no bitmask to update.
>
> intel core2 has the global control reg, but for all intents and purposes
> the perf_enable/disable calls emulate this global enable/disable.
>
> > Disabling a counter does not trigger a complete reschedule of events.
> > This happens only when hw_group_sched_in() is called.
> >
> > The n_events = 0 in hw_perf_disable() is used to signal that something
> > is changing. It should not be here but here. The problem is that
> > hw_group_sched_in() needs a way to know that it is called for a
> > completely new series of group scheduling so it can discard any
> > previous assignment. This goes back to the issue I raised in my
> > previous email. You could add a parameter to hw_group_sched_in() that
> > would indicate this is the first group. that would cause n_events =0
> > and the function would start accumulating events for the new
> > scheduling period.
>
> I'm not really seeing the problem here...
>
>
>  perf_disable() <-- shut down the full pmu
>
>  pmu->disable() <-- hey someone got removed (easy free the reg)
>  pmu->enable()  <-- hey someone got added (harder, check constraints)
>
>  hw_perf_group_sched_in() <-- hey a full group got added
>                              (better than multiple ->enable)
>
>  perf_enable() <-- re-enable pmu
>
>
> So ->disable() is used to track freeing, ->enable is used to add
> individual counters, check constraints etc..
>
> hw_perf_group_sched_in() is used to optimize the full group enable.
>

Does that mean that after a disable() I can assume that there won't
be an enable() without a group_sched_in()?

I suspect not. In fact, there is a counter-example in perf_ctx_adjust_freq().

> Afaict that is what power does (Paul?) and that should I think be
> sufficient to track x86 as well.
>
> Since sched_in() is balanced with sched_out(), the ->disable() calls
> should provide the required information as to the occupation of the pmu.
> I don't see the need for more hooks.
>
> Paul, could you comment, since you did all this for power?
>
