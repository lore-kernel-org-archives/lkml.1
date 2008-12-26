Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYLZA7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYLZA7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 19:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYLZA7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 19:59:36 -0500
Received: from ozlabs.org ([203.10.76.45]:60051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYLZA7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 19:59:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18772.11376.339295.42622@cargo.ozlabs.ibm.com>
Date: Fri, 26 Dec 2008 11:59:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chandru <chandru@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
In-Reply-To: <20081224233536.b067c9da.akpm@linux-foundation.org>
References: <200812241325.49404.chandru@in.ibm.com>
	<20081224233536.b067c9da.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Wed, 24 Dec 2008 13:25:49 +0530 Chandru <chandru@in.ibm.com> wrote:
> 
> > On a ppc machine booting linux-2.6.28-rc9 with crashkernel=256M@32M boot 
> > parameter causes the kernel to panic while booting. __Following are the console 
> > messages...
> 
> - Please put [patch] in the Subject: line of patches
> 
> - Please choose a suitable title, as per
>   Documentation/SubmittingPatches, section 15.
> 
> - Please cc suitable mailing lists and maintainers on bug reports and
>   on patches.

Dave Hansen was working on this code recently, and this looks a bit
similar to some changes he was making.  Dave, what's your opinion on
this patch?

Paul.

> From: Chandru <chandru@in.ibm.com>
> 
> When booted with crashkernel=224M@32M or any memory size less than this,
> the system boots properly.  The following was the observation..  The
> system comes up with two nodes (0-256M and 256M-4GB).  _The crashkernel
> memory reservation spans across these two nodes.  _The
> mark_reserved_regions_for_nid() in arch/powerpc/mm/numa.c resizes the
> reserved part of the memory within it as:
> 
> _ _ _ _ _ _ if (end_pfn > node_ar.end_pfn)
> _ _ _ _ _ _ _ _ reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
> _ _ _ _ _ _ _ _ _ _ - (start_pfn << PAGE_SHIFT);
> 
> 
> but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of end 
> 
> _ _ end = PFN_UP(physaddr + size);
> 
> This causes end to get a value past the last page in the 0-256M node. 
> _Again when reserve_bootmem_node() returns,
> _mark_reserved_regions_for_nid() loops around to set the rest of the
> crashkernel memory in the next node as reserved.  _ It references
> NODE_DATA(node_ar.nid) and this causes another 'Oops: kernel access of bad
> area' problem.  The following changes made the system to boot with any
> amount of crashkernel memory size.
> 
> Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/powerpc/mm/numa.c |    7 ++++---
>  mm/bootmem.c           |    4 ++++
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff -puN arch/powerpc/mm/numa.c~2628-rc9-panics-with-crashkernel=256m-while-booting arch/powerpc/mm/numa.c
> --- a/arch/powerpc/mm/numa.c~2628-rc9-panics-with-crashkernel=256m-while-booting
> +++ a/arch/powerpc/mm/numa.c
> @@ -995,10 +995,11 @@ void __init do_init_bootmem(void)
>  				  start_pfn, end_pfn);
>  
>  		free_bootmem_with_active_regions(nid, end_pfn);
> +	}
> +
> +	for_each_online_node(nid) {
>  		/*
> -		 * Be very careful about moving this around.  Future
> -		 * calls to careful_allocation() depend on this getting
> -		 * done correctly.
> +		 * Be very careful about moving this around.
>  		 */
>  		mark_reserved_regions_for_nid(nid);
>  		sparse_memory_present_with_active_regions(nid);
> diff -puN mm/bootmem.c~2628-rc9-panics-with-crashkernel=256m-while-booting mm/bootmem.c
> --- a/mm/bootmem.c~2628-rc9-panics-with-crashkernel=256m-while-booting
> +++ a/mm/bootmem.c
> @@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
>  				 unsigned long size, int flags)
>  {
>  	unsigned long start, end;
> +	bootmem_data_t *bdata = pgdat->bdata;
>  
>  	start = PFN_DOWN(physaddr);
>  	end = PFN_UP(physaddr + size);
>  
> +	if (end > bdata->node_low_pfn)
> +		end = bdata->node_low_pfn;
> +
>  	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
>  }
>  
> _
