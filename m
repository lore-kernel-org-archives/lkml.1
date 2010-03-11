Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0CKOjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:39:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:35319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab0CKOjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:39:19 -0500
Date: Thu, 11 Mar 2010 14:38:34 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267830207-9474-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267830207-9474-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Increase RCU CPU stall timeouts if PROVE_RCU
Message-ID: <tip-007b09243b099811124f69d492adeebe9e439f96@git.kernel.org>
Git-Commit-ID: 007b09243b099811124f69d492adeebe9e439f96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:38:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  007b09243b099811124f69d492adeebe9e439f96
Gitweb:     http://git.kernel.org/tip/007b09243b099811124f69d492adeebe9e439f96
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 5 Mar 2010 15:03:26 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 13:38:01 +0100

rcu: Increase RCU CPU stall timeouts if PROVE_RCU

CONFIG_PROVE_RCU imposes additional overhead on the kernel, so
increase the RCU CPU stall timeouts in an attempt to allow for
this effect.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1267830207-9474-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
