Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbZE1Ox0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbZE1Ox0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZE1OxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:53:19 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52015 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbZE1OxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc;
        b=gUwjsHabz5qGs6Hfb6uetdfepd/GNTiVy8TK2hh/hohj/Z77TW+iM5oXKywH+P9uxa
         /LnyoU3G+HmdETX7SKFZtAwzWe4xo1MKBzxtDq0ezOjbYylyrWIOjYZADobj29AFVI+N
         CZgUklP7dbWqktg8+kxNl9kVjwCl8xo8s8tMs=
Message-ID: <4a1ea556.1c05d00a.689f.1cda@mx.google.com>
Date: Thu, 28 May 2009 07:53:10 -0700 (PDT)
From: eranian@googlemail.com
To: linux-kernel@vger.kernel.org
Subject: comments on Performance Counters for Linux (PCL)
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, paulus@samba.org,
       andi@firstfloor.org, mpjohn@us.ibm.com, carll@us.ibm.com,
       cjashfor@us.ibm.com, mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following sections are some preliminary comments concerning the
Performance Counter for Linux (PCL) API and implementation proposal
currently in development.

S.Eranian
eranian@gmail.com

I/ General API comments

   1/ Data structures

      * struct perf_counter_hw_event

      - I think this structure will be used to enable non-counting features,
	e.g. IBS. Name is awkward. It is used to enable non-hardware events
	(sw events). Why not call it: struct perf_event

      - uint64_t config

	Why use a single field to encode event type and its encoding? By design,
	the syscall is not in the critical path. Why not spell things out
	clearly: int type, uint64_t code.

      - uint64_t irq_period

        IRQ is an x86 related name. Why not use smpl_period instead?

      - uint32_t record_type

        This field is a bitmask. I believe 32-bit is too small to accommodate
	future record formats.

      - uint32_t read_format

        Ditto.

      - uint64_t nmi

        This is an X86-only feature. Why make this visible in a generic API?

	What is the semantic of this?

	I cannot have one counter use NMI and another not use NMI or are you
	planning on switching the interrupt vector when you change event groups?

	Why do I need to be a priviledged user to enable NMI? Especially given
	that:
		- non-privileged users can monitor at privilege level 0 (kernel).
		- there is interrupt throttling

      - uint64_t exclude_*

        It seems those fields were added to support the generic HW events. But
	I think they are confusing and their semantic is not quite clear.

	Furthermore, aren't they irrelevant for the SW events?

	What is the meaning of exclude_user? Which priv levels are actually
	excluded?

        Take Itanium, it has 4 priv levels and the PMU counters can monitor at
	any priv levels or combination thereof?

	When programming raw HW events, the priv level filtering is typically
	already included. Which setting has priority, raw encoding or the
	exclude_*?

	Looking at the existing X86 implementation, it seems exclude_* can
	override whatever is set in the raw event code.

	For any events, but in particular, SW events, why not encode this in
	the config field, like it is for a raw HW event?

      - mmap, munmap, comm

        It is not clear to me why those fields are defined here rather than as
	PERF_RECORD_*. They are stored in the event buffer only. They are only
	useful when sampling.

        It is not clear why you have mmap and munmap as separate options.
	What's the point of munmap-only notification?

      * enum perf_event_types vs. enum perf_event_type

	Both names are too close to each other, yet they define unrelated data
	structures. This is very confusing.

      * struct perf_counter_mmap_page

	The definition of data_head precludes sampling buffers bigger that 4GB.

	Does that makes sense on TB machines?

	Given there is only one counter per-page, there is an awful lot of
	precious RLIMIT_MEMLOCK space wasted for this.

	Typically, if you are self-sampling, you are not going to read the
	current value of the sampling period. That re-mapping trick is only
	useful when counting.

	Why not make these two separate mappings (using the mmap offset as
	the indicator)?

	With this approach, you would get one page back per sampling period
	and that page could then be used for the actual samples.

  2/ System calls

      * ioctl()

	You have defined 3 ioctls() so far to operate on an existing event.
	I was under the impression that ioctl() should not be used except for
	drivers.

      * prctl()

	The API is event-based. Each event gets a file descriptor. Events are
	therefore managed individually. Thus, to enable/disable, you need to
	enable/disable each one separately.

	The use of prctl() breaks this design choice. It is not clear what you
	are actually enabling. It looks like you are enabling all the counters
	attached to the thread. This is incorrect. With your implementation,
	the PMU can be shared between competing users. In particular, multiple
	tools may be monitoring the same thread. Now, imagine, a tool is
	monitoring a self-monitoring thread which happens to start/stop its
	measurement using prctl(). Then, that would also start/stop the
	measurement of the external tool. I have verified that this is what is
	actually happening.

	I believe this call is bogus and it should be eliminated. The interface
	is exposing events individually therefore they should be controlled
	individually.

  3/ Counter width

	It is not clear whether or not the API exposes counters as 64-bit wide
	on PMUs which do not implement 64-bit wide counters.

	Both irq_period and read() return 64-bit integers. However, it appears
	that the implementation is not using all the bits. In fact, on X86, it
	appears the irq_period is truncated silently. I believe this is not
	correct. If the period is not valid, an error should be returned.
	Otherwise, the tool will be getting samples at a rate different than
	what it requested. 

	I would assume that on the read() side, counts are accumulated as
	64-bit integers. But if it is the case, then it seems there is an
	asymmetry between period and counts.

	Given that your API is high level, I don't think tools should have to
	worry about the actual width of a counter. This is especially true
	because they don't know which counters the event is going to go into
	and if I recall correctly, on some PMU models, different counters can
	have different width (Power, I think).

	It is rather convenient for tools to always manipulate counters as
	64-bit integers. You should provide a consistent view between counts
	and periods.

  4/ Grouping

	By design, an event can only be part of one group at a time. Events in
	a group are guaranteed to be active on the PMU at the same time. That
	means a group cannot have more events than there are available counters
	on the PMU. Tools may want to know the number of counters available in
	order to group their events accordingly, such that reliable ratios
	could be computed. It seems the only way to know this is by trial and
	error. This is not practical.

  5/ Multiplexing and scaling

	The PMU can be shared by multiple programs each controlling a variable
	number of events. Multiplexing occurs by default unless pinned is
	requested. The exclusive option only guarantees the group does not
	share the PMU with other groups while it is active, at least this is
	my understanding.

	By default, you may be multiplexed and if that happens you cannot know
	unless you request the timing information as part of the read_format.
	Without it, and if multiplexing has occurred, bogus counts may be
	returned with no indication whatsoever.

	To avoid returning misleading information, it seems like the API should
	refuse to open a non-pinned event which does not have
	PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING in the
	read_format. This would avoid a lot of confusion down the road. 

  7/ Multiplexing and system-wide

	Multiplexing is time-based and it is hooked into the timer tick. At
	every tick, the kernel tries to schedule another group of events.

	In tickless kernels if a CPU is idle, no timer tick is generated,
	therefore no multiplexing occurs. This is incorrect. It's not because
	the CPU is idle, that there aren't any interesting PMU events to measure.
	Parts of the CPU may still be active, e.g., caches and buses. And thus,
	it is expected that multiplexing still happens.

	You need to hook up the timer source for multiplexing to something else
	which is not affected by tickless.

  8/ Controlling group multiplexing

	Although, multiplexing is somehow exposed to user via the timing
	information.  I believe there is not enough control. I know of advanced
	monitoring tools which needs to measure over a dozen events in one
	monitoring session. Given that the underlying PMU does not have enough
	counters OR that certain events cannot be measured together, it is
	necessary to split the events into groups and multiplex them. Events
	are not grouped at random AND groups are not ordered at random either.
	The sequence of groups is carefully chosen such that related events are
	in neighboring groups such that they measure similar parts of the
	execution.  This way you can mitigate the fluctuations introduced by
	multiplexing and compare ratios. In other words, some tools may want to
	control the order in which groups are scheduled on the PMU.

	The exclusive flag ensures correct grouping. But there is nothing to
	control ordering of groups.  That is a problem for some tools. Groups
	from different 'session' may be interleaved and break the continuity of
	 measurement.

	The group ordering has to be controllable from the tools OR must be
	fully specified by the API. But it should not be a property of the
	implementation. The API could for instance specify that groups are
	scheduled in increasing order of the group leaders' file descriptor.
	There needs to be some way of preventing interleaving of groups from
	different 'sessions'.

  9/ Event buffer

	There is a kernel level event buffer which can be re-mapped read-only at
	the user level via mmap(). The buffer must be a multiple of page size
	and must be at least 2-page long. The First page is used for the
	counter re-mapping and buffer header, the second for the actual event
	buffer.

	The buffer is managed as a cyclic buffer. That means there is a
	continuous race between the tool and the kernel. The tool must parse
	the buffer faster than the kernel can fill it out. It is important to
	realize that the race continues even when monitoring is stopped, as non
	PMU-based infos keep being stored, such as mmap, munmap. This is
	expected because it is not possible to lose mapping information
	otherwise invalid correlation of samples may happen.

	However, there is currently no reliable way of figuring out whether or
	not the buffer has wrapped around since the last scan by the tool. Just
	checking the current position or estimating the space left is not good
	enough. There ought to be an overflow counter of some sort indicating
	the number of times the head wrapped around.

   10/ Group event buffer entry

	This is activated by setting the PERF_RECORD_GROUP in the record_type
	field.  With this bit set, the values of the other members of the
	group are stored sequentially in the buffer. To help figure out which
	value corresponds to which event, the current implementation also
	stores the raw encoding of the event.

	The event encoding does not help figure out which event the value refers
	to. There can be multiple events with the same code. This does fit the
	API model where events are identified by file descriptors.

	The file descriptor must be provided and not the raw encoding.

   11/ reserve_percpu

	There are more than counters on many PMU models. Counters are not
	symmetrical even on X86.

	What does this API actually guarantees in terms on what events a tool
	will be able to measure with the reserved counters?

