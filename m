Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXFMQqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXFMQqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbXFMQqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:46:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:38163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758443AbXFMQqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:46:31 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+ugvUN3gyunoyHlGmTAy1untxdS4icWY0vntWslt
	drdTp8p9zovnc4
Date: Wed, 13 Jun 2007 18:46:32 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Eranian <eranian@hpl.hp.com>, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com, ak@suse.de, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Separate performance counter reservation from nmi watchdog
Message-ID: <20070613164632.GA8674@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Eranian <eranian@hpl.hp.com>,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
	perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
	levon@movementarian.org, akpm@linux-foundation.org
References: <20070612150246.GJ32163@frankl.hpl.hp.com> <20070612190730.GA6978@atjola.homenet> <20070613014136.GA2386@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070613014136.GA2386@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.13 03:41:36 +0200, Björn Steinbrink wrote:
> On 2007.06.12 21:07:30 +0200, Björn Steinbrink wrote:
> > On 2007.06.12 08:02:46 -0700, Stephane Eranian wrote:
> > >  * the fill_in_addresses() callback for X86 invokes the NMI watchdog
> > >    reserve_*_nmi() register allocation routines. This is done regardless
> > >    of whether the NMI watchdog is active. When the NMI watchdog is not
> > >    active, the allocator will satisfy the allocation for the first MSR
> > >    of each type (counter or control), but then it will reject any
> > >    request for the others. You end up working with a single
> > >    counter/control register.
> > 
> > Hm, ouch. I'll try to move the reservation parts into a separate system.
> 
> Ok, here's the first try. The performance counter reservation system has
> been moved into its own file and separated from the nmi watchdog. Also,
> the probing rules were relaxed a bit, as they were more restrictive in
> the watchdog code than in the oprofile code.
> 
> The new code never allows to reserve a performance counter or event
> selection register when the probing failed, instead of allowing one
> random register to be reserved.
> 
> While moving the code around, I noticed that the PerfMon nmi watchdog
> actually reserved the wrong MSRs, as the generic reservation function
> always took the base register. As the respective attributes are no
> longer used as base regs, we can now store the correct value there and
> keep using the generic function.
> 
> Being unfamiliar with the kernel init process, I simply put the probing
> call right before the nmi watchdog initialization, but that's probably
> wrong (and dependent on local APIC on i386), so I'd be glad if someone
> could point out a better location.

JFYI, this should be 2.6.22 material, as the dependency on the nmi
watchdog being probed was added by the cleanup in commit
09198e68501a7e34737cd9264d266f42429abcdc. So it's a regression over
2.6.21.

