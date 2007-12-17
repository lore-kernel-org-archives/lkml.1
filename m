Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbXLQXOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbXLQXOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762261AbXLQXOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:14:05 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62264 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760159AbXLQXOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:14:02 -0500
Date: Tue, 18 Dec 2007 00:12:40 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>, RT <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Message-ID: <20071218001240.5cb42aae@siona>
In-Reply-To: <3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com>
	<Pine.LNX.4.58.0712121606241.23712@gandalf.stny.rr.com>
	<3efb10970712121429l7b41d57md4f826f6aaf4b71@mail.gmail.com>
	<3efb10970712130840r7a2c5f72jca641d1cac545464@mail.gmail.com>
	<cd73a99e0712130933s6f601ef7sed90f48c08d9adaa@mail.gmail.com>
	<3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com>
	<3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com>
	<3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
	<20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
	<3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 21:56:30 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> > Btw, it would be nice if patches that affect more or less
> > architecture-independent drivers were posted to linux-kernel (added
> > to Cc.)
> 
> Not really architecture independant, I believe, because thos are
> drivers for peripherals _inside_ Atmel Cores ;-)

Well, those Atmel cores cover two different architectures: ARM and
AVR32. But yeah, "architecture independent" is perhaps a bit of a
stretch ;-)

> > Also, it would be easier to review if you posted just one patch per
> > e-mail. I'm going to cut & paste a bit from your attachments.
> 
> I know, but I have some troubles to get 'quilt mail' to work from
> behind a proxy server, and attaching to a mail, at least it does not
> corrupt the contents of the patches.

Ok, attachments are a lot better than corrupted patches.

> > > +#define lread(port)          __raw_readl(port)
> > > +#define lwrite(v, port)              __raw_writel(v, port)
> >
> > Why is this necessary, and what does 'l' stand for?
> 
> There is a huge list of macros below these definitions. By doing it
> this way, the macros still fit on 80 characters wide, while without
> them, I had split up the macros over several lines, which does not
> make it more readable. That's all.
> 'l' refers at the last letter of __raw_readl, and writel. Nothing
> special.

Ok, makes sense.

> > Looks like you're adding one or more spaces before each TAB here.
> > Why is that an improvement?
> 
> I used scripts/Lindent to reformat the file, and then I removed the
> quirks Lindent put in the file. Apparantly I missed that one.

Hmm. Lindent does such things? That's not very helpful...

> > These conflict with David Brownell's "atmel_serial build warnings
> > begone" patch which was merged into mainline a few weeks ago.
> 
> Hmm, I seem to have missed that one. Why is it not there in a
> big-AT91-patch from Andrew?

I think it went in via Andrew Morton.

But it's fine by me -- it all worked out automatically when I applied it
to 2.6.23 and rebased.

> > >  /*
> > > + * receive interrupt handler.
> > > + */
> > > +static inline void
> > > +atmel_handle_receive(struct uart_port *port, unsigned int
> > > pending)
> >
> > Please drop "inline" here. The compiler will do it automatically if
> > it has only one caller, and if it at some point gets several
> > callers, we might not want to inline it after all.
> 
> Funny, This was the first thing that Andrew started complaining about.
> He suggested to put an inline there which I had not. I already
> mentioned that this was against the CodingStyle, but I also mentioned
> that I did not wanted to start a fight about this :-)
> So, to prevent a discussion, I added the inline...

Hmm, ok. Andrew, could you elaborate on why you want it to be inline?

> I did not remove any comment, even if they appear useless to me. I am
> not the maintainer of this driver, and just wanted to improve it, so
> that it was able of running on Preempt-RT.
> Before being able to submit the change that really mattered to me, I
> had to make the driver pass the scripts/checkpatch.pl check, otherwise
> the patch-that-matters would be completely unreadable.

I understand that.

