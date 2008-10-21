Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYJUOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYJUOrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYJUOr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:47:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56393 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYJUOr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:47:27 -0400
Date: Tue, 21 Oct 2008 10:45:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: make oops_begin and oops_end equal
Message-ID: <20081021144505.GA25750@hmsreliant.think-freely.org>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu> <20081020134211.GA15574@hmsreliant.think-freely.org> <20081020150731.GA25999@mailshack.com> <20081020150834.GA26018@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020150834.GA26018@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 05:08:34PM +0200, Alexander van Heukelum wrote:
> Mostly use the x86_64 version of oops_begin() and oops_end() on
> i386 too. Changes to the original x86_64 version:
> 
Hey, doing a sight review this am here.  Didn't find anything major, but I did
find a few little nits.  comments inlie

>  - move add_taint(TAINT_DIE) into oops_end()
>  - add a conditional crash_kexec() into oops_end()
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> ---
>  arch/x86/kernel/dumpstack_32.c |   36 +++++++++++++++++++++---------------
>  arch/x86/kernel/dumpstack_64.c |    4 +++-
>  2 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index b361475..e45952b 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -289,35 +289,41 @@ static unsigned int die_nest_count;
>  
>  unsigned __kprobes long oops_begin(void)
>  {
> +	int cpu;
>  	unsigned long flags;
>  
>  	oops_enter();
>  
> -	if (die_owner != raw_smp_processor_id()) {
> -		console_verbose();
> -		raw_local_irq_save(flags);
> -		__raw_spin_lock(&die_lock);
> -		die_owner = smp_processor_id();
> -		die_nest_count = 0;
> -		bust_spinlocks(1);
> -	} else {
> -		raw_local_irq_save(flags);
> +	/* racy, but better than risking deadlock. */
> +	raw_local_irq_save(flags);
> +	cpu = smp_processor_id();
> +	if (!__raw_spin_trylock(&die_lock)) {
> +		if (cpu == die_owner)
> +			/* nested oops. should stop eventually */;
> +		else
> +			__raw_spin_lock(&die_lock);
>  	}
>  	die_nest_count++;
> +	die_owner = cpu;
> +	console_verbose();
> +	bust_spinlocks(1);
>  	return flags;
>  }
>  
>  void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  {
> -	bust_spinlocks(0);
>  	die_owner = -1;
> +	bust_spinlocks(0);
> +	die_nest_count--;
>  	add_taint(TAINT_DIE);
> -	__raw_spin_unlock(&die_lock);
> +	if (!die_nest_count)
> +		/* Nest count reaches zero, release the lock. */
> +		__raw_spin_unlock(&die_lock);
>  	raw_local_irq_restore(flags);
> -
> -	if (!regs)
> +	if (!regs) {
> +		oops_exit();
>  		return;
> -
> +	}
>  	if (kexec_should_crash(current))
>  		crash_kexec(regs);
Hmm.  I think this creates the same case that I just fixed in my initial post.
If we start using oops_end with this here, it may be possible to call
crash_kexec with the console_sem held.  If that happens, we deadlock.  I think
you should be able to move this clause up above the bust_spinlocks(0) without
any issue, and that would take care of that

>  	if (in_interrupt())
> @@ -405,6 +411,7 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
>  		panic("Non maskable interrupt");
>  	console_silent();
>  	spin_unlock(&nmi_print_lock);
> +	bust_spinlocks(0);
>  
>  	/*
>  	 * If we are in kernel we are probably nested up pretty bad
> @@ -415,7 +422,6 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
>  		crash_kexec(regs);
>  	}
>  
> -	bust_spinlocks(0);
>  	do_exit(SIGSEGV);
>  }
>  
This undoes my previous patch.  I realize your second patch fixes it properly so
the ordering is correct when oops_begin and oops_end are used, but if you could
rediff so this isn't here, I'd appreciate it.  If these patches are committed
separately, you'll avoid having the tree in a state where that deadlock can
reoccur (even if it is just for one commit)

> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 96a5db7..cd7b46b 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -461,6 +461,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  	die_owner = -1;
>  	bust_spinlocks(0);
>  	die_nest_count--;
> +	add_taint(TAINT_DIE);
>  	if (!die_nest_count)
>  		/* Nest count reaches zero, release the lock. */
>  		__raw_spin_unlock(&die_lock);
> @@ -469,6 +470,8 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  		oops_exit();
>  		return;
>  	}
> +	if (kexec_should_crash(current))
> +		crash_kexec(regs);
If you're going to add the crash_kexec here (which looking at the call sites,
makes sense to me), you should likely remove it from the critical section of die
and die_nmi, just to avoid the redundancy.  Same issue as the 32 bit version
above applies, this needs to happen before you call bust_spinlocks(0).

Fix those issues, and the rest looks good to me.

Regards
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
