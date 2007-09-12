Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbXILWgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbXILWgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932674AbXILWg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:36:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932634AbXILWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:36:25 -0400
Date: Wed, 12 Sep 2007 15:36:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Russell King <rmk@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] wake up from a serial port
Message-Id: <20070912153610.11c4f5cb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.60.0709122019100.5909@poirot.grange>
References: <200709100831.l8A8VUH6015446@imap1.linux-foundation.org>
	<20070910132703.2dd92485@the-village.bc.nu>
	<Pine.LNX.4.60.0709102251250.5200@poirot.grange>
	<20070911081220.GA20847@flint.arm.linux.org.uk>
	<Pine.LNX.4.60.0709111217470.19259@poirot.grange>
	<20070911121057.34b9e066@the-village.bc.nu>
	<Pine.LNX.4.60.0709122019100.5909@poirot.grange>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 20:50:10 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Enable wakeup from serial ports, make it run-time configurable over sysfs, 
> e.g.,
> 
> echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup
> 
> Requires
> 
> # CONFIG_SYSFS_DEPRECATED is not set
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> ---
> 
> Following suggestions from Alan and Russell moved the may_wake_up checks 
> to serial_core.c. This time actually tested - it does even work. Could 
> someone, please, verify, that put_device after device_find_child is 
> correct?

Seems right to me, from reading device_find_child() and its associated
documentation.

> Also would be nice to test with a Natsemi UART, that can wake up 
> the system, if such systems exist.
>

It would help if you could provide simple-to-follow steps which a tester
should follow to perform this testing.

 > 
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 9c57486..8a3d6ea 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -1934,9 +1934,24 @@ static void uart_change_pm(struct uart_state *state, int pm_state)
>  	}
>  }
>  
> +struct uart_match {
> +	struct uart_port *port;
> +	struct uart_driver *driver;
> +};
> +
> +static int serial_match_port(struct device *dev, void *data)
> +{
> +	struct uart_match *match = data;
> +	dev_t devt = MKDEV(match->driver->major, match->driver->minor) + match->port->line;
> +
> +	return dev->devt == devt; /* Actually, only one tty per port */
> +}
> +
>  int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
>  {
>  	struct uart_state *state = drv->state + port->line;
> +	struct device *tty_dev;
> +	struct uart_match match = {port, drv};
>  
>  	mutex_lock(&state->mutex);
>  
> @@ -1947,6 +1962,15 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
>  	}
>  #endif
>  
> +	tty_dev = device_find_child(port->dev, &match, serial_match_port);
> +	if (device_may_wakeup(tty_dev)) {
> +		enable_irq_wake(port->irq);
> +		put_device(tty_dev);
> +		mutex_unlock(&state->mutex);
> +		return 0;
> +	}
> +	port->suspended = 1;
> +
>  	if (state->info && state->info->flags & UIF_INITIALIZED) {
>  		const struct uart_ops *ops = port->ops;
>  
> @@ -1995,6 +2019,13 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
>  	}
>  #endif
>  
> +	if (!port->suspended) {
> +		disable_irq_wake(port->irq);
> +		mutex_unlock(&state->mutex);
> +		return 0;
> +	}
> +	port->suspended = 0;
> +
>  	uart_change_pm(state, 0);
>  
>  	/*
> @@ -2266,6 +2297,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
>  {
>  	struct uart_state *state;
>  	int ret = 0;
> +	struct device *tty_dev;
>  
>  	BUG_ON(in_interrupt());
>  
> @@ -2301,7 +2333,13 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
>  	 * Register the port whether it's detected or not.  This allows
>  	 * setserial to be used to alter this ports parameters.
>  	 */
> -	tty_register_device(drv->tty_driver, port->line, port->dev);
> +	tty_dev = tty_register_device(drv->tty_driver, port->line, port->dev);
> +	if (likely(!IS_ERR(tty_dev))) {
> +		device_can_wakeup(tty_dev) = 1;
> +		device_set_wakeup_enable(tty_dev, 0);
> +	} else
> +		printk(KERN_ERR "Cannot register tty device on line %d\n",
> +		       port->line);
>  
>  	/*
>  	 * If this driver supports console, and it hasn't been
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 773d8d8..60dedc0 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -291,7 +291,8 @@ struct uart_port {
>  	unsigned long		mapbase;		/* for ioremap */
>  	struct device		*dev;			/* parent device */
>  	unsigned char		hub6;			/* this should be in the 8250 driver */
> -	unsigned char		unused[3];
> +	unsigned char		suspended;
> +	unsigned char		unused[2];
>  	void			*private_data;		/* generic platform data pointer */
>  };
>  
