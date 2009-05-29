Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZE2Knh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZE2Knh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZE2Kn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:43:29 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40542 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZE2Kn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=pmaiC8GK72efcvSrm0SG5xIzNnbY8ZIlQ0L7BXS5eYEhGWGIqirWo1bhhKUSUpmdSx
         U3jijYDtxEXyUNAcMeeE8LdTGuVrY5J4iHFowa9138qURIEMZE+5MQno1rk9UVx1wEfT
         2XqHPM4QqCioMbtHSPBrFA7GmaypxcWXvHOUs=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1243527919.6645.75.camel@laptop>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop>
Date: Fri, 29 May 2009 12:43:27 +0200
Message-ID: <7c86c4470905290343q2ec107f1o81a7b80232e42080@mail.gmail.com>
Subject: Re: comments on Performance Counters for Linux (PCL)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 28, 2009 at 6:25 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> I/ General API comments
>>
>>   1/ Data structures
>>
>>      * struct perf_counter_hw_event
>>
>>      - I think this structure will be used to enable non-counting features,
>>        e.g. IBS. Name is awkward. It is used to enable non-hardware events
>>        (sw events). Why not call it: struct perf_event
>
> Sure a name change might be a good idea.
>
In that case, the open syscall should also be changed to something
more generic: perf_open()


>>      - uint64_t irq_period
>>
>>        IRQ is an x86 related name. Why not use smpl_period instead?
>
> don't really care, but IRQ seems used throughout linux, we could name
> the thing interrupt or sample period.
>
IRQ is well understood by kernel people and I agree it is not X86 specific.
But we are talking about user level developers, some not really software
engineers either, e.g., physicists.


>>      - uint32_t record_type
>>
>>        This field is a bitmask. I believe 32-bit is too small to accommodate
>>        future record formats.
>
> It currently controls 8 aspects of the overflow entry, do you really
> forsee the need for more than 32?
>
Again, given the perf_open() syscall is not on a critical path, it does not
hurt to pass a bigger struct and have provision for future extensions.

>>      - uint32_t read_format
>>
>>        Ditto.
>
> I guess it doesn't hurt extending them..

Exactly.

>>      - uint64_t exclude_*
>
>>        What is the meaning of exclude_user? Which priv levels are actually
>>        excluded?
>
> userspace
>
This is a fuzzy notion.

>>        Take Itanium, it has 4 priv levels and the PMU counters can monitor at
>>        any priv levels or combination thereof?
>
> x86 has more priv rings too, but linux only uses 2, kernel (ring 0) and
> user (ring 2 iirc). Does ia64 expose more than 2 priv levels in linux?
>
X86 has priv level 0,1,2,3. The issue, though, it that the X86 PMU only
distinguishes 2 coarse levels: OS, USR. Where OS=0, USR=1,2,3.

IA64 has also 4 levels, but the difference is that the PMU can filter on
all 4 levels independently. The question is then, what does exclude_user
actually encompass there?

And then, there is VT on X86 and IA64...
AMD64 PMU as of family 10h has host and guest filters in the
PERFEVTSEL registers.


>>        When programming raw HW events, the priv level filtering is typically
>>        already included. Which setting has priority, raw encoding or the
>>        exclude_*?
>>
>>        Looking at the existing X86 implementation, it seems exclude_* can
>>        override whatever is set in the raw event code.
>>
>>        For any events, but in particular, SW events, why not encode this in
>>        the config field, like it is for a raw HW event?
>
> Because config is about what we count, this is about where we count.
> Doesn't seem strange to separate these two.
>
For a monitor tool, this means it may need to do the work twice.

Imagine, I encode events using strings: INST_RETIRED:u=1:k=1.
This means measure INST_RETIRED, at user level and kernel level.
You typically pass this to a helper library and you get back the raw
event code, which includes the priv level mask. If that library is generic
and does not know about PCL, then the tool needs to extract either
from the raw code or the string, the priv level information to set the
exclude_* fields accordingly. The alternative is to make the library
PCL-aware and have it set the perf_event structure directly.


