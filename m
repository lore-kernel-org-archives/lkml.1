Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbZFPE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbZFPE5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZFPE5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:57:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZFPE5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:57:05 -0400
Date: Tue, 16 Jun 2009 06:57:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090616045704.GC28596@wotan.suse.de>
References: <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de> <Pine.LNX.4.64.0906151329310.24256@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906151329310.24256@sister.anvils>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:38:12PM +0100, Hugh Dickins wrote:
> On Mon, 15 Jun 2009, Nick Piggin wrote:
> > On Mon, Jun 15, 2009 at 08:45:27PM +1000, Benjamin Herrenschmidt wrote:
> > > On Mon, 2009-06-15 at 12:27 +0200, Nick Piggin wrote:
> > > > Init code doesn't deserve to be more lazy than anybody else, and
> > > > part of the reason why such a core piece of code is so crufty
> > > > is exactly because people have been lazy there.
> > > 
> > > I think the main problem isn't necessarily init code per se, but the
> > > pile of -common- code that can be called both at init time and later.
> > 
> > Just seems bogus argument. Everwhere else that does this (ie.
> > allocations that are called from multiple allocation contexts)
> > passes correct gfp flags down.
> 
> Fair enough that you jealously defend SL?B code from onslaught, but
> FWIW I strongly agree with Ben on all this.  I cannot see the point
> of the pain of moving around SL?B versus bootmem, if we immediately
> force such a distinction (differently dressed) upon their users again.

Well, it is a good idea for other reasons too, not just to
relieve the author of the distinction.

But the distinction now is much smaller. It is not a case of
allocfn()
{
  if (system_state == something crazy)
   alloc_bootmem
  else
   kmalloc
}

freefn()
{
 if (object was kmalloced)
  kfree
}

It is now this:
allocfn(gfp)
{
 kmalloc(gfp)
}

> I fully agree with Ben that it's the job of the allocator to provide
> a service, and part of that job to understand its own limitations at
> different stages of running.

Yes but that's heavily qualified. As I said, we already require
a lot of knowledge of context passed in to it. I have no interest
in adding code to make *early boot* code not have to care about
that, especially because everybody else certainly has to know
whether they are calling the allocator with interrupts disabled
or a lock held etc.

To be clear about this: the allocator is fully servicable and
no different to normal system running at this point. The
difference for example is that code runs with interrupts off
but incorrectly uses GFP_KERNEL for allocations. This is a
blatent bug in any other kernel code, I don't know why boot
code is OK to be horrible and wrong and work around it with
the equally horrible system_state (and this gfp mask which is
just system_state under another name).

I just don't want to use this slab fix in question to be a
license to throw away and forget all about any context information
in the early boot code because someone asserts "it will make the
code better".  I'm fine with the slab change for now, but let's
try to retain context information as well.

If somebody comes up with a patch to remove thousands of lines
of boot code by ignoring context, then I might concede the
point and we could remove the context annotations.

