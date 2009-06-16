Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZFPH3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZFPH3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFPH26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:28:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50158 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZFPH25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:28:57 -0400
Date: Tue, 16 Jun 2009 09:28:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Oskar Schirmer <os@emlix.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 9/9 -v2] imx: serial: use tty_encode_baud_rate to set
	true rate
Message-ID: <20090616072801.GF31396@pengutronix.de>
References: <1244635716-23315-1-git-send-email-os@emlix.com> <1244635716-23315-10-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244635716-23315-10-git-send-email-os@emlix.com>
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
X-Uptime: 09:25:08 up 35 days, 21:49, 25 users,  load average: 0.23, 0.19,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 10, 2009 at 02:08:36PM +0200, Oskar Schirmer wrote:
> real baud rate may be different from the one requested.
> for upper layers, set the nearest value to the real rate
> in favour of the rate previously requested.
> 
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> ---
>  drivers/serial/imx.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
> index 1c00e2a..c367160 100644
> --- a/drivers/serial/imx.c
> +++ b/drivers/serial/imx.c
> @@ -818,6 +818,7 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
>  	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
>  	unsigned int div, ufcr;
>  	unsigned long num, denom;
> +	uint64_t tdiv64;
>  
>  	/*
>  	 * If we don't support modem control lines, don't allow
> @@ -930,6 +931,12 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
>  	rational_best_approximation(16 * div * baud, sport->port.uartclk,
>  		1 << 16, 1 << 16, &num, &denom);
>  
> +	tdiv64 = sport->port.uartclk;
> +	tdiv64 *= num;
> +	do_div(tdiv64, denom * 16 * div);
> +	tty_encode_baud_rate(sport->port.info->port.tty,
> +		(speed_t)tdiv64, (speed_t)tdiv64);
> +
>  	num -= 1;
>  	denom -= 1;
>  

This patch breaks booting with a serial console on i.MX UARTs. The
following patch fixes this. Alan, please consider applying it.

Sascha


>From 4ac2e4dbb3bd31d67a395740b1d4f8206441141b Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 16 Jun 2009 09:24:57 +0200
Subject: [PATCH] i.MX serial driver: Check for NULL pointer deref before calling  tty_encode_baud_rate

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/serial/imx.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 285b414..5d7b58f 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -924,11 +924,13 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	rational_best_approximation(16 * div * baud, sport->port.uartclk,
 		1 << 16, 1 << 16, &num, &denom);
 
-	tdiv64 = sport->port.uartclk;
-	tdiv64 *= num;
-	do_div(tdiv64, denom * 16 * div);
-	tty_encode_baud_rate(sport->port.info->port.tty,
-		(speed_t)tdiv64, (speed_t)tdiv64);
+	if (port->info && port->info->port.tty) {
+		tdiv64 = sport->port.uartclk;
+		tdiv64 *= num;
+		do_div(tdiv64, denom * 16 * div);
+		tty_encode_baud_rate(sport->port.info->port.tty,
+				(speed_t)tdiv64, (speed_t)tdiv64);
+	}
 
 	num -= 1;
 	denom -= 1;
-- 
1.6.3.1


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
