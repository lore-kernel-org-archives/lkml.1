Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbXKAMUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbXKAMUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXKAMUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:20:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47848 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXKAMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:20:11 -0400
Subject: Re: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1193918598.27652.262.camel@twins>
References: <20071031211030.310581000@chello.nl>
	 <20071031211248.796653000@chello.nl>
	 <20071101113138.GA20788@linux.vnet.ibm.com>
	 <1193917912.27652.258.camel@twins>  <1193918299.27652.260.camel@twins>
	 <1193918598.27652.262.camel@twins>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 13:20:08 +0100
Message-Id: <1193919608.27652.277.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 13:03 +0100, Peter Zijlstra wrote:
> On Thu, 2007-11-01 at 12:58 +0100, Peter Zijlstra wrote:
> 
> > > sched_slice() is about lantecy, its intended purpose is to ensure each
> > > task is ran exactly once during sched_period() - which is
> > > sysctl_sched_latency when nr_running <= sysctl_sched_nr_latency, and
> > > otherwise linearly scales latency.
> 
> The thing that got my brain in a twist is what to do about the non-leaf
> nodes, for those it seems I'm not doing the right thing - I think.

Ok, suppose a tree like so:


level 2                   cfs_rq
                       A           B

level 1             cfs_rqA     cfs_rqB
                     A0        B0 - B99


So for sake of determinism, we want to impose a period in which all
level 1 tasks will have ran (at least) once.

Now what sched_slice() does is calculate the weighted proportion of the
given period for each task to run, so that each task runs exactly once.

Now level 2, can introduce these large weight differences, which in this
case result in 'lumps' of time.

In the given example above the weight difference is 1:100, which is
already at the edges of what regular nice levels could do.

How about limiting the max output of sched_slice() to
sysctl_sched_latency in order to break up these large stretches of time?

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -341,7 +341,7 @@ static u64 sched_slice(struct cfs_rq *cf
 		do_div(slice, cfs_rq->load.weight);
 	}
 
-	return slice;
+	return min_t(u64, sysctl_sched_latency, slice);
 }
 
 /*



