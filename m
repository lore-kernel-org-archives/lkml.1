Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZLRCQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZLRCQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZLRCQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZLRCQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:16:28 -0500
Date: Fri, 18 Dec 2009 03:10:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218021042.GA508@redhat.com>
References: <20091218005650.GA20667@redhat.com> <20091218014021.CB474135F@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218014021.CB474135F@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Roland McGrath wrote:
>
> Comparing to the old (2.6.32) logic, I think it might be this (untested).
> I also note this is the sole use of get_si_code, seems like it should
> just be rolled in here.

Well, it is too late for me to even try to read this patch ;)

but...

> @@ -569,14 +568,15 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	 * We already checked v86 mode above, so we can check for kernel mode
>  	 * by just checking the CPL of CS.
>  	 */
> +	dr6 = tsk->thread.debugreg6;

why? we have "tsk->thread.debugreg6 = dr6" above

>  	if ((dr6 & DR_STEP) && !user_mode(regs)) {
>  		tsk->thread.debugreg6 &= ~DR_STEP;
>  		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
>  		regs->flags &= ~X86_EFLAGS_TF;

this looks strange... we set TIF_SINGLESTEP but clear X86_EFLAGS_TF

> +	} else if (dr6 & (DR_STEP | DR_TRAP_BITS)) {
> +		send_sigtrap(tsk, regs, error_code, get_si_code(dr6));
>  	}
> -	si_code = get_si_code(tsk->thread.debugreg6);
> -	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
> -		send_sigtrap(tsk, regs, error_code, si_code);
> +

can't understand how this change can fix the problem. We should always
send SIGTRAP if the task returns to user-mode with X86_EFLAGS_TF?

OK. I blindly applied this patch, step-simple still fails.

Oleg.

