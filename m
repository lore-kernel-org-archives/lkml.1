Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0BWBFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:05:16 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47421 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0BWBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/21] rcu: disable lockdep checking in RCU list-traversal primitives
Date: Mon, 22 Feb 2010 17:04:48 -0800
Message-Id: <1266887105-1528-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The theory is that use of bare rcu_dereference() is more prone to error
than use of the RCU list-traversal primitives.  Therefore, disable lockdep
RCU read-side critical-section checking in these primitives for the time
being.  Once all of the rcu_dereference() uses have been dealt with, it
may be time to re-enable lockdep checking for the RCU list-traversal
primitives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h       |   14 +++++++-------
 include/linux/rculist_nulls.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 1bf0f70..779d707 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -208,7 +208,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_entry_rcu(ptr, type, member) \
-	container_of(rcu_dereference(ptr), type, member)
+	container_of(rcu_dereference_raw(ptr), type, member)
 
 /**
  * list_first_entry_rcu - get the first element from a list
@@ -225,9 +225,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	list_entry_rcu((ptr)->next, type, member)
 
 #define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference((head)->next); \
+	for (pos = rcu_dereference_raw((head)->next); \
 		pos != (head); \
-		pos = rcu_dereference(pos->next))
+		pos = rcu_dereference_raw(pos->next))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
@@ -257,9 +257,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference((pos)->next); \
+	for ((pos) = rcu_dereference_raw((pos)->next); \
 		prefetch((pos)->next), (pos) != (head); \
-		(pos) = rcu_dereference((pos)->next))
+		(pos) = rcu_dereference_raw((pos)->next))
 
 /**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
@@ -418,10 +418,10 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference((head)->first);			 \
+	for (pos = rcu_dereference_raw((head)->first);			 \
 		pos && ({ prefetch(pos->next); 1; }) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference(pos->next))
+		pos = rcu_dereference_raw(pos->next))
 
 #endif	/* __KERNEL__ */
 #endif
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 589a409..b70ffe5 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -101,10 +101,10 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  *
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member) \
-	for (pos = rcu_dereference((head)->first);			 \
+	for (pos = rcu_dereference_raw((head)->first);			 \
 		(!is_a_nulls(pos)) &&			\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference(pos->next))
+		pos = rcu_dereference_raw(pos->next))
 
 #endif
 #endif
-- 
1.6.6

