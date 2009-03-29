Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbZC2Rta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbZC2Rta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZC2RtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:49:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31293 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZC2RtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Yo+erCj2BC9OF9nGjIAM9dAAFs50bj6OUEf05GT/bnm7RU+AyMrcoI8IM+G1XHsicN
         SN3n3DGux1q5P4h0CZKY2vOmYtpu5NFJ/XzCuKmHl8VcodreFe2VD3U4X+EbEhI2471E
         89sQ+9eO+BnjFt+RLB8ZZIJb+M1VkT9qUMINk=
Date: Sun, 29 Mar 2009 21:56:42 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: fault.c cleanup, what else could it be
Message-ID: <20090329175642.GA26405@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, what are you doing?

Can't you just sit tight and not touch code which should not be touched?

Have you lost all taste on small scale?

You're giving bad example to new people, don't you realize it?

This commit have so many junk changes so it's not funny anymore at all.

I have personally stopped sending anything against pure arch/x86/
if there is even a smallest chance it can be prettyfied like this.

When adding ':' at the end of comments, what was wrong with just dot?

	      /*
	       * Oops. The kernel tried to access some bad page. We'll have to
	-      * terminate things with extreme prejudice.
	+      * terminate things with extreme prejudice:
	       */

With initializing things like this:

	-     tsk->thread.cr2 = address;
	-     tsk->thread.trap_no = 14;
	-     tsk->thread.error_code = error_code;
	+     tsk->thread.cr2         = address;
	+     tsk->thread.trap_no     = 14;
	+     tsk->thread.error_code  = error_code;

With if constructs like this:

	-     if (fault & VM_FAULT_OOM)
	+     if (fault & VM_FAULT_OOM) {
	              out_of_memory(regs, error_code, address);
	-     else if (fault & VM_FAULT_SIGBUS)
	-             do_sigbus(regs, error_code, address);
	-     else
	-             BUG();
	+     } else {
	+             if (fault & VM_FAULT_SIGBUS)
	+                     do_sigbus(regs, error_code, address);
	+             else
	+                     BUG();
	+     }

With new empty lines (not all of them, but quite a few) like this:

	>  static int spurious_fault_check(unsigned long error_code, pte_t *pte)
	>  {
	>       if ((error_code & PF_WRITE) && !pte_write(*pte))
	>               return 0;
	> +
	>       if ((error_code & PF_INSTR) && !pte_exec(*pte))
	>               return 0;

What was wrong with all of this?

And for the protocol.

Making variable declarations ordered by length is an obvious bullshit:

1) People wont understand you plan and continue to add it like they did.
2) When changing variable type, I should probably move it. Why should I do it?
   Now if I don't know you nice plan, I'd just change it.
3) Variables can be possibly grouped together, you'll detach them.
3) What to do with initializers?

   Some initializers are brilliant:

	> -     struct task_struct *tsk = current;

See? One line, tsk never changes, at the top of the function.

Or similar:

	struct dentry *dentry = file->f_path.dentry;
	struct inode *inode = dentry->d_inode;

It's _good_ code. Now getting rid of initializers will probably force
you to get rid of them. In the name of what?


Ordering include by length is less obvious but bullshit too.

There is alphabetical ordering at least. The problem is small enough to not
bother. Include rejects are trivial unlike real rejects.


This chunk is also bogus:

	> -     static int warned;
	> +     static int once;

'warned' is exactly what variable meant. Exactly.

I'm attaching offending (literally: offending) commit in it's full glory.

