Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZJZCEI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 25 Oct 2009 22:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZJZCEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:04:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52051 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbZJZCEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:04:00 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
        mtosatti@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/6] rcu: Simplify creating of lockdep class for root rcu_node
Date: Sun, 25 Oct 2009 19:03:55 -0700
Message-Id: <12565226351797-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091026020253.GA11350@linux.vnet.ibm.com>
References: <20091026020253.GA11350@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Use lockdep_set_class() to simplify the code and to avoid any additional
overhead in the !LOCKDEP case.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    5 ++---
 kernel/rcutree.h |    2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ddbf111..f57c32e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1666,8 +1666,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			if (rnp != rcu_get_root(rsp))
-				spin_lock_init(&rnp->lock);
+			spin_lock_init(&rnp->lock);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1690,7 +1689,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
-	spin_lock_init(&rcu_get_root(rsp)->lock);
+	lockdep_set_class(&rcu_get_root(rsp)->lock, &rcu_root_class);
 }
 
 /*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 599161f..e091b30 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -296,6 +296,8 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 
 #else /* #ifdef RCU_TREE_NONCORE */
 
+static struct lock_class_key rcu_root_class;
+
 /* Forward declarations for rcutree_plugin.h */
 static inline void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
-- 
1.5.2.5

