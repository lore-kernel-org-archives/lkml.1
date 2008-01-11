Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYAMQN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYAMQN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 11:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYAMQNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 11:13:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3568 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751408AbYAMQNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 11:13:16 -0500
Date: Fri, 11 Jan 2008 10:17:21 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't drain
Message-ID: <20080111101721.GA4463@ucw.cz>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108115703.GA27179@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-08 11:57:03, Russell King wrote:
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

Is printk() enough for 'we've just lost your data' condition? Maybe we
should abort suspend if we can't drain fifo?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
