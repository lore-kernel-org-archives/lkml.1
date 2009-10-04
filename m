Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZJDMAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZJDMAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZJDMAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:00:06 -0400
Received: from www.tglx.de ([62.245.132.106]:59186 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZJDMAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:00:04 -0400
Date: Sun, 4 Oct 2009 13:59:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rt11 freeze on userland start on ARM
In-Reply-To: <3efb10970909300911j44638434mc22adfd64aaef421@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910041202110.2646@localhost.localdomain>
References: <3efb10970909211136g4e74c8b3vc339d548cdd0959f@mail.gmail.com>  <alpine.LFD.2.00.0909301448030.2518@nanos> <3efb10970909300911j44638434mc22adfd64aaef421@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009, Remy Bohmer wrote:
> > The serial irq cannot run in hard irq context.
> 
> Indeed most drivers cannot, but for this particular handler can you
> please explain me why?
> Maybe I am missing some new mechanism that prevents it that was not
> there on older RT-kernels (tested up-to latest 2.6.24-rt +
> 2.6.26-rt)...

Which had the same problem ....

> The atmel_serial IRQ was adapted such (I think it was mainlined in
> 2.6.25 already) to make it suitable to run in hard-irq context. (I
> know, because I did that myself)

That's fine for mainline but not for -rt.

> FWIW... it seems to run stable in hard-irq context on 2.6.31-rt with
> the patch above as well... (coincidence?)

Yes. The serial code takes locks which are converted to sleeping locks
on -RT. That's a nono.

> > 2) Make the serial driver explicitely threaded and check in the
> > hardirq handler whether the irq originated from the serial driver. If
> > yes, disable it in the serial device and return IRQ_WAKE_THREAD
> > otherwise return IRQ_NONE.
> 
> Interesting, this sounds new, and I have to dig into it to find out
> how this is supposed to work... Do you happen to have any good
> pointers for examples or doc?

drivers/net/wireless/b43/main.c in mainline

> TOL: could the generic interrupt code not check for this? It can see
> the timer interrupt handler not returning 'IRQ_HANDLED', and still see
> the interrupt being active, and know that there is a IRQ thread on the
> same line, so it can conclude itself to mask the source in the
> interrupt controller and wake the thread... Or am I wrong?

What happens if both are active at the same time ? Also masking the
interrupt line will block your timer interrupts until the threaded
handler has completed.

Thanks,

	tglx
