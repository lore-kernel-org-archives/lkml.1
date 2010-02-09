Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0BIVOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:14:08 -0500
Received: from smtp-out.google.com ([216.239.33.17]:25367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0BIVOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:14:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jLitTABKO0sqftOUSe7ITHyVEOW74TfaaDZMKgP4BdVgFHWc/t0hA3xxxaiAPR947
	DuCIHOT0TQucpFr8lYkOw==
MIME-Version: 1.0
In-Reply-To: <20100208184504.GB5130@lenovo>
References: <20100208184504.GB5130@lenovo>
Date: Tue, 9 Feb 2010 22:13:59 +0100
Message-ID: <bd4cb8901002091313h3bc739fbi872567fdb219d752@mail.gmail.com>
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill,

On Mon, Feb 8, 2010 at 7:45 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Hi all,
>
> first of all the patches are NOT for any kind of inclusion. It's not
> ready yet. More likely I'm asking for glance review, ideas, criticism.
>
> The main problem in implementing P4 PMU is that it has much more
> restrictions for event to MSR mapping. So to fit into current
> perf_events model I made the following:
>
> 1) Event representation. P4 uses a tuple of ESCR+CCCR+COUNTER
>   as an "event". Since every CCCR register mapped directly to
>   counter itself and ESCR and CCCR uses only 32bits of their
>   appropriate MSRs, I decided to use "packed" config in
>   in hw_perf_event::config. So that upper 31 bits are ESCR
>   and lower 32 bits are CCCR values. The bit 64 is for HT flag.
>
>   So the base idea here is to pack into 64bit hw_perf_event::config
>   as much info as possible.
>
>   Due to difference in bitfields I needed to implement
>   hw_perf_event::config helper which unbind hw_perf_event::config field
>   from processor specifics and allow to use it in P4 PMU.
>
> 2) ESCR mapping. Since ESCR MSRs are not sequential in address space
>   I introduced a kind of "event template" structure which contains
>   MSR for particular event. This MSRs are tupled in array for 2 values
>   and bind to CCCR index so that HT machine with thread 0 should pick
>   first entry and thread 1 -- second entry.
>
>   If HT is disabled or there is an absence of HT support -- we just use
>   only first counter all the time.
>
>   Ideally would be to modify x86_pmu field values that way that in case
>   of absence of HT we may use all 18 counters at once. Actually there is
>   erratum pointing out that CCCR1 may not have "enable" bit properly working
>   so we should just not use it at all. Ie we may use 17 counters at once.
>
> 3)  Dependant events. Some events (such as counting retired instructions)
>    requires additional "upstream" counter to be armed (for retired instructions
>    this is tagging FSB). Not sure how to handle it properly. Perhaps at moment
>    of scheduling events in we may check out if there is dependant event and
>    then we try to reserve the counter.
>
> 4)  Cascading counters. Well, I suppose we may just not support it for some
>    time.
>
> 5)  Searching the events. Event templates contain (among other fields)
>    "opcode" which is just "ESCR event + CCCR selector" packed so every
>    time I need to find out restriction for particular event I need to
>    walk over templates array and check for same opcode. I guess it will
>    be too slow (well, at moment there a few events, but as only array grow
>    it may become a problem, also iirc some opcodes may intersect).
>
> So the scheme I had in mind was like that:
>
> 1) As only caller asking for some generalized event we pack ESCR+CCCR
>   into "config", check for HT support and put HT bit into config as well.
>
> 2) As events go to schedule for execution need to find out proper
>   hw_perf_event::config into proper template and set proper
>   hw_perf_event::idx (which is just CCCR MSR number\offset) from
>   template. Mark this template as borrowed in global p4_pmu_config
>   space. This allow to find out quickly which ESCR MSR is to be used
>   in event enabling routing.
>
>   Schematically this mapping is
>
>        hw_perf_event::config -> template -> hw_perf_event::idx
>
>   And back at moment of event enabling
>
>        hw_perf_event::idx -> p4_pmu_config[idx] -> template -> ESCR MSR
>
> 3) I've started unbinding x86_schedule_events into per x86_pmu::schedule_events
>   and there I hit hardness in binding HT bit. Have to think...
>
>
> All in one -- If you have some spare minutes, please take a glance. I can't
> say I like this code -- it's overcomplicated and I fear hard to understand.
> and still a bit buggy. Complains are welcome!
>
> So any idea would be great. I'm fine in just DROPPING this approach if we may
> make code simplier. Perhaps I used wrong way from the very beginning.
>
> Stephane, I know you've been (and still is, right?) working on P4 driver
> for libpmu (not sure if I remember correctly this name). Perhaps we should
> take some ideas from there?
>
The library is called libpfm (perfmon) and libpfm4 (perf_events). It has
support for Netburst (pentium4). It does the assignment of events to
counters in user mode. I did not write the P4 support and it was a very long
time ago. I don't recall all the details, except that this was really difficult.
You may want to take a look at pfmlib_pentium4.c.

I am still actively developing libpfm4 for perf_events. The P4 support is
not available because I don't know how perf_events is going to support
it. I'll update the library once that is settled.
