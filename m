Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYHGU55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYHGU55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYHGU5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:57:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:65467 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYHGU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=rQh39XYd9WM4AlOm/zV08ojzI/CLCltllJtEytlSIWYCUyEzjOo9S8CJMbQ+VqDGjv
         hK6gWdE5fkujJNebw6wj8tZuHXF/e03PkEeR62YrSQW6lVr4gpLepvAOPviV9cOqplch
         96DorLjGO2JbWhcYORSzk8uxlJ+mffmUkUom0=
Date: Fri, 8 Aug 2008 02:27:29 +0530
From: Rabin Vincent <rabin@rab.in>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
       ying.huang@intel.com
Subject: [PATCH] lockdep: handle chains involving classes defined in modules
Message-ID: <20080807205729.GB1747@debian>
References: <20080806121650.GA3119@alice> <20080806124134.GA3615@alice> <20080807205340.GA1747@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807205340.GA1747@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/lockdep_chains currently oopses after any module which creates and
uses a lock is unloaded.  This is because one of the chains involves a
class which was defined in the module just unloaded.

The classes are already correctly taken care of using the
all_lock_classes which keeps track of all active lock classses.  Add a
similar all_lock_chains list and use it for keeping track of chains.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/lockdep.h    |    3 +-
 kernel/lockdep.c           |   53 ++++++++++++++++++++++++++++++++++++++-----
 kernel/lockdep_internals.h |    2 +-
 kernel/lockdep_proc.c      |   17 ++++++++++----
 4 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2486eb4..735d06b 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -185,7 +185,8 @@ struct lock_chain {
 	u8				irq_context;
 	u8				depth;
 	u16				base;
-	struct list_head		entry;
+	struct list_head		hash_entry;
+	struct list_head		lock_entry;
 	u64				chain_key;
 };
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d38a643..1b3537b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -253,6 +253,11 @@ LIST_HEAD(all_lock_classes);
 static struct list_head classhash_table[CLASSHASH_SIZE];
 
 /*
+ * We also keep a global list of all lock chains.
+ */
+LIST_HEAD(all_lock_chains);
+
+/*
  * We put the lock dependency chains into a hash-table as well, to cache
  * their existence:
  */
@@ -1462,7 +1467,7 @@ out_bug:
 }
 
 unsigned long nr_lock_chains;
-struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
 int nr_chain_hlocks;
 static u16 chain_hlocks[MAX_LOCKDEP_CHAIN_HLOCKS];
 
@@ -1493,7 +1498,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	 * We can walk it lock-free, because entries only get added
 	 * to the hash:
 	 */
-	list_for_each_entry(chain, hash_head, entry) {
+	list_for_each_entry(chain, hash_head, hash_entry) {
 		if (chain->chain_key == chain_key) {
 cache_hit:
 			debug_atomic_inc(&chain_lookup_hits);
@@ -1517,7 +1522,7 @@ cache_hit:
 	/*
 	 * We have to walk the chain again locked - to avoid duplicates:
 	 */
-	list_for_each_entry(chain, hash_head, entry) {
+	list_for_each_entry(chain, hash_head, hash_entry) {
 		if (chain->chain_key == chain_key) {
 			graph_unlock();
 			goto cache_hit;
@@ -1559,7 +1564,8 @@ cache_hit:
 		}
 		chain_hlocks[chain->base + j] = class - lock_classes;
 	}
-	list_add_tail_rcu(&chain->entry, hash_head);
+	list_add_tail_rcu(&chain->hash_entry, hash_head);
+	list_add_tail_rcu(&chain->lock_entry, &all_lock_chains);
 	debug_atomic_inc(&chain_lookup_misses);
 	inc_chains();
 
@@ -2967,6 +2973,8 @@ void lockdep_reset(void)
 	debug_locks = 1;
 	for (i = 0; i < CHAINHASH_SIZE; i++)
 		INIT_LIST_HEAD(chainhash_table + i);
+	for (i = 0; i < CLASSHASH_SIZE; i++)
+		INIT_LIST_HEAD(classhash_table + i);
 	raw_local_irq_restore(flags);
 }
 
@@ -2990,6 +2998,15 @@ static void zap_class(struct lock_class *class)
 
 }
 
+static void zap_chain(struct lock_chain *chain)
+{
+	/*
+	 * Unhash the chain and remove it from the all_lock_chains list:
+	 */
+	list_del_rcu(&chain->hash_entry);
+	list_del_rcu(&chain->lock_entry);
+}
+
 static inline int within(const void *addr, void *start, unsigned long size)
 {
 	return addr >= start && addr < start + size;
@@ -2997,23 +3014,45 @@ static inline int within(const void *addr, void *start, unsigned long size)
 
 void lockdep_free_key_range(void *start, unsigned long size)
 {
-	struct lock_class *class, *next;
+	struct lock_class *class, *nextclass;
+	struct lock_chain *chain, *nextchain;
 	struct list_head *head;
 	unsigned long flags;
-	int i;
+	int i, j;
 	int locked;
 
 	raw_local_irq_save(flags);
 	locked = graph_lock();
 
 	/*
+	 * Unhash all chains that involve classes created by this module:
+	 */
+	for (i = 0; i < CHAINHASH_SIZE; i++) {
+		head = chainhash_table + i;
+		if (list_empty(head))
+			continue;
+		list_for_each_entry_safe(chain, nextchain, head, hash_entry) {
+			for (j = 0; j < chain->depth; j++) {
+				class = lock_classes +
+					chain_hlocks[chain->base + j];
+
+				if (within(class->key, start, size) ||
+					within(class->name, start, size)) {
+					zap_chain(chain);
+					break;
+				}
+			}
+		}
+	}
+
+	/*
 	 * Unhash all classes that were created by this module:
 	 */
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
 		if (list_empty(head))
 			continue;
-		list_for_each_entry_safe(class, next, head, hash_entry) {
+		list_for_each_entry_safe(class, nextclass, head, hash_entry) {
 			if (within(class->key, start, size))
 				zap_class(class);
 			else if (within(class->name, start, size))
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index c3600a0..ebf2ecb 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -32,7 +32,7 @@
 #define MAX_STACK_TRACE_ENTRIES	262144UL
 
 extern struct list_head all_lock_classes;
-extern struct lock_chain lock_chains[];
+extern struct list_head all_lock_chains;
 
 extern void
 get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3, char *c4);
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 9b0e940..4f447fd 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -190,8 +190,9 @@ static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
 	else {
 		chain = v;
 
-		if (*pos < nr_lock_chains)
-			chain = lock_chains + *pos;
+		if (chain->lock_entry.next != &all_lock_chains)
+			chain = list_entry(chain->lock_entry.next,
+					   struct lock_chain, lock_entry);
 		else
 			chain = NULL;
 	}
@@ -201,11 +202,16 @@ static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *lc_start(struct seq_file *m, loff_t *pos)
 {
+	struct lock_chain *chain;
+	loff_t i = 0;
+
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	if (*pos < nr_lock_chains)
-		return lock_chains + *pos;
+	list_for_each_entry(chain, &all_lock_chains, lock_entry) {
+		if (++i == *pos)
+			return chain;
+	}
 
 	return NULL;
 }
@@ -252,7 +258,8 @@ static int lockdep_chains_open(struct inode *inode, struct file *file)
 		struct seq_file *m = file->private_data;
 
 		if (nr_lock_chains)
-			m->private = lock_chains;
+			m->private = list_entry(all_lock_chains.next,
+					struct lock_chain, lock_entry);
 		else
 			m->private = NULL;
 	}
-- 
1.5.6.3
