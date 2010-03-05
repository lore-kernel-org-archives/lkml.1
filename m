Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0CES7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:59:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37591 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0CES7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:59:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=M+cn7N/WI9azCb4HP6tb8ZYOXNvJeoY+/Flc6GVvnDfqSjN79x+JxE4MNPWi9stf5
	3ZbfXdvxgQsnpohRygevg==
MIME-Version: 1.0
In-Reply-To: <20100305154128.890278662@chello.nl>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
Date: Fri, 5 Mar 2010 10:58:40 -0800
Message-ID: <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 7:39 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> This CPU has just too many handycaps to be really useful.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |    4 ++++
>  arch/x86/kernel/cpu/perf_event_intel.c |   27 +++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
>
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -197,6 +197,7 @@ struct x86_pmu {
>        void            (*put_event_constraints)(struct cpu_hw_events *cpuc,
>                                                 struct perf_event *event);
>        struct event_constraint *event_constraints;
> +       void            (*quirks)(void);
>
>        void            (*cpu_prepare)(int cpu);
>        void            (*cpu_starting)(int cpu);
> @@ -1380,6 +1381,9 @@ void __init init_hw_perf_events(void)
>
>        pr_cont("%s PMU driver.\n", x86_pmu.name);
>
> +       if (x86_pmu.quirks)
> +               x86_pmu.quirks();
> +
>        if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
>                WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
>                     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -800,6 +800,32 @@ static __initconst struct x86_pmu intel_
>        .cpu_dying              = fini_debug_store_on_cpu,
>  };
>
> +static void intel_clowertown_quirks(void)
> +{
> +       /*
> +        * PEBS is unreliable due to:
> +        *
> +        *   AJ67  - PEBS may experience CPL leaks
> +        *   AJ68  - PEBS PMI may be delayed by one event
> +        *   AJ69  - GLOBAL_STATUS[62] will only be set when DEBUGCTL[12]
> +        *   AJ106 - FREEZE_LBRS_ON_PMI doesn't work in combination with PEBS
> +        *
> +        * AJ67 could be worked around by restricting the OS/USR flags.
> +        * AJ69 could be worked around by setting PMU_FREEZE_ON_PMI.
> +        *
> +        * AJ106 could possibly be worked around by not allowing LBR
> +        *       usage from PEBS, including the fixup.
> +        * AJ68  could possibly be worked around by always programming
> +        *       a pebs_event_reset[0] value and coping with the lost events.
> +        *
> +        * But taken together it might just make sense to not enable PEBS on
> +        * these chips.
> +        */
> +       printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
> +       x86_pmu.pebs = 0;
> +       x86_pmu.pebs_constraints = NULL;
> +}
> +
>  static __init int intel_pmu_init(void)
>  {
>        union cpuid10_edx edx;
> @@ -864,6 +890,7 @@ static __init int intel_pmu_init(void)
>                break;
>
>        case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> +               x86_pmu.quirks = intel_clowertown_quirks;

That's too coarse grain!
It is more subtle than this. Some of the errata are marked as Plan
fix. They seem to be
fixed in later models. Your looking at the E5xxx series errata but the
E7xxx do not have
the same problems.

As for CPL leaking, you get that also with regular sampling when you
execute near
the user/kernel boundary given you have skid. Either the kernel or the
user has to
drop samples.
