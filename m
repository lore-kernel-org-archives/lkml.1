Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZKMJdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZKMJdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZKMJdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:33:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:53376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZKMJd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:33:28 -0500
Date: Fri, 13 Nov 2009 09:31:09 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258094104417-git-send-email->
References: <1258094104417-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Accelerate callback processing on CPUs not detecting GP end
Message-ID: <tip-b32e9eb6ad29572b4451847d0e8227c9be2b6d69@git.kernel.org>
Git-Commit-ID: b32e9eb6ad29572b4451847d0e8227c9be2b6d69
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b32e9eb6ad29572b4451847d0e8227c9be2b6d69
Gitweb:     http://git.kernel.org/tip/b32e9eb6ad29572b4451847d0e8227c9be2b6d69
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Nov 2009 22:35:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Nov 2009 10:18:36 +0100

rcu: Accelerate callback processing on CPUs not detecting GP end

An earlier fix for a race resulted in a situation where the CPUs
other than the CPU that detected the end of the grace period would
not process their callbacks until the next grace period started.

This means that these other CPUs would unnecessarily demand that an
extra grace period be started.

This patch eliminates this extra grace period and speeds callback
processing by propagating rsp->completed to the rcu_node structures
in the case where the CPU detecting the end of the grace period
sees no reason to start a new grace period.

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
LKML-Reference: <1258094104417-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d802419..b4efb9e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -676,7 +676,23 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp)) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		if (rnp->completed == rsp->completed) {
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+
+		/*
+		 * Propagate new ->completed value to rcu_node structures
+		 * so that other CPUs don't have to wait until the start
+		 * of the next grace period to process their callbacks.
+		 */
+		rcu_for_each_node_breadth_first(rsp, rnp) {
+			spin_lock(&rnp->lock);	 /* irqs already disabled. */
+			rnp->completed = rsp->completed;
+			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		}
+		local_irq_restore(flags);
 		return;
 	}
 
