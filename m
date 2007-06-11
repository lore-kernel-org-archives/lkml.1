Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbXFKI5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbXFKI5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXFKI5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:57:16 -0400
Received: from www.osadl.org ([213.239.205.134]:53192 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750946AbXFKI5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:57:15 -0400
Subject: Re: [patch-mm 19/23] x86_64: Convert to cleckevents
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
In-Reply-To: <20070611104740.22adc9bc@frecb000686.frec.bull.fr>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092447.072839259@inhelltoy.tec.linutronix.de>
	 <20070611104740.22adc9bc@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=utf-8
Date: Mon, 11 Jun 2007 10:57:11 +0200
Message-Id: <1181552231.8176.45.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 10:47 +0200, Sébastien Dugué wrote:
> Hi Thomas,
> 
> On Sun, 10 Jun 2007 09:44:18 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Convert x86_64 to the clockevents code. Share code with i386 for
> > hpet and PIT.
> > 
> > Build and whitespace fixups from:
> >  Venki Pallipadi <venkatesh.pallipadi@intel.com>
> > and
> >  Chris Wright <chrisw@sous-sol.org>
> 
> 
>   It seems that the hpet clocksource's ->vread has been lost in the conversion.
> Is this on purpose?
> 
>   The patch below fixes it for x86_64 on 2.6.21.3-rt9. If you want it rebased
> on -mm let me know.
> 
>   Thanks,
> 
>   Sébastien.

Indeed. 

Thanks,

	tglx


> ---
> 
>   It seems the hpet clocksource's vread method was lost in the x86_64 conversion
> to clockevent. So here it is.
> 
> Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
> 
>  arch/i386/kernel/hpet.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-2.6.21.3-rt9/arch/i386/kernel/hpet.c
> ===================================================================
> --- linux-2.6.21.3-rt9.orig/arch/i386/kernel/hpet.c	2007-06-07 15:09:41.000000000 +0200
> +++ linux-2.6.21.3-rt9/arch/i386/kernel/hpet.c	2007-06-07 15:50:50.000000000 +0200
> @@ -313,6 +313,13 @@ static cycle_t notrace read_hpet(void)
>  	return (cycle_t)hpet_readl(HPET_COUNTER);
>  }
>  
> +#ifdef CONFIG_X86_64
> +static notrace cycle_t __vsyscall_fn vread_hpet(void)
> +{
> +	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
> +}
> +#endif
> +
>  static struct clocksource clocksource_hpet = {
>  	.name		= "hpet",
>  	.rating		= 250,
> @@ -321,6 +328,9 @@ static struct clocksource clocksource_hp
>  	.shift		= HPET_SHIFT,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  	.resume		= hpet_restart_counter,
> +#ifdef CONFIG_X86_64
> +	.vread		= vread_hpet,
> +#endif
>  };
>  
>  static int hpet_clocksource_register(void)
> 

