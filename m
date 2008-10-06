Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbYJFTqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbYJFTqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYJFTp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:45:59 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:53658 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYJFTp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:45:57 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 15:45:57 EDT
Date: Mon, 06 Oct 2008 13:45:33 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 1/3] Add hlist_for_each_entry_from_rcu
To: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Reply-to: minyard@acm.org
Message-id: <20081006184532.GA10271@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an RCU version of hlist_for_each_entry_from, getting ready for
converting the UDP hash lock to RCU.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 include/linux/rculist.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index eb4443c..f20fe61 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -397,5 +397,23 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference(pos->next))
 
+
+/**
+ * hlist_for_each_entry_from_rcu - iterate over rcu list starting from pos
+ * @tpos:      the type * to use as a loop cursor.
+ * @pos:       the &struct hlist_node to use as a loop cursor.
+ * @member:    the name of the hlist_node within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_head_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define hlist_for_each_entry_from_rcu(tpos, pos, member)                \
+	for (;                                                          \
+	     (pos) && ({ prefetch(pos->next); 1; }) &&    \
+	       ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = rcu_dereference(pos->next))
+
+
 #endif	/* __KERNEL__ */
 #endif
-- 
1.5.6.5