> Thanks,
> Björn
> 
> 
> From: Björn Steinbrink <B.Steinbrink@gmx.de>
> 
> Separate the performance counter reservation system from the nmi
> watchdog to allow usage of all performance counters even if the nmi
> watchdog is not used.
> 
> Fixed the reservation of the wrong performance counter for the PerfMon
> based nmi watchdog along the way.
> 
> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> ---
> diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
> index 67824f3..88b74e3 100644
> --- a/arch/i386/kernel/apic.c
> +++ b/arch/i386/kernel/apic.c
> @@ -1009,6 +1009,7 @@ void __devinit setup_local_APIC(void)
>  	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
>  	apic_write_around(APIC_LVTT, value);
>  
> +	probe_performance_counters();
>  	setup_apic_nmi_watchdog(NULL);
>  	apic_pm_activate();
>  }
> diff --git a/arch/i386/kernel/cpu/Makefile b/arch/i386/kernel/cpu/Makefile
> index 74f27a4..882364d 100644
> --- a/arch/i386/kernel/cpu/Makefile
> +++ b/arch/i386/kernel/cpu/Makefile
> @@ -18,4 +18,4 @@ obj-$(CONFIG_X86_MCE)	+=	mcheck/
>  obj-$(CONFIG_MTRR)	+= 	mtrr/
>  obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
>  
> -obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
> +obj-$(CONFIG_X86_LOCAL_APIC) += perfctr.o perfctr-watchdog.o
> diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
> index 2b04c8f..6187097 100644
> --- a/arch/i386/kernel/cpu/perfctr-watchdog.c
> +++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
> @@ -8,9 +8,7 @@
>     Original code for K7/P6 written by Keith Owens */
>  
>  #include <linux/percpu.h>
> -#include <linux/module.h>
>  #include <linux/kernel.h>
> -#include <linux/bitops.h>
>  #include <linux/smp.h>
>  #include <linux/nmi.h>
>  #include <asm/apic.h>
> @@ -36,105 +34,8 @@ struct wd_ops {
>  
>  static struct wd_ops *wd_ops;
>  
> -/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
> - * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
> - */
> -#define NMI_MAX_COUNTER_BITS 66
> -
> -/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
> - * evtsel_nmi_owner tracks the ownership of the event selection
> - * - different performance counters/ event selection may be reserved for
> - *   different subsystems this reservation system just tries to coordinate
> - *   things a little
> - */
> -static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
> -static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
> -
>  static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
>  
> -/* converts an msr to an appropriate reservation bit */
> -static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
> -{
> -	return wd_ops ? msr - wd_ops->perfctr : 0;
> -}
> -
> -/* converts an msr to an appropriate reservation bit */
> -/* returns the bit offset of the event selection register */
> -static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
> -{
> -	return wd_ops ? msr - wd_ops->evntsel : 0;
> -}
> -
> -/* checks for a bit availability (hack for oprofile) */
> -int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
> -{
> -	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> -
> -	return (!test_bit(counter, perfctr_nmi_owner));
> -}
> -
> -/* checks the an msr for availability */
> -int avail_to_resrv_perfctr_nmi(unsigned int msr)
> -{
> -	unsigned int counter;
> -
> -	counter = nmi_perfctr_msr_to_bit(msr);
> -	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> -
> -	return (!test_bit(counter, perfctr_nmi_owner));
> -}
> -
> -int reserve_perfctr_nmi(unsigned int msr)
> -{
> -	unsigned int counter;
> -
> -	counter = nmi_perfctr_msr_to_bit(msr);
> -	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> -
> -	if (!test_and_set_bit(counter, perfctr_nmi_owner))
> -		return 1;
> -	return 0;
> -}
> -
> -void release_perfctr_nmi(unsigned int msr)
> -{
> -	unsigned int counter;
> -
> -	counter = nmi_perfctr_msr_to_bit(msr);
> -	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> -
> -	clear_bit(counter, perfctr_nmi_owner);
> -}
> -
> -int reserve_evntsel_nmi(unsigned int msr)
> -{
> -	unsigned int counter;
> -
> -	counter = nmi_evntsel_msr_to_bit(msr);
> -	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> -
> -	if (!test_and_set_bit(counter, evntsel_nmi_owner))
> -		return 1;
> -	return 0;
> -}
> -
> -void release_evntsel_nmi(unsigned int msr)
> -{
> -	unsigned int counter;
> -
> -	counter = nmi_evntsel_msr_to_bit(msr);
> -	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> -
> -	clear_bit(counter, evntsel_nmi_owner);
> -}
> -
> -EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
> -EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
> -EXPORT_SYMBOL(reserve_perfctr_nmi);
> -EXPORT_SYMBOL(release_perfctr_nmi);
> -EXPORT_SYMBOL(reserve_evntsel_nmi);
> -EXPORT_SYMBOL(release_evntsel_nmi);
> -
>  void disable_lapic_nmi_watchdog(void)
>  {
>  	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
> @@ -568,8 +469,8 @@ static struct wd_ops intel_arch_wd_ops = {
>  	.setup = setup_intel_arch_watchdog,
>  	.rearm = p6_rearm,
>  	.stop = single_msr_stop_watchdog,
> -	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
> -	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
> +	.perfctr = MSR_ARCH_PERFMON_PERFCTR1,
> +	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
>  };
>  
>  static void probe_nmi_watchdog(void)
> diff --git a/arch/i386/kernel/cpu/perfctr.c b/arch/i386/kernel/cpu/perfctr.c
> new file mode 100644
> index 0000000..63e68a3
> --- /dev/null
> +++ b/arch/i386/kernel/cpu/perfctr.c
> @@ -0,0 +1,175 @@
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <asm/msr-index.h>
> +#include <asm/intel_arch_perfmon.h>
> +
> +struct perfctr_base_regs {
> +	unsigned int perfctr;
> +	unsigned int evntsel;
> +};
> +
> +static struct perfctr_base_regs *perfctr_base_regs;
> +
> +static struct perfctr_base_regs k7_base_regs = {
> +	.perfctr = MSR_K7_PERFCTR0,
> +	.evntsel = MSR_K7_EVNTSEL0
> +};
> +
> +static struct perfctr_base_regs p4_base_regs = {
> +	.perfctr = MSR_P4_BPU_PERFCTR0,
> +	.evntsel = MSR_P4_BSU_ESCR0
> +};
> +
> +static struct perfctr_base_regs p6_base_regs = {
> +	.perfctr = MSR_P6_PERFCTR0,
> +	.evntsel = MSR_P6_EVNTSEL0
> +};
> +
> +static struct perfctr_base_regs arch_perfmon_base_regs = {
> +	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
> +	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0
> +};
> +
> +/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
> + * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
> + */
> +#define NMI_MAX_COUNTER_BITS 66
> +
> +/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
> + * evtsel_nmi_owner tracks the ownership of the event selection
> + * - different performance counters/ event selection may be reserved for
> + *   different subsystems this reservation system just tries to coordinate
> + *   things a little
> + */
> +static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
> +static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
> +
> +void __devinit probe_performance_counters(void)
> +{
> +	switch (boot_cpu_data.x86_vendor) {
> +	case X86_VENDOR_AMD:
> +		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
> +		    boot_cpu_data.x86 != 16)
> +			return;
> +
> +		perfctr_base_regs = &k7_base_regs;
> +		break;
> +
> +	case X86_VENDOR_INTEL:
> +		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
> +			perfctr_base_regs = &arch_perfmon_base_regs;
> +			break;
> +		}
> +		switch (boot_cpu_data.x86) {
> +		case 6:
> +			perfctr_base_regs = &p6_base_regs;
> +			break;
> +
> +		case 15:
> +			perfctr_base_regs = &p4_base_regs;
> +			break;
> +		}
> +		break;
> +	}
> +}
> +
> +/* converts an msr to an appropriate reservation bit */
> +static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
> +{
> +	return msr - perfctr_base_regs->perfctr;
> +}
> +
> +/* converts an msr to an appropriate reservation bit */
> +/* returns the bit offset of the event selection register */
> +static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
> +{
> +	return msr - perfctr_base_regs->evntsel;
> +}
> +
> +/* checks for a bit availability (hack for oprofile) */
> +int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
> +{
> +	if (!perfctr_base_regs)
> +		return 0;
> +
> +	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> +
> +	return (!test_bit(counter, perfctr_nmi_owner));
> +}
> +
> +/* checks the an msr for availability */
> +int avail_to_resrv_perfctr_nmi(unsigned int msr)
> +{
> +	unsigned int counter;
> +
> +	if (!perfctr_base_regs)
> +		return 0;
> +
> +	counter = nmi_perfctr_msr_to_bit(msr);
> +	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> +
> +	return (!test_bit(counter, perfctr_nmi_owner));
> +}
> +
> +int reserve_perfctr_nmi(unsigned int msr)
> +{
> +	unsigned int counter;
> +
> +	if (!perfctr_base_regs)
> +		return 0;
> +
> +	counter = nmi_perfctr_msr_to_bit(msr);
> +	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> +
> +	if (!test_and_set_bit(counter, perfctr_nmi_owner))
> +		return 1;
> +	return 0;
> +}
> +
> +void release_perfctr_nmi(unsigned int msr)
> +{
> +	unsigned int counter;
> +
> +	if (!perfctr_base_regs)
> +		return 0;
> +
> +	counter = nmi_perfctr_msr_to_bit(msr);
> +	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> +
> +	clear_bit(counter, perfctr_nmi_owner);
> +}
> +
> +int reserve_evntsel_nmi(unsigned int msr)
> +{
> +	unsigned int counter;
> +
> +	if (!perfctr_base_regs)
> +		return 0;
> +
> +	counter = nmi_evntsel_msr_to_bit(msr);
> +	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> +
> +	if (!test_and_set_bit(counter, evntsel_nmi_owner))
> +		return 1;
> +	return 0;
> +}
> +
> +void release_evntsel_nmi(unsigned int msr)
> +{
> +	unsigned int counter;
> +
> +	if (!perfctr_base_regs)
> +		return 0;
> +
> +	counter = nmi_evntsel_msr_to_bit(msr);
> +	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
> +
> +	clear_bit(counter, evntsel_nmi_owner);
> +}
> +
> +EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
> +EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
> +EXPORT_SYMBOL(reserve_perfctr_nmi);
> +EXPORT_SYMBOL(release_perfctr_nmi);
> +EXPORT_SYMBOL(reserve_evntsel_nmi);
> +EXPORT_SYMBOL(release_evntsel_nmi);
> diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
> index de1de8a..cc7587d 100644
> --- a/arch/x86_64/kernel/Makefile
> +++ b/arch/x86_64/kernel/Makefile
> @@ -9,7 +9,7 @@ obj-y	:= process.o signal.o entry.o traps.o irq.o \
>  		x8664_ksyms.o i387.o syscall.o vsyscall.o \
>  		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
>  		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o \
> -		perfctr-watchdog.o
> +		perfctr.o perfctr-watchdog.o
>  
>  obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
>  obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
> @@ -60,4 +60,5 @@ i8237-y				+= ../../i386/kernel/i8237.o
>  msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
>  alternative-y			+= ../../i386/kernel/alternative.o
>  pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
> +perfctr-y			+= ../../i386/kernel/cpu/perfctr.o
>  perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
> diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
> index 1b0e07b..892ebf8 100644
> --- a/arch/x86_64/kernel/apic.c
> +++ b/arch/x86_64/kernel/apic.c
> @@ -453,6 +453,7 @@ void __cpuinit setup_local_APIC (void)
>  			oldvalue, value);
>  	}
>  
> +	probe_performance_counters();
>  	nmi_watchdog_default();
>  	setup_apic_nmi_watchdog(NULL);
>  	apic_pm_activate();
> diff --git a/include/asm-i386/nmi.h b/include/asm-i386/nmi.h
> index fb1e133..736af6f 100644
> --- a/include/asm-i386/nmi.h
> +++ b/include/asm-i386/nmi.h
> @@ -18,6 +18,7 @@
>  int do_nmi_callback(struct pt_regs *regs, int cpu);
>  
>  extern int nmi_watchdog_enabled;
> +extern void probe_performance_counters(void);
>  extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
>  extern int avail_to_resrv_perfctr_nmi(unsigned int);
>  extern int reserve_perfctr_nmi(unsigned int);
> diff --git a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
> index d0a7f53..d45fc62 100644
> --- a/include/asm-x86_64/nmi.h
> +++ b/include/asm-x86_64/nmi.h
> @@ -46,6 +46,7 @@ extern int unknown_nmi_panic;
>  extern int nmi_watchdog_enabled;
>  
>  extern int check_nmi_watchdog(void);
> +extern void probe_performance_counters(void);
>  extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
>  extern int avail_to_resrv_perfctr_nmi(unsigned int);
>  extern int reserve_perfctr_nmi(unsigned int);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
