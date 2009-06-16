Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbZFPRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbZFPRmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbZFPRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:42:39 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:39942 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbZFPRmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=SHIoP7Kn3h3u8HOHASigM+aqUT+6ZwIiToMIoaLQVf9zKzpyo79849jOEI57cWHhUF
         ym+WwXnrSkkND8GE09PfpB1WFCn8otetZlPs1uOxU20aebbQHWgh8oHkDwY1/BauAWPZ
         ulLb2DStZ/0FQ+9OLFOzJybsCZsVbOeHyf+co=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Tue, 16 Jun 2009 19:42:39 +0200
Message-ID: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
Subject: v2 of comments on Performance Counters for Linux (PCL)
From: stephane eranian <eranian@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
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

Here is an updated version of my comments on PCL. Compared to the
previous version,
I have removed all the issues that were fixed or clarified. I have
kept all the issues and
open questions which I think are not solved yet and I added a few more.


I/ General API comments

 1/ System calls

     * ioctl()

       You have defined 5 ioctls() so far to operate on an existing event.
       I was under the impression that ioctl() should not be used except for
       drivers.

       How do you justify your usage of ioctl() in this context?

 2/ Grouping

       By design, an event can only be part of one group at a time. Events in
       a group are guaranteed to be active on the PMU at the same time. That
       means a group cannot have more events than there are available counters
       on the PMU. Tools may want to know the number of counters available in
       order to group their events accordingly, such that reliable ratios
       could be computed. It seems the only way to know this is by trial and
       error. This is not practical.

 3/ Multiplexing and system-wide

       Multiplexing is time-based and it is hooked into the timer tick. At
       every tick, the kernel tries to schedule another set of event groups.

       In tickless kernels if a CPU is idle, no timer tick is generated,
       therefore no multiplexing occurs. This is incorrect. It's not because
       the CPU is idle, that there aren't any interesting PMU events to measure.
       Parts of the CPU may still be active, e.g., caches and buses. And thus,
       it is expected that multiplexing still happens.

       You need to hook up the timer source for multiplexing to something else
       which is not affected by tickless. You cannot simply disable tickless
       during a measurement because you would not be measuring the system as
       it actually behaves.

  4/ Controlling group multiplexing

       Although multiplexing is exposed to users via the timing information,
       events may not necessarily be grouped at random by tools. Groups may
       not be ordered at random either.

       I know of tools which craft the sequence of groups carefully such that
       related events are in neighboring groups such that they measure similar
       parts of the execution. This way, you can mitigate the fluctuations
       introduced by multiplexing. In other words, some tools may want to
       control the order in which groups are scheduled on the PMU.

       You mentioned that groups are multiplexed in creation order. But which
       creation order? As far as I know, multiple distinct tools may be
       attaching to the same thread at the same time and their groups may be
       interleaved in the list. Therefore, I believe 'creation order' refers
       to the global group creation order which is only visible to the kernel.
       Each tool may see a different order. Let's take an example.

       Tool A creates group G1, G2, G3 and attaches them to thread T0. At the
       same time tool B creates group G4, G5. The actual global order may
       be: G1, G4, G2, G5, G3. This is what the kernel is going to multiplex.
       Each group will be multiplexed in the right order from the point of view
       of each tool. But there will be gaps. It would be nice to have a way
       to ensure that the sequence is either: G1, G2, G3, G4, G5 or G4, G5,
       G1, G2, G3. In other words, avoid the interleaving.

  5/ Mmaped count

       It is possible to read counts directly from user space for
self-monitoring
       threads. This leverages a HW capability present on some processors. On
       X86, this is possible via RDPMC.

       The full 64-bit count is constructed by combining the hardware value
       extracted with an assembly instruction and a base value made available
       thru the mmap. There is an atomic generation count available to deal
       with the race condition.

       I believe there is a problem with this approach given that the PMU
       is shared and that events can be multiplexed. That means that even
       though you are self-monitoring, events get replaced on the PMU. The
       assembly instruction is unaware of that, it reads a register
not an event.

       On x86, assume event A is hosted in counter 0, thus you need RDPMC(0)
       to extract the count. But then, the event is replaced by another one
       which reuses counter 0. At the user level, you will still use RDPMC(0)
       but it will read the HW value from a different event and combine it
       with a base count from another one.

       To avoid this, you need to pin the event so it stays in the PMU at
       all times. Now, here is something unclear to me. Pinning does not
       mean stay in the SAME register, it means the event stays on the PMU
       but it can possibly change register. To prevent that, I believe you need
       to also set exclusive so that no other group can be scheduled, and thus
       possibly use the same counter.

       Looks like this is the only way you can make this actually work.
       Not setting pinned+exclusive, is another pitfall in which many people
       will fall into.

  6/ Group scheduling

       Looking at the existing code, it seems to me there is a risk of
       starvation for groups, i.e., groups never scheduled on the PMU.

       My understanding of the scheduling algorithm is:

               - first try to  schedule pinned groups. If a pinned group
                 fails, put it in error mode. read() will fail until the
                 group gets another chance at being scheduled.

               - then try to schedule the remaining groups. If a group fails
                 just skip it.

       If the group list does not change, then certain groups may always fail.
       However, the ordering of the list changes because at every tick, it is
       rotated. The head becomes the tail. Therefore, each group eventually gets
       the first position and therefore gets the full PMU to assign its events.

       This works as long as there is a guarantee the list will ALWAYS
