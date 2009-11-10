Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbZKJVhL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 10 Nov 2009 16:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZKJVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:37:10 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56166 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282AbZKJVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:37:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcu: simplify association of quiescent states with grace periods
Date: Tue, 10 Nov 2009 13:37:22 -0800
Message-Id: <12578890421011-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091110213651.GA21411@linux.vnet.ibm.com>
References: <20091110213651.GA21411@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The rdp->passed_quiesc_completed fields are used to properly associate
the recorded quiescent state with a grace period.  It is OK to wrongly
associate a given quiescent state with a preceding grace period, but it
is fatal to associate a given quiescent state with a grace period
that begins after the quiescent state occurred.  Grace periods are
numbered, and the following fields track them:

o	->gpnum is the number of the grace period currently in progress,
	or the number of the last grace period to complete if no grace
	period is currently in progress.

o	->completed is the number of the last grace period to have
	completed.

These two fields are equal if there is no grace period in progress,
otherwise ->gpnum is one greater than ->completed.  But the
rdp->passed_quiesc_completed field compared against ->completed,
and if equal, the quiescent state is presumed to count against the
current grace period.

The earlier code copied rdp->completed to rdp->passed_quiesc_completed,
which has been made to work, but is error-prone.  In contrast, copying
one less than rdp->gpnum is guaranteed safe, because rdp->gpnum is not
incremented until after the start of the corresponding grace period.
At the end of the grace period, when ->completed has incremented, then
any quiescent periods recorded previously will be discarded.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    4 ++--
 kernel/rcutree_plugin.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4026560..2f5d8c5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -100,7 +100,7 @@ void rcu_sched_qs(int cpu)
 	struct rcu_data *rdp;
 
 	rdp = &per_cpu(rcu_sched_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 	rcu_preempt_note_context_switch(cpu);
@@ -111,7 +111,7 @@ void rcu_bh_qs(int cpu)
 	struct rcu_data *rdp;
 
 	rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9744dfc..b7dc0c2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -67,7 +67,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
 static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
-- 
1.5.2.5

