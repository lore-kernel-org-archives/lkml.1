Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZJZLiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZJZLiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZJZLiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:38:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:57238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbZJZLiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:38:10 -0400
Date: Mon, 26 Oct 2009 11:37:11 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <12565226353636-git-send-email->
References: <12565226353636-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add synchronize_srcu_expedited() to the rcutorture test suite
Message-ID: <tip-804bb8370522a569bd3a732b9de5fbd55e26f155@git.kernel.org>
Git-Commit-ID: 804bb8370522a569bd3a732b9de5fbd55e26f155
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  804bb8370522a569bd3a732b9de5fbd55e26f155
Gitweb:     http://git.kernel.org/tip/804bb8370522a569bd3a732b9de5fbd55e26f155
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 25 Oct 2009 19:03:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 09:40:30 +0100

rcu: Add synchronize_srcu_expedited() to the rcutorture test suite

Adds the "srcu_expedited" torture type, and also renames
sched_ops_sync to sched_sync_ops for consistency while we are in
this file.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: avi@redhat.com
Cc: mtosatti@redhat.com
LKML-Reference: <12565226353636-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
