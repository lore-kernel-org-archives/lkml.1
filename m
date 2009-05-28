Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbZE1QZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbZE1QZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZE1QZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:25:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:41037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZE1QZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:25:43 -0400
Subject: Re: comments on Performance Counters for Linux (PCL)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 18:25:19 +0200
Message-Id: <1243527919.6645.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 16:58 +0200, stephane eranian wrote:
> Hi,
> 
> The following sections are some preliminary comments concerning the
> Performance Counter for Linux (PCL) API and implementation proposal
> currently in development.

Thanks for your input, some answers below.

~hth

> I/ General API comments
> 
>   1/ Data structures
> 
>      * struct perf_counter_hw_event
> 
>      - I think this structure will be used to enable non-counting features,
>        e.g. IBS. Name is awkward. It is used to enable non-hardware events
>        (sw events). Why not call it: struct perf_event

Sure a name change might be a good idea.

>      - uint64_t config
> 
>        Why use a single field to encode event type and its encoding? By design,
>        the syscall is not in the critical path. Why not spell things out
>        clearly: int type, uint64_t code.

Because its convenient to be able to identify a counter in a single u64.

>      - uint64_t irq_period
> 
>        IRQ is an x86 related name. Why not use smpl_period instead?

don't really care, but IRQ seems used throughout linux, we could name
the thing interrupt or sample period.

>      - uint32_t record_type
> 
>        This field is a bitmask. I believe 32-bit is too small to accommodate
>        future record formats.

It currently controls 8 aspects of the overflow entry, do you really
forsee the need for more than 32?

>      - uint32_t read_format
> 
>        Ditto.

I guess it doesn't hurt extending them..

>      - uint64_t nmi

Its no a u64, but a single bit, also, its dead and about to be removed.

>      - uint64_t exclude_*
> 
>        It seems those fields were added to support the generic HW events. But
>        I think they are confusing and their semantic is not quite clear.
> 
>        Furthermore, aren't they irrelevant for the SW events?

They are.

>        What is the meaning of exclude_user? Which priv levels are actually
>        excluded?

userspace

>        Take Itanium, it has 4 priv levels and the PMU counters can monitor at
>        any priv levels or combination thereof?

x86 has more priv rings too, but linux only uses 2, kernel (ring 0) and
user (ring 2 iirc). Does ia64 expose more than 2 priv levels in linux?

>        When programming raw HW events, the priv level filtering is typically
>        already included. Which setting has priority, raw encoding or the
>        exclude_*?
> 
>        Looking at the existing X86 implementation, it seems exclude_* can
>        override whatever is set in the raw event code.
> 
>        For any events, but in particular, SW events, why not encode this in
>        the config field, like it is for a raw HW event?

Because config is about what we count, this is about where we count.
Doesn't seem strange to separate these two.

>      - mmap, munmap, comm
> 
>        It is not clear to me why those fields are defined here rather than as
>        PERF_RECORD_*. They are stored in the event buffer only. They are only
>        useful when sampling.
> 
>        It is not clear why you have mmap and munmap as separate options.
>        What's the point of munmap-only notification?

You only need one, either mmap or munmap, its up to the application
which one it prefers, both work too.

They are not part of PERF_RECORD_ because MMAP/MUNMAP/COMM events are
unrelated to counter overflow.

>      * enum perf_event_types vs. enum perf_event_type
> 
>        Both names are too close to each other, yet they define unrelated data
>        structures. This is very confusing.

OK.

>      * struct perf_counter_mmap_page
> 
>        The definition of data_head precludes sampling buffers bigger that 4GB.
> 
>        Does that makes sense on TB machines?

Dunno, 4G seems an awefull lot to me -- but if someone really wants more
I guess we can grow the field.

