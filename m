Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYFJPrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYFJPrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYFJPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:47:25 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35614 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYFJPrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:47:24 -0400
Date: Tue, 10 Jun 2008 08:47:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080610154716.GF15481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-2-git-send-email-jens.axboe@oracle.com> <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 03:51:25PM +0100, Catalin Marinas wrote:
> Hi,
> 
> On Thu, 2008-05-29 at 10:58 +0200, Jens Axboe wrote:
> > This adds kernel/smp.c which contains helpers for IPI function calls. In
> > addition to supporting the existing smp_call_function() in a more efficient
> > manner, it also adds a more scalable variant called smp_call_function_single()
> > for calling a given function on a single CPU only.
> [...]
> > + * You must not call this function with disabled interrupts or from a
> > + * hardware interrupt handler or from a bottom half handler.
> > + */
> > +int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> > +			   int wait)
> > +{
> > +	struct call_function_data d;
> > +	struct call_function_data *data = NULL;
> > +	cpumask_t allbutself;
> > +	unsigned long flags;
> > +	int cpu, num_cpus;
> > +
> > +	/* Can deadlock when called with interrupts disabled */
> > +	WARN_ON(irqs_disabled());
> 
> I was thinking whether this condition can be removed and allow the
> smp_call_function*() to be called with IRQs disabled. At a quick look,
> it seems to be possible if the csd_flag_wait() function calls the IPI
> handlers directly when the IRQs are disabled (see the patch below).
> 
> This would be useful on ARM11MPCore based systems where the cache
> maintenance operations are not detected by the snoop control unit and
> this affects the DMA calls like dma_map_single(). There doesn't seem to
> be any restriction on calls to dma_map_single() and hence we cannot
> broadcast the cache operation to the other CPUs. I could implement this
> in the ARM specific code using spin_try_lock (on an IPI-specific lock
> held during the cross-call) and polling for an IPI if a lock cannot be
> acquired (meaning that a different CPU is issuing an IPI) but I was
> wondering whether this would be possible in a more generic way.
> 
> Please let me know what you think or whether deadlocks are still
> possible (or any other solution apart from hardware fixes :-)). Thanks.

There were objections last month:  http://lkml.org/lkml/2008/5/3/167

The issue was that this permits some interrupts to arrive despite
interrupts being disabled.  There seemed to be less resistance to
doing this in the wait==1 case, however.

						Thanx, Paul

> diff --git a/kernel/smp.c b/kernel/smp.c
> index ef6de3d..2c63e81 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -54,6 +54,10 @@ static void csd_flag_wait(struct call_single_data *data)
>  		smp_mb();
>  		if (!(data->flags & CSD_FLAG_WAIT))
>  			break;
> +		if (irqs_disabled()) {
> +			generic_smp_call_function_single_interrupt();
> +			generic_smp_call_function_interrupt();
> +		}
>  		cpu_relax();
>  	} while (1);
>  }
> @@ -208,9 +212,6 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  	/* prevent preemption and reschedule on another processor */
>  	int me = get_cpu();
> 
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
>  	if (cpu == me) {
>  		local_irq_save(flags);
>  		func(info);
> @@ -250,9 +251,6 @@ EXPORT_SYMBOL(smp_call_function_single);
>   */
>  void __smp_call_function_single(int cpu, struct call_single_data *data)
>  {
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
> -
>  	generic_exec_single(cpu, data);
>  }
> 
> @@ -279,9 +277,6 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
>  	unsigned long flags;
>  	int cpu, num_cpus;
> 
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
>  	cpu = smp_processor_id();
>  	allbutself = cpu_online_map;
>  	cpu_clear(cpu, allbutself);
> 
> 
> -- 
> Catalin
> 
