Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0CCVwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:52:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab0CCVwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:52:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qIEr28pJ1vuEqR0f+lCWebtAEiXQWH3ztw3ma+mrNwZcrJAQsI6kGlElnR/rvU49P
	0sJWErxDYm21LL+JpOduA==
MIME-Version: 1.0
In-Reply-To: <20100303164306.451251096@chello.nl>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
Date: Wed, 3 Mar 2010 22:52:27 +0100
Message-ID: <bd4cb8901003031352x60bd48dfr6431260b3d824a72@mail.gmail.com>
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 5:39 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Implement support for Intel LBR stacks that support
> FREEZE_LBRS_ON_PMI. We do not (yet?) support the LBR config register
> because that is SMT wide and would also put undue restraints on the
> PEBS users.
>
You're saying PEBS users have priorities over pure LBR users?
Why is that?

Without coding this, how would you expose LBR configuration to userland
given you're using the PERF_SAMPLE_BRANCH_STACK approach?


> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event.c           |   22 ++
>  arch/x86/kernel/cpu/perf_event_intel.c     |   13 +
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  228 +++++++++++++++++++++++++++++
>  3 files changed, 263 insertions(+)
>
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -48,6 +48,12 @@ struct amd_nb {
>        struct event_constraint event_constraints[X86_PMC_IDX_MAX];
>  };
>
> +#define MAX_LBR_ENTRIES                16
> +
> +struct lbr_entry {
> +       u64     from, to, flags;
> +};
> +
>  struct cpu_hw_events {
>        /*
>         * Generic x86 PMC bits
> @@ -70,6 +76,14 @@ struct cpu_hw_events {
>        u64                     pebs_enabled;
>
>        /*
> +        * Intel LBR bits
> +        */
> +       int                     lbr_users;
> +       int                     lbr_entries;
> +       struct lbr_entry        lbr_stack[MAX_LBR_ENTRIES];
> +       void                    *lbr_context;
> +
> +       /*
>         * AMD specific bits
>         */
>        struct amd_nb           *amd_nb;
> @@ -154,6 +168,13 @@ struct x86_pmu {
>        int             pebs_record_size;
>        void            (*drain_pebs)(void);
>        struct event_constraint *pebs_constraints;
> +
> +       /*
> +        * Intel LBR
> +        */
> +       unsigned long   lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
> +       int             lbr_nr;                    /* hardware stack size */
> +       int             lbr_format;                /* hardware format     */
>  };
>
>  static struct x86_pmu x86_pmu __read_mostly;
> @@ -1238,6 +1259,7 @@ undo:
>
>  #include "perf_event_amd.c"
>  #include "perf_event_p6.c"
> +#include "perf_event_intel_lbr.c"
>  #include "perf_event_intel_ds.c"
>  #include "perf_event_intel.c"
>
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -480,6 +480,7 @@ static void intel_pmu_disable_all(void)
>                intel_pmu_disable_bts();
>
>        intel_pmu_pebs_disable_all();
> +       intel_pmu_lbr_disable_all();
>  }
>
>  static void intel_pmu_enable_all(void)
> @@ -499,6 +500,7 @@ static void intel_pmu_enable_all(void)
>        }
>
>        intel_pmu_pebs_enable_all();
> +       intel_pmu_lbr_enable_all();
>  }
>
>  static inline u64 intel_pmu_get_status(void)
> @@ -675,6 +677,8 @@ again:
>        inc_irq_stat(apic_perf_irqs);
>        ack = status;
>
> +       intel_pmu_lbr_read();
> +
>        /*
>         * PEBS overflow sets bit 62 in the global status register
>         */
> @@ -847,6 +851,8 @@ static __init int intel_pmu_init(void)
>                memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
>                       sizeof(hw_cache_event_ids));
>
> +               intel_pmu_lbr_init_core();
> +
>                x86_pmu.event_constraints = intel_core2_event_constraints;
>                pr_cont("Core2 events, ");
>                break;
> @@ -856,13 +862,18 @@ static __init int intel_pmu_init(void)
>                memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
>                       sizeof(hw_cache_event_ids));
>
> +               intel_pmu_lbr_init_nhm();
> +
>                x86_pmu.event_constraints = intel_nehalem_event_constraints;
>                pr_cont("Nehalem/Corei7 events, ");
>                break;
> +
>        case 28: /* Atom */
>                memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
>                       sizeof(hw_cache_event_ids));
>
> +               intel_pmu_lbr_init_atom();
> +
>                x86_pmu.event_constraints = intel_gen_event_constraints;
>                pr_cont("Atom events, ");
>                break;
> @@ -872,6 +883,8 @@ static __init int intel_pmu_init(void)
>                memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
>                       sizeof(hw_cache_event_ids));
>
> +               intel_pmu_lbr_init_nhm();
> +
>                x86_pmu.event_constraints = intel_westmere_event_constraints;
>                pr_cont("Westmere events, ");
>                break;
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -0,0 +1,228 @@
> +#ifdef CONFIG_CPU_SUP_INTEL
> +
> +enum {
> +       LBR_FORMAT_32           = 0x00,
> +       LBR_FORMAT_LIP          = 0x01,
> +       LBR_FORMAT_EIP          = 0x02,
> +       LBR_FORMAT_EIP_FLAGS    = 0x03,
> +};
> +
> +/*
> + * We only support LBR implementations that have FREEZE_LBRS_ON_PMI
> + * otherwise it becomes near impossible to get a reliable stack.
> + */
> +
> +#define X86_DEBUGCTL_LBR                               (1 << 0)
> +#define X86_DEBUGCTL_FREEZE_LBRS_ON_PMI                (1 << 11)
> +
> +static void __intel_pmu_lbr_enable(void)
> +{
> +       u64 debugctl;
> +
> +       rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +       debugctl |= (X86_DEBUGCTL_LBR | X86_DEBUGCTL_FREEZE_LBRS_ON_PMI);
> +       wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +}
> +
> +static void __intel_pmu_lbr_disable(void)
> +{
> +       u64 debugctl;
> +
> +       rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +       debugctl &= ~(X86_DEBUGCTL_LBR | X86_DEBUGCTL_FREEZE_LBRS_ON_PMI);
> +       wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +}
> +
> +static void intel_pmu_lbr_reset_32(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < x86_pmu.lbr_nr; i++)
> +               wrmsrl(x86_pmu.lbr_from + i, 0);
> +}
> +
> +static void intel_pmu_lbr_reset_64(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < x86_pmu.lbr_nr; i++) {
> +               wrmsrl(x86_pmu.lbr_from + i, 0);
> +               wrmsrl(x86_pmu.lbr_to   + i, 0);
> +       }
> +}
> +
> +static void intel_pmu_lbr_reset(void)
> +{
> +       if (x86_pmu.lbr_format == LBR_FORMAT_32)
> +               intel_pmu_lbr_reset_32();
> +       else
> +               intel_pmu_lbr_reset_64();
> +}
> +
> +static void intel_pmu_lbr_enable(struct perf_event *event)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +
> +       if (!x86_pmu.lbr_nr)
> +               return;
> +
> +       WARN_ON(cpuc->enabled);
> +
> +       /*
> +        * Reset the LBR stack if this is the first LBR user or
> +        * we changed task context so as to avoid data leaks.
> +        */
> +
> +       if (!cpuc->lbr_users ||
> +           (event->ctx->task && cpuc->lbr_context != event->ctx)) {
> +               intel_pmu_lbr_reset();
> +               cpuc->lbr_context = event->ctx;
> +       }
> +
> +       cpuc->lbr_users++;
> +}
> +
> +static void intel_pmu_lbr_disable(struct perf_event *event)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +
> +       if (!x86_pmu.lbr_nr)
> +               return;
> +
> +       cpuc->lbr_users--;
> +
> +       BUG_ON(cpuc->lbr_users < 0);
> +       WARN_ON(cpuc->enabled);
> +}
> +
> +static void intel_pmu_lbr_enable_all(void)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +
> +       if (cpuc->lbr_users)
> +               __intel_pmu_lbr_enable();
> +}
> +
> +static void intel_pmu_lbr_disable_all(void)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +
> +       if (cpuc->lbr_users)
> +               __intel_pmu_lbr_disable();
> +}
> +
> +static inline u64 intel_pmu_lbr_tos(void)
> +{
> +       u64 tos;
> +
> +       rdmsrl(x86_pmu.lbr_tos, tos);
> +
> +       return tos;
> +}
> +
> +static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
> +{
> +       unsigned long mask = x86_pmu.lbr_nr - 1;
> +       u64 tos = intel_pmu_lbr_tos();
> +       int i;
> +
> +       for (i = 0; i < x86_pmu.lbr_nr; i++, tos--) {
> +               unsigned long lbr_idx = (tos - i) & mask;
> +               union {
> +                       struct {
> +                               u32 from;
> +                               u32 to;
> +                       };
> +                       u64     lbr;
> +               } msr_lastbranch;
> +
> +               rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
> +
> +               cpuc->lbr_stack[i].from  = msr_lastbranch.from;
> +               cpuc->lbr_stack[i].to    = msr_lastbranch.to;
> +               cpuc->lbr_stack[i].flags = 0;
> +       }
> +       cpuc->lbr_entries = i;
> +}
> +
> +#define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
> +
> +/*
> + * Due to lack of segmentation in Linux the effective address (offset)
> + * is the same as the linear address, allowing us to merge the LIP and EIP
> + * LBR formats.
> + */
> +static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
> +{
> +       unsigned long mask = x86_pmu.lbr_nr - 1;
> +       u64 tos = intel_pmu_lbr_tos();
> +       int i;
> +
> +       for (i = 0; i < x86_pmu.lbr_nr; i++, tos--) {
> +               unsigned long lbr_idx = (tos - i) & mask;
> +               u64 from, to, flags = 0;
> +
> +               rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
> +               rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
> +
> +               if (x86_pmu.lbr_format == LBR_FORMAT_EIP_FLAGS) {
> +                       flags = !!(from & LBR_FROM_FLAG_MISPRED);
> +                       from = (u64)((((s64)from) << 1) >> 1);
> +               }
> +
> +               cpuc->lbr_stack[i].from  = from;
> +               cpuc->lbr_stack[i].to    = to;
> +               cpuc->lbr_stack[i].flags = flags;
> +       }
> +       cpuc->lbr_entries = i;
> +}
> +
> +static void intel_pmu_lbr_read(void)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +
> +       if (!cpuc->lbr_users)
> +               return;
> +
> +       if (x86_pmu.lbr_format == LBR_FORMAT_32)
> +               intel_pmu_lbr_read_32(cpuc);
> +       else
> +               intel_pmu_lbr_read_64(cpuc);
> +}
> +
> +static int intel_pmu_lbr_format(void)
> +{
> +       u64 capabilities;
> +
> +       rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
> +       return capabilities & 0x1f;
> +}
> +
> +static void intel_pmu_lbr_init_core(void)
> +{
> +       x86_pmu.lbr_format = intel_pmu_lbr_format();
> +       x86_pmu.lbr_nr     = 4;
> +       x86_pmu.lbr_tos    = 0x01c9;
> +       x86_pmu.lbr_from   = 0x40;
> +       x86_pmu.lbr_to     = 0x60;
> +}
> +
> +static void intel_pmu_lbr_init_nhm(void)
> +{
> +       x86_pmu.lbr_format = intel_pmu_lbr_format();
> +       x86_pmu.lbr_nr     = 16;
> +       x86_pmu.lbr_tos    = 0x01c9;
> +       x86_pmu.lbr_from   = 0x680;
> +       x86_pmu.lbr_to     = 0x6c0;
> +}
> +
> +static void intel_pmu_lbr_init_atom(void)
> +{
> +       x86_pmu.lbr_format = intel_pmu_lbr_format();
> +       x86_pmu.lbr_nr     = 8;
> +       x86_pmu.lbr_tos    = 0x01c9;
> +       x86_pmu.lbr_from   = 0x40;
> +       x86_pmu.lbr_to     = 0x60;
> +}
> +
> +#endif /* CONFIG_CPU_SUP_INTEL */
>
> --
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
