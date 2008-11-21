Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYKUKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYKUKdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYKUKdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:33:39 -0500
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:39941 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYKUKdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:33:38 -0500
Subject: Re: Regression: Bisected, IRQ and MSI allocations screwed without
	sparse irq
From: Jesper Dangaard Brouer <jdb@comx.dk>
Reply-To: jdb@comx.dk
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Robert Olsson <Robert.Olsson@data.slu.se>
In-Reply-To: <alpine.LFD.2.00.0811201539360.3197@localhost.localdomain>
References: <1226572171.6834.87.camel@localhost.localdomain>
	 <20081113.141513.116537651.davem@davemloft.net>
	 <Pine.LNX.4.64.0811192333130.30818@ask.diku.dk>
	 <20081119.151138.93409143.davem@davemloft.net>
	 <Pine.LNX.4.64.0811202035590.19962@ask.diku.dk>
	 <alpine.LFD.2.00.0811201539360.3197@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: ComX Networks A/S
Date: Fri, 21 Nov 2008 11:33:34 +0100
Message-Id: <1227263614.25811.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 16:34 -0800, Thomas Gleixner wrote:
> On Thu, 20 Nov 2008, Jesper Dangaard Brouer wrote:
> > I have bisected a regression to your commit
> > 3235e936c0cc3589309280b6f59e5096779adae3,
> > "x86: remove sparse irq from Kconfig".
> > 
> > Its actually not necessary your fault, as your commit simply removes
> > the config option HAVE_SPARSE_IRQ.  This revels the bug / regression
> > I'm exposted to.
> 
> Yup, the bisect result is pretty useless.
>  
> > The cause of this problem (tracked down together with Robert Olsson)
> > is that on 2.6.28 I have a lot less IRQs available.  It seems max 34
> > IRQs.  Due the reduced number of IRQs the NIU driver cannot get
> > enough IRQs to the interfaces, and starts to use "IO-APIC" based
> > IRQs.
> 
> Can you please try the attached patch ?

I have tried the patch and it solved the problem! :-)

I'll gladly test other patches from your.  Guess this patch needs to be
brushed up before a mainline patch is ready.

My hardware is a HP ProLiant DL380-G5.


> -----
>  arch/x86/kernel/io_apic.c |   22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic.c
> +++ linux-2.6/arch/x86/kernel/io_apic.c
> @@ -3594,27 +3594,7 @@ int __init io_apic_get_redir_entries (in
>  
>  int __init probe_nr_irqs(void)
>  {
> -	int idx;
> -	int nr = 0;
> -#ifndef CONFIG_XEN
> -	int nr_min = 32;
> -#else
> -	int nr_min = NR_IRQS;
> -#endif
> -
> -	for (idx = 0; idx < nr_ioapics; idx++)
> -		nr += io_apic_get_redir_entries(idx) + 1;
> -
> -	/* double it for hotplug and msi and nmi */
> -	nr <<= 1;
> -
> -	/* something wrong ? */
> -	if (nr < nr_min)
> -		nr = nr_min;
> -	if (WARN_ON(nr > NR_IRQS))
> -		nr = NR_IRQS;
> -
> -	return nr;
> +	return NR_IRQS;
>  }
>  

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
