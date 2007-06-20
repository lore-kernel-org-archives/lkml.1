Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbXFTNMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbXFTNMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbXFTNM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:12:27 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:41971 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753612AbXFTNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:12:26 -0400
Date: Wed, 20 Jun 2007 15:11:20 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070620131120.GA17615@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com
References: <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <alpine.LFD.0.98.0706191649160.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706191649160.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 05:09:10PM -0700, Linus Torvalds wrote:
> Heh.
> 
> Yeah, at this point I think we can pretty much guarantee that your problem 
> is one of two cases:
> 
>  - either a bit random, and depends on some timing thing, and one of the 
>    kernels you marked "good" wasn't really.

Nope

>    It's not likely that you marked a good kernel bad, of course, since 
>    with a good kernel, everything should have always worked, but with a 
>    bad kernel and a bug that isn't entirely reproducible, you'd mark it 
>    "good" by mistake - because it just randomly didn't show the problem.

Nope

> OR
> 
>  - we actually have two different commits that introduce the problem for 
>    you, and it comes and goes, and the bisection doesn't work, because 
>    there isn't a clear "this side works, that other side does not" 
>    situation.

Yes

Looking a bit closer to the bisect myself, I note that 
25971f68d392f1816e21520e9e59648403b0bdad and
aba297927d1d558c7a94548135133bdf9172708a are part of
a branch that is derived from a very "old" revision.
git bisect assumes that such an old revision is good,
but in fact - that was already bad as well, because
the history of this bug is:

2.6.22-rc5 BAD
2.6.22-rc4+somethingelse BAD
2.6.22-rc4+something GOOD
2.6.22-rc4 BAD
...
2.6.18-rc1 BAD
2.6.18 GOOD

Thus: BAD BAD BAD GOOD GOOD BAD BAD

and git bisect can't handle that, even though I started
with a 'good' start point and a bad start point at the end.

> For example, later on you say:
> 
> > Personally I am convinced that the real problem is with
> > 8888985144db8f4cb7e56154b31bdf233d3550bf
> 
> but if you look at your commit log, you have:
> 
> > # bad: [25971f68d392f1816e21520e9e59648403b0bdad] [PARISC] fix section
> > # mismatch in ccio-dma
> > git-bisect bad 25971f68d392f1816e21520e9e59648403b0bdad
> 
> Notice? You said that 25971f68d392f1816e21520e9e59648403b0bdad was bad, 
> but that is *before_ the 8888985144db8f4cb7e56154b31bdf233d3550bf commit. 
> Do a
> 
> 	gitk 25971f68d3..8888985144
> 
> to see that part of the history.

This part is thus based upon a revision so old that it was bad again,
even before the small period that it was good.

> So maybe you didn't test that kernel properly? And maybe it really is 
> random, and something has happened that just makes it happen more often?

No, it is really 100% reproducible.

-- 
Carlo Wood <carlo@alinoe.com>
