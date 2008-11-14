Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbYKNBYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbYKNBYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbYKNBWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:22:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404AbYKNBW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:22:27 -0500
Date: Fri, 14 Nov 2008 02:22:24 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081114012224.GB5063@wotan.suse.de>
References: <20081113072821.GB2946@wotan.suse.de> <20081113074109.GB1723@elte.hu> <20081113075022.GC2946@wotan.suse.de> <20081113080247.GA21144@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113080247.GA21144@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 09:02:47AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > [...] The comment was actually just in relation to my oom-killer 
> > page fault patches that are in -mm. I'm not proposing this for merge 
> > just yet, but will wait for Andrew.
> 
> We definitely want to carry and test this in the x86 tree, so we 
> should either move the x86 bits of your oom-killer page fault patches 
> from -mm into the x86 tree - or (if that's not possible due to 
> cross-arch impact) this patch should be rebased to -git and the 
> oom-killer patches based ontop of that.

The thing is that the oom killer patches solve more of a pressing
problem (that oom from page faults doesn't obey any of our oom
heuristics eg. panic_on_oom or never-kill-this-task, which can cause
things to not failover properly, or X to get killed etc etc.)

So I definitely want that patch in... this patch OTOH is great, but
nobody is actually going to notice, seriously. It is simply
something that we should all be doing all the time, and once 1000
such patches are merged then the kernel might be 1% faster :)

