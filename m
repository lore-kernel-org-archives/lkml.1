Return-Path: <linux-kernel-owner+w=401wt.eu-S1765606AbXLNDwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765606AbXLNDwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbXLNDwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:52:33 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36353 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbXLNDwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:52:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
References: <20071213235543.568682000@intel.com>
	<20071213235711.464325000@intel.com>
Date: Thu, 13 Dec 2007 20:48:45 -0700
In-Reply-To: <20071213235711.464325000@intel.com> (venkatesh pallipadi's
	message of "Thu, 13 Dec 2007 15:55:45 -0800")
Message-ID: <m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:

> Originally based on a patch from Eric Biederman, but heavily changed.
>
> Forward port of pat-base.patch to x86 tree, with a bug fix.
> Code was using 'PCD|PWT' i.e., PAT3 for WC mapping. So set the WC mapping at
> correct PAT fields PA3/PA7.

Well that wasn't from my original tested patch. Grr.

> TBD: KEXEC and other CPU offline paths may need pat_shutdown()?

> Index: linux-2.6/arch/x86/mm/Makefile_64
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/Makefile_64 2007-12-11 03:30:34.000000000 -0800
> +++ linux-2.6/arch/x86/mm/Makefile_64	2007-12-11 03:42:08.000000000 -0800
> @@ -2,7 +2,7 @@
>  # Makefile for the linux x86_64-specific parts of the memory manager.
>  #
>  
> -obj-y := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap_64.o
> +obj-y := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap_64.o
> pat.o
>  obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
>  obj-$(CONFIG_NUMA) += numa_64.o
>  obj-$(CONFIG_K8_NUMA) += k8topology_64.o
> Index: linux-2.6/arch/x86/mm/pat.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/arch/x86/mm/pat.c	2007-12-11 04:12:47.000000000 -0800
> @@ -0,0 +1,57 @@
> +/* Handle caching attributes in page tables (PAT) */
> +#include <linux/mm.h>
> +#include <linux/kernel.h>
> +#include <linux/rbtree.h>
> +#include <linux/gfp.h>
> +#include <asm/msr.h>
> +#include <asm/tlbflush.h>
> +#include <asm/processor.h>
> +
> +static u64 boot_pat_state;
> +
> +enum {
> +	PAT_UC = 0,   	/* uncached */
> +	PAT_WC = 1,		/* Write combining */
> +	PAT_WT = 4,		/* Write Through */
> +	PAT_WP = 5,		/* Write Protected */
> +	PAT_WB = 6,		/* Write Back (default) */
> +	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
> +};
> +
> +#define PAT(x,y) ((u64)PAT_ ## y << ((x)*8))
> +
> +void __cpuinit pat_init(void)
> +{
> +	/* Set PWT+PCD to Write-Combining. All other bits stay the same */
> +	if (cpu_has_pat) {
> +		u64 pat;
> +		/* PTE encoding used in Linux:
> +                   PAT
> +                   |PCD
> +                   ||PWT
> +                   |||
> +		   000 WB         default
> +		   010 UC_MINUS   _PAGE_PCD
> +		   011 WC         _PAGE_WC
> +		   PAT bit unused */
> +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,UC_MINUS) | PAT(3,WC) |
> +		      PAT(4,WB) | PAT(5,WT) | PAT(6,UC_MINUS) | PAT(7,WC);

I strongly object to this configuration.

The caching modes of interest are:
PAT_WB write-back or a close as the MTRRs will allow
       used for WC today.
PAT_UC completely uncachable not overridable by MTRRs 
       and what we use today for pgprot_noncached
PAT_WC what isn't available for current use.

We should use:
> +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,WC) | PAT(3,UC) |
> +		      PAT(4,WB) | PAT(5,WT) | PAT(6,WC) | PAT(7,UC);

Changing the UC- which currently allows write-combining if the MTRRs specify it,
to WC.  This grandfathers in all of our current usage and changes the one
PAT type that could today and in legacy mode specify WC to really specify WC.

I don't know if we need to set the high half or not, that would depend
on the state of the PAT errata.

I do know we need to use the low 4 pat mappings to avoid most of the PAT
errata issues.

As for Andi's concern about modules playing games with the PAT mappings
if we don't redefine how we use the page table entries our exposure to
badly behaved modules more limited.

> +		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> +		wrmsrl(MSR_IA32_CR_PAT, pat);
> +		__flush_tlb_all();
> +		asm volatile("wbinvd");
> +	}
> +}
> +
> +#undef PAT
> +
> +void pat_shutdown(void)
> +{
> +	/* Restore CPU default pat state */
> +	if (cpu_has_pat) {
> +		wrmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> +		__flush_tlb_all();
> +		asm volatile("wbinvd");
> +	}
> +}
> +


Eric
