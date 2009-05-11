Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbZEKMkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbZEKMkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZEKMjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:44 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:35470 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbZEKMjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:43 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH PATCH 4/6] lockdep: Seperate lock ids for read/write
	acquires.
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:46 +0530
Message-ID: <20090511123946.31159.72380.stgit@sofia.in.ibm.com>
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key of a dependency chain is obtained from the keys of the locks
involved in the dependency chains. The keys of the locks are defined
as their lock_class id's. Since we don't distinguish between the read/write
acquire of a particular lock, we get the same key's for two different
chains involving the same locks in the same dependency order, but in
different read/write states.
Eg:

	lock(A) ---> Rlock(B)
	lock(A) ---> Wlock(B)

Fix this by distinguishing between the read/write acquires of a lock
by defining the lock's key as follows:
	class_id + is_read_lock(lock) * MAX_LOCKDEP_KEYS.

Thus for the purpose of chain key calculation, a lock's key can be in
the range 1 to 2*MAX_LOCKDEP_KEYS - 1.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/lockdep.h |   14 ++++++++++++++
 kernel/lockdep.c        |   19 +++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 161deee..98cb434 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -163,6 +163,7 @@ struct lock_chain {
 };
 
 #define MAX_LOCKDEP_KEYS_BITS		13
+
 /*
  * Subtract one because we offset hlock->class_idx by 1 in order
  * to make 0 mean no class. This avoids overflowing the class_idx
@@ -170,6 +171,19 @@ struct lock_chain {
  */
 #define MAX_LOCKDEP_KEYS		((1UL << MAX_LOCKDEP_KEYS_BITS) - 1)
 
+/*
+ * A lock's class id is used to calculate the chain-key. Since we need to
+ * differentiate between the chains which contain the read acquire of
+ * a lock from the chains having write acquire of the same lock,
+ * we offset the class_idx by  MAX_LOCKDEP_KEYS if it is a read acquire.
+ *
+ * Thus the the lock's key during a chain-key calculation can be in the range
+ * 1 to 2 * MAX_LOCKDEP_KEYS - 1.
+ *
+ * LOCKDEP_CHAIN_KEY_BITS holds the number of bits required to
+ * represent this range.
+ */
+#define LOCKDEP_CHAIN_KEY_BITS	(MAX_LOCKDEP_KEYS_BITS + 1)
 struct held_lock {
 	/*
 	 * One-way hash of the dependency chain up to this point. We
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5f92ea4..c644af8 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -286,8 +286,8 @@ static struct list_head chainhash_table[CHAINHASH_SIZE];
  * unique.
  */
 #define iterate_chain_key(key1, key2) \
-	(((key1) << MAX_LOCKDEP_KEYS_BITS) ^ \
-	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
+	(((key1) << LOCKDEP_CHAIN_KEY_BITS) ^ \
+	((key1) >> (64 - LOCKDEP_CHAIN_KEY_BITS)) ^ \
 	(key2))
 
 void lockdep_off(void)
@@ -1802,6 +1802,9 @@ static void check_chain_key(struct task_struct *curr)
 		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 			return;
 
+		if (is_read(hlock->rw_state))
+			id += MAX_LOCKDEP_KEYS;
+
 		if (prev_hlock && (prev_hlock->irq_context !=
 							hlock->irq_context))
 			chain_key = 0;
@@ -2614,6 +2617,18 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 		return 0;
 
+	/*
+	 * Factor in the read/write state in the chain key calculation.
+	 *
+	 * Two chain containing lock dependencies in the same order can
+	 * still differ due to their read/write state
+	 * eg: lock(A)->Rlock(B) is different from lock(A)->Wlock(B)
+	 *
+	 * Hence distinguish between such chains.
+	 */
+	if (is_read(rw_state))
+		id += MAX_LOCKDEP_KEYS;
+
 	chain_key = curr->curr_chain_key;
 	if (!depth) {
 		if (DEBUG_LOCKS_WARN_ON(chain_key != 0))

