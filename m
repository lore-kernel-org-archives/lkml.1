Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXI1Qyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXI1Qyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXI1Qy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:54:28 -0400
Received: from mx1.suse.de ([195.135.220.2]:37133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbXI1Qy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:54:27 -0400
Date: Fri, 28 Sep 2007 18:54:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070928165425.GA7366@wotan.suse.de>
References: <20070928154832.GB12538@wotan.suse.de> <20070928170719.2f617a7a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928170719.2f617a7a@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 05:07:19PM +0100, Alan Cox wrote:
> > The only alternative is to assume a weak memory model, and add the required
> > barriers to spin_unlock -- something that has been explicitly avoided, but
> 
> We have the barriers in spin_unlock already for Pentium Pro and IDT
> Winchip systems. The Winchip explicitly supports out of order store (and
> was about 10-20% faster with it set this way), the PPro has some annoying
> little store ordering bugs which is why we xchgb out of spin_unlock in
> those cases.

And we still have the correct smp_wmb barrier for OOOSTORE systems. And
we never did any smp_wmb tricks for broken ppros in barrier code.

IOW, my patch is a complete noop for both (it changes smp_rmb to be a
noop, of course, but AFAIKS that shouldn't be relevant for either
problem -- and if it was, then you need to add special ifdefs for
them rather than make everyone else eat proverbial shit, like we do
for spin_unlock).



> > The complaint that broken old ppros get more broken seems to be bogus as wel
l:
> > wmb on i386 never catered to the old ppro to start with. The errata seem to
>
> There are only a couple of awkward cases with the PPro and we carefully
> work around them. The other half of the work is the flush_write_buffers.

Note that for IO, rmb/wmb/mb remain as they are.


> > Buggy ppros: I have no interest in, given the vague errata and apparently
> > unfixable problems with lockless code; anybody is welcome to try adding
> > whatever they like to help them work, but again please don't confuse that
> > with having anything to do with this patch...
>
> PPro was fixed, made to work and brutally tested on quad PPro. There are
> cases that wouldn't work (PPro + AGP which never happens) and there are
> cases that need specific handling (PPro + Voodoo card and some other 3D
> bits) which are handled currently in the X server. The rest is fine.

Aside from the fact that we currently don't do anything for ppro in
smp_wmb *anyway*, I really don't think adding stuff there can fix it:
you can fix critical sections, because you can be sure that all stores
to the same memory regions are strictly fenced inside the locks, except
for the ops on the locks themselves. For those stores, you obviously can
work around the problems by using lock ops.

However, for lockless code, it is entirely possible to do conflicting
unlocked stores to the same location. Memory barriers are never going to
stop this, because they do not provide any synchronisation. They may make
some things less likely or some actual patterns effectively safe...

Anyway, I'm not arguing against adding "stuff" here for it. I repeat:
that isn't concerned with this patch.


> > Winchip: can any of these CPUs with ooostores do SMP? If not, then smp_wmb
> > can also be a simple barrier on i386 too.
> 
> The IDT Winchip can do SMP apparently. Nobody has ever seen an SMP
> winchip board so I don't think it matters and even if one existed we
> wouldn't support it anyway

OK, so in theory we could make smp_wmb just a simple barrier, however the
code for ooostore there is under a config option, so there is no harm in
keeping it around really.


> However 
> - You've not shown the patch has any performance gain

Can I theorise that it will reduce icache misses and be done with? ;)


> - You've probably broken Pentium Pro

Doubt it. It would be really interesting to have an _exact_ trace of
how it breaks that isn't fundamentally broken already. I suspect that
information will never come out of intel. But again, if you think we
need some stronger stuff in smp_wmb, I can do a patch that depends
on the broken ppro stores config option if you just tell me what should
be there (again, remember that my patch isn't actually changing anything
already there except for smp_rmb side).


> - and for modern processors its still not remotely clear your patch is
> correct because of NT stores.

No. We already _have_ to rely on this model for barriers because we
have a lock-less spin_unlock. We can either: put explicit mfences around
all stores that aren't executed inorder WRT other stores; or make
spin_unlock use the lock prefix.

We have pretty explicitly decided to do the former, and the fact that
subsequent patches to implement these exotic stores have broken the
memory ordering model does in no way invalidate this patch, IMO.


> 
> So NAK

Thanks :) Very nice feedback (I wasn't having a gentle dig at you,
honest!)

