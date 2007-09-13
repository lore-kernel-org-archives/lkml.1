Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbXIMQtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbXIMQtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXIMQto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:49:44 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1652 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXIMQtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:49:43 -0400
Date: Thu, 13 Sep 2007 18:50:12 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
In-Reply-To: <20070913142842.GA26016@elte.hu>
Message-ID: <Pine.LNX.4.64.0709131706100.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709120242040.1817@scrub.home>
 <20070913075258.GA9173@elte.hu> <Pine.LNX.4.64.0709131419170.1817@scrub.home>
 <20070913142842.GA26016@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Sep 2007, Ingo Molnar wrote:

> > Then you had the time to reimplement the very things you've just asked 
> > me about and what do I get credit for - "two cleanups from RFS".
> 
> i'm sorry to say this, but you must be reading some other email list and 
> a different git tree than what i am reading.
> 
> Firstly, about communications - in the past 3 months i've written you 40 
> emails regarding CFS - and that's more emails than my wife (or any 
> member of my family) got in that timeframe :-( I just ran a quick 
> script: i sent more CFS related emails to you than to any other person 
> on this planet. I bent backwards trying to somehow get you to cooperate 
> with us (and i still havent given up on that!) - instead of you 
> disparaging CFS and me frequently :-(
> 
> Secondly, i prominently credited you as early as in the second sentence 
> of our announcement:
> 
>  | fresh back from the Kernel Summit, Peter Zijlstra and me are pleased 
>  | to announce the latest iteration of the CFS scheduler development 
>  | tree. Our main focus has been on simplifications and performance - 
>  | and as part of that we've also picked up some ideas from Roman 
>  | Zippel's 'Really Fair Scheduler' patch as well and integrated them 
>  | into CFS. We'd like to ask people go give these patches a good 
>  | workout, especially with an eye on any interactivity regressions.
> 
>    http://lkml.org/lkml/2007/9/11/395
> 
> And you are duly credited in 3 patches:

This needs a little perspective, as I couldn't clone the repository (and 
you know that), all I had was this announcement, so using the patch 
descriptions now as defense is unfair by you.
In this announcement you make relatively few references how this relates 
to my work. Maybe someone else can show me how to read that announcement 
differently, but IMO the casual reader is likely to get the impression, 
that you only picked some minor cleanups from my patch, but it's rather 
unclear that you already reimplemented key aspects of my patch. Don't 
blame me for your own ambiguity.

>    ------------------->
> 
>    Subject: sched: introduce se->vruntime
> 
>    introduce se->vruntime as a sum of weighted delta-exec's, and use 
>    that as the key into the tree.
> 
>    the idea to use absolute virtual time as the basic metric of 
>    scheduling has been first raised by William Lee Irwin, advanced by 
>    Tong Li and first prototyped by Roman Zippel in the "Really Fair 
>    Scheduler" (RFS) patchset.
> 
>    also see:
> 
>       http://lkml.org/lkml/2007/9/2/76
> 
>    for a simpler variant of this patch.

Let's compare this to the relevant part of the announcement:

| The ->vruntime metric is similar to the ->time_norm metric used by
| Roman's patch (and both are losely related to the already existing
| sum_exec_runtime metric in CFS), it's in essence the sum of CPU time
| executed by a task, in nanoseconds - weighted up or down by their nice
| level (or kept the same on the default nice 0 level). Besides this basic
| metric our implementation and math differs from RFS.

In the patch you are more explicit about the virtual time aspect, in the 
announcement you're less clear that it's all based on the same idea and 
somehow it's important to stress the point that "implementation and math 
differs", which is not untrue, but your forget to mention that the 
differences are rather small.

> You never directly replied to these pretty explicit requests, all you 
> did was this side remark 5 days later in one of your patch 
> announcements:

This is ridiculous, I asked you multiple times to explain to me some of 
the differences relative to CFS as response to the splitup requests. Not 
once did you react, you didn't even ask what I'd like to know 
specifically.

> 
>    " For a split version I'm still waiting for some more explanation
>      about the CFS tuning parameter. "
> 
>      http://lkml.org/lkml/2007/9/7/87
> 
> You are an experienced kernel hacker. How you can credibly claim that 
> while you were capable of writing a new scheduler along with a series of 
> 25 complex mathematical equations that few if any lkml readers are able 
> to understand (and which scheduler came in one intermixed patch that 
> added no new comments at all!), and that you are able to maintain the 
> m68k Linux architecture code, but that at the same time some supposed 
> missing explanation from _me_ makes you magically incapable to split up 
> _your own fine code_? This is really beyond me.

I never claimed to understand every detail of CFS, I can _guess_ what 
_might_ have been intended, but from that it's impossible to know for 
certain how important they are. Let's take this patch fragment:

-       /*
-        * Fix up delta_fair with the effect of us running
-        * during the whole sleep period:
-        */
-       if (sched_feat(SLEEPER_AVG))
-               delta_fair = div64_likely32((u64)delta_fair * load,
-                                               load + se->load.weight);
-
-       delta_fair = calc_weighted(delta_fair, se);


You simply remove this logic, without ever explaining what it was really 
good for. There is no indication how it has been replaced. AFAICT the 
comment refers to the calc_weighted() call, which is not the problem.
I can _guess_ that it was meant to scale the bonus based on cpu load, what 
I can't guess from this is why this logic was added in first place, _why_ 
it was neccessary.

It had been easy for me to simply remove this as well, but I had preferred 
to _know_ what the motivation for this logic was, so I can take it into 
account in my patch.

bye, Roman
