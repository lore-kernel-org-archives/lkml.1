Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZKMGes (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 13 Nov 2009 01:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZKMGen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:34:43 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48054 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZKMGem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:34:42 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: accelerate callback processing on CPUs not detecting GP end
Date: Thu, 12 Nov 2009 22:35:03 -0800
Message-Id: <1258094104417-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091113063439.GA560@linux.vnet.ibm.com>
References: <20091113063439.GA560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier fix for a race resulted in a situation where the CPUs other
than the CPU that detected the end of the grace period would not process
their callbacks until the next grace period started.  This means that
these other CPUs would unnecessarily demand that an extra grace period
be started.  This patch eliminates this extra grace period and speeds
callback processing by propagating rsp->completed to the rcu_node
structures in the case where the CPU detecting the end of the grace
period sees no reason to start a new grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2f5d8c5..0490371 100644
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
 
-- 
1.5.2.5

