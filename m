Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BJQCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:02:04 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab0BJQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:02:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=XF4H54D1wnzsYRvcJw695m522Xi6497ipg5wnzbtCnLvrLi8+junQOweCRmTzgRFb
	QmyT9eFh120IL4iWJ3Hxw==
MIME-Version: 1.0
In-Reply-To: <20100210154638.GJ24679@erda.amd.com>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
	 <20100210154638.GJ24679@erda.amd.com>
Date: Wed, 10 Feb 2010 17:01:45 +0100
Message-ID: <bd4cb8901002100801p50e2450x25e3004a0f45cff7@mail.gmail.com>
Subject: Re: [RFC] perf_events: how to add Intel LBR support
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 4:46 PM, Robert Richter <robert.richter@amd.com> wrote:
> Stephane,
>
> On 10.02.10 12:31:16, Stephane Eranian wrote:
>> I started looking into how to add LBR support to perf_events. We have LBR
>> support in perfmon and it has proven very useful for some measurements.
>>
>> The usage model is that you always couple LBR with sampling on an event.
>> You want the LBR state dumped into the sample on overflow. When you resume,
>> after an overflow, you clear LBR and you restart it.
>>
>> One obvious implementation would be to add a new sample type such as
>> PERF_SAMPLE_TAKEN_BRANCHES. That would generate a sample with
>> a body containing an array of 4x2 up to 16x2 u64 addresses. Internally, the
>> hw_perf_event_structure would have to store the LBR state so it could be
>> saved and restored on context switch in per-thread mode.
>>
>> There is one problem with this approach. On Nehalem, the LBR can be configured
>> to capture only certain types of branches + priv levels. That is about
>> 8 config bits
>> + priv levels. Where do we pass those config options?
>
I was referring to the fact that if I enable LBR via a PERF_SAMPLE_* bit, I
will actually need more than one bit because there are configuration options.
I was not talking about event_attr.config.

> The basic idea for IBS is to define special pmu events that have a
> different behaviour than standard events (on x86 these are performance
> counters). The 64 bit configuration value of such an event is simply
> marked as a special event. The pmu detects the type of the model
> specific event and passes its value to the hardware. Doing so you can
> pass any kind of configuration data to a certain pmu.
>
Isn't that what the event_attr.type field is used for? there is a RAW type.
I use it all the time. As for passing to the PMU specific code, this is
already what it does based on event_attr.type.

> The sample data you get in this case could be either packed into the
> standard perf_event sampling format, or if this does not fit, the pmu
> may return raw samples in a special format the userland knows about.
>
There is a PERF_SAMPLE_RAW (used by tracing?). It can return opaque
data of variable length.

There is a slight difference between IBS and LBR. LBR in itself does not
generate any interrupts. It has no associated period you arm. It is a free
running cyclic buffer. To be useful, it needs to be associated with a regular
counting event, e.g, BRANCH_INSTRUCTIONS_RETIRED. Thus, you
would need to set PERF_SAMPLE_TAKEN_BRANCH on this event, and
then you would expect the LBR data coming back as PERF_SAMPLE_RAW.


If you use the other approach with a dedicated event type. For instance:

event.type = PERF_TYPE_HW_BRANCH;
event.config  = PERF_HW_BRANCH:TAKEN:ANY

I used a symbolic name to make things clearer (but it is the same model as
for the cache events).

Then you need to group this event with BRANCH_INSTRUCTIONS_RETIRED
and set PERF_SAMPLE_GROUP to collect the values of the other member
of the group. In that case, the other member is LBR but it has a value that
is more than 64 bits. That does not work with the current code.


> The interface extension is adopting the perfmon2 model specific pmu
> setup where you can pass config values to the pmu and return
> performance data from it. The implementation is architecture
> independent and compatible with the current interface. The only change
> to the api is an additional bit to the perf_event_attr to mark the raw
> config value as model specific.
>
>> An alternative approach is to define a new type of (pseudo)-event, e.g.,
>> PERF_TYPE_HW_BRANCH and provide variations very much like this is
>> done for the generic cache events. That event would be associated with a
>> new fixed-purpose counter (similar to BTS). It would go through scheduling
>> via a specific constraint (similar to BTS). The hw_perf_event structure
>> would provide the storage area for dumping LBR state.
>>
>> To sample on LBR with the event approach, the LBR event would have to
>> be in the same event group. The sampling event would then simply add
>> sample_type = PERF_SAMPLE_GROUP.
>>
>> The second approach looks more extensible, flexible than the first one. But
>> it runs into a major problem with the current perf_event API/ABI and
>> implementation. The current assumption is that all events never return more
>> than 64-bit worth of data. In the case of LBR, we would need to return way
>> more than this.
>
> My implementation just need one 64 bit config value, but it could be
> extended to use more than one config value too.
>
Ok, I'll wait for the code then.
