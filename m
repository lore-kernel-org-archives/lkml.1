Return-Path: <linux-kernel-owner+w=401wt.eu-S938576AbXG3JTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938576AbXG3JTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765986AbXG3JTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:19:19 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:60304 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761793AbXG3JTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:19:17 -0400
Date: Mon, 30 Jul 2007 02:18:41 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mucci@cs.utk.edu, pwatkins@sicortex.com,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       mucci@cs.utk.edu, linux-mips@linux-mips.org, ak@suse.de,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] MIPS: add smp_call_function_single()
Message-ID: <20070730091841.GC25162@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070727124451.GC9828@frankl.hpl.hp.com> <20070727125533.GD5118@linux-mips.org> <20070727135323.GF9828@frankl.hpl.hp.com> <20070728091950.GA4642@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728091950.GA4642@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks for catching this. We will resubmit an updated version.

PHil, Peter, would you be able/willing to do this?

thanks.

On Sat, Jul 28, 2007 at 11:19:50AM +0200, Heiko Carstens wrote:
> On Fri, Jul 27, 2007 at 06:53:23AM -0700, Stephane Eranian wrote:
> > Ralf,
> > 
> > Here is take 2.
> > 
> > [MIPS] add smp_call_function_single (take 2)
> > 
> > signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
> > signed-off-by: Phil Mucci <mucci@cs.utk.edu>
> > 
> > diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> > index be7362b..d47234c 100644
> > --- a/arch/mips/kernel/smp.c
> > +++ b/arch/mips/kernel/smp.c
> > @@ -193,6 +193,53 @@ void smp_call_function_interrupt(void)
> >  	}
> >  }
> > 
> > +int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int retry,
> > +			     int wait)
> > +{
> > +	struct call_data_struct data;
> > +	int me = smp_processor_id();
> > +
> > +	/*
> > +	 * Can die spectacularly if this CPU isn't yet marked online
> > +	 */
> > +	BUG_ON(!cpu_online(me));
> > +	if (cpu == me) {
> > +		WARN_ON(1);
> > +		return -EBUSY;
> > +	}
> > +
> > +	/* Can deadlock when called with interrupts disabled */
> > +	WARN_ON(irqs_disabled());
> > +
> > +	data.func = func;
> > +	data.info = info;
> > +	atomic_set(&data.started, 0);
> > +	data.wait = wait;
> > +	if (wait)
> > +		atomic_set(&data.finished, 0);
> > +
> > +	spin_lock(&smp_call_lock);
> > +	call_data = &data;
> > +	mb();
> > +
> > +	/* Send a message to the other CPU */
> > +	core_send_ipi(cpu, SMP_CALL_FUNCTION);
> > +
> > +	/* Wait for response */
> > +	/* FIXME: lock-up detection, backtrace on lock-up */
> > +	while (atomic_read(&data.started) != 1)
> > +		barrier();
> > +
> > +	if (wait)
> > +		while (atomic_read(&data.finished) != 1)
> > +			barrier();
> > +	call_data = NULL;
> > +	spin_unlock(&smp_call_lock);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(smp_call_function_single);
> > +
> >  static void stop_this_cpu(void *dummy)
> >  {
> 
> This will not do the right thing. Semantics of smp_call_function_single()
> changed recently. It now is supposed to call func() locally with irqs
> disabled if cpu == smp_processor_id(). See i386/x86_64 and powerpc.
> Unfortunately ia64 hasn't been changed yet, so it will behave differently.

-- 

-Stephane
