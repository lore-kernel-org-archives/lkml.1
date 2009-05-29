Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZE2KtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZE2KtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZE2KtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:49:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34923 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZE2KtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hjAiyB3A3zGFEtZY78dpjjLaQbE9SKdN5FcqQ3qzzW9sjl6zeobTDTeqcp25H8tNve
         wpwUI8oanlazKd5MVN6Q43tqeHeG1T0bha/NWBbQSOMRpc+b2CqucKmjJYqBEtPsr9Ik
         Khs4MeYlD6Ptkmnwfwkf4PdJSlu3sQHsdG7wA=
Date: Fri, 29 May 2009 12:49:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: David Gibson <dwg@au1.ibm.com>, Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 06/12] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090529104901.GA5997@nowhere>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115344.GG25673@in.ibm.com> <20090528064238.GC3091@yookeroo.seuss> <20090529090146.GA5353@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529090146.GA5353@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 02:31:46PM +0530, K.Prasad wrote:
> On Thu, May 28, 2009 at 04:42:38PM +1000, David Gibson wrote:
> > On Mon, May 11, 2009 at 05:23:44PM +0530, K.Prasad wrote:
> > > From: Alan Stern <stern@rowland.harvard.edu>
> > > 
> > > This patch enables the use of abstract debug registers in
> > > process-handling routines.
> > 
> > [snip]
> > >  
> > > +	p->thread.io_bitmap_ptr = NULL;
> > 
> > Why is manipulating the io_bitmap_ptr relevant to debug register
> > handling?
> 
> I *re-read* the patch but was unable to find how this change had sneaked
> in. It shouldn't be there although it is harmless.


When I reviewed this patch, I also ended stucked on it.
But actually I guess I found the sense, this is only for
convenience.

Look at the current copy_thread() in arch/x86/kernel/process32.c

If p->thread.io_bitmap_ptr fails to be duplicated, we set
p->thread.io_bitmap_max = 0 and return -ENOMEM

Now look at the patch.
If we fail to copy the hardware thread virtual registers we
want to exit with io_bitmap_ptr = NULL
If we fail to copy the io_bitmap, we want to free the breakpoint
and exit.
If we fail further, we want to free breakpoints and io_bitmap_ptr

The out section then tries to:

-free the breakpoints
-free p->thread.io_bitmap_ptr


So it's important to set io_bitmap_ptr to NULL so that
we know whether we have to release it or not.

 
> Hi Frederic,
> 	I am attaching a new version of this patch 06/12 that:
> 
> - removes the line that assigns NULL to "p->thread.io_bitmap_ptr"


Dangerous. Unless p->thread.io_bitmap_ptr is already zeroed out
at this stage?

 
> - Updates the comment in __switch_to() function which was stale (was
>   relevant when 'last_debugged_task' was used to detect lazy debug
>   register switching).
> 
> Kindly integrate this version in lieu of the older version sent here:
> http://lkml.org/lkml/2009/5/21/149.


Ok. Well it would be nice if you resend the whole series actually :)
Do you have another fix pending?

Thanks!

