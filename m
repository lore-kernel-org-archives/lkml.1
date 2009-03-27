Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZC0QUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZC0QUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZC0QUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:20:21 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46426 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbZC0QUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:20:19 -0400
Date: Fri, 27 Mar 2009 21:49:15 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: rt group scheduling, compare child's limit against
	parent's
Message-ID: <20090327161915.GA8891@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter,

I've not been able to follow the reasoning behind checking the sum of
the children's runtime not exceeding the parent's runtime as opposed to
the child's runtime not exceeding that of the parent.

>From what I understand, the limits only guarantee that the group cannot
exceed a certain limit and not guarantee a group gets to run. If my
understanding is corrct, maybe the following patch is needed?

Thanks,

--
sched: rt group scheduling, compare child's limit against parent's

The current logic checks that the sum of the children's runtime in rt
group scheduling does not exceed the parent's. This logic is wrong,
all we claim is that the group cannot exceed the amount of time allowed.

Change the code to reflect this.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 kernel/sched.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -9601,7 +9601,7 @@ static int tg_schedulable(struct task_gr
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	unsigned long total;
 	u64 period, runtime;
 
 	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
@@ -9640,9 +9640,10 @@ static int tg_schedulable(struct task_gr
 		return -EINVAL;
 
 	/*
-	 * The sum of our children's runtime should not exceed our own.
+	 * The child's runtime should not exceed our own.
 	 */
 	list_for_each_entry_rcu(child, &tg->children, siblings) {
+		unsigned long ratio;
 		period = ktime_to_ns(child->rt_bandwidth.rt_period);
 		runtime = child->rt_bandwidth.rt_runtime;
 
@@ -9651,11 +9652,11 @@ static int tg_schedulable(struct task_gr
 			runtime = d->rt_runtime;
 		}
 
-		sum += to_ratio(period, runtime);
-	}
+		ratio = to_ratio(period, runtime);
 
-	if (sum > total)
-		return -EINVAL;
+		if (ratio > total)
+			return -EINVAL;
+	}
 
 	return 0;
 }
-- 
regards,
Dhaval
