Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZCKIzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZCKIzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZCKIyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:54:37 -0400
Received: from cmpxchg.org ([85.214.51.133]:34331 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbZCKIyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:54:35 -0400
Date: Wed, 11 Mar 2009 09:54:07 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eric@lammerts.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][retry 3] Conform L3 Cache Index Disable to Linux standards
Message-ID: <20090311085407.GA1783@cmpxchg.org>
References: <200903101541.45739.mark.langsdorf@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903101541.45739.mark.langsdorf@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:41:45PM -0500, Mark Langsdorf wrote:
> 
>     Add ABI Documentation entry and fix some /sys directory formating
>     issues with the L3 Cache Index Disable feature for future AMD
>     processors.  Add a check to disable it for family 0x10 models
>     that do not support it yet.
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-cache_disable
> new file mode 100644
> index 0000000..c7d9174
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-cache_disable
> @@ -0,0 +1,18 @@
> +What:	    /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
> +Date:	    August 2008
> +KernelVersion:  2.6.27
> +Contact:	 mark.langsdorf@amd.com
> +Description:    These files exist in every cpu's cache index directories.
> +		 There are currently 2 cache_disable_# files in each
> +		 directory.  Reading from these files on a supported
> +		 processor will return that cache disable index value
> +		 for that processor and node.  Writing to one of these
> +		 files will cause the specificed cache index to be disabled.
> +
> +		 Currently, only AMD Family 10h Processors support cache index
> +		 disable, and only for their L3 caches.  See the BIOS and
> +		 Kernel Developer's Guide at
> +		 http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
> +		 for formatting information and other details on the
> +		 cache index disable.
> +Users:	   joachim.deguara@amd.com
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 72c65bc..2547807 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -81,7 +81,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
>  
>  obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
>  
> -obj-$(CONFIG_K8_NB)		+= k8.o
> +obj-y				+= k8.o

This affects all configurations that don't have a k8 northbridge as
well:

   text    data     bss     dec     hex filename
3277392  330356  327680 3935428  3c0cc4 vmlinux
   text    data     bss     dec     hex filename
3277891  330452  327680 3936023  3c0f17 vmlinux.with.k8.c

Please consider leaving that conditional compilation as is and define
dummy accessors for when this code is disabled.

>  obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
>  obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
>  obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 8e6ce2c..5ecac89 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -18,6 +18,9 @@
>  #include <asm/processor.h>
>  #include <asm/smp.h>
>  
> +#include <linux/pci.h>
> +#include <asm/k8.h>
> +
>  #define LVL_1_INST	1
>  #define LVL_1_DATA	2
>  #define LVL_2		3
> @@ -159,14 +162,6 @@ struct _cpuid4_info_regs {
>  	unsigned long can_disable;
>  };
>  
> -#if defined(CONFIG_PCI) && defined(CONFIG_SYSFS)
> -static struct pci_device_id k8_nb_id[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
> -	{}
> -};
> -#endif
> -
>  unsigned short			num_cache_leaves;
>  
>  /* AMD doesn't have CPUID4. Emulate it here to report the same
> @@ -291,6 +286,12 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
>  {
>  	if (index < 3)
>  		return;
> +	if (boot_cpu_data.x86 == 0x11)
> +		return;
> +
> +	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x15))
> +		return;
> +
>  	this_leaf->can_disable = 1;
>  }
>  
> @@ -639,6 +640,64 @@ static ssize_t show_##file_name						\
>  	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
>  }
>  
> +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
> +		 unsigned int index)
> +{
> +	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +	struct pci_dev *dev = k8_northbridges[node];
> +	unsigned int reg = 0;
> +
> +	if (!this_leaf->can_disable)
> +		return -EINVAL;
> +
> +	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
> +	return sprintf(buf, "%x\n", reg);
> +}
> +
> +#define SHOW_CACHE_DISABLE(index)					\
> +static ssize_t								\
> +show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
> +{									\
> +	return show_cache_disable(this_leaf, buf, index);		\
> +}
> +
> +static ssize_t
> +store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
> +		 size_t count, unsigned int index)
> +{
> +	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +	struct pci_dev *dev = k8_northbridges[node];
> +	unsigned long val = 0;
> +
> +	if (!this_leaf->can_disable)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;

This means a user that is never allowed to write sometimes gets an
'Invalid argument' instead of the 'Permission denied'.  Perhaps it's
better to do that permission check first?

	Hannes
