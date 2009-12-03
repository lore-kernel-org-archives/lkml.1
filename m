Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZLCNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZLCNvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZLCNvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:51:40 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:34148 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZLCNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:51:39 -0500
Date: Thu, 3 Dec 2009 14:51:40 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
       Pavel Machek <pavel@ucw.cz>, saxena@laptop.org,
       Eric Miao <eric.y.miao@gmail.com>, s.hauer@pengutronix.de,
       Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH]serial-core: resume serial hardware with
 no_console_suspend (resend)
Message-ID: <20091203135140.GC14091@buzzloop.caiaq.de>
References: <1259767256.8709.323.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259767256.8709.323.camel@hammer.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 04:20:56PM +0100, Stanislav Brabec wrote:
> Perform a tricky suspend/resume even with no_console_suspend.
> 
> With no_console_suspend, kernel skips serial port suspend/resume and the
> serial hardware may remain in undefined state after resume. It actually
> happens on devices that don't have BIOS that handle serial
> initialization. It makes impossible to use serial console after resume. 
> 
> Devices affected by this problem include:
> Sharp Zaurus devices
> Several PXA based ARM embedded boards

True, I had occasions where the serial console did not get back to life
after suspend on a PXA300 based device. It didn't always happen though.

> The patch does:
> - Save the hardware state
> - Perform buffer flush in time of its suspend call
> - Tell the driver that port is suspended
> - But still accept new data
> - And keep console hardware in state that allows to send them
> 
> It allows to capture late console messages without breaking console
> after resume.
> 
> This is just a resend of a patch discussed in these threads, as the
> patch was not yet applied.
> 
> "Possible suspend/resume regression in .32-rc?" (Nov 1-5, 2009, ARM
> list, later LKML)
> 
> "serial-core: resume serial hardware with no_console_suspend" (Sep
> 15-Oct 18, 2009, LKML & ARM lists)
> 
> Signed-off-by: Stanislav Brabec <sbrabec@suse.cz>
> Tested-by: Haojian Zhuang <haojian.zhuang@gmail.com>

And I didn't see that problem anymore since your patch is applied,
great!

Tested-by: Daniel Mack <daniel@caiaq.de>

Thanks,
Daniel



> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index dcc7244..f1e1ab2 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -2008,12 +2008,6 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>  
>  	mutex_lock(&port->mutex);
>  
> -	if (!console_suspend_enabled && uart_console(uport)) {
> -		/* we're going to avoid suspending serial console */
> -		mutex_unlock(&port->mutex);
> -		return 0;
> -	}
> -
>  	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
>  	if (device_may_wakeup(tty_dev)) {
>  		enable_irq_wake(uport->irq);
> @@ -2021,20 +2015,23 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>  		mutex_unlock(&port->mutex);
>  		return 0;
>  	}
> -	uport->suspended = 1;
> +	if (console_suspend_enabled || !uart_console(uport))
> +		uport->suspended = 1;
>  
>  	if (port->flags & ASYNC_INITIALIZED) {
>  		const struct uart_ops *ops = uport->ops;
>  		int tries;
>  
> -		set_bit(ASYNCB_SUSPENDED, &port->flags);
> -		clear_bit(ASYNCB_INITIALIZED, &port->flags);
> +		if (console_suspend_enabled || !uart_console(uport)) {
> +			set_bit(ASYNCB_SUSPENDED, &port->flags);
> +			clear_bit(ASYNCB_INITIALIZED, &port->flags);
>  
> -		spin_lock_irq(&uport->lock);
> -		ops->stop_tx(uport);
> -		ops->set_mctrl(uport, 0);
> -		ops->stop_rx(uport);
> -		spin_unlock_irq(&uport->lock);
> +			spin_lock_irq(&uport->lock);
> +			ops->stop_tx(uport);
> +			ops->set_mctrl(uport, 0);
> +			ops->stop_rx(uport);
> +			spin_unlock_irq(&uport->lock);
> +		}
>  
>  		/*
>  		 * Wait for the transmitter to empty.
> @@ -2049,16 +2046,18 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>  			       drv->dev_name,
>  			       drv->tty_driver->name_base + uport->line);
>  
> -		ops->shutdown(uport);
> +		if (console_suspend_enabled || !uart_console(uport))
> +			ops->shutdown(uport);
>  	}
>  
>  	/*
>  	 * Disable the console device before suspending.
>  	 */
> -	if (uart_console(uport))
> +	if (console_suspend_enabled && uart_console(uport))
>  		console_stop(uport->cons);
>  
> -	uart_change_pm(state, 3);
> +	if (console_suspend_enabled || !uart_console(uport))
> +		uart_change_pm(state, 3);
>  
>  	mutex_unlock(&port->mutex);
>  
> @@ -2075,29 +2074,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  
>  	mutex_lock(&port->mutex);
>  
> -	if (!console_suspend_enabled && uart_console(uport)) {
> -		/* no need to resume serial console, it wasn't suspended */
> -		/*
> -		 * First try to use the console cflag setting.
> -		 */
> -		memset(&termios, 0, sizeof(struct ktermios));
> -		termios.c_cflag = uport->cons->cflag;
> -		/*
> -		 * If that's unset, use the tty termios setting.
> -		 */
> -		if (termios.c_cflag == 0)
> -			termios = *state->port.tty->termios;
> -		else {
> -			termios.c_ispeed = termios.c_ospeed =
> -				tty_termios_input_baud_rate(&termios);
> -			termios.c_ispeed = termios.c_ospeed =
> -				tty_termios_baud_rate(&termios);
> -		}
> -		uport->ops->set_termios(uport, &termios, NULL);
> -		mutex_unlock(&port->mutex);
> -		return 0;
> -	}
> -
>  	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
>  	if (!uport->suspended && device_may_wakeup(tty_dev)) {
>  		disable_irq_wake(uport->irq);
> @@ -2123,21 +2099,23 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  		spin_lock_irq(&uport->lock);
>  		ops->set_mctrl(uport, 0);
>  		spin_unlock_irq(&uport->lock);
> -		ret = ops->startup(uport);
> -		if (ret == 0) {
> -			uart_change_speed(state, NULL);
> -			spin_lock_irq(&uport->lock);
> -			ops->set_mctrl(uport, uport->mctrl);
> -			ops->start_tx(uport);
> -			spin_unlock_irq(&uport->lock);
> -			set_bit(ASYNCB_INITIALIZED, &port->flags);
> -		} else {
> -			/*
> -			 * Failed to resume - maybe hardware went away?
> -			 * Clear the "initialized" flag so we won't try
> -			 * to call the low level drivers shutdown method.
> -			 */
> -			uart_shutdown(state);
> +		if (console_suspend_enabled || !uart_console(uport)) {
> +			ret = ops->startup(uport);
> +			if (ret == 0) {
> +				uart_change_speed(state, NULL);
> +				spin_lock_irq(&uport->lock);
> +				ops->set_mctrl(uport, uport->mctrl);
> +				ops->start_tx(uport);
> +				spin_unlock_irq(&uport->lock);
> +				set_bit(ASYNCB_INITIALIZED, &port->flags);
> +			} else {
> +				/*
> +				 * Failed to resume - maybe hardware went away?
> +				 * Clear the "initialized" flag so we won't try
> +				 * to call the low level drivers shutdown method.
> +				 */
> +				uart_shutdown(state);
> +			}
>  		}
>  
>  		clear_bit(ASYNCB_SUSPENDED, &port->flags);
> 
> 
> -- 
> Best Regards / S pozdravem,
> 
> Stanislav Brabec
> software developer
> ---------------------------------------------------------------------
> SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
> Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
> 190 00 Praha 9                                  fax: +420 284 028 951
> Czech Republic                                    http://www.suse.cz/
> 
> 
> 
> 
