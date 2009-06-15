Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZFOHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZFOHkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZFOHki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:40:38 -0400
Received: from mx1.emlix.com ([193.175.82.87]:36817 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZFOHkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:40:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Mon, 15 Jun 2009 09:40:33 +0200
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Oskar Schirmer <os@emlix.com>, Sascha Hauer <kernel@pengutronix.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/9 -v2] imx: serial: use rational library function
Message-ID: <20090615074032.GB3984@emlix.com>
References: <1244635716-23315-1-git-send-email-os@emlix.com> <1244635716-23315-8-git-send-email-os@emlix.com> <20090612071649.GA31396@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090612071649.GA31396@pengutronix.de>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 09:16:49 +0200, Sascha Hauer wrote:
> Hi Oskar,
> 
> On Wed, Jun 10, 2009 at 02:08:34PM +0200, Oskar Schirmer wrote:
> > for calculation of numerator and denominator
> > used in baud rate setting, use generic library function
> > for optimum settings.
> > 
> > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > ---
> >  drivers/serial/Kconfig |    1 +
> >  drivers/serial/imx.c   |   30 ++++++++++--------------------
> >  2 files changed, 11 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> > index 343e3a3..0ecb4c4 100644
> > --- a/drivers/serial/Kconfig
> > +++ b/drivers/serial/Kconfig
> > @@ -833,6 +833,7 @@ config SERIAL_IMX
> >  	bool "IMX serial port support"
> >  	depends on ARM && (ARCH_IMX || ARCH_MXC)
> >  	select SERIAL_CORE
> > +	select RATIONAL
> >  	help
> >  	  If you have a machine based on a Motorola IMX CPU you
> >  	  can enable its onboard serial port by enabling this option.
> > diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
> > index 60892a2..11f93e2 100644
> > --- a/drivers/serial/imx.c
> > +++ b/drivers/serial/imx.c
> > @@ -41,6 +41,7 @@
> >  #include <linux/serial_core.h>
> >  #include <linux/serial.h>
> >  #include <linux/clk.h>
> > +#include <linux/rational.h>
> >  
> >  #include <asm/io.h>
> >  #include <asm/irq.h>
> > @@ -670,7 +671,8 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
> >  	unsigned long flags;
> >  	unsigned int ucr2, old_ucr1, old_txrxen, baud, quot;
> >  	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
> > -	unsigned int div, num, denom, ufcr;
> > +	unsigned int div, ufcr;
> > +	unsigned long num, denom;
> >  
> >  	/*
> >  	 * If we don't support modem control lines, don't allow
> > @@ -772,32 +774,20 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
> >  	if (!div)
> >  		div = 1;
> >  
> > -	num = baud;
> > -	denom = port->uartclk / div / 16;
> > +	rational_best_approximation(16 * div * baud, sport->port.uartclk,
> > +		1 << 16, 1 << 16, &num, &denom);
> 
> Reading the example you have given for rational_best_approximation() in
> the last patch this should be (1 << 16) - 1, right?

No, the registers hold values minus one, e.g.
to select numerator = 14, set UBIR = 13.
Thus, the maximum value for rate calculation
is 1 << 16, not 0xFFFF. For the "minus 1", see below.

> 
> >  
> > -	/* shift num and denom right until they fit into 16 bits */
> > -	while (num > 0x10000 || denom > 0x10000) {
> > -		num >>= 1;
> > -		denom >>= 1;
> > -	}
> > -	if (num > 0)
> > -		num -= 1;
> > -	if (denom > 0)
> > -		denom -= 1;
> > -
> > -	writel(num, sport->port.membase + UBIR);
> > -	writel(denom, sport->port.membase + UBMR);
> > -
> > -	if (div == 7)
> > -		div = 6; /* 6 in RFDIV means divide by 7 */
> > -	else
> > -		div = 6 - div;
> > +	num -= 1;
> > +	denom -= 1;

This is where rate calculation values are
decreased for register purpose.

> >  
> >  	ufcr = readl(sport->port.membase + UFCR);
> >  	ufcr = (ufcr & (~UFCR_RFDIV)) |
> >  	    (div << 7);
> >  	writel(ufcr, sport->port.membase + UFCR);
> >  
> > +	writel(num, sport->port.membase + UBIR);
> > +	writel(denom, sport->port.membase + UBMR);
> > +
> >  #ifdef ONEMS
> >  	writel(sport->port.uartclk / div / 1000, sport->port.membase + ONEMS);
> >  #endif
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
