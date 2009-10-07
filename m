Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZJGGS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZJGGS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZJGGSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:18:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZJGGSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:18:24 -0400
Date: Wed, 7 Oct 2009 06:17:21 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12548908983277-git-send-email->
References: <12548908983277-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Place root rcu_node structure in separate lockdep class
Message-ID: <tip-978c0b88146a7f9b364b71b5b83c5b12e7b413d7@git.kernel.org>
Git-Commit-ID: 978c0b88146a7f9b364b71b5b83c5b12e7b413d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 06:17:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  978c0b88146a7f9b364b71b5b83c5b12e7b413d7
Gitweb:     http://git.kernel.org/tip/978c0b88146a7f9b364b71b5b83c5b12e7b413d7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 6 Oct 2009 21:48:18 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Oct 2009 08:11:21 +0200

rcu: Place root rcu_node structure in separate lockdep class

Before this patch, all of the rcu_node structures were in the same lockdep
class, so that lockdep would complain when rcu_preempt_offline_tasks()
acquired the root rcu_node structure's lock while holding one of the leaf
rcu_nodes' locks.

This patch changes rcu_init_one() to use a separate
spin_lock_init() for the root rcu_node structure's lock than is
used for that of all of the rest of the rcu_node structures, which
puts the root rcu_node structure's lock in its own lockdep class.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12548908983277-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
