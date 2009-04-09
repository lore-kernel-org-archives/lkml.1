Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbZDIJsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbZDIJsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761815AbZDIJsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:48:41 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17763 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762459AbZDIJsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:48:40 -0400
X-BigFish: VPS-27(zz1432R98dR1805M936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KHTV8K-02-GK2-01
Date: Thu, 9 Apr 2009 11:48:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       eric@lammerts.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH][retry 6] Conform L3 Cache Index Disable to Linux
	Standards
Message-ID: <20090409094821.GA19712@alberich.amd.com>
References: <200903171457.25582.mark.langsdorf@amd.com> <200904081602.34320.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200904081602.34320.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 09:48:22.0497 (UTC) FILETIME=[52104D10:01C9B8F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 04:02:34PM -0500, Mark Langsdorf wrote:
> commit eb40831ca29a89f056f8c6128c8b36d3691f6698
> Author: Mark Langsdorf <mlangsdo@acernow.amd.com>
> Date:   Wed Apr 8 15:48:45 2009 -0500
> 
>     Add ABI Documentation entry and fix some /sys directory formating
>     issues with the L3 Cache Index Disable feature for future AMD
>     processors.  Add a check to disable it for family 0x10 models
>     that do not support it yet.
>     
>     Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

I feel uncomfortable with this patch (and the previous ones).
The patch addresses issues with the current Linux code but introduces
new ones.

I suggest to revert last two patches on tip/x86/cpu
and to split Mark's last patch into several pieces.
(BTW, i'll do this in any case asap).

This would really help to understand the code changes
and to ease review and further adaptions of this code.

> diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
> index 54c8cc5..ebd9390 100644
> --- a/arch/x86/include/asm/k8.h
> +++ b/arch/x86/include/asm/k8.h
> @@ -12,4 +12,13 @@ extern int cache_k8_northbridges(void);
>  extern void k8_flush_garts(void);
>  extern int k8_scan_nodes(unsigned long start, unsigned long end);
>  
> +static inline struct pci_dev *get_k8_northbridge(int node)
> +{
> +#ifdef CONFIG_K8_NB
> +	return k8_northbridges[node];
> +#else
> +	return NULL;
> +#endif
> +}

IMHO a macro would suffice to return either k8_northbridges[node]
or NULL. And num_k8_northbridges should be checked, no?

>  #endif /* _ASM_X86_K8_H */
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 483eda9..453a6e3 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -639,6 +640,70 @@ static ssize_t show_##file_name						\
>  	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
>  }
>  
> +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
> +		 unsigned int index)
> +{
> +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> +	int node = cpu_to_node(cpu);
> +	struct pci_dev *dev = get_k8_northbridge(node);
> +	unsigned int reg = 0;
> +
> +	if (!this_leaf->can_disable)
> +		return -EINVAL;
> +
> +	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);

Do I miss something, or why is there no check for dev==NULL?  IMHO
this will cause an Oops when dereferencing dev->bus in
pci_read_config_dword in case of "ifndef CONFIG_K8_NB".

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
> +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> +	int node = cpu_to_node(cpu);
> +	struct pci_dev *dev = get_k8_northbridge(node);
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

Missing check for dev==NULL and potential Oops, no?

> +	scrubber &= ~0x0f800000;
> +	pci_write_config_dword(dev, 0x58, scrubber);

This adapts L3 scrub rate but accesses reserved bits.
Perhaps you meant to zero out bits 24-28 which would
mean to use

     scrubber &= ~0x1f000000;

(... but maybe I need some more coffee to do the bit fiddling ... ;-)


Regards,
Andreas


