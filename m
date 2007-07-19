Return-Path: <linux-kernel-owner+w=401wt.eu-S937358AbXGSNjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937358AbXGSNjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937146AbXGSNi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:38:56 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:65201 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935176AbXGSNiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:38:55 -0400
Date: Thu, 19 Jul 2007 09:38:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: new text patching for review
Message-ID: <20070719133852.GA5490@Krystal>
References: <200707191105.44056.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707191105.44056.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:11:29 up 2 days,  7:45,  1 user,  load average: 0.82, 0.90, 0.94
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

* Andi Kleen (ak@suse.de) wrote:
> 
> Hallo,
> 
> I had some second thoughts about the text patching of DEBUG_RODATA kernels
> using change_page_attr(). Change_page_attr is intrusive and slow and using
> a separate mapping is a little more gentle. I came up with this patch.
> For your review and testing pleasure.
> 
> The main quirk is that it doesn't fully follow the cross-modifying code
> recommendations; but i'm not sure that's really needed.
> 
> Also I admit nop_out is quite inefficient, but that's a very slow path
> and it was easier to do it this way than handle all the corner cases
> explicitely.
> 
> Comments,
> 
> -Andi
> 
> x86: Fix alternatives and kprobes to remap write-protected kernel text
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/i386/kernel/alternative.c   |   33 +++++++++++++++++++++++++++++++--
>  arch/i386/kernel/kprobes.c       |    9 +++------
>  arch/i386/mm/init.c              |   14 +++-----------
>  arch/x86_64/kernel/kprobes.c     |   10 +++-------
>  arch/x86_64/mm/init.c            |   10 ----------
>  arch/x86_64/mm/pageattr.c        |    2 +-
>  include/asm-i386/alternative.h   |    2 ++
>  include/asm-x86_64/alternative.h |    2 ++
>  include/asm-x86_64/pgtable.h     |    2 ++
>  9 files changed, 47 insertions(+), 37 deletions(-)
> 
> Index: linux/arch/x86_64/kernel/kprobes.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/kprobes.c
> +++ linux/arch/x86_64/kernel/kprobes.c
> @@ -39,9 +39,9 @@
>  #include <linux/module.h>
>  #include <linux/kdebug.h>
>  
> -#include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
>  #include <asm/uaccess.h>
> +#include <asm/alternative.h>
>  
>  void jprobe_return_end(void);
>  static void __kprobes arch_copy_kprobe(struct kprobe *p);
> @@ -209,16 +209,12 @@ static void __kprobes arch_copy_kprobe(s
>  
>  void __kprobes arch_arm_kprobe(struct kprobe *p)
>  {
> -	*p->addr = BREAKPOINT_INSTRUCTION;
> -	flush_icache_range((unsigned long) p->addr,
> -			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	text_poke(p->addr, BREAKPOINT_INSTRUCTION);
>  }
>  
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> -	*p->addr = p->opcode;
> -	flush_icache_range((unsigned long) p->addr,
> -			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	text_poke(p->addr, p->opcode);
>  }
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> Index: linux/arch/i386/kernel/alternative.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/alternative.c
> +++ linux/arch/i386/kernel/alternative.c
> @@ -2,8 +2,12 @@
>  #include <linux/sched.h>
>  #include <linux/spinlock.h>
>  #include <linux/list.h>
> +#include <linux/kprobes.h>
> +#include <linux/mm.h>
> +#include <linux/vmalloc.h>
>  #include <asm/alternative.h>
>  #include <asm/sections.h>
> +#include <asm/pgtable.h>
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int smp_alt_once;
> @@ -145,12 +149,15 @@ static unsigned char** find_nop_table(vo
>  static void nop_out(void *insns, unsigned int len)
>  {
>  	unsigned char **noptable = find_nop_table();
> +	int i;
>  
>  	while (len > 0) {
>  		unsigned int noplen = len;
>  		if (noplen > ASM_NOP_MAX)
>  			noplen = ASM_NOP_MAX;
> -		memcpy(insns, noptable[noplen], noplen);
> +		/* Very inefficient */
> +		for (i = 0; i < noplen; i++)
> +			text_poke(insns + i, noptable[noplen][i]);

Ewwwwwwwwwww.... you plan to run this in SMP ? So you actually go byte
by byte changing pieces of instructions non atomically and doing
non-Intel's errata friendly XMC. You are really looking for trouble
there :) Two distinct errors can occur: 

1 - Invalid instruction (due to partial instruction modification)
2 - GPF (or something like it), due to Intel's errata.

I don't see why we _need_ to do the copy operation within a wrapper. I
am always frowning when I see an API that could do a simple task (and do
it well) turn into a more sophisticated interface (here: dealing with
write permissions _and_ doing the copy). It seems to me that it will
just limit the programmer's options about what code they want to change,
how, on how many bytes at a time...

>  		insns += noplen;
>  		len -= noplen;
>  	}
> @@ -202,7 +209,7 @@ static void alternatives_smp_lock(u8 **s
>  			continue;
>  		if (*ptr > text_end)
>  			continue;
> -		**ptr = 0xf0; /* lock prefix */
> +		text_poke(ptr, 0xf0); /* lock prefix */
>  	};
>  }
>  
> @@ -406,3 +413,25 @@ void __init alternative_instructions(voi
>   	apply_paravirt(__parainstructions, __parainstructions_end);
>  	local_irq_restore(flags);
>  }
> +
> +/*
> + * RED-PEN Intel recommends stopping the other CPUs for such
> + * "cross-modifying code".
> + */

Yeah, actually, you don't want them to busy loop with interrupts
disabled during this. Even then, you can get an NMI. Dealing with this
properly at the kernel level requires a little bit more thought than
what has been given to Intel's proposed algorithm. See DJprobes and the
immediate values for that.

Note that it does not apply to the breakpoint instruction set/setting
the original byte back.

> +void __kprobes text_poke(void *oaddr, u8 opcode)
> +{
> +        u8 *addr = oaddr;
> +	if (!pte_write(*lookup_address((unsigned long)addr))) {
> +		struct page *p = virt_to_page(addr);
> +		addr = vmap(&p, 1, VM_MAP, PAGE_KERNEL);

Oh, this part is nice.. you remap the same physical page in a writable
mapping, and then remove the mapping after the operation. I like this :)

What I don't like about this particular implementation is that it does
not support "poking" more than 1 byte. In order to support this, you
would have to deal with the case where the address range spans over more
than one page.

Also, doing the copy in the same interface seems a bit awkward.


I would much prefer something like:

void *map_shadow_write(void *addr, size_t len);
(returns a pointer to the shadow writable pages, at the same page offset
as "addr")

int unmap_shadow_write(void *shadow_addr, size_t len);
(unmap the shadow pages)

Then, the in-kernel user is free to modify their pages as they like.
Since we cannot foresee each modification pattern, I think that leaving
this kind of flexibility is useful.


Mathieu


> +		if (!addr)
> +			return;
> +		addr += ((unsigned long)oaddr) % PAGE_SIZE;
> +	}
> +	*addr = opcode;
> +	/* Not strictly needed, but can speed CPU recovery up */
> +	if (cpu_has_clflush)
> +		asm("clflush (%0) " :: "r" (addr) : "memory");
> +	if (addr != oaddr)
> +		vunmap(addr);
> +}
> Index: linux/arch/x86_64/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/x86_64/mm/pageattr.c
> +++ linux/arch/x86_64/mm/pageattr.c
> @@ -13,7 +13,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/io.h>
>  
> -static inline pte_t *lookup_address(unsigned long address) 
> +pte_t *lookup_address(unsigned long address)
>  { 
>  	pgd_t *pgd = pgd_offset_k(address);
>  	pud_t *pud;
> Index: linux/include/asm-i386/alternative.h
> ===================================================================
> --- linux.orig/include/asm-i386/alternative.h
> +++ linux/include/asm-i386/alternative.h
> @@ -149,4 +149,6 @@ apply_paravirt(struct paravirt_patch_sit
>  #define __parainstructions_end	NULL
>  #endif
>  
> +extern void text_poke(void *addr, u8 opcode);
> +
>  #endif /* _I386_ALTERNATIVE_H */
> Index: linux/include/asm-x86_64/alternative.h
> ===================================================================
> --- linux.orig/include/asm-x86_64/alternative.h
> +++ linux/include/asm-x86_64/alternative.h
> @@ -154,4 +154,6 @@ apply_paravirt(struct paravirt_patch *st
>  #define __parainstructions_end NULL
>  #endif
>  
> +extern void text_poke(void *addr, u8 opcode);
> +
>  #endif /* _X86_64_ALTERNATIVE_H */
> Index: linux/include/asm-x86_64/pgtable.h
> ===================================================================
> --- linux.orig/include/asm-x86_64/pgtable.h
> +++ linux/include/asm-x86_64/pgtable.h
> @@ -403,6 +403,8 @@ extern struct list_head pgd_list;
>  
>  extern int kern_addr_valid(unsigned long addr); 
>  
> +pte_t *lookup_address(unsigned long addr);
> +
>  #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
>  		remap_pfn_range(vma, vaddr, pfn, size, prot)
>  
> Index: linux/arch/i386/kernel/kprobes.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/kprobes.c
> +++ linux/arch/i386/kernel/kprobes.c
> @@ -35,6 +35,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/desc.h>
>  #include <asm/uaccess.h>
> +#include <asm/alternative.h>
>  
>  void jprobe_return_end(void);
>  
> @@ -169,16 +170,12 @@ int __kprobes arch_prepare_kprobe(struct
>  
>  void __kprobes arch_arm_kprobe(struct kprobe *p)
>  {
> -	*p->addr = BREAKPOINT_INSTRUCTION;
> -	flush_icache_range((unsigned long) p->addr,
> -			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	text_poke(p->addr, BREAKPOINT_INSTRUCTION);
>  }
>  
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> -	*p->addr = p->opcode;
> -	flush_icache_range((unsigned long) p->addr,
> -			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	text_poke(p->addr, p->opcode);
>  }
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> Index: linux/arch/i386/mm/init.c
> ===================================================================
> --- linux.orig/arch/i386/mm/init.c
> +++ linux/arch/i386/mm/init.c
> @@ -801,17 +801,9 @@ void mark_rodata_ro(void)
>  	unsigned long start = PFN_ALIGN(_text);
>  	unsigned long size = PFN_ALIGN(_etext) - start;
>  
> -#ifndef CONFIG_KPROBES
> -#ifdef CONFIG_HOTPLUG_CPU
> -	/* It must still be possible to apply SMP alternatives. */
> -	if (num_possible_cpus() <= 1)
> -#endif
> -	{
> -		change_page_attr(virt_to_page(start),
> -		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
> -		printk("Write protecting the kernel text: %luk\n", size >> 10);
> -	}
> -#endif
> +	change_page_attr(virt_to_page(start),
> +	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
> +	printk("Write protecting the kernel text: %luk\n", size >> 10);
>  	start += size;
>  	size = (unsigned long)__end_rodata - start;
>  	change_page_attr(virt_to_page(start),
> Index: linux/arch/x86_64/mm/init.c
> ===================================================================
> --- linux.orig/arch/x86_64/mm/init.c
> +++ linux/arch/x86_64/mm/init.c
> @@ -600,16 +600,6 @@ void mark_rodata_ro(void)
>  {
>  	unsigned long start = (unsigned long)_stext, end;
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -	/* It must still be possible to apply SMP alternatives. */
> -	if (num_possible_cpus() > 1)
> -		start = (unsigned long)_etext;
> -#endif
> -
> -#ifdef CONFIG_KPROBES
> -	start = (unsigned long)__start_rodata;
> -#endif
> -	
>  	end = (unsigned long)__end_rodata;
>  	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
>  	end &= PAGE_MASK;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
