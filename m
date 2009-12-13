Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbZLMICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbZLMICa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 03:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZLMIC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 03:02:29 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55098 "HELO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751454AbZLMIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 03:02:28 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH][RFC] perf lock: Distribute numerical IDs for each lock instances
Date: Sun, 13 Dec 2009 17:02:24 +0900
Message-Id: <1260691344-4724-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements distributing numerical IDs for each lock instances.

Principle:
At first, kernel holds lock_idtable. It is an double dimension array
for each lock class with LOCK_IDTABLE_LENGTH of struct lock_instance_stat.

struct lock_instance_stat can have many things for lock stats or something,
but it isn't important point.

The important point is that index of lock_idtable is used as numerical ID.
And this patch makes lockdep_map have this ID. So searching stats data for
lock instances are O(1), very fast.

And the second important point is that when numerical IDs are distributed
for each lock instances.
This patch makes lockdep_map have a new member, do_register. This is a pointer of function.
When initialized the lock instances (for example: SPIN_DEP_MAP_INIT in spinlock_types.h),
this member is initialized with
register_lockdep_id() in kernel/lockdep.c .
This function receives the adress of lockdep_map (it's owner),
and searches lock_idtable, then if unused ID (unused index) is found,
set the owner (spinlock_t, rwlock_t, etc. obtained with container_of) of lockdep_map
to lock_idtable's unit determined in above.

When this do_register() called? lock_acquire() calls it.
And once initialize completed, nop_register_lockdep_id() will be
assigned to do_register(). It is a nop function.

I believe this patch makes implementation of perf lock more easy
and precision, and may also help lock people.

Benefit:
 * Low overhead
 * int type ID is easy to deal with

Demerit:
 * What should kernel do when lock_idtable is exhausted?
   (But I think entire number of lock instances are not so many,
    and predicting upper limit of it is not hard)
 * instances before calling lock_acquire() with cannot be identified
 * end of instances cannot be determined

This patch is a proof of concept version.
There are some rest todos, especially the statement in lock_acquire():
	if (lock->do_register)
this must be removed in future, this proves that
there's some lockdep_map I cannot initializing correctly.
For example, rcu_lock_map in kernel/rcupdate.c .

And I implemented debugfs entry, lockdep_idtable
for dumping ID and name of instances like this,
% cat  lockdep_idtable
        --- spinlock ---
0: logbuf_lock
1: (console_sem).lock
2: clockevents_lock
3: set_atomicity_lock
4: pgd_lock
5: init_mm.page_table_lock
6: index_init_lock
7: ioapic_lock
8: x86_mce_decoder_chain.lock
9: pcpu_lock
10: perf_resource_lock
...

But it is can be merged according to checkpatch.pl,
if you like it, could you merge it into perf/lock branch, Ingo?
And I really want to hear comments from people! :)

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/rwsem.h   |   10 +++-
 include/linux/lockdep.h        |   27 +++++++
 include/linux/mutex.h          |   12 +++-
 include/linux/rwsem-spinlock.h |   11 +++-
 include/linux/spinlock_types.h |   20 +++++-
 kernel/lockdep.c               |  148 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 222 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..179e4fb 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -74,7 +74,15 @@ struct rw_semaphore {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = {	\
+		.type = LOCKDEP_TYPE_RWSEM,		\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+		.id = -1,				\
+		.do_register =				\
+		register_lockdep_id,			\
+	}
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..04199fa 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -20,6 +20,16 @@ struct lockdep_map;
 #include <linux/stacktrace.h>
 
 /*
+ * CAUTION!
+ * This should be enough for all lock allocated
+ * from system boot to system down
+ * for each class of lock (spin, rw, mutex, rwsem)
+ */
+#define LOCK_IDTABLE_LENGTH             1024
+
+extern void register_lockdep_id(struct lockdep_map *map);
+
+/*
  * We'd rather not expose kernel/lockdep_states.h this wide, but we do need
  * the total number of states... :-(
  */
@@ -126,6 +136,17 @@ struct lock_class_stats lock_stats(struct lock_class *class);
 void clear_lock_stats(struct lock_class *class);
 #endif
 
+struct lock_instance_stat {
+	void *lock;		/* spinlock_t *, struct mutex *, etc... */
+};
+
+#define LOCKDEP_TYPE_OTHER              0
+#define LOCKDEP_TYPE_SPIN               1
+#define LOCKDEP_TYPE_RW                 2
+#define LOCKDEP_TYPE_MUTEX              3
+#define LOCKDEP_TYPE_RWSEM              4
+#define LOCKDEP_TYPE_MAX                5
+
 /*
  * Map the lock object (the lock instance) to the lock-class object.
  * This is embedded into specific lock instances:
@@ -134,10 +155,16 @@ struct lockdep_map {
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache;
 	const char			*name;
+	const char			*file;
+	int      			line;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
 	unsigned long			ip;
 #endif
+
+	int                             type;
+	int                             id;
+	void (*do_register)(struct lockdep_map *);
 };
 
 /*
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 878cab4..3910b64 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -88,8 +88,16 @@ do {							\
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __DEP_MAP_MUTEX_INITIALIZER(lockname) \
-		, .dep_map = { .name = #lockname }
+# define __DEP_MAP_MUTEX_INITIALIZER(lockname)		\
+	, .dep_map = {					\
+		.type = LOCKDEP_TYPE_MUTEX,		\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+		.id = -1,				\
+		.do_register =				\
+		register_lockdep_id,			\
+		}
 #else
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)
 #endif
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 6c3c0f6..3feb045 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -38,7 +38,16 @@ struct rw_semaphore {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+# define __RWSEM_DEP_MAP_INIT(lockname)		\
+	, .dep_map = {				\
+		.type = LOCKDEP_TYPE_RWSEM,	\
+		.file = __FILE__,		\
+		.line = __LINE__,		\
+		.name = #lockname,		\
+		.id = -1,			\
+		.do_register =			\
+		register_lockdep_id,		\
+	}
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 68d88f7..14dd491 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -52,13 +52,29 @@ typedef struct {
 #define SPINLOCK_OWNER_INIT	((void *)-1L)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = {	\
+		.type = LOCKDEP_TYPE_SPIN,		\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+		.id = -1,				\
+		.do_register =				\
+		register_lockdep_id,			\
+	}
 #else
 # define SPIN_DEP_MAP_INIT(lockname)
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define RW_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define RW_DEP_MAP_INIT(lockname)	.dep_map = {	\
+		.type = LOCKDEP_TYPE_RW,		\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+		.id = -1,				\
+		.do_register =				\
+		register_lockdep_id,			\
+	}
 #else
 # define RW_DEP_MAP_INIT(lockname)
 #endif
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f5dcd36..a767a66 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -43,6 +43,7 @@
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
+#include <linux/debugfs.h>
 
 #include <asm/sections.h>
 
@@ -2669,6 +2670,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 	return ret;
 }
 
+static void nop_register_lockdep_id(struct lockdep_map *map);
 /*
  * Initialize a lock instance's lock-class mapping info:
  */
@@ -2704,6 +2706,10 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
+
+	/* FIXME! How can I detect type of the owner of lock? */
+	lock->type = LOCKDEP_TYPE_OTHER;
+	lock->do_register = nop_register_lockdep_id;
 }
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
@@ -3202,6 +3208,10 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 {
 	unsigned long flags;
 
+	if (lock->do_register)
+		/* This branch have to be removed in completed version */
+		lock->do_register(lock);
+
 	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 
 	if (unlikely(current->lockdep_recursion))
@@ -3800,3 +3810,141 @@ void lockdep_sys_exit(void)
 		lockdep_print_held_locks(curr);
 	}
 }
