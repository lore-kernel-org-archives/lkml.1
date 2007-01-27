Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbXA0A2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbXA0A2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXA0A2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:28:21 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:61500 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751708AbXA0A2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:28:20 -0500
Message-ID: <45BA9C9D.7060302@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	 er
Date: Fri, 26 Jan 2007 16:28:13 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 27 Jan 2007 00:28:13.0800 (UTC) FILETIME=[0802DE80:01C741AA]
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
>  >> > Index: linux_2_6/drivers/serial/8250.c
>  >> > ===================================================================
>  >> > RCS file: linux_2_6/drivers/serial/8250.c,v
>  >> > retrieving revision 1.1.1.7
>  >> > diff -u -r1.1.1.7 8250.c
>  >> > --- linux_2_6/drivers/serial/8250.c   19 Oct 2006 21:00:58 -0000     
>  >>1.1.1.7
>  >> > +++ linux_2_6/drivers/serial/8250.c   24 Jan 2007 23:55:27 -0000
>  >>[...]
>  >> > @@ -333,6 +334,8 @@
>  >> >   static void
>  >> >   serial_out(struct uart_8250_port *up, int offset, int value)
> 
>  >>   Your patch is clearly garbled again, something added an extra space
>  >>to all
>  >>lines stating with space... :-/
> 
>  > I see that but was under the impression cvs diff did that so all lines
>  > lineup correctly whether they have a +, -, or neither.
> 
>     Yes. And your mailer has probably added another space to lines already
> begginign with space. Some mailers tend to do it, don't know sure why... 
> :-/

I'll look into it for the next patch.


>  > It doesn't affect applying the patches for me, did you try?
> 
>     I hadn't but I had no doubts it'll fail... just tried, not a single 
> hunk
> applied. :-]
> 
>  >> >   {
>  >> > +     /* Save the offset before it's remapped */
>  >> > +     int save_offset = offset;
> 
>  >>    Is there real need to save this? What regshift equals for this UART?
> 
>  > Yes, we have a regshift of 2 on this SoC and it could be different on 
> other
>  > SoCs which reuse the UART IP.
> 
>     Agreed then (though still seems avoidable).
> 
>  >> >       offset = map_8250_out_reg(up, offset) << up->port.regshift;
> 
>  >> >       switch (up->port.iotype) {
>  >> > @@ -359,6 +362,19 @@
>  >> >                       writeb(value, up->port.membase + offset);
>  >> >               break;
>  >> >
>  >> > +     case UPIO_DWAPB:
>  >> > +             /* Save the LCR value so it can be re-written when a
>  >> > +              * Busy Detect interrupt occurs. */
>  >> > +             if (save_offset == UART_LCR)
>  >> > +                     up->lcr = value;
>  >> > +             writeb(value, up->port.membase + offset);
>  >> > +             /* Read the IER to ensure any interrupt is cleared 
> before
>  >> > +              * returning from ISR. */
>  >> > +             if ((save_offset == UART_TX || save_offset == 
> UART_IER) &&
> 
>  >>    Not sure how an IER read ensures that...
> 
>  > It's just a dummy read to ensure that any writes which clear 
> interrupts have
>  > reached the device before returning from the IRQ.
> 
>     Hm, isn't it CPU write buffer flush? Shouldn't this be handled more
> generically?

No because this peripheral is across an internal SoC bus. Only a read
accessing it will ensure the write is complete. We must insure the
interrupt source is cleared to avoid spurious interrupts.


> [...]
>  >> > Index: linux_2_6/drivers/serial/8250_early.c
>  >> > ===================================================================
>  >> > RCS file: linux_2_6/drivers/serial/8250_early.c,v
>  >> > retrieving revision 1.1.1.3
>  >> > diff -u -r1.1.1.3 8250_early.c
>  >> > --- linux_2_6/drivers/serial/8250_early.c     19 Oct 2006 20:08:20
>  >>-0000      1.1.1.3
>  >> > +++ linux_2_6/drivers/serial/8250_early.c     24 Jan 2007 23:55:27 
> -0000
>  >> > @@ -46,7 +46,7 @@
>  >> >
>  >> >   static unsigned int __init serial_in(struct uart_port *port, int
>  >>offset)
>  >> >   {
>  >> > -     if (port->iotype == UPIO_MEM)
>  >> > +     if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>  >> >               return readb(port->membase + offset);
>  >> >       else
>  >> >               return inb(port->iobase + offset);
>  >> > @@ -54,7 +54,7 @@
>  >> >
>  >> >   static void __init serial_out(struct uart_port *port, int offset,
>  >>int value)
>  >> >   {
>  >> > -     if (port->iotype == UPIO_MEM)
>  >> > +     if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>  >> >               writeb(value, port->membase + offset);
>  >> >       else
>  >> >               outb(value, port->iobase + offset);
>  >> > @@ -233,7 +233,7 @@
>  >> >               return 0;
>  >> >
>  >> >       /* Try to start the normal driver on a matching line.  */
>  >> > -     mmio = (port->iotype == UPIO_MEM);
>  >> > +     mmio = (port->iotype == UPIO_MEM || port->iotype == 
> UPIO_DWAPB);
>  >> >       line = serial8250_start_console(port, device->options);
>  >> >       if (line < 0)
>  >> >               printk("No ttyS device at %s 0x%lx for console\n",
> 
>  >>    From your 8250_eraly.c changes I can conclude regshift == 1 (it 
> doesn't
>  >>currently support other cases). So, serial_pot() doesn't need
>  >>save_offset. :-)
> 
>  > Our regshift is definitely 2 on this SoC and we don't have any 
> problems with
>  > console output before the serial driver opens. So assuming it's using
>  > 8250_early.c for initial console output I can only conclude that it 
> works
> 
>     It comes into action only if you specify console=uart,... kernel option
> for the eraly console support.  The "plain" 8250 console driver is 
> containded
> within 8250.c itself.
> 
>  > because UART_TX is offset 0 and the port was left configured from our
>  > ROM monitor.
> 
>     Well, this part of the patch can't be considered complete then (how LSR
> polling is going to work?), so should either be removed or the proper 
> regshift
> support added.

Since we don't require it I will drop the 8250_early.c changes from the patch.

I've tested the "mm tree" patch for the backup timer and it works, although
the output seems a little choppy at times. I'll drop the UART_BUG_DWTHRE flag
and associated code.

Marc
