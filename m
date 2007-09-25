Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXIYJlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXIYJlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXIYJl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:41:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36360 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbXIYJl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:41:28 -0400
Date: Tue, 25 Sep 2007 11:40:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925094040.GA28391@elte.hu>
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925094440.GK26289@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Sep 25, 2007 at 11:13:31AM +0200, Ingo Molnar wrote:
> > ok, i'm too seeing some sort of latency weirdness with 
> > CONFIG_FAIR_GROUP_SCHED enabled, _if_ there's Xorg involved which runs 
> > under root uid on my box - and hence gets 50% of all CPU time.
> > 
> > Srivatsa, any ideas? It could either be an accounting buglet (less 
> > likely, seems like the group scheduling bits stick to the 50% splitup 
> > nicely), or a preemption buglet. One potential preemption buglet would 
> > be for the group scheduler to not properly preempt a running task when a 
> > task from another uid is woken?
> 
> Yep, I noticed that too.
> 
> check_preempt_wakeup()
> {
> 	...
> 
> 	if (is_same_group(curr, p)) {
> 	    ^^^^^^^^^^^^^
> 
> 		resched_task();
> 	}
> 
> }
> 
> Will try a fix to check for preemption at higher levels ..

i bet fixing this will increase precision of group scheduling as well. 
Those long latencies can be thought of as noise as well, and the 
fair-scheduling "engine" might not be capable to offset all sources of 
noise. So generally, while we allow a certain amount of lag in 
preemption decisions (wakeup-granularity, etc.), with which the fairness 
engine will cope just fine, we do not want to allow unlimited lag.

	Ingo
