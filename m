Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZAZTBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZAZTBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZAZTBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:01:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbZAZTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:01:41 -0500
Date: Mon, 26 Jan 2009 11:00:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: mingo@elte.hu, linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, travis@sgi.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       arjan@infradead.org, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [git pull] cpus4096 tree, part 3
Message-Id: <20090126110054.bdddbf38.akpm@linux-foundation.org>
In-Reply-To: <20090105011630.GI32239@wotan.suse.de>
References: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
	<20090102203839.GA26850@elte.hu>
	<alpine.LFD.2.00.0901021531140.3179@localhost.localdomain>
	<20090103193859.GB9805@elte.hu>
	<alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
	<20090103203621.GA2491@elte.hu>
	<20090103213856.GA24138@elte.hu>
	<alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
	<20090103223723.GA17047@elte.hu>
	<20090105011416.GG32239@wotan.suse.de>
	<20090105011630.GI32239@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 02:16:30 +0100
Nick Piggin <npiggin@suse.de> wrote:

> Really cc linux-arch this time
> 
> On Mon, Jan 05, 2009 at 02:14:16AM +0100, Nick Piggin wrote:
> > On Sat, Jan 03, 2009 at 11:37:23PM +0100, Ingo Molnar wrote:
> > > 
> > > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 
> > > > What happened to Nick's cleanup patch to do_page_fault (a month or two 
> > > > ago? I complained about some of the issues in his first version and 
> > > > asked for some further cleanups, but I think that whole discussion ended 
> > > > with him saying "I am going to add those changes that you suggested (in 
> > > > fact, I already have)".
> > > > 
> > > > And then I didn't see anything further. Maybe I just missed the end 
> > > > result. Or maybe we have it in some -mm branch or something?
> > > 
> > > they would have been in tip/x86/mm and would be upstream now had Nick 
> > > re-sent a v2 series but that never happened. I think they might have 
> > > fallen victim to a serious attention deficit caused by the SLQB patch ;-)
> > 
> > Well, I already added Linus's suggestions but didn't submit it because
> > there was a bit of work going on in that file as far as I could see, both
> > in the x86 tree and in -mm:
> > 
> > (http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/broken-out/mm-invoke-oom-killer-from-page-fault.patch)
> > 
> > It isn't a big deal to resolve either way, but I don't want to make Andrew's
> > life harder.
> > 
> > [Yes OK now I'm the guilty one of pushing in an x86 patch not via the
> > x86 tree ;) This one is easy to break in pieces, but I didn't want
> > to create a dependency between the trees]
> > 
> > I didn't really consider it to be urgent, so I was waiting for that patch
> > to go in, but I was still hoping to get this into 2.6.29... This is what
> > it looks like now with your suggestions, and just merged it to your current
> > tree (untested).
> > 
> > I'll cc the linux-arch list here too, because it might be nice to keep these
> > things as structurally similar as possible (and they'll all want to look at
> > the -mm patch above, although I'll probably end up having to write the
> > patches!).
> 
> ---
> Optimise x86's do_page_fault (C entry point for the page fault path).

It took rather a lot of hunting to find this email.  Please do try to
make the email subject match the final patch's title?

>   * This routine handles page faults.  It determines the address,
>   * and the problem, and then passes it off to one of the appropriate
> @@ -583,16 +796,12 @@ asmlinkage
>  #endif
>  void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
> +	unsigned long address;
>  	struct task_struct *tsk;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	unsigned long address;
> -	int write, si_code;
> +	int write;
>  	int fault;
> -#ifdef CONFIG_X86_64
> -	unsigned long flags;
> -	int sig;
> -#endif
>  
>  	tsk = current;
>  	mm = tsk->mm;
> @@ -601,9 +810,7 @@ void __kprobes do_page_fault(struct pt_r
>  	/* get the address */
>  	address = read_cr2();
>  
> -	si_code = SEGV_MAPERR;
> -
> -	if (notify_page_fault(regs))
> +	if (unlikely(notify_page_fault(regs)))
>  		return;
>  	if (unlikely(kmmio_fault(regs, address)))
>  		return;
> @@ -638,10 +845,10 @@ void __kprobes do_page_fault(struct pt_r
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
>  		 * fault we could otherwise deadlock.
>  		 */
> -		goto bad_area_nosemaphore;
> +		bad_area_nosemaphore(regs, error_code, address);
> +		return;
>  	}
>  
> -
>  	/*
>  	 * It's safe to allow irq's after cr2 has been saved and the
>  	 * vmalloc fault has been handled.
> @@ -657,17 +864,18 @@ void __kprobes do_page_fault(struct pt_r
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
> @@ -684,20 +892,26 @@ again:
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
> @@ -705,31 +919,25 @@ again:
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
> -	si_code = SEGV_ACCERR;
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

What's going on here?  We set `error_code' to PF_WRITE, which is some
x86-specific thing.

> +	if (unlikely(access_error(error_code, write, vma))) {
> +		bad_area_access_error(regs, error_code, address);
> +		return;
>  	}
>  
>  	/*
> @@ -739,11 +947,8 @@ good_area:
>  	 */
>  	fault = handle_mm_fault(mm, vma, address, write);

and then pass it into handle_mm_fault(), which is expecting a bunch of
flags in the FAULT_FLAG_foo domain.

IOW, the code will accidentally set FAULT_FLAG_NONLINEAR!.


Methinks we want something like this,

--- a/arch/x86/mm/fault.c~fix-x86-optimise-x86s-do_page_fault-c-entry-point-for-the-page-fault-path
+++ a/arch/x86/mm/fault.c
@@ -942,7 +942,7 @@ void __kprobes do_page_fault(struct pt_r
 	 * we can handle it..
 	 */
 good_area:
-	write = error_code & PF_WRITE;
+	write = (error_code & PF_WRITE) ? FAULT_FLAG_WRITE : 0;
 	if (unlikely(access_error(error_code, write, vma))) {
 		bad_area_access_error(regs, error_code, address);
 		return;
_


but why did the current code pass testing at all??

