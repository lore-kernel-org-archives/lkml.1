Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470Ab0ALIH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0ALIH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794Ab0ALIH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:07:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43546 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0ALIH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:07:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 17:04:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Zheng, Shaohui" <shaohui.zheng@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [ RESEND PATCH v3] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel
Message-Id: <20100112170433.394be31b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <DA586906BA1FFC4384FCFD6429ECE860316C0133@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE860316C0133@shzsmsx502.ccr.corp.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 15:45:54 +0800
"Zheng, Shaohui" <shaohui.zheng@intel.com> wrote:

> Resend the v3 patch after reviewed by KAMEZAWA Hiroyuki. We still keep the 
> Old e820map, update variable max_pfn, max_low_pfn and high_memory only. 
> It is dependent on Fenguang's page_is_ram patch.
> 
> Memory-Hotplug: Fix the bug on interface /dev/mem for 64-bit kernel
> 
> The new added memory can not be access by interface /dev/mem, because we do not
>  update the variable high_memory, max_pfn and max_low_pfn.
> 
> Memory hotplug still has critical issues for 32-bit kernel, and it is more 
> important for 64-bit kernel, we fix it on 64-bit first. We add a function 
> update_end_of_memory_vars in file arch/x86/mm/init.c to update these variables.
> 
> CC: Andi Kleen <ak@linux.intel.com>
> CC: Li Haicheng <haicheng.li@intel.com>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>

3 points...
1. I think this patch cannot be compiled in archs other than x86. Right ?
   IOW, please add static inline dummy...

2. pgdat->[start,end], totalram_pages etc...are updated at memory hotplug.
   Please place the hook nearby them.

3. I recommend you yo use memory hotplug notifier.
   If it's allowed, it will be cleaner.
   It seems there are no strict ordering to update parameters this patch touches.

Thanks,
-Kame





> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index d406c52..b6a85cc 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -1,6 +1,7 @@
>  #include <linux/initrd.h>
>  #include <linux/ioport.h>
>  #include <linux/swap.h>
> +#include <linux/bootmem.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/e820.h>
> @@ -386,3 +387,24 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  	free_init_pages("initrd memory", start, end);
>  }
>  #endif
> +
> +/**
> + * After memory hotplug, the variable max_pfn, max_low_pfn and high_memory will
> + * be affected, it will be updated in this function. Memory hotplug still has
> + * critical issues on 32-bit kennel, it was more important on 64-bit kernel,
> + * so we update the variables for 64-bit kernel first, fix me in future for
> + * 32-bit kenrel.
> + */
> +void __meminit __attribute__((weak)) update_end_of_memory_vars(u64 start,
> +		u64 size)
> +{
> +#ifdef CONFIG_X86_64
> +	unsigned long start_pfn = start >> PAGE_SHIFT;
> +	unsigned long end_pfn = PFN_UP(start + size);
> +
> +	if (end_pfn > max_pfn) {
> +		max_low_pfn = max_pfn = end_pfn;
> +		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> +	}
> +#endif /* CONFIG_X86_64 */
> +}
> diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
> index b10ec49..84533a5 100644
> --- a/include/linux/bootmem.h
> +++ b/include/linux/bootmem.h
> @@ -13,6 +13,7 @@
>  
>  extern unsigned long max_low_pfn;
>  extern unsigned long min_low_pfn;
> +extern void update_end_of_memory_vars(u64 start, u64 size);
>  
>  /*
>   * highest page
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 030ce8a..3e94b23 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -523,6 +523,9 @@ int __ref add_memory(int nid, u64 start, u64 size)
>  		BUG_ON(ret);
>  	}
>  
> +	/* update max_pfn, max_low_pfn and high_memory */
> +	update_end_of_memory_vars(start, size);
> +
>  	goto out;
>  
>  error:
> 
> Thanks & Regards,
> Shaohui
> 
> 
> 

