Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820Ab0BZAuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:50:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42280 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934755Ab0BZAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:50:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 09:46:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       yinghai@kernel.org
Subject: Re: [RFT/PATCH] x86: Unify kernel_physical_mapping_init() API
Message-Id: <20100226094639.0a106466.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002241703570.1180@melkki.cs.helsinki.fi>
References: <alpine.DEB.2.00.1002241703570.1180@melkki.cs.helsinki.fi>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 17:04:47 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch changes the 32-bit version of kernel_physical_mapping_init() to
> return the last mapped address like the 64-bit one so that we can unify the
> call-site in init_memory_mapping().
> 

I'm sorry if I can't track the logic correctly..


> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> Note: I have only tested this on VirtualBox which is why I tagged the patch as
> RFT.
> 
>   arch/x86/mm/init.c    |    7 -------
>   arch/x86/mm/init_32.c |    8 +++++---
>   2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index d406c52..e71c5cb 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -266,16 +266,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>   	if (!after_bootmem)
>   		find_early_table_space(end, use_pse, use_gbpages);
> 
> -#ifdef CONFIG_X86_32
> -	for (i = 0; i < nr_range; i++)
> -		kernel_physical_mapping_init(mr[i].start, mr[i].end,
> -					     mr[i].page_size_mask);
> -	ret = end;
> -#else /* CONFIG_X86_64 */
>   	for (i = 0; i < nr_range; i++)
>   		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
>   						   mr[i].page_size_mask);
> -#endif
> 
>   #ifdef CONFIG_X86_32
>   	early_ioremap_page_table_range_init();
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 9a0c258..2226f2c 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -241,6 +241,7 @@ kernel_physical_mapping_init(unsigned long start,
>   			     unsigned long page_size_mask)
>   {
>   	int use_pse = page_size_mask == (1<<PG_LEVEL_2M);
> +	unsigned long last_map_addr = end;
>   	unsigned long start_pfn, end_pfn;
>   	pgd_t *pgd_base = swapper_pg_dir;
>   	int pgd_idx, pmd_idx, pte_ofs;
> @@ -341,9 +342,10 @@ repeat:
>   					prot = PAGE_KERNEL_EXEC;
> 
>   				pages_4k++;
> -				if (mapping_iter == 1)
> +				if (mapping_iter == 1) {
>   					set_pte(pte, pfn_pte(pfn, init_prot));
> -				else
> +					last_map_addr = (pfn << PAGE_SHIFT) + PAGE_SIZE;
> +				} else
>   					set_pte(pte, pfn_pte(pfn, prot));
>   			}
>   		}

Don't we need to update last_map_addr after pages_2m++; ?

And...from the logic,
  unsigned long last_map_addr = end;
seems to be always true.

So, just returning "end" is not good ?

Thanks,
-Kame

> @@ -368,7 +370,7 @@ repeat:
>   		mapping_iter = 2;
>   		goto repeat;
>   	}
> -	return 0;
> +	return last_map_addr;
>   }
> 
>   pte_t *kmap_pte;
> -- 
> 1.5.6.4
> 
> 

