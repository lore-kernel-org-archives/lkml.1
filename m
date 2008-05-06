Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYEFMcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYEFMcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYEFMcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:32:01 -0400
Received: from www.tglx.de ([62.245.132.106]:35333 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYEFMcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:32:00 -0400
Date: Tue, 6 May 2008 14:31:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, jkosina@suse.cz,
       zdenek.kabelac@gmail.com
Subject: Re: [PATCH REPOST^3] Run IST traps from user mode preemptive on
 process stack
In-Reply-To: <20080502091948.GA26099@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0805061305460.3318@apollo.tec.linutronix.de>
References: <20080502091948.GA26099@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Andi Kleen wrote:
> [Fixes a bug originally introduced in 2.6.23 I think. Reposted many times
> so far, but still not applied. Please apply.]

The print_vma_addr() bug was introduced by commit 03252919 (by you) in
the 2.6.25 merge window and we fixed it before 25-rc2 via commit e8bff74a.

Do you know about any other breakage in that code? If not, why do you
claim that we ignored a bug fix?
 
> Run IST traps from user mode preemptive on process stack
> 
> x86-64 has a few exceptions which run on special architecture 
> supported IST exception stacks: these are nmi, double fault, stack fault,
> int 3, debug.

+ MCE
 
> Previously they would check for a scheduling event on returning
> if the original CPU state was user mode and then switch to a 
> process stack to schedule.
>
> But the actual trap handler would still run on the IST stack
> with preemption disabled.
> 
> This patch changes these traps instead to always switch 
> to the process stack when the trap originated from user mode.
> For kernel traps it keeps running non preemptive on the IST stack
> because that is much safer (e.g. to still get nmi watchdog events
> out even when the process stack is corrupted) 
> 
> Then the actual trap handlers can run with preemption enabled
> or schedule as needed (e.g. to take locks) 
> 
> This fixes a regression I added earlier with print_vma_addr()
> executing down() in these trap handlers from user space.

Aside of the fact, that it has been fixed long time ago in a simple
and non dangerous way already, your "fix" adds a far more serious
regression:

> --- linux.orig/arch/x86/kernel/entry_64.S
> +++ linux/arch/x86/kernel/entry_64.S
> @@ -771,12 +771,18 @@ END(spurious_interrupt)
>  	.if \ist
>  	movq	%gs:pda_data_offset, %rbp
>  	.endif
> -	movq %rsp,%rdi
>  	movq ORIG_RAX(%rsp),%rsi
>  	movq $-1,ORIG_RAX(%rsp)
>  	.if \ist
>  	subq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
>  	.endif
> +	testl $3,CS(%rsp)
> +	jz 2f					/* in kernel? stay on exception stack for now */
> +	movq %rsp,%rdi
> +	call sync_regs				/* Move all state over to process stack */
> +	movq %rax,%rsp				/* switch stack to process stack */
> +2:
> +	movq %rsp,%rdi
>  	call \sym
>  	.if \ist
>  	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)

This introduces two security bugs in one go:

1.) The IST stack pointer is elevated unconditionaly and with your
change we can now schedule away in the handler. Then another task on
this same CPU triggers the same trap and elevates it again. This can
nest multiple times and there is no protection against an IST stack
overflow at all!

This is probably a nice fat user-triggerable root hole in fact!
Exploitable because user-space has control over the pt_regs data,
so by nesting enough such overflows a critical kernel data structure
can probably be written with near-arbitrary content.

At minimum you've introuduced a nasty DoS hole that would almost never
trigger during normal loads - it would probably result in extremely hard
to debug memory corruption in data structures that are near the IST stacks.

2.) The IST stack pointer is unbalanced in the other direction as well:
it is incremented on CPUn then the handler is scheduled away and migrated
to CPUm. After return from the handler the IST stacks of both CPUs are
corrupted. Exploitable by unprivileged user-space code as well.

Thanks,

	tglx
