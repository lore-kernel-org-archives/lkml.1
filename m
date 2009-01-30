Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZA3HJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZA3HJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZA3HJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:09:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:53963 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751378AbZA3HJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:09:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ACVxtZB1A5eckr/rnUjKvr0+aGNpCFJf/Y1EI8m
	pBK32TRbQBkFth
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1233298321.17301.18.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
	 <1233296647.6071.15.camel@marge.simson.net>
	 <1233298321.17301.18.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 08:09:04 +0100
Message-Id: <1233299344.4506.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 01:52 -0500, Nathanael Hoyle wrote:
> On Fri, 2009-01-30 at 07:24 +0100, Mike Galbraith wrote:

> > Sounds like a problem was recently fixed.  Can you try 2.6.29-rc3 or
> > 2.6.28.2?
> > 
> 
> I will try to do so as soon as I get the chance.  Do you have any
> specific info on the problem that you believe was fixed and/or the fix
> applied.

The commit text below also applies to +nice tasks.

commit 046e7f77d734778a3b2e7d51ce63da3dbe7a8168
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jan 15 14:53:39 2009 +0100

    sched: fix update_min_vruntime
    
    commit e17036dac189dd034c092a91df56aa740db7146d upstream.
    
    Impact: fix SCHED_IDLE latency problems
    
    OK, so we have 1 running task A (which is obviously curr and the tree is
    equally obviously empty).
    
    'A' nicely chugs along, doing its thing, carrying min_vruntime along as it
    goes.
    
    Then some whacko speed freak SCHED_IDLE task gets inserted due to SMP
    balancing, which is very likely far right, in that case
    
    update_curr
      update_min_vruntime
        cfs_rq->rb_leftmost := true (the crazy task sitting in a tree)
          vruntime = se->vruntime
    
    and voila, min_vruntime is waaay right of where it ought to be.
    
    OK, so why did I write it like that to begin with...
    
    Aah, yes.
    
    Say we've just dequeued current
    
    schedule
      deactivate_task(prev)
        dequeue_entity
          update_min_vruntime
    
    Then we'll set
    
      vruntime = cfs_rq->min_vruntime;
    
    we find !cfs_rq->curr, but do find someone in the tree. Then we _must_
    do vruntime = se->vruntime, because
    
     vruntime = min_vruntime(vruntime := cfs_rq->min_vruntime, se->vruntime)
    
    will not advance vruntime, and cause lags the other way around (which we
    fixed with that initial patch: 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
    (sched: more accurate min_vruntime accounting).
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Tested-by: Mike Galbraith <efault@gmx.de>
    Acked-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 98345e4..06a68c4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -283,7 +283,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 						   struct sched_entity,
 						   run_node);
 
-		if (vruntime == cfs_rq->min_vruntime)
+		if (!cfs_rq->curr)
 			vruntime = se->vruntime;
 		else
 			vruntime = min_vruntime(vruntime, se->vruntime);


