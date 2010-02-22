Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0BVOuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:50:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0BVOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:50:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=tcPa25qBBgnId3Zak1fkt3+LOSLmQCkFviHuV5cPHnm/ZC30KpdpWJqpTn6vuiaV9
	cy1PMkpfcca5FI4JZKcWQ==
MIME-Version: 1.0
In-Reply-To: <1266848978.6122.195.camel@laptop>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
	 <1266142321.5273.409.camel@laptop> <1266531936.2903.58.camel@laptop>
	 <bd4cb8901002220607t2cf7a6eaqb9e8e0c90d18ebf5@mail.gmail.com>
	 <1266848978.6122.195.camel@laptop>
Date: Mon, 22 Feb 2010 15:49:43 +0100
Message-ID: <bd4cb8901002220649n4a71756eh726706adbe2e0e55@mail.gmail.com>
Subject: Re: [RFC] perf_events: how to add Intel LBR support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 3:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-22 at 15:07 +0100, Stephane Eranian wrote:
>> On Thu, Feb 18, 2010 at 11:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Sun, 2010-02-14 at 11:12 +0100, Peter Zijlstra wrote:
>> >>
>> >> Dealing with context switches is also going to be tricky, where we have
>> >> to safe and 'restore' LBR stacks for per-task counters.
>> >
>> > OK, so I poked at the LBR hardware a bit, sadly the TOS really doesn't
>> > count beyond the few bits it requires :-(
>> >
>>
>> The TOS is also a read-only MSR.
>
> well, r/o is fine.
>
Need to restore or stitch LBR entries at some point to get the full sequential
history. this is needed when a thread migrates from one CPU to another.

>> > I had hopes it would, since that would make it easier to share the LBR,
>> > simply take a TOS snapshot when you schedule the counter in, and never
>> > roll back further for that particular counter.
>> >
>> > As it stands we'll have to wipe the full LBR state every time we 'touch'
>> > it, which makes it less useful for cpu-bound counters.
>> >
>> Yes, you need to clean it up each time you snapshot it and each time
>> you restore it.
>>
>> The patch does not seem to handle LBR context switches.
>
> Well, it does, but sadly not in a viable way, it assumes the TOS counts
> more than the required bits and stops the unwind on hwc->lbr_tos
> snapshot. Except that the TOS doesn't work that way.
>
Yes, you cannot simply record a point-in-time and extract the difference
with current TOS value. LBR may wrap around multiple times. You need
to do the basic save and restore.

> This whole PEBS/LBR stuff is a massive trainwreck from a design pov.

LBR is unrelated to PEBS. LBR provides quite some value-add. Thus, it
needs to be supported.

>
>> > Also, not all hw (core and pentium-m) supports the freeze_lbrs_on_pmi
>> > bit, what we could do for those is stick an unconditional LBR disable
>> > very early in the NMI path and simply roll back the stack until we hit a
>> > branch into the NMI vector, that should leave a few usable LBR entries.
>> >
>> You need to be consistent across the CPUs. If a CPU does not provide
>> freeze_on_pmi, then I would simply not support it as a first approach.
>> Same thing if the LBR is less than 4-deep. I don't think you'll get anything
>> useful out of it.
>
> Well, if at the first branch into the NMI handler you do an
> unconditional LBR disable, you should still have 3 usable records. But
> yeah, the 1 deep LBR chips (p6 and amd) are pretty useless for this
> purpose and are indeed not supported.
>
I doubt that by the time you get to the NMI handler, you have not at least
executed 3 branches in some assembly code. I would simply not support
LBR on those processors.

>> The patch does not address the configuration options available on Intel
>> Nehalem/Westmere, i.e., LBR_SELECT (see Vol 3a table 16-9). We can
>> handle priv level separately as it can be derived from the event exclude_*.
>> But it you want to allow multiple events in a group to use PERF_SAMPLE_LBR
>> then you need to ensure LBR_SELECT is set to the same value, priv levels
>> included.
>
> Yes, I explicitly skipped that because of the HT thing and because like
> I argued in an earlier reply, I don't see much use for it, that is, it
> significantly complicates matters for not much (if any) benefit.
>
Well, I want to be able to filter the type of branches captured by LBR
and in particular return branches. Useful if you want to collect a statistical
call graph, for instance. We did that on Itanium a very long time ago, using
their equivalent to LBR (called BTB) and it gave very good results.
Without filtering,
code with loops will inevitably pollute the LBR and the data will be useless for
building a statistical call graph.

> As it stands LBR seems much more like a hw-breakpoint feature than a PMU
> feature, except for this trainwreck called PEBS.
>
I don't understand your comparison. LBR is just a free running cyclic buffer
recording taken branches. You simply want to snapshot it on PMU interrupt.
It is totally independent of PEBS.It does not operate in the same way.

>> Furthermore, LBR_SELECT is shared between HT threads. We need to either
>> add another field in perf_event_attr or encode this in the config
>> field, though it
>> is ugly because unrelated to the event but rather to the sample_type.
>>
>> The patch is missing the sampling part, i.e., dump of the LBR (in sequential
>> order) into the sampling buffer.
>
> Yes, I just hacked enough stuff together to poke at the hardware a bit,
> never said it was anywhere near complete.
>
>> I would also select a better name than PERF_SAMPLE_LBR. LBR is an
>> Intel thing. Maybe PERF_SAMPLE_TAKEN_BRANCH.
>
> Either LAST_BRANCH (suggesting a single entry), or BRANCH_STACK
> (suggesting >1 possible entries) seem more appropriate.
>
> Supporting only a single entry, LAST_BRANCH, seems like an attractive
> enough option, the use of multiple steps back seem rather pointless for
> interpreting the sample.

I would vote for BRANCH_STACK.
