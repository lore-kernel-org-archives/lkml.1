Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbZCBRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbZCBRyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZCBRx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:53:57 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:62854 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZCBRxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=N8dEQUr5nmjvd7jMOcd/9FXIPE998V8zqds7cYvIGOYPiS8amoulqP9XHWsRz058iE
         yr5P2q8tl4D0CwgWVh4Eg+Zn6zgT6EeARJMbKPpqyKhzib+aj4/n/e0P6xN964GELjZB
         KjToXeOLDMuox+BwG135GVYAc9zncpWFVkkD0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Date: Mon, 2 Mar 2009 18:55:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090227; KDE/4.2.0; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-arch" <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1235996477.5330.174.camel@laptop> <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021855.02765.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Peter Zijlstra wrote:
> > 
> > Would you be willing to take such a patch?
> 
> Yes - some day.
> 
> The "irq's disabled fastpath" thing has been there since pretty much day 
> one, because some irq handlers always wanted it. Making it the default 
> (and the only choice) is fine.
> 
> HOWEVER.
> 
> The fact is, some interrupt handlers are too slow for this. If you are 
> using a PIO IDE driver, not enabling interrupts will not only make you 
> lose serial line interrupts like mad (even at slow speeds), but has 
> historically resulted in even timer interrupts being lost because the IDE 
> layer is so slow.
> 
> The thing is, with PIO, a 512-byte disk read ends up doing 256 16-bit word 
> reads from the controller, each potentially up to 600ns long (PIO0 
> timings). That's 150ms - for a single sector!
> 
> Now, IDE controllers that we end up using PIO on all tend to be pretty 
> old, but admittedly even the old ones are faster than the worst-case 
> timings, so in practice you're not looking quite at that kind of horror 
> case, but you're still looking at each sector transfer (256 16-bit words) 
> taking on the order of tens of us.
> 
> For example, Mode2 timings are probably still something we should consider 
> realistic, and that's 240ns per word - a single sector now takes ~60ms to 
> read off the disk.
> 
> And we don't do single sectors. Most transfers will be 8 sectors (4k 
> contiguos read). So now that 60ms is 480ms per such IDE interrupt. And 
> even with the _good_ timings, we're certainly looking at a reduction of 
> that to about half.
> 
> Imagine what happens when we have interrupts disabled for half a second at 
> a time.  
> 
> In other words, I do not think we are ready for this.
> 
> Now: I suspect you don't have a single machine that does PIO by default, 
> and you probably haven't had any for the last ten years. These things 
> _are_ old. But they do exist. 
> 
> Could we make IRQF_DISABLED the default? Hell yes. We probably should. But 
> we realistically can't remove the non-disabled case, until you also have a 
> (tested) patch to fix these kinds of issues for the IDE PIO case (and 
> possibly others - IDE is the one I _know_ needs it).
> 
> Could we make just the IDE driver itself enable interrupts? Sure. But that 

Actually it has been doing it for years (some host drivers don't do this by
default and still need "hdparm -u" or equivalent but I was planning to change
it for 2.6.30).

> means that the interrupt controller code needs to know that some drivers 
> may enable interrupts and they may have recursive interrupts occurring. In 
> which case you really do want a flag anyway, since the interrupt 
> controller may well end up deciding that the "we're not going to enable 
> interrupts" case allows certain optimizations (like just ACK'ing it 
> immediately and not masking it at the interrupt controller).
> So this is not as simple as your patch. Not even _nearly_.

IDE IRQ handler (& probably many others) assume that IRQ layer won't be
trying to call it again while IRQ is being serviced -- is this going to
change with the introduction of threaded IRQs?

Thanks,
Bart
