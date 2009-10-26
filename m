Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZJZRai (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 26 Oct 2009 13:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZJZRah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:30:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55498 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZJZRah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:30:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/1] rcu: Simplify creating of lockdep class for root rcu_node
Date: Mon, 26 Oct 2009 10:24:31 -0700
Message-Id: <1256577871443-git-send-email->
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Use lockdep_set_class() to simplify the code and to avoid any additional
overhead in the !LOCKDEP case.  Also move the definition of rcu_root_class
into kernel/rcutree.c, as suggested by Lai Jiangshan.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ddbf111..055f1a9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -51,6 +51,8 @@
 
 /* Data structures. */
 
+static struct lock_class_key rcu_root_class;
+
 #define RCU_STATE_INITIALIZER(name) { \
 	.level = { &name.node[0] }, \
 	.levelcnt = { \
@@ -1666,8 +1668,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			if (rnp != rcu_get_root(rsp))
-				spin_lock_init(&rnp->lock);
+			spin_lock_init(&rnp->lock);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1690,7 +1691,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
-	spin_lock_init(&rcu_get_root(rsp)->lock);
+	lockdep_set_class(&rcu_get_root(rsp)->lock, &rcu_root_class);
 }
 
 /*
-- 
1.5.2.5

