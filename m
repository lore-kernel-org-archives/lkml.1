Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZBKIU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZBKIU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZBKIUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:20:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZBKIUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:20:16 -0500
Date: Wed, 11 Feb 2009 09:20:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: allow users to count user, kernel
	and/or hypervisor events
Message-ID: <20090211082004.GA21105@elte.hu>
References: <18834.20374.325525.248022@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18834.20374.325525.248022@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Impact: new perf_counter feature
> 
> This extends the perf_counter_hw_event struct with bits that specify
> that events in user, kernel and/or hypervisor mode should not be
> counted (i.e. should be excluded), and adds code to program the PMU
> mode selection bits accordingly on x86 and powerpc.

Nice generalization!

Two small details:

> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -107,21 +107,25 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
>  		return -EINVAL;
>  
>  	/*
> -	 * Count user events, and generate PMC IRQs:
> +	 * Generate PMC IRQs:
>  	 * (keep 'enabled' bit clear for now)
>  	 */
> -	hwc->config = ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_INT;
> +	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
>  
>  	/*
> -	 * If privileged enough, count OS events too, and allow
> -	 * NMI events as well:
> +	 * Count user and OS events unless requested not to.
>  	 */
> -	hwc->nmi = 0;
> -	if (capable(CAP_SYS_ADMIN)) {
> +	if (!hw_event->exclude_user)
> +		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
> +	if (!hw_event->exclude_kernel)
>  		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
> -		if (hw_event->nmi)
> -			hwc->nmi = 1;
> -	}
> +
> +	/*
> +	 * If privileged enough, allow NMI events:
> +	 */
> +	hwc->nmi = 0;
> +	if (capable(CAP_SYS_ADMIN) && hw_event->nmi)
> +		hwc->nmi = 1;

Note that previously is was not just NMI counts that were privileged,
also kernel (and hypervisor) counts were non-accessible to
non-CAP_ADMIN users.

The reason is security: if PMU features are finegrained enough then
even via the use of pure counts an attacker can extract things like
crypto keys more easily, just via statistical probing.

For example if an in-kernel secret key is used to encrypt or decrypt
something, and user-space can trigger that path in a probing way
(i.e. can trigger it an arbitrary number of times and can provide
near-arbitrary plaintext input to the crypto algorithm), then the
number of divisions and multiplications done by the crypto algorithm
may show valuable numeric properties of the key in question. Same goes
for the number of memory/cache operations done, or the number of branches
executed.

To make matters worse, these counts are often 'complimentary' in a
mathematical sense, i.e. they shed light on different aspects of the
key's particular interaction with the crypto algorithm and with the
known-plaintext, and if used together they can expose deep details.

This technique goes beyond the well-known attack vector of the cycle
counter (which is useful too but very noisy in practice), and in certain
cases it might make the recovery of keys a lot easier and a lot faster.

OTOH, i think security worries like that, while well-founded for certain
threat models, are quite detached from everyday Linux use and limit the
utility of perfcounters. So i dont disagree with the way you extended
things here - but i think we should do it consciously and should provide
a toggle for the paranoid or the needy, via a __read_mostly sysctl switch.

Something like /proc/sys/kernel/perf_counters_strict - and default the
switch to off. (i.e. allow perfcounter use by default)

Plus we should also provide a high-level LSM callback to allow more
finegrained control of perfcounter access.

[ And maybe, in the long run, we want to protect sensitive codepaths of
  execution via perfcounter-disable/enable pairs. ]

> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -1567,11 +1567,25 @@ sw_perf_counter_init(struct perf_counter *counter)
>  {
>  	const struct hw_perf_counter_ops *hw_ops = NULL;
>  
> +	/*
> +	 * Software counters (currently) can't in general distinguish
> +	 * between user, kernel and hypervisor events.
> +	 * However, context switches and cpu migrations are considered
> +	 * to be kernel events, and page faults are never hypervisor
> +	 * events.
> +	 */
>  	switch (counter->hw_event.type) {
>  	case PERF_COUNT_CPU_CLOCK:
> -		hw_ops = &perf_ops_cpu_clock;
> +		if (!(counter->hw_event.exclude_user ||
> +		      counter->hw_event.exclude_kernel ||
> +		      counter->hw_event.exclude_hv))
> +			hw_ops = &perf_ops_cpu_clock;
>  		break;
>  	case PERF_COUNT_TASK_CLOCK:
> +		if (counter->hw_event.exclude_user ||
> +		    counter->hw_event.exclude_kernel ||
> +		    counter->hw_event.exclude_hv)
> +			break;
>  		/*
>  		 * If the user instantiates this as a per-cpu counter,
>  		 * use the cpu_clock counter instead.
> @@ -1582,13 +1596,17 @@ sw_perf_counter_init(struct perf_counter *counter)
>  			hw_ops = &perf_ops_cpu_clock;
>  		break;
>  	case PERF_COUNT_PAGE_FAULTS:
> -		hw_ops = &perf_ops_page_faults;
> +		if (!(counter->hw_event.exclude_user ||
> +		      counter->hw_event.exclude_kernel))
> +			hw_ops = &perf_ops_page_faults;
>  		break;
>  	case PERF_COUNT_CONTEXT_SWITCHES:
> -		hw_ops = &perf_ops_context_switches;
> +		if (!counter->hw_event.exclude_kernel)
> +			hw_ops = &perf_ops_context_switches;
>  		break;
>  	case PERF_COUNT_CPU_MIGRATIONS:
> -		hw_ops = &perf_ops_cpu_migrations;
> +		if (!counter->hw_event.exclude_kernel)
> +			hw_ops = &perf_ops_cpu_migrations;
>  		break;

I think here it would be cleaner if we extended perf_ops with a bitmask that
contains the kind of events it supports? For hw counters that would
default to all bits set - but sw counters could limit themselves via the
rules above.

	Ingo