>        Given there is only one counter per-page, there is an awful lot of
>        precious RLIMIT_MEMLOCK space wasted for this.
> 
>        Typically, if you are self-sampling, you are not going to read the
>        current value of the sampling period. That re-mapping trick is only
>        useful when counting.
> 
>        Why not make these two separate mappings (using the mmap offset as
>        the indicator)?
> 
>        With this approach, you would get one page back per sampling period
>        and that page could then be used for the actual samples.

Not quite, you still need a place for the data_head.

>  2/ System calls
> 
>      * ioctl()
> 
>        You have defined 3 ioctls() so far to operate on an existing event.
>        I was under the impression that ioctl() should not be used except for
>        drivers.

4 actually.

>      * prctl()
> 
>        The API is event-based. Each event gets a file descriptor. Events are
>        therefore managed individually. Thus, to enable/disable, you need to
>        enable/disable each one separately.
> 
>        The use of prctl() breaks this design choice. It is not clear what you
>        are actually enabling. It looks like you are enabling all the counters
>        attached to the thread. This is incorrect. With your implementation,
>        the PMU can be shared between competing users. In particular, multiple
>        tools may be monitoring the same thread. Now, imagine, a tool is
>        monitoring a self-monitoring thread which happens to start/stop its
>        measurement using prctl(). Then, that would also start/stop the
>        measurement of the external tool. I have verified that this is what is
>        actually happening.

Recently changed that, it enables/disables all counters created by the
task calling prctl().

>        I believe this call is bogus and it should be eliminated. The interface
>        is exposing events individually therefore they should be controlled
>        individually.

Bogus maybe not, superfluous, yeah, its a simpler way than iterating all
the fds you just created, saves a few syscalls.

If that justifies its existance,. I dunno.

>  3/ Counter width
> 
>        It is not clear whether or not the API exposes counters as 64-bit wide
>        on PMUs which do not implement 64-bit wide counters.
> 
>        Both irq_period and read() return 64-bit integers. However, it appears
>        that the implementation is not using all the bits. In fact, on X86, it
>        appears the irq_period is truncated silently. I believe this is not
>        correct. If the period is not valid, an error should be returned.
>        Otherwise, the tool will be getting samples at a rate different than
>        what it requested.

Sure, fail creation when the specified period is larger than the
supported counter width -- patch welcome.

>        I would assume that on the read() side, counts are accumulated as
>        64-bit integers. But if it is the case, then it seems there is an
>        asymmetry between period and counts.
> 
>        Given that your API is high level, I don't think tools should have to
>        worry about the actual width of a counter. This is especially true
>        because they don't know which counters the event is going to go into
>        and if I recall correctly, on some PMU models, different counters can
>        have different width (Power, I think).
> 
>        It is rather convenient for tools to always manipulate counters as
>        64-bit integers. You should provide a consistent view between counts
>        and periods.

So you're suggesting to artificually strech periods by say composing a
single overflow from smaller ones, ignoring the intermediate overflow
events?

That sounds doable, again, patch welcome.

>  4/ Grouping
> 
>        By design, an event can only be part of one group at a time. Events in
>        a group are guaranteed to be active on the PMU at the same time. That
>        means a group cannot have more events than there are available counters
>        on the PMU. Tools may want to know the number of counters available in
>        order to group their events accordingly, such that reliable ratios
>        could be computed. It seems the only way to know this is by trial and
>        error. This is not practical.

Got a proposal to ammend this?

>  5/ Multiplexing and scaling
> 
>        The PMU can be shared by multiple programs each controlling a variable
>        number of events. Multiplexing occurs by default unless pinned is
>        requested. The exclusive option only guarantees the group does not
>        share the PMU with other groups while it is active, at least this is
>        my understanding.

We have pinned and exclusive. pinned means always on the PMU, exclusive
means when on the PMU no-one else can be.

>        By default, you may be multiplexed and if that happens you cannot know
>        unless you request the timing information as part of the read_format.
>        Without it, and if multiplexing has occurred, bogus counts may be
>        returned with no indication whatsoever.

