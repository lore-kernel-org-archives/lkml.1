Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbZLOXNX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934241AbZLOXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:13:10 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33551 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934184AbZLOXCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 02/18] rcu: adjust force_quiescent_state() locking, step 2
Date: Tue, 15 Dec 2009 15:02:25 -0800
Message-Id: <12609181611638-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

This patch releases rnp->lock after the end of force_quiescent_state()'s
switch statement.  This is a second step towards prohibiting starting
grace periods while force_quiescent_state() is executing, which will
reduce the number and complexity of races that force_quiescent_state()
is involved in.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index eae331d..d42ad30 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1219,7 +1219,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
-		spin_unlock(&rnp->lock);
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
@@ -1246,10 +1245,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			rsp->completed_fqs = lastcomp;
 			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
-		if (!forcenow) {
-			spin_unlock(&rnp->lock);
+		if (!forcenow)
 			break;
-		}
 		/* fall into next case. */
 
 	case RCU_FORCE_QS:
@@ -1262,14 +1259,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Leave state in case more forcing is required. */
 
-		break;
-
-	default:
-
-		spin_unlock(&rnp->lock);
-		WARN_ON_ONCE(1);
+		spin_lock(&rnp->lock);
 		break;
 	}
+	spin_unlock(&rnp->lock);
 unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
-- 
1.5.2.5