>>      * struct perf_counter_mmap_page
>>        Given there is only one counter per-page, there is an awful lot of
>>        precious RLIMIT_MEMLOCK space wasted for this.
>>
>>        Typically, if you are self-sampling, you are not going to read the
>>        current value of the sampling period. That re-mapping trick is only
>>        useful when counting.
>>
>>        Why not make these two separate mappings (using the mmap offset as
>>        the indicator)?
>>
>>        With this approach, you would get one page back per sampling period
>>        and that page could then be used for the actual samples.
>
> Not quite, you still need a place for the data_head.
>
You could put it at the beginning of the actual buffer. But then, I
suspect it will
break the logic you have in data_head (explained below).


>>  2/ System calls
>>
>>      * ioctl()
>>
>>        You have defined 3 ioctls() so far to operate on an existing event.
>>        I was under the impression that ioctl() should not be used except for
>>        drivers.
>
> 4 actually.
>
Why not use 4 new syscalls instead of using ioctl().

>>      * prctl()
>>
>>        The API is event-based. Each event gets a file descriptor. Events are
>>        therefore managed individually. Thus, to enable/disable, you need to
>>        enable/disable each one separately.
>>
>>        The use of prctl() breaks this design choice. It is not clear what you
>>        are actually enabling. It looks like you are enabling all the counters
>>        attached to the thread. This is incorrect. With your implementation,
>>        the PMU can be shared between competing users. In particular, multiple
>>        tools may be monitoring the same thread. Now, imagine, a tool is
>>        monitoring a self-monitoring thread which happens to start/stop its
>>        measurement using prctl(). Then, that would also start/stop the
>>        measurement of the external tool. I have verified that this is what is
>>        actually happening.
>
> Recently changed that, it enables/disables all counters created by the
> task calling prctl().
>
And attached that what? Itself or anything?

>>        I believe this call is bogus and it should be eliminated. The interface
>>        is exposing events individually therefore they should be controlled
>>        individually.
>
> Bogus maybe not, superfluous, yeah, its a simpler way than iterating all
> the fds you just created, saves a few syscalls.
>
Well, my point was that it does not fit well with your file descriptor oriented
API.


>
>>  3/ Counter width
>>
>>        It is not clear whether or not the API exposes counters as 64-bit wide
>>        on PMUs which do not implement 64-bit wide counters.
>>
>>        Both irq_period and read() return 64-bit integers. However, it appears
>>        that the implementation is not using all the bits. In fact, on X86, it
>>        appears the irq_period is truncated silently. I believe this is not
>>        correct. If the period is not valid, an error should be returned.
>>        Otherwise, the tool will be getting samples at a rate different than
>>        what it requested.
>
> Sure, fail creation when the specified period is larger than the
> supported counter width -- patch welcome.
>
Yes, but then that means tools need to know on which counter
the event is going to be programmed. Not all counters may have the
same width.

>>        I would assume that on the read() side, counts are accumulated as
>>        64-bit integers. But if it is the case, then it seems there is an
>>        asymmetry between period and counts.
>>
>>        Given that your API is high level, I don't think tools should have to
>>        worry about the actual width of a counter. This is especially true
>>        because they don't know which counters the event is going to go into
>>        and if I recall correctly, on some PMU models, different counters can
>>        have different width (Power, I think).
>>
>>        It is rather convenient for tools to always manipulate counters as
>>        64-bit integers. You should provide a consistent view between counts
>>        and periods.
>
> So you're suggesting to artificually strech periods by say composing a
> single overflow from smaller ones, ignoring the intermediate overflow
> events?
>
Yes, you emulate actual 64-bit wide counters. In the case of perfmon,
there is no notion of sampling period. All counters are exposed as 64-bit
wide. You can write any value you want into a counter. If you want a period p,
then you program the counter to -p. The period p may be larger than the width
of the actual counter. That means you will get intermediate overflows. A final
overflow will make the 64-bit value wrap around and that's when you
record a sample.

