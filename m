Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757Ab0B0AjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:39:10 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58470 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966723Ab0B0AjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:39:04 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: more fixes for accelerated GPs for last non-dynticked CPU
Date: Fri, 26 Feb 2010 16:38:58 -0800
Message-Id: <1267231138-27856-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100227003831.GA27703@linux.vnet.ibm.com>
References: <20100227003831.GA27703@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables irqs across the call to rcu_needs_cpu().  It also
enforces a hold-off period so that the idle loop doesn't softirq itself
to death when there are lots of RCU callbacks in flight on the last
non-dynticked CPU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ed241fc..464ad2c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -986,6 +986,7 @@ static void rcu_needs_cpu_flush(void)
 
 #define RCU_NEEDS_CPU_FLUSHES 5
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
+static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 
 /*
  * Check to see if any future RCU-related work will need to be done
@@ -1013,6 +1014,7 @@ int rcu_needs_cpu(int cpu)
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
 		if (thatcpu != cpu) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
+			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
 		}
 
@@ -1022,6 +1024,7 @@ int rcu_needs_cpu(int cpu)
 		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		return rcu_needs_cpu_quick_check(cpu);
 	}
 
@@ -1038,8 +1041,10 @@ int rcu_needs_cpu(int cpu)
 	}
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
-	if (c)
+	if (c) {
 		raise_softirq(RCU_SOFTIRQ);
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+	}
 	return c;
 }
 
@@ -1050,10 +1055,13 @@ int rcu_needs_cpu(int cpu)
 static void rcu_needs_cpu_flush(void)
 {
 	int cpu = smp_processor_id();
+	unsigned long flags;
 
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0)
 		return;
+	local_irq_save(flags);
 	(void)rcu_needs_cpu(cpu);
+	local_irq_restore(flags);
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.6.6

