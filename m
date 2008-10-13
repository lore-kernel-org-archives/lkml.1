Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYJMQKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYJMQKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbYJMQKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:10:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755943AbYJMQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:10:39 -0400
Date: Mon, 13 Oct 2008 09:08:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Karel Zak <kzak@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
In-Reply-To: <20081013160259.GA26866@elte.hu>
Message-ID: <alpine.LFD.2.00.0810130908150.3288@nehalem.linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org> <20081012200004.GI10429@nb.net.home>
 <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org> <20081013152633.GA6523@elte.hu> <alpine.LFD.2.00.0810130841440.3288@nehalem.linux-foundation.org> <20081013160259.GA26866@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Ingo Molnar wrote:
> 
> hm, i think the 64-bit case is the correct code, because in this 'init 
> task OOMs' case we do:
> 
> out_of_memory:
>         up_read(&mm->mmap_sem);
>         if (is_global_init(tsk)) {
>                 yield();
>                 down_read(&mm->mmap_sem);
> 
> note that we drop the mmap_sem, so in theory another thread of this same 
> MM could change the vma tree, and our 'vma' might not be valid anymore.

Hmm. Looks about right.

> It's probably not a real issue in practice because this is about PID 1, 
> so i doubt it really matters, but still.
> 
> So how about the patch below?

Ack. As long as we don't have two versions and the code is impossible to 
look at.

			Linus

> 
> 	Ingo
> 
> ---------------->
> >From 7b87da331b6ada44ccd5ffeedba76880c825d4fc Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 13 Oct 2008 17:49:02 +0200
> Subject: [PATCH] x86/mm: unify init task OOM handling
> 
> Linus noticed that the "again:" versus "survive:" OOM logic for
> the init task was arbitrarily different.
> 
> The 64-bit codepath is the better one, because it correctly re-lookups
> the vma after having dropped the ->mmap_sem.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/fault.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index ac2ad78..8bc5956 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -671,7 +671,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		goto bad_area_nosemaphore;
>  
>  again:
> -	/* When running in the kernel we expect faults to occur only to
> +	/*
> +	 * When running in the kernel we expect faults to occur only to
>  	 * addresses in user space.  All other faults represent errors in the
>  	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
>  	 * erroneous fault occurring in a code path which already holds mmap_sem
> @@ -734,9 +735,6 @@ good_area:
>  			goto bad_area;
>  	}
>  
> -#ifdef CONFIG_X86_32
> -survive:
> -#endif
>  	/*
>  	 * If for any reason at all we couldn't handle the fault,
>  	 * make sure we exit gracefully rather than endlessly redo
> @@ -871,12 +869,11 @@ out_of_memory:
>  	up_read(&mm->mmap_sem);
>  	if (is_global_init(tsk)) {
>  		yield();
> -#ifdef CONFIG_X86_32
> -		down_read(&mm->mmap_sem);
> -		goto survive;
> -#else
> +		/*
> +		 * Re-lookup the vma - in theory the vma tree might
> +		 * have changed:
> +		 */
>  		goto again;
> -#endif
>  	}
>  
>  	printk("VM: killing process %s\n", tsk->comm);
> 
