Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZFLHR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZFLHR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZFLHRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:17:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54624 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZFLHRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:17:47 -0400
Date: Fri, 12 Jun 2009 09:16:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Oskar Schirmer <os@emlix.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/9 -v2] imx: serial: use rational library function
Message-ID: <20090612071649.GA31396@pengutronix.de>
References: <1244635716-23315-1-git-send-email-os@emlix.com> <1244635716-23315-8-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244635716-23315-8-git-send-email-os@emlix.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:15:01 up 31 days, 21:39, 15 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On Wed, Jun 10, 2009 at 02:08:34PM +0200, Oskar Schirmer wrote:
> for calculation of numerator and denominator
> used in baud rate setting, use generic library function
> for optimum settings.
> 
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> ---
>  drivers/serial/Kconfig |    1 +
>  drivers/serial/imx.c   |   30 ++++++++++--------------------
>  2 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 343e3a3..0ecb4c4 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -833,6 +833,7 @@ config SERIAL_IMX
>  	bool "IMX serial port support"
>  	depends on ARM && (ARCH_IMX || ARCH_MXC)
>  	select SERIAL_CORE
> +	select RATIONAL
>  	help
>  	  If you have a machine based on a Motorola IMX CPU you
>  	  can enable its onboard serial port by enabling this option.
> diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
> index 60892a2..11f93e2 100644
> --- a/drivers/serial/imx.c
> +++ b/drivers/serial/imx.c
> @@ -41,6 +41,7 @@
>  #include <linux/serial_core.h>
>  #include <linux/serial.h>
>  #include <linux/clk.h>
> +#include <linux/rational.h>
>  
>  #include <asm/io.h>
>  #include <asm/irq.h>
> @@ -670,7 +671,8 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
>  	unsigned long flags;
>  	unsigned int ucr2, old_ucr1, old_txrxen, baud, quot;
>  	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
> -	unsigned int div, num, denom, ufcr;
> +	unsigned int div, ufcr;
> +	unsigned long num, denom;
>  
>  	/*
>  	 * If we don't support modem control lines, don't allow
> @@ -772,32 +774,20 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
>  	if (!div)
>  		div = 1;
>  
> -	num = baud;
> -	denom = port->uartclk / div / 16;
> +	rational_best_approximation(16 * div * baud, sport->port.uartclk,
> +		1 << 16, 1 << 16, &num, &denom);

Reading the example you have given for rational_best_approximation() in
the last patch this should be (1 << 16) - 1, right?

>  
> -	/* shift num and denom right until they fit into 16 bits */
> -	while (num > 0x10000 || denom > 0x10000) {
> -		num >>= 1;
> -		denom >>= 1;
> -	}
> -	if (num > 0)
> -		num -= 1;
> -	if (denom > 0)
> -		denom -= 1;
> -
> -	writel(num, sport->port.membase + UBIR);
> -	writel(denom, sport->port.membase + UBMR);
> -
> -	if (div == 7)
> -		div = 6; /* 6 in RFDIV means divide by 7 */
> -	else
> -		div = 6 - div;
> +	num -= 1;
> +	denom -= 1;
>  
>  	ufcr = readl(sport->port.membase + UFCR);
>  	ufcr = (ufcr & (~UFCR_RFDIV)) |
>  	    (div << 7);
>  	writel(ufcr, sport->port.membase + UFCR);
>  
> +	writel(num, sport->port.membase + UBIR);
> +	writel(denom, sport->port.membase + UBMR);
> +
>  #ifdef ONEMS
>  	writel(sport->port.uartclk / div / 1000, sport->port.membase + ONEMS);
>  #endif
> -- 
> 1.5.3.7
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
