Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZG1Duj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZG1Duj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZG1Dui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:50:38 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:45214 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZG1Dui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TvOzWlJnuV+VGzvxxcBaXCyKxVCrlYf5Rg/uouLhU/tvVAHSntXBAEUFT706VlGOH4
         TVM8AmExehfL754FXup5kDdUl++yvMMiQbcmJYGCXFHA8EV9aTmfi9nF2E7Q26/uEicB
         t1/7iVZhnf5yMtlZ9unvQmueMGPqdPVTeX1oc=
Date: Tue, 28 Jul 2009 05:50:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Fix traceback seen when resuming after suspend-to-ram
Message-ID: <20090728035032.GI5147@nowhere>
References: <20090722151123.GA4934@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722151123.GA4934@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 08:41:23PM +0530, K.Prasad wrote:
> Hi Ingo,
> 	Please accept a patch that fixes the warning message and traceback
> seen upon a resume after suspend-to-ram.
> 
> The warning message is emitted because
> spin_unlock_bh()<--load_debug_registers() is invoked with interrupts
> disabled upon 'resume' unlike when invoked at boot-time, and was
> reported on LKML here: http://lkml.org/lkml/2009/7/18/145.
> 
> This patch modifies load_debug_registers() to block all interrupts and not
> just bottom-halves (bottom-halves were blocked in load_debug_registers()
> prevent flush_thread_hw_breakpoint() from interfering when invoked from
> SoftIRQ context).
> 
> Fix traceback seen when resuming after suspend-to-ram
> 
> This patch fixes a traceback when resuming after a suspend-to-ram operation.
> The traceback warns about entering slowpatch due to a spin_unlock_bh() done
> from interrupt context.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/hw_breakpoint.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6-tip/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/hw_breakpoint.c
> +++ linux-2.6-tip/kernel/hw_breakpoint.c
> @@ -80,17 +80,15 @@ void load_debug_registers(void)
>  	unsigned long flags;
>  	struct task_struct *tsk = current;
>  
> -	spin_lock_bh(&hw_breakpoint_lock);
> -
>  	/* Prevent IPIs for new kernel breakpoint updates */
> -	local_irq_save(flags);
> +	spin_lock_irqsave(&hw_breakpoint_lock, flags);
> +
>  	arch_update_kernel_hw_breakpoint(NULL);
> -	local_irq_restore(flags);
>  
>  	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
>  		arch_install_thread_hw_breakpoint(tsk);
>  
> -	spin_unlock_bh(&hw_breakpoint_lock);
> +	spin_unlock_irqrestore(&hw_breakpoint_lock, flags);
>  }
>  
>  /*


Hmm, this may lead to a state in which lockdep would complain because
your lock is taken as softirq-safe from flush_thread_hw_breakpoint()
and hardirq-safe in load_debug_registers().

Lockdep will think that you have an unsafe state in
flush_thread_hw_breakpoint() because your lock has been taken in
a hardirq-safe fashion elsewhere and therefore can be taken in a
hardirq path.

We know it's safe, but lockdep will warn anyway.

BTW: how is it possible that flush_thread_hw_breakpoint() can be called
from softirq? It can called in a failed fork or any case when a thread
is released. Does such thing sometimes happen in softirq?

Thanks.


