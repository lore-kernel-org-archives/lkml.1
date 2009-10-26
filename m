Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZJZCED (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 25 Oct 2009 22:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZJZCEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:04:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38003 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZJZCD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:03:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
        mtosatti@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcu: add synchronize_srcu_expedited() to the rcutorture test suite
Date: Sun, 25 Oct 2009 19:03:52 -0700
Message-Id: <12565226353636-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091026020253.GA11350@linux.vnet.ibm.com>
References: <20091026020253.GA11350@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Adds the "srcu_expedited" torture type, and also renames sched_ops_sync
to sched_sync_ops for consistency while we are in this file.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 697c0a0..14480e8 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -547,6 +547,25 @@ static struct rcu_torture_ops srcu_ops = {
 	.name		= "srcu"
 };
 
+static void srcu_torture_synchronize_expedited(void)
+{
+	synchronize_srcu_expedited(&srcu_ctl);
+}
+
+static struct rcu_torture_ops srcu_expedited_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize_expedited,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_expedited"
+};
+
 /*
  * Definitions for sched torture testing.
  */
@@ -592,7 +611,7 @@ static struct rcu_torture_ops sched_ops = {
 	.name		= "sched"
 };
 
-static struct rcu_torture_ops sched_ops_sync = {
+static struct rcu_torture_ops sched_sync_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
@@ -1098,8 +1117,8 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-		  &sched_expedited_ops,
-		  &srcu_ops, &sched_ops, &sched_ops_sync, };
+		  &srcu_ops, &srcu_expedited_ops,
+		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
 
-- 
1.5.2.5

