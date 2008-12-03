Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYLCL1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLCL1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYLCL1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:27:35 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:52945 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbYLCL1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:27:34 -0500
Date: Wed, 3 Dec 2008 19:27:25 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: v2.6.28-rc7: Fail compile arch/x86/kernel/cpu/common.c
Message-ID: <20081203112725.GA6822@ubuntu>
References: <20081203070115.GA32403@ubuntu> <20081203073504.GB17580@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081203073504.GB17580@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 08:35:04AM +0100, Ingo Molnar wrote:
>* Jianjun Kong <jianjun@zeuux.org> wrote:
>> arch/x86/kernel/cpu/common.c: In function ‘early_identify_cpu’:
>> arch/x86/kernel/cpu/common.c:555: error: ‘boot_cpu_id’ undeclared (first
>> use in this function)
>> arch/x86/kernel/cpu/common.c:555: error: (Each undeclared identifier is
>> reported only once
>> arch/x86/kernel/cpu/common.c:555: error: for each function it appears
>> in.)
>> arch/x86/kernel/cpu/common.c: In function ‘cpu_init’:
>> arch/x86/kernel/cpu/common.c:1142: error: ‘boot_cpu_id’ undeclared
>> (first use in this function)
>> make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
>> make[1]: *** [arch/x86/kernel/cpu] Error 2
>> make: *** [arch/x86/kernel] Error 2
>
>i cannot reproduce this build error neither with v2.6.28-rc7 nor 
>with latest -git (commit f6f7b52), using your config.
>
>could you send me your arch/x86/include/asm/smp.h file? Could 
>you also double-check that you have the kernel source tree 
>checked out properly? If you track it as a remote as per:

My kernel source tree checked out from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git, and there is no problem of check out.

This problem is also exist on the latest code of linux-2.6.git.

$ cat arch/x86/include/asm/smp.h

#ifndef _ASM_X86_SMP_H
#define _ASM_X86_SMP_H
#ifndef __ASSEMBLY__
#include <linux/cpumask.h>
#include <linux/init.h>
#include <asm/percpu.h>

/*
 * We need the APIC definitions automatically as part of 'smp.h'
 */
#ifdef CONFIG_X86_LOCAL_APIC
# include <asm/mpspec.h>
# include <asm/apic.h>
# ifdef CONFIG_X86_IO_APIC
#  include <asm/io_apic.h>
# endif
#endif
#include <asm/pda.h>
#include <asm/thread_info.h>

extern cpumask_t cpu_callout_map;
extern cpumask_t cpu_initialized;
extern cpumask_t cpu_callin_map;

extern void (*mtrr_hook)(void);
extern void zap_low_mappings(void);

extern int __cpuinit get_local_pda(int cpu);

extern int smp_num_siblings;
extern unsigned int num_processors;
extern cpumask_t cpu_initialized;

DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
DECLARE_PER_CPU(cpumask_t, cpu_core_map);
DECLARE_PER_CPU(u16, cpu_llc_id);
#ifdef CONFIG_X86_32
DECLARE_PER_CPU(int, cpu_number);
#endif

DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);

/* Static state in head.S used to set up a CPU */
extern struct {
	void *sp;
	unsigned short ss;
} stack_start;

struct smp_ops {
	void (*smp_prepare_boot_cpu)(void);
	void (*smp_prepare_cpus)(unsigned max_cpus);
	void (*smp_cpus_done)(unsigned max_cpus);

	void (*smp_send_stop)(void);
	void (*smp_send_reschedule)(int cpu);

	int (*cpu_up)(unsigned cpu);
	int (*cpu_disable)(void);
	void (*cpu_die)(unsigned int cpu);
	void (*play_dead)(void);

	void (*send_call_func_ipi)(cpumask_t mask);
	void (*send_call_func_single_ipi)(int cpu);
};

/* Globals due to paravirt */
extern void set_cpu_sibling_map(int cpu);

#ifdef CONFIG_SMP
#ifndef CONFIG_PARAVIRT
#define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
#endif
extern struct smp_ops smp_ops;

