Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYJOSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYJOSgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYJOSgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:36:01 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:24652 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751889AbYJOSgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:36:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dD2z2uQJKiMmt8hj8aUhOVQNHE/UhqQCnKAoemSBSv35R2XY5RhVH6gvZPDsyjU+Wna2bRbH7L7HK6NsGKkrvjKp/cwX2oaKHAyhhaFOjAD/0YgP9R3uTnYoia60rD6gI/J07nqyp6zq+FECxhNOH4yIp0zf7afYHU/hhjW2V3Q=  ;
X-YMail-OSG: uL5Pr6gVM1nFn99NJ8FXr_lpL.pAcsshQJAdAWyxEWRsw8tuy1WEf3Kn3znqadrR044thRYAWli_Evtd7PD7yTAXhc6uymfxZ68FCvGJo2K5HVDouxZUd_KVnsX42EpL5IPG
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 05:35:51 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160512.28443.nickpiggin@yahoo.com.au> <1224094753.3316.266.camel@calx>
In-Reply-To: <1224094753.3316.266.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160535.51586.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 05:19, Matt Mackall wrote:
> On Thu, 2008-10-16 at 05:12 +1100, Nick Piggin wrote:
> > On Thursday 16 October 2008 05:03, Linus Torvalds wrote:
> > > On Thu, 16 Oct 2008, Nick Piggin wrote:
> > > > What do you mean by the allocation is stable?
> > >
> > > "all writes done to it before it's exposed".
> > >
> > > > 2. I think it could be easy to assume that the allocated object that
> > > > was initialised with a ctor for us already will have its initializing
> > > > stores ordered when we get it from slab.
> > >
> > > You make tons of assumptions.
> > >
> > > You assume that
> > >  (a) unlocked accesses are the normal case and should be something the
> > >      allocator should prioritize/care about.
> > >  (b) that if you have a ctor, it's the only thing the allocator will
> > > do.
> >
> > Yes, as I said, I do not want to add a branch and/or barrier to the
> > allocator for this. I just want to flag the issue and discuss whether
> > there is anything that can be done about it.
>
> Well the alternative is to have someone really smart investigate all the
> lockless users of ctors and add appropriate barriers. I suspect that's a
> fairly small set and that you're already familiar with most of them.

I thought someone might volunteer me for that job :)

Actually, there are surprisingly huge number of them. What I would be
most comfortable doing, if I was making a kernel to run my life support
system on an SMP powerpc box, would be to spend zero time on all the
drivers and whacky things with ctors and just add smp_wmb() after them
if they are not _totally_ obvious.

There is only one user in mm/. Which I had a quick look at. There might
be other issues with it, but maybe with a bit more locking or an
explicit barrier or two, it will become more obviously correct.

fs/, inode, dentries, seem to be a very big user. I'd _guess_ they should
be OK because the inode and dentry caches are pretty serialised as it is.
I think unless a fs is doing something really crazy, it would be hard for
one CPU to get to a new dentry, say, before it has been locked up and into
the dcache. Casting a quick eye over things wouldn't hurt, though.


> But yes, I think you may be on to a real problem. It might also be worth
> devoting a few neurons to thinking about zeroed allocations.

Hmm, that's a point. The page nor slab allocators don't order those before
we get them either. I might have a sniff around mm/ or so, but no way I
could audit all kzalloc etc. users in the kernel. Maybe that case is a bit
more obvious though, because we're not conceptually thinking about pulling
out an already-set-up-object living happily in ctor land somewhere. We
explicitly say: allocate me something, and zero it out.

It's 5am and I'm rambling at this point. Probably either one is about as
likely to have bugs, and maybe only _very slightly_ more likely to have an
ordering bug than any other kernel code.
