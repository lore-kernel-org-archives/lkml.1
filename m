Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030888Ab0B0WxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:53:13 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39281 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964920Ab0B0WxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:53:11 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: fix holdoff for accelerated GPs for last non-dynticked CPU
Date: Sat, 27 Feb 2010 14:53:07 -0800
Message-Id: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100227225240.GA16515@linux.vnet.ibm.com>
References: <20100227225240.GA16515@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the holdoff only happen when the full number of attempts have been
made.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 464ad2c..79b53bd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1010,6 +1010,10 @@ int rcu_needs_cpu(int cpu)
 	int c = 0;
 	int thatcpu;
 
+	/* Check for being in the holdoff period. */
+	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies)
+		return rcu_needs_cpu_quick_check(cpu);
+
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
 		if (thatcpu != cpu) {
@@ -1041,10 +1045,8 @@ int rcu_needs_cpu(int cpu)
 	}
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
-	if (c) {
+	if (c)
 		raise_softirq(RCU_SOFTIRQ);
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-	}
 	return c;
 }
 
-- 
1.6.6

