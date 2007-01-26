Return-Path: <linux-kernel-owner+w=401wt.eu-S965676AbXAZN65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676AbXAZN65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030195AbXAZN65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:58:57 -0500
Received: from h155.mvista.com ([63.81.120.155]:7985 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965675AbXAZN64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:58:56 -0500
Message-ID: <45BA08EF.4070000@ru.mvista.com>
Date: Fri, 26 Jan 2007 16:58:07 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
 er
References: <45B938D9.6010203@pmc-sierra.com>
In-Reply-To: <45B938D9.6010203@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:

>> > Here is my second attempt at the serial driver patch for the
>> > PMC-Sierra MSP71xx device.

>> > There are three different fixes:
>> > 1. Fix for THRE errata
>> > - I verified the UART_BUG_TXEN fix does not help with this erratum.
>> > - I left our current fix in until I get our platform booting on
>> > 2.6.20-rc4 to try the mm tree "8250-uart-backup-timer.patch".
>> > Feel free to ignore for now.

>> > 2. Fix for Busy Detect on LCR write
>> > - Moved to new UPIO_DWAPB iotype. Because the new type is a memory
>> > mapped device and there are several tests for UPIO_MEM, this involved
>> > updating serial_core.c and 8250_early.c in addition to 8250.c.
>> > - I tried implementing this totally in serial_in as suggested, but
>> > it can't be done because of bit overlap between UART_IIR_NO_INT and
>> > UART_IIR_BUSY. Also there is no way to set the interrupt "handled = 1"
>> > from serial_in.

>> > 3. Workaround for interrupt/data concurrency issue
>> > - Moved to new UPIO_DWAPB iotype.

>> > Index: linux_2_6/drivers/serial/8250.c
>> > ===================================================================
>> > RCS file: linux_2_6/drivers/serial/8250.c,v
>> > retrieving revision 1.1.1.7
>> > diff -u -r1.1.1.7 8250.c
>> > --- linux_2_6/drivers/serial/8250.c   19 Oct 2006 21:00:58 -0000      
>>1.1.1.7
>> > +++ linux_2_6/drivers/serial/8250.c   24 Jan 2007 23:55:27 -0000
>>[...]
>> > @@ -333,6 +334,8 @@
>> >   static void
>> >   serial_out(struct uart_8250_port *up, int offset, int value)

>>   Your patch is clearly garbled again, something added an extra space 
>>to all
>>lines stating with space... :-/

> I see that but was under the impression cvs diff did that so all lines
> lineup correctly whether they have a +, -, or neither.

    Yes. And your mailer has probably added another space to lines already 
begginign with space. Some mailers tend to do it, don't know sure why... :-/

> It doesn't affect applying the patches for me, did you try?

    I hadn't but I had no doubts it'll fail... just tried, not a single hunk 
applied. :-]

