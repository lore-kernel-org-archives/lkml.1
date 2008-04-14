Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYDNEEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYDNEEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYDNEDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:03:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34483 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbYDNEDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:03:50 -0400
Date: Sun, 13 Apr 2008 21:03:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: [PATCH 4/5] Add call_rcu_sched() and friends to rcutorture
Message-ID: <20080414040343.GD30495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080414035848.GA30005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414035848.GA30005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry to rcu_torture_ops allowing the correct barrier function to
be used upon exit from rcutorture.  Also add torture options for the
new call_rcu_sched() API.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc6-C3-rcu_barrier_sched/kernel/rcutorture.c linux-2.6.25-rc6-C4-rcutorture/kernel/rcutorture.c
--- linux-2.6.25-rc6-C3-rcu_barrier_sched/kernel/rcutorture.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-C4-rcutorture/kernel/rcutorture.c	2008-04-09 16:39:14.000000000 -0700
@@ -191,6 +191,7 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferredfree)(struct rcu_torture *p);
 	void (*sync)(void);
+	void (*cb_barrier)(void);
 	int (*stats)(char *page);
 	char *name;
 };
@@ -264,6 +265,7 @@ static struct rcu_torture_ops rcu_ops = 
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = rcu_barrier,
 	.stats = NULL,
 	.name = "rcu"
 };
@@ -303,6 +305,7 @@ static struct rcu_torture_ops rcu_sync_o
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = NULL,
 	.stats = NULL,
 	.name = "rcu_sync"
 };
@@ -363,6 +366,7 @@ static struct rcu_torture_ops rcu_bh_ops
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_bh_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = rcu_barrier_bh,
 	.stats = NULL,
 	.name = "rcu_bh"
 };
@@ -376,6 +380,7 @@ static struct rcu_torture_ops rcu_bh_syn
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = NULL,
 	.name = "rcu_bh_sync"
 };
@@ -457,6 +462,7 @@ static struct rcu_torture_ops srcu_ops =
 	.completed = srcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = srcu_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = srcu_torture_stats,
 	.name = "srcu"
 };
@@ -481,6 +487,11 @@ static int sched_torture_completed(void)
 	return 0;
 }
 
+static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
+{
+	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
+}
+
 static void sched_torture_synchronize(void)
 {
 	synchronize_sched();
@@ -493,12 +504,27 @@ static struct rcu_torture_ops sched_ops 
 	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock = sched_torture_read_unlock,
 	.completed = sched_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
+	.deferredfree = rcu_sched_torture_deferred_free,
 	.sync = sched_torture_synchronize,
+	.cb_barrier = rcu_barrier_sched,
 	.stats = NULL,
 	.name = "sched"
 };
 
+static struct rcu_torture_ops sched_ops_sync = {
+	.init = rcu_sync_torture_init,
+	.cleanup = NULL,
+	.readlock = sched_torture_read_lock,
+	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock = sched_torture_read_unlock,
+	.completed = sched_torture_completed,
+	.deferredfree = rcu_sync_torture_deferred_free,
+	.sync = sched_torture_synchronize,
+	.cb_barrier = NULL,
+	.stats = NULL,
+	.name = "sched_sync"
+};
+
 /*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
@@ -844,7 +870,9 @@ rcu_torture_cleanup(void)
 	stats_task = NULL;
 
 	/* Wait for all RCU callbacks to fire.  */
-	rcu_barrier();
+
+	if (cur_ops->cb_barrier != NULL)
+		cur_ops->cb_barrier();
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
@@ -864,7 +892,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-		  &srcu_ops, &sched_ops, };
+		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
