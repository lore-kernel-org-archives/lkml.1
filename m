Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYALXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYALXCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 18:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYALXBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 18:01:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55479 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYALXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 18:01:54 -0500
Date: Sat, 12 Jan 2008 15:01:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080112150120.05f93768@laptopd505.fenrus.org>
In-Reply-To: <20080112214911.GA20102@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<20080112094557.71f5382a@laptopd505.fenrus.org>
	<20080112214911.GA20102@jurassic.park.msu.ru>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 00:49:11 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Sat, Jan 12, 2008 at 09:45:57AM -0800, Arjan van de Ven wrote:
> > btw this is my main objection to your patch; it intertwines the
> > conf1 and mmconfig code even more.
> 
> There is nothing wrong with it; please realize that mmconf and conf1
> are just different cpu-side interfaces. Both produce precisely the
> *same* bus cycles as far as the lower 256-byte space is concerned.
> 
> > When (and I'm saying "when" not "if") systems arrive that only have
> > MMCONFIG for some of the devices, we'll have to detangle this again,
> > and I'm really not looking forward to that.
> 
> MMCONFIG for *some* of the devices? This doesn't sound realistic
> from technical point of view.

you're wrong. 

> MMCONFIG-only systems? Sure. I really hope to see these. But it won't
> be PC-AT architecture anymore. It has to be something like alpha,
> for instance, fully utilizing the 64-bit address space, and we'll have
> to have the whole low-level PCI infrastructure completely different
> for these future platforms anyway.
> Right now, each and every x86 chipset *does* require working
> conf1 just in order to set up the mmconf aperture. It's the very
> fundamental thing, sort of design philosophy.

s/x86/pc/

and not even that.

Really this is a huge design mistake in your patch, the hard coding of conf1,
and for that reason I really don't think it should go in.

We have 4 or so methods on PC today to access config space, probably going to 6 in the next year
or two. One of those methods *HARD PICKING* another one as "second best" for cases where it
doesn't want to deal with is WRONG. It really needs to be up to the architecture/platform
to decide which ops vector is the fallback. And yes on your current PC that might well be conf1.
But hardcoding that is not the right thing. We have the vectors, we have the ranking code,
just make a "second rank" thing. 
Oh wait, my patch did that ;)
Then let either the mmconfig code or the wrapper above it (doesn't matter, in fact, I can see
value of making this decision in the wrapper and keep mmconfig code simple and clean,
because maybe mmconfig IS the thing that the architecture says needs to deal with the lower 256 bytes)..

Oh wait my patch also did that pretty much ;)

The rest of my patch was defaulting to off. Is it that bit that you really hate?


