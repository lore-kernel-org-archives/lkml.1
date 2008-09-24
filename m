Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYIXORE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYIXORE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYIXOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:16:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:8906 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:16:53 -0400
X-BigFish: VPS-28(zz1432R98dR1805M936fOzzzz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7PEBM-04-VA0-01
Date: Wed, 24 Sep 2008 16:16:16 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Yan Li <elliot.li.tech@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message when running as VMware guest
Message-ID: <20080924141616.GV24392@amd.com>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 24 Sep 2008 14:16:17.0024 (UTC) FILETIME=[1BD9B800:01C91E50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 08:24:37PM +0800, Yan Li wrote:
> Since the mtrr empty was detected very early before we can use DMI or
> PCI to check whether we are running as a VMware guest or not, we now
> only print an info there. Warning will only be issued later when we
> are sure that we are not running as a VMware guest.
> 
> mtrr_trim_uncached_memory() is modified to return meaningful codes for
> later warning decision.

A lot of code if #ifdef'ed to vmware. Can you hide this into a header
file? This way its not very clean code I think.

> Signed-off-by: Yan Li <elliot.li.tech@gmail.com>
> ---
>  arch/x86/kernel/cpu/mtrr/main.c |   16 +++++++++++++++-
>  arch/x86/kernel/setup.c         |   27 ++++++++++++++++++++++++++-
>  include/asm-x86/mtrr.h          |    2 ++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index b117d7f..95d1cc0 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -1453,6 +1453,11 @@ static u64 __init real_trim_memory(unsigned long start_pfn,
>   * all of the memory the kernel is intending to use. If not, it'll trim any
>   * memory off the end by adjusting end_pfn, removing it from the kernel's
>   * allocation pools, warning the user with an obnoxious message.
> + *
> + * Return code:
> + * EMTRR_ALL_BLANK (-1):  not trimmed due to CPU MTRRs all blank
> + *                    0:  not trimmed due to other reasons
> + *                    1:  trimmed successfully
>   */
>  int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
>  {
> @@ -1494,11 +1499,20 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
>  			highest_pfn = base + size;
>  	}
>  
> -	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
> +	/* kvm/qemu/VMware doesn't have mtrr set right, don't trim them all */
>  	if (!highest_pfn) {
> +#ifdef CONFIG_VMWARE_GUEST_DETECT
> +		/* the "mtrr all blank" warning will be deferred until
> +		 * after DMI scanning and we know the machine is not a
> +		 * VMware guest
> +		 */
> +		printk(KERN_INFO "CPU MTRRs all blank\n");
> +		return EMTRR_ALL_BLANK;
> +#else
>  		WARN(!kvm_para_available(), KERN_WARNING
>  				"WARNING: strange, CPU MTRRs all blank?\n");
>  		return 0;
> +#endif

Can we move the WARN after the DMI scanning for all cases? This will
save this #ifdef and is a cleaner approach imho.

>  	}
>  
>  	/* check entries number */
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 9838f25..4cbec10 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -102,6 +102,7 @@
>  #include <asm/percpu.h>
>  #include <asm/topology.h>
>  #include <asm/apicdef.h>
> +#include <asm/vmware.h>
>  #ifdef CONFIG_X86_64
>  #include <asm/numa_64.h>
>  #endif
> @@ -593,6 +594,13 @@ struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
>  
>  void __init setup_arch(char **cmdline_p)
>  {
> +#ifdef CONFIG_VMWARE_GUEST_DETECT
> +	/* the "mtrr all blank" warning will be deferred until after
> +	 * DMI scanning and we know the machine is not a VMware guest
> +	 */
> +	int cpu_mtrr_all_blank_later_warning = 0;
> +#endif
> +
>  #ifdef CONFIG_X86_32
>  	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
>  	visws_early_detect();
> @@ -733,8 +741,16 @@ void __init setup_arch(char **cmdline_p)
>  	early_reserve_e820_mpc_new();
>  	/* update e820 for memory not covered by WB MTRRs */
>  	mtrr_bp_init();
> -	if (mtrr_trim_uncached_memory(max_pfn))
> +	switch (mtrr_trim_uncached_memory(max_pfn)) {
> +	case 1:
>  		max_pfn = e820_end_of_ram_pfn();
> +		break;
> +#ifdef CONFIG_VMWARE_GUEST_DETECT
> +	case EMTRR_ALL_BLANK:
> +		cpu_mtrr_all_blank_later_warning = 1;
> +		break;
> +#endif
> +	}
>  
>  #ifdef CONFIG_X86_32
>  	/* max_low_pfn get updated here */
> @@ -783,6 +799,15 @@ void __init setup_arch(char **cmdline_p)
>  
>  	dmi_scan_machine();
>  
> +#ifdef CONFIG_VMWARE_GUEST_DETECT
> +	if (cpu_mtrr_all_blank_later_warning) {
> +		WARN(!(kvm_para_available() || (is_vmware_guest())),
> +		     KERN_WARNING
> +		     "WARNING: strange, CPU MTRRs all blank? "
> +		     "Deferred from mtrr_trim_uncached_memory()\n");
> +	}
> +#endif
> +
>  	io_delay_init();
>  
>  	/*
> diff --git a/include/asm-x86/mtrr.h b/include/asm-x86/mtrr.h
> index a69a01a..b6d8fcb 100644
> --- a/include/asm-x86/mtrr.h
> +++ b/include/asm-x86/mtrr.h
> @@ -26,6 +26,8 @@
>  #include <linux/ioctl.h>
>  #include <linux/errno.h>
>  
> +#define	EMTRR_ALL_BLANK (-1)
> +
>  #define	MTRR_IOCTL_BASE	'M'
>  
>  struct mtrr_sentry {
> -- 
> 1.5.4.3
> 
> 
> -- 
> Li, Yan
> 
> "Everything that is really great and inspiring is created by the
> individual who can labor in freedom."
>               - Albert Einstein, in Out of My Later Years (1950)
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

