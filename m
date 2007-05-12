Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbXELQg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbXELQg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXELQgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:36:53 -0400
Received: from newmail.sw.starentnetworks.com ([12.33.234.78]:44291 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbXELQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:36:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17989.60703.575698.491592@zeus.sw.starentnetworks.com>
Date: Sat, 12 May 2007 12:36:47 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] improved locking performance in rt_run_flush()
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While testing adding/deleting large numbers of interfaces, I found
rt_run_flush() was the #1 cpu user in a kernel profile by far.

The below patch changes rt_run_flush() to only take each spinlock
protecting the rt_hash_table once instead of taking a spinlock for
every hash table bucket (and ending up taking the same small set 
of locks over and over).

Deleting 256 interfaces on a 4-way SMP system with 16K buckets reduced
overall cpu-time more than 50% and reduced wall-time about 33%.  I
suspect systems with large amounts of memory (and more buckets) will
see an even greater benefit.

Note there is a small change in that rt_free() is called while the
lock is held where before it was called without the lock held.  I
don't think this should be an issue.

Signed-off-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>

===== net/ipv4/route.c 1.162 vs edited =====
--- 1.162/net/ipv4/route.c	2007-02-14 11:09:54 -05:00
+++ edited/net/ipv4/route.c	2007-05-04 17:53:33 -04:00
@@ -237,9 +237,17 @@
 		for (i = 0; i < RT_HASH_LOCK_SZ; i++) \
 			spin_lock_init(&rt_hash_locks[i]); \
 		}
+# define rt_hash_lock_for_each(lockaddr) \
+	for (lockaddr = rt_hash_lock_addr(RT_HASH_LOCK_SZ-1); lockaddr >= rt_hash_locks; lockaddr--)
+# define rt_hash_lock_for_each_item(locknum, slot) \
+	for (slot = locknum-rt_hash_locks; slot <= rt_hash_mask; slot += RT_HASH_LOCK_SZ)
 #else
 # define rt_hash_lock_addr(slot) NULL
 # define rt_hash_lock_init()
+# define rt_hash_lock_for_each(lockaddr) \
+	lockaddr = NULL;
+# define rt_hash_lock_for_each_item(locknum, slot) \
+	for (slot = rt_hash_mask; slot >= 0; slot--)
 #endif
 
 static struct rt_hash_bucket 	*rt_hash_table;
@@ -691,23 +699,26 @@
 static void rt_run_flush(unsigned long dummy)
 {
 	int i;
+	spinlock_t *lockaddr;
 	struct rtable *rth, *next;
 
 	rt_deadline = 0;
 
 	get_random_bytes(&rt_hash_rnd, 4);
 
-	for (i = rt_hash_mask; i >= 0; i--) {
-		spin_lock_bh(rt_hash_lock_addr(i));
-		rth = rt_hash_table[i].chain;
-		if (rth)
-			rt_hash_table[i].chain = NULL;
-		spin_unlock_bh(rt_hash_lock_addr(i));
-
-		for (; rth; rth = next) {
-			next = rth->u.dst.rt_next;
-			rt_free(rth);
+	rt_hash_lock_for_each(lockaddr) {
+		spin_lock_bh(lockaddr);
+		rt_hash_lock_for_each_item(lockaddr, i) {
+			rth = rt_hash_table[i].chain;
+			if (rth) {
+				rt_hash_table[i].chain = NULL;
+				for (; rth; rth = next) {
+					next = rth->u.dst.rt_next;
+					rt_free(rth);
+				}
+			}
 		}
+		spin_unlock_bh(lockaddr);
 	}
 }
 