I don't see the problem, you knew they could get multiplexes, yet you
didn't ask for the information needed to extrapolate the information,
sounds like you get what you aksed for.

>        To avoid returning misleading information, it seems like the API should
>        refuse to open a non-pinned event which does not have
>        PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING in the
>        read_format. This would avoid a lot of confusion down the road.

I prefer to give people rope and tell them how to tie the knot.

>  7/ Multiplexing and system-wide
> 
>        Multiplexing is time-based and it is hooked into the timer tick. At
>        every tick, the kernel tries to schedule another group of events.
> 
>        In tickless kernels if a CPU is idle, no timer tick is generated,
>        therefore no multiplexing occurs. This is incorrect. It's not because
>        the CPU is idle, that there aren't any interesting PMU events to measure.
>        Parts of the CPU may still be active, e.g., caches and buses. And thus,
>        it is expected that multiplexing still happens.
> 
>        You need to hook up the timer source for multiplexing to something else
>        which is not affected by tickless.

Or inhibit nohz when there are active counters, but good point.

>  8/ Controlling group multiplexing
> 
>        Although, multiplexing is somehow exposed to user via the timing
>        information.  I believe there is not enough control. I know of advanced
>        monitoring tools which needs to measure over a dozen events in one
>        monitoring session. Given that the underlying PMU does not have enough
>        counters OR that certain events cannot be measured together, it is
>        necessary to split the events into groups and multiplex them. Events
>        are not grouped at random AND groups are not ordered at random either.
>        The sequence of groups is carefully chosen such that related events are
>        in neighboring groups such that they measure similar parts of the
>        execution.  This way you can mitigate the fluctuations introduced by
>        multiplexing and compare ratios. In other words, some tools may want to
>        control the order in which groups are scheduled on the PMU.

Current code RR groups in the order they are created, is more control
needed?

>        The exclusive flag ensures correct grouping. But there is nothing to
>        control ordering of groups.  That is a problem for some tools. Groups
>        from different 'session' may be interleaved and break the continuity of
>         measurement.

I'm not sure I understand the 'session' bit.

>        The group ordering has to be controllable from the tools OR must be
>        fully specified by the API. But it should not be a property of the
>        implementation. The API could for instance specify that groups are
>        scheduled in increasing order of the group leaders' file descriptor.
>        There needs to be some way of preventing interleaving of groups from
>        different 'sessions'.

If we specify we maintain order of creation, would that suffice?

>  9/ Event buffer
> 
>        There is a kernel level event buffer which can be re-mapped read-only at
>        the user level via mmap(). The buffer must be a multiple of page size

2^n actually

>        and must be at least 2-page long. The First page is used for the
>        counter re-mapping and buffer header, the second for the actual event
>        buffer.

I think a single data page is valid too (2^0=1).

>        The buffer is managed as a cyclic buffer. That means there is a
>        continuous race between the tool and the kernel. The tool must parse
>        the buffer faster than the kernel can fill it out. It is important to
>        realize that the race continues even when monitoring is stopped, as non
>        PMU-based infos keep being stored, such as mmap, munmap. This is
>        expected because it is not possible to lose mapping information
>        otherwise invalid correlation of samples may happen.
> 
>        However, there is currently no reliable way of figuring out whether or
>        not the buffer has wrapped around since the last scan by the tool. Just
>        checking the current position or estimating the space left is not good
>        enough. There ought to be an overflow counter of some sort indicating
>        the number of times the head wrapped around.

data_head wraps on u32, that is, it increments past the mmap'ed data
window, and only the lower n+page_shift bits signify the position in the
buffer (hence the 2^n pages requirement).

This means that if userspace remembers the last read position, and all
the data was overwritten since last time, we'd be able to tell.

Suppose we have mapped 4 pages (of page size 4k), that means our buffer
position would be the lower 14 bits of data_head.

Now say the last observed position was:

  0x00003458 (& 0x00003FFF == 0x3458)

