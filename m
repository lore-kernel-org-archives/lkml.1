Return-Path: <linux-kernel-owner+w=401wt.eu-S940901AbXHJTLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940901AbXHJTLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbXHJTLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:11:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138AbXHJTLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:11:33 -0400
Message-ID: <46BCB85B.5050703@redhat.com>
Date: Fri, 10 Aug 2007 15:11:23 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
References: <46BB4599.2020900@redhat.com> <p73zm10egym.fsf@bingen.suse.de> <46BB5F9B.6050808@redhat.com> <20070809231618.GC1845@one.firstfloor.org> <46BBA4CB.7070009@redhat.com> <20070810082310.GA6804@one.firstfloor.org>
In-Reply-To: <20070810082310.GA6804@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2007 04:23 AM, Andi Kleen wrote:
> 
> This is the patch i came up with in the end. Passes testing.
> I also fixed some more minor things.

Looks good to me. Missed adding KERN_EMERG for the printk()
of the TSS address, though.

> 
> Fix double fault handler
> 
> From: Chuck Ebbert <cebbert@redhat.com>
> 
> The new percpu code has apparently broken the doublefault handler
> when CONFIG_DEBUG_SPINLOCK is set. Doublefault is handled by
> a hardware task, making the check
> 
>         SPIN_BUG_ON(lock->owner == current, lock, "recursion");
> 
> fault because it uses the FS register to access the percpu data
> for current, and that register is zero in the new TSS. (The trace
> I saw was on 2.6.20 where it was GS, but it looks like this will
> still happen with FS on 2.6.22.)
> 
> Initializing FS in the doublefault_tss should fix it.
> 
> AK: Also fix broken ptr_ok() and turn printks into KERN_EMERG
> AK: And add a PANIC prefix to make clear the system will hang
> AK: (e.g. x86-64 will recover) 
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
>  arch/i386/kernel/doublefault.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/arch/i386/kernel/doublefault.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/doublefault.c
> +++ linux/arch/i386/kernel/doublefault.c
> @@ -13,7 +13,7 @@
>  static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
>  #define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
>  
> -#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + 0x1000000)
> +#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
>  
>  static void doublefault_fn(void)
>  {
> @@ -23,7 +23,7 @@ static void doublefault_fn(void)
>  	store_gdt(&gdt_desc);
>  	gdt = gdt_desc.address;
>  
> -	printk("double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
> +	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
>  
>  	if (ptr_ok(gdt)) {
>  		gdt += GDT_ENTRY_TSS << 3;
> @@ -35,11 +35,11 @@ static void doublefault_fn(void)
>  		if (ptr_ok(tss)) {
>  			struct i386_hw_tss *t = (struct i386_hw_tss *)tss;
>  
> -			printk("eip = %08lx, esp = %08lx\n", t->eip, t->esp);
> +			printk(KERN_EMERG "eip = %08lx, esp = %08lx\n", t->eip, t->esp);
>  
> -			printk("eax = %08lx, ebx = %08lx, ecx = %08lx, edx = %08lx\n",
> +			printk(KERN_EMERG "eax = %08lx, ebx = %08lx, ecx = %08lx, edx = %08lx\n",
>  				t->eax, t->ebx, t->ecx, t->edx);
> -			printk("esi = %08lx, edi = %08lx\n",
> +			printk(KERN_EMERG "esi = %08lx, edi = %08lx\n",
>  				t->esi, t->edi);
>  		}
>  	}
> @@ -63,6 +63,7 @@ struct tss_struct doublefault_tss __cach
>  		.cs		= __KERNEL_CS,
>  		.ss		= __KERNEL_DS,
>  		.ds		= __USER_DS,
> +		.fs		= __KERNEL_PERCPU,
>  
>  		.__cr3		= __pa(swapper_pg_dir)
>  	}
> 
> 
> 
> 

