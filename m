Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXBSOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXBSOZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932278AbXBSOZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:25:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:13992 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbXBSOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=PYqGV5k8/oCDgHO3PwdENYtsNA1oY5TXIl40hlqvMISVL7SS2GeRiGuXNkY+g1yjBaM+Fwol3PQe+1rUHPSCcA5RwIHR0goojqjIu5vg8GiqiVcsOKKtYrzXJ5tWdVph8f5CAQy+jwBKr9X3Kgj8UIGyp9efHHT5JQPTgPS1+CM=
Date: Tue, 20 Feb 2007 14:24:42 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: jose.goncalves@inov.pt, tie-fei.zang@freescale.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070220142442.GF566@slug>
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219134539.GA27370@flint.arm.linux.org.uk>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 01:45:39PM +0000, Russell King wrote:
> On Tue, Feb 20, 2007 at 01:29:09PM +0000, Frederik Deweerdt wrote:
> > (Sorry for the resend, I forgot to cc the list)
> > Hi Russell,
> > 
> > It seems that the following change in drivers/serial/8250.c
> > 
> > +
> > +	/*
> > +	 * Do a quick test to see if we receive an
> > +	 * interrupt when we enable the TX irq.
> > +	 */
> > +	serial_outp(up, UART_IER, UART_IER_THRI);
> > +	lsr = serial_in(up, UART_LSR);
> > +	iir = serial_in(up, UART_IIR);
> > +	serial_outp(up, UART_IER, 0);
> > +
> > +	if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
> > +		if (!(up->capabilities & UART_BUG_TXEN)) {
> > +			up->capabilities |= UART_BUG_TXEN;
> > +			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
> > +				 port->line);
> > +		}
> > +	} else {
> > +		up->capabilities &= ~UART_BUG_TXEN;
> > +	}
> > +
> > 
> > that was introduced in 2.6.12[1], is causing oopses on some hardware. In
> > particular Jose Goncalves reported[2] an oops in 2.6.16.38 reproducible
> 
> I don't see that.  The oops your referring to is a NULL pointer
> dereference.  The only dereferences the above code does is via
> 'up' and 'port' both of which are provably always non-null here.
Neither did I, but introducing printk's through the function, we narrowed
the problem to this part of the code. And removing it makes the problem
go away. We inserted 37 printk's in the function body, and Jose bisected
those until the problem went away.
>
> > I was wondering:
> > - what is the goal of the test?
> 
> To detect UARTs which do not assert an interrupt when the transmit
> interrupt is enabled, which then causes no data to ever be transmitted
> without this work-around.
OK, thanks for clarifying.
> 
> > - could this be CONFIGed ?
> 
> No, it's only runtime because you can't tell which ports might be
> affected, and you might have a mixture of ports which are affected
> and those which aren't.
Hmm, ok. And what about a CONFIG_I_KNOW_MY_SERIAL_IS_BROKEN option?
> 
> > PS: CCing Andrew and Zang Roy-r61911 as they seemed to discuss this in
> > http://lkml.org/lkml/2006/6/13/21
> 
> I don't see any reference to this problem there.
Sorry, I suck, I got that mixed with that one:
http://lkml.org/lkml/2006/12/26/63
"probing for UART_BUG_TXEN in 8250 driver leads to weird effects on some
ARM boards"

Regards,
Frederik
