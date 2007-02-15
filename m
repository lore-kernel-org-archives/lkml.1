Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXBOUbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXBOUbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161191AbXBOUbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:31:47 -0500
Received: from h155.mvista.com ([63.81.120.155]:43027 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030603AbXBOUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:31:46 -0500
Message-ID: <45D4C324.1000106@ru.mvista.com>
Date: Thu, 15 Feb 2007 23:31:32 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
References: <200702151926.l1FJQT2o020816@pasqua.pmc-sierra.bc.ca>
In-Reply-To: <200702151926.l1FJQT2o020816@pasqua.pmc-sierra.bc.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:

> There are three different fixes:
> 1. Fix for DesignWare APB THRE errata:
> In brief, this is a non-standard 16550 in that the THRE interrupt
> will not re-assert itself simply by disabling and re-enabling the
> THRI bit in the IER, it is only re-enabled if a character is actually
> sent out.
> It appears that the "8250-uart-backup-timer.patch" in the "mm" tree also
> fixes it so we have dropped our initial workaround.
> This patch now needs to be applied on top of that "mm" patch.

    This patch has hit the mainline kernel already.

> 2. Fix for Busy Detect on LCR write:
> The DesignWare APB UART has a feature which causes a new Busy Detect
> interrupt to be generated if it's busy when the LCR is written. This
> fix saves the value of the LCR and rewrites it after clearing the
> interrupt.

> 3. Workaround for interrupt/data concurrency issue:
> The SoC needs to ensure that writes that can cause interrupts to be
> cleared reach the UART before returning from the ISR. This fix reads
> a non-destructive register on the UART so the read transaction
> completion ensures the previously queued write transaction has
> also completed.

> The differences from the last attempt is dropping the call to
> in_irq() and including more detailed description of the fixes.

    The difference part would better be under the "---" cutoff line, along 
with diffstat.
This way it gets auto-removed by quilt/git when applying the patch.

> Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>

> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 3d91bfc..bfaacc5 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -308,6 +308,7 @@ static unsigned int serial_in(struct uar
>  		return inb(up->port.iobase + 1);
>  
>  	case UPIO_MEM:
> +	case UPIO_DWAPB:
>  		return readb(up->port.membase + offset);
>  
>  	case UPIO_MEM32:
> @@ -333,6 +334,8 @@ #endif
>  static void
>  serial_out(struct uart_8250_port *up, int offset, int value)
>  {
> +	/* Save the offset before it's remapped */
> +	int save_offset = offset;
>  	offset = map_8250_out_reg(up, offset) << up->port.regshift;
>  
>  	switch (up->port.iotype) {

    I've just got an idea how to "beautify" this code -- rename the 'offset' 
arg to something like reg, and then declare/init 'offset' as local variable.
Would certainly look better (and worth doing in all serial_* accessros).

> @@ -359,6 +362,18 @@ #endif
>  			writeb(value, up->port.membase + offset);
>  		break;
>  
> +	case UPIO_DWAPB:
> +		/* Save the LCR value so it can be re-written when a
> +		 * Busy Detect interrupt occurs. */
> +		if (save_offset == UART_LCR)
> +			up->lcr = value;
> +		writeb(value, up->port.membase + offset);
> +		/* Read the IER to ensure any interrupt is cleared before
> +		 * returning from ISR. */
> +		if (save_offset == UART_TX || save_offset == UART_IER)
> +			value = serial_in(up, UART_IER);
> +		break;
> +		
>  	default:
>  		outb(value, up->port.iobase + offset);
>  	}
> @@ -2454,8 +2485,8 @@ int __init serial8250_start_console(stru
>  
>  	add_preferred_console("ttyS", line, options);
>  	printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
> -		line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
> -		port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
> +		line, port->iotype >= UPIO_MEM ? "MMIO" : "I/O port",
> +		port->iotype >= UPIO_MEM ? (unsigned long) port->mapbase :
>  		    (unsigned long) port->iobase, options);
>  	if (!(serial8250_console.flags & CON_ENABLED)) {
>  		serial8250_console.flags &= ~CON_PRINTBUFFER;

    I've remembered why I decided not to fix it: this code only gets called 
from 8250__eraly.c which can't handle anything beyond UPIO_MEM anyway.

WBR, Sergei
