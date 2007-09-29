Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXI2NT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXI2NT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 09:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbXI2NTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 09:19:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:36203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbXI2NTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 09:19:50 -0400
Date: Sat, 29 Sep 2007 15:19:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070929131949.GE14159@wotan.suse.de>
References: <20070928154832.GB12538@wotan.suse.de> <20070928170719.2f617a7a@the-village.bc.nu> <20070928165425.GA7366@wotan.suse.de> <20070928181831.26f34a64@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928181831.26f34a64@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 06:18:31PM +0100, Alan Cox wrote:
> > on the broken ppro stores config option if you just tell me what should
> > be there (again, remember that my patch isn't actually changing anything
> > already there except for smp_rmb side).
> 
> The PPro needs rmb to ensure a store doesn't go for a walk on the wild
> side and pass the read especially when we are dealing with device space.

smp_rmb (ie. the non device space version) needs to order stores too?
OK, that's definitely something we'll need a locked op for. I can't see how
it could possibly close all holes, though: the level at which memory ordering
dependencies operate in lockless code is way above what the hardware can
know about.

For any 2 given code sequences
store 1 -> X
store 2 -> Y
and
load Y
load X

There may be a requirement to have wmb and rmb respectively for
correctness, or it may be perfectly correct without ordering. Unless the
issue is *purely* that store and/or loads can erroneously execute out
of order, then adding magic to barrier primitives cannot fix all cases
(and the errata certainly looked spookier than simply out of order
problems).


> The rest of the stuff is a little vague which makes me nervous when
> considering relaxing the PPro case for smp_rmb. With smp_rmb as it is at
> the moment the PPro is effectively treated as an out of order cpu and so
> shouldn't hit anything occassionally that a PPC wouldn't hit every time.

Well, it's all a little vague to me ;) (maybe you were privy to info that you
aren't allowed to talk about...). IIRC the errata I could find, mentioned
concurrent stores to a single variable as being problematic, and nothing
about memory ordering, or loads, at all.

One difference with a normal weakly ordered machine, is that the normal
one wouldn't require rmb to order loads vs stores, for example.

Anyway, after all that blowing of smoke (I'm just genuinely curious), I have
no problems with any fixups for ppro and defer to your greater understanding
of the issues. However, all that can go under the config variable we have
for that purpose. Let me know what you need? Is it just a matter of putting
the dummy lock'ed op back in smp_rmb? You sure you don't also need
smp_wmb to order stores? I can cook up a patch to do either.


> > > - and for modern processors its still not remotely clear your patch is
> > > correct because of NT stores.
> > 
> > No. We already _have_ to rely on this model for barriers 
> 
> Well Linus has dealt with the question of NT stores for us now...

He actually didn't, quite ;) (see other post)


> Given this isn't an issue on 64bit I'm inclined to argue that only 64bit
> behaviour should be changed at this point.

That's the easy way out, but I think it creates more problems down the
line. It diverges the code base and testing base. I think it is pretty simple
(and serves as good documentation) to extend the use of the ppro ifdef
to do what we need here, rather than implicitly rely on the barriers being
stronger than required for non-broken implementations.

