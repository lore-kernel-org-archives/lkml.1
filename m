Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab0BNODI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:03:08 -0500
Received: from mail-bw0-f216.google.com ([209.85.218.216]:56656 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab0BNODF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:03:05 -0500
Message-ID: <4B7801FA.9080203@petalogix.com>
Date: Sun, 14 Feb 2010 15:00:26 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, davem@davemloft.net,
       microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] of/flattree: Don't assume HAVE_LMB
References: <20100213154838.4767.83881.stgit@angua> <20100213160247.4767.74578.stgit@angua>
In-Reply-To: <20100213160247.4767.74578.stgit@angua>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> We don't always have lmb available, so make arches provide an
> early_init_dt_alloc_memory_arch() to handle the allocation of
> memory in the fdt code.
> 
> When we don't have lmb.h included, we need asm/page.h for __va.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
>  arch/microblaze/kernel/prom.c |    5 +++++
>  arch/powerpc/kernel/prom.c    |    5 +++++
>  drivers/of/fdt.c              |    9 ++++++---
>  include/linux/of_fdt.h        |    1 +
>  4 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
> index 050b799..a7dcaf0 100644
> --- a/arch/microblaze/kernel/prom.c
> +++ b/arch/microblaze/kernel/prom.c
> @@ -55,6 +55,11 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  	lmb_add(base, size);
>  }
>  
> +u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +	return lmb_alloc(size, align);
> +}
> +
>  #ifdef CONFIG_EARLY_PRINTK
>  /* MS this is Microblaze specifig function */
>  static int __init early_init_dt_scan_serial(unsigned long node,
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 43c78d7..5bbbdb2 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -510,6 +510,11 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  	memstart_addr = min((u64)memstart_addr, base);
>  }
>  
> +u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +	return lmb_alloc(size, align);
> +}
> +
>  #ifdef CONFIG_BLK_DEV_INITRD
>  void __init early_init_dt_setup_initrd_arch(unsigned long start,
>  		unsigned long end)
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index b51f797..406757a 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -10,16 +10,18 @@
>   */
>  
>  #include <linux/kernel.h>
> -#include <linux/lmb.h>
>  #include <linux/initrd.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> -
> +#include <linux/string.h>
> +#include <linux/errno.h>
>  
>  #ifdef CONFIG_PPC
>  #include <asm/machdep.h>
>  #endif /* CONFIG_PPC */

It is not part of your patch but I think that will be great completely 
remove this CONFIG_PPC part from generic OF file.
Would it be possible to include your asm/machdep.h through asm/page.h or 
any other file?

Michal

>  
> +#include <asm/page.h>
> +
>  int __initdata dt_root_addr_cells;
>  int __initdata dt_root_size_cells;
>  
> @@ -560,7 +562,8 @@ void __init unflatten_device_tree(void)
>  	pr_debug("  size is %lx, allocating...\n", size);
>  
>  	/* Allocate memory for the expanded device tree */
> -	mem = lmb_alloc(size + 4, __alignof__(struct device_node));
> +	mem = early_init_dt_alloc_memory_arch(size + 4,
> +			__alignof__(struct device_node));
>  	mem = (unsigned long) __va(mem);
>  
>  	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index c9cb8a7..a1ca92c 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -78,6 +78,7 @@ extern void early_init_dt_check_for_initrd(unsigned long node);
>  extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
>  				     int depth, void *data);
>  extern void early_init_dt_add_memory_arch(u64 base, u64 size);
> +extern u64 early_init_dt_alloc_memory_arch(u64 size, u64 align);
>  extern u64 dt_mem_next_cell(int s, __be32 **cellp);
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
