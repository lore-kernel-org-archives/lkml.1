Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZI3PLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZI3PLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZI3PLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:11:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53396 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZI3PLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:11:03 -0400
Date: Wed, 30 Sep 2009 17:11:03 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Deepak Saxena <dsaxena@laptop.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: console resume broken since
	ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
Message-ID: <20090930151103.GU27039@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
X-Uptime: 17:04:59 up 13 days,  5:20, 48 users,  load average: 14.68, 6.51,
	3.22
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes setting the console speed if console suspend is disabled
by breaking it if it is enabled, see below:

> commit ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
> Author: Deepak Saxena <dsaxena@laptop.org>
> Date:   Sat Sep 19 13:13:33 2009 -0700
> 
>     Set proper console speed on resume if console suspend is disabled
>     
>     Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
>     XO laptop. Basically what happens is that upon returning from resume,
>     serial8250_resume_port() will reconfigure the port for high speed
>     mode and all console output will be garbled, making debug of the
>     resume path painful. This patch modifies uart_resume_port() to
>     reset the port to the state it was in before we suspended.
>     
>     Original patch by Marcelo Tosatti
>     
>     Second patch by Deepak then reworked by Alan to fit with the tty changes
>     before it got submitted. Also fixed the console path to set c_i/ospeed as
>     some drivers require the termios fields are valid
>     
>     Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
>     Signed-off-by: Alan Cox <alan@linux.intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 3fd0134..2514d00 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -2068,11 +2068,29 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  	struct tty_port *port = &state->port;
>  	struct device *tty_dev;
>  	struct uart_match match = {uport, drv};
> +	struct ktermios termios;
>  
>  	mutex_lock(&port->mutex);
>  
>  	if (!console_suspend_enabled && uart_console(uport)) {
>  		/* no need to resume serial console, it wasn't suspended */
> +		/*
> +		 * First try to use the console cflag setting.
> +		 */
> +		memset(&termios, 0, sizeof(struct ktermios));
> +		termios.c_cflag = uport->cons->cflag;
> +		/*
> +		 * If that's unset, use the tty termios setting.
> +		 */
> +		if (termios.c_cflag == 0)
> +			termios = *state->port.tty->termios;
> +		else {
> +			termios.c_ispeed = termios.c_ospeed =
> +				tty_termios_input_baud_rate(&termios);
> +			termios.c_ispeed = termios.c_ospeed =
> +				tty_termios_baud_rate(&termios);
> +		}
> +		uport->ops->set_termios(uport, &termios, NULL);
>  		mutex_unlock(&port->mutex);
>  		return 0;
>  	}
> @@ -2089,20 +2107,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  	 * Re-enable the console device after suspending.
>  	 */
>  	if (uart_console(uport)) {
> -		struct ktermios termios;
> -
> -		/*
> -		 * First try to use the console cflag setting.
> -		 */
> -		memset(&termios, 0, sizeof(struct ktermios));
> -		termios.c_cflag = uport->cons->cflag;
> -
> -		/*
> -		 * If that's unset, use the tty termios setting.
> -		 */
> -		if (port->tty && termios.c_cflag == 0)
> -			termios = *port->tty->termios;
> -
>  		uart_change_pm(state, 0);
>  		uport->ops->set_termios(uport, &termios, NULL);


We call ->set_termios with an unitialized struct ktermios here.

Any ideas what to do?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
