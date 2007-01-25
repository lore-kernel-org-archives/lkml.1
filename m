Return-Path: <linux-kernel-owner+w=401wt.eu-S965152AbXAYOui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbXAYOui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 09:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXAYOui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 09:50:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:1328 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965007AbXAYOuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 09:50:37 -0500
Message-ID: <45B8C3BA.4060106@ru.mvista.com>
Date: Thu, 25 Jan 2007 17:50:34 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
References: <45B7F32E.1030208@pmc-sierra.com>
In-Reply-To: <45B7F32E.1030208@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc St-Jean wrote:
> Here is my second attempt at the serial driver patch for the
> PMC-Sierra MSP71xx device.
> 
> There are three different fixes:
> 1. Fix for THRE errata
> - I verified the UART_BUG_TXEN fix does not help with this erratum.
> - I left our current fix in until I get our platform booting on
> 2.6.20-rc4 to try the mm tree "8250-uart-backup-timer.patch".
> Feel free to ignore for now.
> 
> 2. Fix for Busy Detect on LCR write
> - Moved to new UPIO_DWAPB iotype. Because the new type is a memory
> mapped device and there are several tests for UPIO_MEM, this involved
> updating serial_core.c and 8250_early.c in addition to 8250.c.
> - I tried implementing this totally in serial_in as suggested, but
> it can't be done because of bit overlap between UART_IIR_NO_INT and
> UART_IIR_BUSY. Also there is no way to set the interrupt "handled = 1"
> from serial_in.
> 
> 3. Workaround for interrupt/data concurrency issue
> - Moved to new UPIO_DWAPB iotype.

> Index: linux_2_6/drivers/serial/8250.c
> ===================================================================
> RCS file: linux_2_6/drivers/serial/8250.c,v
> retrieving revision 1.1.1.7
> diff -u -r1.1.1.7 8250.c
> --- linux_2_6/drivers/serial/8250.c	19 Oct 2006 21:00:58 -0000	1.1.1.7
> +++ linux_2_6/drivers/serial/8250.c	24 Jan 2007 23:55:27 -0000
[...]
> @@ -333,6 +334,8 @@
>   static void
>   serial_out(struct uart_8250_port *up, int offset, int value)

   Your patch is clearly garbled again, something added an extra space to all 
lines stating with space... :-/

