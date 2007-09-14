Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXINLqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXINLqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXINLqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:46:13 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2819 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXINLqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:46:12 -0400
Date: Fri, 14 Sep 2007 13:46:28 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
In-Reply-To: <20070913124738.GA4450@elte.hu>
Message-ID: <Pine.LNX.4.64.0709131851080.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709121405130.1817@scrub.home>
 <20070913124738.GA4450@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Sep 2007, Ingo Molnar wrote:

> > The rest of the math is indeed different - it's simply missing. What 
> > is there is IMO not really adequate. I guess you will see the 
> > differences, once you test a bit more with different nice levels.
> 
> Roman, i disagree strongly. I did test with different nice levels. Here 
> are some hard numbers: the CPU usage table of 40 busy loops started at 
> once, all running at a different nice level, from nice -20 to nice +19:

Ingo, you should have read the rest of the paragraph too, I said "it's 
needed for a good task placement", I didn't say anything about time 
distribution.
Try to start a few niced busy loops and then try some interactivity tests.
You should also increase the granularity, the rather small time slices can
cover up a lot of bad scheduling decisions.

> In the announcement of your "Really Fair Scheduler" patch you used the 
> following very strong statement:
> 
>     " This model is far more accurate than CFS is [...]"
> 
>     http://lkml.org/lkml/2007/8/30/307
> 
> but when i stressed you for actual real-world proof of CFS misbehavior, 

You're forgetting that only a few days before that announcement, the worst 
issues had been fixed, which at that time I hadn't taken into account yet.

> you said:
> 
>     "[...] they have indeed little effect in the short term, [...] "
> 
>     http://lkml.org/lkml/2007/9/2/282
> 
> so how can CFS be "far less accurate" (paraphrased) while it has "little 
> effect in the short term"?
> 
> so to repeat my question: my (and Peter's) claim is that there is no 
> real-world significance of much of the complexity you added to avoid 
> rounding effects. You do disagree with that, so our follow-up question 
> is: what actual real-world significance does it have in your opinion? 
> What is the worst-case effect? Do we even care? We have measured it 
> every which way and it just does not matter. (but we could easily be 
> wrong, so please be specific if you know about something that we 
> overlooked.) Thanks,

Did you read the rest of mail? I said a little bit more than that, which 
actually explains this already in large parts.
(BTW this mail also has one example where I almost begged you to explain 
me some of the CFS features in response to your splitup request - no 
response.)

Accuracy is an important aspect, but it's not really the primary goal. 
As I said I wanted a correct mathematical model of CFS, but due to the 
complexity of CFS (of which a lot has been removed now in CFS-devel) it 
was rather difficult to produce such a model.
Producing an accurate model is meant as a _tool_ for further 
transformations, e.g. to analyze where are further simplifications 
possible, where can the 64bit math be replaced with something simpler 
without reducing scheduling quality significantly.
The added accuracy increases of course the complexity, but compared to the 
already existing complexity it was still less (at least according to the 
lmbench numbers), so IMO it's worth it. The advantage is that I didn't had 
to worry about any effects of unexpected rounding errors. This scheduler 
has to work with a wide range of clock implementations and AFAICT it's 
impossible to guarantee that it work in any situation, it may not 
break down completely, but I couldn't exclude unexplainable anomalities, 
especially after seeing the problems in the early CFS version, which got 
merged.
As I also mentioned this is only part of the problem (but to which early 
CFS version significantly contributed). The main problem were the limits, 
once the limits are exceeded, that overflow/underflow time is simply lost 
and that is what finally resulted in the misbehaviour. The rounding 
problems were one possible cause but not the only one. Other possibilities 
would require more complex scheduling pattern, where de-/enqueuing of 
tasks would push some tasks into these limits. Prime suspect here was the 
sleeper bonus and the question was: is it possible to accumulate the 
bonus, is it possible to force the punishment onto specific tasks.

The complexity of CFS makes it now hard to quantify the problem, it's easy
to say that it will work in most cases, but e.g. the rounding fixes 
changed more the common case but not really the worst case. The point is 
what would cost to be a little more acurate and as proved with my patch 
not much, but in the end we would have a more reliable scheduler, that 
not only works well in the common cases.

Anyway, as I said already earlier, with the step to an absolute virtual 
time the biggest error source is gone, so in a way you also proved my 
point that it's worth it, even if you don't want to admit it.

bye, Roman
