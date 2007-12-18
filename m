Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXLRJI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXLRJI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 04:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXLRJIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 04:08:16 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64907 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751938AbXLRJIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 04:08:13 -0500
Date: Tue, 18 Dec 2007 10:07:24 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Remy Bohmer <linux@bohmer.net>, linux-kernel@vger.kernel.org,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       Steven Rostedt <rostedt@goodmis.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Message-ID: <20071218100724.3e79629e@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20071217234932.GH23657@flint.arm.linux.org.uk>
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
	<20071217234932.GH23657@flint.arm.linux.org.uk>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 23:49:32 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Dec 17, 2007 at 09:56:30PM +0100, Remy Bohmer wrote:
> > > > +#define lread(port)          __raw_readl(port)
> > > > +#define lwrite(v, port)              __raw_writel(v, port)
> > >
> > > Why is this necessary, and what does 'l' stand for?
> > 
> > There is a huge list of macros below these definitions. By doing it
> > this way, the macros still fit on 80 characters wide, while without
> > them, I had split up the macros over several lines, which does not
> > make it more readable. That's all.
> > 'l' refers at the last letter of __raw_readl, and writel. Nothing special.
> 
> So why not keep to the Linux convention?  How about at_readl() and
> at_writel() ?

Something like this perhaps?

#define at_readl(port, off)	__raw_readl((port)->membase + (off))
#define at_writel(v, port, off)	__raw_writel(v, (port)->membase + (off))

#define UART_PUT_CR(port, v)	at_writel(v, port, ATMEL_US_CR)
#define UART_PUT_MR(port, v)	at_writel(v, port, ATMEL_US_MR)
#define UART_PUT_IER(port, v)	at_writel(v, port, ATMEL_US_IER)
#define UART_PUT_IDR(port, v)	at_writel(v, port, ATMEL_US_IDR)
#define UART_PUT_CHAR(port, v)	at_writel(v, port, ATMEL_US_THR)
#define UART_PUT_BRGR(port, v)	at_writel(v, port, ATMEL_US_BRGR)
#define UART_PUT_RTOR(port, v)	at_writel(v, port, ATMEL_US_RTOR)

That said, I wonder if it may actually be nicer to just use
at_writel()/at_readl() throughout the driver...but that's for a later
cleanup.

> > >
> > > > +     while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
> > > > +             barrier();
> > >
> > > Should probably use cpu_relax(), but it's probably out of scope for a
> > > codingstyle cleanup patch (and I don't think it matters on AVR32 or
> > > ARM.)
> > 
> > Agree.
> 
> Even though it doesn't matter at the moment, I rather like to think a
> bit about the future.  If the kernel has a simple and cheap mechanism
> there's no reason to avoid using it.

I can do it in a separate patch.

> > 
> > > >       /*
> > > > -      *      First, save IMR and then disable interrupts
> > > > +      *      First, save IMR and then disable interrupts
> > > >        */
> > > >       imr = UART_GET_IMR(port);       /* get interrupt mask */
> > > >       UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
> > > > @@ -790,30 +828,32 @@ static void atmel_console_write(struct c
> > > >       uart_console_write(port, s, count, atmel_console_putchar);
> > > >
> > > >       /*
> > > > -      *      Finally, wait for transmitter to become empty
> > > > -      *      and restore IMR
> > > > +      *      Finally, wait for transmitter to become empty
> > > > +      *      and restore IMR
> > > >        */
> > >
> > > Looks like you're replacing TABs with spaces. Why?
> > 
> > ????
> 
> I think someone's mailer might be messing with the patches.  The above
> removed and added lines appear to be identical.

Yes, the difference was wiped out after a few times back and forth. It
was visible (or...not actually visible, but you know how to detect
these things) in the first couple of e-mails.

Haavard