> > >       /*
> > > -      *      First, save IMR and then disable interrupts
> > > +      *      First, save IMR and then disable interrupts
> > >        */
> > >       imr = UART_GET_IMR(port);       /* get interrupt mask */
> > >       UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
> > > @@ -790,30 +828,32 @@ static void atmel_console_write(struct c
> > >       uart_console_write(port, s, count, atmel_console_putchar);
> > >
> > >       /*
> > > -      *      Finally, wait for transmitter to become empty
> > > -      *      and restore IMR
> > > +      *      Finally, wait for transmitter to become empty
> > > +      *      and restore IMR
> > >        */
> >
> > Looks like you're replacing TABs with spaces. Why?
> 
> ????

Originally, there's a TAB between '*' and First/Finally. The patch
replaces it with spaces.

That said, it's probably better to just replace the tab with a single
space...

> > > -// TODO: CR is a write-only register
> > > -//   unsigned int cr;
> > > +/* TODO: CR is a write-only register
> > > +//      unsigned int cr;
> > >  //
> > > -//   cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
> > > -//   if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
> > > -//           /* ok, the port was enabled */
> > > -//   }
> > > +//      cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
> > > +//      if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
> > > +//              / * ok, the port was enabled * /
> > > +//      }*/
> >
> > That's a funny mix of C and C++ comments. Why not simply use #if 0
> > and kill all the C++ comments?
> 
> As mentioned, did not want to change it that much.

Understandably. However, I think we should just kill that code
altogether and check BRGR instead. If BRGR is 0, the baud rate
generator doesn't run, so we can assume the port hasn't been
initialized.

I'll cook up a separate patch for that. Until then, I think we should
just leave it as it was.

> > That said, I don't understand what "TODO" means in this context. CR
> > isn't going to be readable any time soon.
> 
> I also did not understand what was meant here.

I think I do. We want to check if the port is already enabled, but we
can't read it from CR. So I think we should use BRGR instead.

> > > @@ -845,10 +885,10 @@ static int __init atmel_console_setup(st
> > >       int parity = 'n';
> > >       int flow = 'n';
> > >
> > > -     if (port->membase == 0)         /* Port not initialized yet
> > > - delay setup */
> > > +     if (port->membase == 0) /* Port not initialized yet - delay
> > > setup */ return -ENODEV;
> >
> > Looks better if you move the comment inside the body IMO.
> 
> And would add some extra brackets etc.
> I did not try to make it perfect ;-)

No extra brackets are needed. Comments don't count.

> > > @@ -880,13 +920,17 @@ static struct console atmel_console = {
> > >  static int __init atmel_console_init(void)
> > >  {
> > >       if (atmel_default_console_device) {
> > > -             add_preferred_console(ATMEL_DEVICENAME,
> > > atmel_default_console_device->id, NULL);
> > > -
> > > atmel_init_port(&(atmel_ports[atmel_default_console_device->id]),
> > > atmel_default_console_device);
> > > +             add_preferred_console(ATMEL_DEVICENAME,
> > > +
> > > atmel_default_console_device->id, NULL);
> > > +             atmel_init_port(
> > > +
> > > &(atmel_ports[atmel_default_console_device->id]),
> > > +                           atmel_default_console_device);
> >
> > That looks a bit funny. If you're having trouble moving
> > &(atmel_ports... onto the same line as atmel_init_port, please
> > consider removing the redundant parentheses.
> 
> Guess, that wouldn't fit either?

It does. Barely.

> > Moving on to the next patch...
> >
> > > This patch splits up the interrupt handler of the serial port
> > > into a interrupt top-half and some tasklets.
> > >
> > > The goal is to get the interrupt top-half as short as possible to
> > > minimize latencies on interrupts. But the old code also does some
> > > calls in the interrupt handler that are not allowed on preempt-RT
> > > in IRQF_NODELAY context. This handler is executed in this context
> > > because of the interrupt sharing with the timer interrupt.
> > > The timer interrupt on Preempt-RT runs in IRQF_NODELAY context.
> >
> > What calls are we talking about here? uart_insert_char() and
> > tty_flip_buffer_push()?
> 
> Yep. All calls that block on a Mutex somehow on Preempt-RT. (such as
> spinlocks, wakeup_interruptible() and many of its friends.)

Right. Looks like the DMA patch call these functions from irq context
too...I guess it'll need the same treatment?

> > > 2 tasklets are used:
> > > * one for handling the error statuses
> > > * one for pushing the incoming characters into the tty-layer.
> >
> > Why is it necessary with two tasklets?
> 
> To prevent rewriting the code completely. 1 change was in a read
> routine, the other at a different location.

Ok, but both originate from the interrupt handler...

> > > +struct atmel_uart_char {
> > > +     unsigned int status;
> > > +     unsigned int overrun;
> > > +     unsigned int ch;
> > > +     unsigned int flg;
> > > +};
> >
> > Hmm. 16 bytes per char is a bit excessive, isn't it? How about
> >
> > struct atmel_uart_char {
> >         u16     ch;
> >         u16     status;
> > };
> >
> > where ch is the received character (up to 9 bits) and status is the
> > lowest 16 bits of the status register?
> 
> I used the NODELAY patch for the 8250 serial port as reference, it
> contains similar code, and I tried to make both look the same.

Ok, I see. But...

> > > +#define ATMEL_SERIAL_RINGSIZE 1024

This means that the buffer ends up at 16K. Since the buffer itself is
kept in a struct along with a few other pieces of data, we end up
kmalloc()ing 32KB of memory...

> > > +struct atmel_uart_ring {
> > > +     unsigned int          head;
> > > +     unsigned int          tail;
> > > +     unsigned int          count;
> > > +     struct atmel_uart_char data[ATMEL_SERIAL_RINGSIZE];
> > > +};
> >
> > Why not use struct circ_buf? Why do you need "count"?
> 
> See previous remark.

Ok.

> > Ok, that's all for now. I'm going to take a closer look at the DMA
> > patch and hopefully figure out why it isn't working on AVR32.
> >
> > Thanks for your efforts in cleaning this stuff up.
> >
> > Haavard
> >
> 
> Thank you for reviewing it.
> 
> I will have a look at it in again later this week.
> 
> Have you any idea how we can integrate both patch series (yours and
> mine) without interfering each other? This patchset was quite
> annoying, because through multiple channels patches are submitted, and
> even stacked up...

I'm a bit tempted to just go ahead and do the changes we agree on and
post the result. Then I'll see if I can make the DMA stuff behave. I've
got a different driver lying around which is DMA-only and has a few
problems on its own. Integrating the good bits into the atmel_serial
driver will hopefully result in something that is better than either of
them.

Also, I think the DMA patch needs to be more integrated with your
"interrupt handler splitup" patch. No point in keeping two RX buffers
around, and the DMA code needs to obey the same rules as the rest of
the driver if it's going to work in -rt.

And I'd really like to have working DMA support on avr32 before
christmas ;-)

Haavard
