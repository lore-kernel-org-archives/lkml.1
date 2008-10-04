Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYJDTvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYJDTvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYJDTv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:51:28 -0400
Received: from server.drzeus.cx ([85.8.24.28]:34330 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751724AbYJDTv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:51:28 -0400
Date: Sat, 4 Oct 2008 21:51:22 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: RFC: Driver for CB710/720 memory card reader (MMC part) - v2
Message-ID: <20081004215122.0626cd7b@mjolnir.drzeus.cx>
In-Reply-To: <20080925062924.GA32105@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl>
	<20080909091800.37eccc0f@mjolnir.drzeus.cx>
	<20080909090613.GA22158@rere.qmqm.pl>
	<20080911201307.GA31730@rere.qmqm.pl>
	<20080912234302.GA19230@rere.qmqm.pl>
	<20080920130006.69d50cbb@mjolnir.drzeus.cx>
	<20080925062924.GA32105@rere.qmqm.pl>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 08:29:24 +0200
Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:

> 
> This should be almost ready. mmc-test passes up to a point where it
> tries non-sector-size writes to the card - I didn't have time to look
> into this further, yet.
> 

If you can't figure it out, just make sure the driver fails the
requests with -EINVAL.

> > > +/* sg-to-PIO buffer */
> [and its API]
> > Why this complex system? Can't you use the handlers the kernel already
> > provides? You also get a lot of special handling with those, e.g.
> > highmem.
> 
> I looked at linux/lib/scatterlist.c and found nothing really useful. If
> there were some preconditions always met for scatterlists - like that block
> does not span multiple pages, or at least 16-byte block don't, then most
> of this code can go away. It looks complicated, because it implements
> a special iterator interface that always returns multiple-of-16-byte blocks
> for reading or writing. This makes the PIO loops very simple and fast
> (the bounce_buffer case was never triggered by mmc-block in my tests).
> 

The buffers leave no alignment guarantees unfortunately. 

Have a look at the current sdhci.c PIO routines though. It uses the sg
iterator helpers and keeps track of four byte chunks (as opposed to the
16 byte ones you need).

> > > +static void cb710_mmc_enable_irq(struct cb710_chip *chip, int enable)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&chip->irq_lock, flags);
> > > +	__cb710_mmc_enable_irq(chip, enable);
> > > +	spin_unlock_irqrestore(&chip->irq_lock, flags);
> > > +}
> > This is a fairly useless wrapper. Look over how it is called instead.
> 
> Can you expand on this? Right now irq handler doesn't call
> __cb710_mmc_enable_irq() but modifies registers itself. This will
> change eventually.
> 

Just require that the lock must be held by the caller when invoking
cb710_mmc_enable_irq(). It's usually easier to keep track of locks by
keeping the lock handling at entry points into the driver.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
