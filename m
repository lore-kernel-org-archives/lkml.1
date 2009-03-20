Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZCTBoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZCTBoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZCTBoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:44:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbZCTBoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:44:08 -0400
Message-ID: <49C2F4CC.4030301@kernel.org>
Date: Thu, 19 Mar 2009 18:43:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       mark.langsdorf@amd.com, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cpu: conform L3 Cache Index Disable to Linux
 standards
References: <tip-45ca863a40306ccc99c68d13421b6577240760ca@git.kernel.org>
In-Reply-To: <tip-45ca863a40306ccc99c68d13421b6577240760ca@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf wrote:
> Commit-ID:  45ca863a40306ccc99c68d13421b6577240760ca
> Gitweb:     http://git.kernel.org/tip/45ca863a40306ccc99c68d13421b6577240760ca
> Author:     Mark Langsdorf <mark.langsdorf@amd.com>
> AuthorDate: Tue, 17 Mar 2009 14:57:25 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 18 Mar 2009 13:46:12 -0700
> 
> x86, cpu: conform L3 Cache Index Disable to Linux standards
> 
> Impact: fix for future processors
> 
> Add ABI Documentation entry and fix some /sys directory formating
> issues with the L3 Cache Index Disable feature for future AMD
> processors.  Add a check to disable it for family 0x10 models
> that do not support it properly.  Correct the disable algorithm
> to reflect erratum 388.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> 
> ---
>  arch/x86/include/asm/k8.h             |    4 +
>  arch/x86/kernel/cpu/intel_cacheinfo.c |  180 ++++++++++++++-------------------
>  2 files changed, 82 insertions(+), 102 deletions(-)
> 
> diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
> index 54c8cc5..0d619c3 100644
> --- a/arch/x86/include/asm/k8.h
> +++ b/arch/x86/include/asm/k8.h
> @@ -6,7 +6,11 @@
>  extern struct pci_device_id k8_nb_ids[];
>  
>  extern int early_is_k8_nb(u32 value);
> +#ifdef CONFIG_K8_NB
>  extern struct pci_dev **k8_northbridges;
> +#else
> +struct pci_dev **k8_northbridges;
> +#endif
>  extern int num_k8_northbridges;
>  extern int cache_k8_northbridges(void);
>  extern void k8_flush_garts(void);
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index c471eb1..b728325 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c

looks strange, why have those k8 code in intel...c?

YH

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
> -#ifdef CONFIG_PCI
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
> +	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
> +		return;
> +
>  	this_leaf->can_disable = 1;
>  }
>  
> @@ -639,6 +640,68 @@ static ssize_t show_##file_name						\
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
> +	unsigned int scrubber = 0;
> +
> +	if (!this_leaf->can_disable)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (strict_strtoul(buf, 10, &val) < 0)
> +		return -EINVAL;
> +
> +	val |= 0xc0000000;
> +	pci_read_config_dword(dev, 0x58, &scrubber);
> +	scrubber &= ~0x0f800000;
> +	pci_write_config_dword(dev, 0x58, scrubber);
> +	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
> +	wbinvd();
> +	pci_write_config_dword(dev, 0x1BC + index * 4, val);
> +	return count;
> +}
> +
> +#define STORE_CACHE_DISABLE(index)					\
> +static ssize_t								\
> +store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
> +		 const char *buf, size_t count)			     	\
> +{									\
> +	return store_cache_disable(this_leaf, buf, count, index);	\
> +}
> +
> +SHOW_CACHE_DISABLE(0)
> +STORE_CACHE_DISABLE(0)
> +SHOW_CACHE_DISABLE(1)
> +STORE_CACHE_DISABLE(1)
> +
>  show_one_plus(level, eax.split.level, 0);
>  show_one_plus(coherency_line_size, ebx.split.coherency_line_size, 1);
>  show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
> @@ -696,98 +759,6 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
>  #define to_object(k)	container_of(k, struct _index_kobject, kobj)
>  #define to_attr(a)	container_of(a, struct _cache_attr, attr)
>  
> -#ifdef CONFIG_PCI
> -static struct pci_dev *get_k8_northbridge(int node)
> -{
> -	struct pci_dev *dev = NULL;
> -	int i;
> -
> -	for (i = 0; i <= node; i++) {
> -		do {
> -			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
> -			if (!dev)
> -				break;
> -		} while (!pci_match_id(&k8_nb_id[0], dev));
> -		if (!dev)
> -			break;
> -	}
> -	return dev;
> -}
> -#else
> -static struct pci_dev *get_k8_northbridge(int node)
> -{
> -	return NULL;
> -}
> -#endif
> -
> -static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
> -{
> -	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
> -	int node = cpu_to_node(cpumask_first(mask));
> -	struct pci_dev *dev = NULL;
> -	ssize_t ret = 0;
> -	int i;
> -
> -	if (!this_leaf->can_disable)
> -		return sprintf(buf, "Feature not enabled\n");
> -
> -	dev = get_k8_northbridge(node);
> -	if (!dev) {
> -		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
> -		return -EINVAL;
> -	}
> -
> -	for (i = 0; i < 2; i++) {
> -		unsigned int reg;
> -
> -		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
> -
> -		ret += sprintf(buf, "%sEntry: %d\n", buf, i);
> -		ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",  
> -			buf,
> -			reg & 0x80000000 ? "Disabled" : "Allowed",
> -			reg & 0x40000000 ? "Disabled" : "Allowed");
> -		ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
> -			buf, (reg & 0x30000) >> 16, reg & 0xfff);
> -	}
> -	return ret;
> -}
> -
> -static ssize_t
> -store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
> -		    size_t count)
> -{
> -	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
> -	int node = cpu_to_node(cpumask_first(mask));
> -	struct pci_dev *dev = NULL;
> -	unsigned int ret, index, val;
> -
> -	if (!this_leaf->can_disable)
> -		return 0;
> -
> -	if (strlen(buf) > 15)
> -		return -EINVAL;
> -
> -	ret = sscanf(buf, "%x %x", &index, &val);
> -	if (ret != 2)
> -		return -EINVAL;
> -	if (index > 1)
> -		return -EINVAL;
> -
> -	val |= 0xc0000000;
> -	dev = get_k8_northbridge(node);
> -	if (!dev) {
> -		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
> -		return -EINVAL;
> -	}
> -
> -	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
> -	wbinvd();
> -	pci_write_config_dword(dev, 0x1BC + index * 4, val);
> -
> -	return 1;
> -}
> -
>  struct _cache_attr {
>  	struct attribute attr;
>  	ssize_t (*show)(struct _cpuid4_info *, char *);
> @@ -808,7 +779,11 @@ define_one_ro(size);
>  define_one_ro(shared_cpu_map);
>  define_one_ro(shared_cpu_list);
>  
> -static struct _cache_attr cache_disable = __ATTR(cache_disable, 0644, show_cache_disable, store_cache_disable);
> +static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
> +		 show_cache_disable_0, store_cache_disable_0);
> +static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
> +		 show_cache_disable_1, store_cache_disable_1);
> +
>  
>  static struct attribute * default_attrs[] = {
>  	&type.attr,
> @@ -820,7 +795,8 @@ static struct attribute * default_attrs[] = {
>  	&size.attr,
>  	&shared_cpu_map.attr,
>  	&shared_cpu_list.attr,
> -	&cache_disable.attr,
> +	&cache_disable_0.attr,
> +	&cache_disable_1.attr,
>  	NULL
>  };
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

