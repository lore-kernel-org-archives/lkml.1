Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZDNQna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZDNQna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZDNQnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:43:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:58113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZDNQnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:43:19 -0400
Date: Tue, 14 Apr 2009 16:42:36 GMT
From: tip-bot for Jiri Pirko <jpirko@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu, jpirko@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, jpirko@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090414153356.GC3999@psychotron.englab.brq.redhat.com>
References: <20090414153356.GC3999@psychotron.englab.brq.redhat.com>
Subject: [tip:core/rcu] rculist.h: introduce list_entry_rcu() and list_first_entry_rcu()
Message-ID: <tip-72c6a9870f901045f2464c3dc6ee8914bfdc07aa@git.kernel.org>
Git-Commit-ID: 72c6a9870f901045f2464c3dc6ee8914bfdc07aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 16:42:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72c6a9870f901045f2464c3dc6ee8914bfdc07aa
Gitweb:     http://git.kernel.org/tip/72c6a9870f901045f2464c3dc6ee8914bfdc07aa
Author:     Jiri Pirko <jpirko@redhat.com>
AuthorDate: Tue, 14 Apr 2009 17:33:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 18:41:15 +0200

rculist.h: introduce list_entry_rcu() and list_first_entry_rcu()

I've run into the situation where I need to use list_first_entry with
rcu-guarded list. This patch introduces this.

Also simplify list_for_each_entry_rcu() to use new list_entry_rcu()
instead of list_entry().

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: dipankar@in.ibm.com
LKML-Reference: <20090414153356.GC3999@psychotron.englab.brq.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rculist.h |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e649bd3..5710f43 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -198,6 +198,32 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	at->prev = last;
 }
 
+/**
+ * list_entry_rcu - get the struct for this entry
+ * @ptr:        the &struct list_head pointer.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_entry_rcu(ptr, type, member) \
+	container_of(rcu_dereference(ptr), type, member)
+
+/**
+ * list_first_entry_rcu - get the first element from a list
+ * @ptr:        the list head to take the element from.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_first_entry_rcu(ptr, type, member) \
+	list_entry_rcu((ptr)->next, type, member)
+
 #define __list_for_each_rcu(pos, head) \
 	for (pos = rcu_dereference((head)->next); \
 		pos != (head); \
@@ -214,9 +240,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
+	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
 		prefetch(pos->member.next), &pos->member != (head); \
-		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
+		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 
 /**
