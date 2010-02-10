Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0BJC2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 21:28:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:36939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab0BJC2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 21:28:12 -0500
Message-ID: <4B721965.2030108@kernel.org>
Date: Tue, 09 Feb 2010 18:26:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, apic: Don't use logical-flat mode when
 CPU hotplug may exceed 8 CPUs
References: <20100118201256.672679042@sbs-t61.sc.intel.com>	 <tip-418f727639cfc8f03068aae09f473c493c759b9b@git.kernel.org>	 <4B71ADB3.5010303@kernel.org> <1265767304.2833.19.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1265767304.2833.19.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 06:01 PM, Suresh Siddha wrote:
> On Tue, 2010-02-09 at 10:47 -0800, Yinghai Lu wrote:
>>>  #ifdef CONFIG_X86_32
>>> -	if (num_processors > 8) {
>>> +	if (num_possible_cpus() > 8) {
>>
>> for 32bit you can not use this function yet.
>> that only can be used after prefill_possible_map()
> 
> Yinghai, Agreed. How about the appended patch? I tested and it works.
> Peter wants a small quick fix for this issue (to resolve the boot issue
> reported in the virtualization guest context) so that we can queue it
> for .33 and .32 kernels (as some distributions will be based on these
> kernels).
> 
> Can you please Ack if it is ok?
> 
> thanks,
> suresh
> ---
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs
> 
> We need to fall back from logical-flat APIC mode to physical-flat mode
> when we have more than 8 CPUs.  However, in the presence of CPU
> hotplug(with bios listing not enabled but possible cpus as disabled cpus in
> MADT), we have to consider the number of possible CPUs rather than
> the number of current CPUs; otherwise we may cross the 8-CPU boundary
> when CPUs are added later.
> 
> 32bit apic code can use more cleanups (like the removal of vendor checks in
> 32bit default_setup_apic_routing()) and more unifications with 64bit code.
> Yinghai has some patches in works already. This patch addresses the boot issue
> that is reported in the virtualization guest context.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: <stable@kernel.org>
> ---
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 036d28a..0acbcdf 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -1185,9 +1185,6 @@ static void __init acpi_process_madt(void)
>  		if (!error) {
>  			acpi_lapic = 1;
>  
> -#ifdef CONFIG_X86_BIGSMP
> -			generic_bigsmp_probe();
> -#endif
>  			/*
>  			 * Parse MADT IO-APIC entries
>  			 */
> @@ -1197,8 +1194,6 @@ static void __init acpi_process_madt(void)
>  				acpi_ioapic = 1;
>  
>  				smp_found_config = 1;
> -				if (apic->setup_apic_routing)
> -					apic->setup_apic_routing();
>  			}
>  		}
>  		if (error == -EINVAL) {
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index a85f216..6e29b2a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1641,9 +1641,7 @@ int __init APIC_init_uniprocessor(void)
>  #endif
>  
>  	enable_IR_x2apic();
> -#ifdef CONFIG_X86_64
>  	default_setup_apic_routing();
> -#endif
>  
>  	verify_local_APIC();
>  	connect_bsp_APIC();
> @@ -1891,21 +1889,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
>  	if (apicid > max_physical_apicid)
>  		max_physical_apicid = apicid;
>  
> -#ifdef CONFIG_X86_32
> -	if (num_processors > 8) {
> -		switch (boot_cpu_data.x86_vendor) {
> -		case X86_VENDOR_INTEL:
> -			if (!APIC_XAPIC(version)) {
> -				def_to_bigsmp = 0;
> -				break;
> -			}
> -			/* If P4 and above fall through */
> -		case X86_VENDOR_AMD:
> -			def_to_bigsmp = 1;
> -		}
> -	}
> -#endif
> -
>  #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
>  	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
>  	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
> diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
> index 1a6559f..88e78ae 100644
> --- a/arch/x86/kernel/apic/probe_32.c
> +++ b/arch/x86/kernel/apic/probe_32.c
> @@ -54,6 +54,31 @@ late_initcall(print_ipi_mode);
>  
>  void default_setup_apic_routing(void)
>  {
> +	int version = apic_version[boot_cpu_physical_apicid];
> +
> +	if (num_possible_cpus() > 8) {
> +		switch (boot_cpu_data.x86_vendor) {
> +		case X86_VENDOR_INTEL:
> +			if (!APIC_XAPIC(version)) {
> +				def_to_bigsmp = 0;
> +				break;
> +			}
> +			/* If P4 and above fall through */
> +		case X86_VENDOR_AMD:
> +			def_to_bigsmp = 1;
> +		}
> +	}
> +
> +#ifdef CONFIG_X86_BIGSMP
> +	generic_bigsmp_probe();
> +#endif
> +
> +	if (apic->setup_apic_routing)
> +		apic->setup_apic_routing();

the main difference between this patch and
http://patchwork.kernel.org/patch/74525/

is moving apic->setup_apic_routing calling.

wonder if it will affect subarch other than logical flat and physical flat.

YH

> +}
> +
> +void setup_apic_flat_routing(void)
> +{
>  #ifdef CONFIG_X86_IO_APIC
>  	printk(KERN_INFO
>  		"Enabling APIC mode:  Flat.  Using %d I/O APICs\n",
> @@ -103,7 +128,7 @@ struct apic apic_default = {
>  	.init_apic_ldr			= default_init_apic_ldr,
>  
>  	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
> -	.setup_apic_routing		= default_setup_apic_routing,
> +	.setup_apic_routing		= setup_apic_flat_routing,
>  	.multi_timer_check		= NULL,
>  	.apicid_to_node			= default_apicid_to_node,
>  	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
> diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
> index 450fe20..83e9be4 100644
> --- a/arch/x86/kernel/apic/probe_64.c
> +++ b/arch/x86/kernel/apic/probe_64.c
> @@ -67,7 +67,7 @@ void __init default_setup_apic_routing(void)
>  	}
>  #endif
>  
> -	if (apic == &apic_flat && num_processors > 8)
> +	if (apic == &apic_flat && num_possible_cpus() > 8)
>  			apic = &apic_physflat;
>  
>  	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index 40b54ce..a2c1edd 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -359,13 +359,6 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
>  		x86_init.mpparse.mpc_record(1);
>  	}
>  
> -#ifdef CONFIG_X86_BIGSMP
> -	generic_bigsmp_probe();
> -#endif
> -
> -	if (apic->setup_apic_routing)
> -		apic->setup_apic_routing();
> -
>  	if (!num_processors)
>  		printk(KERN_ERR "MPTABLE: no processors registered!\n");
>  	return num_processors;
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index b2ebcba..c08829a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1087,9 +1087,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  	set_cpu_sibling_map(0);
>  
>  	enable_IR_x2apic();
> -#ifdef CONFIG_X86_64
>  	default_setup_apic_routing();
> -#endif
>  
>  	if (smp_sanity_check(max_cpus) < 0) {
>  		printk(KERN_INFO "SMP disabled\n");
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

