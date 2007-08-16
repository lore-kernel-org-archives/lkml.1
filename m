Return-Path: <linux-kernel-owner+w=401wt.eu-S938007AbXHPCt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938007AbXHPCt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbXHPCtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:49:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40370 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760648AbXHPCtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:49:09 -0400
Date: Wed, 15 Aug 2007 19:49:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: bunk@kernel.org, josh@kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: [PATCH] Make rcutorture RNG use temporal entropy
Message-ID: <20070816024904.GA5312@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Repost of http://lkml.org/lkml/2007/8/10/472 made available by request.

The locking used by get_random_bytes() can conflict with the
preempt_disable() and synchronize_sched() form of RCU.  This patch changes
rcutorture's RNG to gather entropy from the new cpu_clock() interface
(relying on interrupts, preemption, daemons, and rcutorture's reader
thread's rock-bottom scheduling priority to provide useful entropy),
and also adds and EXPORT_SYMBOL_GPL() to make that interface available
to GPLed kernel modules such as rcutorture.

Passes several hours of rcutorture.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |    8 ++------
 sched.c      |    2 ++
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -urpNa -X dontdiff linux-2.6.23-rc2/kernel/rcutorture.c linux-2.6.23-rc2-rcutorturesched/kernel/rcutorture.c
--- linux-2.6.23-rc2/kernel/rcutorture.c	2007-08-03 19:49:55.000000000 -0700
+++ linux-2.6.23-rc2-rcutorturesched/kernel/rcutorture.c	2007-08-10 17:15:22.000000000 -0700
@@ -42,7 +42,6 @@
 #include <linux/notifier.h>
 #include <linux/freezer.h>
 #include <linux/cpu.h>
-#include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
@@ -166,16 +165,13 @@ struct rcu_random_state {
 
 /*
  * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from get_random_bytes().
+ * generator, with occasional help from cpu_clock().
  */
 static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
-	long refresh;
-
 	if (--rrsp->rrs_count < 0) {
-		get_random_bytes(&refresh, sizeof(refresh));
-		rrsp->rrs_state += refresh;
+		rrsp->rrs_state += (unsigned long)cpu_clock(smp_processor_id());
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
diff -urpNa -X dontdiff linux-2.6.23-rc2/kernel/sched.c linux-2.6.23-rc2-rcutorturesched/kernel/sched.c
--- linux-2.6.23-rc2/kernel/sched.c	2007-08-03 19:49:55.000000000 -0700
+++ linux-2.6.23-rc2-rcutorturesched/kernel/sched.c	2007-08-10 17:22:57.000000000 -0700
@@ -394,6 +394,8 @@ unsigned long long cpu_clock(int cpu)
 	return now;
 }
 
+EXPORT_SYMBOL_GPL(cpu_clock);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /* Change a task's ->cfs_rq if it moves across CPUs */
 static inline void set_task_cfs_rq(struct task_struct *p)
