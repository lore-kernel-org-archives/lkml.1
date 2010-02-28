Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031639Ab0B1I7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:59:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:40383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031620Ab0B1I7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:59:45 -0500
Date: Sun, 28 Feb 2010 08:59:01 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix holdoff for accelerated GPs for last non-dynticked CPU
Message-ID: <tip-622ea685f1fafdf84d612440535c84341f0860b8@git.kernel.org>
Git-Commit-ID: 622ea685f1fafdf84d612440535c84341f0860b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 08:59:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  622ea685f1fafdf84d612440535c84341f0860b8
Gitweb:     http://git.kernel.org/tip/622ea685f1fafdf84d612440535c84341f0860b8
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 27 Feb 2010 14:53:07 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 28 Feb 2010 09:17:42 +0100

rcu: Fix holdoff for accelerated GPs for last non-dynticked CPU

Make the holdoff only happen when the full number of attempts
have been made.

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
LKML-Reference: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