+
+/*
+ *
+ * Distributing numeric ID for each lock instances
+ *
+ * CAUTION!
+ * This method cannot detect the end of lock instance
+ *
+ */
+
+static struct lock_instance_stat
+lock_idtable[LOCKDEP_TYPE_MAX][LOCK_IDTABLE_LENGTH];
+
+static void nop_register_lockdep_id(struct lockdep_map *map)
+{
+	return;			/* This is nop function */
+}
+
+void register_lockdep_id(struct lockdep_map *map)
+{
+	int i;
+
+	for (i = 0; lock_idtable[map->type][i].lock; i++) {
+		if (i + 1 == LOCK_IDTABLE_LENGTH)
+			panic("Exhausted lock id table!");
+	}
+
+	switch (map->type) {
+	case LOCKDEP_TYPE_OTHER:
+		printk(KERN_DEBUG "LOCKDEP_TYPE_OTHER detected, name:%s\n",
+		       map->name);
+		break;
+	case LOCKDEP_TYPE_SPIN:
+		lock_idtable[map->type][i].lock
+			= (void *)container_of(map, spinlock_t, dep_map);
+		break;
+	case LOCKDEP_TYPE_RW:
+		lock_idtable[map->type][i].lock
+			= (void *)container_of(map, rwlock_t, dep_map);
+		break;
+	case LOCKDEP_TYPE_MUTEX:
+		lock_idtable[map->type][i].lock
+			= (void *)container_of(map, struct mutex, dep_map);
+		break;
+	case LOCKDEP_TYPE_RWSEM:
+		lock_idtable[map->type][i].lock
+			= (void *)container_of(map,
+					       struct rw_semaphore, dep_map);
+		break;
+	default:
+		panic("Unknown lock type:%d!!!\n", map->type);
+		break;
+	}
+
+	map->id = i;
+	map->do_register = nop_register_lockdep_id;
+}
+EXPORT_SYMBOL_GPL(register_lockdep_id);
+
+static int lockdep_idtable_show(struct seq_file *m, void *v)
+{
+	int type, id;
+	const char *name = NULL;
+
+	spinlock_t *spin;
+	rwlock_t *rw;
+	struct mutex *mutex;
+	struct rw_semaphore *rwsem;
+
+	for (type = LOCKDEP_TYPE_SPIN; type < LOCKDEP_TYPE_MAX; type++) {
+		switch (type) {
+		case LOCKDEP_TYPE_SPIN:
+			seq_printf(m, "\t --- spinlock ---\n");
+			break;
+		case LOCKDEP_TYPE_RW:
+			seq_printf(m, "\t --- rwlock ---\n");
+			break;
+		case LOCKDEP_TYPE_MUTEX:
+			seq_printf(m, "\t --- mutex ---\n");
+			break;
+		case LOCKDEP_TYPE_RWSEM:
+			seq_printf(m, "\t --- rwsem ---\n");
+			break;
+		}
+
+		for (id = 0; id < LOCK_IDTABLE_LENGTH; id++) {
+
+			if (!lock_idtable[type][id].lock)
+				continue;
+
+			switch (type) {
+			case LOCKDEP_TYPE_SPIN:
+				spin = lock_idtable[type][id].lock;
+				name = spin->dep_map.name;
+				break;
+			case LOCKDEP_TYPE_RW:
+				rw = lock_idtable[type][id].lock;
+				name = rw->dep_map.name;
+				break;
+			case LOCKDEP_TYPE_MUTEX:
+				mutex = lock_idtable[type][id].lock;
+				name = mutex->dep_map.name;
+				break;
+			case LOCKDEP_TYPE_RWSEM:
+				rwsem = lock_idtable[type][id].lock;
+				name = rwsem->dep_map.name;
+				break;
+			}
+
+			seq_printf(m, "%d: %s\n", id, name);
+		}
+	}
+
+	seq_puts(m, "\n");
+
+	return 0;
+}
+
+static int lockdep_idtable_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, lockdep_idtable_show, NULL);
+}
+
+static const struct file_operations lockdep_idtable_fops = {
+	.open		= lockdep_idtable_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static __init int lockdep_idtable_init_debug(void)
+{
+	debugfs_create_file("lockdep_idtable", 0444, NULL, NULL,
+			&lockdep_idtable_fops);
+
+	return 0;
+}
+late_initcall(lockdep_idtable_init_debug);
-- 
1.6.5.2

