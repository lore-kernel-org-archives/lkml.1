Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZFJHBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZFJHBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZFJHA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:00:59 -0400
Received: from mx1.emlix.com ([193.175.82.87]:56772 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZFJHA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:00:58 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Wed, 10 Jun 2009 09:00:58 +0200
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Oskar Schirmer <os@emlix.com>, Sascha Hauer <kernel@pengutronix.de>,
       linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>
Subject: Re: [PATCH 8/8] imx: serial: add IrDA support to serial driver
Message-ID: <20090610070058.GA18851@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com> <1244555211-15618-2-git-send-email-os@emlix.com> <1244555211-15618-3-git-send-email-os@emlix.com> <1244555211-15618-4-git-send-email-os@emlix.com> <1244555211-15618-5-git-send-email-os@emlix.com> <1244555211-15618-6-git-send-email-os@emlix.com> <1244555211-15618-7-git-send-email-os@emlix.com> <1244555211-15618-8-git-send-email-os@emlix.com> <1244555211-15618-9-git-send-email-os@emlix.com> <20090609181038.GA32355@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090609181038.GA32355@pengutronix.de>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 20:10:38 +0200, Sascha Hauer wrote:
> Hi Oskar,
> 
> Some comments inline.
> 
> On Tue, Jun 09, 2009 at 03:46:51PM +0200, Oskar Schirmer wrote:
> > From: Fabian Godehardt <fg@emlix.com>
> > 
> > Using the iMX serial driver with an IrDA device
> > needs extra peripheral settings and specific
> > timing depending on the transmitter circuitry used.
> > 
> > Signed-off-by: Fabian Godehardt <fg@emlix.com>
> > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > ---
> >  arch/arm/mach-imx/include/mach/imx-uart.h |    4 +
> >  drivers/serial/imx.c                      |  207 ++++++++++++++++++++++++++---
> >  2 files changed, 192 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/include/mach/imx-uart.h b/arch/arm/mach-imx/include/mach/imx-uart.h
> > index d54eb1d..01ea268 100644
> > --- a/arch/arm/mach-imx/include/mach/imx-uart.h
> > +++ b/arch/arm/mach-imx/include/mach/imx-uart.h
> > @@ -2,11 +2,15 @@
> >  #define ASMARM_ARCH_UART_H
> >  
> >  #define IMXUART_HAVE_RTSCTS (1<<0)
> > +#define IMXUART_IRDA        (1<<1)
> >  
> >  struct imxuart_platform_data {
> >  	int (*init)(struct platform_device *pdev);
> >  	void (*exit)(struct platform_device *pdev);
> >  	unsigned int flags;
> > +#ifdef CONFIG_IRDA
> > +	void (*irda_enable)(int enable);
> > +#endif
> 
> I think you shouldn't ifdef this field. Otherwise platform code needs
> exactly this ifdef aswell.

Right. I'll change that.

> >  };
> >  
> >  #endif
> > diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
> > index 11f93e2..305b6bf 100644
> > --- a/drivers/serial/imx.c
> > +++ b/drivers/serial/imx.c
> > @@ -8,6 +8,9 @@
> >   *  Author: Sascha Hauer <sascha@saschahauer.de>
> >   *  Copyright (C) 2004 Pengutronix
> >   *
> > + *  Copyright (C) 2009 emlix GmbH
> > + *  Author: Fabian Godehardt (added IrDA support for iMX)
> > + *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License as published by
> >   * the Free Software Foundation; either version 2 of the License, or
> > @@ -41,6 +44,7 @@
> >  #include <linux/serial_core.h>
> >  #include <linux/serial.h>
> >  #include <linux/clk.h>
> > +#include <linux/delay.h>
> >  #include <linux/rational.h>
> >  
> >  #include <asm/io.h>
> > @@ -149,6 +153,7 @@
> >  #define  UCR4_DREN  	 (1<<0)  /* Recv data ready interrupt enable */
> >  #define  UFCR_RXTL_SHF   0       /* Receiver trigger level shift */
> >  #define  UFCR_RFDIV      (7<<7)  /* Reference freq divider mask */
> > +#define  UFCR_RFDIV_REG(x)	(((x) < 7 ? 6 - (x) : 6) << 7)
> >  #define  UFCR_TXTL_SHF   10      /* Transmitter trigger level shift */
> >  #define  USR1_PARITYERR  (1<<15) /* Parity error interrupt flag */
> >  #define  USR1_RTSS  	 (1<<14) /* RTS pin status */
> > @@ -213,9 +218,21 @@ struct imx_port {
> >  	unsigned int		old_status;
> >  	int			txirq,rxirq,rtsirq;
> >  	unsigned int		have_rtscts:1;
> > +#ifdef CONFIG_IRDA
> > +	unsigned int		use_irda:1;
> > +	unsigned int		irda_inv_rx:1;
> > +	unsigned int		irda_inv_tx:1;
> > +	int			trcv_delay; /* transceiver delay */
> > +#endif
> 
> You can't use USE_IRDA() several times in your patch because you ifdef
> these fields. Given the fact that these only add 4 bytes to struct
> imx_port you could remove the ifdef here and use USE_IRDA()
> consistently.

Ok.

> Do you need these fields anyway? Their values are hardcoded in the
> driver and can't be overridden by platform code.

We used to set them via sysfs, but we thought the patch for that
is not generically reusable. I'll see if I add the default settings
to platform data, so they wont be hardcoded but can be adjusted
to the hardware used as needed.

  Oskar

> 
> Sascha
> 
> >  	struct clk		*clk;
> >  };
> >  
> > +#ifdef CONFIG_IRDA
> > +#define USE_IRDA(sport)	((sport)->use_irda)
> > +#else
> > +#define USE_IRDA(sport)	(0)
> > +#endif
> > +
> >  /*
> >   * Handle any change of modem status signal since we were last called.
> >   */
> > @@ -269,6 +286,50 @@ static void imx_stop_tx(struct uart_port *port)
> >  	struct imx_port *sport = (struct imx_port *)port;
> >  	unsigned long temp;
> >  
> > +#ifdef CONFIG_IRDA
> > +	if (sport->use_irda) {
> > +		/* half duplex - wait for end of transmission */
> > +		int n = 256;
> > +		while ((--n > 0) &&
> > +		      !(readl(sport->port.membase + USR2) & USR2_TXDC)) {
> > +			udelay(5);
> > +			barrier();
> > +		}
> > +		/*
> > +		 * irda transceiver - wait a bit more to avoid
> > +		 * cutoff, hardware dependent
> > +		 */
> > +		udelay(sport->trcv_delay);
> > +
> > +		/*
> > +		 * half duplex - reactivate receive mode,
> > +		 * flush receive pipe echo crap
> > +		 */
> > +		if (readl(sport->port.membase + USR2) & USR2_TXDC) {
> > +			temp = readl(sport->port.membase + UCR1);
> > +			temp &= ~(UCR1_TXMPTYEN | UCR1_TRDYEN);
> > +			writel(temp, sport->port.membase + UCR1);
> > +
> > +			temp = readl(sport->port.membase + UCR4);
> > +			temp &= ~(UCR4_TCEN);
> > +			writel(temp, sport->port.membase + UCR4);
> > +
> > +			while (readl(sport->port.membase + URXD0) &
> > +			       URXD_CHARRDY)
> > +				barrier();
> > +
> > +			temp = readl(sport->port.membase + UCR1);
> > +			temp |= UCR1_RRDYEN;
> > +			writel(temp, sport->port.membase + UCR1);
> > +
> > +			temp = readl(sport->port.membase + UCR4);
> > +			temp |= UCR4_DREN;
> > +			writel(temp, sport->port.membase + UCR4);
> > +		}
> > +		return;
> > +	}
> > +#endif
> > +
> >  	temp = readl(sport->port.membase + UCR1);
> >  	writel(temp & ~UCR1_TXMPTYEN, sport->port.membase + UCR1);
> >  }
> > @@ -324,9 +385,30 @@ static void imx_start_tx(struct uart_port *port)
> >  	struct imx_port *sport = (struct imx_port *)port;
> >  	unsigned long temp;
> >  
> > +	if (USE_IRDA(sport)) {
> > +		/* half duplex in IrDA mode; have to disable receive mode */
> > +		temp = readl(sport->port.membase + UCR4);
> > +		temp &= ~(UCR4_DREN);
> > +		writel(temp, sport->port.membase + UCR4);
> > +
> > +		temp = readl(sport->port.membase + UCR1);
> > +		temp &= ~(UCR1_RRDYEN);
> > +		writel(temp, sport->port.membase + UCR1);
> > +	}
> > +
> >  	temp = readl(sport->port.membase + UCR1);
> >  	writel(temp | UCR1_TXMPTYEN, sport->port.membase + UCR1);
> >  
> > +	if (USE_IRDA(sport)) {
> > +		temp = readl(sport->port.membase + UCR1);
> > +		temp |= UCR1_TRDYEN;
> > +		writel(temp, sport->port.membase + UCR1);
> > +
> > +		temp = readl(sport->port.membase + UCR4);
> > +		temp |= UCR4_TCEN;
> > +		writel(temp, sport->port.membase + UCR4);
> > +	}
> > +
> >  	if (readl(sport->port.membase + UTS) & UTS_TXEMPTY)
> >  		imx_transmit_buffer(sport);
> >  }
> > @@ -536,12 +618,7 @@ static int imx_setup_ufcr(struct imx_port *sport, unsigned int mode)
> >  	if(!ufcr_rfdiv)
> >  		ufcr_rfdiv = 1;
> >  
> > -	if(ufcr_rfdiv >= 7)
> > -		ufcr_rfdiv = 6;
> > -	else
> > -		ufcr_rfdiv = 6 - ufcr_rfdiv;
> > -
> > -	val |= UFCR_RFDIV & (ufcr_rfdiv << 7);
> > +	val |= UFCR_RFDIV_REG(ufcr_rfdiv);
> >  
> >  	writel(val, sport->port.membase + UFCR);
> >  
> > @@ -560,8 +637,24 @@ static int imx_startup(struct uart_port *port)
> >  	 * requesting IRQs
> >  	 */
> >  	temp = readl(sport->port.membase + UCR4);
> > +
> > +	if (USE_IRDA(sport))
> > +		temp |= UCR4_IRSC;
> > +
> >  	writel(temp & ~UCR4_DREN, sport->port.membase + UCR4);
> >  
> > +	if (USE_IRDA(sport)) {
> > +		/* reset fifo's and state machines */
> > +		int i = 100;
> > +		temp = readl(sport->port.membase + UCR2);
> > +		temp &= ~UCR2_SRST;
> > +		writel(temp, sport->port.membase + UCR2);
> > +		while (!(readl(sport->port.membase + UCR2) & UCR2_SRST) &&
> > +		    (--i > 0)) {
> > +			udelay(1);
> > +		}
> > +	}
> > +
> >  	/*
> >  	 * Allocate the IRQ(s) i.MX1 has three interrupts whereas later
> >  	 * chips only have one interrupt.
> > @@ -577,12 +670,16 @@ static int imx_startup(struct uart_port *port)
> >  		if (retval)
> >  			goto error_out2;
> >  
> > -		retval = request_irq(sport->rtsirq, imx_rtsint,
> > -			     (sport->rtsirq < MAX_INTERNAL_IRQ) ? 0 :
> > -			       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> > -				DRIVER_NAME, sport);
> > -		if (retval)
> > -			goto error_out3;
> > +		/* do not use RTS IRQ on IrDA */
> > +		if (!USE_IRDA(sport)) {
> > +			retval = request_irq(sport->rtsirq, imx_rtsint,
> > +				     (sport->rtsirq < MAX_INTERNAL_IRQ) ? 0 :
> > +				       IRQF_TRIGGER_FALLING |
> > +				       IRQF_TRIGGER_RISING,
> > +					DRIVER_NAME, sport);
> > +			if (retval)
> > +				goto error_out3;
> > +		}
> >  	} else {
> >  		retval = request_irq(sport->port.irq, imx_int, 0,
> >  				DRIVER_NAME, sport);
> > @@ -599,18 +696,51 @@ static int imx_startup(struct uart_port *port)
> >  
> >  	temp = readl(sport->port.membase + UCR1);
> >  	temp |= UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN;
> > +
> > +	if (USE_IRDA(sport)) {
> > +		temp |= UCR1_IREN;
> > +		temp &= ~(UCR1_RTSDEN);
> > +	}
> > +
> >  	writel(temp, sport->port.membase + UCR1);
> >  
> >  	temp = readl(sport->port.membase + UCR2);
> >  	temp |= (UCR2_RXEN | UCR2_TXEN);
> >  	writel(temp, sport->port.membase + UCR2);
> >  
> > +	if (USE_IRDA(sport)) {
> > +		/* clear RX-FIFO */
> > +		int i = 64;
> > +		while ((--i > 0) &&
> > +			(readl(sport->port.membase + URXD0) & URXD_CHARRDY)) {
> > +			barrier();
> > +		}
> > +	}
> > +
> >  #if defined CONFIG_ARCH_MX2 || defined CONFIG_ARCH_MX3
> >  	temp = readl(sport->port.membase + UCR3);
> >  	temp |= UCR3_RXDMUXSEL;
> >  	writel(temp, sport->port.membase + UCR3);
> >  #endif
> >  
> > +#ifdef CONFIG_IRDA
> > +	if (sport->use_irda) {
> > +		temp = readl(sport->port.membase + UCR4);
> > +		if (sport->irda_inv_rx)
> > +			temp |= UCR4_INVR;
> > +		else
> > +			temp &= ~(UCR4_INVR);
> > +		writel(temp | UCR4_DREN, sport->port.membase + UCR4);
> > +
> > +		temp = readl(sport->port.membase + UCR3);
> > +		if (sport->irda_inv_tx)
> > +			temp |= UCR3_INVT;
> > +		else
> > +			temp &= ~(UCR3_INVT);
> > +		writel(temp, sport->port.membase + UCR3);
> > +	}
> > +#endif
> > +
> >  	/*
> >  	 * Enable modem status interrupts
> >  	 */
> > @@ -618,6 +748,15 @@ static int imx_startup(struct uart_port *port)
> >  	imx_enable_ms(&sport->port);
> >  	spin_unlock_irqrestore(&sport->port.lock,flags);
> >  
> > +#ifdef CONFIG_IRDA
> > +	if (sport->use_irda) {
> > +		struct imxuart_platform_data *pdata;
> > +		pdata = sport->port.dev->platform_data;
> > +		if (pdata->irda_enable)
> > +			pdata->irda_enable(1);
> > +	}
> > +#endif
> > +
> >  	return 0;
> >  
> >  error_out3:
> > @@ -639,6 +778,15 @@ static void imx_shutdown(struct uart_port *port)
> >  	temp &= ~(UCR2_TXEN);
> >  	writel(temp, sport->port.membase + UCR2);
> >  
> > +#ifdef CONFIG_IRDA
> > +	if (sport->use_irda) {
> > +		struct imxuart_platform_data *pdata;
> > +		pdata = sport->port.dev->platform_data;
> > +		if (pdata->irda_enable)
> > +			pdata->irda_enable(0);
> > +	}
> > +#endif
> > +
> >  	/*
> >  	 * Stop our timer.
> >  	 */
> > @@ -648,7 +796,8 @@ static void imx_shutdown(struct uart_port *port)
> >  	 * Free the interrupts
> >  	 */
> >  	if (sport->txirq > 0) {
> > -		free_irq(sport->rtsirq, sport);
> > +		if (!USE_IRDA(sport))
> > +			free_irq(sport->rtsirq, sport);
> >  		free_irq(sport->txirq, sport);
> >  		free_irq(sport->rxirq, sport);
> >  	} else
> > @@ -660,6 +809,9 @@ static void imx_shutdown(struct uart_port *port)
> >  
> >  	temp = readl(sport->port.membase + UCR1);
> >  	temp &= ~(UCR1_TXMPTYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN);
> > +	if (USE_IRDA(sport))
> > +		temp &= ~(UCR1_IREN);
> > +
> >  	writel(temp, sport->port.membase + UCR1);
> >  }
> >  
> > @@ -768,11 +920,19 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
> >  			sport->port.membase + UCR2);
> >  	old_txrxen &= (UCR2_TXEN | UCR2_RXEN);
> >  
> > -	div = sport->port.uartclk / (baud * 16);
> > -	if (div > 7)
> > -		div = 7;
> > -	if (!div)
> > +	if (USE_IRDA(sport)) {
> > +		/*
> > +		 * use maximum available submodule frequency to
> > +		 * avoid missing short pulses due to low sampling rate
> > +		 */
> >  		div = 1;
> > +	} else {
> > +		div = sport->port.uartclk / (baud * 16);
> > +		if (div > 7)
> > +			div = 7;
> > +		if (!div)
> > +			div = 1;
> > +	}
> >  
> >  	rational_best_approximation(16 * div * baud, sport->port.uartclk,
> >  		1 << 16, 1 << 16, &num, &denom);
> > @@ -781,8 +941,7 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
> >  	denom -= 1;
> >  
> >  	ufcr = readl(sport->port.membase + UFCR);
> > -	ufcr = (ufcr & (~UFCR_RFDIV)) |
> > -	    (div << 7);
> > +	ufcr = (ufcr & (~UFCR_RFDIV)) | UFCR_RFDIV_REG(div);
> >  	writel(ufcr, sport->port.membase + UFCR);
> >  
> >  	writel(num, sport->port.membase + UBIR);
> > @@ -1139,6 +1298,16 @@ static int serial_imx_probe(struct platform_device *pdev)
> >  	if (pdata && (pdata->flags & IMXUART_HAVE_RTSCTS))
> >  		sport->have_rtscts = 1;
> >  
> > +#ifdef CONFIG_IRDA
> > +	if (pdata && (pdata->flags & IMXUART_IRDA)) {
> > +		/* set defaults */
> > +		sport->irda_inv_rx = 0;
> > +		sport->irda_inv_tx = 0;
> > +		sport->trcv_delay = 50;
> > +		sport->use_irda = 1;
> > +	}
> > +#endif
> > +
> >  	if (pdata->init) {
> >  		ret = pdata->init(pdev);
> >  		if (ret)
> > -- 
> > 1.5.3.7
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
geschäftsführung: dr. uwe kracke, dr. cord seele, ust-idnr.: de 205 198 055
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160

emlix - your embedded linux partner
