Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZDGNQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZDGNQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbZDGNQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:16:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbZDGNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:16:11 -0400
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407125726.GA31372@elte.hu>
References: <1239083045.22733.383.camel@macbook.infradead.org>
	 <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu>
	 <1239084280.22733.404.camel@macbook.infradead.org>
	 <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>
	 <20090407090229.GA2467@elte.hu>
	 <1239104035.22733.443.camel@macbook.infradead.org>
	 <20090407121457.GC11641@elte.hu>
	 <1239108263.22733.492.camel@macbook.infradead.org>
	 <20090407125726.GA31372@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Apr 2009 06:14:45 -0700
Message-Id: <1239110085.22733.504.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 14:57 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Tue, 2009-04-07 at 14:14 +0200, Ingo Molnar wrote:
> > > Well, i consider it a feature that it flags weird if (x, y) 
> > > constructs: and yes, these iterators you introduced, while they are 
> > > legit C, definitely count as 'weird'. If regular code was doing it, 
> > > not a loop abstraction, i'd call it non-obvious and borderline 
> > > broken straight away.
> > > 
> > > We should _never ever_ put comma statements into if () 
> > > constructs without a _really_ good reason - and if yes, we can 
> > > flag that we know what we are doing, via extra parentheses.
> > 
> > I disagree. I don't think we should be declaring valid C syntax as 
> > 'off limits', however rare it is.
> >
> > _Especially_ if it only actually fails with a fairly esoteric 
> > config option set. That's just asking for build breakage.
> 
> It failed within 10 minutes of testing for me. And i did not say 
> 'off limits', i said 'needs a second look and a i-know-what-i-am 
> doing flag'.
> 
> Anyway, we apparently disagree about what constitutes acceptable 
> code and what not. I am more cautious about "weird looking" 
> constructs, and for a good reason: often a 'hm, this looks a bit 
> weird' sub-conscious feeling is the only sign we have of a serious 
> bug in the making.
> 
> So making code not look weird and teaching people to not use weird 
> looking patterns in usual code is a prime goal - at least to me. 
> 
> Does such an approach limit the C language? Yes, of course it does, 
> that's the whole point. You appear to be more of the "if it's valid 
> C it's fine" camp.

Well... "it's fine" implies a judgement call about its acceptability.
I'd certainly go for "if it's valid C, then it should _work_".

But failing that, I'll go for "if it's valid C and you want to make it
fail, then at least make it fail _consistently_ and give a coherent
error".

> > > and if yes, we can flag that we know what we are doing, via 
> > > extra parentheses.
> > 
> > That's hardly much of a barrier. The requirement to sprinkle 
> > gratuitous-looking extra parentheses around the place really isn't 
> > going to give us much of a _benefit_ in return for the build 
> > breakage.
> 
> The thing is, the branch-tracer might be even more weird than your 
> iterator (it certainly is, and we might even remove it if it's 
> causing undue problems), but it has been upstream for some time 
> already and it is certainly useful for certain types of 
> difficult-to-analyze codepaths.

I wouldn't suggest removing the branch-tracer. Just fixing it.

> Also, it is not breaking the build currently [with any given 
> combination of weird .config combos] - so there's no 'sprinking' 
> anywhere except your arguably under-tested iterator ;-)

It was lightly tested because it was obviously correct™. 

For some weird reason I thought I was programming in C -- and it was a
trivial change to simplify the previous iterators which made me want to
poke my eyes out.

To be honest, it doesn't matter much -- it's such an unusual construct
that it's unlikely to come up again. So it doesn't _really_ matter if we
take the fix that I believe to be more correct, or the one I believe to
be a crappy workaround.

But I would ask that if you we do the latter, you make it fail in _all_
cases, not just with CONFIG_PROFILE_ALL_BRANCHES.

Making valid C code fall over, but _only_ when a certain esoteric config
option is set, is a _really_ bad idea.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

