Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZDNPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZDNPe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZDNPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:34:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbZDNPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:34:20 -0400
Date: Tue, 14 Apr 2009 17:33:57 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: [PATCH] rculist.h: introduce list_entry_rcu and
	list_first_entry_rcu
Message-ID: <20090414153356.GC3999@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've run into the situation where I need to use list_first_entry with
rcu-guarded list. This patch introduces this. Also changed
list_for_each_entry_rcu to use new list_entry_rcu instead of list_entry.

Jirka

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
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
-- 
1.6.0.6

