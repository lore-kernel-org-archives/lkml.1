Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXFTAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXFTAKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 20:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXFTAKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 20:10:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbXFTAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 20:10:06 -0400
Date: Tue, 19 Jun 2007 17:09:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
In-Reply-To: <20070619233716.GA5779@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706191649160.3593@woody.linux-foundation.org>
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
 <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
 <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
 <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
 <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org>
 <20070619233716.GA5779@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Carlo Wood wrote:

> On Mon, Jun 18, 2007 at 03:57:51PM -0700, Linus Torvalds wrote:
> > > I'll redo the bisect with this new git.
> > 
> > Thanks,
> > 		Linus
> 
> Well, I did a new 'git bisect' - and if you ask me - it is still broken.
> 
> It's conclusion was this time:
> 
> hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
> 01da41b86f6e5f9a724e20a63f093d77e37d8056 is first bad commit
> 
>     parisc: make command_line[] static

Heh.

Yeah, at this point I think we can pretty much guarantee that your problem 
is one of two cases:

 - either a bit random, and depends on some timing thing, and one of the 
   kernels you marked "good" wasn't really.

   It's not likely that you marked a good kernel bad, of course, since 
   with a good kernel, everything should have always worked, but with a 
   bad kernel and a bug that isn't entirely reproducible, you'd mark it 
   "good" by mistake - because it just randomly didn't show the problem.

OR

 - we actually have two different commits that introduce the problem for 
   you, and it comes and goes, and the bisection doesn't work, because 
   there isn't a clear "this side works, that other side does not" 
   situation.

For example, later on you say:

> Personally I am convinced that the real problem is with
> 8888985144db8f4cb7e56154b31bdf233d3550bf

but if you look at your commit log, you have:

> # bad: [25971f68d392f1816e21520e9e59648403b0bdad] [PARISC] fix section
> # mismatch in ccio-dma
> git-bisect bad 25971f68d392f1816e21520e9e59648403b0bdad

Notice? You said that 25971f68d392f1816e21520e9e59648403b0bdad was bad, 
but that is *before_ the 8888985144db8f4cb7e56154b31bdf233d3550bf commit. 
Do a

	gitk 25971f68d3..8888985144

to see that part of the history.

So maybe you didn't test that kernel properly? And maybe it really is 
random, and something has happened that just makes it happen more often?

Also, some *really* nasty bugs end up being about bad initialization, and 
it turns out that what happens more is not which kernel you run, but what 
the *previous* kernel you ran is, because it left some device driver state 
that the bug doesn't clean up!

Anyway, can you try that 25971f68d3 kernel one more time? You marked it 
bad, but if that kernel is bad, then the commit you are pointing to is 
*not* the culprit.

			Linus
