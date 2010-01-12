Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086Ab0ALQKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0ALQKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699Ab0ALQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:10:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0ALQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:10:33 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, perfmon2-devel@lists.sf.net,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 17:10:16 +0100
Message-ID: <1263312616.4244.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 12:50 +0200, Stephane Eranian wrote:
> 	This patch improves event scheduling by maximizing the use
> 	of PMU registers regardless of the order in which events are
> 	created in a group.
> 
> 	The algorithm takes into account the list of counter constraints
> 	for each event. It assigns events to counters from the most
> 	constrained, i.e., works on only one counter, to the least
> 	constrained, i.e., works on any counter.
> 
> 	Intel Fixed counter events and the BTS special event are also
> 	handled via this algorithm which is designed to be fairly generic.
> 
> 	The patch also updates the validation of an event to use the
> 	scheduling algorithm. This will cause early failure in
> 	perf_event_open().
> 
> 	This is the 2nd version of this patch. It follows the model used
> 	by PPC, by running the scheduling algorithm and the actual
> 	assignment separately. Actual assignment takes place in
> 	hw_perf_enable() whereas scheduling is implemented in
> 	hw_perf_group_sched_in() and x86_pmu_enable().

Looks very good, will have to reread it again in the morning to look for
more details but from an initial reading its fine.

One concern I do have is the loss of error checking on
event_sched_in()'s event->pmu->enable(), that could be another
'hardware' PMU like breakpoints, in which case it could fail.

Not sure what to do with that.. maybe we should not allow mixing
different hardware PMU events, but only 1 hardware + software events, in
which case the below patch should retain some of the
is_software_event()s.

Frederic, Paul?



> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> --

> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8d9f854..16beb34 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -19,6 +19,7 @@
>  #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
>  
>  #define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
> +#define ARCH_PERFMON_EVENTSEL_ANY			  (1 << 21)
>  #define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
>  #define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
>  #define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)


> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index d616c06..d68c3e5 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1343,6 +1579,13 @@ intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
>  		bits |= 0x2;
>  	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
>  		bits |= 0x1;
> +
> +	/*
> +	 * ANY bit is supported in v3 and up
> +	 */
> +	if (x86_pmu.version > 2 && hwc->config & ARCH_PERFMON_EVENTSEL_ANY)
> +		bits |= 0x4;
> +
>  	bits <<= (idx * 4);
>  	mask = 0xfULL << (idx * 4);
>  

This looks like a separate patch all by itself.

Also, the below fixes a few style nits and that is_software_event()
usage:

---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -225,7 +225,8 @@ static struct event_constraint intel_cor
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_nehalem_event_constraints[] = {
+static struct event_constraint intel_nehalem_event_constraints[] =
+{
 	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
 	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
 	EVENT_CONSTRAINT(0x40, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LD */
@@ -241,7 +242,8 @@ static struct event_constraint intel_neh
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_gen_event_constraints[] = {
+static struct event_constraint intel_gen_event_constraints[] =
+{
 	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
 	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
 };
@@ -1310,6 +1312,13 @@ skip:
 	return 0;
 }
 
+static const struct pmu pmu;
+
+static inline bool is_x86_event(struct perf_event *event)
+{
+	return event->pmu == pmu;
+}
+
 /*
  * dogrp: true if must collect siblings events (group)
  * returns total number of events and error code
@@ -1324,7 +1333,7 @@ static int collect_events(struct cpu_hw_
 	/* current number of events already accepted */
 	n = cpuc->n_events;
 
-	if (!is_software_event(leader)) {
+	if (is_x86_event(leader)) {
 		if (n >= max_count)
 			return -ENOSPC;
 		cpuc->event_list[n] = leader;
@@ -1334,7 +1343,7 @@ static int collect_events(struct cpu_hw_
 		return n;
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
-		if (is_software_event(event) ||
+		if (!is_x86_event(event) ||
 		    event->state == PERF_EVENT_STATE_OFF)
 			continue;
 
@@ -2154,7 +2163,7 @@ static void event_sched_in(struct perf_e
 	event->state = PERF_EVENT_STATE_ACTIVE;
 	event->oncpu = cpu;
 	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
-	if (is_software_event(event))
+	if (!is_x86_event(event))
 		event->pmu->enable(event);
 }
 
@@ -2209,7 +2218,7 @@ int hw_perf_group_sched_in(struct perf_e
 	 * 1 means successful and events are active
 	 * This is not quite true because we defer
 	 * actual activation until hw_perf_enable() but
-	 * this way we* ensure caller won't try to enable
+	 * this way we ensure caller won't try to enable
 	 * individual events
 	 */
 	return 1;



