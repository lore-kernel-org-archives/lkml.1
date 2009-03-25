Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZCYQeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZCYQeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZCYQeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:34:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZCYQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:34:05 -0400
Date: Wed, 25 Mar 2009 12:34:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Matt Mackall <mpm@selenic.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hua Zhong <hzhong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
In-Reply-To: <1237997658.2132.193.camel@calx>
Message-ID: <alpine.DEB.2.00.0903251227360.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org>  <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>  <009101c9ad20$1ae231c0$50a69540$@com>  <1237968394.30175.12.camel@penberg-laptop> 
 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>  <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>  <1237993145.30175.34.camel@penberg-laptop>  <alpine.DEB.2.00.0903251103070.5675@gandalf.stny.rr.com>  <alpine.DEB.2.00.0903251105030.5675@gandalf.stny.rr.com>
 <1237997658.2132.193.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Matt Mackall wrote:
> > 
> > I think the theory is that gcc and the CPU can handle normal branch 
> > predictions well. But if you use one of the prediction macros, gcc 
> > (and some archs) behaves differently, such that taking the wrong branch 
> > can cost more than the time saved with all the other correct hits.
> > 
> > Again, I'm not sure. I haven't done the bench marks. Perhaps someone else 
> > is more apt at knowing the details here.
> 
> >From first principles, we can make a reasonable model of branch
> prediction success with a branch cache:
> 
>                hot cache     cold cache  cold cache  cold cache 
>                w|w/o hint                good hint   bad hint
> p near 0       +             +           +           -
> p near .5      0             0           0           0
> p near 1       +             -           +           -
> 
> (this assumes the CPU is biased against branching in the cold cache
> case)
> 
> Branch prediction miss has a penalty measured in some smallish number of
> cycles. So the impact in cycles/sec[1] is (p(miss) * penalty) * (calls /
> sec). Because the branch cache kicks in and hides our unlikely hint with
> a hot cache, we can't get a high calls/sec, so to have much impact,
> we've got to have a very high probably of a missed branch (p near 1)
> _and_ cold cache. 
> 
> So for CPUs with a branch cache, unlikely hints only make sense in
> fairly extreme cases. And I think that includes most CPU families these
> days as it's pretty much required to get much advantage from making the
> CPU clock faster than the memory bus. 
> 
> We'd have a lot of trouble benchmarking this meaningfully as hot caches
> kill the effect. And it would of course depend directly on a given CPU's
> branch cache size and branch miss penalty, numbers that vary from model
> to model. So I think unless we can confidently state that a branch is
> rarely taken, there's very little upside to adding unlikely.
> 
> On the other hand, there's also very little downside until our hint is
> grossly inaccurate. So there's a huge hysteresis here: if p is < .99,
> not much point adding unlikely. If p is > .1, not much point removing
> it.
> 
> [1] Note that cycles/sec is dimensionless as cycles and seconds are both
> measures of time. So impact here is in units of very small fractions of
> a percent.

Hi Matt,

Thanks for this info!

Although gcc plays a role too. That is, if we have

	if (x)
		do something small;

	do something large;


this can be broken into:

	cmp x
	beq 1f
	do something small
1:
	do something large

Which plays nice with the cache. But, by adding a unlikely(x), gcc will 
probably choose to do:

	cmp x
	bne 2f

1:
	do something large

	ret;

2:
	do something small
	b 1b

which hurts in a number of ways.

-- Steve

