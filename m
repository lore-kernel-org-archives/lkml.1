Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZHUL3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZHUL3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZHUL3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:29:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbZHUL3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:29:48 -0400
Date: Fri, 21 Aug 2009 13:29:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       balbir@linux.vnet.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] better align percpu counter (Was Re: [tip:sched/core]
	sched: cpuacct: Use bigger percpu counter batch values for stats
	counters
Message-ID: <20090821112915.GA24647@elte.hu>
References: <20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten> <20090820052605.GC26265@balbir.in.ibm.com> <1250747579.8282.110.camel@twins> <20090820060528.GG21100@kryten> <20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com> <20090820062451.GH21100@kryten> <20090820174123.afa43c48.kamezawa.hiroyu@jp.fujitsu.com> <20090820100403.GB29093@elte.hu> <20090821112054.1e6bc4e6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821112054.1e6bc4e6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 20 Aug 2009 12:04:03 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > with your program
> > > before patch.
> > > cpuacct off : 414000-416000 ctsw per sec.
> > > cpuacct on  : 401000-404000 ctsw per sec.
> > > 
> > > after patch
> > > cpuacct on  : 412000-413000 ctsw per sec.
> > > 
> > > Maybe I should check cache-miss late ;)
> > 
> > Btw., in latest upstream you can do that via:
> > 
> >   cd tools/perf/
> >   make -j install
> > 
> >   perf stat --repeat 5 -- taskset -c 1 ./context_switch
> > 
> 
> tried. (on 8cpu/2socket host). It seems cache-miss decreases. But 
> IPC ..?

All the numbers have gone down - about the same amount of cycles but 
fewer instructions executed, and fewer cache-misses. That's good.

The Instructions Per Cycle metric got worse because cycles stayed 
constant. One thing is that you have triggered counter-over-commit 
(the 'scaled from' messages) - this means that more counters are 
used than the hardware has space for - so we round-robin schedule 
them.

If you want to get to the bottom of that, to get the most precise 
result try something like:

    perf stat --repeat 5 -a -e \
        cycles,instructions,L1-dcache-load-misses,L1-dcache-store-misses \
        -- ./ctxt_sw.sh

( this is almost the same as the command line you used, but without 
  the 'cache-misses' counter. Your CPU should be able to 
  simultaneously activate all these counters and they should count 
  100% of the events. )

	Ingo
