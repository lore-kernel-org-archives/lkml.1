Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZI1Oqr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 28 Sep 2009 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZI1Oqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:46:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34437 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZI1Oql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:46:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: Apply review feedback from Josh Triplett, part 3
Date: Mon, 28 Sep 2009 07:46:32 -0700
Message-Id: <12541491931164-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090928144551.GA20704@linux.vnet.ibm.com>
References: <20090928144551.GA20704@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitespace fixes, updated comments, and trivial code movement.

o	Fix whitespace error in RCU_HEAD_INIT()

o	Move "So where is rcu_write_lock()" comment so that it does
	not come between the rcu_read_unlock() header comment and
	the rcu_read_unlock() definition.

o	Move the module_param statements for blimit, qhimark, and qlowmark
	to immediately follow the corresponding definitions.

o	In __rcu_offline_cpu(), move the assignment to rdp_me inside the
	"if" statement, given that rdp_me is not used outside of that "if"
	statement.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   14 +++++++-------
 kernel/rcutree.c         |   10 +++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b2f1e10..6dd71fa 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -83,7 +83,7 @@ extern int rcu_scheduler_active;
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
+#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
 #define INIT_RCU_HEAD(ptr) do { \
        (ptr)->next = NULL; (ptr)->func = NULL; \
@@ -135,12 +135,6 @@ static inline void rcu_read_lock(void)
 	rcu_read_acquire();
 }
 
-/**
- * rcu_read_unlock - marks the end of an RCU read-side critical section.
- *
- * See rcu_read_lock() for more information.
- */
-
 /*
  * So where is rcu_write_lock()?  It does not exist, as there is no
  * way for writers to lock out RCU readers.  This is a feature, not
@@ -150,6 +144,12 @@ static inline void rcu_read_lock(void)
  * used as well.  RCU does not care how the writers keep out of each
  * others' way, as long as they do so.
  */
+
+/**
+ * rcu_read_unlock - marks the end of an RCU read-side critical section.
+ *
+ * See rcu_read_lock() for more information.
+ */
 static inline void rcu_read_unlock(void)
 {
 	rcu_read_release();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 45eb2d1..1ccdd5b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -121,6 +121,10 @@ static int blimit = 10;		/* Maximum callbacks per softirq. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
+module_param(blimit, int, 0);
+module_param(qhimark, int, 0);
+module_param(qlowmark, int, 0);
+
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
 
@@ -873,8 +877,8 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	 * indefinitely delay callbacks, you have far worse things to
 	 * be worrying about.
 	 */
-	rdp_me = rsp->rda[smp_processor_id()];
 	if (rdp->nxtlist != NULL) {
+		rdp_me = rsp->rda[smp_processor_id()];
 		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
 		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 		rdp->nxtlist = NULL;
@@ -1570,7 +1574,3 @@ void __init __rcu_init(void)
 }
 
 #include "rcutree_plugin.h"
-
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
-- 
1.5.2.5

