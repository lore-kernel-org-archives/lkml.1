Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0BJKM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:12:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab0BJKMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:12:25 -0500
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100209223909.GE5068@lenovo>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu>
	 <20100209223909.GE5068@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 11:12:12 +0100
Message-ID: <1265796732.11509.260.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 01:39 +0300, Cyrill Gorcunov wrote:


> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> @@ -26,6 +26,7 @@
>  #include <linux/bitops.h>
>  
>  #include <asm/apic.h>
> +#include <asm/perf_p4.h>
>  #include <asm/stacktrace.h>
>  #include <asm/nmi.h>
>  
> @@ -140,6 +141,7 @@ struct x86_pmu {
>  	u64		max_period;
>  	u64		intel_ctrl;
>  	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
> +	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign, int cpu);
>  	void		(*enable_bts)(u64 config);
>  	void		(*disable_bts)(void);
>  

> +/*
> + * This is the most important routine of Netburst PMU actually
> + * and need a huge speedup!
> + */
> +static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign, int cpu)
> +{

> +}


> -static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
> +/* we don't use cpu argument here at all */
> +static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign, int cpu)
>  {
>  	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
>  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];


> @@ -1796,7 +2305,7 @@ static int x86_pmu_enable(struct perf_ev
>  	if (n < 0)
>  		return n;
>  
> -	ret = x86_schedule_events(cpuc, n, assign);
> +	ret = x86_pmu.schedule_events(cpuc, n, assign, 0);
>  	if (ret)
>  		return ret;
>  	/*

This look like a bug, surely we can run on !cpu0.

> @@ -2313,7 +2822,7 @@ int hw_perf_group_sched_in(struct perf_e
>  	if (n0 < 0)
>  		return n0;
>  
> -	ret = x86_schedule_events(cpuc, n0, assign);
> +	ret = x86_pmu.schedule_events(cpuc, n0, assign, cpu);
>  	if (ret)
>  		return ret;
>  

I'd try BUG_ON(cpu != smp_processor_id()) and scrap passing that cpu
thing around.

> @@ -2700,6 +3232,7 @@ static int validate_group(struct perf_ev
>  {
>  	struct perf_event *leader = event->group_leader;
>  	struct cpu_hw_events *fake_cpuc;
> +	int cpu = smp_processor_id();
>  	int ret, n;
>  
>  	ret = -ENOMEM;
> @@ -2725,7 +3258,7 @@ static int validate_group(struct perf_ev
>  
>  	fake_cpuc->n_events = n;
>  
> -	ret = x86_schedule_events(fake_cpuc, n, NULL);
> +	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL, cpu);
>  
>  out_free:
>  	kfree(fake_cpuc);


