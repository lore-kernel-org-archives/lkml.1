Return-Path: <linux-kernel-owner+w=401wt.eu-S965927AbXIKG55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbXIKG55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbXIKG5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:57:48 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39603 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759820AbXIKG5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:57:47 -0400
Date: Tue, 11 Sep 2007 15:57:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/2] Maple Bus support for SEGA Dreamcast
Message-ID: <20070911065736.GA19095@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
	Arjan van de Ven <arjan@infradead.org>
References: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com> <20070911042716.GA18367@linux-sh.org> <1189492766.6129.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189492766.6129.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 07:39:26AM +0100, Adrian McMenamin wrote:
> On Tue, 2007-09-11 at 13:27 +0900, Paul Mundt wrote:
> > I don't believe the 'or any later version' thing was intended by any of
> > the original authors, this should probably be dropped. The original file
> > lacked explicit terms, so the default behaviour there is to fall back to
> > what the top-level COPYING says, which has the 'or any later version'
> > garbage removed.
> 
> On 30th of August you wrote this in an email to the linuxsh list:
> 
> "Both Marcus and I intended all of our code to be v2 only, so that
> should probably be statically defined here. However, I believe
> Yaegashi-san wrote a lot of this initial version, and I'm sure there
> were others that hacked on it as well. So we may simply have to leave it
> as GPLv2 with the unfortunate + any later version garbage."
> 
> I think you were right the first time.
> 
I also wrote in the same mail that the history of that could be verified
in the old CVS tree, after which it was obvious that there was nothing
explicitly stated that would contradict the terms of the top-level COPYING.

The + any later version stuff was never mentioned in any version of the
file dating back to 2.4.3 when it was first added in the CVS tree. Given
that, I don't see any reason why we should be adding it now.

> > > +static DEFINE_MUTEX(maple_list_lock);
> > > +
> > > +DEFINE_MUTEX(maple_dma_lock);
> > > +EXPORT_SYMBOL_GPL(maple_dma_lock);
> > > +
> > It would be better to have accessors for this rather than exporting the
> > mutex globally.
> 
> Actually the mutex is accessed in the aica code so it, or any wrappers
> need to be exported
> 
Exporting accessors for use in the driver code is fine, exporting a
global lock is rather more ugly.

> > > +/* use init call to ensure bus is registered ahead of devices */
> > > +fs_initcall(maple_bus_init);
> > 
> > Please use subsys_initcall() or something like that, this isn't a file
> > system. The comment is also pointless, it's obvious what the initcall is
> > for if you use the proper one.
> > 
> 
> Except performance of the driver is very poor when I use subsys_initcall
> - detecting devices on a phase-of-the-noon related basis. Not an issue
> when I use the later call.
> 
I don't know if I buy that argument, but as you're going to be more or
less the only user of this bus, I can live with that. At least update
your comment so it has some relevance.

> > > +void maple_setup_port_rescan(struct maple_device *mdev);
> > > +
> > > +void maplebus_init_hardware(void);
> > > +
> > Why would these ever be accessible to drivers?
> > 
> You are right about the rescan - a relic of an earlier iteration but the
> maplebus_init_hardware is used to control the DMA in the aica code

What exactly is the AICA trying to do to the maple bus? G2
synchronization is one thing, but that's very different from
reinitializing the bus.

While Sega's hardware may be whimsical, a sound driver should never be
reinitializing an input bus.. that's just too bogus for words, sorry.
