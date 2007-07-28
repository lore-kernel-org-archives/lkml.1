Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbXG1JUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbXG1JUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 05:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXG1JU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 05:20:27 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:4958 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXG1JU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 05:20:26 -0400
Date: Sat, 28 Jul 2007 11:19:50 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       mucci@cs.utk.edu, linux-mips@linux-mips.org, ak@suse.de,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] MIPS: add smp_call_function_single()
Message-ID: <20070728091950.GA4642@osiris.boeblingen.de.ibm.com>
References: <20070727124451.GC9828@frankl.hpl.hp.com> <20070727125533.GD5118@linux-mips.org> <20070727135323.GF9828@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727135323.GF9828@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 06:53:23AM -0700, Stephane Eranian wrote:
> Ralf,
> 
> Here is take 2.
> 
> [MIPS] add smp_call_function_single (take 2)
> 
> signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
> signed-off-by: Phil Mucci <mucci@cs.utk.edu>
> 
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index be7362b..d47234c 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -193,6 +193,53 @@ void smp_call_function_interrupt(void)
>  	}
>  }
> 
> +int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int retry,
> +			     int wait)
> +{
> +	struct call_data_struct data;
> +	int me = smp_processor_id();
> +
> +	/*
> +	 * Can die spectacularly if this CPU isn't yet marked online
> +	 */
> +	BUG_ON(!cpu_online(me));
> +	if (cpu == me) {
> +		WARN_ON(1);
> +		return -EBUSY;
> +	}
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
> +	data.func = func;
> +	data.info = info;
> +	atomic_set(&data.started, 0);
> +	data.wait = wait;
> +	if (wait)
> +		atomic_set(&data.finished, 0);
> +
> +	spin_lock(&smp_call_lock);
> +	call_data = &data;
> +	mb();
> +
> +	/* Send a message to the other CPU */
> +	core_send_ipi(cpu, SMP_CALL_FUNCTION);
> +
> +	/* Wait for response */
> +	/* FIXME: lock-up detection, backtrace on lock-up */
> +	while (atomic_read(&data.started) != 1)
> +		barrier();
> +
> +	if (wait)
> +		while (atomic_read(&data.finished) != 1)
> +			barrier();
> +	call_data = NULL;
> +	spin_unlock(&smp_call_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(smp_call_function_single);
> +
>  static void stop_this_cpu(void *dummy)
>  {

This will not do the right thing. Semantics of smp_call_function_single()
changed recently. It now is supposed to call func() locally with irqs
disabled if cpu == smp_processor_id(). See i386/x86_64 and powerpc.
Unfortunately ia64 hasn't been changed yet, so it will behave differently.
