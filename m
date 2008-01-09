Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYAIAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYAIAGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYAIAGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:06:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbYAIAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:06:35 -0500
Date: Tue, 8 Jan 2008 16:06:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port
 won't drain
Message-Id: <20080108160610.53694773.akpm@linux-foundation.org>
In-Reply-To: <20080108115703.GA27179@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk>
	<20080108115703.GA27179@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 11:57:03 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> Some ports seem to be unable to drain their transmitters on shut down.
> Such a problem can occur if the port is programmed for hardware imposed
> flow control, characters are in the FIFO but the CTS signal is inactive.
> 
> Normally, this isn't a problem because most places where we wait for the
> transmitter to drain have a time-out.  However, there is no timeout in
> the suspend path.
> 
> Give a port 30ms to drain; this is an arbitary value chosen to avoid
> long delays if there are many such ports in the system, while giving a
> reasonable chance for a single port to drain.  Should a port not drain
> within this timeout, issue a warning.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 3bb5d24..4ce219c 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -1977,6 +1977,7 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
>  
>  	if (state->info && state->info->flags & UIF_INITIALIZED) {
>  		const struct uart_ops *ops = port->ops;
> +		int tries;
>  
>  		state->info->flags = (state->info->flags & ~UIF_INITIALIZED)
>  				     | UIF_SUSPENDED;
> @@ -1990,9 +1991,14 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
>  		/*
>  		 * Wait for the transmitter to empty.
>  		 */
> -		while (!ops->tx_empty(port)) {
> +		for (tries = 3; !ops->tx_empty(port) && tries; tries--) {
>  			msleep(10);
>  		}
> +		if (!tries)
> +			printk(KERN_ERR "%s%s%s%d: Unable to drain transmitter\n",
> +			       port->dev ? port->dev->bus_id : "",
> +			       port->dev ? ": " : "",
> +			       drv->dev_name, port->line);
>  
>  		ops->shutdown(port);
>  	}
> 

One hopes that doing a printk from within uart_suspend_port() will dtrt if
that port is (was?) being used as a console.