>>  4/ Grouping
>>
>>        By design, an event can only be part of one group at a time. Events in
>>        a group are guaranteed to be active on the PMU at the same time. That
>>        means a group cannot have more events than there are available counters
>>        on the PMU. Tools may want to know the number of counters available in
>>        order to group their events accordingly, such that reliable ratios
>>        could be computed. It seems the only way to know this is by trial and
>>        error. This is not practical.
>
> Got a proposal to ammend this?
>
Either add a syscall for that, or better, expose this via sysfs.

>>  5/ Multiplexing and scaling
>>
>>        The PMU can be shared by multiple programs each controlling a variable
>>        number of events. Multiplexing occurs by default unless pinned is
>>        requested. The exclusive option only guarantees the group does not
>>        share the PMU with other groups while it is active, at least this is
>>        my understanding.
>
> We have pinned and exclusive. pinned means always on the PMU, exclusive
> means when on the PMU no-one else can be.
>
exclusive: no sharing even if the group does not use all the counters
AND they are
                other events waiting for the resource. Right?

>>        By default, you may be multiplexed and if that happens you cannot know
>>        unless you request the timing information as part of the read_format.
>>        Without it, and if multiplexing has occurred, bogus counts may be
>>        returned with no indication whatsoever.
>
> I don't see the problem, you knew they could get multiplexes, yet you
> didn't ask for the information needed to extrapolate the information,
> sounds like you get what you aksed for.
>
The API specification must then clearly say: events and groups of events
are multiplexed by default. Scaling is not done automatically.

>>        To avoid returning misleading information, it seems like the API should
>>        refuse to open a non-pinned event which does not have
>>        PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING in the
>>        read_format. This would avoid a lot of confusion down the road.
>
> I prefer to give people rope and tell them how to tie the knot.
>
This is a case of silent error. I suspect many people will fall into that trap.
Need to make sure documentation warns about that.

>>  7/ Multiplexing and system-wide
>>
>>        Multiplexing is time-based and it is hooked into the timer tick. At
>>        every tick, the kernel tries to schedule another group of events.
>>
>>        In tickless kernels if a CPU is idle, no timer tick is generated,
>>        therefore no multiplexing occurs. This is incorrect. It's not because
>>        the CPU is idle, that there aren't any interesting PMU events to measure.
>>        Parts of the CPU may still be active, e.g., caches and buses. And thus,
>>        it is expected that multiplexing still happens.
>>
>>        You need to hook up the timer source for multiplexing to something else
>>        which is not affected by tickless.
>
> Or inhibit nohz when there are active counters, but good point.
>
Don't want do use nohz because you would be modifying the system
you're trying to monitor.

>>  8/ Controlling group multiplexing
>>
>>        Although, multiplexing is somehow exposed to user via the timing
>>        information.  I believe there is not enough control. I know of advanced
>>        monitoring tools which needs to measure over a dozen events in one
>>        monitoring session. Given that the underlying PMU does not have enough
>>        counters OR that certain events cannot be measured together, it is
>>        necessary to split the events into groups and multiplex them. Events
>>        are not grouped at random AND groups are not ordered at random either.
>>        The sequence of groups is carefully chosen such that related events are
>>        in neighboring groups such that they measure similar parts of the
>>        execution.  This way you can mitigate the fluctuations introduced by
>>        multiplexing and compare ratios. In other words, some tools may want to
>>        control the order in which groups are scheduled on the PMU.
>
> Current code RR groups in the order they are created, is more control
> needed?
>
I understand the creation order in the case of a single tool.

My point was more in the case of multiple groups from multiple tools competing.
Imagine, Tool A and B want to monitor thread T. A has 3 groups, B 2 groups.
imagine all groups are exclusive. Does this mean that all groups of A will be
multiplexed and THEN all groups of B, or can they be interleaved, e.g. 1 group
from A, followed by 1 group from B?

This behavior has to be clearly spelled out by the API.


