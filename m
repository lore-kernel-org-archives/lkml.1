Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbXKPJjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbXKPJjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 04:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXKPJjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 04:39:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35627 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXKPJjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 04:39:07 -0500
Subject: Re: [patch] x86: make delay_tsc() preemptible again
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <20071116084741.GA20011@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org>
	 <20071115194116.12c7a0f6@laptopd505.fenrus.org>
	 <473D5016.4000105@qumranet.com> <20071116083627.GA18225@elte.hu>
	 <20071116084741.GA20011@elte.hu>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 10:39:02 +0100
Message-Id: <1195205942.3059.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-16 at 09:47 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > but that should not be needed in this case. Why doesnt the TSC using 
> > delay loop simply poll the CPU it is on and fix up the TSC?
> 
> something like the patch below.
> 
> 	Ingo
> 
> --------------->
> Subject: x86: make delay_tsc() preemptible again
> From: Ingo Molnar <mingo@elte.hu>
> 
> make delay_tsc() preemptible again.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/lib/delay_32.c |   28 +++++++++++++++++++++++-----
>  arch/x86/lib/delay_64.c |   30 ++++++++++++++++++++++++------
>  2 files changed, 47 insertions(+), 11 deletions(-)
> 
> Index: linux/arch/x86/lib/delay_32.c
> ===================================================================
> --- linux.orig/arch/x86/lib/delay_32.c
> +++ linux/arch/x86/lib/delay_32.c
> @@ -38,17 +38,35 @@ static void delay_loop(unsigned long loo
>  		:"0" (loops));
>  }
>  
> -/* TSC based delay: */
> +/*
> + * TSC based delay:
> + *
> + * We are careful about preemption as TSC's are per-CPU.
> + */
>  static void delay_tsc(unsigned long loops)
>  {
> -	unsigned long bclock, now;
> +	unsigned long prev, now;
> +	long left = loops;
> +	int prev_cpu, cpu;
>  
> -	preempt_disable();		/* TSC's are per-cpu */
> -	rdtscl(bclock);
> +	preempt_disable();
> +	rdtscl(prev);
>  	do {
> +		prev_cpu = smp_processor_id();
>  		rep_nop();
> +		preempt_enable();

Why not have the rep_nop() here between the enable, and disable ?

> +
> +		preempt_disable();
> +		cpu = smp_processor_id();
>  		rdtscl(now);
> -	} while ((now-bclock) < loops);
> +		/*
> +		 * If we preempted we skip this small amount of time:
                           ^ migrated, perhaps?

> +		 */
> +		if (prev_cpu != cpu)
> +			prev = now;
> +		left -= now - prev;
> +		prev = now;
> +	} while (left > 0);
>  	preempt_enable();
>  }


Otherwise, looks like a very nice patch :-)