> commit 2d4a71676f4d89418a0d53e60b89e8b804b390b2
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Feb 20 19:56:40 2009 +0100
> 
>     x86, mm: fault.c cleanup
>     
>     Impact: cleanup, no code changed
>     
>     Clean up various small details, which can be correctness checked
>     automatically:
>     
>      - tidy up the include file section
>      - eliminate unnecessary includes
>      - introduce show_signal_msg() to clean up code flow
>      - standardize the code flow
>      - standardize comments and other style details
>      - more cleanups, pointed out by checkpatch
>     
>     No code changed on either 32-bit nor 64-bit:
>     
>     arch/x86/mm/fault.o:
>     
>        text	   data	    bss	    dec	    hex	filename
>        4632	     32	     24	   4688	   1250	fault.o.before
>        4632	     32	     24	   4688	   1250	fault.o.after
>     
>     the md5 changed due to a change in a single instruction:
>     
>        2e8a8241e7f0d69706776a5a26c90bc0  fault.o.before.asm
>        c5c3d36e725586eb74f0e10692f0193e  fault.o.after.asm
>     
>     Because a __LINE__ reference in a WARN_ONCE() has changed.
>     
>     On 32-bit a few stack offsets changed - no code size difference
>     nor any functionality difference.
>     
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index e4b9fc5..351d679 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1,56 +1,59 @@
>  /*
>   *  Copyright (C) 1995  Linus Torvalds
> - *  Copyright (C) 2001,2002 Andi Kleen, SuSE Labs.
> + *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
>   */
> -
> -#include <linux/signal.h>
> -#include <linux/sched.h>
> -#include <linux/kernel.h>
> -#include <linux/errno.h>
> -#include <linux/string.h>
> -#include <linux/types.h>
> -#include <linux/ptrace.h>
> -#include <linux/mmiotrace.h>
> -#include <linux/mman.h>
> -#include <linux/mm.h>
> -#include <linux/smp.h>
>  #include <linux/interrupt.h>
> -#include <linux/init.h>
> -#include <linux/tty.h>
> -#include <linux/vt_kern.h>		/* For unblank_screen() */
> +#include <linux/mmiotrace.h>
> +#include <linux/bootmem.h>
>  #include <linux/compiler.h>
>  #include <linux/highmem.h>
> -#include <linux/bootmem.h>		/* for max_low_pfn */
> -#include <linux/vmalloc.h>
> -#include <linux/module.h>
>  #include <linux/kprobes.h>
>  #include <linux/uaccess.h>
> +#include <linux/vmalloc.h>
> +#include <linux/vt_kern.h>
> +#include <linux/signal.h>
> +#include <linux/kernel.h>
> +#include <linux/ptrace.h>
> +#include <linux/string.h>
> +#include <linux/module.h>
>  #include <linux/kdebug.h>
> +#include <linux/errno.h>
>  #include <linux/magic.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/mman.h>
> +#include <linux/tty.h>
> +#include <linux/smp.h>
> +#include <linux/mm.h>
> +
> +#include <asm-generic/sections.h>
>  
> -#include <asm/system.h>
> -#include <asm/desc.h>
> -#include <asm/segment.h>
> -#include <asm/pgalloc.h>
> -#include <asm/smp.h>
>  #include <asm/tlbflush.h>
> +#include <asm/pgalloc.h>
> +#include <asm/segment.h>
> +#include <asm/system.h>
>  #include <asm/proto.h>
> -#include <asm-generic/sections.h>
>  #include <asm/traps.h>
> +#include <asm/desc.h>
>  
>  /*
> - * Page fault error code bits
> - *	bit 0 == 0 means no page found, 1 means protection fault
> - *	bit 1 == 0 means read, 1 means write
> - *	bit 2 == 0 means kernel, 1 means user-mode
> - *	bit 3 == 1 means use of reserved bit detected
> - *	bit 4 == 1 means fault was an instruction fetch
> + * Page fault error code bits:
> + *
> + *   bit 0 ==	 0: no page found	1: protection fault
> + *   bit 1 ==	 0: read access		1: write access
> + *   bit 2 ==	 0: kernel-mode access	1: user-mode access
> + *   bit 3 ==				1: use of reserved bit detected
> + *   bit 4 ==				1: fault was an instruction fetch
>   */
> -#define PF_PROT		(1<<0)
> -#define PF_WRITE	(1<<1)
> -#define PF_USER		(1<<2)
> -#define PF_RSVD		(1<<3)
> -#define PF_INSTR	(1<<4)
> +enum x86_pf_error_code {
> +
> +	PF_PROT		=		1 << 0,
> +	PF_WRITE	=		1 << 1,
> +	PF_USER		=		1 << 2,
> +	PF_RSVD		=		1 << 3,
> +	PF_INSTR	=		1 << 4,
> +};
>  
>  static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  {
> @@ -82,23 +85,27 @@ static inline int notify_page_fault(struct pt_regs *regs)
>  }
>  
>  /*
> - * X86_32
> - * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
> - * Check that here and ignore it.
> + * Prefetch quirks:
> + *
> + * 32-bit mode:
> + *
> + *   Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
> + *   Check that here and ignore it.
>   *
> - * X86_64
> - * Sometimes the CPU reports invalid exceptions on prefetch.
> - * Check that here and ignore it.
> + * 64-bit mode:
>   *
> - * Opcode checker based on code by Richard Brunner
> + *   Sometimes the CPU reports invalid exceptions on prefetch.
> + *   Check that here and ignore it.
> + *
> + * Opcode checker based on code by Richard Brunner.
>   */
> -static int is_prefetch(struct pt_regs *regs, unsigned long error_code,
> -			unsigned long addr)
> +static int
> +is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
>  {
> +	unsigned char *max_instr;
>  	unsigned char *instr;
>  	int scan_more = 1;
>  	int prefetch = 0;
> -	unsigned char *max_instr;
>  
>  	/*
>  	 * If it was a exec (instruction fetch) fault on NX page, then
> @@ -114,9 +121,9 @@ static int is_prefetch(struct pt_regs *regs, unsigned long error_code,
>  		return 0;
>  
>  	while (scan_more && instr < max_instr) {
> -		unsigned char opcode;
>  		unsigned char instr_hi;
>  		unsigned char instr_lo;
> +		unsigned char opcode;
>  
>  		if (probe_kernel_address(instr, opcode))
>  			break;
> @@ -173,15 +180,17 @@ static int is_prefetch(struct pt_regs *regs, unsigned long error_code,
>  	return prefetch;
>  }
>  
> -static void force_sig_info_fault(int si_signo, int si_code,
> -	unsigned long address, struct task_struct *tsk)
> +static void
> +force_sig_info_fault(int si_signo, int si_code, unsigned long address,
> +		     struct task_struct *tsk)
>  {
>  	siginfo_t info;
>  
> -	info.si_signo = si_signo;
> -	info.si_errno = 0;
> -	info.si_code = si_code;
> -	info.si_addr = (void __user *)address;
> +	info.si_signo	= si_signo;
> +	info.si_errno	= 0;
> +	info.si_code	= si_code;
> +	info.si_addr	= (void __user *)address;
> +
>  	force_sig_info(si_signo, &info, tsk);
>  }
>  
> @@ -189,6 +198,7 @@ static void force_sig_info_fault(int si_signo, int si_code,
>  static int bad_address(void *p)
>  {
>  	unsigned long dummy;
> +
>  	return probe_kernel_address((unsigned long *)p, dummy);
>  }
>  #endif
> @@ -200,13 +210,14 @@ static void dump_pagetable(unsigned long address)
>  
>  	page = read_cr3();
>  	page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
> +
>  #ifdef CONFIG_X86_PAE
>  	printk("*pdpt = %016Lx ", page);
>  	if ((page >> PAGE_SHIFT) < max_low_pfn
>  	    && page & _PAGE_PRESENT) {
>  		page &= PAGE_MASK;
>  		page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
> -		                                         & (PTRS_PER_PMD - 1)];
> +							& (PTRS_PER_PMD - 1)];
>  		printk(KERN_CONT "*pde = %016Lx ", page);
>  		page &= ~_PAGE_NX;
>  	}
> @@ -218,14 +229,15 @@ static void dump_pagetable(unsigned long address)
>  	 * We must not directly access the pte in the highpte
>  	 * case if the page table is located in highmem.
>  	 * And let's rather not kmap-atomic the pte, just in case
> -	 * it's allocated already.
> +	 * it's allocated already:
>  	 */
>  	if ((page >> PAGE_SHIFT) < max_low_pfn
>  	    && (page & _PAGE_PRESENT)
>  	    && !(page & _PAGE_PSE)) {
> +
>  		page &= PAGE_MASK;
>  		page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
> -		                                         & (PTRS_PER_PTE - 1)];
> +							& (PTRS_PER_PTE - 1)];
>  		printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
>  	}
>  
> @@ -239,26 +251,38 @@ static void dump_pagetable(unsigned long address)
>  	pgd = (pgd_t *)read_cr3();
>  
>  	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK);
> +
>  	pgd += pgd_index(address);
> -	if (bad_address(pgd)) goto bad;
> +	if (bad_address(pgd))
> +		goto bad;
> +
>  	printk("PGD %lx ", pgd_val(*pgd));
> -	if (!pgd_present(*pgd)) goto ret;
> +
> +	if (!pgd_present(*pgd))
> +		goto out;
>  
>  	pud = pud_offset(pgd, address);
> -	if (bad_address(pud)) goto bad;
> +	if (bad_address(pud))
> +		goto bad;
> +
>  	printk("PUD %lx ", pud_val(*pud));
>  	if (!pud_present(*pud) || pud_large(*pud))
> -		goto ret;
> +		goto out;
>  
>  	pmd = pmd_offset(pud, address);
> -	if (bad_address(pmd)) goto bad;
> +	if (bad_address(pmd))
> +		goto bad;
> +
>  	printk("PMD %lx ", pmd_val(*pmd));
> -	if (!pmd_present(*pmd) || pmd_large(*pmd)) goto ret;
> +	if (!pmd_present(*pmd) || pmd_large(*pmd))
> +		goto out;
>  
>  	pte = pte_offset_kernel(pmd, address);
> -	if (bad_address(pte)) goto bad;
> +	if (bad_address(pte))
> +		goto bad;
> +
>  	printk("PTE %lx", pte_val(*pte));
> -ret:
> +out:
>  	printk("\n");
>  	return;
>  bad:
> @@ -285,7 +309,6 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
>  	 * and redundant with the set_pmd() on non-PAE. As would
>  	 * set_pud.
>  	 */
> -
>  	pud = pud_offset(pgd, address);
>  	pud_k = pud_offset(pgd_k, address);
>  	if (!pud_present(*pud_k))
> @@ -295,11 +318,14 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
>  	pmd_k = pmd_offset(pud_k, address);
>  	if (!pmd_present(*pmd_k))
>  		return NULL;
> +
>  	if (!pmd_present(*pmd)) {
>  		set_pmd(pmd, *pmd_k);
>  		arch_flush_lazy_mmu_mode();
> -	} else
> +	} else {
>  		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
> +	}
> +
>  	return pmd_k;
>  }
>  #endif
> @@ -312,29 +338,37 @@ KERN_ERR "******* Please consider a BIOS update.\n"
>  KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
>  #endif
>  
> -/* Workaround for K8 erratum #93 & buggy BIOS.
> -   BIOS SMM functions are required to use a specific workaround
> -   to avoid corruption of the 64bit RIP register on C stepping K8.
> -   A lot of BIOS that didn't get tested properly miss this.
> -   The OS sees this as a page fault with the upper 32bits of RIP cleared.
> -   Try to work around it here.
> -   Note we only handle faults in kernel here.
> -   Does nothing for X86_32
> +/*
> + * Workaround for K8 erratum #93 & buggy BIOS.
> + *
> + * BIOS SMM functions are required to use a specific workaround
> + * to avoid corruption of the 64bit RIP register on C stepping K8.
> + *
> + * A lot of BIOS that didn't get tested properly miss this.
> + *
> + * The OS sees this as a page fault with the upper 32bits of RIP cleared.
> + * Try to work around it here.
> + *
> + * Note we only handle faults in kernel here.
> + * Does nothing on 32-bit.
>   */
>  static int is_errata93(struct pt_regs *regs, unsigned long address)
>  {
>  #ifdef CONFIG_X86_64
> -	static int warned;
> +	static int once;
> +
>  	if (address != regs->ip)
>  		return 0;
> +
>  	if ((address >> 32) != 0)
>  		return 0;
> +
>  	address |= 0xffffffffUL << 32;
>  	if ((address >= (u64)_stext && address <= (u64)_etext) ||
>  	    (address >= MODULES_VADDR && address <= MODULES_END)) {
> -		if (!warned) {
> +		if (!once) {
>  			printk(errata93_warning);
> -			warned = 1;
> +			once = 1;
>  		}
>  		regs->ip = address;
>  		return 1;
> @@ -344,16 +378,17 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
>  }
>  
>  /*
> - * Work around K8 erratum #100 K8 in compat mode occasionally jumps to illegal
> - * addresses >4GB.  We catch this in the page fault handler because these
> - * addresses are not reachable. Just detect this case and return.  Any code
> + * Work around K8 erratum #100 K8 in compat mode occasionally jumps
> + * to illegal addresses >4GB.
> + *
> + * We catch this in the page fault handler because these addresses
> + * are not reachable. Just detect this case and return.  Any code
>   * segment in LDT is compatibility mode.
>   */
>  static int is_errata100(struct pt_regs *regs, unsigned long address)
>  {
>  #ifdef CONFIG_X86_64
> -	if ((regs->cs == __USER32_CS || (regs->cs & (1<<2))) &&
> -	    (address >> 32))
> +	if ((regs->cs == __USER32_CS || (regs->cs & (1<<2))) && (address >> 32))
>  		return 1;
>  #endif
>  	return 0;
> @@ -363,8 +398,9 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
>  {
>  #ifdef CONFIG_X86_F00F_BUG
>  	unsigned long nr;
> +
>  	/*
> -	 * Pentium F0 0F C7 C8 bug workaround.
> +	 * Pentium F0 0F C7 C8 bug workaround:
>  	 */
>  	if (boot_cpu_data.f00f_bug) {
>  		nr = (address - idt_descr.address) >> 3;
> @@ -378,8 +414,9 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
>  	return 0;
>  }
>  
> -static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
> -			    unsigned long address)
> +static void
> +show_fault_oops(struct pt_regs *regs, unsigned long error_code,
> +		unsigned long address)
>  {
>  #ifdef CONFIG_X86_32
>  	if (!oops_may_print())
> @@ -389,12 +426,14 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  #ifdef CONFIG_X86_PAE
>  	if (error_code & PF_INSTR) {
>  		unsigned int level;
> +
>  		pte_t *pte = lookup_address(address, &level);
>  
> -		if (pte && pte_present(*pte) && !pte_exec(*pte))
> +		if (pte && pte_present(*pte) && !pte_exec(*pte)) {
>  			printk(KERN_CRIT "kernel tried to execute "
>  				"NX-protected page - exploit attempt? "
>  				"(uid: %d)\n", current_uid());
> +		}
>  	}
>  #endif
>  
> @@ -403,34 +442,45 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  		printk(KERN_CONT "NULL pointer dereference");
>  	else
>  		printk(KERN_CONT "paging request");
> +
>  	printk(KERN_CONT " at %p\n", (void *) address);
>  	printk(KERN_ALERT "IP:");
>  	printk_address(regs->ip, 1);
> +
>  	dump_pagetable(address);
>  }
>  
>  #ifdef CONFIG_X86_64
> -static noinline void pgtable_bad(struct pt_regs *regs,
> -			 unsigned long error_code, unsigned long address)
> +static noinline void
> +pgtable_bad(struct pt_regs *regs, unsigned long error_code,
> +	    unsigned long address)
>  {
> -	unsigned long flags = oops_begin();
> -	int sig = SIGKILL;
> -	struct task_struct *tsk = current;
> +	struct task_struct *tsk;
> +	unsigned long flags;
> +	int sig;
> +
> +	flags = oops_begin();
> +	tsk = current;
> +	sig = SIGKILL;
>  
>  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
>  	       tsk->comm, address);
>  	dump_pagetable(address);
> -	tsk->thread.cr2 = address;
> -	tsk->thread.trap_no = 14;
> -	tsk->thread.error_code = error_code;
> +
> +	tsk->thread.cr2		= address;
> +	tsk->thread.trap_no	= 14;
> +	tsk->thread.error_code	= error_code;
> +
>  	if (__die("Bad pagetable", regs, error_code))
>  		sig = 0;
> +
>  	oops_end(flags, regs, sig);
>  }
>  #endif
>  
> -static noinline void no_context(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address)
> +static noinline void
> +no_context(struct pt_regs *regs, unsigned long error_code,
> +	   unsigned long address)
>  {
>  	struct task_struct *tsk = current;
>  	unsigned long *stackend;
> @@ -440,18 +490,20 @@ static noinline void no_context(struct pt_regs *regs,
>  	int sig;
>  #endif
>  
> -	/* Are we prepared to handle this kernel fault?  */
> +	/* Are we prepared to handle this kernel fault? */
>  	if (fixup_exception(regs))
>  		return;
>  
>  	/*
> -	 * X86_32
> -	 * Valid to do another page fault here, because if this fault
> -	 * had been triggered by is_prefetch fixup_exception would have
> -	 * handled it.
> +	 * 32-bit:
> +	 *
> +	 *   Valid to do another page fault here, because if this fault
> +	 *   had been triggered by is_prefetch fixup_exception would have
> +	 *   handled it.
> +	 *
> +	 * 64-bit:
>  	 *
> -	 * X86_64
> -	 * Hall of shame of CPU/BIOS bugs.
> +	 *   Hall of shame of CPU/BIOS bugs.
>  	 */
>  	if (is_prefetch(regs, error_code, address))
>  		return;
> @@ -461,7 +513,7 @@ static noinline void no_context(struct pt_regs *regs,
>  
>  	/*
>  	 * Oops. The kernel tried to access some bad page. We'll have to
> -	 * terminate things with extreme prejudice.
> +	 * terminate things with extreme prejudice:
>  	 */
>  #ifdef CONFIG_X86_32
>  	bust_spinlocks(1);
> @@ -471,7 +523,7 @@ static noinline void no_context(struct pt_regs *regs,
>  
>  	show_fault_oops(regs, error_code, address);
>  
> - 	stackend = end_of_stack(tsk);
> +	stackend = end_of_stack(tsk);
>  	if (*stackend != STACK_END_MAGIC)
>  		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
>  
> @@ -487,28 +539,54 @@ static noinline void no_context(struct pt_regs *regs,
>  	sig = SIGKILL;
>  	if (__die("Oops", regs, error_code))
>  		sig = 0;
> +
>  	/* Executive summary in case the body of the oops scrolled away */
>  	printk(KERN_EMERG "CR2: %016lx\n", address);
> +
>  	oops_end(flags, regs, sig);
>  #endif
>  }
>  
> -static void __bad_area_nosemaphore(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address,
> -			int si_code)
> +/*
> + * Print out info about fatal segfaults, if the show_unhandled_signals
> + * sysctl is set:
> + */
> +static inline void
> +show_signal_msg(struct pt_regs *regs, unsigned long error_code,
> +		unsigned long address, struct task_struct *tsk)
> +{
> +	if (!unhandled_signal(tsk, SIGSEGV))
> +		return;
> +
> +	if (!printk_ratelimit())
> +		return;
> +
> +	printk(KERN_CONT "%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
> +		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
> +		tsk->comm, task_pid_nr(tsk), address,
> +		(void *)regs->ip, (void *)regs->sp, error_code);
> +
> +	print_vma_addr(KERN_CONT " in ", regs->ip);
> +
> +	printk(KERN_CONT "\n");
> +}
> +
> +static void
> +__bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
> +		       unsigned long address, int si_code)
>  {
>  	struct task_struct *tsk = current;
>  
>  	/* User mode accesses just cause a SIGSEGV */
>  	if (error_code & PF_USER) {
>  		/*
> -		 * It's possible to have interrupts off here.
> +		 * It's possible to have interrupts off here:
>  		 */
>  		local_irq_enable();
>  
>  		/*
>  		 * Valid to do another page fault here because this one came
> -		 * from user space.
> +		 * from user space:
>  		 */
>  		if (is_prefetch(regs, error_code, address))
>  			return;
> @@ -516,22 +594,16 @@ static void __bad_area_nosemaphore(struct pt_regs *regs,
>  		if (is_errata100(regs, address))
>  			return;
>  
> -		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
> -		    printk_ratelimit()) {
> -			printk(
> -			"%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
> -			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
> -			tsk->comm, task_pid_nr(tsk), address,
> -			(void *) regs->ip, (void *) regs->sp, error_code);
> -			print_vma_addr(" in ", regs->ip);
> -			printk("\n");
> -		}
> +		if (unlikely(show_unhandled_signals))
> +			show_signal_msg(regs, error_code, address, tsk);
> +
> +		/* Kernel addresses are always protection faults: */
> +		tsk->thread.cr2		= address;
> +		tsk->thread.error_code	= error_code | (address >= TASK_SIZE);
> +		tsk->thread.trap_no	= 14;
>  
> -		tsk->thread.cr2 = address;
> -		/* Kernel addresses are always protection faults */
> -		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
> -		tsk->thread.trap_no = 14;
>  		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
> +
>  		return;
>  	}
>  
> @@ -541,15 +613,16 @@ static void __bad_area_nosemaphore(struct pt_regs *regs,
>  	no_context(regs, error_code, address);
>  }
>  
> -static noinline void bad_area_nosemaphore(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address)
> +static noinline void
> +bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
> +		     unsigned long address)
>  {
>  	__bad_area_nosemaphore(regs, error_code, address, SEGV_MAPERR);
>  }
>  
> -static void __bad_area(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address,
> -			int si_code)
> +static void
> +__bad_area(struct pt_regs *regs, unsigned long error_code,
> +	   unsigned long address, int si_code)
>  {
>  	struct mm_struct *mm = current->mm;
>  
> @@ -562,67 +635,77 @@ static void __bad_area(struct pt_regs *regs,
>  	__bad_area_nosemaphore(regs, error_code, address, si_code);
>  }
>  
> -static noinline void bad_area(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address)
> +static noinline void
> +bad_area(struct pt_regs *regs, unsigned long error_code, unsigned long address)
>  {
>  	__bad_area(regs, error_code, address, SEGV_MAPERR);
>  }
>  
> -static noinline void bad_area_access_error(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address)
> +static noinline void
> +bad_area_access_error(struct pt_regs *regs, unsigned long error_code,
> +		      unsigned long address)
>  {
>  	__bad_area(regs, error_code, address, SEGV_ACCERR);
>  }
>  
>  /* TODO: fixup for "mm-invoke-oom-killer-from-page-fault.patch" */
> -static void out_of_memory(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address)
> +static void
> +out_of_memory(struct pt_regs *regs, unsigned long error_code,
> +	      unsigned long address)
>  {
>  	/*
>  	 * We ran out of memory, call the OOM killer, and return the userspace
> -	 * (which will retry the fault, or kill us if we got oom-killed).
> +	 * (which will retry the fault, or kill us if we got oom-killed):
>  	 */
>  	up_read(&current->mm->mmap_sem);
> +
>  	pagefault_out_of_memory();
>  }
>  
> -static void do_sigbus(struct pt_regs *regs,
> -			unsigned long error_code, unsigned long address)
> +static void
> +do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address)
>  {
>  	struct task_struct *tsk = current;
>  	struct mm_struct *mm = tsk->mm;
>  
>  	up_read(&mm->mmap_sem);
>  
> -	/* Kernel mode? Handle exceptions or die */
> +	/* Kernel mode? Handle exceptions or die: */
>  	if (!(error_code & PF_USER))
>  		no_context(regs, error_code, address);
> +
>  #ifdef CONFIG_X86_32
> -	/* User space => ok to do another page fault */
> +	/* User space => ok to do another page fault: */
>  	if (is_prefetch(regs, error_code, address))
>  		return;
>  #endif
> -	tsk->thread.cr2 = address;
> -	tsk->thread.error_code = error_code;
> -	tsk->thread.trap_no = 14;
> +
> +	tsk->thread.cr2		= address;
> +	tsk->thread.error_code	= error_code;
> +	tsk->thread.trap_no	= 14;
> +
>  	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
>  }
>  
> -static noinline void mm_fault_error(struct pt_regs *regs,
> -		unsigned long error_code, unsigned long address, unsigned int fault)
> +static noinline void
> +mm_fault_error(struct pt_regs *regs, unsigned long error_code,
> +	       unsigned long address, unsigned int fault)
>  {
> -	if (fault & VM_FAULT_OOM)
> +	if (fault & VM_FAULT_OOM) {
>  		out_of_memory(regs, error_code, address);
> -	else if (fault & VM_FAULT_SIGBUS)
> -		do_sigbus(regs, error_code, address);
> -	else
> -		BUG();
> +	} else {
> +		if (fault & VM_FAULT_SIGBUS)
> +			do_sigbus(regs, error_code, address);
> +		else
> +			BUG();
> +	}
>  }
>  
>  static int spurious_fault_check(unsigned long error_code, pte_t *pte)
>  {
>  	if ((error_code & PF_WRITE) && !pte_write(*pte))
>  		return 0;
> +
>  	if ((error_code & PF_INSTR) && !pte_exec(*pte))
>  		return 0;
>  
> @@ -630,16 +713,19 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
>  }
>  
>  /*
> - * Handle a spurious fault caused by a stale TLB entry.  This allows
> - * us to lazily refresh the TLB when increasing the permissions of a
> - * kernel page (RO -> RW or NX -> X).  Doing it eagerly is very
> - * expensive since that implies doing a full cross-processor TLB
> - * flush, even if no stale TLB entries exist on other processors.
> + * Handle a spurious fault caused by a stale TLB entry.
> + *
> + * This allows us to lazily refresh the TLB when increasing the
> + * permissions of a kernel page (RO -> RW or NX -> X).  Doing it
> + * eagerly is very expensive since that implies doing a full
> + * cross-processor TLB flush, even if no stale TLB entries exist
> + * on other processors.
> + *
>   * There are no security implications to leaving a stale TLB when
>   * increasing the permissions on a page.
>   */
> -static noinline int spurious_fault(unsigned long error_code,
> -				unsigned long address)
> +static noinline int
> +spurious_fault(unsigned long error_code, unsigned long address)
>  {
>  	pgd_t *pgd;
>  	pud_t *pud;
> @@ -678,20 +764,23 @@ static noinline int spurious_fault(unsigned long error_code,
>  		return 0;
>  
>  	/*
> -	 * Make sure we have permissions in PMD
> -	 * If not, then there's a bug in the page tables.
> +	 * Make sure we have permissions in PMD.
> +	 * If not, then there's a bug in the page tables:
>  	 */
>  	ret = spurious_fault_check(error_code, (pte_t *) pmd);
>  	WARN_ONCE(!ret, "PMD has incorrect permission bits\n");
> +
>  	return ret;
>  }
>  
>  /*
> - * X86_32
> - * Handle a fault on the vmalloc or module mapping area
> + * 32-bit:
> + *
> + *   Handle a fault on the vmalloc or module mapping area
>   *
> - * X86_64
> - * Handle a fault on the vmalloc area
> + * 64-bit:
> + *
> + *   Handle a fault on the vmalloc area
>   *
>   * This assumes no large pages in there.
>   */
> @@ -702,7 +791,7 @@ static noinline int vmalloc_fault(unsigned long address)
>  	pmd_t *pmd_k;
>  	pte_t *pte_k;
>  
> -	/* Make sure we are in vmalloc area */
> +	/* Make sure we are in vmalloc area: */
>  	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>  		return -1;
>  
> @@ -717,9 +806,11 @@ static noinline int vmalloc_fault(unsigned long address)
>  	pmd_k = vmalloc_sync_one(__va(pgd_paddr), address);
>  	if (!pmd_k)
>  		return -1;
> +
>  	pte_k = pte_offset_kernel(pmd_k, address);
>  	if (!pte_present(*pte_k))
>  		return -1;
> +
>  	return 0;
>  #else
>  	pgd_t *pgd, *pgd_ref;
> @@ -727,69 +818,84 @@ static noinline int vmalloc_fault(unsigned long address)
>  	pmd_t *pmd, *pmd_ref;
>  	pte_t *pte, *pte_ref;
>  
> -	/* Make sure we are in vmalloc area */
> +	/* Make sure we are in vmalloc area: */
>  	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>  		return -1;
>  
> -	/* Copy kernel mappings over when needed. This can also
> -	   happen within a race in page table update. In the later
> -	   case just flush. */
> -
> +	/*
> +	 * Copy kernel mappings over when needed. This can also
> +	 * happen within a race in page table update. In the later
> +	 * case just flush:
> +	 */
>  	pgd = pgd_offset(current->active_mm, address);
>  	pgd_ref = pgd_offset_k(address);
>  	if (pgd_none(*pgd_ref))
>  		return -1;
> +
>  	if (pgd_none(*pgd))
>  		set_pgd(pgd, *pgd_ref);
>  	else
>  		BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
>  
> -	/* Below here mismatches are bugs because these lower tables
> -	   are shared */
> +	/*
> +	 * Below here mismatches are bugs because these lower tables
> +	 * are shared:
> +	 */
>  
>  	pud = pud_offset(pgd, address);
>  	pud_ref = pud_offset(pgd_ref, address);
>  	if (pud_none(*pud_ref))
>  		return -1;
> +
>  	if (pud_none(*pud) || pud_page_vaddr(*pud) != pud_page_vaddr(*pud_ref))
>  		BUG();
> +
>  	pmd = pmd_offset(pud, address);
>  	pmd_ref = pmd_offset(pud_ref, address);
>  	if (pmd_none(*pmd_ref))
>  		return -1;
> +
>  	if (pmd_none(*pmd) || pmd_page(*pmd) != pmd_page(*pmd_ref))
>  		BUG();
> +
>  	pte_ref = pte_offset_kernel(pmd_ref, address);
>  	if (!pte_present(*pte_ref))
>  		return -1;
> +
>  	pte = pte_offset_kernel(pmd, address);
> -	/* Don't use pte_page here, because the mappings can point
> -	   outside mem_map, and the NUMA hash lookup cannot handle
> -	   that. */
> +
> +	/*
> +	 * Don't use pte_page here, because the mappings can point
> +	 * outside mem_map, and the NUMA hash lookup cannot handle
> +	 * that:
> +	 */
>  	if (!pte_present(*pte) || pte_pfn(*pte) != pte_pfn(*pte_ref))
>  		BUG();
> +
>  	return 0;
>  #endif
>  }
>  
>  int show_unhandled_signals = 1;
>  
> -static inline int access_error(unsigned long error_code, int write,
> -				struct vm_area_struct *vma)
> +static inline int
> +access_error(unsigned long error_code, int write, struct vm_area_struct *vma)
>  {
>  	if (write) {
> -		/* write, present and write, not present */
> +		/* write, present and write, not present: */
>  		if (unlikely(!(vma->vm_flags & VM_WRITE)))
>  			return 1;
> -	} else if (unlikely(error_code & PF_PROT)) {
> -		/* read, present */
> -		return 1;
> -	} else {
> -		/* read, not present */
> -		if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
> -			return 1;
> +		return 0;
>  	}
>  
> +	/* read, present: */
> +	if (unlikely(error_code & PF_PROT))
> +		return 1;
> +
> +	/* read, not present: */
> +	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
> +		return 1;
> +
>  	return 0;
>  }
>  
> @@ -797,9 +903,9 @@ static int fault_in_kernel_space(unsigned long address)
>  {
>  #ifdef CONFIG_X86_32
>  	return address >= TASK_SIZE;
> -#else /* !CONFIG_X86_32 */
> +#else
>  	return address >= TASK_SIZE64;
> -#endif /* CONFIG_X86_32 */
> +#endif
>  }
>  
>  /*
> @@ -812,18 +918,19 @@ asmlinkage
>  #endif
>  void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
> -	unsigned long address;
> +	struct vm_area_struct *vma;
>  	struct task_struct *tsk;
> +	unsigned long address;
>  	struct mm_struct *mm;
> -	struct vm_area_struct *vma;
>  	int write;
>  	int fault;
>  
>  	tsk = current;
>  	mm = tsk->mm;
> +
>  	prefetchw(&mm->mmap_sem);
>  
> -	/* get the address */
> +	/* Get the faulting address: */
>  	address = read_cr2();
>  
>  	if (unlikely(kmmio_fault(regs, address)))
> @@ -847,22 +954,23 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		    vmalloc_fault(address) >= 0)
>  			return;
>  
> -		/* Can handle a stale RO->RW TLB */
> +		/* Can handle a stale RO->RW TLB: */
>  		if (spurious_fault(error_code, address))
>  			return;
>  
> -		/* kprobes don't want to hook the spurious faults. */
> +		/* kprobes don't want to hook the spurious faults: */
>  		if (notify_page_fault(regs))
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> -		 * fault we could otherwise deadlock.
> +		 * fault we could otherwise deadlock:
>  		 */
>  		bad_area_nosemaphore(regs, error_code, address);
> +
>  		return;
>  	}
>  
> -	/* kprobes don't want to hook the spurious faults. */
> +	/* kprobes don't want to hook the spurious faults: */
>  	if (unlikely(notify_page_fault(regs)))
>  		return;
>  	/*
> @@ -870,13 +978,15 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	 * vmalloc fault has been handled.
>  	 *
>  	 * User-mode registers count as a user access even for any
> -	 * potential system fault or CPU buglet.
> +	 * potential system fault or CPU buglet:
>  	 */
>  	if (user_mode_vm(regs)) {
>  		local_irq_enable();
>  		error_code |= PF_USER;
> -	} else if (regs->flags & X86_EFLAGS_IF)
> -		local_irq_enable();
> +	} else {
> +		if (regs->flags & X86_EFLAGS_IF)
> +			local_irq_enable();
> +	}
>  
>  #ifdef CONFIG_X86_64
>  	if (unlikely(error_code & PF_RSVD))
> @@ -884,8 +994,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  #endif
>  
>  	/*
> -	 * If we're in an interrupt, have no user context or are running in an
> -	 * atomic region then we must not take the fault.
> +	 * If we're in an interrupt, have no user context or are running
> +	 * in an atomic region then we must not take the fault:
>  	 */
>  	if (unlikely(in_atomic() || !mm)) {
>  		bad_area_nosemaphore(regs, error_code, address);
> @@ -894,19 +1004,19 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  
>  	/*
>  	 * When running in the kernel we expect faults to occur only to
> -	 * addresses in user space.  All other faults represent errors in the
> -	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
> -	 * erroneous fault occurring in a code path which already holds mmap_sem
> -	 * we will deadlock attempting to validate the fault against the
> -	 * address space.  Luckily the kernel only validly references user
> -	 * space from well defined areas of code, which are listed in the
> -	 * exceptions table.
> +	 * addresses in user space.  All other faults represent errors in
> +	 * the kernel and should generate an OOPS.  Unfortunately, in the
> +	 * case of an erroneous fault occurring in a code path which already
> +	 * holds mmap_sem we will deadlock attempting to validate the fault
> +	 * against the address space.  Luckily the kernel only validly
> +	 * references user space from well defined areas of code, which are
> +	 * listed in the exceptions table.
>  	 *
>  	 * As the vast majority of faults will be valid we will only perform
> -	 * the source reference check when there is a possibility of a deadlock.
> -	 * Attempt to lock the address space, if we cannot we then validate the
> -	 * source.  If this is invalid we can skip the address space check,
> -	 * thus avoiding the deadlock.
> +	 * the source reference check when there is a possibility of a
> +	 * deadlock. Attempt to lock the address space, if we cannot we then
> +	 * validate the source. If this is invalid we can skip the address
> +	 * space check, thus avoiding the deadlock:
>  	 */
>  	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
>  		if ((error_code & PF_USER) == 0 &&
> @@ -917,8 +1027,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		down_read(&mm->mmap_sem);
>  	} else {
>  		/*
> -		 * The above down_read_trylock() might have succeeded in which
> -		 * case we'll have missed the might_sleep() from down_read().
> +		 * The above down_read_trylock() might have succeeded in
> +		 * which case we'll have missed the might_sleep() from
> +		 * down_read():
>  		 */
>  		might_sleep();
>  	}
> @@ -938,7 +1049,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		/*
>  		 * Accessing the stack below %sp is always a bug.
>  		 * The large cushion allows instructions like enter
> -		 * and pusha to work.  ("enter $65535,$31" pushes
> +		 * and pusha to work. ("enter $65535, $31" pushes
>  		 * 32 pointers and then decrements %sp by 65535.)
>  		 */
>  		if (unlikely(address + 65536 + 32 * sizeof(unsigned long) < regs->sp)) {
> @@ -957,6 +1068,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	 */
>  good_area:
>  	write = error_code & PF_WRITE;
> +
>  	if (unlikely(access_error(error_code, write, vma))) {
>  		bad_area_access_error(regs, error_code, address);
>  		return;
> @@ -965,13 +1077,15 @@ good_area:
>  	/*
>  	 * If for any reason at all we couldn't handle the fault,
>  	 * make sure we exit gracefully rather than endlessly redo
> -	 * the fault.
> +	 * the fault:
>  	 */
>  	fault = handle_mm_fault(mm, vma, address, write);
> +
>  	if (unlikely(fault & VM_FAULT_ERROR)) {
>  		mm_fault_error(regs, error_code, address, fault);
>  		return;
>  	}
> +
>  	if (fault & VM_FAULT_MAJOR)
>  		tsk->maj_flt++;
>  	else
> @@ -1004,13 +1118,13 @@ void vmalloc_sync_all(void)
>  	for (address = VMALLOC_START & PMD_MASK;
>  	     address >= TASK_SIZE && address < FIXADDR_TOP;
>  	     address += PMD_SIZE) {
> +
>  		unsigned long flags;
>  		struct page *page;
>  
>  		spin_lock_irqsave(&pgd_lock, flags);
>  		list_for_each_entry(page, &pgd_list, lru) {
> -			if (!vmalloc_sync_one(page_address(page),
> -					      address))
> +			if (!vmalloc_sync_one(page_address(page), address))
>  				break;
>  		}
>  		spin_unlock_irqrestore(&pgd_lock, flags);
> @@ -1018,12 +1132,14 @@ void vmalloc_sync_all(void)
>  #else /* CONFIG_X86_64 */
>  	for (address = VMALLOC_START & PGDIR_MASK; address <= VMALLOC_END;
>  	     address += PGDIR_SIZE) {
> +
>  		const pgd_t *pgd_ref = pgd_offset_k(address);
>  		unsigned long flags;
>  		struct page *page;
>  
>  		if (pgd_none(*pgd_ref))
>  			continue;
> +
>  		spin_lock_irqsave(&pgd_lock, flags);
>  		list_for_each_entry(page, &pgd_list, lru) {
>  			pgd_t *pgd;