>>  9/ Event buffer
>>
>>        There is a kernel level event buffer which can be re-mapped read-only at
>>        the user level via mmap(). The buffer must be a multiple of page size
>
> 2^n actually
>
Yes. But this is rounded-up to pages because of remapping. So better make use
of the full space.


>>        and must be at least 2-page long. The First page is used for the
>>        counter re-mapping and buffer header, the second for the actual event
>>        buffer.
>
> I think a single data page is valid too (2^0=1).
>
I have not tried that yet.

> Suppose we have mapped 4 pages (of page size 4k), that means our buffer
> position would be the lower 14 bits of data_head.
>
> Now say the last observed position was:
>
>  0x00003458 (& 0x00003FFF == 0x3458)
>
> and the next observed position is:
>
>  0x00013458 (& 0x00003FFF == 0x3458)
>
> We'd still be able to tell we overflowed 8 times.
>
Isn't it 4 times?

> Does this suffice?
>
Should work, assuming you have some bits left for the overflow.
That means you cannot actually go to 4GB of space unless you
know you cannot lose the race with the kernel.

>>   11/ reserve_percpu
>>
>>        There are more than counters on many PMU models. Counters are not
>>        symmetrical even on X86.
>>
>>        What does this API actually guarantees in terms on what events a tool
>>        will be able to measure with the reserved counters?
>>
>> II/ X86 comments
>>
>>   Mostly implementation related comments in this section.
>>
>>   1/ Fixed counter and event on Intel
>>
>>        You cannot simply fall back to generic counters if you cannot find
>>        a fixed counter. There are model-specific bugs, for instance
>>        UNHALTED_REFERENCE_CYCLES (0x013c), does not measure the same thing on
>>        Nehalem when it is used in fixed counter 2 or a generic counter. The
>>        same is true on Core.
>>
>>        You cannot simply look at the event field code to determine whether
>>        this is an event supported by a fixed counters. You must look at the
>>        other fields such as edge, invert, cnt-mask. If those are present then
>>        you have to fall back to using a generic counter as fixed counters only
>>        support priv level filtering. As indicated above, though, the
>>        programming UNHALTED_REFERENCE_CYCLES on a generic counter does not
>>        count the same thing, therefore you need to fail is filters other than
>>        priv levels are present on this event.
>>
>>   2/ Event knowledge missing
>>
>>        There are constraints and bugs on some events in Intel Core and Nehalem.
>>        In your model, those need to be taken care of by the kernel. Should the
>>        kernel make the wrong decision, there would be no work-around for user
>>        tools. Take the example I outlined just above with Intel fixed counters.
>>
>>        Constraints do exist on AMD64 processors as well..
>
> Good thing updating the kernel is so easy ;-)
>

Not once this is in production though.


>>   3/ Interrupt throttling
>>
>>        There is apparently no way for a system admin to set the threshold. It
>>        is hardcoded.
>>
>>        Throttling occurs without the tool(s) knowing. I think this is a problem.
>
> Fixed, it has a sysctl now, is in generic code and emits timestamped
> throttle/unthrottle events to the data stream, Power also implemented
> the needed bits.
>
Good.

>> III/ Requests
>>
>>   1/ Sampling period change
>>
>>        As it stands today, it seems there is no way to change a period but to
>>        close() the event file descriptor and start over.. When you close the
>>        group leader, it is not clear to me what happens to the remaining events.
>
> The other events will be 'promoted' to individual counters and continue
> on until their fd is closed too.
>
So you'd better start from scratch because you will lose group sampling.

>>        I know of tools which want to adjust the sampling period based on the
>>        number of samples they get per second.
>
> I recently implemented dynamic period stuff, it adjusts the period every
> tick so as to strive for a given target frequency.
>
I am wondering is the tool shouldn't be in charge of that rather than
the kernel.
At least it would give it more control about what is happening and when.