and the next observed position is:

  0x00013458 (& 0x00003FFF == 0x3458)

We'd still be able to tell we overflowed 8 times.

Does this suffice?

[ assuming you map less than 4G of course, otherwise there's no spare
  bits left ]

>   10/ Group event buffer entry
> 
>        This is activated by setting the PERF_RECORD_GROUP in the record_type
>        field.  With this bit set, the values of the other members of the
>        group are stored sequentially in the buffer. To help figure out which
>        value corresponds to which event, the current implementation also
>        stores the raw encoding of the event.
> 
>        The event encoding does not help figure out which event the value refers
>        to. There can be multiple events with the same code. This does fit the
>        API model where events are identified by file descriptors.
> 
>        The file descriptor must be provided and not the raw encoding.

OK, sounds sensible.

>   11/ reserve_percpu
> 
>        There are more than counters on many PMU models. Counters are not
>        symmetrical even on X86.
> 
>        What does this API actually guarantees in terms on what events a tool
>        will be able to measure with the reserved counters?
> 
> II/ X86 comments
> 
>   Mostly implementation related comments in this section.
> 
>   1/ Fixed counter and event on Intel
> 
>        You cannot simply fall back to generic counters if you cannot find
>        a fixed counter. There are model-specific bugs, for instance
>        UNHALTED_REFERENCE_CYCLES (0x013c), does not measure the same thing on
>        Nehalem when it is used in fixed counter 2 or a generic counter. The
>        same is true on Core.
> 
>        You cannot simply look at the event field code to determine whether
>        this is an event supported by a fixed counters. You must look at the
>        other fields such as edge, invert, cnt-mask. If those are present then
>        you have to fall back to using a generic counter as fixed counters only
>        support priv level filtering. As indicated above, though, the
>        programming UNHALTED_REFERENCE_CYCLES on a generic counter does not
>        count the same thing, therefore you need to fail is filters other than
>        priv levels are present on this event.
> 
>   2/ Event knowledge missing
> 
>        There are constraints and bugs on some events in Intel Core and Nehalem.
>        In your model, those need to be taken care of by the kernel. Should the
>        kernel make the wrong decision, there would be no work-around for user
>        tools. Take the example I outlined just above with Intel fixed counters.
> 
>        Constraints do exist on AMD64 processors as well..

Good thing updating the kernel is so easy ;-)

>   3/ Interrupt throttling
> 
>        There is apparently no way for a system admin to set the threshold. It
>        is hardcoded.
> 
>        Throttling occurs without the tool(s) knowing. I think this is a problem.

Fixed, it has a sysctl now, is in generic code and emits timestamped
throttle/unthrottle events to the data stream, Power also implemented
the needed bits.

>    4/ NMI
> 
>        Why restrict NMI to privileged users when you have throttling to protect
>        against interrupt flooding?
> 
>        Are you trying to restrict non privileged users from getting sampling
>        inside kernel critical sections?

On its way to being fixed. Everything is NMI now only the code needs
cleaning up.

> III/ Requests
> 
>   1/ Sampling period change
> 
>        As it stands today, it seems there is no way to change a period but to
>        close() the event file descriptor and start over.. When you close the
>        group leader, it is not clear to me what happens to the remaining events.

The other events will be 'promoted' to individual counters and continue
on until their fd is closed too.

>        I know of tools which want to adjust the sampling period based on the
>        number of samples they get per second.

I recently implemented dynamic period stuff, it adjusts the period every
tick so as to strive for a given target frequency.

>        By design, your perf_counter_open() should not really be in the
>        critical path, e.g., when you are processing samples from the event
>        buffer. Thus, I think it would be good to have a dedicated call to
>        allow changing the period.

Yet another ioctl() ?

