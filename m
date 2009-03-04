Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCDS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCDS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZCDS3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:29:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32919 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZCDS3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:29:38 -0500
Date: Wed, 4 Mar 2009 19:29:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       ego@in.ibm.com, tglx@linutronix.de, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org
Subject: Re: [v2 PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090304182914.GF1537@elte.hu>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304173321.GB25962@elte.hu> <20090304180657.GA27520@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304180657.GA27520@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2009-03-04 18:33:21]:
> 
> > 
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:
> > 
> > > $taskset -c 4,5,6,7 make -j4
> > > 
> > > my_driver queuing timers continuously on CPU 10.
> > > 
> > > idle load balancer currently on CPU 15
> > > 
> > > 
> > > Case1: Without timer migration		Case2: With timer migration
> > > 
> > >    --------------------			   --------------------
> > >    | Core | LOC Count |			   | Core | LOC Count |
> > >    | 4    |   2504    |			   | 4    |   2503    |
> > >    | 5    |   2502    |			   | 5    |   2503    |
> > >    | 6    |   2502    |			   | 6    |   2502    |
> > >    | 7    |   2498    |			   | 7    |   2500    |
> > >    | 10   |   2501    |			   | 10   |     35    |
> > >    | 15   |   2501    |			   | 15   |   2501    |
> > >    --------------------			   --------------------
> > > 
> > >    ---------------------		   --------------------
> > >    | Core | Sleep time |		   | Core | Sleep time |
> > >    | 4    |    0.47168 |		   | 4    |    0.49601 |
> > >    | 5    |    0.44301 |		   | 5    |    0.37153 |
> > >    | 6    |    0.38979 |		   | 6    |    0.51286 |
> > >    | 7    |    0.42829 |		   | 7    |    0.49635 |
> > >    | 10   |    9.86652 |		   | 10   |   10.04216 |
> > >    | 15   |    0.43048 |		   | 15   |    0.49056 |
> > >    ---------------------		   ---------------------
> > > 
> > > Here, all the timers queued by the driver on CPU10 are moved to CPU15,
> > > which is the idle load balancer.
> > 
> > The numbers with this automatic method based on the ilb-cpu look 
> > pretty convincing. Is this what you expected it to be?
> 
> Yes Ingo, this is the expected results and looks pretty good.  However
> there are two parameters controlled in this experiment:
> 
> 1) The system is moderately loaded with kernbench so that there are
>    some busy CPUs and some idle cpus, and the no_hz mask is does not
>    change often.  This leads to stable ilb-cpu selection.  If the
>    system is either completely idle or loaded too little leading to
>    ilb nominations, then timers keep following the ilb cpu and it is
>    very difficult to experimentally observe the benefits.
> 
>    Even if the ilb bounces, consolidating timers should increase
>    overlap between timers and reduce the wakeup from idle.
> 
>    Optimising the ilb selection should significantly improve
>    experimental results for this patch.
> 
> 2) The timer test driver creates quite large timer load so that the
>    effect of migration is observable as sleep time difference on the
>    expected target cpu.  This kind of timer load may not be uncommon
>    with lots of application stack loaded in an enterprise system

the important thing to watch out for is to not have _worse_ 
performance due to ilb jumping too much. So as long as you can 
prove that numbers dont get worse you are golden.

Power-saving via migration will only work if there's a 
concentrated workload to begin with.

So the best results will be in combination with scheduler 
power-saving patches. (which too make the ilb jump less in 
essence)

So by getting scheduler power saving enhancements your method 
will work better too - there's good synergy and no dependency on 
any user-space component.

Btw., could you please turn the runtime switch into a /proc/sys 
sysctl, and only when CONFIG_SCHED_DEBUG=y. Otherwise it should 
be default-enabled with no ability to turn it off.

	Ingo
