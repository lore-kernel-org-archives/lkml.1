Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXBSOfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXBSOfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBSOfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:35:32 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4549 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXBSOfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:35:31 -0500
Date: Mon, 19 Feb 2007 14:35:20 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: jose.goncalves@inov.pt, tie-fei.zang@freescale.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219143520.GB27370@flint.arm.linux.org.uk>
Mail-Followup-To: Frederik Deweerdt <deweerdt@free.fr>,
	jose.goncalves@inov.pt, tie-fei.zang@freescale.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220142442.GF566@slug>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 02:24:42PM +0000, Frederik Deweerdt wrote:
> On Mon, Feb 19, 2007 at 01:45:39PM +0000, Russell King wrote:
> > On Tue, Feb 20, 2007 at 01:29:09PM +0000, Frederik Deweerdt wrote:
> > > (Sorry for the resend, I forgot to cc the list)
> > > Hi Russell,
> > > 
> > > It seems that the following change in drivers/serial/8250.c
> > > 
> > > +
> > > +	/*
> > > +	 * Do a quick test to see if we receive an
> > > +	 * interrupt when we enable the TX irq.
> > > +	 */
> > > +	serial_outp(up, UART_IER, UART_IER_THRI);
> > > +	lsr = serial_in(up, UART_LSR);
> > > +	iir = serial_in(up, UART_IIR);
> > > +	serial_outp(up, UART_IER, 0);
> > > +
> > > +	if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
> > > +		if (!(up->capabilities & UART_BUG_TXEN)) {
> > > +			up->capabilities |= UART_BUG_TXEN;
> > > +			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
> > > +				 port->line);
> > > +		}
> > > +	} else {
> > > +		up->capabilities &= ~UART_BUG_TXEN;
> > > +	}
> > > +
> > > 
> > > that was introduced in 2.6.12[1], is causing oopses on some hardware. In
> > > particular Jose Goncalves reported[2] an oops in 2.6.16.38 reproducible
> > 
> > I don't see that.  The oops your referring to is a NULL pointer
> > dereference.  The only dereferences the above code does is via
> > 'up' and 'port' both of which are provably always non-null here.
>
> Neither did I, but introducing printk's through the function, we narrowed
> the problem to this part of the code. And removing it makes the problem
> go away. We inserted 37 printk's in the function body, and Jose bisected
> those until the problem went away.

Well, there's still little clue about why this is causing a NULL pointer
dereference.  The only thing I can think is that somehow performing
this test is causing a power glitch to your CPU, causing its registers
to get corrupted, and which results in it doing a NULL pointer deref.

Are you saying that the NULL pointer occurred while executing this code?
If not, where does the NULL pointer occur?

> > No, it's only runtime because you can't tell which ports might be
> > affected, and you might have a mixture of ports which are affected
> > and those which aren't.
> Hmm, ok. And what about a CONFIG_I_KNOW_MY_SERIAL_IS_BROKEN option?

Andrew's said no (in that the thread you refer to) and suggested an
alternative, I've said no, how many more 'no's do you need to turn
you away from the wrong approach?

> > > PS: CCing Andrew and Zang Roy-r61911 as they seemed to discuss this in
> > > http://lkml.org/lkml/2006/6/13/21
> > 
> > I don't see any reference to this problem there.
>
> Sorry, I suck, I got that mixed with that one:
> http://lkml.org/lkml/2006/12/26/63
> "probing for UART_BUG_TXEN in 8250 driver leads to weird effects on some
> ARM boards"

The "weird effects" were never quantified, so that's one of the reasons
I ignored that report (another being is that I stopped being the serial
maintainer a while ago, and now serial is maintainerless.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
