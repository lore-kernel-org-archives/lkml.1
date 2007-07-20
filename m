Return-Path: <linux-kernel-owner+w=401wt.eu-S940046AbXGTP7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940046AbXGTP7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbXGTP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:59:31 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:33259 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937547AbXGTP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:59:30 -0400
Date: Fri, 20 Jul 2007 11:59:26 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, jeremy@goop.org, zach@vmware.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap write-protected kernel text
Message-ID: <20070720155926.GA1960@Krystal>
References: <20070720532.949522000@suse.de> <20070720153246.6597614E79@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070720153246.6597614E79@wotan.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:57:48 up 3 days, 10:31,  3 users,  load average: 0.09, 0.22, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
...
> +/*
> + * Warning: 
> + * When you use this code to patch more than one byte of an instruction
> + * you need to make sure that other CPUs cannot execute this code in parallel.
> + * And on the local CPU you need to be protected again NMI or MCE handlers
> + * seeing an inconsistent instruction while you patch.
> + */

I guess it would be good to also mention the fact that no thread must be
preempted in the middle of multiple instructions combined into one that
would make the iret run an illegal instruction when the thread is
scheduled again.

Mathieu


> +void __kprobes text_poke(void *oaddr, unsigned char *opcode, int len)
> +{
> +        u8 *addr = oaddr;
> +	if (!pte_write(*lookup_address((unsigned long)addr))) {
> +		struct page *p[2] = { virt_to_page(addr), virt_to_page(addr+PAGE_SIZE) };
> +		addr = vmap(p, 2, VM_MAP, PAGE_KERNEL);
> +		if (!addr)
> +			return;
> +		addr += ((unsigned long)oaddr) % PAGE_SIZE;
> +	}
> +	memcpy(addr, opcode, len);
> +	sync_core();
> +	/* Not strictly needed, but can speed CPU recovery up. Ignore cross cacheline
> +	   case. */
> +	if (cpu_has_clflush)
> +		asm("clflush (%0) " :: "r" (oaddr) : "memory");
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
> +extern void text_poke(void *addr, unsigned char *opcode, int len);
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
> +extern void text_poke(void *addr, unsigned char *opcode, int len);
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
> +	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
>  }
>  
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> -	*p->addr = p->opcode;
> -	flush_icache_range((unsigned long) p->addr,
> -			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	text_poke(p->addr, &p->opcode, 1);
>  }
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> Index: linux/arch/i386/mm/init.c
> ===================================================================
> --- linux.orig/arch/i386/mm/init.c
> +++ linux/arch/i386/mm/init.c
> @@ -800,17 +800,9 @@ void mark_rodata_ro(void)
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
> Index: linux/arch/i386/kernel/paravirt.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/paravirt.c
> +++ linux/arch/i386/kernel/paravirt.c
> @@ -124,20 +124,28 @@ unsigned paravirt_patch_ignore(unsigned 
>  	return len;
>  }
>  
> +struct branch { 
> +	unsigned char opcode;
> +	u32 delta;
> +} __attribute__((packed)); 
> +
>  unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
>  			     void *site, u16 site_clobbers,
>  			     unsigned len)
>  {
>  	unsigned char *call = site;
>  	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
> +	struct branch b;
>  
>  	if (tgt_clobbers & ~site_clobbers)
>  		return len;	/* target would clobber too much for this site */
>  	if (len < 5)
>  		return len;	/* call too long for patch site */
>  
> -	*call++ = 0xe8;		/* call */
> -	*(unsigned long *)call = delta;
> +	b.opcode = 0xe8; /* call */
> +	b.delta = delta;
> +	BUILD_BUG_ON(sizeof(b) != 5);
> +	text_poke(call, (unsigned char *)&b, 5);
>  
>  	return 5;
>  }
> @@ -150,8 +158,9 @@ unsigned paravirt_patch_jmp(void *target
>  	if (len < 5)
>  		return len;	/* call too long for patch site */
>  
> -	*jmp++ = 0xe9;		/* jmp */
> -	*(unsigned long *)jmp = delta;
> +	b.opcode = 0xe9;	/* jmp */
> +	b.delta = delta;
> +	text_poke(call, (unsigned char *)&b, 5);
>  
>  	return 5;
>  }
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