II/ X86 comments

   Mostly implementation related comments in this section.

   1/ Fixed counter and event on Intel

	You cannot simply fall back to generic counters if you cannot find
	a fixed counter. There are model-specific bugs, for instance
	UNHALTED_REFERENCE_CYCLES (0x013c), does not measure the same thing on
	Nehalem when it is used in fixed counter 2 or a generic counter. The
	same is true on Core.

	You cannot simply look at the event field code to determine whether
	this is an event supported by a fixed counters. You must look at the
	other fields such as edge, invert, cnt-mask. If those are present then
	you have to fall back to using a generic counter as fixed counters only
	support priv level filtering. As indicated above, though, the
	programming UNHALTED_REFERENCE_CYCLES on a generic counter does not
	count the same thing, therefore you need to fail is filters other than
	priv levels are present on this event.

   2/ Event knowledge missing

	There are constraints and bugs on some events in Intel Core and Nehalem.
	In your model, those need to be taken care of by the kernel. Should the
	kernel make the wrong decision, there would be no work-around for user
	tools. Take the example I outlined just above with Intel fixed counters.

	Constraints do exist on AMD64 processors as well.

   3/ Interrupt throttling

	There is apparently no way for a system admin to set the threshold. It
	is hardcoded.

	Throttling occurs without the tool(s) knowing. I think this is a problem.

    4/ NMI

	Why restrict NMI to privileged users when you have throttling to protect
	against interrupt flooding?

	Are you trying to restrict non privileged users from getting sampling
	inside kernel critical sections?

