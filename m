Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbYBSWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbYBSWZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYBSWZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:25:24 -0500
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.201.235]:33987 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754919AbYBSWZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:25:23 -0500
X-Yahoo-Newman-Id: 769326.8221.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=azyNZOemEuAbIhbSoXjWtzuXTfoYiI2hT3CbjyVI2ZxDXbnqOTszp/4BKprcnzGf0u/03rKUN0SK0KzYvTkOf1H1h3YvGc45nhebbSGmc1oCyW0DL3rnb0iMBJVauFcSR/YKsyd2YLKVC9LJ0PF4JmZ1hlmPWfuQs1fGnP3Olbg=  ;
X-YMail-OSG: zkucX6IVM1mcqrPqaGDjU0snkO0iF4mcEDEv.yW_yDrbzjoIVlG.xIJc4FHExBU36sr6OuYmQg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Date: Wed, 20 Feb 2008 09:25:12 +1100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Willy Tarreau <w@1wt.eu>,
       Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
References: <47B70A61.9030306@tiscali.nl> <200802192046.46955.nickpiggin@yahoo.com.au> <20080219095702.GA6940@one.firstfloor.org>
In-Reply-To: <20080219095702.GA6940@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200925.13366.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 20:57, Andi Kleen wrote:
> On Tue, Feb 19, 2008 at 08:46:46PM +1100, Nick Piggin wrote:

> > I think it was just a simple context switch benchmark, but not lmbench
> > (which I found to be a bit too variable). But it was a long time ago...
>
> Do you still have it?
>
> I thought about writing my own but ended up being too lazy for that @)

Had a quick look but couldn't find it. It was just two threads running
and switching to each other with a couple of mutexes or yield. If I
find it, then I'll send it over.


> > > > Actually one thing I don't like about gcc is that I think it still
> > > > emits cmovs for likely/unlikely branches,
> > >
> > > That's -Os.
> >
> > And -O2 and -O3, on the gccs that I'm using, AFAIKS.
>
> Well if it still happens on gcc 4.2 with P4 tuning you should
> perhaps open a gcc PR. They tend to ignore these bugs mostly in
> my experience, but sometimes they act on them.

I'm not sure about P4 tuning... But even IMO it should not on
predictable branches too much for any (especially OOOE) CPU.


> > > > which is silly (the gcc developers
> > >
> > > It depends on the CPU. e.g. on K8 and P6 using CMOV if possible
> > > makes sense. P4 doesn't like it though.
> >
> > If the branch is completely predictable (eg. annotated), then I
> > think branches should be used anyway. Even on well predicted
> > branches, cmov is similar speed on microbenchmarks, but it will
> > increase data hazards I think, so it will probably be worse for
> > some real world situations.
>
> At least the respective optimization manuals say they should be used.
> I presume they only made this recommendation after some extensive
> benchmarking.

What I have seen is that they tell you definitely not to use it for
predictable branches. Eg. the Intel optimization manual says

 Use the setcc and cmov instructions to eliminate unpredictable
 conditional branches where possible. Do not do this for predictable
 branches. Do not use these instructions to eliminate all
 unpredictable conditional branches, because using these instructions
 will incur execution overhead due to executing both paths of a
 conditional branch. In addition, converting conditional branches to
 cmovs or setcc trades control-flow dependence for data dependence
 and restricts the capability of the out-of-order engine.


> > But a likely branch will be _strongly_ predicted to be taken,
> > wheras a lot of the gcc heuristics simply have slightly more or
> > slightly less probability. So it's not just a question of which
> > way is more likely, but also _how_ likely it is to go that way.
>
> Yes, but a lot of the heuristics are pretty strong (>80%) and gcc will
> act on them unless it has a very strong contra cue. And that should
> normally not be the case.

True, but if you know a branch is 99%+, then use of likely/unlikely
can still be a good idea. 80% may not be enough to choose a branch
over a cmov for example.

