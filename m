Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbYAKR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbYAKR3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760683AbYAKR3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:29:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27951 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760263AbYAKR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:29:07 -0500
X-SBRS: None
X-MesageID: 37345073
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,272,1196658000"; 
   d="scan'208";a="37345073"
Message-ID: <4787A72E.8060704@citrix.com>
Date: Fri, 11 Jan 2008 09:28:14 -0800
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com>
In-Reply-To: <4787436E.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory
> (Xen requires GDT *and* LDT to be page-aligned).

Can kmalloc return non-page-aligned PAGE_SIZE allocations?

>  Using the page
> allocator interface also removes the (albeit small) slab allocator
> overhead.

Runtime or space overhead?  Given that they're once-off allocations, the 
time part isn't a big factor.  And apparently LDT is completely unused.

Seems like a reasonable change either way.

>  The same change being done for 64-bits for consistency.
>
> Further, the Xen hypercall interface expects the LDT address to be
> virtual, not machine.
>   

Shows how much the LDT gets used then...  Hm, but I didn't make that 
code up; I wonder where it came from?  But certainly, passing the mfn of 
the first page of a vmalloc area doesn't make any sense.

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Ingo Molnar <mingo@elte.hu>
>   
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

> ---
>  arch/x86/kernel/ldt_32.c |    7 +++----
>  arch/x86/kernel/ldt_64.c |    7 +++----
>  arch/x86/xen/enlighten.c |    9 +--------
>  3 files changed, 7 insertions(+), 16 deletions(-)
>
> --- linux-2.6.24-rc7/arch/x86/kernel/ldt_32.c	2008-01-10 16:53:54.000000000 +0100
> +++ 2.6.24-rc7-x86-xen-ldt/arch/x86/kernel/ldt_32.c	2008-01-09 13:59:50.000000000 +0100
> @@ -9,7 +9,6 @@
>  #include <linux/mm.h>
>  #include <linux/smp.h>
>  #include <linux/vmalloc.h>
> -#include <linux/slab.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
> @@ -38,7 +37,7 @@ static int alloc_ldt(mm_context_t *pc, i
>  	if (mincount*LDT_ENTRY_SIZE > PAGE_SIZE)
>  		newldt = vmalloc(mincount*LDT_ENTRY_SIZE);
>  	else
> -		newldt = kmalloc(mincount*LDT_ENTRY_SIZE, GFP_KERNEL);
> +		newldt = (void *)__get_free_page(GFP_KERNEL);
>  
>  	if (!newldt)
>  		return -ENOMEM;
> @@ -69,7 +68,7 @@ static int alloc_ldt(mm_context_t *pc, i
>  		if (oldsize*LDT_ENTRY_SIZE > PAGE_SIZE)
>  			vfree(oldldt);
>  		else
> -			kfree(oldldt);
> +			put_page(virt_to_page(oldldt));
>  	}
>  	return 0;
>  }
> @@ -114,7 +113,7 @@ void destroy_context(struct mm_struct *m
>  		if (mm->context.size*LDT_ENTRY_SIZE > PAGE_SIZE)
>  			vfree(mm->context.ldt);
>  		else
> -			kfree(mm->context.ldt);
> +			put_page(virt_to_page(mm->context.ldt));
>  		mm->context.size = 0;
>  	}
>  }
> --- linux-2.6.24-rc7/arch/x86/kernel/ldt_64.c	2008-01-10 16:53:54.000000000 +0100
> +++ 2.6.24-rc7-x86-xen-ldt/arch/x86/kernel/ldt_64.c	2008-01-09 13:59:50.000000000 +0100
> @@ -12,7 +12,6 @@
>  #include <linux/mm.h>
>  #include <linux/smp.h>
>  #include <linux/vmalloc.h>
> -#include <linux/slab.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
> @@ -41,7 +40,7 @@ static int alloc_ldt(mm_context_t *pc, u
>  	if (mincount*LDT_ENTRY_SIZE > PAGE_SIZE)
>  		newldt = vmalloc(mincount*LDT_ENTRY_SIZE);
>  	else
> -		newldt = kmalloc(mincount*LDT_ENTRY_SIZE, GFP_KERNEL);
> +		newldt = (void *)__get_free_page(GFP_KERNEL);
>  
>  	if (!newldt)
>  		return -ENOMEM;
> @@ -73,7 +72,7 @@ static int alloc_ldt(mm_context_t *pc, u
>  		if (oldsize*LDT_ENTRY_SIZE > PAGE_SIZE)
>  			vfree(oldldt);
>  		else
> -			kfree(oldldt);
> +			put_page(virt_to_page(oldldt));
>  	}
>  	return 0;
>  }
> @@ -117,7 +116,7 @@ void destroy_context(struct mm_struct *m
>  		if ((unsigned)mm->context.size*LDT_ENTRY_SIZE > PAGE_SIZE)
>  			vfree(mm->context.ldt);
>  		else
> -			kfree(mm->context.ldt);
> +			put_page(virt_to_page(mm->context.ldt));
>  		mm->context.size = 0;
>  	}
>  }
> --- linux-2.6.24-rc7/arch/x86/xen/enlighten.c	2008-01-10 16:53:55.000000000 +0100
> +++ 2.6.24-rc7-x86-xen-ldt/arch/x86/xen/enlighten.c	2008-01-09 14:00:51.000000000 +0100
> @@ -275,19 +275,12 @@ static unsigned long xen_store_tr(void)
>  
>  static void xen_set_ldt(const void *addr, unsigned entries)
>  {
> -	unsigned long linear_addr = (unsigned long)addr;
>  	struct mmuext_op *op;
>  	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
>  
>  	op = mcs.args;
>  	op->cmd = MMUEXT_SET_LDT;
> -	if (linear_addr) {
> -		/* ldt my be vmalloced, use arbitrary_virt_to_machine */
> -		xmaddr_t maddr;
> -		maddr = arbitrary_virt_to_machine((unsigned long)addr);
> -		linear_addr = (unsigned long)maddr.maddr;
> -	}
> -	op->arg1.linear_addr = linear_addr;
> +	op->arg1.linear_addr = (unsigned long)addr;
>  	op->arg2.nr_ents = entries;
>  
>  	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
>
>
>
>   

