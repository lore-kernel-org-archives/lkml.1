Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab0CLOJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:09:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:47083 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933212Ab0CLOJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:09:01 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+6VsBKVn+6hheCwsXyUrVFIphEFMirW/1m+KFsnW
	6JgDU/ja+hw3b4
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch x86-xen-disable-highmem-pte-allocation-even-when-config_highpte-y.patch added to 2.6.33-stable tree
Date: Fri, 12 Mar 2010 15:08:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.slh.10-sidux-686; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, ian.campbell@citrix.com, hpa@zytor.com,
       jeremy@goop.org, mingo@elte.hu, pasik@iki.fi,
       xen-devel@lists.xensource.com, stable@kernel.org
References: <12683359492650@site>
In-Reply-To: <12683359492650@site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003121508.54384.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 12 March 2010, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
> 
> to the 2.6.33-stable tree.  Its filename is
> 
>     x86-xen-disable-highmem-pte-allocation-even-when-config_highpte-y.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From 817a824b75b1475f1b067c8cee318c7b4d66fcde Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ian.campbell@citrix.com>
> Date: Fri, 26 Feb 2010 17:16:00 +0000
> Subject: x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> commit 817a824b75b1475f1b067c8cee318c7b4d66fcde upstream.
> 
> There's a path in the pagefault code where the kernel deliberately
> breaks its own locking rules by kmapping a high pte page without
> holding the pagetable lock (in at least page_check_address). This
> breaks Xen's ability to track the pinned/unpinned state of the
> page. There does not appear to be a viable workaround for this
> behaviour so simply disable HIGHPTE for all Xen guests.

This patch breaks compilation of the current 2.6.33 -stable queue and might
also affect queue-2.6.32 (untested):

  CC      arch/x86/xen/enlighten.o
arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
arch/x86/xen/enlighten.c:1102: error: ‘__userpte_alloc_gfp’ undeclared (first use in this function)
arch/x86/xen/enlighten.c:1102: error: (Each undeclared identifier is reported only once
arch/x86/xen/enlighten.c:1102: error: for each function it appears in.)
make[2]: *** [arch/x86/xen/enlighten.o] Error 1
make[1]: *** [arch/x86/xen] Error 2

as it seems to depend (tested) on:

commit 14315592009c17035cac81f4954d5a1f4d71e489
Author: Ian Campbell <ian.campbell@citrix.com>
Date:   Wed Feb 17 10:38:10 2010 +0000

    x86, mm: Allow highmem user page tables to be disabled at boot time

Regards
	Stefan Lippers-Hollmann

-- 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> LKML-Reference: <1267204562-11844-1-git-send-email-ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pasi Kärkkäinen <pasik@iki.fi>
> Cc: <xen-devel@lists.xensource.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/x86/xen/enlighten.c |    7 +++++++
>  arch/x86/xen/mmu.c       |   11 ++++++-----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -50,6 +50,7 @@
>  #include <asm/traps.h>
>  #include <asm/setup.h>
>  #include <asm/desc.h>
> +#include <asm/pgalloc.h>
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>  #include <asm/reboot.h>
> @@ -1094,6 +1095,12 @@ asmlinkage void __init xen_start_kernel(
>  
>  	__supported_pte_mask |= _PAGE_IOMAP;
>  
> +	/*
> +	 * Prevent page tables from being allocated in highmem, even
> +	 * if CONFIG_HIGHPTE is enabled.
> +	 */
> +	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
> +
>  	/* Work out if we support NX */
>  	x86_configure_nx();
>  
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1432,14 +1432,15 @@ static void *xen_kmap_atomic_pte(struct
>  {
>  	pgprot_t prot = PAGE_KERNEL;
>  
> +	/*
> +	 * We disable highmem allocations for page tables so we should never
> +	 * see any calls to kmap_atomic_pte on a highmem page.
> +	 */
> +	BUG_ON(PageHighMem(page));
> +
>  	if (PagePinned(page))
>  		prot = PAGE_KERNEL_RO;
>  
> -	if (0 && PageHighMem(page))
> -		printk("mapping highpte %lx type %d prot %s\n",
> -		       page_to_pfn(page), type,
> -		       (unsigned long)pgprot_val(prot) & _PAGE_RW ? "WRITE" : "READ");
> -
>  	return kmap_atomic_prot(page, type, prot);
>  }
>  #endif