rotate. If
       a thread does not run long enough for a tick, it may never rotate.

  7/ Group validity checking

       At the user level, an application is only concerned with events
and grouping
       of those events. The assignment logic is performed by the kernel.

       For a group to be scheduled, all its events must be compatible
with each other,
       otherwise the group will never be scheduled. It is not clear to
me when that
       sanity check will be performed if I create the group such that
it is stopped.

       If the group goes all the way to scheduling, it will never be
scheduled. Counts
       will be zero and the users will have no idea why. If the group
is put in error
       state, read will not be possible. But again, how will the user know why?


  8/ Generalized cache events

      In recent days, you have added support for what you call
'generalized cache events'.

      The log defines:
               new event type: PERF_TYPE_HW_CACHE

               This is a 3-dimensional space:
               { L1-D, L1-I, L2, ITLB, DTLB, BPU } x
               { load, store, prefetch } x
               { accesses, misses }

      Those generic events are then mapped by the kernel onto actual
PMU events if possible.

      I don't see any justification for adding this and especially in
the kernel.

      What's the motivation and goal of this?

      If you define generic events, you need to provide a clear
definition of what they are
      actually measuring. This is especially true for caches because
there are many cache
      events and many different behaviors.

      If the goal is to make comparisons easier. I believe this is
doomed to fail. Because
      different caches behave differently, events capture different
subtle things, e.g, HW
      prefetch vs. sw prefetch. If to actually understand what the
generic event is counting
      I need to know the mapping, then this whole feature is useless.

  9/ Group reading

      It is possible to start/stop an event group simply via ioctl()
on the group
      leader. However, it is not possible to read all the counts with a single
      with a single read() system call. That seems odd. Furhermore, I
believe you
      want reads to be as atomic as possible.

  10/ Event buffer minimal useful size

      As it stands, the buffer header occupies the first page, even though the
      buffer header struct is 32-byte long. That's a lot of precious
RLIMIT_MEMLOCK
      memory wasted.

      The actual buffer (data) starts at the next page (from builtin-top.c):

       static void mmap_read_counter(struct mmap_data *md)
       {
               unsigned int head = mmap_read_head(md);
               unsigned int old = md->prev;
               unsigned char *data = md->base + page_size;


       Given that the buffer "full" notification are sent on page
crossing boundaries,
       if the actual buffer payload size is 1 page, you are guaranteed
to have your
       samples overwritten.

       This leads me to believe that the minimal buffer size to get
useful data is 3 pages.
       This is per event group per thread. That puts a lot of pressure
on RLIMIT_MEMLOCK
       which is ususally set fairly low by distros.

   11/ Missing definitions for generic hardware events

       As soon as you define generic events, you need to provide a
clear and precise definition
       at to what they measure. This is crucial to make them useful. I
have not seen such a
       definition yet.

II/ X86 comments

  1/ Fixed counters on Intel

       You cannot simply fall back to generic counters if you cannot find
       a fixed counter. There are model-specific bugs, for instance
       UNHALTED_REFERENCE_CYCLES (0x013c), does not measure the same thing on
       Nehalem when it is used in fixed counter 2 or a generic counter. The
       same is true on Core.

       You cannot simply look at the event field code to determine whether
       this is an event supported by a fixed counters. You must look at the
       other fields such as edge, invert, cnt-mask. If those are present then
       you have to fall back to using a generic counter as fixed counters only
       support priv level filtering. As indicated above, though, programming
       UNHALTED_REFERENCE_CYCLES on a generic counter does not count the same
       thing, therefore you need to fail if filters other than priv levels are
       present on this event.

  2/ Event knowledge missing

       There are constraints on events in Intel processors. Different
constraints
       do exist on AMD64 processors, especially with uncore-releated events.

       In your model, those need to be taken care of by the kernel. Should the
       kernel make the wrong decision, there would be no work-around for user
       tools. Take the example I outlined just above with Intel fixed counters.

       The current code-base does not have any constrained event
support, therefore
       bogus counts may be returned depending on the event measured.

III/ Requests

  1/ Sampling period randomization

       It is our experience (on Itanium, for instance), that for certain
       sampling measurements, it is beneficial to randomize the sampling
       period a bit. This is in particular the case when sampling on an
       event that happens very frequently and which is not related to
       timing, e.g., branch_instructions_retired. Randomization helps mitigate
       the bias. You do not need something sophisticated. But when you are using
       a kernel-level sampling buffer, you need to have the kernel randomize.
       Randomization needs to be supported per event.

IV/ Open questions

  1/ Support for model-specific uncore PMU monitoring capabilities

       Recent processors have multiple PMUs. Typically one per core and but
       also one at the socket level, e.g., Intel Nehalem. It is expected that
       this API will provide access to these PMU as well.

       It seems like with the current API, raw events for those PMU would need
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
       define a new record_format and read_format.  That formats would only be
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
