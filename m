Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZC0OX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZC0OX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZC0OXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:23:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44787 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZC0OXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:23:17 -0400
Date: Fri, 27 Mar 2009 15:19:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 1/14] x86, ptrace: add arch_ptrace_report_exit
Message-ID: <20090327141937.GB14504@redhat.com>
References: <20090327094626.A11002@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327094626.A11002@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Markus Metzger wrote:
>
> --- git-tip.orig/include/linux/ptrace.h	2009-03-23 10:45:30.000000000 +0100
> +++ git-tip/include/linux/ptrace.h	2009-03-23 11:31:21.000000000 +0100
> @@ -335,6 +335,23 @@ static inline void user_enable_block_ste
>  #define arch_ptrace_fork(child, clone_flags)	do { } while (0)
>  #endif
>
> +#ifndef arch_ptrace_report_exit
> +/**
> + * arch_ptrace_report_exit - Do machine specific work for exiting ptraced tasks
> + * @exit_code:	current->exit_code value
> + *
> + * This is called early from do_exit() with no locks held after we notified the
> + * ptracer.
> + */
> +#define arch_ptrace_report_exit(exit_code)	do { } while (0)
> +#endif
> +
> +static inline void ptrace_report_exit(long *exit_code)
> +{
> +	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
> +	arch_ptrace_report_exit(*exit_code);
> +}
> +
>  extern int task_current_syscall(struct task_struct *target, long *callno,
>  				unsigned long args[6], unsigned int maxargs,
>  				unsigned long *sp, unsigned long *pc);
> Index: git-tip/include/linux/tracehook.h
> ===================================================================
> --- git-tip.orig/include/linux/tracehook.h	2009-03-23 10:45:30.000000000 +0100
> +++ git-tip/include/linux/tracehook.h	2009-03-23 11:31:21.000000000 +0100
> @@ -211,7 +211,7 @@ static inline void tracehook_report_exec
>   */
>  static inline void tracehook_report_exit(long *exit_code)
>  {
> -	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
> +	ptrace_report_exit(exit_code);
>  }

This needs Rolan'd review.

But I'd say this has nothing to do with tracehooks. And why do
you pass *exit_code to arch_ptrace_report_exit() ?

Just add arch_ptrace_report_exit(void) into do_exit() ?

>From the 3/14 patch:

	#define arch_ptrace_report_exit(code) x86_ptrace_report_exit(code)

	void x86_ptrace_report_exit(long exit_code)
	{
	       ptrace_bts_exit();
	}

This is a bit strange. Why do we need 2 functions, ptrace_bts_exit() and
x86_ptrace_report_exit() which just calls the first one?

Oleg.

