Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZFPFUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZFPFUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZFPFUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:20:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:41947 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZFPFUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:20:02 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <20090616044601.GB28596@wotan.suse.de>
References: <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <1245059859.23207.16.camel@penberg-laptop>
	 <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop>
	 <20090615112355.GB6012@wotan.suse.de> <1245101498.12400.37.camel@pasglop>
	 <20090616044601.GB28596@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 15:18:06 +1000
Message-Id: <1245129486.12400.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 06:46 +0200, Nick Piggin wrote:
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

About all of the ones below and more :-) It all depends what you define
by "early" though :-)

> >  - All the vmalloc interfaces (__get_vm_area() and it's 5 or 6 variants)
> >  - Allocation of PCI host bridges data structures in the powerpc code
> >  - Allocation of interrupt controller domains in the powerpc code
> >  - Page table allocations (oops ... can't change that arch specific,
> > would have to be a generic change)
> 
> No it would not. If an arch (eg s390) does this in early boot, then
> it can create its own allocation function which takes a gfp mask, and
> define the generic one to just pass it a GFP_KERNEL. generic code does
> not call this in early boot of course.

Right, which means that ioremap needs a special code path early boot
since it uses this etc...

We are basically adding special-cases in a whole lot of places, which
could -ALL- be removed just by having the allocator do the "right
thing" :-)

> >  - ioremap (which call both __get_vm_area() and page table allocs)
> >  - ...
> > 
> > Are you just insane ? :-)
> 
> I think so, but that's besides the point ;)

Allright, I concede that :-)

Cheers,
Ben.


