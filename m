Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYJTVSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYJTVSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYJTVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:18:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYJTVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:18:31 -0400
Date: Mon, 20 Oct 2008 14:17:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Tomaso.Paoletti@caviumnetworks.com
Subject: Re: [PATCH] serial: Initialize spinlocks in 8250 and don't clobber
 them.
Message-Id: <20081020141750.d0610586.akpm@linux-foundation.org>
In-Reply-To: <48F51114.2010105@caviumnetworks.com>
References: <48F51114.2010105@caviumnetworks.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 14:37:24 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> Initialize spinlocks in 8250 and don't clobber them.

That's actually quite bad.  There's no reason why an all-zeroes pattern
for a spinlock_t correctly represents the unlocked state.  I guess we
got lucky on the architectures which use this code.

> Spinlock debugging fails in 8250.c because the lock fields in
> irq_lists are not initialized.  Initialize them.
> 
> In serial8250_isa_init_ports(), the port's lock is initialized.  We
> should not overwrite it.  Only copy in the fields we need.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
> ---
>  drivers/serial/8250.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index d4104a3..0688799 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2494,6 +2494,9 @@ static void __init serial8250_isa_init_ports(void)
>  		return;
>  	first = 0;
>  
> +	for (i = 0; i < ARRAY_SIZE(irq_lists); i++)
> +		spin_lock_init(&irq_lists[i].lock);

OK..  But serial8250_isa_init_ports() has so many callsites that I'd
worry that we end up running this initialisation multiple times.  Say,
if the right combination of boot options is provided?  This is probably
a benign thing, but it's not desirable.

A simple "fix" would be

static void __init irq_lists_init(void)
{
	static unsigned long done;

	if (!test_and_set_bit(0, &done)) {
		int i;

		for (i = 0; i < ARRAY_SIZE(irq_lists); i++)
			spin_lock_init(&irq_lists[i].lock);
	}
}

A better fix would be to initialise all those spinlocks at compile
time.  But given the need to pass the address of each lock into each
lock's initialiser, that could be tricky.

>  	for (i = 0; i < nr_uarts; i++) {
>  		struct uart_8250_port *up = &serial8250_ports[i];
>  
> @@ -2699,12 +2702,24 @@ static struct uart_driver serial8250_reg = {
>   */
>  int __init early_serial_setup(struct uart_port *port)
>  {
> +	struct uart_port *p;
> +
>  	if (port->line >= ARRAY_SIZE(serial8250_ports))
>  		return -ENODEV;
>  
>  	serial8250_isa_init_ports();
> -	serial8250_ports[port->line].port	= *port;
> -	serial8250_ports[port->line].port.ops	= &serial8250_pops;
> +	p = &serial8250_ports[port->line].port;
> +	p->iobase       = port->iobase;
> +	p->membase      = port->membase;
> +	p->irq          = port->irq;
> +	p->uartclk      = port->uartclk;
> +	p->fifosize     = port->fifosize;
> +	p->regshift     = port->regshift;
> +	p->iotype       = port->iotype;
> +	p->flags        = port->flags;
> +	p->mapbase      = port->mapbase;
> +	p->private_data = port->private_data;
> +	p->ops		= &serial8250_pops;
>  	return 0;
>  }

Having to spell out each member like this is pretty nasty from a
maintainability point of view.  If new fields are added to uart_port,
we surely will forget to update this code.

But yes, copying a spinlock by value is quite wrong.  Perhaps we could
retain the struct assigment and then run spin_lock_init() to get the
spinlock into a sane state?



