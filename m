Return-Path: <linux-kernel-owner+w=401wt.eu-S965780AbXIGOdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780AbXIGOdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965398AbXIGOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:33:25 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:48994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374AbXIGOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:33:24 -0400
Subject: [PATCH] list.h: add list_for_each_entry_continue_rcu
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Pavel Emelianov <xemul@openvz.org>, Zach Brown <zach.brown@oracle.com>,
       Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 16:34:48 +0200
Message-Id: <1189175688.28781.167.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To implement the multicast list callback in mac80211 we need to
do partial list iteration. Since I want to convert the interface
list to an RCU list, I need a new list walking primitive:
list_for_each_entry_continue_rcu().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---
How do we want to handle this? Is it ok to push this via net-2.6.24 so
we can merge it along with the fix that needs it?

 include/linux/list.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- wireless-dev.orig/include/linux/list.h	2007-09-07 00:16:07.374444290 +0200
+++ wireless-dev/include/linux/list.h	2007-08-29 21:08:14.802054000 +0200
@@ -665,6 +665,26 @@ static inline void list_splice_init_rcu(
 		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
         	(pos) = (pos)->next)
 
+
+/**
+ * list_for_each_entry_continue_rcu - continue iteration over rcu list
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Continue to iterate over rcu list of given type, continuing after
+ * the current position.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_entry_continue_rcu(pos, head, member) \
+	for ((pos) = list_entry((pos)->member.next, typeof(*pos), member); \
+		prefetch(rcu_dereference((pos))->member.next), \
+			 &pos->member != (head); \
+        	(pos) = list_entry(pos->member.next, typeof(*pos), member))
+
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is


