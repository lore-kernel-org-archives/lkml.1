Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0BXUFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:05:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0BXUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 06/10] audit: __rcu annotations
Date: Wed, 24 Feb 2010 21:04:02 +0100
Message-Id: <1267041846-10469-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX183NKU+gc4nHkG3CJn940BJLSuz4YWuE3Nmuc7
 wXp4FNfoJCvnRqJsOv4rzBUhskCllyPe8tSDzKn694eWzehpk+
 /5Hs4UJQuz70DL2h/Nulg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/audit.c       |    4 ++--
 kernel/audit.h       |    6 +++---
 kernel/audit_tree.c  |   14 +++++++-------
 kernel/auditfilter.c |   28 ++++++++++++++--------------
 kernel/auditsc.c     |    8 ++++----
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 5feed23..6115194 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -116,7 +116,7 @@ static atomic_t    audit_lost = ATOMIC_INIT(0);
 static struct sock *audit_sock;
 
 /* Hash for inode-based rules */
-struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
+struct rcu_list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
 
 /* The audit_freelist is a list of pre-allocated audit buffers (if more
  * than AUDIT_MAXFREE are in use, the audit buffer is freed instead of
@@ -985,7 +985,7 @@ static int __init audit_init(void)
 	audit_log(NULL, GFP_KERNEL, AUDIT_KERNEL, "initialized");
 
 	for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
-		INIT_LIST_HEAD(&audit_inode_hash[i]);
+		INIT_LIST_HEAD_RCU(&audit_inode_hash[i]);
 
 	return 0;
 }
diff --git a/kernel/audit.h b/kernel/audit.h
index 208687b..bd4335c 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -58,7 +58,7 @@ struct audit_tree;
 struct audit_chunk;
 
 struct audit_entry {
-	struct list_head	list;
+	struct rcu_list_head	list;
 	struct rcu_head		rcu;
 	struct audit_krule	rule;
 };
@@ -71,7 +71,7 @@ extern int audit_ever_enabled;
 extern int audit_pid;
 
 #define AUDIT_INODE_BUCKETS	32
-extern struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
+extern struct rcu_list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
 
 static inline int audit_hash_ino(u32 ino)
 {
@@ -101,7 +101,7 @@ extern int selinux_audit_rule_update(void);
 
 extern struct mutex audit_filter_mutex;
 extern void audit_free_rule_rcu(struct rcu_head *);
-extern struct list_head audit_filter_list[];
+extern struct rcu_list_head audit_filter_list[];
 
 /* audit watch functions */
 extern unsigned long audit_watch_inode(struct audit_watch *watch);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 4b05bd9..dfebdbb 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -20,7 +20,7 @@ struct audit_tree {
 };
 
 struct audit_chunk {
-	struct list_head hash;
+	struct rcu_list_head hash;
 	struct inotify_watch watch;
 	struct list_head trees;		/* with root here */
 	int dead;
@@ -121,7 +121,7 @@ static struct audit_chunk *alloc_chunk(int count)
 	if (!chunk)
 		return NULL;
 
-	INIT_LIST_HEAD(&chunk->hash);
+	INIT_LIST_HEAD_RCU(&chunk->hash);
 	INIT_LIST_HEAD(&chunk->trees);
 	chunk->count = count;
 	atomic_long_set(&chunk->refs, 1);
@@ -157,10 +157,10 @@ static void __put_chunk(struct rcu_head *rcu)
 }
 
 enum {HASH_SIZE = 128};
-static struct list_head chunk_hash_heads[HASH_SIZE];
+static struct rcu_list_head chunk_hash_heads[HASH_SIZE];
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(hash_lock);
 
