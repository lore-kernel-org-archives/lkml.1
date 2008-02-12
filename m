Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYBLBST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYBLBST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYBLBSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:18:09 -0500
Received: from mail.vyatta.com ([216.93.170.194]:41903 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYBLBSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:18:08 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.727
Date: Mon, 11 Feb 2008 17:18:03 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fib_trie: rcu_assign_pointer warning fix
Message-ID: <20080211171803.6fec191a@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate warnings when rcu_assign_pointer is used with unsigned long.
It is reasonable to use RCU with non-pointer values so allow it for general
use.  Add a comment to explain the if test.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
 include/linux/rcupdate.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 37a642c..c44ac87 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -172,14 +172,15 @@ struct rcu_head {
  * structure after the pointer assignment.  More importantly, this
  * call documents which pointers will be dereferenced by RCU read-side
  * code.
+ *
+ * If value is the NULL (constant 0), then no barrier is needed.
  */
 
-#define rcu_assign_pointer(p, v) \
-	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
-		(p) = (v); \
+#define rcu_assign_pointer(p, v)			\
+	({						\
+		if (!(__builtin_constant_p(v) && v))	\
+			smp_wmb();			\
+		(p) = (v);				\
 	})
 
 /**
-- 
1.5.3.8

