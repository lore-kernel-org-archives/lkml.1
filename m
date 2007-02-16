Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXBPRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXBPRVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXBPRVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:21:42 -0500
Received: from h155.mvista.com ([63.81.120.155]:52461 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932515AbXBPRVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:21:41 -0500
Message-ID: <45D5E81B.7030304@ru.mvista.com>
Date: Fri, 16 Feb 2007 20:21:31 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
 er
References: <45D5E4A7.3070807@pmc-sierra.com>
In-Reply-To: <45D5E4A7.3070807@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:

>> > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
>> > index 3d91bfc..bfaacc5 100644
>> > --- a/drivers/serial/8250.c
>> > +++ b/drivers/serial/8250.c
>> > @@ -308,6 +308,7 @@ static unsigned int serial_in(struct uar
>> >               return inb(up->port.iobase + 1);
>> > 
>> >       case UPIO_MEM:
>> > +     case UPIO_DWAPB:
>> >               return readb(up->port.membase + offset);
>> > 
>> >       case UPIO_MEM32:
>> > @@ -333,6 +334,8 @@ #endif
>> >  static void
>> >  serial_out(struct uart_8250_port *up, int offset, int value)
>> >  {
>> > +     /* Save the offset before it's remapped */
>> > +     int save_offset = offset;
>> >       offset = map_8250_out_reg(up, offset) << up->port.regshift;
>> > 
>> >       switch (up->port.iotype) {

>>    I've just got an idea how to "beautify" this code -- rename the 
>>'offset'
>>arg to something like reg, and then declare/init 'offset' as local 
>>variable.
>>Would certainly look better (and worth doing in all serial_* accessros).

> I agree but am having enough of a hard time getting the bare minimum
> accepted that I don't dare touch any unnecessary lines.

    Well, I can try pushing this simple cleanup myself... seems worth doing 
for alike future cases anyway.

>> > @@ -359,6 +362,18 @@ #endif
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
>> > +             if (save_offset == UART_TX || save_offset == UART_IER)
>> > +                     value = serial_in(up, UART_IER);
>> > +             break;
>> > +            
>> >       default:
>> >               outb(value, up->port.iobase + offset);
>> >       }
>> > @@ -2454,8 +2485,8 @@ int __init serial8250_start_console(stru
>> > 
>> >       add_preferred_console("ttyS", line, options);
>> >       printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
>> > -             line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
>> > -             port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
>> > +             line, port->iotype >= UPIO_MEM ? "MMIO" : "I/O port",
>> > +             port->iotype >= UPIO_MEM ? (unsigned long) port->mapbase :
>> >                   (unsigned long) port->iobase, options);
>> >       if (!(serial8250_console.flags & CON_ENABLED)) {
>> >               serial8250_console.flags &= ~CON_PRINTBUFFER;

>>    I've remembered why I decided not to fix it: this code only gets called
>>from 8250__eraly.c which can't handle anything beyond UPIO_MEM anyway.

> We don't use 8250_early and I've tested it works without, so I'll drop this
> change.

    No need I guess since this is the Right Thing (TM) anyway.

> Thanks,
> Marc

WBR, Sergei
