Return-Path: <linux-kernel-owner+w=401wt.eu-S1422965AbXBHMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422965AbXBHMNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422964AbXBHMNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:13:18 -0500
Received: from h155.mvista.com ([63.81.120.155]:43647 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422959AbXBHMNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:13:17 -0500
Message-ID: <45CB13D5.3090907@ru.mvista.com>
Date: Thu, 08 Feb 2007 15:13:09 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
References: <45CA5415.4000402@pmc-sierra.com>
In-Reply-To: <45CA5415.4000402@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:
> Fourth attempt at the serial driver patch for the PMC-Sierra MSP71xx device.
> 
> There are three different fixes:
> 1. Fix for DesignWare THRE errata
> - Dropped our fix since the "8250-uart-backup-timer.patch" in the "mm"
> tree also fixes it. This patch needs to be applied on top of "mm" patch.
> 
> 2. Fix for Busy Detect on LCR write
> - Changed the ordering of test in serial8250_interrupt().
> - Combined test for UPIO_DWAPB with UPIO_MEM in serial8250_start_console().
> - Renamed new uart_8250_port member to private_data.
> 
> 3. Workaround for interrupt/data concurrency issue
> - No changes since last patch.

> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 3d91bfc..b309c4c 100644
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
> +		} else if (up->port.iotype == UPIO_DWAPB &&
> +				(iir & UART_IIR_BUSY) == UART_IIR_BUSY) {

     Worth aligning this line with the opening paren of if... but's that's 
nitpicking. :-)

> +			/* The DesignWare APB UART has an Busy Detect (0x07)
> +			 * interrupt meaning an LCR write attempt occured while the
> +			 * UART was busy. The interrupt must be cleared by reading
> +			 * the UART status register (USR) and the LCR re-written. */
> +			unsigned int status;
> +			status = *(volatile u32 *)up->port.private_data;
> +			serial_out(up, UART_LCR, up->lcr);
> +
> +			handled = 1;
> +
> +			end = NULL;
>   		} else if (end == NULL)
>   			end = l;
> 
>   	return 0;

    Still, shouldn't you be doing this in serial8250_timeout() also?
What IRQ numbers this UART is using, BTW?

> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index cf23813..bd9711a 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -276,6 +277,7 @@ #define UPF_USR_MASK		((__force upf_t) (
>   	struct device		*dev;			/* parent device */
>   	unsigned char		hub6;			/* this should be in the 8250 driver */
>   	unsigned char		unused[3];
> +	void				*private_data;		/* generic platform data pointer */

    One tab to many before *private_data...

> diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
> index 3c8a6aa..1c5ed7d 100644
> --- a/include/linux/serial_reg.h
> +++ b/include/linux/serial_reg.h
> @@ -38,6 +38,8 @@ #define UART_IIR_THRI		0x02 /* Transmitt
>   #define UART_IIR_RDI		0x04 /* Receiver data interrupt */
>   #define UART_IIR_RLSI		0x06 /* Receiver line status interrupt */
> 
> +#define UART_IIR_BUSY		0x07 /* DesignWare APB Busy Detect */
> +
>   #define UART_FCR	2	/* Out: FIFO Control Register */
>   #define UART_FCR_ENABLE_FIFO	0x01 /* Enable the FIFO */
>   #define UART_FCR_CLEAR_RCVR	0x02 /* Clear the RCVR FIFO */

    Oops, your mailer went and did it again. :-)

WBR, Sergei
