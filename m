Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYHRR6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYHRR6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYHRR6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:58:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYHRR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:58:39 -0400
Date: Mon, 18 Aug 2008 10:30:48 -0700
From: Greg KH <greg@kroah.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] Patch Upstream: x64, fpu: fix possible FPU leakage in
	error conditions
Message-ID: <20080818173048.GA16194@kroah.com>
References: <200808170025.m7H0PAL6026263@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808170025.m7H0PAL6026263@hera.kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suresh, the following patch does not apply to the 2.6.26.2 kernel.  If
you feel it should be also commited there, can you please provide a
backported version and send it to stable@kernel.org?

thanks,

greg k-h

> commit: 6ffac1e90a17ea0aded5c581204397421eec91b6
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Date: Thu, 24 Jul 2008 18:07:56 -0700
> Subject: x64, fpu: fix possible FPU leakage in error conditions
> 
> On Thu, Jul 24, 2008 at 03:43:44PM -0700, Linus Torvalds wrote:
> > So how about this patch as a starting point? This is the RightThing(tm) to
> > do regardless, and if it then makes it easier to do some other cleanups,
> > we should do it first. What do you think?
> 
> restore_fpu_checking() calls init_fpu() in error conditions.
> 
> While this is wrong(as our main intention is to clear the fpu state of
> the thread), this was benign before commit 92d140e21f1 ("x86: fix taking
> DNA during 64bit sigreturn").
> 
> Post commit 92d140e21f1, live FPU registers may not belong to this
> process at this error scenario.
> 
> In the error condition for restore_fpu_checking() (especially during the
> 64bit signal return), we are doing init_fpu(), which saves the live FPU
> register state (possibly belonging to some other process context) into
> the thread struct (through unlazy_fpu() in init_fpu()). This is wrong
> and can leak the FPU data.
> 
> For the signal handler restore error condition in restore_i387(), clear
> the fpu state present in the thread struct(before ultimately sending a
> SIGSEGV for badframe).
> 
> For the paranoid error condition check in math_state_restore(), send a
> SIGSEGV, if we fail to restore the state.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: <stable@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/signal_64.c |   11 ++++++++++-
>  arch/x86/kernel/traps_64.c  |    9 ++++++++-
>  include/asm-x86/i387.h      |    2 --
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
> index b45ef8d..ca316b5 100644
> --- a/arch/x86/kernel/signal_64.c
> +++ b/arch/x86/kernel/signal_64.c
> @@ -104,7 +104,16 @@ static inline int restore_i387(struct _fpstate __user *buf)
>  		clts();
>  		task_thread_info(current)->status |= TS_USEDFPU;
>  	}
> -	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
> +	err = restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
> +	if (unlikely(err)) {
> +		/*
> +		 * Encountered an error while doing the restore from the
> +		 * user buffer, clear the fpu state.
> +		 */
> +		clear_fpu(tsk);
> +		clear_used_math();
> +	}
> +	return err;
>  }
>  
>  /*
> diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
> index 3f18d73..513caac 100644
> --- a/arch/x86/kernel/traps_64.c
> +++ b/arch/x86/kernel/traps_64.c
> @@ -1131,7 +1131,14 @@ asmlinkage void math_state_restore(void)
>  	}
>  
>  	clts();				/* Allow maths ops (or we recurse) */
> -	restore_fpu_checking(&me->thread.xstate->fxsave);
> +	/*
> +	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
> +	 */
> +	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
> +		stts();
> +		force_sig(SIGSEGV, me);
> +		return;
> +	}
>  	task_thread_info(me)->status |= TS_USEDFPU;
>  	me->fpu_counter++;
>  }
> diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
> index 96fa844..0048fb7 100644
> --- a/include/asm-x86/i387.h
> +++ b/include/asm-x86/i387.h
> @@ -62,8 +62,6 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
>  #else
>  		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
>  #endif
> -	if (unlikely(err))
> -		init_fpu(current);
>  	return err;
>  }
>  
