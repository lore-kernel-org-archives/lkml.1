Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYCTUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYCTUFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbYCTUFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:05:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbYCTUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:05:30 -0400
Date: Thu, 20 Mar 2008 13:04:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       giometti@linux.it
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-Id: <20080320130400.0b17e1fc.akpm@linux-foundation.org>
In-Reply-To: <12048053472063-git-send-email-giometti@linux.it>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
	<12048053471754-git-send-email-giometti@linux.it>
	<12048053471177-git-send-email-giometti@linux.it>
	<12048053473741-git-send-email-giometti@linux.it>
	<12048053472063-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Mar 2008 13:09:04 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> Adds support for the PPS sources connected with the CD (Carrier
> Detect) pin of a serial port.
> 
> ...
>
> +#ifdef CONFIG_PPS_CLIENT_UART
> +
> +static int
> +uart_register_pps_port(struct uart_state *state, struct uart_port *port)
> +{
> +	struct tty_driver *drv = port->info->tty->driver;
> +	int ret;
> +
> +	state->pps_info.owner = THIS_MODULE;
> +	state->pps_info.dev = port->dev;
> +	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
> +		drv->driver_name, port->line);
> +	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
> +		drv->name, port->line);

umm, why are we hard-wiring "/dev" into the kernel source?  Is it just for
user-friendly printks?

> +	state->pps_info.mode = PPS_CAPTUREBOTH | \
> +			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> +			PPS_CANWAIT | PPS_TSFMT_TSPEC;
> +
> +	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
> +				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> +	if (ret < 0) {
> +		dev_err(port->dev, "cannot register PPS source \"%s\"\n",
> +						state->pps_info.path);
> +		return ret;
> +	}
> +	port->pps_source = ret;
> +	dev_dbg(port->dev, "PPS source #%d \"%s\" added\n",
> +		port->pps_source, state->pps_info.path);
> +
> +	return 0;
> +}
> +
> +static void
> +uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
> +{
> +	pps_unregister_source(port->pps_source);
> +	dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
> +				port->pps_source, state->pps_info.path);
> +}
> +
> +#else
> +
> +#define uart_register_pps_port(state, port)	do { } while (0)
> +#define uart_unregister_pps_port(state, port)	do { } while (0)

Please never implement in cpp that which can be implemented in C.  These
should have been static inlines.  That's nicer, matches the
CONFIG_PPS_CLIENT_UART=y code and provides type checking.

> +#endif /* CONFIG_PPS_CLIENT_UART */
> +
>  static int uart_set_info(struct uart_state *state,
>  			 struct serial_struct __user *newinfo)
>  {
> @@ -810,11 +859,19 @@ static int uart_set_info(struct uart_state *state,
>  			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
>  
>   check_and_exit:
> +	/* PPS support enabled/disabled? */
> +	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {
> +		if (new_flags & UPF_HARDPPS_CD)
> +			uart_register_pps_port(state, port);
> +		else
> +			uart_unregister_pps_port(state, port);
> +	}
> +
>  	retval = 0;
>  	if (port->type == PORT_UNKNOWN)
>  		goto exit;
>  	if (state->info->flags & UIF_INITIALIZED) {
> -		if (((old_flags ^ port->flags) & UPF_SPD_MASK) ||
> +		if (((old_flags ^ port->flags) & (UPF_SPD_MASK|UPF_HARDPPS_CD)) ||
>  		    old_custom_divisor != port->custom_divisor) {
>  			/*
>  			 * If they're setting up a custom divisor or speed,
> @@ -2148,6 +2205,12 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
>  		port->ops->config_port(port, flags);
>  	}
>  
> +	/*
> +	 * Add the PPS support for the current port.
> +	 */
> +	if (port->flags & UPF_HARDPPS_CD)
> +		uart_register_pps_port(state, port);
> +
>  	if (port->type != PORT_UNKNOWN) {
>  		unsigned long flags;
>  
> @@ -2405,6 +2468,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
>  	mutex_unlock(&state->mutex);
>  
>  	/*
> +	 * Remove PPS support from the current port.
> +	 */
> +	if (port->flags & UPF_HARDPPS_CD)
> +		uart_unregister_pps_port(state, port);
> +
> +	/*
>  	 * Remove the devices from the tty layer
>  	 */
>  	tty_unregister_device(drv->tty_driver, port->line);

