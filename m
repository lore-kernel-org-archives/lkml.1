Return-Path: <linux-kernel-owner+w=401wt.eu-S1946234AbXBPTMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946234AbXBPTMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946237AbXBPTMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:12:17 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2302 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946234AbXBPTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:12:16 -0500
Date: Fri, 16 Feb 2007 19:12:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070216191207.GC2572@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
References: <20070216185230.GO8882@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216185230.GO8882@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 07:52:30PM +0100, Rodolfo Giometti wrote:
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 98ec861..cd9a003 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1315,8 +1315,25 @@ static unsigned int check_modem_status(struct uart_8250_port *up)
>  			up->port.icount.rng++;
>  		if (status & UART_MSR_DDSR)
>  			up->port.icount.dsr++;
> -		if (status & UART_MSR_DDCD)
> +		if (status & UART_MSR_DDCD) {
> +#ifdef CONFIG_PPS_CLIENT_UART_8250
> +			if (status & UART_MSR_DCD) {
> +				linuxpps_event(up->port.pps_source,
> +						PPS_CAPTUREASSERT, up);
> +				dbg("serial8250: PPS assert event at %lu "
> +				    "on source #%d",
> +					jiffies, up->port.pps_source);
> +			}
> +			else {
> +				linuxpps_event(up->port.pps_source,
> +						PPS_CAPTURECLEAR, up);
> +				dbg("serial8250: PPS clear event at %lu "
> +				    "on source #%d",
> +					jiffies, up->port.pps_source);
> +			}
> +#endif

Yuck.  Please.  No.  Doing it this way means you have to modify every
single serial driver out there which is a mamouth task.

>  			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);

Did you not look to see what's in this helper?  You'll find within here
the following code:

#ifdef CONFIG_HARD_PPS
        if ((port->flags & UPF_HARDPPS_CD) && status)
                hardpps();
#endif

which should've been a big sign lit up in bright lights in Times Square
pointing you towards the right place to put your code.

> +		}
>  		if (status & UART_MSR_DCTS)
>  			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
>  
> @@ -2004,6 +2021,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
>  		up->ier |= UART_IER_MSI;
>  	if (up->capabilities & UART_CAP_UUE)
>  		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
> +#ifdef CONFIG_PPS_CLIENT_UART_8250
> +	up->ier |= UART_IER_MSI;	/* enable interrupts */
> +#endif

Why not continue to leave it as a decision of the administrator - if
you want ports to default to having PPS support enabled, change all
the registration to set UPF_HARDPPS_CD.  But leave the admin with
the ability to disable it.

> @@ -2124,6 +2130,33 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
>  		 */
>  		if (!uart_console(port))
>  			uart_change_pm(state, 3);
> +
> +#ifdef CONFIG_PPS_CLIENT_UART
> +		/*
> +		 * Add the PPS support for the probed port.
> +		 */
> +                snprintf(state->pps_info.name, LINUXPPS_MAX_NAME_LEN,
> +				"%s%d", drv->driver_name, port->line);
> +		snprintf(state->pps_info.path, LINUXPPS_MAX_NAME_LEN,
> +				"/dev/%s%d", drv->dev_name, port->line);
> +
> +		state->pps_info.mode = PPS_CAPTUREBOTH | \
> +				PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> +				PPS_CANWAIT | PPS_TSFMT_TSPEC;
> +
> +		retval = linuxpps_register_source(&state->pps_info,
> +					PPS_CAPTUREBOTH | \
> +					PPS_OFFSETASSERT | PPS_OFFSETCLEAR,
> +					-1 /* PPS ID is up to the system */);
> +		if (retval < 0) {
> +			err("cannot register PPS source \"%s\"",
> +				state->pps_info.path);
> +			return;
> +		}
> +		port->pps_source = retval;
> +		info("PPS source #%d \"%s\" added to the system ",
> +			port->pps_source, state->pps_info.path);
> +#endif

This means that PPS support is not available for any port which wasn't
autoprobed at device discovery time.  That seems quite restrictive.
Maybe it needs to be coupled with the setting/clearing of UPF_HARDPPS_CD ?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
