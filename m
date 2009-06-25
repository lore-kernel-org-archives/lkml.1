Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZFYL3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZFYL3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZFYL2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:28:54 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49855 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZFYL2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=YHGkBgB4KAAKQ6X8+b/sPzHqkiVuxJILGnvcwzCALcX3iCSOFZKVEs0xkxwcL3p0nC
         KLWRraeVLyo8A0YiSObHdoJ5ygu33eR6FkxEGYapVIUx2qbDDGl+BjY91i0rJvpRulN+
         q655rX/+BCXrtF0Yj15DJJDF+xRMzeEqRAYvM=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Thu, 25 Jun 2009 13:28:52 +0200
Message-ID: <7c86c4470906250428r2ab232ebvb32bbdf4e633617f@mail.gmail.com>
Subject: Re: [perfmon2] IV.3 - AMD IBS
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Drongowski, Paul" <paul.drongowski@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Rob Fowler <rjf@renci.org>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 23, 2009 at 4:55 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> The 20 bits delay is in cycles, right? So this in itself still lends
> itself to be transparently provided as a PERF_COUNT_HW_CPU_CYCLES
> counter.
>

I do not believe you can use  IBS as a better substitute for either CYCLES or
INSTRUCTIONS sampling. IBS simply does not operate in the same way.

But instead of me arguing with you guys for a long time, I have asked someone
at AMD who knows more than me about IBS. Paul posted his answer only on
the perfmon2 mailing list, I have forwarded it below.

You will also note that he is providing another example as to why support for
software sampling period randomization is useful.

I would like to thank Paul for spending time providing a lot of useful details
about IBS.

I am hoping this can clarify things.

