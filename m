Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0AEAEO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 19:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481Ab0AEAEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:04:12 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38870 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab0AEAEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:04:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: give different levels of the rcu_node hierarchy distinct lockdep names
Date: Mon,  4 Jan 2010 16:04:02 -0800
Message-Id: <12626498421830-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100105000337.GA23307@linux.vnet.ibm.com>
References: <20100105000337.GA23307@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Previously, each level of the rcu_node hierarchy had the same rather
unimaginative name: "&rcu_node_class[i]".  This makes lockdep diagnostics
involving these lockdep classes less helpful than would be nice.
This patch fixes this by giving each level of the rcu_node hierarchy
a distinct name: "rcu_node_level_0", "rcu_node_level_1", and so on.
This version of the patch includes improved diagnostics suggested by
Josh Triplett and Peter Zijlstra.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0a4c328..3b13d64 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1811,11 +1811,17 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
  */
 static void __init rcu_init_one(struct rcu_state *rsp)
 {
+	static char *buf[] = { "rcu_node_level_0",
+			       "rcu_node_level_1",
+			       "rcu_node_level_2",
+			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
 	struct rcu_node *rnp;
 
+	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
+
 	/* Initialize the level-tracking arrays. */
 
 	for (i = 1; i < NUM_RCU_LVLS; i++)
@@ -1829,7 +1835,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
 			spin_lock_init(&rnp->lock);
-			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
+			lockdep_set_class_and_name(&rnp->lock,
+						   &rcu_node_class[i], buf[i]);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
-- 
1.5.2.5

