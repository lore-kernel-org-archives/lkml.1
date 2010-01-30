Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699Ab0A3LqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0A3LqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0A3LqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:46:22 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52233 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0A3Lnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:43:42 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 03/11] lockdep: Add information of file and line where lock inited to struct lockdep_map
Date: Sat, 30 Jan 2010 20:43:25 +0900
Message-Id: <1264851813-8413-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FILE__ and __LINE__ where lock instances initialized are useful information
for profiling lock behaviour.
This patch adds these to struct lockdep_map.

The impact of this patch is making lockdep_init_map() macro.
Former lockdep_init_map() was renamed to __lockdep_init_map().
And lockdep_init_map() is a simple wrapper
to pass __FILE__ and __LINE__ to __lockdep_init_map() now.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/lockdep.h |   20 ++++++++++++++++----
 kernel/lockdep.c        |   10 +++++++---
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..a631afa 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -134,6 +134,8 @@ struct lockdep_map {
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache;
 	const char			*name;
+	const char			*file;
+	unsigned int			line;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
 	unsigned long			ip;
@@ -241,15 +243,25 @@ extern void lockdep_on(void);
  * to lockdep:
  */
 
-extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
-			     struct lock_class_key *key, int subclass);
+extern void __lockdep_init_map(struct lockdep_map *lock, const char *name,
+			     struct lock_class_key *key, int subclass,
+			     const char *file, unsigned int line);
+
+/*
+ * There's many direct call to __lockdep_init_map() (former lockdep_init_map()),
+ * and these lacks __FILE__ and __LINE__ .
+ * Current lockdep_init_map() is a wrapper for it.
+ */
+#define lockdep_init_map(lock, name, key, subclass)	\
+	__lockdep_init_map(lock, name, key, subclass, __FILE__, __LINE__)
 
 /*
  * To initialize a lockdep_map statically use this macro.
  * Note that _name must not be NULL.
  */
 #define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
-	{ .name = (_name), .key = (void *)(_key), }
+	{ .name = (_name), .key = (void *)(_key),	\
+			.file = __FILE__, .line = __LINE__}
 
 /*
  * Reinitialize a lock key - for cases where there is special locking or
@@ -342,7 +354,7 @@ static inline void lockdep_on(void)
 # define lockdep_trace_alloc(g)			do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
-# define lockdep_init_map(lock, name, key, sub) \
+# define lockdep_init_map(lock, name, key, sub)	\
 		do { (void)(name); (void)(key); } while (0)
 # define lockdep_set_class(lock, key)		do { (void)(key); } while (0)
 # define lockdep_set_class_and_name(lock, key, name) \
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5feaddc..f0f6dfd 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2681,8 +2681,9 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 /*
  * Initialize a lock instance's lock-class mapping info:
  */
-void lockdep_init_map(struct lockdep_map *lock, const char *name,
-		      struct lock_class_key *key, int subclass)
+void __lockdep_init_map(struct lockdep_map *lock, const char *name,
+		      struct lock_class_key *key, int subclass,
+		      const char *file, unsigned int line)
 {
 	lock->class_cache = NULL;
 #ifdef CONFIG_LOCK_STAT
@@ -2713,8 +2714,11 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
+
+	lock->file = file;
+	lock->line = line;
 }
-EXPORT_SYMBOL_GPL(lockdep_init_map);
+EXPORT_SYMBOL_GPL(__lockdep_init_map);
 
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
-- 
1.6.5.2

