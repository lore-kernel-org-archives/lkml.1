Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZCKQqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZCKQqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZCKQqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:46:37 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52342 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbZCKQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:46:37 -0400
Subject: Re: [PATCH 2/2] cpumask: use modern cpumask methods in
	arch/x86/mach-voyager/voyager_smp.c
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20090311064033.CA31DDE154@ozlabs.org>
References: <20090311064033.CA31DDE154@ozlabs.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 16:46:32 +0000
Message-Id: <1236789992.3270.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 17:02 +1030, Rusty Russell wrote:
> Impact: cleanup
> 
> 1) cpus_addr() -> cpumask_bits()
> 2) cpu_online_map -> cpu_online_mask
> 3) init_cpu_online & set_cpu_online
> 4) smp_commenced_mask is an unsigned long, not a cpumask_t (easier than
>    a cpumask_var_t).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> To: James.Bottomley@HansenPartnership.com

Looks fine ... I'll just have to do some integration with this patch

http://marc.info/?l=linux-kernel&m=123653138913095

Which contains a few changes in this area.

James


> ---
>  arch/x86/mach-voyager/voyager_smp.c |   45 +++++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> --- a/arch/x86/mach-voyager/voyager_smp.c
> +++ b/arch/x86/mach-voyager/voyager_smp.c
> @@ -132,7 +132,7 @@ static inline void send_CPI_allbutself(_
>  static inline void send_CPI_allbutself(__u8 cpi)
>  {
>  	__u8 cpu = smp_processor_id();
> -	__u32 mask = cpus_addr(cpu_online_map)[0] & ~(1 << cpu);
> +	__u32 mask = cpumask_bits(cpu_online_mask)[0] & ~(1 << cpu);
>  	send_CPI(mask, cpi);
>  }
>  
> @@ -207,7 +207,7 @@ static __u32 cpu_booted_map;
>  
>  /* the synchronize flag used to hold all secondary CPUs spinning in
>   * a tight loop until the boot sequence is ready for them */
> -static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
> +static unsigned long smp_commenced_mask;
>  
>  /* This is for the new dynamic CPU boot code */
>  
> @@ -357,7 +357,7 @@ void __init find_smp_config(void)
>  	/* initialize the CPU structures (moved from smp_boot_cpus) */
>  	for (i = 0; i < nr_cpu_ids; i++)
>  		cpu_irq_affinity[i] = ~0;
> -	cpu_online_map = cpumask_of_cpu(boot_cpu_id);
> +	init_cpu_online(cpumask_of(boot_cpu_id));
>  
>  	/* The boot CPU must be extended */
>  	voyager_extended_vic_processors = 1 << boot_cpu_id;
> @@ -471,18 +471,18 @@ static void __init start_secondary(void 
>  	 * permission to proceed.  Without this, the new per CPU stuff
>  	 * in the softirqs will fail */
>  	local_irq_disable();
> -	cpu_set(cpuid, cpu_callin_map);
> +	cpumask_set_cpu(cpuid, cpu_callin_mask);
>  
>  	/* signal that we're done */
>  	cpu_booted_map = 1;
>  
> -	while (!cpu_isset(cpuid, smp_commenced_mask))
> +	while (!test_bit(cpuid, &smp_commenced_mask))
>  		rep_nop();
>  	local_irq_enable();
>  
>  	local_flush_tlb();
>  
> -	cpu_set(cpuid, cpu_online_map);
> +	set_cpu_online(cpuid, true);
>  	wmb();
>  	cpu_idle();
>  }
> @@ -605,8 +605,8 @@ static void __init do_boot_cpu(__u8 cpu)
>  		printk("CPU%d: ", cpu);
>  		print_cpu_info(&cpu_data(cpu));
>  		wmb();
> -		cpu_set(cpu, cpu_callout_map);
> -		cpu_set(cpu, cpu_present_map);
> +		cpumask_set_cpu(cpu, cpu_callout_mask);
> +		set_cpu_present(cpu, true);
>  	} else {
>  		printk("CPU%d FAILED TO BOOT: ", cpu);
>  		if (*
> @@ -668,8 +668,8 @@ void __init smp_boot_cpus(void)
>  	/* enable our own CPIs */
>  	vic_enable_cpi();
>  
> -	cpu_set(boot_cpu_id, cpu_online_map);
> -	cpu_set(boot_cpu_id, cpu_callout_map);
> +	set_cpu_online(boot_cpu_id, true);
> +	cpumask_set_cpu(boot_cpu_id, cpu_callout_mask);
>  
>  	/* loop over all the extended VIC CPUs and boot them.  The
>  	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
> @@ -832,7 +832,7 @@ voyager_flush_tlb_others(unsigned long c
>  
>  	if (!cpumask)
>  		BUG();
> -	if ((cpumask & cpus_addr(cpu_online_map)[0]) != cpumask)
> +	if ((cpumask & cpumask_bits(cpu_online_mask)[0]) != cpumask)
>  		BUG();
>  	if (cpumask & (1 << smp_processor_id()))
>  		BUG();
> @@ -951,7 +951,7 @@ static void smp_stop_cpu_function(void *
>  static void smp_stop_cpu_function(void *dummy)
>  {
>  	VDEBUG(("VOYAGER SMP: CPU%d is STOPPING\n", smp_processor_id()));
> -	cpu_clear(smp_processor_id(), cpu_online_map);
> +	set_cpu_online(smp_processor_id(), false);
>  	local_irq_disable();
>  	for (;;)
>  		halt();
> @@ -1608,9 +1608,9 @@ void set_vic_irq_affinity(unsigned int i
>  	unsigned long irq_mask = 1 << irq;
>  	int cpu;
>  
> -	real_mask = cpus_addr(*mask)[0] & voyager_extended_vic_processors;
> +	real_mask = cpumask_bits(mask)[0] & voyager_extended_vic_processors;
>  
> -	if (cpus_addr(*mask)[0] == 0)
> +	if (cpumask_bits(mask)[0] == 0)
>  		/* can't have no CPUs to accept the interrupt -- extremely
>  		 * bad things will happen */
>  		return;
> @@ -1752,24 +1752,23 @@ static void __cpuinit voyager_smp_prepar
>  	init_gdt(smp_processor_id());
>  	switch_to_new_gdt();
>  
> -	cpu_online_map = cpumask_of_cpu(smp_processor_id());
> -	cpu_callout_map = cpumask_of_cpu(smp_processor_id());
> -	cpu_callin_map = CPU_MASK_NONE;
> -	cpu_present_map = cpumask_of_cpu(smp_processor_id());
> -
> +	init_cpu_online(cpumask_of(smp_processor_id()));
> +	cpumask_copy(cpu_callout_mask, cpumask_of(smp_processor_id()));
> +	cpumask_clear(cpu_callin_mask);
> +	init_cpu_present(cpumask_of(smp_processor_id()));
>  }
>  
>  static int __cpuinit voyager_cpu_up(unsigned int cpu)
>  {
>  	/* This only works at boot for x86.  See "rewrite" above. */
> -	if (cpu_isset(cpu, smp_commenced_mask))
> +	if (test_bit(cpu, &smp_commenced_mask))
>  		return -ENOSYS;
>  
>  	/* In case one didn't come up */
> -	if (!cpu_isset(cpu, cpu_callin_map))
> +	if (!cpumask_test_cpu(cpu, cpu_callin_mask))
>  		return -EIO;
>  	/* Unleash the CPU! */
> -	cpu_set(cpu, smp_commenced_mask);
> +	set_bit(cpu, &smp_commenced_mask);
>  	while (!cpu_online(cpu))
>  		mb();
>  	return 0;
> @@ -1788,7 +1787,7 @@ void __init smp_setup_processor_id(void)
>  
>  static void voyager_send_call_func(const struct cpumask *callmask)
>  {
> -	__u32 mask = cpus_addr(*callmask)[0] & ~(1 << smp_processor_id());
> +	__u32 mask = cpumask_bits(callmask)[0] & ~(1 << smp_processor_id());
>  	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
>  }
>  

