Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYD3W3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYD3W3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934459AbYD3W3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:29:19 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50073 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934449AbYD3W3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:29:17 -0400
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       torvalds@linux-foundation.org
In-Reply-To: <20080427160120.5788118f@laptopd505.fenrus.org>
References: <20080427214837.GA11631@elte.hu>
	 <1209335660.3801.79.camel@localhost.localdomain>
	 <4815009C.2010809@garzik.org>
	 <20080427.154620.177583216.davem@davemloft.net>
	 <20080427160120.5788118f@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 16:44:04 -0500
Message-Id: <1209591844.3774.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-27 at 16:01 -0700, Arjan van de Ven wrote:
> On Sun, 27 Apr 2008 15:46:20 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Jeff Garzik <jeff@garzik.org>
> > Date: Sun, 27 Apr 2008 18:39:24 -0400
> > 
> > > I disagree with this semantics change.  A number of code places
> > > _and drivers_ GET IT RIGHT, and these are all broken now?
> > 
> > [ Note, James's patch that you quoted is about mapping DMA
> >   memory, in dma_declare_coherent_memory(), rather than devices.
> >   But I know what you are trying to talk about Jeff. :-) ]
> > 
> > Wrt. ioremap() semanics, it is important to realize that if
> > the implementation of this on x86 has been giving non-cached
> > I/O mappings out up until recently, you can expect that there
> > are hundreds of drivers that might now be broken.
> 
> it's even worse than that.
> 99% of the time it gave out uncached memory, but if the bios was iffy,
> it would suddenly give out something else.
> 
> The changes to ioremap() recently turned that into "100% uncached".
> For me, that's the right (because safe) behavior, exactly for the
> reason you mentioned: it's what happened in practice, and driver writers
> would assume that to happen.
> 
> Anything except uncached would just be insanity as default.
> (well the old "whatever mood the bios writer was in, usually uncached" is
> effectively uncached except for weird behaving boxes)

OK, but look; this is why you broke me.

The former meaning of ioremap() was give me whatever caching the mtrrs
set up (assuming you actually have mtrrs.  For voyager, we don't so it
always meant give me cached memory).

The change broke the QIC ioremap area because it absolutely *requires*
cached memory.   It drops performance on the Q720 SCSI cards because
caching was used essentially like write combining to reduce the
unbursted traffic across the MCA bus.

When the Voyagers were designed, the only way to get them better
performace with the slow bus technology was to do a massive amount of
caching, so they're optimised to the point where every element on the
voyager bus (sort of like the intel frontside bus) is a primary
participant in the caching algorithm, and this includes the MCA
controllers.  So for me, I want every invocation of ioremap to mean
ioremap_cached() otherwise I don't benefit from the added caches.

I can fully understand that bus technology has got worse in terms of
caching since the voyager heydays.  However, I'd rather not be penalised
for everyone else's hardware failings.  Since the old ioremap is only
used in the IORESOURCE_CACHABLE case for PCI, and since that used to
defer to the mtrr settings anyway, it probably does make sense to keep
it as ioremap_cache() as long as that still defers to the mtrr settings.

I suppose I could think about an ioremap platform override for voyager
since, by and large, ioremap_nocache() is the wrong thing on the
platform.

James


