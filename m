Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbXHFHGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbXHFHGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXHFHFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:05:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:34922 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXHFHFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TnVBcnxHay0p9SemXA/VXf8Txx1iIzXcsh1B7o5JIKtekerthiCUMUZl9ms4bZ3CZkqthhyXB+IC/rbxII0/40/80u/MxJ8+cL23J1cKYDVuWB3syOVb+WQCKIi1QysKm2yr1UvgVgnQnnRBX5iUEjHwA45eMN2CrJJgJC0Ndj0=
Message-ID: <4bacf17f0708060005o33af2c21yc1b909d4fc2beb01@mail.gmail.com>
Date: Mon, 6 Aug 2007 09:05:52 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: [patch] genirq: fix simple and fasteoi irq handlers
Cc: "Ingo Molnar" <mingo@elte.hu>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070803060733.GA1582@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
	 <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu>
	 <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu>
	 <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
	 <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com>
	 <20070802201126.GA27000@elte.hu> <20070803060733.GA1582@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/3, Jarek Poplawski <jarkao2@o2.pl>:
> Hi,
>
> I can't guarantee this is all needed to fix this bug, but I think
> this patch is necessary here.
>
> Regards,
> Jarek P.
> ------------>
>
> Subject: genirq: fix simple and fasteoi irq handlers
>
> After the "genirq: do not mask interrupts by default" patch interrupts
> should be disabled not immediately upon request, but after they happen.
> But, handle_simple_irq() and handle_fasteoi_irq() can skip this once or
> more if an irq is just serviced (IRQ_INPROGRESS), possibly disrupting a
> driver's work.
>
> The main reason of problems here, pointing the broken patch and making
> the first patch which can fix this was done by Marcin Slusarz.
> Additional test patches of Thomas Gleixner and Ingo Molnar tested by
> Marcin Slusarz helped to narrow possible reasons even more. Thanks.
>
> PS: this patch fixes only one evident error here, but there could be
> more places affected by above-mentioned change in irq handling.
>
>
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
>
> ---
>
> diff -Nurp 2.6.23-rc1-/kernel/irq/chip.c 2.6.23-rc1/kernel/irq/chip.c
> --- 2.6.23-rc1-/kernel/irq/chip.c       2007-07-09 01:32:17.000000000 +0200
> +++ 2.6.23-rc1/kernel/irq/chip.c        2007-08-02 20:42:38.000000000 +0200
> @@ -295,12 +295,11 @@ handle_simple_irq(unsigned int irq, stru
>
>         spin_lock(&desc->lock);
>
> -       if (unlikely(desc->status & IRQ_INPROGRESS))
> -               goto out_unlock;
>         kstat_cpu(cpu).irqs[irq]++;
>
>         action = desc->action;
> -       if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
> +       if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
> +                                                IRQ_DISABLED)))) {
>                 if (desc->chip->mask)
>                         desc->chip->mask(irq);
>                 desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
> @@ -392,18 +391,16 @@ handle_fasteoi_irq(unsigned int irq, str
>
>         spin_lock(&desc->lock);
>
> -       if (unlikely(desc->status & IRQ_INPROGRESS))
> -               goto out;
> -
>         desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
>         kstat_cpu(cpu).irqs[irq]++;
>
>         /*
> -        * If its disabled or no action available
> +        * If it's running, disabled or no action available
>          * then mask it and get out of here:
>          */
>         action = desc->action;
> -       if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
> +       if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
> +                                                IRQ_DISABLED)))) {
>                 desc->status |= IRQ_PENDING;
>                 if (desc->chip->mask)
>                         desc->chip->mask(irq);
>
This patch didn't fix my NIC (tried on 2.6.22.1)

Marcin
