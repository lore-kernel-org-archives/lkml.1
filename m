Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbZANJ6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbZANJ6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbZANJ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:57:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbZANJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:57:51 -0500
Date: Wed, 14 Jan 2009 10:57:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add support for pinned and exclusive
	counter groups
Message-ID: <20090114095743.GA1389@elte.hu>
References: <18797.44875.470975.535175@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18797.44875.470975.535175@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4885]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Impact: New perf_counter features
> 
> A pinned counter group is one that the user wants to have on the CPU 
> whenever possible, i.e. whenever the associated task is running, for a 
> per-task group, or always for a per-cpu group.  If the system cannot 
> satisfy that, it puts the group into an error state where it is not 
> scheduled any more and reads from it return EOF (i.e. 0 bytes read).  
> The group can be released from error state and made readable again using 
> prctl(PR_TASK_PERF_COUNTERS_ENABLE).  When we have finer-grained 
> enable/disable controls on counters we'll be able to reset the error 
> state on individual groups.

ok, that looks like quite sensible semantics.

> An exclusive group is one that the user wants to be the only group using 
> the CPU performance monitor hardware whenever it is on.  The counter 
> group scheduler will not schedule an exclusive group if there are 
> already other groups on the CPU and will not schedule other groups onto 
> the CPU if there is an exclusive group scheduled (that statement does 
> not apply to groups containing only software counters, which can always 
> go on and which do not prevent an exclusive group from going on). With 
> an exclusive group, we will be able to let users program PMU registers 
> at a low level without the concern that those settings will perturb 
> other measurements.

ok, this sounds good too. The disadvantage is the reduction in utility. 
Actual applications and users will decide which variant is more useful in 
practice - it does not complicate the design unreasonably.

> Along the way this reorganizes things a little:
> - is_software_counter() is moved to perf_counter.h.
> - cpuctx->active_oncpu now records the number of hardware counters on
>   the CPU, i.e. it now excludes software counters.  Nothing was reading
>   cpuctx->active_oncpu before, so this change is harmless.

(btw., the percpu allocation code seems to have bitrotten a bit - the 
logic around perf_reserved_percpu looks wrong and somewhat complicated.)

> - A new cpuctx->exclusive field records whether we currently have an
>   exclusive group on the CPU.
> - counter_sched_out moves higher up in perf_counter.c and gets called
>   from __perf_counter_remove_from_context and __perf_counter_exit_task,
>   where we used to have essentially the same code.
> - __perf_counter_sched_in now goes through the counter list twice, doing
>   the pinned counters in the first loop and the non-pinned counters in
>   the second loop, in order to give the pinned counters the best chance
>   to be scheduled in.

hm, i guess this could be improved: by queueing pinned counters in front 
of the list and unpinned counters to the tail.

> Note that only a group leader can be exclusive or pinned, and that 
> attribute applies to the whole group.  This avoids some awkwardness in 
> some corner cases (e.g. where a group leader is closed and the other 
> group members get added to the context list).  If we want to relax that 
> restriction later, we can, and it is easier to relax a restriction than 
> to apply a new one.

yeah, agreed.

> What this doesn't handle is when a pinned counter gets inherited and 
> goes into error state in the child.  The sensible thing would be to put 
> the parent counter into error state in __perf_counter_exit_task, but 
> that might mean taking it off the PMU on some other CPU, and I was 
> nervous about doing anything substantial to parent_counter.  Maybe what 
> we need instead of an error value for counter->state is a separate error 
> flag that can be set atomically by exiting children. BTW, I think we 
> need an smp_wmb after updating parent_counter->count, so that when the 
> parent sees the child has exited it is guaranteed to see the updated 
> ->count value.

Yeah. Such artifacts at inheritance stem from the reduction in utility 
that comes from any exclusive-resource-usage scheme, and are expected.

For example, right now it works just fine to nest 'timec' in itself [there 
is a reduction in statistical value if we start round-robining, but 
there's still full utility]. If it used exclusive or pinned counters that 
might not work.

Again, which restrictions users/developers are more willing to live with 
will be shown in actual usage of these facilities.

	Ingo
