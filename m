Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbZLRRhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbZLRRhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZLRRhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:37:14 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45358 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZLRRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:37:12 -0500
Date: Fri, 18 Dec 2009 23:07:03 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218173703.GA3726@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091218005650.GA20667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218005650.GA20667@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 01:56:50AM +0100, Oleg Nesterov wrote:
> Hi.
> 
> do_debug() is obviously wrong wrt PTRACE_SINGLESTEP/TIF_SINGLESTEP, no?
> 
> Afaics this was broken by
> 
> 	hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
> 	commit 08d68323d1f0c34452e614263b212ca556dae47f
> 
> To verify, the "patch" below fixes the stepping for me, not sure what
> is the proper fix...
> 
> Oleg.
> 
> --- arch/x86/kernel/traps.c~	2009-12-18 00:20:49.000000000 +0100
> +++ arch/x86/kernel/traps.c	2009-12-18 01:44:05.000000000 +0100
> @@ -575,7 +575,7 @@ dotraplinkage void __kprobes do_debug(st
>  		regs->flags &= ~X86_EFLAGS_TF;
>  	}
>  	si_code = get_si_code(tsk->thread.debugreg6);
> -	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
> +//	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
>  		send_sigtrap(tsk, regs, error_code, si_code);
>  	preempt_conditional_cli(regs);
>

The cause for such a behaviour isn't apparent to me and like others, I'm
unable to recreate it (Single-stepping using gdb over a tiny program
running on x86, latest -tip works fine).

Did you try to narrow down the causative piece of code, among the
several hooks in do_debug()?

A separate 'dr6' and 'thread.debugreg6' was desired by the community (refer:
Pine.LNX.4.44L0.0904011216460.3736-100000@iolanthe.rowland.org and
Pine.LNX.4.44L0.0904091634150.4094-100000@iolanthe.rowland.org) then.
'dr6' and 'thread.deebugreg6' would contain the value of the DR6 status
register and every exception handler would reset the bits in them
corresponding to which action has been taken. The difference in them being
that 'thread.debugreg6' would be eventually processed by code interested
in user-space while 'dr6' was restricted to those hooks in do_debug().

Thanks,
K.Prasad

