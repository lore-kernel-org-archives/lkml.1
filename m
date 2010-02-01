Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0BAQMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:12:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0BAQMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:12:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=MoAbHzPRW2c6t57b/PhKAenQYH4e9K514wdWm3OgIHc/QHfgGRxTYcB3SxQkskbvx
	6Z1Nsu4PcaRM7WTMQlQFg==
MIME-Version: 1.0
In-Reply-To: <1265038508.24455.177.camel@laptop>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
Date: Mon, 1 Feb 2010 17:12:50 +0100
Message-ID: <bd4cb8901002010812x505b77b4h754f573e3bbfa615@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 4:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-01 at 14:50 +0200, Stephane Eranian wrote:
>>       We cannot assume that because hwc->idx == assign[i], we
>>       can avoid reprogramming the counter in hw_perf_enable().
>>
>>       The event may have been scheduled out and another event
>>       may have been programmed into this counter. Thus, we need
>>       a more robust way of verifying if the counter still
>>       contains config/data related to an event.
>>
>>       This patch adds a generation number to each counter on each
>>       cpu. Using this mechanism we can verify reliabilty whether the
>>       content of a counter corresponds to an event.
>>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Thanks, got it.
>
> btw, I've also added the below, from what I can make from the docs fixed
> counter 2 is identical to arch perf event 0x013c, as per table A-1 and
> A-7. Both are called CPU_CLK_UNHALTED.REF, except for Core2, where
> 0x013c is called CPU_CLK_UNHALTED.BUS.
>

If you measure 0x013c in a generic counter or in fixed counter 2
it will count the same thing but not at the same rate.
This is true on Core2, Atom, Nehalem, Westmere. The ratio is the
clock/bus ratio.

This goes back to an earlier discussion where I was asking about
the meaning of the generic PMU events and in particular
PERF_COUNT_HW_CPU_CYCLES. Which of the 3 distinct cycle
events (unhalted_core_cycles, unhalted_reference_cycles, bus_cycles)
does not correspond to?



> ---
> Subject: perf_events, x86: Fixup fixed counter constraints
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Feb 01 15:36:30 CET 2010
>
> Patch 1da53e0230 ("perf_events, x86: Improve x86 event scheduling")
> lost us one of the fixed purpose counters and then ed8777fc13
> ("perf_events, x86: Fix event constraint masks") broke it even
> further.
>
> Widen the fixed event mask to event+umask and specify the full config
> for each of the 3 fixed purpose counters. Then let the init code fill
> out the placement for the GP regs based on the cpuid info.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  arch/x86/include/asm/perf_event.h |    2 +-
>  arch/x86/kernel/cpu/perf_event.c  |   38 ++++++++++++++++++++++++++++++--------
>  2 files changed, 31 insertions(+), 9 deletions(-)
>
> Index: linux-2.6/arch/x86/include/asm/perf_event.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/perf_event.h
> +++ linux-2.6/arch/x86/include/asm/perf_event.h
> @@ -50,7 +50,7 @@
>         INTEL_ARCH_INV_MASK| \
>         INTEL_ARCH_EDGE_MASK|\
>         INTEL_ARCH_UNIT_MASK|\
> -        INTEL_ARCH_EVTSEL_MASK)
> +        INTEL_ARCH_EVENT_MASK)
>
>  #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL                0x3c
>  #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK                (0x00 << 8)
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -243,8 +243,18 @@ static struct event_constraint intel_cor
>
>  static struct event_constraint intel_core2_event_constraints[] =
>  {
> -       FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
> -       FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 1ULL << 32), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1ULL << 33), /* CPU_CLK_UNHALTED.CORE */
> +       /*
> +        * FIXED_EVENT_CONSTRAINT(0x013c, 1ULL << 34),  CPU_CLK_UNHALTED.REF
> +        *
> +        * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
> +        * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
> +        * ratio between these counters.
> +        *
> +        * TODO: find/measure the fixed ratio and apply it so that we can
> +        * enable this fixed purpose counter in a transparent way.
> +        */
>        INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
>        INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
>        INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
> @@ -259,8 +269,9 @@ static struct event_constraint intel_cor
>
>  static struct event_constraint intel_nehalem_event_constraints[] =
>  {
> -       FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
> -       FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 1ULL << 32), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1ULL << 33), /* CPU_CLK_UNHALTED.CORE */
> +       FIXED_EVENT_CONSTRAINT(0x013c, 1ULL << 34), /* CPU_CLK_UNHALTED.REF */
>        INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
>        INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
>        INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
> @@ -274,8 +285,9 @@ static struct event_constraint intel_neh
>
>  static struct event_constraint intel_westmere_event_constraints[] =
>  {
> -       FIXED_EVENT_CONSTRAINT(0xc0, (0xf|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
> -       FIXED_EVENT_CONSTRAINT(0x3c, (0xf|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 1ULL << 32), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1ULL << 33), /* CPU_CLK_UNHALTED.CORE */
> +       FIXED_EVENT_CONSTRAINT(0x013c, 1ULL << 34), /* CPU_CLK_UNHALTED.REF */
>        INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
>        INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
>        INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
> @@ -284,8 +296,9 @@ static struct event_constraint intel_wes
>
>  static struct event_constraint intel_gen_event_constraints[] =
>  {
> -       FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
> -       FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 1ULL << 32), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1ULL << 33), /* CPU_CLK_UNHALTED.CORE */
> +       FIXED_EVENT_CONSTRAINT(0x013c, 1ULL << 34), /* CPU_CLK_UNHALTED.REF */
>        EVENT_CONSTRAINT_END
>  };
>
> @@ -2602,6 +2615,7 @@ static void __init pmu_check_apic(void)
>
>  void __init init_hw_perf_events(void)
>  {
> +       struct event_constraint *c;
>        int err;
>
>        pr_info("Performance Events: ");
> @@ -2650,6 +2664,14 @@ void __init init_hw_perf_events(void)
>                __EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1,
>                                   0, x86_pmu.num_events);
>
> +       for_each_event_constraint(c, x86_pmu.event_constraints) {
> +               if (c->cmask != INTEL_ARCH_FIXED_MASK)
> +                       continue;
> +
> +               c->idxmsk64[0] |= (1ULL << x86_pmu.num_events) - 1;
> +               c->weight += x86_pmu.num_events;
> +       }
> +
>        pr_info("... version:                %d\n",     x86_pmu.version);
>        pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
>        pr_info("... generic registers:      %d\n",     x86_pmu.num_events);
>
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