>>        By design, your perf_counter_open() should not really be in the
>>        critical path, e.g., when you are processing samples from the event
>>        buffer. Thus, I think it would be good to have a dedicated call to
>>        allow changing the period.
>
> Yet another ioctl() ?
>
I would say yet another syscall.

>>   2/ Sampling period randomization
>>
>>        It is our experience (on Itanium, for instance), that for certain
>>        sampling measurements, it is beneficial to randomize the sampling
>>        period a bit. This is in particular the case when sampling on an
>>        event that happens very frequently and which is not related to
>>        timing, e.g., branch_instructions_retired. Randomization helps mitigate
>>        the bias. You do not need anything sophisticated.. But when you are using
>>        a kernel-level sampling buffer, you need to have to kernel randomize.
>>        Randomization needs to be supported per event.
>
> Corey raised this a while back, I asked what kind of parameters were
> needed and if a specific (p)RNG was specified.
>
> Is something with an (avg,std) good enough? Do you have an
> implementation that I can borrow, or even better a patch? :-)

I think all you need is a bitmask to control the range of variation of the
period. As I said, the randomizer does not need to be sophisticated.
In perfmon we originally used the Carta random number generator.
But nowadays, we use the existing random32() kernel function.

>
>> IV/ Open questions
>>
>>   1/ Support for model-specific uncore PMU monitoring capabilities
>>
>>        Recent processors have multiple PMUs. Typically one per core and but
>>        also one at the socket level, e.g., Intel Nehalem. It is expected that
>>        this API will provide access to these PMU as well.
>>
>>        It seems like with the current API, raw events for those PMUs would need
>>        a new architecture-specific type as the event encoding by itself may
>>        not be enough to disambiguate between a core and uncore PMU event.
>>
>>        How are those events going to be supported?
>
> /me goes poke at the docs... and finds MSR_OFFCORE_RSP_0. Not sure I
> quite get what they're saying though, but yes
>
This one is not uncore, it's core. Name is confusing. The uncore is all the UNC_
stuff. See Vol3b section 18.17.2.

>>   2/ Features impacting all counters
>>
>>        On some PMU models, e.g., Itanium, they are certain features which have
>>        an influence on all counters that are active. For instance, there is a
>>        way to restrict monitoring to a range of continuous code or data
>>        addresses using both some PMU registers and the debug registers.
>>
>>        Given that the API exposes events (counters) as independent of each
>>        other, I wonder how range restriction could be implemented.
>
> Setting them per counter and when scheduling the counters check for
> compatibility and stop adding counters to the pmu if the next counter is
> incompatible.
>
How would you pass the code range addresses per-counter?
Suppose I want to monitor CYCLES between 0x100000-0x200000.
Range is specified using debug registers.


>>        Similarly, on Itanium, there are global behaviors. For instance, on
>>        counter overflow the entire PMU freezes all at once. That seems to be
>>        contradictory with the design of the API which creates the illusion of
>>        independence.
>
> Simply take the interrupt, deal with the overflow, and continue, its not
> like the hardware can do any better, can it?
>
Hardware cannot do more. That means other unrelated counters which happen
to have been scheduled at the same time will be blindspotted.

I suspect that for Itanium, the better way is to refuse to co-schedule events
from different groups, i.e., always run in exclusive mode.

>>   3/ AMD IBS
>>
>>        How is AMD IBS going to be implemented?
>>
>>        IBS has two separate sets of registers. One to capture fetch related
>>        data and another one to capture instruction execution data. For each,
>>        there is one config register but multiple data registers. In each mode,
>>        there is a specific sampling period and IBS can interrupt.
>>
>>        It looks like you could define two pseudo events or event types and then
>>        define a new record_format and read_format.  That formats would only be
>>        valid for an IBS event.
>>
>>        Is that how you intend to support IBS?
>
> I can't seem to locate the IBS stuff in the documentation currently, and
> I must admit I've not yet looked into it, others might have.
>
AMD BIOS and Kernel Developer's Guide (BKDG) for Family 10h, section 3.13.
You have the register descriptions.
