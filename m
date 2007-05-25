Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbXEYHh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbXEYHh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXEYHhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:37:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48732 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbXEYHhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:37:17 -0400
Date: Fri, 25 May 2007 13:15:00 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       efault@gmx.de, kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070525074500.GD6157@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4654BF88.3030404@yahoo.fr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 12:26:16AM +0200, Guillaume Chazarain wrote:
> As a sidenote, while in CFS-v13 a nice=0 tasks seems to get 10x more CPU 
> than a nice=10 one, with the group fairness patch, the ratio drops to 
> less than 2x (for tasks with the same UID).

gah ..silly me.

Can you repeat your tests with this patch pls? With the patch applied, I am
now getting the same split between nice 0 and nice 10 task as CFS-v13
provides (90:10 as reported by top )

 5418 guest     20   0  2464  304  236 R   90  0.0   5:41.40 3 hog
 5419 guest     30  10  2460  304  236 R   10  0.0   0:43.62 3 nice10hog



Fix a stupid bug, where I was not calling __check_preempt_curr_fair()
at task level during task_tick ..

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>


---


diff -puN kernel/sched_fair.c~fix kernel/sched_fair.c
--- linux-2.6.22-rc1-cfs-group/kernel/sched_fair.c~fix	2007-05-25 12:28:52.000000000 +0530
+++ linux-2.6.22-rc1-cfs-group-vatsa/kernel/sched_fair.c	2007-05-25 12:30:06.000000000 +0530
@@ -577,11 +577,12 @@ static void entity_tick(struct lrq *lrq,
 				   *n = task_entity(next);
 
 		if ((c == lrq->rq->idle) || (rt_prio(n->prio) &&
-						(n->prio < c->prio)))
+						(n->prio < c->prio))) {
 			resched_task(c);
-	} else
-		__check_preempt_curr_fair(lrq, next, curr,
-					  *(lrq->sched_granularity));
+			return;
+		}
+	}
+	__check_preempt_curr_fair(lrq, next, curr, *(lrq->sched_granularity));
 }
 
 static void _update_load(struct lrq *this_rq)
_


-- 
Regards,
vatsa
