Return-Path: <linux-kernel-owner+w=401wt.eu-S934570AbXLQXws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570AbXLQXws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872AbXLQXwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:52:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50520 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbXLQXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:05 -0500
Date: Mon, 17 Dec 2007 23:49:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Remy Bohmer <linux@bohmer.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       Steven Rostedt <rostedt@goodmis.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Message-ID: <20071217234932.GH23657@flint.arm.linux.org.uk>
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com> <Pine.LNX.4.58.0712121606241.23712@gandalf.stny.rr.com> <3efb10970712121429l7b41d57md4f826f6aaf4b71@mail.gmail.com> <3efb10970712130840r7a2c5f72jca641d1cac545464@mail.gmail.com> <cd73a99e0712130933s6f601ef7sed90f48c08d9adaa@mail.gmail.com> <3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com> <3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com> <3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com> <20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com> <3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 09:56:30PM +0100, Remy Bohmer wrote:
> > > +#define lread(port)          __raw_readl(port)
> > > +#define lwrite(v, port)              __raw_writel(v, port)
> >
> > Why is this necessary, and what does 'l' stand for?
> 
> There is a huge list of macros below these definitions. By doing it
> this way, the macros still fit on 80 characters wide, while without
> them, I had split up the macros over several lines, which does not
> make it more readable. That's all.
> 'l' refers at the last letter of __raw_readl, and writel. Nothing special.

So why not keep to the Linux convention?  How about at_readl() and
at_writel() ?

> > >  /*
> > > + * receive interrupt handler.
> > > + */
> > > +static inline void
> > > +atmel_handle_receive(struct uart_port *port, unsigned int pending)
> >
> > Please drop "inline" here. The compiler will do it automatically if it
> > has only one caller, and if it at some point gets several callers, we
> > might not want to inline it after all.
> 
> Funny, This was the first thing that Andrew started complaining about.
> He suggested to put an inline there which I had not. I already
> mentioned that this was against the CodingStyle, but I also mentioned
> that I did not wanted to start a fight about this :-)
> So, to prevent a discussion, I added the inline...

There's two schools of thought - those who want to add 'inline' keywords
all over the place and those who don't.  It's quite correct that if a
static function will be inlined by the compiler as it sees fit.  It
_can_ be that the compiler will chose not to inline it and that may
result in better register allocation in the caller, resulting in overall
faster code.

> >
> > > +     while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
> > > +             barrier();
> >
> > Should probably use cpu_relax(), but it's probably out of scope for a
> > codingstyle cleanup patch (and I don't think it matters on AVR32 or
> > ARM.)
> 
> Agree.

Even though it doesn't matter at the moment, I rather like to think a
bit about the future.  If the kernel has a simple and cheap mechanism
there's no reason to avoid using it.

> 
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

I think someone's mailer might be messing with the patches.  The above
removed and added lines appear to be identical.
