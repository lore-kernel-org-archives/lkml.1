Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYKZNgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYKZNgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYKZNgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:36:24 -0500
Received: from www.tglx.de ([62.245.132.106]:49288 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYKZNgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:36:22 -0500
Date: Wed, 26 Nov 2008 14:35:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> This patch adds the X86 generic perfmon code. It is in charge of
> implementing certain key functionalities required by the generic
> code such as read/write of the PMU registers, low-level interrupt
> handling.
> 
> Signed-off-by: Stephane Eranian <eranian@gmail.com>
> --
>
> Index: o3/arch/x86/perfmon/Kconfig
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ o3/arch/x86/perfmon/Kconfig	2008-11-25 18:22:52.000000000 +0100
> @@ -0,0 +1,18 @@
> +menu "Hardware Performance Monitoring support"
> +config PERFMON
> +	bool "Perfmon2 performance monitoring interface"
> +	select X86_LOCAL_APIC

depends on X86_LOCAL_APIC

> +config PERFMON_DEBUG
> +	bool "Perfmon debugging"
> +	default n
> +	depends on PERFMON
> +	help
> +	Enables perfmon debugging support
> +
> +endmenu

Please move this config options into perfmon/Kconfig

config PERFMON
	bool "Perfmon2 performance monitoring interface"
	depends on ARCH_HAS_PERFMON_SUPPORT

So we avoid duplicating that all over the tree

> Index: o3/arch/x86/perfmon/perfmon.c
> +
> +DEFINE_PER_CPU(unsigned long, real_iip);
> +DEFINE_PER_CPU(int, pfm_using_nmi);

static

> +/**
> + * pfm_arch_ctxswin_thread - thread context switch in
> + * @task: task switched in
> + * @ctx: context for the task
> + * @set: active event set
> + *
> + * Called from pfm_ctxsw(). Task is guaranteed to be current.
> + * set cannot be NULL. Context is locked. Interrupts are masked.
> + *
> + * Caller has already restored all PMD and PMC registers, if
> + * necessary (i.e., lazy restore scheme).
> + *
> + * On x86, the only common code just needs to unsecure RDPMC if necessary
> + *
> + * On model-specific features, e.g., PEBS, IBS, are taken care of in the
> + * corresponding PMU description module
> + */

Can we please move these docbook comments to include/linux/perfmon.h ?

Otherwise we have them in ten different places and probably out of
sync sooner than later. kgdb and other infrastructures which are cross
arch do the same.

> +void pfm_arch_ctxswin_thread(struct task_struct *task, struct pfm_context *ctx)
> +{
> +	struct pfm_arch_context *ctx_arch;
> +
> +	ctx_arch = pfm_ctx_arch(ctx);

Can we please make this

	struct pfm_arch_context *ctx_arch = pfm_ctx_arch(ctx);

Same on various places below.

> +void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set)
> +{
> +	u16 i, num;

why u16 ? int is fine for loop counters

> +	num = set->nused_pmds;
> +
> +	/*
> +	 * we can restore only the PMD we use because:
> +	 *
> +	 * 	- can only read with pfm_read_pmds() the registers
> +	 * 	  declared used via pfm_write_pmds()
> +	 *
> +	 * 	- if cr4.pce=1, only counters are exposed to user. RDPMC
> +	 * 	  does not work with other types of PMU registers.Thus, no
> +	 * 	  address is ever exposed by counters
> +	 *
> +	 * 	- there is never a dependency between one pmd register and
> +	 * 	  another
> +	 */
> +	for (i = 0; num; i++) {
> +		if (likely(pfm_arch_bv_test_bit(i, set->used_pmds))) {
> +			pfm_write_pmd(ctx, i, set->pmds[i]);
> +			num--;
> +		}
> +	}

  This loop construct looks scary. It relies on set->nused_pmds >=
  bits set in set->used_pmds. I had to look more than once to
  understand that. It's used all over the code in variations.

> +/**
> + * smp_pmu_interrupt - lowest level PMU interrupt handler for X86
> + * @regs: machine state
> + *
> + * The PMU interrupt is handled through an interrupt gate, therefore
> + * the CPU automatically clears the EFLAGS.IF, i.e., masking interrupts.
> + *
> + * The perfmon interrupt handler MUST run with interrupts disabled due
> + * to possible race with other, higher priority interrupts, such as timer
> + * or IPI function calls.
> + *
> + * See description in IA-32 architecture manual, Vol 3 section 5.8.1
> + */
> +void smp_pmu_interrupt(struct pt_regs *regs)

Why is this only hooked up to x86_64 ?

> +/**
> + * pfm_handle_nmi - PMU NMI handler notifier callback

> + * Cannot grab any locks, include the perfmon context lock
> +	/*
> +	 * we stop the PMU to avoid further overflow before this
> +	 * one is treated by lower priority interrupt handler
> +	 */
> +	pmu_info->quiesce();

This calls into the intel/amd implementations and iterates over
pfm_pmu_conf->regs_all.pmcs and clears the event select registers.

How is that NMI safe against pfm_arch_write_pmc() in other places ?

> +	/*
> +	 * record actual instruction pointer
> +	 */
> +	__get_cpu_var(real_iip) = instruction_pointer(args->regs);
> +
> +	/*
> +	 * post lower priority interrupt (LOCAL_PERFMON_VECTOR)
> +	 */
> +	pfm_arch_resend_irq(ctx);

Do we really need this whole NMI business ?

> +	/*
> +	 * we need to rewrite the APIC vector on Intel
> +	 */
> +	if (current_cpu_data.x86_vendor == X86_VENDOR_INTEL)
> +		apic_write(APIC_LVTPC, APIC_DM_NMI);

Why reenable _before_ we handled the current set ?

> +/**
> + * pfm_arch_resend_irq - post perfmon interrupt on regular vector
> + *
> + * called from pfm_ctxswin_thread() and pfm_handle_nmi()
> + */
> +void pfm_arch_resend_irq(struct pfm_context *ctx)
> +{

> +	 * Instead we send ourself an IPI on the perfmon
> +	 * vector.
> +	 */
> +	val  = APIC_DEST_SELF|APIC_INT_ASSERT|
> +	       APIC_DM_FIXED|LOCAL_PERFMON_VECTOR;

Please use

       send_IPI_self(LOCAL_PERFMON_VECTOR);

instead of open coding it. 

Your code is also missing apic_wait_icr_idle() so it would kill an
queued, but not yet delivered IPI.

> +			PFM_DBG("pmc%d(%s) already used", i, d->desc);

cant we simply use pr_debug ?

> +		if (pmu_info->flags & PFM_X86_FL_NO_SHARING) {
> +			PFM_INFO("PMU already used by another subsystem, "

printk please

> +/**
> + * pfm-arch_pmu_release_percpu - clear NMI state for one CPU
> + *
> + */
> +static void pfm_arch_pmu_release_percpu(void *data)
> +{
> +	struct pfm_arch_pmu_info *pmu_info;
> +
> +	pmu_info = pfm_pmu_conf->pmu_info;
> +
> +	__get_cpu_var(pfm_using_nmi) = 0;
> +	/*
> +	 * invoke model specific release routine.
> +	 */
> +	if (pmu_info->release_pmu_percpu)
> +		pmu_info->release_pmu_percpu();
> +}
> +
> +/**
> + * pfm_arch_pmu_release - release PMU resource to system
> + *
> + * called from pfm_pmu_release()
> + * interrupts are not masked
> + *
> + * On x86, we return the PMU registers to the MSR allocator
> + */
> +void pfm_arch_pmu_release(void)
> +{
> +	struct pfm_regmap_desc *d;
> +	u16 i, n;
> +
> +	d = pfm_pmu_conf->pmc_desc;
> +	n = pfm_pmu_conf->regs_all.num_pmcs;
> +	for (i = 0; n; i++, d++) {
> +		if (!pfm_arch_bv_test_bit(i, pfm_pmu_conf->regs_all.pmcs))
> +			continue;
> +		release_evntsel_nmi(d->hw_addr);
> +		n--;
> +		PFM_DBG("pmc%u released", i);
> +	}
> +	d = pfm_pmu_conf->pmd_desc;
> +	n = pfm_pmu_conf->regs_all.num_pmds;
> +	for (i = 0; n; i++, d++) {
> +		if (!pfm_arch_bv_test_bit(i, pfm_pmu_conf->regs_all.pmds))
> +			continue;
> +		release_perfctr_nmi(d->hw_addr);
> +		n--;
> +		PFM_DBG("pmd%u released", i);
> +	}

What is masking the vectors ?

> +	/* clear NMI variable if used */
> +	if (__get_cpu_var(pfm_using_nmi))
> +		on_each_cpu(pfm_arch_pmu_release_percpu, NULL , 1);
> +}
> +

> Index: o3/arch/x86/include/asm/perfmon_kern.h

> +static inline void pfm_arch_unload_context(struct pfm_context *ctx)
> +static inline int pfm_arch_load_context(struct pfm_context *ctx)

> +void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set);
> +void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx);
> +void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx);

> +static inline void pfm_arch_intr_freeze_pmu(struct pfm_context *ctx,
> +static inline void pfm_arch_intr_unfreeze_pmu(struct pfm_context *ctx)
> +static inline void pfm_arch_ovfl_reset_pmd(struct pfm_context *ctx, unsigned int cnum)

80 chars.

> +static inline int pfm_arch_context_create(struct pfm_context *ctx, u32 ctx_flags)

Ditto.

> +static inline void pfm_arch_context_free(struct pfm_context *ctx)

> +/*
> + * functions implemented in arch/x86/perfmon/perfmon.c
> + */

The above non inlines are in perfmon.c as well.

> +int  pfm_arch_init(void);
> +void pfm_arch_resend_irq(struct pfm_context *ctx);
> +
> +int  pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx);
> +void pfm_arch_ctxswin_thread(struct task_struct *task, struct pfm_context *ctx);
> +
> +void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set);
> +int  pfm_arch_pmu_config_init(struct pfm_pmu_config *cfg);
> +void pfm_arch_pmu_config_remove(void);
> +char *pfm_arch_get_pmu_module_name(void);
> +int pfm_arch_pmu_acquire(u64 *unavail_pmcs, u64 *unavail_pmds);
> +void pfm_arch_pmu_release(void);
> +
> +static inline void pfm_arch_serialize(void)
> +{}
> +
> +static inline void pfm_arch_arm_handle_work(struct task_struct *task)
> +{}
> +
> +static inline void pfm_arch_disarm_handle_work(struct task_struct *task)
> +{}
> +
> +#define PFM_ARCH_CTX_SIZE	(sizeof(struct pfm_arch_context))
> +/*
> + * x86 does not need extra alignment requirements for the sampling buffer
> + */
> +#define PFM_ARCH_SMPL_ALIGN_SIZE	0

Defines in one place please

> +asmlinkage void  pmu_interrupt(void);

> +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)
> +{
> +	bitmap_copy((unsigned long *)a,
> +		    (unsigned long *)b,
> +		    nbits);

	bitmap_copy((unsigned long *) a, (unsigned long *) b, nbits);

Please.	

> +static inline void pfm_arch_bv_or(u64 *a, u64 *b, u64 *c, int nbits)
> +static inline void pfm_arch_bv_and(u64 *a, u64 *b, u64 *c, int nbits)
> +static inline void pfm_arch_bv_zero(u64 *a, int nbits)
> +static inline int pfm_arch_bv_weight(u64 *a, int nbits)
> +static inline void pfm_arch_bv_set_bit(int b, u64 *a)
> +static inline void pfm_arch_bv_clear_bit(int b, u64 *a)
> +static inline int pfm_arch_bv_test_bit(int b, u64 *a)
> +static inline unsigned long pfm_arch_bv_find_next_bit(const u64 *addr,

9 simple wrappers around generic bitops. The only reason you need
those is because you use 64bit variables and that does not work on
32bit BE machines.

I do not understand in the first place why you cant use simple
unsigned longs for the bitfields, but if this is necessary for
whatever non obvious reason, then its not an excuse to make this arch
dependent code at all. You need a LE/BE64 and a BE32 version.  So you
need a generic and a special be32 version. That's not arch specific.

Thanks,

	tglx

