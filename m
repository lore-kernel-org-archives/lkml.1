Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZJ0HtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZJ0HtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZJ0HtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:49:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbZJ0HtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:49:15 -0400
Date: Tue, 27 Oct 2009 07:48:41 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1256577871443-git-send-email->
References: <1256577871443-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Simplify creating of lockdep class for root rcu_node
Message-ID: <tip-88b91c7ca49bc8600cf1106eb891d08c1965b9ce@git.kernel.org>
Git-Commit-ID: 88b91c7ca49bc8600cf1106eb891d08c1965b9ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88b91c7ca49bc8600cf1106eb891d08c1965b9ce
Gitweb:     http://git.kernel.org/tip/88b91c7ca49bc8600cf1106eb891d08c1965b9ce
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 26 Oct 2009 10:24:31 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 21:07:16 +0100

rcu: Simplify creating of lockdep class for root rcu_node

Use lockdep_set_class() to simplify the code and to avoid any
additional overhead in the !LOCKDEP case.  Also move the
definition of rcu_root_class into kernel/rcutree.c, as suggested
by Lai Jiangshan.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1256577871443-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
