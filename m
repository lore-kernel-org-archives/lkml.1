Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYCYL7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYCYL7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYCYL6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:58:55 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.10]:26424 "EHLO
	mail2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYCYL6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:58:54 -0400
X-Greylist: delayed 1631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 07:58:54 EDT
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JYAAOB-04-G0D-01
Date: Tue, 25 Mar 2008 12:31:23 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of memory
Message-ID: <20080325113123.GL17986@amd.com>
References: <20080312353.598285931@firstfloor.org> <20080312025330.AC1961B41D1@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312025330.AC1961B41D1@basil.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Mar 2008 11:31:23.0213 (UTC) FILETIME=[C115B7D0:01C88E6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 03:53:30AM +0100, Andi Kleen wrote:
> 
> Intel recommends to not use large pages for the first 1MB 
> of the physical memory because there are fixed size MTRRs there
> which cause splitups in the TLBs.
> 
> On AMD doing so is also a good idea.

This should especially boost performance on 32 bit. Have you numbers for
that?

> The implementation is a little different between 32bit and 64bit.
> On 32bit I just taught the initial page table set up about this
> because it was very simple to do. This also has the advantage
> that the risk of a prefetch ever seeing the page even
> if it only exists for a short time is minimized.
> 
> On 64bit that is not quite possible, so use set_memory_4k() a little
> later (in check_bugs) instead.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/bugs_64.c |   12 ++++++++++++
>  arch/x86/mm/init_32.c     |    6 +++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/kernel/bugs_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/bugs_64.c
> +++ linux/arch/x86/kernel/bugs_64.c
> @@ -9,6 +9,7 @@
>  #include <asm/bugs.h>
>  #include <asm/processor.h>
>  #include <asm/mtrr.h>
> +#include <asm/cacheflush.h>
>  
>  void __init check_bugs(void)
>  {
> @@ -18,4 +19,15 @@ void __init check_bugs(void)
>  	print_cpu_info(&boot_cpu_data);
>  #endif
>  	alternative_instructions();
> +
> +	/*
> +	 * Make sure the first 2MB area is not mapped by huge pages
> +	 * There are typically fixed size MTRRs in there and overlapping
> +	 * MTRRs into large pages causes slow downs.
> +	 *
> +	 * Right now we don't do that with gbpages because there seems
> +	 * very little benefit for that case.
> +	 */
> +	if (!direct_gbpages)
> +		set_memory_4k((unsigned long)__va(0), 1);
>  }
> Index: linux/arch/x86/mm/init_32.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_32.c
> +++ linux/arch/x86/mm/init_32.c
> @@ -181,8 +181,13 @@ static void __init kernel_physical_mappi
>  			/*
>  			 * Map with big pages if possible, otherwise
>  			 * create normal page tables:
> +			 *
> +			 * Don't use a large page for the first 2/4MB of memory
> +			 * because there are often fixed size MTRRs in there
> +			 * and overlapping MTRRs into large pages can cause
> +			 * slowdowns.
>  			 */
> -			if (cpu_has_pse) {
> +			if (cpu_has_pse && !(pgd_idx == 0 && pmd_idx == 0)) {
>  				unsigned int addr2;
>  				pgprot_t prot = PAGE_KERNEL_LARGE;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

