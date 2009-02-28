Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZB1Iab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZB1Iab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZB1IaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:30:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38041 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZB1IaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:30:21 -0500
Date: Sat, 28 Feb 2009 09:29:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228082922.GB11425@elte.hu>
References: <20090224020304.GA4496@google.com> <20090225072503.GD21903@elte.hu> <alpine.LFD.2.00.0902250753030.3111@localhost.localdomain> <200902272305.01867.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902272305.01867.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Thursday 26 February 2009 03:04:22 Linus Torvalds wrote:
> > On Wed, 25 Feb 2009, Ingo Molnar wrote:
> > > The main artifact would be the unaligned edges around a bigger
> > > write. In particular the tail portion of a big write will be
> > > cached.
> >
> > .. but I don't really agree that this is a problem.
> >
> > Sure, it's "wrong", but does it actually matter? No. Is it worth adding
> > complexity to existing interfaces for? I think not.
> >
> > In general, I think that software should not mess with nontemporal stores.
> > The thing is, software almost never knows enough about the CPU cache to
> > make an intelligent choice.
> >
> > So I didn't want to apply the nocache patches in the first place, but the
> > performance numbers were pretty clear. I'll take "real numbers" over my
> > personal dislikes any day. But now we have real numbers going the other
> > way for small writes, and a patch to fix that.
> >
> > But we have no amount of real numbers for the edge cases, and I don't
> > think they matter. In fact, I don't think they _can_ matter, because it is
> > inevitably always going to be an issue of "which CPU and which memory
> > subsystem".
> >
> > In other words, there is no "right" answer. There is no "perfect". But
> > there is "we can fix the real numbers".
> 
> Well... these are "real" benchmark numbers. Where the benchmark is
> actually apparently performing an access pattern that seemingly
> should favour nontemporal stores (the numbers are just measuring the
> phase were write(2) is being done).
> 
> 
> > At the same time, we also do know:
> >  - caches work
> >  - CPU designers will continue to worry about the normal (cached) case,
> >    and will do reasonable things with cache replacement.
> >  - ergo: w should always consider the cached case to be the _normal_ mode,
> >    and it's the nontempral loads/stores that need to explain themselves.
> >
> > So I do think we should just apply the simple patch. Not make a big deal
> > out of it. We have numbers. We use cached memory copies for everything
> > else. It's always "safe".
> >
> > And we pretty much know that the only time we will ever really care about
> > the nontemporal case is with big writes - where the "edge effects"
> > essentially become total noise.
> 
> I guess so. I wouldn't mind just doing cached stores all the 
> time for the reasons you say.
> 
> But whatever. If it ever becomes *really* important, I guess 
> we can flag this kind of behaviour from userspace.

Important question: is there a standing NAK for the 'total' 
parameter addition patch i did? You requested it and Linus didnt 
like it ... and i've measured it and it's just a single 
instruction in the whole kernel so it did not seem to be too bad 
to me.

It might be wrong on the principle though, so will revert it if 
needed, before it spreads into too many topics.

	Ingo
