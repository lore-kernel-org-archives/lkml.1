Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0CEXDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:03:42 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50079 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab0CEXDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:03:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: Increase RCU CPU stall timeouts if PROVE_RCU
Date: Fri,  5 Mar 2010 15:03:26 -0800
Message-Id: <1267830207-9474-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100305230256.GA9410@linux.vnet.ibm.com>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PROVE_RCU imposes additional overhead on the kernel, so increase
the RCU CPU stall timeouts in an attempt to allow for this effect.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1439eb5..4a525a3 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -246,12 +246,21 @@ struct rcu_data {
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
-						  /*  to take at least one */
-						  /*  scheduling clock irq */
-						  /*  before ratting on them. */
+
+#ifdef CONFIG_PROVE_RCU
+#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
+#else
+#define RCU_STALL_DELAY_DELTA	       0
+#endif
+
+#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ + RCU_STALL_DELAY_DELTA)
+						/* for rsp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ + RCU_STALL_DELAY_DELTA)
+						/* for rsp->jiffies_stall */
+#define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
+						/*  to take at least one */
+						/*  scheduling clock irq */
+						/*  before ratting on them. */
 
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
-- 
1.6.6

