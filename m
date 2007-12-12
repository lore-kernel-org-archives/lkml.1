Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXLLFwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXLLFwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXLLFwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:52:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbXLLFwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:52:21 -0500
Date: Tue, 11 Dec 2007 21:51:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Petr Tesarik <ptesarik@suse.cz>, tony.luck@intel.com
Subject: Re: [PATCH] arch_ptrace_stop
Message-Id: <20071211215135.95ae3f6d.akpm@linux-foundation.org>
In-Reply-To: <20071208011152.CDA8E26F8EA@magilla.localdomain>
References: <1196959793.6586.3.camel@elijah.suse.cz>
	<20071208011152.CDA8E26F8EA@magilla.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Dec 2007 17:11:52 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:

> 
> This adds support to allow asm/ptrace.h to define two new macros,
> arch_ptrace_stop_needed and arch_ptrace_stop.  These control special
> machine-specific actions to be done before a ptrace stop.  The new
> code compiles away to nothing when the new macros are not defined.
> This is the case on all machines to begin with.
> 
> On ia64, these macros will be defined to solve the long-standing
> issue of ptrace vs register backing store.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> CC: Petr Tesarik <ptesarik@suse.cz>
> CC: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/ptrace.h |   35 +++++++++++++++++++++++++++++++++++
>  kernel/signal.c        |   33 ++++++++++++++++++++++++++++++++-
>  2 files changed, 67 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index ae8146a..7168757 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -128,6 +128,41 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
>  #define force_successful_syscall_return() do { } while (0)
>  #endif
>  
> +#ifndef arch_ptrace_stop_needed
> +/**
> + * arch_ptrace_stop_needed - Decide whether arch_ptrace_stop() should be called
> + * @code:	current->exit_code value ptrace will stop with
> + * @info:	siginfo_t pointer (or %NULL) for signal ptrace will stop with
> + *
> + * This is called with the siglock held, to decide whether or not it's
> + * necessary to release the siglock and call arch_ptrace_stop() with the
> + * same @code and @info arguments.  It can be defined to a constant if
> + * arch_ptrace_stop() is never required, or always is.  On machines where
> + * this makes sense, it should be defined to a quick test to optimize out
> + * calling arch_ptrace_stop() when it would be superfluous.  For example,
> + * if the thread has not been back to user mode since the last stop, the
> + * thread state might indicate that nothing needs to be done.
> + */
> +#define arch_ptrace_stop_needed(code, info)	(0)
> +#endif
> +
> +#ifndef arch_ptrace_stop
> +/**
> + * arch_ptrace_stop - Do machine-specific work before stopping for ptrace
> + * @code:	current->exit_code value ptrace will stop with
> + * @info:	siginfo_t pointer (or %NULL) for signal ptrace will stop with
> + *
> + * This is called with no locks held when arch_ptrace_stop_needed() has
> + * just returned nonzero.  It is allowed to block, e.g. for user memory
> + * access.  The arch can have machine-specific work to be done before
> + * ptrace stops.  On ia64, register backing store gets written back to user
> + * memory here.  Since this can be costly (requires dropping the siglock),
> + * we only do it when the arch requires it for this particular stop, as
> + * indicated by arch_ptrace_stop_needed().
> + */
> +#define arch_ptrace_stop(code, info)		do { } while (0)

Mutter.  These would be better as static inlines.  A macro just invites
variable-unused warnings on non-ia64 and outright compilation errors on
ia64.  Speaking from experience...

static inline void arch_ptrace_stop(int exit_code, siginfo_t *info)
{
}
#define arch_ptrace_stop arch_ptrace_stop

should work?

>  /*
> + * Return nonzero if there is a SIGKILL that should be waking us up.
> + * Called with the siglock held.
> + */
> +static int sigkill_pending(struct task_struct *tsk)
> +{
> +	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
> +		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
> +		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
> +}

Could you please take a peek at the infrastructure added by
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/add-lock_page_killable.patch
and see if there is exploitable commonality?


