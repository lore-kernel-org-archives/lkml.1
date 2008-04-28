Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYD1EzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYD1EzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYD1Eyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:54:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYD1Eys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:54:48 -0400
Message-ID: <481558A0.9020803@cn.fujitsu.com>
Date: Mon, 28 Apr 2008 12:54:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fair-group: fix a Div0 error of the fair group scheduler
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I echoed 0 into the "cpu.shares" file, a Div0 error occured.

We found it is caused by the following calling.

   sched_group_set_shares(tg, shares)
       set_se_shares(tg->se[i], shares/nr_cpu_ids)
           __set_se_shares(se, shares)
               div64_64((1ULL<<32), shares)

When the echoed value was less than the number of processores, the result of the
sentence "shares/nr_cpu_ids" was 0, and then the system called div64() to divide
the result, the Div0 error occured.

It is unnecessary that the shares value is divided by nr_cpu_ids, I think.
Because in the function  __update_group_shares_cpu() and init_tg_cfs_entry(),
the shares value isn't divided by nr_cpu_ids when setting shares of the sched
entity.

This patch fixes this bug. And echoing ULONG_MAX value into cpu.shares also
causes Div0 error, so we set a macro MAX_SHARES to limit the max value of
shares.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
  kernel/sched.c |   17 +++++++++++------
  1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 740fb40..aa1bb81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -318,7 +318,13 @@ static DEFINE_MUTEX(doms_cur_mutex);
  # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
  #endif

+/*
+ * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
+ * (The default weight is 1024 - so there's no practical
+ *  limitation from this.)
+ */
  #define MIN_SHARES	2
+#define MAX_SHARES	(ULONG_MAX - 1)

  static int init_task_group_load = INIT_TASK_GROUP_LOAD;
  #endif
@@ -1748,6 +1754,8 @@ __update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,

  	if (shares < MIN_SHARES)
  		shares = MIN_SHARES;
+	else if (shares > MAX_SHARES)
+		shares = MAX_SHARES;

  	__set_se_shares(tg->se[tcpu], shares);
  }
@@ -8722,13 +8730,10 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
  	if (!tg->se[0])
  		return -EINVAL;

-	/*
-	 * A weight of 0 or 1 can cause arithmetics problems.
-	 * (The default weight is 1024 - so there's no practical
-	 *  limitation from this.)
-	 */
  	if (shares < MIN_SHARES)
  		shares = MIN_SHARES;
+	else if (shares > MAX_SHARES)
+		shares = MAX_SHARES;

  	mutex_lock(&shares_mutex);
  	if (tg->shares == shares)
@@ -8753,7 +8758,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
  		 * force a rebalance
  		 */
  		cfs_rq_set_shares(tg->cfs_rq[i], 0);
-		set_se_shares(tg->se[i], shares/nr_cpu_ids);
+		set_se_shares(tg->se[i], shares);
  	}

  	/*
-- 
1.5.4.rc3