> Hi Alan,
> 	I'm retaining the
> "Reviewed-by: Alan Stern <stern@rowland.harvard.edu>" tag on the patch
> even after the above changes and guess it is acceptable to you. Please
> let me know if you have any concerns about that.
> 
> Thanks,
> K.Prasad
> 
> 
> Use the new wrapper routines to access debug registers in process/thread code
> 
> This patch enables the use of abstract debug registers in
> process-handling routines.
> 
> Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  arch/x86/kernel/process.c    |   23 ++++++-----------------
>  arch/x86/kernel/process_32.c |   27 +++++++++++++++++++++++++++
>  arch/x86/kernel/process_64.c |   30 ++++++++++++++++++++++++++++++
>  3 files changed, 63 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/process.c
> @@ -17,6 +17,8 @@
>  #include <asm/uaccess.h>
>  #include <asm/i387.h>
>  #include <asm/ds.h>
> +#include <asm/debugreg.h>
> +#include <asm/hw_breakpoint.h>
>  
>  unsigned long idle_halt;
>  EXPORT_SYMBOL(idle_halt);
> @@ -48,6 +50,8 @@ void free_thread_xstate(struct task_stru
>  		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
>  		tsk->thread.xstate = NULL;
>  	}
> +	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
> +		flush_thread_hw_breakpoint(tsk);
>  
>  	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
>  }
> @@ -106,14 +110,9 @@ void flush_thread(void)
>  	}
>  #endif
>  
> -	clear_tsk_thread_flag(tsk, TIF_DEBUG);
> +	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
> +		flush_thread_hw_breakpoint(tsk);
>  
> -	tsk->thread.debugreg0 = 0;
> -	tsk->thread.debugreg1 = 0;
> -	tsk->thread.debugreg2 = 0;
> -	tsk->thread.debugreg3 = 0;
> -	tsk->thread.debugreg6 = 0;
> -	tsk->thread.debugreg7 = 0;
>  	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
>  	/*
>  	 * Forget coprocessor state..
> @@ -195,16 +194,6 @@ void __switch_to_xtra(struct task_struct
>  	else if (next->debugctlmsr != prev->debugctlmsr)
>  		update_debugctlmsr(next->debugctlmsr);
>  
> -	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
> -		set_debugreg(next->debugreg0, 0);
> -		set_debugreg(next->debugreg1, 1);
> -		set_debugreg(next->debugreg2, 2);
> -		set_debugreg(next->debugreg3, 3);
> -		/* no 4 and 5 */
> -		set_debugreg(next->debugreg6, 6);
> -		set_debugreg(next->debugreg7, 7);
> -	}
> -
>  	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
>  	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
>  		/* prev and next are different */
> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_32.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
> @@ -58,6 +58,8 @@
>  #include <asm/idle.h>
>  #include <asm/syscalls.h>
>  #include <asm/ds.h>
> +#include <asm/debugreg.h>
> +#include <asm/hw_breakpoint.h>
>  
>  asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
>  
> @@ -263,6 +265,11 @@ int copy_thread(unsigned long clone_flag
>  	task_user_gs(p) = get_user_gs(regs);
>  
>  	tsk = current;
> +	err = -ENOMEM;
> +	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
> +		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
> +			goto out;
> +
>  	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
>  		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
>  						IO_BITMAP_BYTES, GFP_KERNEL);
> @@ -282,10 +289,13 @@ int copy_thread(unsigned long clone_flag
>  		err = do_set_thread_area(p, -1,
>  			(struct user_desc __user *)childregs->si, 0);
>  
> +out:
>  	if (err && p->thread.io_bitmap_ptr) {
>  		kfree(p->thread.io_bitmap_ptr);
>  		p->thread.io_bitmap_max = 0;
>  	}
> +	if (err)
> +		flush_thread_hw_breakpoint(p);
>  
>  	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
>  	p->thread.ds_ctx = NULL;
> @@ -424,6 +434,23 @@ __switch_to(struct task_struct *prev_p, 
>  		lazy_load_gs(next->gs);
>  
>  	percpu_write(current_task, next_p);
> +	/*
> +	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
> +	 * call before current is updated.  Suppose a kernel breakpoint is
> +	 * triggered in between the two, the hw-breakpoint handler will see that
> +	 * the 'current' task does not have TIF_DEBUG flag set and will think it
> +	 * is leftover from an old task (lazy switching) and will erase it. Then
> +	 * until the next context switch, no user-breakpoints will be installed.
> +	 *
> +	 * The real problem is that it's impossible to update both current and
> +	 * physical debug registers at the same instant, so there will always be
> +	 * a window in which they disagree and a breakpoint might get triggered.
> +	 * Since we use lazy switching, we are forced to assume that a
> +	 * disagreement means that current is correct and the exception is due
> +	 * to lazy debug register switching.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
> +		arch_install_thread_hw_breakpoint(next_p);
>  
>  	return prev_p;
>  }
> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_64.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
> @@ -52,6 +52,8 @@
>  #include <asm/idle.h>
>  #include <asm/syscalls.h>
>  #include <asm/ds.h>
> +#include <asm/debugreg.h>
> +#include <asm/hw_breakpoint.h>
>  
>  asmlinkage extern void ret_from_fork(void);
>  
> @@ -245,6 +247,8 @@ void release_thread(struct task_struct *
>  			BUG();
>  		}
>  	}
> +	if (unlikely(dead_task->thread.debugreg7))
> +		flush_thread_hw_breakpoint(dead_task);
>  }
>  
>  static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
> @@ -306,6 +310,11 @@ int copy_thread(unsigned long clone_flag
>  	savesegment(es, p->thread.es);
>  	savesegment(ds, p->thread.ds);
>  
> +	err = -ENOMEM;
> +	if (unlikely(test_tsk_thread_flag(me, TIF_DEBUG)))
> +		if (copy_thread_hw_breakpoint(me, p, clone_flags))
> +			goto out;
> +
>  	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
>  		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
>  		if (!p->thread.io_bitmap_ptr) {
> @@ -344,6 +353,9 @@ out:
>  		kfree(p->thread.io_bitmap_ptr);
>  		p->thread.io_bitmap_max = 0;
>  	}
> +	if (err)
> +		flush_thread_hw_breakpoint(p);
> +
>  	return err;
>  }
>  
> @@ -489,6 +501,24 @@ __switch_to(struct task_struct *prev_p, 
>  	 */
>  	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
>  		math_state_restore();
> +	/*
> +	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
> +	 * call before current is updated.  Suppose a kernel breakpoint is
> +	 * triggered in between the two, the hw-breakpoint handler will see that
> +	 * the 'current' task does not have TIF_DEBUG flag set and will think it
> +	 * is leftover from an old task (lazy switching) and will erase it. Then
> +	 * until the next context switch, no user-breakpoints will be installed.
> +	 *
> +	 * The real problem is that it's impossible to update both current and
> +	 * physical debug registers at the same instant, so there will always be
> +	 * a window in which they disagree and a breakpoint might get triggered.
> +	 * Since we use lazy switching, we are forced to assume that a
> +	 * disagreement means that current is correct and the exception is due
> +	 * to lazy debug register switching.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
> +		arch_install_thread_hw_breakpoint(next_p);
> +
>  	return prev_p;
>  }
>  

