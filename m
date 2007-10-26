Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXJZVYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXJZVYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764163AbXJZVYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:24:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764078AbXJZVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:24:19 -0400
Date: Fri, 26 Oct 2007 14:23:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: new style ColdFire UART driver
Message-Id: <20071026142328.d06a1b3b.akpm@linux-foundation.org>
In-Reply-To: <200710190142.l9J1gfxk003771@goober>
References: <200710190142.l9J1gfxk003771@goober>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 11:42:41 +1000
Greg Ungerer <gerg@snapgear.com> wrote:

> A new style serial driver for the Freescale ColdFire UART to replace
> the old style one currently in the tree (drivers/serial/mcfserial.c).
> 
> Currently this UART is only found in the ColdFire CPU family of parts
> (thus I prefixed this patch [M68KNOMMU]).
> 
> This has been around for a long while now, tested on all available
> platforms.
> 
> ...
>

All of these:

> +/****************************************************************************/

don't really add much value.

> +static unsigned int mcf_get_mctrl(struct uart_port *port)
> +{
> +	struct mcf_uart *pp = (struct mcf_uart *) port;

container_of() would be nicer: it explains what's going on and removes the
unpleasing requirement that uart_port be the first member of mcf_uart.

> +static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
> +{
> +	struct mcf_uart *pp = (struct mcf_uart *) port;

Many instances..

> +static void mcf_set_termios(struct uart_port *port, struct ktermios *termios,
> +	struct ktermios *old)
> +{
> +	unsigned long flags;
> +	unsigned int baud, baudclk;
> +	unsigned char mr1, mr2;

Is this all up-to-date with Alan's recent termios changes?

> +static struct mcf_uart mcf_ports[3];
> +
> +#define	MCF_MAXPORTS	(sizeof(mcf_ports) / sizeof(struct mcf_uart))

Use ARRAY_SIZE here.

> +/****************************************************************************/
> +#if defined(CONFIG_SERIAL_MCF_CONSOLE)
> +/****************************************************************************/
> +
> +int __init early_mcf_setup(struct mcf_platform_uart *platp)

hrm, this is global and has no callers.

> +{
> +	struct uart_port *port;
> +	int i;
> +
> +	for (i = 0; ((i < MCF_MAXPORTS) && (platp[i].mapbase)); i++) {
> +		port = &mcf_ports[i].port;
> +
> +		port->line = i;
> +		port->type = PORT_MCF;
> +		port->mapbase = platp[i].mapbase;
> +		port->membase = (platp[i].membase) ? platp[i].membase :
> +			(unsigned char __iomem *) port->mapbase;
> +		port->iotype = SERIAL_IO_MEM;
> +		port->irq = platp[i].irq;
> +		port->uartclk = MCF_BUSCLK;
> +		port->flags = ASYNC_BOOT_AUTOCONF;
> +		port->ops = &mcf_uart_ops;
> +	}
> +
> +	return 0;
> +}
> +