Trust me, there is no shortage of fastpaths that are stupidly bloated
in Linux. Just from gcc being smart, and people not watching the
generated code :)

 
> Below is a first (completely untested!) raw attempt at porting your 
> patch to -git. (I resolved a good deal of conflicts without testing 
> the end result, so take care.)
> 
> 	Ingo
> 
> ---------------->
> Subject: x86: optimise page fault path a little
> From: Nick Piggin <npiggin@suse.de>
> Date: Thu, 13 Nov 2008 08:28:21 +0100
> 
> I was just looking around the page fault code for any obvious performance
> improvements. I noticed do_page_fault is rather big, uses a lot of stack,
> and generates some branch mispredicts.
> 
> It's only about 1.1% on the profile of the workload I'm looking at, so my
> improvement is pretty close to in the noise, but I wonder if micro
> optimisations like the following would be welcome?
> 
> This patch adds branch hints and moves error condition code out of line.
> It shrinks do_page_fault from 2410 bytes to 603 bytes, and from 352 to 64
> bytes of stack. Total text size does grow by about 500 bytes due to the
> additional functions added.
> 
> ---
>  arch/x86/mm/fault.c |  439 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 251 insertions(+), 188 deletions(-)
> 
> Index: tip/arch/x86/mm/fault.c
> ===================================================================
> --- tip.orig/arch/x86/mm/fault.c
> +++ tip/arch/x86/mm/fault.c
> @@ -93,8 +93,8 @@ static inline int notify_page_fault(stru
>   *
>   * Opcode checker based on code by Richard Brunner
>   */
> -static int is_prefetch(struct pt_regs *regs, unsigned long addr,
> -		       unsigned long error_code)
> +static int is_prefetch(struct pt_regs *regs, unsigned long error_code,
> +			unsigned long addr)
>  {
>  	unsigned char *instr;
>  	int scan_more = 1;
> @@ -411,17 +411,16 @@ static void show_fault_oops(struct pt_re
>  }
>  
>  #ifdef CONFIG_X86_64
> -static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
> -				 unsigned long error_code)
> +static noinline void pgtable_bad(struct pt_regs *regs,
> +			 unsigned long error_code, unsigned long address)
>  {
>  	unsigned long flags = oops_begin();
>  	int sig = SIGKILL;
> -	struct task_struct *tsk;
> +	struct task_struct *tsk = current;
>  
>  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
> -	       current->comm, address);
> +	       tsk->comm, address);
>  	dump_pagetable(address);
> -	tsk = current;
>  	tsk->thread.cr2 = address;
>  	tsk->thread.trap_no = 14;
>  	tsk->thread.error_code = error_code;
> @@ -431,6 +430,197 @@ static noinline void pgtable_bad(unsigne
>  }
>  #endif
>  
> +static noinline void no_context(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	struct task_struct *tsk = current;
> +#ifdef CONFIG_X86_64
> +	unsigned long flags;
> +#endif
> +
> +	/* Are we prepared to handle this kernel fault?  */
> +	if (fixup_exception(regs))
> +		return;
> +
> +	/*
> +	 * X86_32
> +	 * Valid to do another page fault here, because if this fault
> +	 * had been triggered by is_prefetch fixup_exception would have
> +	 * handled it.
> +	 *
> +	 * X86_64
> +	 * Hall of shame of CPU/BIOS bugs.
> +	 */
> +	if (is_prefetch(regs, error_code, address))
> +		return;
> +
> +	if (is_errata93(regs, address))
> +		return;
> +
> +	/*
> +	 * Oops. The kernel tried to access some bad page. We'll have to
> +	 * terminate things with extreme prejudice.
> +	 */
> +#ifdef CONFIG_X86_32
> +	bust_spinlocks(1);
> +#else
> +	flags = oops_begin();
> +#endif
> +
> +	show_fault_oops(regs, error_code, address);
> +
> +	tsk->thread.cr2 = address;
> +	tsk->thread.trap_no = 14;
> +	tsk->thread.error_code = error_code;
> +
> +#ifdef CONFIG_X86_32
> +	die("Oops", regs, error_code);
> +	bust_spinlocks(0);
> +	do_exit(SIGKILL);
> +#else
> +	if (__die("Oops", regs, error_code))
> +		regs = NULL;
> +	/* Executive summary in case the body of the oops scrolled away */
> +	printk(KERN_EMERG "CR2: %016lx\n", address);
> +	oops_end(flags, regs, SIGKILL);
> +#endif
> +}
> +
> +static void __bad_area_nosemaphore(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address,
> +			int si_code)
> +{
> +	struct task_struct *tsk = current;
> +
> +	/* User mode accesses just cause a SIGSEGV */
> +	if (error_code & PF_USER) {
> +		/*
> +		 * It's possible to have interrupts off here.
> +		 */
> +		local_irq_enable();
> +
> +		/*
> +		 * Valid to do another page fault here because this one came
> +		 * from user space.
> +		 */
> +		if (is_prefetch(regs, error_code, address))
> +			return;
> +
> +		if (is_errata100(regs, address))
> +			return;
> +
> +		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
> +		    printk_ratelimit()) {
> +			printk(
> +			"%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
> +			task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
> +			tsk->comm, task_pid_nr(tsk), address,
> +			(void *) regs->ip, (void *) regs->sp, error_code);
> +			print_vma_addr(" in ", regs->ip);
> +			printk("\n");
> +		}
> +
> +		tsk->thread.cr2 = address;
> +		/* Kernel addresses are always protection faults */
> +		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
> +		tsk->thread.trap_no = 14;
> +		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
> +		return;
> +	}
> +
> +	if (is_f00f_bug(regs, address))
> +		return;
> +
> +	no_context(regs, error_code, address);
> +}
> +
> +static noinline void bad_area_nosemaphore(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	__bad_area_nosemaphore(regs, error_code, address, SEGV_MAPERR);
> +}
> +
> +static void __bad_area(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address,
> +			int si_code)
> +{
> +	struct mm_struct *mm = current->mm;
> +
> +	/*
> +	 * Something tried to access memory that isn't in our memory map..
> +	 * Fix it, but check if it's kernel or user first..
> +	 */
> +	up_read(&mm->mmap_sem);
> +
> +	__bad_area_nosemaphore(regs, error_code, address, si_code);
> +}
> +
> +static noinline void bad_area(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	__bad_area(regs, error_code, address, SEGV_MAPERR);
> +}
> +
> +static noinline void bad_area_accerr(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	__bad_area(regs, error_code, address, SEGV_ACCERR);
> +}
> +
> +static void out_of_memory(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	struct task_struct *tsk = current;
> +	struct mm_struct *mm = tsk->mm;
> +	/*
> +	 * We ran out of memory, or some other thing happened to us that made
> +	 * us unable to handle the page fault gracefully.
> +	 */
> +	up_read(&mm->mmap_sem);
> +	if (is_global_init(tsk)) {
> +		yield();
> +		return;
> +	}
> +
> +	printk("VM: killing process %s\n", tsk->comm);
> +	if (error_code & PF_USER)
> +		do_group_exit(SIGKILL);
> +	no_context(regs, error_code, address);
> +}
> +
> +static void do_sigbus(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	struct task_struct *tsk = current;
> +	struct mm_struct *mm = tsk->mm;
> +
> +	up_read(&mm->mmap_sem);
> +
> +	/* Kernel mode? Handle exceptions or die */
> +	if (!(error_code & PF_USER))
> +		no_context(regs, error_code, address);
> +#ifdef CONFIG_X86_32
> +	/* User space => ok to do another page fault */
> +	if (is_prefetch(regs, error_code, address))
> +		return;
> +#endif
> +	tsk->thread.cr2 = address;
> +	tsk->thread.error_code = error_code;
> +	tsk->thread.trap_no = 14;
> +	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
> +}
> +
> +static noinline void mm_fault_error(struct pt_regs *regs,
> +		unsigned long error_code, unsigned long address, unsigned int fault)
> +{
> +	if (fault & VM_FAULT_OOM)
> +		out_of_memory(regs, error_code, address);
> +	else if (fault & VM_FAULT_SIGBUS)
> +		do_sigbus(regs, error_code, address);
> +	else
> +		BUG();
> +}
> +
>  static int spurious_fault_check(unsigned long error_code, pte_t *pte)
>  {
>  	if ((error_code & PF_WRITE) && !pte_write(*pte))
> @@ -450,8 +640,8 @@ static int spurious_fault_check(unsigned
>   * There are no security implications to leaving a stale TLB when
>   * increasing the permissions on a page.
>   */
> -static int spurious_fault(unsigned long address,
> -			  unsigned long error_code)
> +static noinline int spurious_fault(unsigned long error_code,
> +				unsigned long address)
>  {
>  	pgd_t *pgd;
>  	pud_t *pud;
> @@ -496,7 +686,7 @@ static int spurious_fault(unsigned long 
>   *
>   * This assumes no large pages in there.
>   */
> -static int vmalloc_fault(unsigned long address)
> +static noinline int vmalloc_fault(unsigned long address)
>  {
>  #ifdef CONFIG_X86_32
>  	unsigned long pgd_paddr;
> @@ -585,18 +775,15 @@ asmlinkage
>  #endif
>  void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
> +	unsigned long address;
>  	struct task_struct *tsk;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	unsigned long address;
>  	int write, si_code;
>  	int fault;
>  	unsigned long *stackend;
>  
> -#ifdef CONFIG_X86_64
> -	unsigned long flags;
>  	int sig;
> -#endif
>  
>  	tsk = current;
>  	mm = tsk->mm;
> @@ -614,7 +801,7 @@ void __kprobes do_page_fault(struct pt_r
>  	if(kmemcheck_active(regs))
>  		kmemcheck_hide(regs);
>  
> -	if (notify_page_fault(regs))
> +	if (unlikely(notify_page_fault(regs)))
>  		return;
>  	if (unlikely(kmmio_fault(regs, address)))
>  		return;
> @@ -653,7 +840,8 @@ void __kprobes do_page_fault(struct pt_r
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
>  		 * fault we could otherwise deadlock.
>  		 */
> -		goto bad_area_nosemaphore;
> +		bad_area_nosemaphore(regs, error_code, address);
> +		return;
>  	}
>  
>  
> @@ -672,17 +860,18 @@ void __kprobes do_page_fault(struct pt_r
>  
>  #ifdef CONFIG_X86_64
>  	if (unlikely(error_code & PF_RSVD))
> -		pgtable_bad(address, regs, error_code);
> +		pgtable_bad(regs, error_code, address);
>  #endif
>  
>  	/*
>  	 * If we're in an interrupt, have no user context or are running in an
>  	 * atomic region then we must not take the fault.
>  	 */
> -	if (unlikely(in_atomic() || !mm))
> -		goto bad_area_nosemaphore;
> +	if (unlikely(in_atomic() || !mm)) {
> +		bad_area_nosemaphore(regs, error_code, address);
> +		return;
> +	}
>  
> -again:
>  	/*
>  	 * When running in the kernel we expect faults to occur only to
>  	 * addresses in user space.  All other faults represent errors in the
> @@ -699,20 +888,26 @@ again:
>  	 * source.  If this is invalid we can skip the address space check,
>  	 * thus avoiding the deadlock.
>  	 */
> -	if (!down_read_trylock(&mm->mmap_sem)) {
> +	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
>  		if ((error_code & PF_USER) == 0 &&
> -		    !search_exception_tables(regs->ip))
> -			goto bad_area_nosemaphore;
> +		    !search_exception_tables(regs->ip)) {
> +			bad_area_nosemaphore(regs, error_code, address);
> +			return;
> +		}
>  		down_read(&mm->mmap_sem);
>  	}
>  
>  	vma = find_vma(mm, address);
> -	if (!vma)
> -		goto bad_area;
> -	if (vma->vm_start <= address)
> +	if (unlikely(!vma)) {
> +		bad_area(regs, error_code, address);
> +		return;
> +	}
> +	if (likely(vma->vm_start <= address))
>  		goto good_area;
> -	if (!(vma->vm_flags & VM_GROWSDOWN))
> -		goto bad_area;
> +	if (unlikely(!(vma->vm_flags & VM_GROWSDOWN))) {
> +		bad_area(regs, error_code, address);
> +		return;
> +	}
>  	if (error_code & PF_USER) {
>  		/*
>  		 * Accessing the stack below %sp is always a bug.
> @@ -720,31 +915,34 @@ again:
>  		 * and pusha to work.  ("enter $65535,$31" pushes
>  		 * 32 pointers and then decrements %sp by 65535.)
>  		 */
> -		if (address + 65536 + 32 * sizeof(unsigned long) < regs->sp)
> -			goto bad_area;
> +		if (unlikely(address + 65536 + 32 * sizeof(unsigned long) < regs->sp)) {
> +			bad_area(regs, error_code, address);
> +			return;
> +		}
>  	}
> -	if (expand_stack(vma, address))
> -		goto bad_area;
> -/*
> - * Ok, we have a good vm_area for this memory access, so
> - * we can handle it..
> - */
> +	if (unlikely(expand_stack(vma, address))) {
> +		bad_area(regs, error_code, address);
> +		return;
> +	}
> +
> +	/*
> +	 * Ok, we have a good vm_area for this memory access, so
> +	 * we can handle it..
> +	 */
>  good_area:
>  	si_code = SEGV_ACCERR;
> -	write = 0;
> -	switch (error_code & (PF_PROT|PF_WRITE)) {
> -	default:	/* 3: write, present */
> -		/* fall through */
> -	case PF_WRITE:		/* write, not present */
> -		if (!(vma->vm_flags & VM_WRITE))
> -			goto bad_area;
> -		write++;
> -		break;
> -	case PF_PROT:		/* read, present */
> -		goto bad_area;
> -	case 0:			/* read, not present */
> -		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
> -			goto bad_area;
> +	write = error_code & PF_WRITE;
> +	if (write) {
> +		if (unlikely(!(vma->vm_flags & VM_WRITE))) {
> +			bad_area_accerr(regs, error_code, address);
> +			return;
> +		}
> +	} else if (unlikely(error_code & PF_PROT)) {
> +		bad_area_accerr(regs, error_code, address);
> +		return;
> +	} else if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))) {
> +		bad_area_accerr(regs, error_code, address);
> +		return;
>  	}
>  
>  	/*
> @@ -754,11 +952,8 @@ good_area:
>  	 */
>  	fault = handle_mm_fault(mm, vma, address, write);
>  	if (unlikely(fault & VM_FAULT_ERROR)) {
> -		if (fault & VM_FAULT_OOM)
> -			goto out_of_memory;
> -		else if (fault & VM_FAULT_SIGBUS)
> -			goto do_sigbus;
> -		BUG();
> +		mm_fault_error(regs, error_code, address, fault);
> +		return;
>  	}
>  	if (fault & VM_FAULT_MAJOR)
>  		tsk->maj_flt++;
> @@ -769,150 +964,18 @@ good_area:
>  	/*
>  	 * Did it hit the DOS screen memory VA from vm86 mode?
>  	 */
> -	if (v8086_mode(regs)) {
> +	if (unlikely(v8086_mode(regs))) {
>  		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
>  		if (bit < 32)
>  			tsk->thread.screen_bitmap |= 1 << bit;
>  	}
>  #endif
>  	up_read(&mm->mmap_sem);
> -	return;
> -
> -/*
> - * Something tried to access memory that isn't in our memory map..
> - * Fix it, but check if it's kernel or user first..
> - */
> -bad_area:
> -	up_read(&mm->mmap_sem);
> -
> -bad_area_nosemaphore:
> -	/* User mode accesses just cause a SIGSEGV */
> -	if (error_code & PF_USER) {
> -		/*
> -		 * It's possible to have interrupts off here.
> -		 */
> -		local_irq_enable();
> -
> -		/*
> -		 * Valid to do another page fault here because this one came
> -		 * from user space.
> -		 */
> -		if (is_prefetch(regs, address, error_code))
> -			return;
> -
> -		if (is_errata100(regs, address))
> -			return;
> -
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
> -
> -		tsk->thread.cr2 = address;
> -		/* Kernel addresses are always protection faults */
> -		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
> -		tsk->thread.trap_no = 14;
> -		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
> -		return;
> -	}
> -
> -	if (is_f00f_bug(regs, address))
> -		return;
> -
> -no_context:
> -	/* Are we prepared to handle this kernel fault?  */
> -	if (fixup_exception(regs))
> -		return;
> -
> -	/*
> -	 * X86_32
> -	 * Valid to do another page fault here, because if this fault
> -	 * had been triggered by is_prefetch fixup_exception would have
> -	 * handled it.
> -	 *
> -	 * X86_64
> -	 * Hall of shame of CPU/BIOS bugs.
> -	 */
> -	if (is_prefetch(regs, address, error_code))
> -		return;
> -
> -	if (is_errata93(regs, address))
> -		return;
> -
> -/*
> - * Oops. The kernel tried to access some bad page. We'll have to
> - * terminate things with extreme prejudice.
> - */
> -#ifdef CONFIG_X86_32
> -	bust_spinlocks(1);
> -#else
> -	flags = oops_begin();
> -#endif
> -
> -	show_fault_oops(regs, error_code, address);
> -
>   	stackend = end_of_stack(tsk);
>  	if (*stackend != STACK_END_MAGIC)
>  		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
>  
> -	tsk->thread.cr2 = address;
> -	tsk->thread.trap_no = 14;
> -	tsk->thread.error_code = error_code;
> -
> -#ifdef CONFIG_X86_32
> -	die("Oops", regs, error_code);
> -	bust_spinlocks(0);
> -	do_exit(SIGKILL);
> -#else
>  	sig = SIGKILL;
> -	if (__die("Oops", regs, error_code))
> -		sig = 0;
> -	/* Executive summary in case the body of the oops scrolled away */
> -	printk(KERN_EMERG "CR2: %016lx\n", address);
> -	oops_end(flags, regs, sig);
> -#endif
> -
> -/*
> - * We ran out of memory, or some other thing happened to us that made
> - * us unable to handle the page fault gracefully.
> - */
> -out_of_memory:
> -	up_read(&mm->mmap_sem);
> -	if (is_global_init(tsk)) {
> -		yield();
> -		/*
> -		 * Re-lookup the vma - in theory the vma tree might
> -		 * have changed:
> -		 */
> -		goto again;
> -	}
> -
> -	printk("VM: killing process %s\n", tsk->comm);
> -	if (error_code & PF_USER)
> -		do_group_exit(SIGKILL);
> -	goto no_context;
> -
> -do_sigbus:
> -	up_read(&mm->mmap_sem);
> -
> -	/* Kernel mode? Handle exceptions or die */
> -	if (!(error_code & PF_USER))
> -		goto no_context;
> -#ifdef CONFIG_X86_32
> -	/* User space => ok to do another page fault */
> -	if (is_prefetch(regs, address, error_code))
> -		return;
> -#endif
> -	tsk->thread.cr2 = address;
> -	tsk->thread.error_code = error_code;
> -	tsk->thread.trap_no = 14;
> -	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
>  }
>  
>  DEFINE_SPINLOCK(pgd_lock);
