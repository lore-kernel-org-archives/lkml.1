Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYDOGym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYDOGym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYDOGyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:54:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbYDOGyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:54:32 -0400
Date: Mon, 14 Apr 2008 23:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yhlu.kernel@gmail.com
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64/mm: check and print vmemmap allocation
 continuous
Message-Id: <20080414235348.a5ddffee.akpm@linux-foundation.org>
In-Reply-To: <200804120119.24868.yhlu.kernel@gmail.com>
References: <200804120119.24868.yhlu.kernel@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 01:19:24 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> 
> So for big system with a lot memory, don't print out too much, and easy found
> out if it is continuous
> 
> on 256G 8 sockets system will get
>  [ffffe20000000000-ffffe20002bfffff] PMD -> [ffff810001400000-ffff810003ffffff] on node 0
> [ffffe2001c700000-ffffe2001c7fffff] potential offnode page_structs
>  [ffffe20002c00000-ffffe2001c7fffff] PMD -> [ffff81000c000000-ffff8100255fffff] on node 0
> [ffffe20038700000-ffffe200387fffff] potential offnode page_structs
>  [ffffe2001c800000-ffffe200387fffff] PMD -> [ffff810820200000-ffff81083c1fffff] on node 1
>  [ffffe20040000000-ffffe2007fffffff] PUD ->ffff811027a00000 on node 2
>  [ffffe20038800000-ffffe2003fffffff] PMD -> [ffff811020200000-ffff8110279fffff] on node 2
> [ffffe20054700000-ffffe200547fffff] potential offnode page_structs
>  [ffffe20040000000-ffffe200547fffff] PMD -> [ffff811027c00000-ffff81103c3fffff] on node 2
> [ffffe20070700000-ffffe200707fffff] potential offnode page_structs
>  [ffffe20054800000-ffffe200707fffff] PMD -> [ffff811820200000-ffff81183c1fffff] on node 3
>  [ffffe20080000000-ffffe200bfffffff] PUD ->ffff81202fa00000 on node 4
>  [ffffe20070800000-ffffe2007fffffff] PMD -> [ffff812020200000-ffff81202f9fffff] on node 4
> [ffffe2008c700000-ffffe2008c7fffff] potential offnode page_structs
>  [ffffe20080000000-ffffe2008c7fffff] PMD -> [ffff81202fc00000-ffff81203c3fffff] on node 4
> [ffffe200a8700000-ffffe200a87fffff] potential offnode page_structs
>  [ffffe2008c800000-ffffe200a87fffff] PMD -> [ffff812820200000-ffff81283c1fffff] on node 5
>  [ffffe200c0000000-ffffe200ffffffff] PUD ->ffff813037a00000 on node 6
>  [ffffe200a8800000-ffffe200bfffffff] PMD -> [ffff813020200000-ffff8130379fffff] on node 6
> [ffffe200c4700000-ffffe200c47fffff] potential offnode page_structs
>  [ffffe200c0000000-ffffe200c47fffff] PMD -> [ffff813037c00000-ffff81303c3fffff] on node 6
>  [ffffe200c4800000-ffffe200e07fffff] PMD -> [ffff813820200000-ffff81383c1fffff] on node 7
> 
> instead of a long print out...
> 

I'll consider this an x86 patch, for the x86 tree.


> 
> Index: linux-2.6/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_64.c
> +++ linux-2.6/arch/x86/mm/init_64.c
> @@ -931,6 +931,10 @@ const char *arch_vma_name(struct vm_area
>  /*
>   * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
>   */
> +static long __meminitdata addr_start, addr_end;
> +static void __meminitdata *p_start, *p_end;
> +static int __meminitdata node_start;
> +
>  int __meminit
>  vmemmap_populate(struct page *start_page, unsigned long size, int node)
>  {
> @@ -965,12 +969,32 @@ vmemmap_populate(struct page *start_page
>  							PAGE_KERNEL_LARGE);
>  			set_pmd(pmd, __pmd(pte_val(entry)));
>  
> -			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
> -				addr, addr + PMD_SIZE - 1, p, node);
> +			/* check if we got continous */

"continuous".

In fact I'd phrase it "Check to see if we have contiguous blocks".

> +			if (p_end != p || node_start != node) {
> +				if (p_start)
> +					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
> +						addr_start, addr_end-1, p_start, p_end-1, node_start);
> +				addr_start = addr;
> +				node_start = node;
> +				p_start = p;
> +			}
> +			addr_end = addr + PMD_SIZE;
> +			p_end = p + PMD_SIZE;
>  		} else {
>  			vmemmap_verify((pte_t *)pmd, node, addr, next);
>  		}
>  	}
>  	return 0;
>  }
> +
> +void __meminit vmemmap_populate_print_last(void)

This definition

> +{
> +	if (p_start) {
> +		printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
> +			addr_start, addr_end-1, p_start, p_end-1, node_start);
> +		p_start = NULL;
> +		p_end = NULL;
> +		node_start = 0;
> +	}
> +}
>  #endif
> Index: linux-2.6/mm/sparse.c
> ===================================================================
> --- linux-2.6.orig/mm/sparse.c
> +++ linux-2.6/mm/sparse.c
> @@ -285,6 +285,9 @@ struct page __init *sparse_early_mem_map
>  	return NULL;
>  }
>  
> +void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)

And this definition

should match each other.  The way to do that is to put a declaration in a
header file which is included by both .c files, please.

> +{
> +}
>  /*
>   * Allocate the accumulated non-linear sections, allocate a mem_map
>   * for each and record the physical to section mapping.
> @@ -337,6 +340,8 @@ void __init sparse_init(void)
>  								usemap);
>  	}
>  
> +	vmemmap_populate_print_last();
> +
>  	free_bootmem(__pa(usemap_map), size);
>  }

