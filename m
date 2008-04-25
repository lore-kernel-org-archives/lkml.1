Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYDYINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYDYINZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYDYINL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:13:11 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:48065 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYDYINJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:13:09 -0400
Subject: Re: [git pull] scheduler/misc fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, tglx@linutronix.de
In-Reply-To: <20080425.005738.114887644.davem@davemloft.net>
References: <20080424225530.GA8717@elte.hu>
	 <20080424.204620.88617191.davem@davemloft.net>
	 <1209109710.7115.400.camel@twins>
	 <20080425.005738.114887644.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 10:13:03 +0200
Message-Id: <1209111183.7115.402.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 00:57 -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 25 Apr 2008 09:48:30 +0200
> 
> >  c) there are 'IPI' handlers on SPARC64 that look like they can wake
> >     the CPU from idle sleep but do not appear to call irq_enter() which
> >     has the above patch's touch_softlock_watchdog() in its callchain.
> > 
> > tl0_irq1:       TRAP_IRQ(smp_call_function_client, 1)
> > tl0_irq2:       TRAP_IRQ(smp_receive_signal_client, 2)
> > tl0_irq3:       TRAP_IRQ(smp_penguin_jailcell, 3)
> > tl0_irq4:       TRAP_IRQ(smp_new_mmu_context_version_client, 4)
> > 
> > 
> > 
> > So the current working thesis is that the bug in a) hides a real problem
> > not quite fixed by b) and exploited by c).
> 
> The equivalent to smp_receive_signal_client() on x86
> (smp_reschedule_interrupt) doesn't do an irq_enter() either.
> 
> However x86 does do an irq_enter() for smp_call_function() interrupt
> handling.
> 
> What is the rule in these cases?
> 
> Anyways, does the following patch fix the problem?

Sadly, no :-(

> diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
> index 524b889..bf4ef84 100644
> --- a/arch/sparc64/kernel/smp.c
> +++ b/arch/sparc64/kernel/smp.c
> @@ -866,14 +866,21 @@ void smp_call_function_client(int irq, struct pt_regs *regs)
>  	void *info = call_data->info;
>  
>  	clear_softint(1 << irq);
> +
> +	irq_enter();
> +
> +	if (!call_data->wait) {
> +		/* let initiator proceed after getting data */
> +		atomic_inc(&call_data->finished);
> +	}
> +
> +	func(info);
> +
> +	irq_exit();
> +
>  	if (call_data->wait) {
>  		/* let initiator proceed only after completion */
> -		func(info);
> -		atomic_inc(&call_data->finished);
> -	} else {
> -		/* let initiator proceed after getting data */
>  		atomic_inc(&call_data->finished);
> -		func(info);
>  	}
>  }


