Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZJLL4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZJLL4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZJLL4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:56:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51242 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZJLL4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:56:39 -0400
Date: Mon, 12 Oct 2009 13:55:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012115549.GA13987@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <20091012091954.GA31171@elte.hu> <20091012092713.GA32647@elte.hu> <20091012112504.GA10002@elte.hu> <20091012124501.3c1ac94f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012124501.3c1ac94f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Unfortunately 46d57a449aa13d9c6adcc9d1dbc7b9a0ecfb69d8 is not easy to 
> > revert, at all. Would be glad to try any patch - fixes or some manual 
> > revert as well (if that's feasible).
> 
> The patch doesn't do anything but create local variables of 
> state->port. I'm now glad I did it that way as it makes it easy to 
> spot the mistake.
>
> the tty_port lock is ->lock, the uart lock is ->lock both are 
> different..
> 
> Spot the mistake:
> 
>  	if (state->flags & UIF_INITIALIZED) {
>  		unsigned long flags;
>  		spin_lock_irqsave(&port->lock, flags);
> -		port->ops->stop_rx(port);
> +		uport->ops->stop_rx(uport);
>  		spin_unlock_irqrestore(&port->lock, flags);
>  		/*
>  		 * Before we drop DTR, make sure the UART transmitter
>  		 * has completely drained; this is especially
>  		 * important if there is a transmit FIFO!
>  		 */
> -		uart_wait_until_sent(tty, port->timeout);
> +		uart_wait_until_sent(tty, uport->timeout);
>  	}
> 
> 
> so uart_close takes the wrong lock. I've checked the rest of the patch 
> for the same error and I don't see any other screwups.

Cool! This very much looks like something that could fix both problems. 
I've started testing your fix.

And yeah, i too never ever regretted having done 'too finegrained' 
patches. (only ever the other way around) They are a pleasure to bisect 
back to.

> [...] The race in question is very hard to hit but fortunately Ingo 
> hit it twice..

a hundred thousand bootups a year go a long way in finding narrow races 
;-)

	Ingo