static inline void smp_send_stop(void)
{
	smp_ops.smp_send_stop();
}

static inline void smp_prepare_boot_cpu(void)
{
	smp_ops.smp_prepare_boot_cpu();
}

static inline void smp_prepare_cpus(unsigned int max_cpus)
{
	smp_ops.smp_prepare_cpus(max_cpus);
}

static inline void smp_cpus_done(unsigned int max_cpus)
{
	smp_ops.smp_cpus_done(max_cpus);
}

static inline int __cpu_up(unsigned int cpu)
{
	return smp_ops.cpu_up(cpu);
}

static inline int __cpu_disable(void)
{
	return smp_ops.cpu_disable();
}

static inline void __cpu_die(unsigned int cpu)
{
	smp_ops.cpu_die(cpu);
}

static inline void play_dead(void)
{
	smp_ops.play_dead();
}

static inline void smp_send_reschedule(int cpu)
{
	smp_ops.smp_send_reschedule(cpu);
}

static inline void arch_send_call_function_single_ipi(int cpu)
{
	smp_ops.send_call_func_single_ipi(cpu);
}

static inline void arch_send_call_function_ipi(cpumask_t mask)
{
	smp_ops.send_call_func_ipi(mask);
}

void cpu_disable_common(void);
void native_smp_prepare_boot_cpu(void);
void native_smp_prepare_cpus(unsigned int max_cpus);
void native_smp_cpus_done(unsigned int max_cpus);
int native_cpu_up(unsigned int cpunum);
int native_cpu_disable(void);
void native_cpu_die(unsigned int cpu);
void native_play_dead(void);
void play_dead_common(void);

void native_send_call_func_ipi(cpumask_t mask);
void native_send_call_func_single_ipi(int cpu);

extern void prefill_possible_map(void);

void smp_store_cpu_info(int id);
#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)

/* We don't mark CPUs online until __cpu_up(), so we need another measure */
static inline int num_booting_cpus(void)
{
	return cpus_weight(cpu_callout_map);
}
#else
static inline void prefill_possible_map(void)
{
}
#endif /* CONFIG_SMP */

extern unsigned disabled_cpus __cpuinitdata;

#ifdef CONFIG_X86_32_SMP
/*
 * This function is needed by all SMP systems. It must _always_ be valid
 * from the initial startup. We map APIC_BASE very early in page_setup(),
 * so this is correct in the x86 case.
 */
#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
extern int safe_smp_processor_id(void);

#elif defined(CONFIG_X86_64_SMP)
#define raw_smp_processor_id()	read_pda(cpunumber)

#define stack_smp_processor_id()					\
({								\
	struct thread_info *ti;						\
	__asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
	ti->cpu;							\
})
#define safe_smp_processor_id()		smp_processor_id()

#else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
#define cpu_physical_id(cpu)		boot_cpu_physical_apicid
#define safe_smp_processor_id()		0
#define stack_smp_processor_id() 	0
#endif

#ifdef CONFIG_X86_LOCAL_APIC

#ifndef CONFIG_X86_64
static inline int logical_smp_processor_id(void)
{
	/* we don't want to mark this access volatile - bad code generation */
	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
}

#include <mach_apicdef.h>
static inline unsigned int read_apic_id(void)
{
	unsigned int reg;

	reg = *(u32 *)(APIC_BASE + APIC_ID);

	return GET_APIC_ID(reg);
}
#endif


# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
extern int hard_smp_processor_id(void);
# else
#include <mach_apicdef.h>
static inline int hard_smp_processor_id(void)
{
	/* we don't want to mark this access volatile - bad code generation */
	return read_apic_id();
}
# endif /* APIC_DEFINITION */

#else /* CONFIG_X86_LOCAL_APIC */

# ifndef CONFIG_SMP
#  define hard_smp_processor_id()	0
# endif

#endif /* CONFIG_X86_LOCAL_APIC */

#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
extern unsigned char boot_cpu_id;
#else
#define boot_cpu_id	0
#endif

#endif /* __ASSEMBLY__ */
#endif /* _ASM_X86_SMP_H */
