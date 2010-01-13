Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567Ab0AMK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0AMK3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557Ab0AMK3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:29:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:58824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab0AMK3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:29:37 -0500
Date: Wed, 13 Jan 2010 10:29:00 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626570513455-git-send-email->
References: <12626570513455-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Disable lockdep checking in RCU list-traversal primitives
Message-ID: <tip-dd7eec1c517430d5c9cfc94e1a7af24dc273b987@git.kernel.org>
Git-Commit-ID: dd7eec1c517430d5c9cfc94e1a7af24dc273b987
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:29:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd7eec1c517430d5c9cfc94e1a7af24dc273b987
Gitweb:     http://git.kernel.org/tip/dd7eec1c517430d5c9cfc94e1a7af24dc273b987
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 18:04:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:08 +0100

rcu: Disable lockdep checking in RCU list-traversal primitives

The theory is that use of bare rcu_dereference() is more prone
to error than use of the RCU list-traversal primitives.
Therefore, disable lockdep RCU read-side critical-section
checking in these primitives for the time being.  Once all of
the rcu_dereference() uses have been dealt with, it may be time
to re-enable lockdep checking for the RCU list-traversal
primitives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12626570513455-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
