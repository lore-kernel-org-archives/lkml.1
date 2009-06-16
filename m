Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZFPSri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZFPSri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbZFPSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:47:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbZFPSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:47:27 -0400
Date: Tue, 16 Jun 2009 11:45:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <20090616044601.GB28596@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0906161141290.3282@localhost.localdomain>
References: <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
 <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de> <1245101498.12400.37.camel@pasglop> <20090616044601.GB28596@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Nick Piggin wrote:

> On Tue, Jun 16, 2009 at 07:31:38AM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2009-06-15 at 13:23 +0200, Nick Piggin wrote:
> > > > I think the main problem isn't necessarily init code per se, but the
> > > > pile of -common- code that can be called both at init time and
> > > later.
> > > 
> > > Just seems bogus argument. Everwhere else that does this (ie.
> > > allocations that are called from multiple allocation contexts)
> > > passes correct gfp flags down.
> > 
> > So you say we should create new variants of all these APIs that take gfp
> > flags as arguments just because they might be called early during boot :
> 
> No, just create the ones that actually are called in early boot.

No.

Nick, I don't think you've follow the problems.

The thing is, we do end up wanting to do a lot of allocations, and it's 
not even very "early" - we've already initialized all the allocators. It's 
just that WE HAVE NOT ENABLED INTERRUPTS YET!

So the "hack" is to let everybody act as if everything is normal. Which it 
pretty much is. Just use kmalloc/kfree etc, and use _all_ the regular 
functions. Setting up the core layers so that we _can_ enable interrupts 
involves quite a lot of random crud, they should be able to use regular 
code.

And the hack is there because we really are in a magic stage. The memory 
management works, but it just can't do certain things yet. It's not the 
callers that need to be changed, because the callers are usually regular 
routines that work perfectly normally long after boot, and having to add a 
magic "I'm now doign this during early boot" argument to the whole stack 
is just _stupid_, when the stack itself doesn't actually care - only the 
allocators do.

			Linus
