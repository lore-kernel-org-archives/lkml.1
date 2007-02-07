Return-Path: <linux-kernel-owner+w=401wt.eu-S1161407AbXBGRym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161407AbXBGRym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161392AbXBGRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:54:42 -0500
Received: from homer.mvista.com ([63.81.120.155]:35862 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161384AbXBGRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:54:41 -0500
Message-ID: <45CA125B.6050701@ru.mvista.com>
Date: Wed, 07 Feb 2007 20:54:35 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
References: <45C77B61.1080209@pmc-sierra.com>
In-Reply-To: <45C77B61.1080209@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc St-Jean wrote:
> Third attempt at the serial driver patch for the PMC-Sierra MSP71xx device.
> 
> There are three different fixes:
> 1. Fix for DesignWare THRE errata
> - Dropped our fix since the "8250-uart-backup-timer.patch" in the "mm"
> tree also fixes it. This patch needs to be applied on top of it.
> 
> 2. Fix for Busy Detect on LCR write
> - Dropped the addition of UPIO_DWAPB iotype to 8250_early.c as Sergei
> pointed out the fix wasn't complete and we don't require it.
> 
> 3. Workaround for interrupt/data concurrency issue
> - Fix must remain serial8250_interrupt() in order to mark interrupt as
> handled.
> 
> Thanks,
> Marc
> 
> Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 3d91bfc..489ff2b 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -308,6 +308,7 @@ static unsigned int serial_in(struct uar
>   		return inb(up->port.iobase + 1);
> 
>   	case UPIO_MEM:
> +	case UPIO_DWAPB:
>   		return readb(up->port.membase + offset);
> 
>   	case UPIO_MEM32:
> @@ -333,6 +334,8 @@ #endif
>   static void
>   serial_out(struct uart_8250_port *up, int offset, int value)
>   {
> +	/* Save the offset before it's remapped */
> +	int save_offset = offset;
>   	offset = map_8250_out_reg(up, offset) << up->port.regshift;
> 
>   	switch (up->port.iotype) {
> @@ -359,6 +362,18 @@ #endif
>   			writeb(value, up->port.membase + offset);
>   		break;
> 
> +	case UPIO_DWAPB:
> +		/* Save the LCR value so it can be re-written when a
> +		 * Busy Detect interrupt occurs. */
> +		if (save_offset == UART_LCR)
> +			up->lcr = value;
> +		writeb(value, up->port.membase + offset);
> +		/* Read the IER to ensure any interrupt is cleared before
> +		 * returning from ISR. */
> +		if ((save_offset == UART_TX || save_offset == UART_IER) && in_irq())
> +			value = serial_in(up, UART_IER);
> +		break;
> +		
>   	default:
>   		outb(value, up->port.iobase + offset);
>   	}
> @@ -373,6 +388,7 @@ serial_out_sync(struct uart_8250_port *u
>   #ifdef CONFIG_SERIAL_8250_AU1X00
>   	case UPIO_AU:
>   #endif
> +	case UPIO_DWAPB:
>   		serial_out(up, offset, value);
>   		(void)serial_in(up, UART_LCR); /* safe, no side-effects */
>   		break;
> @@ -1383,6 +1399,19 @@ static irqreturn_t serial8250_interrupt(
>   			handled = 1;
> 
>   			end = NULL;
> +		} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY &&
> +				up->port.iotype == UPIO_DWAPB) {

    Makes sense to swap the checks, i.e. to only test for UART_IIR_BUSY is 
this is UPIO_DWAPB.

> +			/* The DesignWare APB UART has an Busy Detect (0x07)
> +			 * interrupt meaning an LCR write attempt occured while the
> +			 * UART was busy. The interrupt must be cleared by reading
> +			 * the UART status register (USR) and the LCR re-written. */
> +			unsigned int status;
> +			status = *(volatile u32 *)up->port.data;
> +			serial_out(up, UART_LCR, up->lcr);
> +
> +			handled = 1;
> +
> +			end = NULL;
>   		} else if (end == NULL)
>   			end = l;

[...]

> @@ -2454,9 +2485,12 @@ int __init serial8250_start_console(stru
> 
>   	add_preferred_console("ttyS", line, options);
>   	printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
> -		line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
> -		port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
> -		    (unsigned long) port->iobase, options);
> +		line,
> +		(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
> +			? "MMIO" : "I/O port",
> +		(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
> +			? (unsigned long) port->mapbase : (unsigned long) port->iobase,
> +		options);

    Please turn this check into port->iotype >= UPIO_MEM, since this would be 
the Right Thing (RM).  All iotypes beyond UPIO_MEM are memory mapped.  And I 
thought I fixed that -- was wrong, obviously... :-/

> diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
> index 3c8a6aa..b3550cc 100644
> --- a/include/linux/serial_reg.h
> +++ b/include/linux/serial_reg.h
> @@ -37,6 +37,7 @@ #define UART_IIR_MSI		0x00 /* Modem stat
>   #define UART_IIR_THRI		0x02 /* Transmitter holding register empty */
>   #define UART_IIR_RDI		0x04 /* Receiver data interrupt */
>   #define UART_IIR_RLSI		0x06 /* Receiver line status interrupt */
> +#define UART_IIR_BUSY		0x07 /* DesignWare APB Busy Detect */

    Alan already said about this one... :-)

    BTW, your patches are still corrupt by your mailer (space added to lines 
starting with space)

MBR, Sergei
