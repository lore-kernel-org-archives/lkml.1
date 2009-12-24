Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZLXJaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZLXJaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 04:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZLXJaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 04:30:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZLXJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 04:30:15 -0500
Subject: Re: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1261629824.10947.13.camel@marge.simson.net>
References: <20091217185021.684424629@chello.nl>
	 <1261581216.4937.150.camel@laptop>
	 <1261629824.10947.13.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 10:29:24 +0100
Message-ID: <1261646964.4937.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 05:43 +0100, Mike Galbraith wrote:
> On Wed, 2009-12-23 at 16:13 +0100, Peter Zijlstra wrote:
> > load_balance() and load_balance_newidle() look remarkably similar, one
> > key point they differ in is the condition on when to active balance.
> > 
> > So split out that logic into a separate function.
> > 
> > One side effect is that previously load_balance_newidle() used to fail and
> > return -1 under these conditions, whereas now it doesn't. I've not yet fully
> > figured out the whole -1 return case for either load_balance{,_newidle}().
> > 
> > It also differs in that sd->cache_nice_tries is now added on the 
> > CPU_NEWLY_IDLE case.
> 
> Unification Looks like a good idea, less being more and all that.  I
> suspect that last bit is why newidle effectiveness has been heavily
> impacted.  x264 ultrafast testcase is whimpering pathetically again ;-)

That could be easily verified by setting cache_nice_tries to 0.

However, I would suspect need_active_balance(.idle = CPU_NEWLY_IDLE) to
always fail on your machine, since I don't think you've got all that
power savings muck enabled.

Is that with just this patch applied or also with the next one? I
worried more about the next one.

If just this one, that funny -1 return value thing might have played a
role, since that seems to trigger the:

 if (pulled_task) {
   this_rq->idle_stamp = 0;
   break;
 }

logic in idle_balance()

Which didn't make any sense to me, since it didn't move any task, so why
pretend it did...