On Wed, Jun 24, 2009 at 8:20 PM, Drongowski,
Paul<paul.drongowski@amd.com> wrote:
>
> Hi --
>
> I'm sorry to be joining this discussion so late. A few of my
> colleagues pointed me toward the current thread on IBS and I've tried
> to catch up by reading the archives. A short self-introduction: I'm a
> member of the AMD CodeAnalyst team, Ravi Bhargava and I wrote Appendix G
> (concerning IBS) of the AMD Software Optimization Guide for AMD
> Family 10h Processors and at one point in my life, I worked on DCPI
> (using ProfileMe).
>
> First off, Stephane and Rob have done a good job representing IBS and
> also ProfileMe. Thanks, guys!
>
> Rather than grossly disturb the current discussion, I'd like to offer
> a few points of clarification and maybe a little useful history.
>
> Peter's observation that IBS is a "mismatch with the traditional one
> value per counter thing" is quite apt. IBS has similarities to
> ProfileMe. Stephane's citation of the Itanium Data-EAR and
> Instruction-EAR are also very relevant as examples of profile data
> that do not fit with the "one value per counter thing."
>
> IBS Fetch.
>
>    IBS fetch sampling does not exactly sample x86 instructions. The
>    current fetch counter counts fetch operations where a fetch
> operation
>    may be a 32-byte fetch block (on AMD Family 10h) or it may be a
>    fetch operation initiated by a redirection such as a branch.
>    A fetch block is 32 bytes of instruction information which is
>    sent to the instruction decoder. The fetch address that is reported
>    may either be the start of a valid x86 instruction or the start of
>    a fetch block. In the second case, the address may be in the middle
> of
>    an x86 instruction.
>
>    IBS fetch sampling produces a number of event flags (e.g.,
> instruction
>    cache miss), but it also produces the latency (in cycles) of the
>    fetch operation. The latencies can be accumulated in either
>    descriptive statistics, or better, in a histogram since descriptive
>    statistics don't really show where an access is hitting in the
>    memory hierarchy. BTW, even though an IBS fetch sample may be
> reported,
>    the decoder may not use the instruction bytes due to a late arriving
>    redirection.
>
> IBS Op.
>
>    IBS op sampling does not sample x86 instructions. It samples the
>    ops which are issued from x86 instructions. Some x86 instructions
>    issue more than one op. Microcoded instructions are particularly
>    thorny as a single REP MOV may issue many ops, thereby affecting
>    the number of samples that fall on them (i.e., disproportionate to
> the
>    execution frequency of the surrounding basic block.) The number of
>    ops issued is data dependent and is unpredictable. Appendix C
>    of the Software Optimization Guide lists the number of ops issued
>    from x86 instructions (one, two or many).
>
>    Beginning with AMD Family 10h RevC, there are two op selection
>    (counting) modes for IBS: cycles-counting and dispatched op
> counting.
>
>    Cycles-counting is _not_ equivalent to CPU_CLK_UNHALTED -- it is
>    not a precise version of the performance monitoring counter (PMC)
>    event (event select 0x076). In cycles-mode, when the current count
>    reaches the max count, the next available dispatch group of ops is
>    selected and a secondary mechanism selects an op within the dispatch
>    group. The dispatch group may contain one, two or three ops. If you
>    smell a rat, you're right. The secondary scheme negatively affects
>    the desired pseudo-random selection scheme. Also, if a dispatch
>    group is not available, the sample is skipped and the counting
>    process is reset.
>
>    Further, cycles-mode selection is affected by pipeline stalls. This
>    affects the distribution of IBS op samples taken in cycles-mode.
>    With cycles-mode, one instruction may have more data cache miss
> events,
>    but the underlying sampling basis is so skewed that the comparison
> is
>    not meaningful. IBS op samples are generated only for ops that
> retire;
>    tagged ops on a "wrong path" are flushed without producing a sample.
>    Overall, I cannot personally say that IBS cycles-mode produces a
> precise
>    equivalent to CPU_CLK_UNHALTED. I cannot endorse or recommend
>    its use in this way.
>
>    Given these issues, dispatched op counting was added in RevC. This
> mode
>    is the _preferred_ mode. Ops are counted as they are dispatched and
> the
>    op that triggers the max count threshold is selected and tagged.
>    Dispatched op mode produces a distribution of op samples that
> reflects
>    the execution frequency of instructions/basic blocks. DirectPath
>    Double and VectorPath (microcoded) x86 instructions which issue more
> than
>    one op will still be oversampled, however. The distribution is
> important
>    because it allows meaningful comparison of event counts between
>    instructions.
>
>    Even though the distribution of samples in dispatched op mode
> reflects
>    execution frequency, it is not a substitute for RETIRED_INSTRUCTIONS
>    (event select 0x0c0). The number of IBS op samples in some
> workloads,
>    especially those with certain kinds of stack access and microcoded
>    instructions, diverges greatly from RETIRED_INSTRUCTIONS.
>
>    IBS is what it is.
>
> IBS derived events
>
>    Since ProfileMe and Data EAR didn't exactly take the world by storm,
>    (oh, yeah, I worked with HP Caliper on Itanium for a while, too ;-),
>    profiling infrastructures like OProfile and CodeAnalyst are largely
>    based on the PMC sampling model.
>
>    In order to get IBS into practice as quickly as possible, we defined
>    IBS derived events. This allowed us to implement basic support for
>    IBS in both OProfile and CodeAnalyst without major changes in
>    infrastructure. I should note that translation from raw IBS bits to
>    derived events is and was always intended to be performed by user
>    space tools. I personally believe that translation should not be
>    performed in the kernel -- kernel support should be simple and
>    lightweight.
>
>    An IBS op sample is a small "packet" of profile data:
>
>        A bunch of event flags (data cache miss, etc.)
>        Tag-to-retire time (cycles)
>        Completion-to-retire (cycles)
>        DC miss latency (cycles)
>        DC miss addresses (64-bit virtual and physical addresses)
>
>    These entities can be used to compute latency distributions,
>    memory access maps, etc. IBS enables new kinds of analysis such
>    as data-centric profiling that identifies hot data regions (that
>    could be used to tune data layout in NUMA environment).
>
>    Quite frankly, at this juncture, I find the derived event model to
> be
>    too limiting. DCPI had a much different way of organizing ProfileMe
>    data that allowed flexible formulation of queries during
> post-processing --
>    something that cannot be done with the derived event approach.
>
>    Further, the organization and use of DC miss addresses is open for
>    investigation. I would _love_ to encourage someone (anyone? anyone?)
>    to take up this investigation. There may also be unforeseen uses --
>    perhaps driving compile-time optimizations. The existing derived
> events
>    do not adequately support new applications of IBS data. Thus, I
> would
>    encourage kernel-level support that passes IBS data along without
>    modification.
>
> Filtering.
>
>    After our initial experience with IBS, we see the need for
> filtering.
>    One approach is to collect and report only those IBS register values
>    that are needed to support a certain kind of analysis. For example,
>    if the DC miss addresses are not needed, why collect them? Suravee
>    and Robert Richter (both terrific colleagues) have been
> investigating
>    this, so I will defer to their analysis and comments.
>
> Software randomization.
>
>    We've found that software randomization of the sampling period
> and/or
>    current count is needed to avoid certain situations where the
> pipeline
>    and the sampling process get into a periodic hard-loop that affects
>    the distribution of IBS op samples. BTW, forcing those low order
> four
>    bits to zero occasionally has a negative effect on op distribution.
>
> IBS future extensions
>
>    Of course, I can't discuss specific new features. However, here are
>    some possible variations:
>
>       * The current count and max count values may become longer.
>       * New event flags may be added.
>       * Existing event flags may be left out (i.e., not implemented
>         in a family or model)
>       * New ancillary data (like DC miss latency or DC miss address)
>         may be added.
>
>    It may be necessary to collect new 64-bit values that do not contain
>    event flags, for example.
>
> Thanks for enduring this long-winded message. I hope that I've
> communicated some information and requirements, and I'll be more than
> happy to answer questions about IBS (or get the answers).
>
> -- pj
>
> Dr. Paul Drongowski
> AMD CodeAnalyst team
> Boston Design Center
>
> -------------------------
> The information presented in this reply is for informational purposes
> only and may contain technical inaccuracies, omissions and
> typographical errors. Links to third party sites are for convenience
> only, and no endorsement is implied.
>
>
>
>
> ------------------------------------------------------------------------------
> _______________________________________________
> perfmon2-devel mailing list
> perfmon2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/perfmon2-devel
>
