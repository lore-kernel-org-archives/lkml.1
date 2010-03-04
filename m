Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0CDBu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:50:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52023 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab0CDBuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:50:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: suppress __mpol_dup() false positive from RCU lockdep
Date: Wed,  3 Mar 2010 17:50:17 -0800
Message-Id: <1267667418-32233-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100304015001.GA32190@linux.vnet.ibm.com>
References: <20100304015001.GA32190@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common code is used during task creation and after the task has started
running.  RCU protection is not needed during task creation because no
other CPU has access to the under-construction task.  Provide the RCU
protection anyway to suppress the false positive, as there does not
appear to be a good way for the common code to recognize that the task
is only accessible to the CPU creating it.

Cc: Paul Menage <menage@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 mm/mempolicy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 290fb5b..3cec080 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1730,10 +1730,12 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 
 	if (!new)
 		return ERR_PTR(-ENOMEM);
+	rcu_read_lock();
 	if (current_cpuset_is_being_rebound()) {
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(old, &mems);
 	}
+	rcu_read_unlock();
 	*new = *old;
 	atomic_set(&new->refcnt, 1);
 	return new;
-- 
1.6.6

