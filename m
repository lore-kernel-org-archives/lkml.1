Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbZLOXQP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761936AbZLOXPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:15:42 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44975 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934168AbZLOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 10/18] rcu: make force_quiescent_state() start grace period if needed
Date: Tue, 15 Dec 2009 15:02:33 -0800
Message-Id: <12609181613597-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

Grace periods cannot be started while force_quiescent_state() is
active.  This is OK in that the affected CPUs will try again later,
but it does induce needless grace-period delays.  This patch causes
rcu_start_gp() to record a failed attempt to start a grace period.
When force_quiescent_state() prepares to return, it then starts the
grace period if there was such a failed attempt.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    8 ++++++++
 kernel/rcutree.h |    5 +++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d920285..55e8f6e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -660,6 +660,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
+		if (cpu_needs_another_gp(rsp, rdp))
+			rsp->fqs_need_gp = 1;
 		if (rnp->completed == rsp->completed) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
@@ -1239,6 +1241,12 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		break;
 	}
 	rsp->fqs_active = 0;
+	if (rsp->fqs_need_gp) {
+		spin_unlock(&rsp->fqslock); /* irqs remain disabled */
+		rsp->fqs_need_gp = 0;
+		rcu_start_gp(rsp, flags); /* releases rnp->lock */
+		return;
+	}
 	spin_unlock(&rnp->lock);  /* irqs remain disabled */
 unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index edb6fae..bd5d78a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -278,6 +278,11 @@ struct rcu_state {
 						/* Force QS state. */
 	u8	fqs_active;			/* force_quiescent_state() */
 						/*  is running. */
+	u8	fqs_need_gp;			/* A CPU was prevented from */
+						/*  starting a new grace */
+						/*  period because */
+						/*  force_quiescent_state() */
+						/*  was running. */
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
 
-- 
1.5.2.5

