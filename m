Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYIYUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYIYUCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYIYUCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:02:13 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28246 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYIYUCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:02:08 -0400
X-BigFish: VPS-46(zz1432R541L98dR936eQ62a3L1805M655Ozzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7ROYS-02-ARB-01
Date: Thu, 25 Sep 2008 22:00:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] oprofile: Implement Intel architectural perfmon support
Message-ID: <20080925200048.GI23557@erda.amd.com>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org> <1219250433-25516-2-git-send-email-andi@firstfloor.org> <1219250433-25516-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1219250433-25516-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Sep 2008 20:00:53.0393 (UTC) FILETIME=[6A570010:01C91F49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.08 18:40:31, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Newer Intel CPUs (Core1+) have support for architectural
> events described in CPUID 0xA. See the IA32 SDM Vol3b.18 for details.
> 
> The advantage of this is that it can be done without knowing about
> the specific CPU, because the CPU describes by itself what
> performance events are supported. This is only a fallback
> because only a limited set of 6 events are supported.
> This allows to do profiling on Nehalem and on Atom systems
> (later not tested)
> 
> This patch implements support for that in oprofile's Intel
> Family 6 profiling module. It also has the advantage of supporting
> an arbitary number of events now as reported by the CPU.
> Also allow arbitary counter widths >32bit while we're at it.
> 
> Requires a patched oprofile userland to support the new
> architecture.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/kernel-parameters.txt |    5 ++
>  arch/x86/oprofile/nmi_int.c         |   32 +++++++++--
>  arch/x86/oprofile/op_model_ppro.c   |  104 +++++++++++++++++++++++++++-------
>  arch/x86/oprofile/op_x86_model.h    |    3 +
>  4 files changed, 116 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 056742c..10c8b1b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1486,6 +1486,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  	oprofile.timer=	[HW]
>  			Use timer interrupt instead of performance counters
>  
> +	oprofile.force_arch_perfmon=1 [X86]
> +			Force use of architectural perfmon performance counters
> +			in oprofile on Intel CPUs.  The kernel selects the
> +			correct default on its own.
> +

Could you create a separate patch that introduces this new kernel
parameter? This would make it easier to send all other changes
upstream. We already discussed the need of this parameter. Maybe it
would fit better to have a more generalized paramater for this that
could be reused then by other archs/models as well. Something like
force_pmu_detection that could be used for all new CPUs (also other
models) that do not yet have a specific kernel implementation.

Even better would a sysfs entry instead with that we can specify which
cpu type to use:

 echo "i386/arch_perfmon" > /sys/module/oprofile/parameters/cpu_type

That would allow us to switch the pmu at runtime and also from the
userland.

>  	osst=		[HW,SCSI] SCSI Tape Driver
>  			Format: <buffer_size>,<write_threshold>
>  			See also Documentation/scsi/st.txt.
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 36d2f92..6438c32 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -430,6 +430,19 @@ static int __init ppro_init(char **cpu_type)
>  	return 1;
>  }
>  
> +static int force_arch_perfmon;
> +module_param(force_arch_perfmon, int, 0);
> +
> +static int __init arch_perfmon_init(char **cpu_type)
> +{
> +	if (!cpu_has_arch_perfmon)
> +		return 0;
> +	*cpu_type = "i386/arch_perfmon";
> +	model = &op_arch_perfmon_spec;
> +	arch_perfmon_setup_counters();
> +	return 1;
> +}
> +
>  /* in order to get sysfs right */
>  static int using_nmi;
>  
> @@ -437,7 +450,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  {
>  	__u8 vendor = boot_cpu_data.x86_vendor;
>  	__u8 family = boot_cpu_data.x86;
> -	char *cpu_type;
> +	char *cpu_type = NULL;
>  
>  	if (!cpu_has_apic)
>  		return -ENODEV;
> @@ -467,22 +480,29 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  		break;
>  
>  	case X86_VENDOR_INTEL:
> +		if (force_arch_perfmon) {
> +			if (!arch_perfmon_init(&cpu_type))
> +				return -ENODEV;
> +			break;
> +		}
> +
>  		switch (family) {
>  			/* Pentium IV */
>  		case 0xf:
> -			if (!p4_init(&cpu_type))
> -				return -ENODEV;
> +			p4_init(&cpu_type);
>  			break;
>  
>  			/* A P6-class processor */
>  		case 6:
> -			if (!ppro_init(&cpu_type))
> -				return -ENODEV;
> +			ppro_init(&cpu_type);
>  			break;
>  
>  		default:
> -			return -ENODEV;
> +			break;
>  		}
> +
> +		if (!cpu_type && !arch_perfmon_init(&cpu_type))
> +			return -ENODEV;
>  		break;
>  
>  	default:
> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index eff431f..12e207a 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -1,32 +1,34 @@
>  /*
>   * @file op_model_ppro.h
> - * pentium pro / P6 model-specific MSR operations
> + * Family 6 perfmon and architectural perfmon MSR operations
>   *
>   * @remark Copyright 2002 OProfile authors
> + * @remark Copyright 2008 Intel Corporation
>   * @remark Read the file COPYING
>   *
>   * @author John Levon
>   * @author Philippe Elie
>   * @author Graydon Hoare
> + * @author Andi Kleen
>   */
>  
>  #include <linux/oprofile.h>
> +#include <linux/slab.h>
>  #include <asm/ptrace.h>
>  #include <asm/msr.h>
>  #include <asm/apic.h>
>  #include <asm/nmi.h>
> +#include <asm/intel_arch_perfmon.h>
>  
>  #include "op_x86_model.h"
>  #include "op_counter.h"
>  
> -#define NUM_COUNTERS 2
> -#define NUM_CONTROLS 2
> +static int num_counters = 2;
> +static int counter_width = 32;
>  
>  #define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
>  #define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
> -#define CTR_32BIT_WRITE(l, msrs, c)	\
> -	do {wrmsr(msrs->counters[(c)].addr, -(u32)(l), 0); } while (0)
> -#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
> +#define CTR_OVERFLOWED(n) (!((n) & (1U<<(counter_width-1))))
>  
>  #define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
>  #define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
> @@ -40,20 +42,20 @@
>  #define CTRL_SET_UM(val, m) (val |= (m << 8))
>  #define CTRL_SET_EVENT(val, e) (val |= e)
>  
> -static unsigned long reset_value[NUM_COUNTERS];
> +static u64 *reset_value;
>  
>  static void ppro_fill_in_addresses(struct op_msrs * const msrs)
>  {
>  	int i;
>  
> -	for (i = 0; i < NUM_COUNTERS; i++) {
> +	for (i = 0; i < num_counters; i++) {
>  		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
>  			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
>  		else
>  			msrs->counters[i].addr = 0;
>  	}
>  
> -	for (i = 0; i < NUM_CONTROLS; i++) {
> +	for (i = 0; i < num_counters; i++) {
>  		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
>  			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
>  		else
> @@ -67,8 +69,22 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>  	unsigned int low, high;
>  	int i;
>  
> +	if (!reset_value) {
> +		reset_value = kmalloc(sizeof(unsigned) * num_counters,
> +					GFP_ATOMIC);
> +		if (!reset_value)
> +			return;
> +	}
> +
> +	if (cpu_has_arch_perfmon) {
> +		union cpuid10_eax eax;
> +		eax.full = cpuid_eax(0xa);
> +		if (counter_width < eax.split.bit_width)
> +			counter_width = eax.split.bit_width;
> +	}
> +
>  	/* clear all counters */
> -	for (i = 0 ; i < NUM_CONTROLS; ++i) {
> +	for (i = 0 ; i < num_counters; ++i) {
>  		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
>  			continue;
>  		CTRL_READ(low, high, msrs, i);
> @@ -77,18 +93,18 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>  	}
>  
>  	/* avoid a false detection of ctr overflows in NMI handler */
> -	for (i = 0; i < NUM_COUNTERS; ++i) {
> +	for (i = 0; i < num_counters; ++i) {
>  		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
>  			continue;
> -		CTR_32BIT_WRITE(1, msrs, i);
> +		wrmsrl(msrs->counters[i].addr, -1LL);
>  	}
>  
>  	/* enable active counters */
> -	for (i = 0; i < NUM_COUNTERS; ++i) {
> +	for (i = 0; i < num_counters; ++i) {
>  		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
>  			reset_value[i] = counter_config[i].count;
>  
> -			CTR_32BIT_WRITE(counter_config[i].count, msrs, i);
> +			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>  
>  			CTRL_READ(low, high, msrs, i);
>  			CTRL_CLEAR(low);
> @@ -111,13 +127,13 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
>  	unsigned int low, high;
>  	int i;
>  
> -	for (i = 0 ; i < NUM_COUNTERS; ++i) {
> +	for (i = 0 ; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
>  		CTR_READ(low, high, msrs, i);
>  		if (CTR_OVERFLOWED(low)) {
>  			oprofile_add_sample(regs, i);
> -			CTR_32BIT_WRITE(reset_value[i], msrs, i);
> +			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>  		}
>  	}
>  
> @@ -141,7 +157,7 @@ static void ppro_start(struct op_msrs const * const msrs)
>  	unsigned int low, high;
>  	int i;
>  
> -	for (i = 0; i < NUM_COUNTERS; ++i) {
> +	for (i = 0; i < num_counters; ++i) {
>  		if (reset_value[i]) {
>  			CTRL_READ(low, high, msrs, i);
>  			CTRL_SET_ACTIVE(low);
> @@ -156,7 +172,7 @@ static void ppro_stop(struct op_msrs const * const msrs)
>  	unsigned int low, high;
>  	int i;
>  
> -	for (i = 0; i < NUM_COUNTERS; ++i) {
> +	for (i = 0; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
>  		CTRL_READ(low, high, msrs, i);
> @@ -169,21 +185,65 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
>  {
>  	int i;
>  
> -	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
> +	for (i = 0 ; i < num_counters ; ++i) {
>  		if (CTR_IS_RESERVED(msrs, i))
>  			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
>  	}
> -	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
> +	for (i = 0 ; i < num_counters ; ++i) {
>  		if (CTRL_IS_RESERVED(msrs, i))
>  			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
>  	}
> +	if (reset_value) {
> +		kfree(reset_value);
> +		reset_value = NULL;
> +	}
>  }
>  
>  
>  struct op_x86_model_spec const op_ppro_spec = {
> -	.num_counters = NUM_COUNTERS,
> -	.num_controls = NUM_CONTROLS,
> +	.num_counters = 2,
> +	.num_controls = 2,
> +	.fill_in_addresses = &ppro_fill_in_addresses,
> +	.setup_ctrs = &ppro_setup_ctrs,
> +	.check_ctrs = &ppro_check_ctrs,
> +	.start = &ppro_start,
> +	.stop = &ppro_stop,
> +	.shutdown = &ppro_shutdown
> +};
> +
> +/*
> + * Architectural performance monitoring.
> + *
> + * Newer Intel CPUs (Core1+) have support for architectural
> + * events described in CPUID 0xA. See the IA32 SDM Vol3b.18 for details.
> + * The advantage of this is that it can be done without knowing about
> + * the specific CPU.
> + */
> +
> +void arch_perfmon_setup_counters(void)
> +{
> +	union cpuid10_eax eax;
> +
> +	eax.full = cpuid_eax(0xa);
> +
> +	/* Workaround for BIOS bugs in 6/15. Taken from perfmon2 */
> +	if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
> +		current_cpu_data.x86_model == 15) {
> +		eax.split.version_id = 2;
> +		eax.split.num_counters = 2;
> +		eax.split.bit_width = 40;
> +	}
> +
> +	num_counters = eax.split.num_counters;
> +
> +	op_arch_perfmon_spec.num_counters = num_counters;
> +	op_arch_perfmon_spec.num_controls = num_counters;
> +}
> +
> +struct op_x86_model_spec op_arch_perfmon_spec = {
> +	/* num_counters/num_controls filled in at runtime */
>  	.fill_in_addresses = &ppro_fill_in_addresses,
> +	/* user space does the cpuid check for available events */
>  	.setup_ctrs = &ppro_setup_ctrs,
>  	.check_ctrs = &ppro_check_ctrs,
>  	.start = &ppro_start,
> diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
> index 575e08e..68c2bb9 100644
> --- a/arch/x86/oprofile/op_x86_model.h
> +++ b/arch/x86/oprofile/op_x86_model.h
> @@ -47,5 +47,8 @@ extern struct op_x86_model_spec const op_ppro_spec;
>  extern struct op_x86_model_spec const op_p4_spec;
>  extern struct op_x86_model_spec const op_p4_ht2_spec;
>  extern struct op_x86_model_spec const op_athlon_spec;
> +extern struct op_x86_model_spec op_arch_perfmon_spec;
> +
> +extern void arch_perfmon_setup_counters(void);

Put this to an init function of op_x86_model_spec. Then it could be
also static.

-Robert

>  
>  #endif /* OP_X86_MODEL_H */
> -- 
> 1.5.6
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

