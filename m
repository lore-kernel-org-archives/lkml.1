Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZBSMKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZBSMKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZBSMKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:10:04 -0500
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:30042 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753337AbZBSMKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:10:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YulVlTxTEwfWX+2L/qPwUI3T5O5Mo9TP2p0kKczXt2Z76oYJwysBFJAQy6YizudSFwDdY2AGn5o5EVFGXfqKFXe4M0uvA/k4LaJ3AH7d1t95IXL0EY5w0cwv93Bcw02miSDR8AoWZr5Uqi7TK+iHZd9lrSXamEZM9NQZLP6guKw=  ;
X-YMail-OSG: omvDFnkVM1m2Lvz34u5UIya8gFCc4FKy9Z8M_JcCyWMd.AIcvr5y.hL3W6OTZsmOItUJ91iWaBo2fJEQAraE7eUkm.0F_Xgw9ruosT0yxoQ51B9Cn4wV2HUKUw8g8iCqeBfMrwUxY_t4eW52J656BXE6sdBhrYbJw3g9IbkJTtl16b_Ie.qPW2UKmjTBvTOYENW24qiaxeoBNgbrCt_55MghCz8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/10] vmalloc: implement vm_area_register_early()
Date: Thu, 19 Feb 2009 23:09:28 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-8-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192309.29576.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 23:04:33 Tejun Heo wrote:
> Impact: allow multiple early vm areas
>
> There are places where kernel VM area needs to be allocated before
> vmalloc is initialized.  This is done by allocating static vm_struct,
> initializing several fields and linking it to vmlist and later vmalloc
> initialization picking up these from vmlist.  This is currently done
> manually and if there's more than one such areas, there's no defined
> way to arbitrate who gets which address.
>
> This patch implements vm_area_register_early(), which takes vm_area
> struct with flags and size initialized, assigns address to it and puts
> it on the vmlist.  This way, multiple early vm areas can determine
> which addresses they should use.  The only current user - alpha mm
> init - is converted to use it.

Yes, this is much cleaner. Arguably could go upstream earlier, but
if there are no other callers, probably doesn't matter so much.

Acked-by: Nick Piggin <npiggin@suse.de>

>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/alpha/mm/init.c    |   20 +++++++++++++-------
>  include/linux/vmalloc.h |    1 +
>  mm/vmalloc.c            |   24 ++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 7 deletions(-)
>
> diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
> index 5d7a16e..df6df02 100644
> --- a/arch/alpha/mm/init.c
> +++ b/arch/alpha/mm/init.c
> @@ -189,9 +189,21 @@ callback_init(void * kernel_end)
>
>  	if (alpha_using_srm) {
>  		static struct vm_struct console_remap_vm;
> -		unsigned long vaddr = VMALLOC_START;
> +		unsigned long nr_pages = 0;
> +		unsigned long vaddr;
>  		unsigned long i, j;
>
> +		/* calculate needed size */
> +		for (i = 0; i < crb->map_entries; ++i)
> +			nr_pages += crb->map[i].count;
> +
> +		/* register the vm area */
> +		console_remap_vm.flags = VM_ALLOC;
> +		console_remap_vm.size = nr_pages << PAGE_SHIFT;
> +		vm_area_register_early(&console_remap_vm);
> +
> +		vaddr = (unsigned long)consle_remap_vm.addr;
> +
>  		/* Set up the third level PTEs and update the virtual
>  		   addresses of the CRB entries.  */
>  		for (i = 0; i < crb->map_entries; ++i) {
> @@ -213,12 +225,6 @@ callback_init(void * kernel_end)
>  				vaddr += PAGE_SIZE;
>  			}
>  		}
> -
> -		/* Let vmalloc know that we've allocated some space.  */
> -		console_remap_vm.flags = VM_ALLOC;
> -		console_remap_vm.addr = (void *) VMALLOC_START;
> -		console_remap_vm.size = vaddr - VMALLOC_START;
> -		vmlist = &console_remap_vm;
>  	}
>
>  	callback_init_done = 1;
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 506e762..bbc0513 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -106,5 +106,6 @@ extern long vwrite(char *buf, char *addr, unsigned long
> count); */
>  extern rwlock_t vmlist_lock;
>  extern struct vm_struct *vmlist;
> +extern __init void vm_area_register_early(struct vm_struct *vm);
>
>  #endif /* _LINUX_VMALLOC_H */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c37924a..d206261 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -24,6 +24,7 @@
>  #include <linux/radix-tree.h>
>  #include <linux/rcupdate.h>
>  #include <linux/bootmem.h>
> +#include <linux/pfn.h>
>
>  #include <asm/atomic.h>
>  #include <asm/uaccess.h>
> @@ -982,6 +983,29 @@ void *vm_map_ram(struct page **pages, unsigned int
> count, int node, pgprot_t pro }
>  EXPORT_SYMBOL(vm_map_ram);
>
> +/**
> + * vm_area_register_early - register vmap area early during boot
> + * @vm: vm_struct to register
> + * @size: size of area to register
> + *
> + * This function is used to register kernel vm area before
> + * vmalloc_init() is called.  @vm->size and @vm->flags should contain
> + * proper values on entry and other fields should be zero.  On return,
> + * vm->addr contains the allocated address.
> + *
> + * DO NOT USE THIS FUNCTION UNLESS YOU KNOW WHAT YOU'RE DOING.
> + */
> +void __init vm_area_register_early(struct vm_struct *vm)
> +{
> +	static size_t vm_init_off __initdata;
> +
> +	vm->addr = (void *)VMALLOC_START + vm_init_off;
> +	vm_init_off = PFN_ALIGN(vm_init_off + vm->size);
> +
> +	vm->next = vmlist;
> +	vmlist = vm;
> +}
> +
>  void __init vmalloc_init(void)
>  {
>  	struct vmap_area *va;


