Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYBRPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYBRPfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYBRPfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:35:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYBRPf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:35:27 -0500
Subject: Re: Regression with sched yield - 2.6.25-rc2-mm1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <47B9A206.5000008@linux.vnet.ibm.com>
References: <47B9775F.1050203@linux.vnet.ibm.com>
	 <1203338377.10858.3.camel@lappy>  <47B99AB4.3020604@linux.vnet.ibm.com>
	 <1203347933.10858.8.camel@lappy>  <47B9A206.5000008@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 16:35:12 +0100
Message-Id: <1203348912.10858.14.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 20:49 +0530, Balbir Singh wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-02-18 at 20:18 +0530, Balbir Singh wrote:
> > 
> >>> Humm, the check that should have avoided that is:
> >>>
> >>>         /*
> >>>          * Are we the only task in the tree?
> >>>          */
> >>>         if (unlikely(rq->load.weight == curr->se.load.weight))
> >>>                 return;
> >>>

> OK, but does it belong to the cfs_rq?

I'm not looking at the cfs_rq, but at rq. Looking at cfs_rq isn't
correct because it might be a group with only a single task even though
there might be more tasks on this cpu.

Now it turns out, looking at the rq isn't correct either. At the time I
think I thought that a runnable RT task would've preempted - but that is
of course not valid under all preemption models - and racy even on
PREEMPT=y

> >>  Having said that, rightmost was indeed
> >> NULL, so I need to figure out why it was. The other question is why would a real
> >> time task be found by sched_yield_fair? 
> > 
> > Because a rt task contributes weight and would make the test above fail
> > because rt->load would be larger than expected.
> > 
> 
> I thought we were searching an RBtree for the fair group scheduler. If what you
> say is indeed true, shouldn't we check if the task is an rt task in
> sched_yield_fair() instead of the !rightmost check?

We're not actually finding a rt task. Just the presence of a runnable RT
task on this CPU skews the weights and fools my test.

rightmost returns NULL because there just isn't anybody else in the CFS
rq (note that current isn't in the tree).


