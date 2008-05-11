Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYEKWNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYEKWNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYEKWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:13:27 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51016 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbYEKWN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:13:26 -0400
Date: Mon, 12 May 2008 01:11:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511221158.GN1645@cs181133002.pp.htv.fi>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi> <20080511194248.GA514@uranus.ravnborg.org> <20080511200016.GH1645@cs181133002.pp.htv.fi> <20080511203827.GA850@uranus.ravnborg.org> <20080511211902.GI1645@cs181133002.pp.htv.fi> <20080511214428.GA1782@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080511214428.GA1782@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 11:44:28PM +0200, Sam Ravnborg wrote:
> On Mon, May 12, 2008 at 12:19:02AM +0300, Adrian Bunk wrote:
> > On Sun, May 11, 2008 at 10:38:27PM +0200, Sam Ravnborg wrote:
> > > > > 
> > > > > You continue to fail to acknowledge that it is valueable information
> > > > > that we pass gcc a _hint_ that it is a good idea to inline certain
> > > > > functions.
> > > > > 
> > > > > The inline hint is there to tell gcc that it shall inline this function
> > > > > in cases where it usual think it should not do so. Which invietably
> > > > > will result in a larger codesize in some cases.
> > > > 
> > > > We also give gcc an explicit "Optimize for size.".
> > > 
> > > gcc was asked to optimize for size in general as per the commandline option.
> > > But on a much more fine grained level gcc is given a hint that
> > > this function would be a good idea to inline.
> > > 
> > > And I really expect gcc to pay most attention to the more specific
> > > information provided for a single function than a general commandline option.
> > 
> > Can you try to get from expectations back to reality?
> 
> What I wrote is based on common sense.
>...

My common sense would be that -Os beats "inline".

But we are in an area where "common sense" doesn't help if we rely on 
some specific behaviour.

> > gcc 4.3 even ignores the unlikely() hint in timespec_add_ns()
> > (we now have a workaround for this in the kernel).
> I do not follow the logic here.
> Gcc may fail in a few cases to do what we expect but that
> is far from that we shall assume that it always fails.

My logic is simple:

If you rely on a hint that assumption can break.

It happened (wrongly) for unlikely(), and is even more possible in cases 
where you tell gcc to do conflicting things.

> > >...
> > > > All the "optimized inlining" does is to allow gcc to no longer inline 
> > > > functions marked as "inline" if it prefers not to do so.
> > > The "optimized inlining" allows gcc (if gcc > 4.0) to make an educated
> > > guess if it is worhtwhile to inline a function or not. And when deciding
> > > to do so or not gcc may include many different factors inlcuding
> > > but not limited to -s.
> > > And this is certainly optimized compared to the situation where
> > > inline equals to always_inline.
> > > Keep in mind that we often perfer to have _less_ inlining than we have
> > > today for debugging ease. And this is what we get with optimized inlining
> > > compared to farced inlining.
> > > 
> > > > 
> > > > And what exactly is your problem with my patch if you consider the 
> > > > general "optimized inlining" approach correct?
> > > 
> > > I've already listed two things:
> > > -> It is no longer a simple kconfig change to try with or without.
> > > -> It is independent on gcc version
> > 
> > I already asked you previously in this thread:
> 
> And you fail to comment why both points are not worth considering.
> 
> > 
> > Do we have any hard data that gcc < 4.0 has a "broken inline algorithm" 
> > and all gcc versions >= 4.0 have a "working inline algorithm"?
> 
> Is it hard data for you that Linus says that gcc < 4.0 is "broken"
> so yes. Search the archives.
> 
> If you expect me to show you a lot of disassembly then no.

Can you give me a pointer where someone showed that regarding inlining
gcc 3.4 is worse than gcc 4.0?

AFAIR this 4.0 border was only a guessed border and noone knows what 
happens with gcc 4.0.

Actually, the "optimized inlining" was only justified with code size, 
and I don't remember anyone checking whether it affects the performance
at all.

> > > And for fast path code like sched.c I would much assume a proper analysis
> > > when it is acceptable to remove the inline hint is almost mandatory.
> > >...
> > 
> > Why didn't you request a proper analysis before the "optimized inlining" 
> > stuff hit Linus' tree?
> Adrian - stop this bullshit.
> We are discussing _your_ patch. Not some other patch that you
> seems to have some hard feelings about. And yes I saw the reference
> in the initial patch which I saw no reason to comment on as this
> was purely bullshit then and still is so.

All my patch does is to highlight a problem with the "optimized inlining" 
approach I already mentioned some time ago.

We have many fast paths in different subsystems, and if you require a
"proper analysis" for a patch touching only one piece of code you should 
require the same if this "optimized inlining" stuff resurfaces for
2.6.27 or 2.6.28 that does similar stuff globally (you'll then have a 
patch that removes the BROKEN you shouldn't treat more gently than you 
treated my patch).

> Was the purpose of this patch just a provocation then?
> If so - then I just lost 50% of my Linux time tonight on it!

Provocation is the only way of communication that works on this list.

I've learned the lesson that being friendly brings you nothing here.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