>   {
> +	/* Save the offset before it's remapped */
> +	int save_offset = offset;

    Is there real need to save this? What regshift equals for this UART?

>   	offset = map_8250_out_reg(up, offset) << up->port.regshift;

>   	switch (up->port.iotype) {
> @@ -359,6 +362,19 @@
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
> +		if ((save_offset == UART_TX || save_offset == UART_IER) &&

    Not sure how an IER read ensures that...

> +				in_irq())

    I'd suggest to either indent this line right (start below 2ns paren of if 
stmt) or keep on the same line.

> +			value = serial_in(up, UART_IER);
> +		break;
> +		
>   	default:
>   		outb(value, up->port.iobase + offset);
>   	}
> @@ -1016,6 +1032,17 @@
>   		up->bugs |= UART_BUG_NOMSR;
>   #endif
> 
> +	/* Workaround:
> +	 * The DesignWare SoC UART part has a bug for all
> +	 * versions before 3.03a (2005-07-18)
> +	 * In brief, this is a non-standard 16550 in that the THRE interrupt
> +	 * will not re-assert itself simply by disabling and re-enabling the
> +	 * THRI bit in the IER, it is only re-enabled if a character is actually
> +	 * sent out.
> +	 */
> +	if( up->port.flags & UPF_DW_THRE_BUG )
> +		up->bugs |= UART_BUG_DWTHRE;
> +
>   	serial_outp(up, UART_LCR, save_lcr);
> 
>   	if (up->capabilities != uart_config[up->port.type].flags) {
> @@ -1141,6 +1168,12 @@
>   			iir = serial_in(up, UART_IIR);
>   			if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
>   				transmit_chars(up);
> +		} else if (up->bugs & UART_BUG_DWTHRE) {
> +			unsigned char lsr, iir;
> +			lsr = serial_in(up, UART_LSR);
> +			iir = serial_in(up, UART_IIR);
> +			if (lsr & UART_LSR_THRE)

    Why read IIR if you don't check it?

> @@ -2352,9 +2402,12 @@
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
>   	if (!(serial8250_console.flags & CON_ENABLED)) {
>   		serial8250_console.flags &= ~CON_PRINTBUFFER;
>   		register_console(&serial8250_console);
[...]
> Index: linux_2_6/drivers/serial/8250_early.c
> ===================================================================
> RCS file: linux_2_6/drivers/serial/8250_early.c,v
> retrieving revision 1.1.1.3
> diff -u -r1.1.1.3 8250_early.c
> --- linux_2_6/drivers/serial/8250_early.c	19 Oct 2006 20:08:20 -0000	1.1.1.3
> +++ linux_2_6/drivers/serial/8250_early.c	24 Jan 2007 23:55:27 -0000
> @@ -46,7 +46,7 @@
> 
>   static unsigned int __init serial_in(struct uart_port *port, int offset)
>   {
> -	if (port->iotype == UPIO_MEM)
> +	if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>   		return readb(port->membase + offset);
>   	else
>   		return inb(port->iobase + offset);
> @@ -54,7 +54,7 @@
> 
>   static void __init serial_out(struct uart_port *port, int offset, int value)
>   {
> -	if (port->iotype == UPIO_MEM)
> +	if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>   		writeb(value, port->membase + offset);
>   	else
>   		outb(value, port->iobase + offset);
> @@ -233,7 +233,7 @@
>   		return 0;
> 
>   	/* Try to start the normal driver on a matching line.  */
> -	mmio = (port->iotype == UPIO_MEM);
> +	mmio = (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB);
>   	line = serial8250_start_console(port, device->options);
>   	if (line < 0)
>   		printk("No ttyS device at %s 0x%lx for console\n",

    From your 8250_eraly.c changes I can conclude regshift == 1 (it doesn't 
currently support other cases). So, serial_pot() doesn't need save_offset. :-)

> Index: linux_2_6/drivers/serial/serial_core.c
> ===================================================================
> RCS file: linux_2_6/drivers/serial/serial_core.c,v
> retrieving revision 1.1.1.7
> diff -u -r1.1.1.7 serial_core.c
> --- linux_2_6/drivers/serial/serial_core.c	19 Oct 2006 21:00:58 -0000	1.1.1.7
> +++ linux_2_6/drivers/serial/serial_core.c	24 Jan 2007 23:55:28 -0000
> @@ -1669,9 +1669,10 @@
> 
>   	ret = sprintf(buf, "%d: uart:%s %s%08lX irq:%d",
>   			port->line, uart_type(port),
> -			port->iotype == UPIO_MEM ? "mmio:0x" : "port:",
> -			port->iotype == UPIO_MEM ? port->mapbase :
> -						(unsigned long) port->iobase,
> +			(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
> +				? "mmio:0x" : "port:",
> +			(port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
> +				? port->mapbase : (unsigned long) port->iobase,
>   			port->irq);
>   	if (port->type == PORT_UNKNOWN) {

    Needless change. My patch that fixes this function is in Linus' tree since 
September, not sure why you don't have it:

http://www2.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6c6a2334a1e8af7c3eaab992732825fa9ade77cf

> Index: linux_2_6/include/linux/serial_core.h
> ===================================================================
> RCS file: linux_2_6/include/linux/serial_core.h,v
> retrieving revision 1.1.1.7
> diff -u -r1.1.1.7 serial_core.h
> --- linux_2_6/include/linux/serial_core.h	19 Oct 2006 21:01:02 -0000	1.1.1.7
> +++ linux_2_6/include/linux/serial_core.h	24 Jan 2007 23:55:28 -0000
[...]
> @@ -274,6 +277,7 @@
>   	struct device		*dev;			/* parent device */
>   	unsigned char		hub6;			/* this should be in the 8250 driver */
>   	unsigned char		unused[3];
> +	void				*user;			/* generic platform 'user' pointer */

    Erm, 'private' or 'data' would've sounded better in the kernel context, 
IMHO... :-)

> Index: linux_2_6/include/linux/serial_reg.h
> ===================================================================
> RCS file: linux_2_6/include/linux/serial_reg.h,v
> retrieving revision 1.1.1.2
> diff -u -r1.1.1.2 serial_reg.h
> --- linux_2_6/include/linux/serial_reg.h	19 Oct 2006 18:29:50 -0000	1.1.1.2
> +++ linux_2_6/include/linux/serial_reg.h	24 Jan 2007 23:55:29 -0000
> @@ -218,6 +218,10 @@
>   #define UART_FCR_PXAR16	0x80	/* receive FIFO treshold = 16 */
>   #define UART_FCR_PXAR32	0xc0	/* receive FIFO treshold = 32 */
> 
> +/*
> + * DesignWare APB UART
> + */
> +#define UART_IIR_BUSY		0x07	/* Busy Detect */

    I'd suggest keeping this with other UART_IIR_* #defines, separated by the 
more elaborate comment.

WBR, Sergei
