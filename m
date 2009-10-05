Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZJEKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZJEKei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbZJEKei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:34:38 -0400
Received: from www.tglx.de ([62.245.132.106]:51925 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbZJEKeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:34:37 -0400
Date: Mon, 5 Oct 2009 12:33:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rt11 freeze on userland start on ARM
In-Reply-To: <3efb10970910041359m1db64926pcf83ebd98a8b1bdd@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910051228041.2646@localhost.localdomain>
References: <3efb10970909211136g4e74c8b3vc339d548cdd0959f@mail.gmail.com>  <alpine.LFD.2.00.0909301448030.2518@nanos>  <3efb10970909300911j44638434mc22adfd64aaef421@mail.gmail.com>  <alpine.LFD.2.00.0910041202110.2646@localhost.localdomain>
 <3efb10970910041359m1db64926pcf83ebd98a8b1bdd@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOn Sun, 4 Oct 2009, Remy Bohmer wrote:

> Hi,
> 
> 2009/10/4 Thomas Gleixner <tglx@linutronix.de>:
> > On Wed, 30 Sep 2009, Remy Bohmer wrote:
> >> > The serial irq cannot run in hard irq context.
> >>
> >> Indeed most drivers cannot, but for this particular handler can you
> >> please explain me why?
> >> Maybe I am missing some new mechanism that prevents it that was not
> >> there on older RT-kernels (tested up-to latest 2.6.24-rt +
> >> 2.6.26-rt)...
> >
> > Which had the same problem ....
> 
> what problem...?

The tasklet conversion happened after .24 and the hard interrupt
context receive loop has introduced quite nasty latencies in
.26. There was some other warning problem in .26 which I forgot.
 
> I will adapt the atmel-serial driver to this new irq-threading model
> and provide a patch for it, it seems cleaner and makes the tasklet
> stuff obsolete for this driver.

Great, that code really looks ugly.

> >> TOL: could the generic interrupt code not check for this? It can see
> >> the timer interrupt handler not returning 'IRQ_HANDLED', and still see
> >> the interrupt being active, and know that there is a IRQ thread on the
> >> same line, so it can conclude itself to mask the source in the
> >> interrupt controller and wake the thread... Or am I wrong?
> >
> > What happens if both are active at the same time ? Also masking the
> > interrupt line will block your timer interrupts until the threaded
> > handler has completed.
> 
> That is indeed true, and proves once again that shared interrupt
> handlers are really annoying, especially on -rt...
> 
> The old way we did in 2.6.24-rt + 2.6.26-rt was to adapt the handler
> to allow it to run in hard-irq context for -rt as well as mainline.
> The new way handles this differently... Since a -rt-friendly generic
> solution seems not possible, I guess before -rt ever becomes mainline
> _all_ interrupt handlers that are shared with a nodelay interrupt in
> some configuration must be adapted to the new threaded_irq model... A
> huge job...

Don't think so. ATx seems to be one of the weirder pieces of hardware :)

Thanks,

	tglx
