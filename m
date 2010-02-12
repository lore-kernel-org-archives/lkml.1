Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0BLKcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:32:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0BLKcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:32:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Nu/9AV8Qxy3GQnSeaOrISnducX5BDsa7mPeQx15ARq8McuSvrWSaH8qR1Ekquwof4
	/ONAXU/qz4oOZ8c0REIdw==
MIME-Version: 1.0
In-Reply-To: <20100211222441.GA6027@erda.amd.com>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
	 <20100210154638.GJ24679@erda.amd.com>
	 <bd4cb8901002100801p50e2450x25e3004a0f45cff7@mail.gmail.com>
	 <20100211222441.GA6027@erda.amd.com>
Date: Fri, 12 Feb 2010 11:32:07 +0100
Message-ID: <bd4cb8901002120232u52302b89rbb1c478c47c3582e@mail.gmail.com>
Subject: Re: [RFC] perf_events: how to add Intel LBR support
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert.

On Thu, Feb 11, 2010 at 11:24 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 10.02.10 17:01:45, Stephane Eranian wrote:
>> I was referring to the fact that if I enable LBR via a PERF_SAMPLE_* bit, I
>> will actually need more than one bit because there are configuration options.
>> I was not talking about event_attr.config.
>
> I am not sure how big a LBR sample would be, but couldn't you send the
> whole sample to the userland as a raw sample? If this is too much
> overhead and you need to configure the formate, you could set up this
> using a small part of the config value.
>
>> > The basic idea for IBS is to define special pmu events that have a
>> > different behaviour than standard events (on x86 these are performance
>> > counters). The 64 bit configuration value of such an event is simply
>> > marked as a special event. The pmu detects the type of the model
>> > specific event and passes its value to the hardware. Doing so you can
>> > pass any kind of configuration data to a certain pmu.
>
>> Isn't that what the event_attr.type field is used for? there is a RAW type.
>> I use it all the time. As for passing to the PMU specific code, this is
>> already what it does based on event_attr.type.
>
> I mean, you could setup the pmu with a raw config value. The samples
> you return are in raw format too. Doing so, you could put in all
> information, also that about the sample format into you
> configuration. Of course there must be a way for values more than 64
> bits.

Not quite for LBR. But I would do that for IBS. I mean define
pseudo-events with unique event selects that can be identified by
the kernel. Then for the rest, I would do:

- The IBS periods can be passed in  attr.period. the frequency may be doable.
- I would ignore the random mode of IBSFETCH for now. Randomization must
  be added in the general case anyway, thus we could leverage that later on.
- Then use PERF_SAMPLE_RAW to collect the IBS data.

Internally, the kernel would identify, in the scheduling code for AMD, these
special events, very much like what is done for BTS in
intel_special_constraints().
IBSFETCH and IBSOP  would have pseudo fixed-purpose counters assigned (similar
to BTS). They would go through the nornal x86_schedule_events()
routine. Given they
are provided by only one fixed-purpose counter, that would
automatically reject attempts
to use IBSOP/IBSFETCH multiple times per event group. On overflow, the
handler would
dump the IBS data registers into the data.raw area.

They are thing, however, you cannot do with non counting events. You cannot
count and therefore you cannot aggregate across threads.


But here is a key difference with LBR: if you use a pseudo-event for LBR, you
cannot use PERF_SAMPLE_RAW. That's because LBR does NOT interrupt. You
always need to associate it with another counting events. So it must be used
with an event pair. Setting PERF_SAMPLE_RAW on the counting event does not
make sense. There is no raw data associated with the counting event. You need
to read PERF_SAMPLE_READ+PERF_FORMAT_GROUP.

If you go with  the PERF_SAMPLE_LBR sample_type approach. You are right,
you would need to encode LBR settings into the config field. But that's awkward.
The config field relates to the event and not its sample_type bitmask.
And AFAIK,
the sample_type is meant to have generic features, not model specific ones. And
internally it would be more difficult to manage because you would need an extra
per-event storage area to save/restore LBR.

One thing possible, though, is to define a pseudo model-specific event
for LBR, e.g.
LBR_EVENT instead of defining a new event type (PERF_TYPE_HW_BRANCH).
That would leave this as a model specific feature which I think it is
for now. I think
some of the LBR setup is now architected by Intel.

Anyway, I am working on getting LBR support. I got some promising results
already. Will update you once I have a clean and working solution.

> The problem with the current x86 implementation is that it expects a
> raw config value in the performance counter format. To mark the config
> as different, I would simply introduce a bit in event_attr that marks
> it as special event.
>
>> > The sample data you get in this case could be either packed into the
>> > standard perf_event sampling format, or if this does not fit, the pmu
>> > may return raw samples in a special format the userland knows about.
>> >
>> There is a PERF_SAMPLE_RAW (used by tracing?). It can return opaque
>> data of variable length.
>>
>> There is a slight difference between IBS and LBR. LBR in itself does not
>> generate any interrupts. It has no associated period you arm. It is a free
>> running cyclic buffer. To be useful, it needs to be associated with a regular
>> counting event, e.g, BRANCH_INSTRUCTIONS_RETIRED. Thus, you
>> would need to set PERF_SAMPLE_TAKEN_BRANCH on this event, and
>> then you would expect the LBR data coming back as PERF_SAMPLE_RAW.
>>
>>
>> If you use the other approach with a dedicated event type. For instance:
>>
>> event.type = PERF_TYPE_HW_BRANCH;
>> event.config  = PERF_HW_BRANCH:TAKEN:ANY
>>
>> I used a symbolic name to make things clearer (but it is the same model as
>> for the cache events).
>>
>> Then you need to group this event with BRANCH_INSTRUCTIONS_RETIRED
>> and set PERF_SAMPLE_GROUP to collect the values of the other member
>> of the group. In that case, the other member is LBR but it has a value that
>> is more than 64 bits. That does not work with the current code.
>
> There are several questions: How to attach additional setup options to
> an event? Grouping seems to be a solution for this. How to pass config
> values with more than 64 bits to the pmu? An extension of the api is
> probably needed, or grouping could work too. How to get samples back?
> The raw sample format is the best to use here. For IBS the difference
> is that the configuration has nothing to do with performance counters
> and a raw config value needs differen handling.
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
