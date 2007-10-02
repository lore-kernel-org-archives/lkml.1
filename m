Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbXJBG0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbXJBG0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXJBG0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:26:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXJBG0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:26:33 -0400
Date: Tue, 2 Oct 2007 08:26:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071002062626.GC18588@elte.hu>
References: <20071001173159.GB2492@elte.hu> <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1717]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Schwartz <davids@webmaster.com> wrote:

> > at a quick glance this seems broken too - but if you show the 
> > specific code i might be able to point out the breakage in detail. 
> > (One underlying problem here appears to be fairness: a quick 
> > unlock/lock sequence may starve out other threads. yield wont solve 
> > that fundamental problem either, and it will introduce random 
> > latencies into apps using this memory allocator.)
> 
> You are assuming that random latencies are necessarily bad. Random 
> latencies may be significantly better than predictable high latency.

i'm not really assuming anything, i gave a vague first impression of the 
vague example you gave (assuming that the yield was done to combat 
fairness problems). This is a case where the human language shows its 
boundaries: statements that are hard to refute with certainty because 
they are too vague. So i'd really suggest you show me some sample/real 
code - that would move this discussion to a much more productive level.

but i'll attempt to weave the chain of argument one step forward (in the 
hope of not distorting your point in any way): _if_ the sched_yield() 
call in that memory allocator is done because it uses a locking 
primitive that is unfair (hence the memory pool lock can be starved), 
then the "guaranteed large latency" is caused by "guaranteed 
unfairness". The solution is not to insert a random latency (via a 
sched_yield() call) that also has a side-effect of fairness to other 
tasks, because this random latency introduces guaranteed unfairness for 
this particular task. The correct solution IMO is to make the locking 
primitive more fair _without_ random delays, and there are a number of 
good techniques for that. (they mostly center around the use of futexes)

one thing that is often missed is that most of the cost of a yield() is 
in the system call and the context-switch - quite similar to the futex 
slowpath. So there's _no_ reason to not use a futexes on Linux. (yes, 
there might be historic/compatibility or ease-of-porting arguments but 
those do not really impact the fundamental argument of whether something 
is technically right or not.)

	Ingo
