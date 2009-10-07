Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZJGEtB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 7 Oct 2009 00:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZJGEs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:48:59 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41702 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZJGEs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:48:58 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: place root rcu_node structure in separate lockdep class
Date: Tue,  6 Oct 2009 21:48:18 -0700
Message-Id: <12548908983277-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091007044748.GA12763@linux.vnet.ibm.com>
References: <20091007044748.GA12763@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Before this patch, all of the rcu_node structures were in the same lockdep
class, so that lockdep would complain when rcu_preempt_offline_tasks()
acquired the root rcu_node structure's lock while holding one of the leaf
rcu_nodes' locks.  This patch changes rcu_init_one() to use a separate
spin_lock_init() for the root rcu_node structure's lock than is used for
that of all of the rest of the rcu_node structures, which puts the root
rcu_node structure's lock in its own lockdep class.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d8d9865..705f02a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1647,7 +1647,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			spin_lock_init(&rnp->lock);
+			if (rnp != rcu_get_root(rsp))
+				spin_lock_init(&rnp->lock);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1670,6 +1671,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
+	spin_lock_init(&rcu_get_root(rsp)->lock);
 }
 
 /*
-- 
1.5.2.5

