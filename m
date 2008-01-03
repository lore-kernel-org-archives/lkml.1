Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYACBqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYACBqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYACBp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:45:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:38427 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYACBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=r6COaOyGW2f6tC2Lmy8VARTP064j3i82HOSb6jL4FX3C5ng4SLLPjhHXdQxwUvifIf/wk1DbHEEwpECHPpz2tGYqnd1lpVG/xMxcEYqqTRjo0XbkIkzwz1EyAQct9317U3Ky4dasTPdDaE2JrxhRyROXo/fW4Js7AJXH65dyxb0=
Date: Thu, 3 Jan 2008 04:45:50 +0300
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fault_{32|64}.c unify do_page_fault
Message-ID: <20080103014550.GA7377@martell.zuzino.mipt.ru>
References: <1199322063.6323.72.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199322063.6323.72.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 05:01:02PM -0800, Harvey Harrison wrote:
> Begin to unify do_page_fault(), easy code movement first.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Ingo, similar to the kprobes unification patches I did, it gets a bit
> uglier before it gets better ;-)
> 
>  arch/x86/mm/fault_32.c |   38 +++++++++++++++++++++++++++++---------
>  arch/x86/mm/fault_64.c |   23 ++++++++++++++++++-----
>  2 files changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
> index b1893eb..051a4ec 100644
> --- a/arch/x86/mm/fault_32.c
> +++ b/arch/x86/mm/fault_32.c
> @@ -375,19 +375,26 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
>  	unsigned long address;
> -	int write, si_code;
> -	int fault;
> +	int write, fault;
> +#ifdef CONFIG_x86_64

There is no such thing as CONFIG_x86_64 .

Do you seriously think code is getting better and more readable because
of this liberal #ifdef sprinkling in every possible direction?

> +	unsigned long flags;
> +#endif

One.

> +	int si_code;
>  
>  	/*
>  	 * We can fault from pretty much anywhere, with unknown IRQ state.
>  	 */
>  	trace_hardirqs_fixup();
>  
> -	/* get the address */
> -	address = read_cr2();
> -
>  	tsk = current;
> +	mm = tsk->mm;
>  
> +#ifdef CONFIG_x86_64
> +	prefetchw(&mm->mmap_sem);
> +#endif

Two.

> +
> +	/* get the address */
> +	address = read_cr2();
>  	si_code = SEGV_MAPERR;
>  
>  	/*
> @@ -403,9 +410,24 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	 * (error_code & 4) == 0, and that the fault was not a
>  	 * protection error (error_code & 9) == 0.
>  	 */
> +#ifdef CONFIG_X86_32
>  	if (unlikely(address >= TASK_SIZE)) {
> -		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
> +		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
> +		    vmalloc_fault(address) >= 0)
>  			return;
> +#else
> +	if (unlikely(address >= TASK_SIZE64)) {
> +		/*
> +		 * Don't check for the module range here: its PML4
> +		 * is always initialized because it's shared with the main
> +		 * kernel text. Only vmalloc may need PML4 syncups.
> +		 */
> +		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
> +		      ((address >= VMALLOC_START && address < VMALLOC_END))) {
> +			if (vmalloc_fault(address) >= 0)
> +				return;
> +		}
> +#endif

Three.

>  		if (notify_page_fault(regs))
>  			return;
>  		/*
> @@ -423,8 +445,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
>  		local_irq_enable();
>  
> -	mm = tsk->mm;
> -
>  	/*
>  	 * If we're in an interrupt, have no user context or are running in an
>  	 * atomic region then we must not take the fault.
> @@ -495,7 +515,7 @@ good_area:
>  			goto bad_area;
>  	}
>  
> - survive:
> +survive:
>  	/*
>  	 * If for any reason at all we couldn't handle the fault,
>  	 * make sure we exit gracefully rather than endlessly redo
> diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
> index 357a3e0..97b92b6 100644
> --- a/arch/x86/mm/fault_64.c
> +++ b/arch/x86/mm/fault_64.c
> @@ -426,7 +426,9 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  	struct vm_area_struct *vma;
>  	unsigned long address;
>  	int write, fault;
> +#ifdef CONFIG_x86_64
>  	unsigned long flags;
> +#endif

Four.

>  	int si_code;
>  
>  	/*
> @@ -436,14 +438,15 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  
>  	tsk = current;
>  	mm = tsk->mm;
> +
> +#ifdef CONFIG_x86_64
>  	prefetchw(&mm->mmap_sem);
> +#endif

Five.

>  
>  	/* get the address */
>  	address = read_cr2();
> -
>  	si_code = SEGV_MAPERR;
>  
> -
>  	/*
>  	 * We fault-in kernel-space virtual memory on-demand. The
>  	 * 'reference' page table is init_mm.pgd.
> @@ -457,6 +460,12 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  	 * (error_code & 4) == 0, and that the fault was not a
>  	 * protection error (error_code & 9) == 0.
>  	 */
> +#ifdef CONFIG_X86_32
> +	if (unlikely(address >= TASK_SIZE)) {
> +		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
> +		    vmalloc_fault(address) >= 0)
> +			return;
> +#else
>  	if (unlikely(address >= TASK_SIZE64)) {
>  		/*
>  		 * Don't check for the module range here: its PML4
> @@ -468,6 +477,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  			if (vmalloc_fault(address) >= 0)
>  				return;
>  		}
> +#endif

Six.

>  		if (notify_page_fault(regs))
>  			return;
>  		/*
> @@ -500,7 +510,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  	if (user_mode_vm(regs))
>  		error_code |= PF_USER;
>  
> - again:
> +again:
>  	/* When running in the kernel we expect faults to occur only to
>  	 * addresses in user space.  All other faults represent errors in the
>  	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
> @@ -531,8 +541,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  	if (!(vma->vm_flags & VM_GROWSDOWN))
>  		goto bad_area;
>  	if (error_code & PF_USER) {
> -		/* Allow userspace just enough access below the stack pointer
> -		 * to let the 'enter' instruction work.
> +		/*
> +		 * Accessing the stack below %sp is always a bug.
> +		 * The large cushion allows instructions like enter
> +		 * and pusha to work.  ("enter $65535,$31" pushes
> +		 * 32 pointers and then decrements %sp by 65535.)
>  		 */
>  		if (address + 65536 + 32 * sizeof(unsigned long) < regs->sp)
>  			goto bad_area;