III/ Requests

   1/ Sampling period change

	As it stands today, it seems there is no way to change a period but to
	close() the event file descriptor and start over. When you close the
	group leader, it is not clear to me what happens to the remaining events.

	I know of tools which want to adjust the sampling period based on the
	number of samples they get per second.

	By design, your perf_counter_open() should not really be in the
	critical path, e.g., when you are processing samples from the event
	buffer. Thus, I think it would be good to have a dedicated call to
	allow changing the period.

   2/ Sampling period randomization

	It is our experience (on Itanium, for instance), that for certain
	sampling measurements, it is beneficial to randomize the sampling
	period a bit. This is in particular the case when sampling on an
	event that happens very frequently and which is not related to
	timing, e.g., branch_instructions_retired. Randomization helps mitigate
	the bias. You do not need anything sophisticated. But when you are using
	a kernel-level sampling buffer, you need to have to kernel randomize.
	Randomization needs to be supported per event.

   3/ Group multiplexing ordering

	As mentioned above, the ordering of group multiplexing for one process
	needs to be either specified by the API or controllable by users.

IV/ Open questions

   1/ Support for model-specific uncore PMU monitoring capabilities

	Recent processors have multiple PMUs. Typically one per core and but
	also one at the socket level, e.g., Intel Nehalem. It is expected that
	this API will provide access to these PMU as well.

	It seems like with the current API, raw events for those PMUs would need
	a new architecture-specific type as the event encoding by itself may
	not be enough to disambiguate between a core and uncore PMU event.

	How are those events going to be supported?

   2/ Features impacting all counters

	On some PMU models, e.g., Itanium, they are certain features which have
	an influence on all counters that are active. For instance, there is a
	way to restrict monitoring to a range of continuous code or data
	addresses using both some PMU registers and the debug registers.

	Given that the API exposes events (counters) as independent of each
	other, I wonder how range restriction could be implemented.

	Similarly, on Itanium, there are global behaviors. For instance, on
	counter overflow the entire PMU freezes all at once. That seems to be
	contradictory with the design of the API which creates the illusion of
	independence.

	What solutions do you propose?

   3/ AMD IBS

	How is AMD IBS going to be implemented?

	IBS has two separate sets of registers. One to capture fetch related
	data and another one to capture instruction execution data. For each,
	there is one config register but multiple data registers. In each mode,
	there is a specific sampling period and IBS can interrupt.

	It looks like you could define two pseudo events or event types and then
	define a new record_format and read_format.  That formats would only be
	valid for an IBS event.

	Is that how you intend to support IBS?

   4/ Intel PEBS    

	Since Netburst-based processors, Intel PMUs support a hardware sampling
	buffer mechanism called PEBS.

	PEBS really became useful with Nehalem.

	Not all events support PEBS. Up until Nehalem, only one counter supported
	PEBS (PMC0). The format of the hardware buffer has changed between Core
	and Nehalem. It is not yet architected, thus it can still evolve with
	future PMU models.

	On Nehalem, there is a new PEBS-based feature called Load Latency
	Filtering which captures where data cache misses occur
	(similar to Itanium D-EAR). Activating this feature requires setting a
	latency threshold hosted in a separate PMU MSR.

	On Nehalem, given that all 4 generic counters support PEBS, the
	sampling buffer may contain samples generated by any of the 4 counters.
	The buffer includes a bitmask of registers to determine the source
	of the samples. Multiple bits may be set in the bitmask.


	How PEBS will be supported for this new API?

   5/ Intel Last Branch Record (LBR)

	Intel processors since Netburst have a cyclic buffer hosted in
	registers which can record taken branches. Each taken branch is stored
	into a pair of LBR registers (source, destination). Up until Nehalem,
	there was not filtering capabilities for LBR. LBR is not an architected
	PMU feature.  

	There is no counter associated with LBR. Nehalem has a LBR_SELECT MSR.
	However there are some constraints on it given it is shared by threads.

	LBR is only useful when sampling and therefore must be combined with a
	counter. LBR must also be configured to freeze on PMU interrupt.

	How is LBR going to be supported?

