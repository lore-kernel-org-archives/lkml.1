Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZLXKBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZLXKBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 05:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZLXKBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 05:01:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:58162 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750872AbZLXKBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 05:01:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19oYNk8Y7touAIbdVSVzkZz9T+7wopyi8G1t6HMoc
	m3WBa+bfK1gfrG
Subject: Re: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1261646964.4937.172.camel@laptop>
References: <20091217185021.684424629@chello.nl>
	 <1261581216.4937.150.camel@laptop>
	 <1261629824.10947.13.camel@marge.simson.net>
	 <1261646964.4937.172.camel@laptop>
Content-Type: text/plain
Date: Thu, 24 Dec 2009 11:01:22 +0100
Message-Id: <1261648882.15438.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 10:29 +0100, Peter Zijlstra wrote:
> On Thu, 2009-12-24 at 05:43 +0100, Mike Galbraith wrote:
> > On Wed, 2009-12-23 at 16:13 +0100, Peter Zijlstra wrote:
> > > load_balance() and load_balance_newidle() look remarkably similar, one
> > > key point they differ in is the condition on when to active balance.
> > > 
> > > So split out that logic into a separate function.
> > > 
> > > One side effect is that previously load_balance_newidle() used to fail and
> > > return -1 under these conditions, whereas now it doesn't. I've not yet fully
> > > figured out the whole -1 return case for either load_balance{,_newidle}().
> > > 
> > > It also differs in that sd->cache_nice_tries is now added on the 
> > > CPU_NEWLY_IDLE case.
> > 
> > Unification Looks like a good idea, less being more and all that.  I
> > suspect that last bit is why newidle effectiveness has been heavily
> > impacted.  x264 ultrafast testcase is whimpering pathetically again ;-)
> 
> That could be easily verified by setting cache_nice_tries to 0.

Was bad wild guess.

> However, I would suspect need_active_balance(.idle = CPU_NEWLY_IDLE) to
> always fail on your machine, since I don't think you've got all that
> power savings muck enabled.

Nope. Guess I need to poke need_active_balance() with a stick.

> Is that with just this patch applied or also with the next one? I
> worried more about the next one.

With both... all 8 actually, but popping last two cures idle woes.

> If just this one, that funny -1 return value thing might have played a
> role, since that seems to trigger the:
> 
>  if (pulled_task) {
>    this_rq->idle_stamp = 0;
>    break;
>  }
> 
> logic in idle_balance()
> 
> Which didn't make any sense to me, since it didn't move any task, so why
> pretend it did...

Heh, pretending is unlikely to help.

	-Mike

