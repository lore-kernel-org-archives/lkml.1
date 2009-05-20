Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZETRMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZETRMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZETRMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:12:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbZETRMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:12:15 -0400
Date: Wed, 20 May 2009 19:12:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: dynamically allocate tasks'
	perf_counter_context struct
Message-ID: <20090520171207.GA16706@elte.hu>
References: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> This replaces the struct perf_counter_context in the task_struct 
> with a pointer to a dynamically allocated perf_counter_context 
> struct.  The main reason for doing is this is to allow us to 
> transfer a perf_counter_context from one task to another when we 
> do lazy PMU switching in a later patch.

Hm, i'm not sure how far this gets us towards lazy PMU switching.

In fact i'd say that the term "lazy PMU switching" is probably 
misleading, we should use: "equivalent PMU context switching" or 
instead.

The difference is really crucial. We cannot really detach a PMU 
context from a task, because the task might migrate to another CPU 
and could run it there. Any lazyness in the switching of the PMU 
context would create the need to send IPIs and other overhead. For 
similar reasons are lazy FPU switching methods not workable on SMP 
generally.

Instead, the right abstraction is to define 'equivalency' between 
task's PMU contexts, created by inheritance. When two tasks 
context-switch that both have the same parent counter(s), we dont 
need to do _any_ physical PMU switching. The counts (and events) 
from one of the tasks can be freely transferred to the other task. 
It's going to get summarized in the parent anyway, so 
context-switching is an invariant.

To implement this, we need something like an 'ID', cookie or 
generation counter for the context, which changes to another unique 
number (or pointer) the moment a context is modified: a counter is 
added, removed or a counter attribute is changed. When counters are 
inherited the cookie gets carried over too. The context-switch code 
can then do this optimization:

	if (prev->ctx.cookie != next->ctx.cookie)
		switch_pmu_ctx(prev, next);

... which will be _very_ fast for the inherited counters (perf stat) 
case.

Note, this does put a few requirements on the architecture code, and 
it requires a few changes to the sched-in/sched-out code and 
requires a few changes to when tasks migrate to other CPUs.

For example the x86 code currently demuxes counter events back to 
counter pointers, using a per-cpu structure:

 struct cpu_hw_counters {
        struct perf_counter     *counters[X86_PMC_IDX_MAX];
        unsigned long           used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
        unsigned long           active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
        unsigned long           interrupts;
        int                     enabled;
 };

the counter pointers are per task - so this bit of cpu_hw_counters 
needs to move into the ctx structure, so that if an overflow IRQ 
comes in, we always only deal with local counters (not with some 
previous task's counter pointers).

	Ingo
