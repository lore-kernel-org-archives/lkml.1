Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYFLIou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYFLIou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYFLIok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:44:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56362 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYFLIoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:44:39 -0400
Message-ID: <4850E192.3080804@cn.fujitsu.com>
Date: Thu, 12 Jun 2008 16:42:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sched: fair group: fix overflow(was: fix divide by zero)
References: <484F7AC5.8040206@cn.fujitsu.com> <1213168547.31518.66.camel@twins>
In-Reply-To: <1213168547.31518.66.camel@twins>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> I think the same thing to do is limit the shares value to something
> smaller instead of using an even more expensive divide.
> 

yes, you are right!

I found another bug about "the shares value is too large":

pid1 and pid2 are set affinity to cpu#0
pid1 is attached to cg1 and pid2 is attached to cg2

if cg1/cpu.shares = 1024 cg2/cpu.shares = 2000000000
then pid2 got 100% usage of cpu, and pid1 0%

if cg1/cpu.shares = 1024 cg2/cpu.shares = 20000000000
then pid2 got 0% usage of cpu, and pid1 100%


And a weight of a cfs_rq is the sum of weights of which entities
are queued on this cfs_rq, so the shares value should be limited
to a smaller value.

I think that (1UL << 18) is a good limited value:
1)it's not too large, we can create a lot of group before overflow
2)it's several times the weight value for nice=-19 (not too small)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index bfb8ad8..fe1b6c7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -312,12 +312,15 @@ static DEFINE_SPINLOCK(task_group_lock);
 #endif
 
 /*
- * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
+ * A weight of 0 or 1 can cause arithmetics problems.
+ * A weight of a cfs_rq is the sum of weights of which entities
+ * are queued on this cfs_rq, so a weight of a entity should not be
+ * too large, so as the shares value of a task group.
  * (The default weight is 1024 - so there's no practical
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(ULONG_MAX - 1)
+#define MAX_SHARES	(1UL << 18)
 
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 #endif




