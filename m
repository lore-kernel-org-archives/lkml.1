Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968266Ab0B0M5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:57:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:45177 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968209Ab0B0M5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:57:12 -0500
Date: Sat, 27 Feb 2010 12:56:32 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267231138-27856-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267231138-27856-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix accelerated GPs for last non-dynticked CPU
Message-ID: <tip-71da81324c83ef65bb196c7f874ac1c6996d8287@git.kernel.org>
Git-Commit-ID: 71da81324c83ef65bb196c7f874ac1c6996d8287
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:56:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71da81324c83ef65bb196c7f874ac1c6996d8287
Gitweb:     http://git.kernel.org/tip/71da81324c83ef65bb196c7f874ac1c6996d8287
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 26 Feb 2010 16:38:58 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Feb 2010 09:53:53 +0100

rcu: Fix accelerated GPs for last non-dynticked CPU

This patch disables irqs across the call to rcu_needs_cpu().  It
also enforces a hold-off period so that the idle loop doesn't
softirq itself to death when there are lots of RCU callbacks in
flight on the last non-dynticked CPU.

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
LKML-Reference: <1267231138-27856-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