-static inline struct list_head *chunk_hash(const struct inode *inode)
+static inline struct rcu_list_head *chunk_hash(const struct inode *inode)
 {
 	unsigned long n = (unsigned long)inode / L1_CACHE_BYTES;
 	return chunk_hash_heads + n % HASH_SIZE;
@@ -169,14 +169,14 @@ static inline struct list_head *chunk_hash(const struct inode *inode)
 /* hash_lock is held by caller */
 static void insert_hash(struct audit_chunk *chunk)
 {
-	struct list_head *list = chunk_hash(chunk->watch.inode);
+	struct rcu_list_head *list = chunk_hash(chunk->watch.inode);
 	list_add_rcu(&chunk->hash, list);
 }
 
 /* called under rcu_read_lock */
 struct audit_chunk *audit_tree_lookup(const struct inode *inode)
 {
-	struct list_head *list = chunk_hash(inode);
+	struct rcu_list_head *list = chunk_hash(inode);
 	struct audit_chunk *p;
 
 	list_for_each_entry_rcu(p, list, hash) {
@@ -959,7 +959,7 @@ static int __init audit_tree_init(void)
 		audit_panic("cannot initialize inotify handle for rectree watches");
 
 	for (i = 0; i < HASH_SIZE; i++)
-		INIT_LIST_HEAD(&chunk_hash_heads[i]);
+		INIT_LIST_HEAD_RCU(&chunk_hash_heads[i]);
 
 	return 0;
 }
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a706040..0de3cdb 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -44,13 +44,13 @@
  */
 
 /* Audit filter lists, defined in <linux/audit.h> */
-struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
-	LIST_HEAD_INIT(audit_filter_list[0]),
-	LIST_HEAD_INIT(audit_filter_list[1]),
-	LIST_HEAD_INIT(audit_filter_list[2]),
-	LIST_HEAD_INIT(audit_filter_list[3]),
-	LIST_HEAD_INIT(audit_filter_list[4]),
-	LIST_HEAD_INIT(audit_filter_list[5]),
+struct rcu_list_head audit_filter_list[AUDIT_NR_FILTERS] = {
+	LIST_HEAD_INIT_RCU(audit_filter_list[0]),
+	LIST_HEAD_INIT_RCU(audit_filter_list[1]),
+	LIST_HEAD_INIT_RCU(audit_filter_list[2]),
+	LIST_HEAD_INIT_RCU(audit_filter_list[3]),
+	LIST_HEAD_INIT_RCU(audit_filter_list[4]),
+	LIST_HEAD_INIT_RCU(audit_filter_list[5]),
 #if AUDIT_NR_FILTERS != 6
 #error Fix audit_filter_list initialiser
 #endif
@@ -821,10 +821,10 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old,
 /* Find an existing audit rule.
  * Caller must hold audit_filter_mutex to prevent stale rule data. */
 static struct audit_entry *audit_find_rule(struct audit_entry *entry,
-					   struct list_head **p)
+					   struct rcu_list_head **p)
 {
 	struct audit_entry *e, *found = NULL;
-	struct list_head *list;
+	struct rcu_list_head *list;
 	int h;
 
 	if (entry->rule.inode_f) {
@@ -834,7 +834,7 @@ static struct audit_entry *audit_find_rule(struct audit_entry *entry,
 		/* we don't know the inode number, so must walk entire hash */
 		for (h = 0; h < AUDIT_INODE_BUCKETS; h++) {
 			list = &audit_inode_hash[h];
-			list_for_each_entry(e, list, list)
+			list_for_each_entry_rcu(e, list, list)
 				if (!audit_compare_rule(&entry->rule, &e->rule)) {
 					found = e;
 					goto out;
@@ -845,7 +845,7 @@ static struct audit_entry *audit_find_rule(struct audit_entry *entry,
 		*p = list = &audit_filter_list[entry->rule.listnr];
 	}
 
-	list_for_each_entry(e, list, list)
+	list_for_each_entry_rcu(e, list, list)
 		if (!audit_compare_rule(&entry->rule, &e->rule)) {
 			found = e;
 			goto out;
@@ -864,7 +864,7 @@ static inline int audit_add_rule(struct audit_entry *entry)
 	struct audit_entry *e;
 	struct audit_watch *watch = entry->rule.watch;
 	struct audit_tree *tree = entry->rule.tree;
-	struct list_head *list;
+	struct rcu_list_head *list;
 	int h, err;
 #ifdef CONFIG_AUDITSYSCALL
 	int dont_count = 0;
@@ -947,7 +947,7 @@ static inline int audit_del_rule(struct audit_entry *entry)
 	struct audit_entry  *e;
 	struct audit_watch *watch = entry->rule.watch;
 	struct audit_tree *tree = entry->rule.tree;
-	struct list_head *list;
+	struct rcu_list_head *list;
 	LIST_HEAD(inotify_list);
 	int ret = 0;
 #ifdef CONFIG_AUDITSYSCALL
@@ -1296,7 +1296,7 @@ int audit_filter_type(int type)
 	int result = 0;
 
 	rcu_read_lock();
-	if (list_empty(&audit_filter_list[AUDIT_FILTER_TYPE]))
+	if (list_empty_rcu(&audit_filter_list[AUDIT_FILTER_TYPE]))
 		goto unlock_and_return;
 
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TYPE],
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index fc0f928..e4fdd74 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -686,7 +686,7 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
  */
 static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 					     struct audit_context *ctx,
-					     struct list_head *list)
+					     struct rcu_list_head *list)
 {
 	struct audit_entry *e;
 	enum audit_state state;
@@ -695,7 +695,7 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 		return AUDIT_DISABLED;
 
 	rcu_read_lock();
-	if (!list_empty(list)) {
+	if (!list_empty_rcu(list)) {
 		int word = AUDIT_WORD(ctx->major);
 		int bit  = AUDIT_BIT(ctx->major);
 
@@ -733,9 +733,9 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 		int bit  = AUDIT_BIT(ctx->major);
 		struct audit_names *n = &ctx->names[i];
 		int h = audit_hash_ino((u32)n->ino);
-		struct list_head *list = &audit_inode_hash[h];
+		struct rcu_list_head *list = &audit_inode_hash[h];
 
-		if (list_empty(list))
+		if (list_empty_rcu(list))
 			continue;
 
 		list_for_each_entry_rcu(e, list, list) {
-- 
1.6.3.3