>> >   {
>> > +     /* Save the offset before it's remapped */
>> > +     int save_offset = offset;

>>    Is there real need to save this? What regshift equals for this UART?

> Yes, we have a regshift of 2 on this SoC and it could be different on other
> SoCs which reuse the UART IP.

    Agreed then (though still seems avoidable).

>> >       offset = map_8250_out_reg(up, offset) << up->port.regshift;

>> >       switch (up->port.iotype) {
>> > @@ -359,6 +362,19 @@
>> >                       writeb(value, up->port.membase + offset);
>> >               break;
>> >
>> > +     case UPIO_DWAPB:
>> > +             /* Save the LCR value so it can be re-written when a
>> > +              * Busy Detect interrupt occurs. */
>> > +             if (save_offset == UART_LCR)
>> > +                     up->lcr = value;
>> > +             writeb(value, up->port.membase + offset);
>> > +             /* Read the IER to ensure any interrupt is cleared before
>> > +              * returning from ISR. */
>> > +             if ((save_offset == UART_TX || save_offset == UART_IER) &&

>>    Not sure how an IER read ensures that...

> It's just a dummy read to ensure that any writes which clear interrupts have
> reached the device before returning from the IRQ.

    Hm, isn't it CPU write buffer flush? Shouldn't this be handled more 
generically?

[...]
>> > Index: linux_2_6/drivers/serial/8250_early.c
>> > ===================================================================
>> > RCS file: linux_2_6/drivers/serial/8250_early.c,v
>> > retrieving revision 1.1.1.3
>> > diff -u -r1.1.1.3 8250_early.c
>> > --- linux_2_6/drivers/serial/8250_early.c     19 Oct 2006 20:08:20 
>>-0000      1.1.1.3
>> > +++ linux_2_6/drivers/serial/8250_early.c     24 Jan 2007 23:55:27 -0000
>> > @@ -46,7 +46,7 @@
>> >
>> >   static unsigned int __init serial_in(struct uart_port *port, int 
>>offset)
>> >   {
>> > -     if (port->iotype == UPIO_MEM)
>> > +     if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>> >               return readb(port->membase + offset);
>> >       else
>> >               return inb(port->iobase + offset);
>> > @@ -54,7 +54,7 @@
>> >
>> >   static void __init serial_out(struct uart_port *port, int offset, 
>>int value)
>> >   {
>> > -     if (port->iotype == UPIO_MEM)
>> > +     if (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB)
>> >               writeb(value, port->membase + offset);
>> >       else
>> >               outb(value, port->iobase + offset);
>> > @@ -233,7 +233,7 @@
>> >               return 0;
>> >
>> >       /* Try to start the normal driver on a matching line.  */
>> > -     mmio = (port->iotype == UPIO_MEM);
>> > +     mmio = (port->iotype == UPIO_MEM || port->iotype == UPIO_DWAPB);
>> >       line = serial8250_start_console(port, device->options);
>> >       if (line < 0)
>> >               printk("No ttyS device at %s 0x%lx for console\n",

>>    From your 8250_eraly.c changes I can conclude regshift == 1 (it doesn't
>>currently support other cases). So, serial_pot() doesn't need 
>>save_offset. :-)

> Our regshift is definitely 2 on this SoC and we don't have any problems with
> console output before the serial driver opens. So assuming it's using
> 8250_early.c for initial console output I can only conclude that it works

    It comes into action only if you specify console=uart,... kernel option 
for the eraly console support.  The "plain" 8250 console driver is containded 
within 8250.c itself.

> because UART_TX is offset 0 and the port was left configured from our
> ROM monitor.

    Well, this part of the patch can't be considered complete then (how LSR 
polling is going to work?), so should either be removed or the proper regshift 
support added.

>> > Index: linux_2_6/include/linux/serial_reg.h
>> > ===================================================================
>> > RCS file: linux_2_6/include/linux/serial_reg.h,v
>> > retrieving revision 1.1.1.2
>> > diff -u -r1.1.1.2 serial_reg.h
>> > --- linux_2_6/include/linux/serial_reg.h      19 Oct 2006 18:29:50 
>>-0000      1.1.1.2
>> > +++ linux_2_6/include/linux/serial_reg.h      24 Jan 2007 23:55:29 -0000
>> > @@ -218,6 +218,10 @@
>> >   #define UART_FCR_PXAR16     0x80    /* receive FIFO treshold = 16 */
>> >   #define UART_FCR_PXAR32     0xc0    /* receive FIFO treshold = 32 */
>> >
>> > +/*
>> > + * DesignWare APB UART
>> > + */
>> > +#define UART_IIR_BUSY                0x07    /* Busy Detect */
>>
>>    I'd suggest keeping this with other UART_IIR_* #defines, separated 
>>by the
>>more elaborate comment.

> Will do. I noticed that the other non-standard value UART_IIR_TOD 0x08 is with
> the Xscale stuff so I followed suit.

    Well, Xscale introduced several bits. And note that 16650 definitions are 
kept with the "standard" 16550 ones.  Well, be sure to elaborate the comment 
whereever you stick that #define.

> Marc

MBR, Sergei
