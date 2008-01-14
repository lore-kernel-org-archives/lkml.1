Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYANWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYANWwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYANWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:52:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23290 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYANWwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:52:08 -0500
Date: Mon, 14 Jan 2008 14:50:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [27/31] CPA: Change comments of external interfaces to
 kerneldoc format
Message-Id: <20080114145054.1f7fa01c.randy.dunlap@oracle.com>
In-Reply-To: <20080114221700.7252314F83@wotan.suse.de>
References: <200801141116.534682000@suse.de>
	<20080114221700.7252314F83@wotan.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 23:17:00 +0100 (CET) Andi Kleen wrote:

> 
> And clarify description a bit.
> 
> Only for 64bit, but the interfaces are identical for 32bit and kerneldoc should
> merge them (?) 

I doubt that kernel-doc will merge them.

Normally we just import (like with !I, !E, !F, etc.) one file that
contains the kernel-doc API notations.
Would that work for this case?


> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  Documentation/DocBook/kernel-api.tmpl |    8 +++++
>  arch/x86/mm/pageattr_64.c             |   46 +++++++++++++++++++++++++---------
>  2 files changed, 42 insertions(+), 12 deletions(-)
> 
> Index: linux/arch/x86/mm/pageattr_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pageattr_64.c
> +++ linux/arch/x86/mm/pageattr_64.c
> @@ -269,19 +269,19 @@ __change_page_attr(unsigned long address
>  	return 0;
>  } 
>  
> -/*
> - * Change the page attributes of an page in the linear mapping.
> - *
> - * This should be used when a page is mapped with a different caching policy
> - * than write-back somewhere - some CPUs do not like it when mappings with
> - * different caching policies exist. This changes the page attributes of the
> - * in kernel linear mapping too.
> +/**
> + * change_page_attr_addr - Change page table attributes in linear mapping
> + * @address: Virtual address in linear mapping.
> + * @numpages: Number of pages to change
> + * @prot:    New page table attribute (PAGE_*)
>   * 
> - * The caller needs to ensure that there are no conflicting mappings elsewhere.
> - * This function only deals with the kernel linear map.
> - * 
> - * Caller must call global_flush_tlb() after this.
> + * Change page attributes of a page in the direct mapping. This is a variant
> + * of change_page_attr() that also works on memory holes that do not have
> + * mem_map entry (pfn_valid() is false).
> + *
> + * See change_page_attr() documentation for more details.
>   */
> +
>  int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
>  {
>  	int err = 0, kernel_map = 0;
> @@ -318,13 +318,35 @@ int change_page_attr_addr(unsigned long 
>  	return err;
>  }
>  
> -/* Don't call this for MMIO areas that may not have a mem_map entry */
> +/**
> + * change_page_attr - Change page table attributes in the linear mapping.
> + * @page: First page to change
> + * @numpages: Number of pages to change
> + * @prot: New protection/caching type (PAGE_*)
> + *
> + * Returns 0 on success, otherwise a negated errno.
> + *
> + * This should be used when a page is mapped with a different caching policy
> + * than write-back somewhere - some CPUs do not like it when mappings with
> + * different caching policies exist. This changes the page attributes of the
> + * in kernel linear mapping too.
> + *
> + * Caller must call global_flush_tlb() later to make the changes active.
> + *
> + * The caller needs to ensure that there are no conflicting mappings elsewhere
> + * (e.g. in user space) * This function only deals with the kernel linear map.
> + *
> + * For MMIO areas without mem_map use change_page_attr_addr() instead.
> + */
>  int change_page_attr(struct page *page, int numpages, pgprot_t prot)
>  {
>  	unsigned long addr = (unsigned long)page_address(page);
>  	return change_page_attr_addr(addr, numpages, prot);
>  }
>  
> +/**
> + * global_flush_tlb - Flush linear mappings changed by change_page_attr()
> + */
>  void global_flush_tlb(void)
>  { 
>  	struct page *pg, *next;
> Index: linux/Documentation/DocBook/kernel-api.tmpl
> ===================================================================
> --- linux.orig/Documentation/DocBook/kernel-api.tmpl
> +++ linux/Documentation/DocBook/kernel-api.tmpl
> @@ -726,4 +726,12 @@ X!Idrivers/video/console/fonts.c
>  !Ffs/pipe.c
>    </chapter>
>  
> +  <chapter id="pageattr">
> +	<title>Kernel direct mapping paging attributes</title>
> +  <para>
> +	Changing the paging attributes of kernel direct mapping pages
> +	on x86.
> +  </para>
> +!Farch/x86/mm/pageattr_64.c
> +  </chapter>
>  </book>
> --

---
~Randy
