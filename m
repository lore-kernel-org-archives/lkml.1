Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0BKUrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:47:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab0BKUrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:47:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] Blackfin: initial tracehook support
In-Reply-To: Mike Frysinger's message of  Thursday, 11 February 2010 04:43:08 -0500 <1265881389-26925-2-git-send-email-vapier@gentoo.org>
References: <20100202185907.GE3630@lst.de>
	<1265881389-26925-2-git-send-email-vapier@gentoo.org>
Emacs: more than just a Lisp interpreter, a text editor as well!
Message-Id: <20100211204653.34BB3900@magilla.sf.frob.com>
Date: Thu, 11 Feb 2010 12:46:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  config BLACKFIN
>  	def_bool y
>  	select HAVE_ARCH_KGDB
> +	select HAVE_ARCH_TRACEHOOK

Don't define this until you have all its constituents as listed in the
arch/Kconfig comment.  I don't see user_regset support.

> +static inline void
> +syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
> +                      unsigned int i, unsigned int n, unsigned long *args)
> +{
> +	/* wtf is "i" ? */
> +	BUG_ON(i);

i is the starting number.  args[0] gets the i'th argument,
args[n - 1] gets the i+n-1'th argument.

> +asmlinkage void syscall_trace_leave(struct pt_regs *regs)
> +{
> +	if (test_thread_flag(TIF_SYSCALL_TRACE))
> +		tracehook_report_syscall_exit(regs, 0);
>  }

Is it in fact true that single-step reports still come normally after a
syscall instruction?

> @@ -213,7 +213,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
>  	 */
>  	if (regs->syscfg & TRACE_BITS) {
>  		regs->syscfg &= ~TRACE_BITS;
> -		ptrace_notify(SIGTRAP);
> +		tracehook_signal_handler(sig, info, ka, regs, 1);
>  	}

This call should be made unconditionally, and it should be made after the
signal mask changes have been made (i.e. at the end of handle_signal).  I
think it's wrong to clear the single-step flag here.  Instead, pass
(regs->syscfg & TRACE_BITS) as the last argument.

With ptrace, it makes no difference one way or the other because it will
always either explicitly clear or explicitly set single-step before it
resumes.  But in future, it will matter.


Thanks,
Roland
