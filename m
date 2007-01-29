Return-Path: <linux-kernel-owner+w=401wt.eu-S1750942AbXA2Phi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbXA2Phi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXA2Phi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:37:38 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3306 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbXA2Phh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:37:37 -0500
Date: Mon, 29 Jan 2007 15:37:25 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
       ppisa4lists@pikron.com
Subject: Re: ARM i.MX serial: fix tx buffer overflows
Message-ID: <20070129153725.GA6602@flint.arm.linux.org.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
	ppisa4lists@pikron.com
References: <20070105155144.GD5838@localhost.localdomain> <200701051901.52486.ppisa4lists@pikron.com> <20070129144758.GA2760@synertronixx3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129144758.GA2760@synertronixx3>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 03:47:59PM +0100, Konstantin Kletschke wrote:
> Am 2007-01-05 19:01 +0100 schrieb Pavel Pisa:
> 
> > It applies only for interrupts going through GPIO layer.
> > The problem has been noticed by Konstantin Kletschke
> > some time ago.
> > 
> >   No IRQF_TRIGGER set_type function for IRQ 26 (MPU)
> 
> Yes. I reported this also.
> 
> >  drivers/serial/imx.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.19-rt/drivers/serial/imx.c
> > ===================================================================
> > +++ linux-2.6.19-rt/drivers/serial/imx.c
> > @@ -403,7 +403,8 @@ static int imx_startup(struct uart_port 
> >  	if (retval) goto error_out2;
> >  
> >  	retval = request_irq(sport->rtsirq, imx_rtsint,
> > -			     IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> > +			     (sport->rtsirq < IMX_IRQS) ? 0 :
> > +			       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> >  			     DRIVER_NAME, sport);
> >  	if (retval) goto error_out3;
> 
> 
> Okay, this indeed fixes my
> 
> No IRQF_TRIGGER set_type function for IRQ 26 (MPU)

Is it really worth adding additional code to shut up this (imho) silly
warning?  It's just adding needless complexity to drivers.

What happens if a driver is used on multiple platforms, some of which
support trigger setting and others which don't?  Are we going to end
up with a large #ifdef in every driver?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
