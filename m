Return-Path: <linux-kernel-owner+w=401wt.eu-S1946019AbXBPRHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946019AbXBPRHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946018AbXBPRHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:07:00 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:47022 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946017AbXBPRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:06:59 -0500
Message-ID: <45D5E4A7.3070807@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	er
Date: Fri, 16 Feb 2007 09:06:47 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 16 Feb 2007 17:06:48.0341 (UTC) FILETIME=[D81F4C50:01C751EC]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Sergei Shtylyov wrote:
> Hello.
> 
> Marc St-Jean wrote:
> 
>  > There are three different fixes:
>  > 1. Fix for DesignWare APB THRE errata:
>  > In brief, this is a non-standard 16550 in that the THRE interrupt
>  > will not re-assert itself simply by disabling and re-enabling the
>  > THRI bit in the IER, it is only re-enabled if a character is actually
>  > sent out.
>  > It appears that the "8250-uart-backup-timer.patch" in the "mm" tree also
>  > fixes it so we have dropped our initial workaround.
>  > This patch now needs to be applied on top of that "mm" patch.
> 
>     This patch has hit the mainline kernel already.

I see, I'll drop the reference to the "mm" patch.


>  > 3. Workaround for interrupt/data concurrency issue:
>  > The SoC needs to ensure that writes that can cause interrupts to be
>  > cleared reach the UART before returning from the ISR. This fix reads
>  > a non-destructive register on the UART so the read transaction
>  > completion ensures the previously queued write transaction has
>  > also completed.
> 
>  > The differences from the last attempt is dropping the call to
>  > in_irq() and including more detailed description of the fixes.
> 
>     The difference part would better be under the "---" cutoff line, along
> with diffstat.
> This way it gets auto-removed by quilt/git when applying the patch.

I'll add to the next posting.

>  > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
>  > index 3d91bfc..bfaacc5 100644
>  > --- a/drivers/serial/8250.c
>  > +++ b/drivers/serial/8250.c
>  > @@ -308,6 +308,7 @@ static unsigned int serial_in(struct uar
>  >               return inb(up->port.iobase + 1);
>  > 
>  >       case UPIO_MEM:
>  > +     case UPIO_DWAPB:
>  >               return readb(up->port.membase + offset);
>  > 
>  >       case UPIO_MEM32:
>  > @@ -333,6 +334,8 @@ #endif
>  >  static void
>  >  serial_out(struct uart_8250_port *up, int offset, int value)
>  >  {
>  > +     /* Save the offset before it's remapped */
>  > +     int save_offset = offset;
>  >       offset = map_8250_out_reg(up, offset) << up->port.regshift;
>  > 
>  >       switch (up->port.iotype) {
> 
>     I've just got an idea how to "beautify" this code -- rename the 
> 'offset'
> arg to something like reg, and then declare/init 'offset' as local 
> variable.
> Would certainly look better (and worth doing in all serial_* accessros).

I agree but am having enough of a hard time getting the bare minimum
accepted that I don't dare touch any unnecessary lines.


>  > @@ -359,6 +362,18 @@ #endif
>  >                       writeb(value, up->port.membase + offset);
>  >               break;
>  > 
>  > +     case UPIO_DWAPB:
>  > +             /* Save the LCR value so it can be re-written when a
>  > +              * Busy Detect interrupt occurs. */
>  > +             if (save_offset == UART_LCR)
>  > +                     up->lcr = value;
>  > +             writeb(value, up->port.membase + offset);
>  > +             /* Read the IER to ensure any interrupt is cleared before
>  > +              * returning from ISR. */
>  > +             if (save_offset == UART_TX || save_offset == UART_IER)
>  > +                     value = serial_in(up, UART_IER);
>  > +             break;
>  > +            
>  >       default:
>  >               outb(value, up->port.iobase + offset);
>  >       }
>  > @@ -2454,8 +2485,8 @@ int __init serial8250_start_console(stru
>  > 
>  >       add_preferred_console("ttyS", line, options);
>  >       printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
>  > -             line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
>  > -             port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
>  > +             line, port->iotype >= UPIO_MEM ? "MMIO" : "I/O port",
>  > +             port->iotype >= UPIO_MEM ? (unsigned long) port->mapbase :
>  >                   (unsigned long) port->iobase, options);
>  >       if (!(serial8250_console.flags & CON_ENABLED)) {
>  >               serial8250_console.flags &= ~CON_PRINTBUFFER;
> 
>     I've remembered why I decided not to fix it: this code only gets called
> from 8250__eraly.c which can't handle anything beyond UPIO_MEM anyway.

We don't use 8250_early and I've tested it works without, so I'll drop this
change.

Thanks,
Marc