>   2/ Sampling period randomization
> 
>        It is our experience (on Itanium, for instance), that for certain
>        sampling measurements, it is beneficial to randomize the sampling
>        period a bit. This is in particular the case when sampling on an
>        event that happens very frequently and which is not related to
>        timing, e.g., branch_instructions_retired. Randomization helps mitigate
>        the bias. You do not need anything sophisticated.. But when you are using
>        a kernel-level sampling buffer, you need to have to kernel randomize.
>        Randomization needs to be supported per event.

Corey raised this a while back, I asked what kind of parameters were
needed and if a specific (p)RNG was specified.

Is something with an (avg,std) good enough? Do you have an
implementation that I can borrow, or even better a patch? :-)

>   3/ Group multiplexing ordering
> 
>        As mentioned above, the ordering of group multiplexing for one process
>        needs to be either specified by the API or controllable by users.

Creation order.

> IV/ Open questions
> 
>   1/ Support for model-specific uncore PMU monitoring capabilities
> 
>        Recent processors have multiple PMUs. Typically one per core and but
>        also one at the socket level, e.g., Intel Nehalem. It is expected that
>        this API will provide access to these PMU as well.
> 
>        It seems like with the current API, raw events for those PMUs would need
>        a new architecture-specific type as the event encoding by itself may
>        not be enough to disambiguate between a core and uncore PMU event.
> 
>        How are those events going to be supported?

/me goes poke at the docs... and finds MSR_OFFCORE_RSP_0. Not sure I
quite get what they're saying though, but yes

>   2/ Features impacting all counters
> 
>        On some PMU models, e.g., Itanium, they are certain features which have
>        an influence on all counters that are active. For instance, there is a
>        way to restrict monitoring to a range of continuous code or data
>        addresses using both some PMU registers and the debug registers.
> 
>        Given that the API exposes events (counters) as independent of each
>        other, I wonder how range restriction could be implemented.

Setting them per counter and when scheduling the counters check for
compatibility and stop adding counters to the pmu if the next counter is
incompatible.

>        Similarly, on Itanium, there are global behaviors. For instance, on
>        counter overflow the entire PMU freezes all at once. That seems to be
>        contradictory with the design of the API which creates the illusion of
>        independence.

Simply take the interrupt, deal with the overflow, and continue, its not
like the hardware can do any better, can it?

>   3/ AMD IBS
> 
>        How is AMD IBS going to be implemented?
> 
>        IBS has two separate sets of registers. One to capture fetch related
>        data and another one to capture instruction execution data. For each,
>        there is one config register but multiple data registers. In each mode,
>        there is a specific sampling period and IBS can interrupt.
> 
>        It looks like you could define two pseudo events or event types and then
>        define a new record_format and read_format.  That formats would only be
>        valid for an IBS event.
> 
>        Is that how you intend to support IBS?

I can't seem to locate the IBS stuff in the documentation currently, and
I must admit I've not yet looked into it, others might have.

>   4/ Intel PEBS
> 
>        Since Netburst-based processors, Intel PMUs support a hardware sampling
>        buffer mechanism called PEBS.
> 
>        PEBS really became useful with Nehalem.
> 
>        Not all events support PEBS. Up until Nehalem, only one counter supported
>        PEBS (PMC0). The format of the hardware buffer has changed between Core
>        and Nehalem. It is not yet architected, thus it can still evolve with
>        future PMU models.
> 
>        On Nehalem, there is a new PEBS-based feature called Load Latency
>        Filtering which captures where data cache misses occur
>        (similar to Itanium D-EAR). Activating this feature requires setting a
>        latency threshold hosted in a separate PMU MSR.
> 
>        On Nehalem, given that all 4 generic counters support PEBS, the
>        sampling buffer may contain samples generated by any of the 4 counters.
>        The buffer includes a bitmask of registers to determine the source
>        of the samples. Multiple bits may be set in the bitmask.
> 
> 
>        How PEBS will be supported for this new API?

Something like that yes, we'd have to read the PEBS data and demux to
the per counter data streams.


