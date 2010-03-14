Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0CNKli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:41:38 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52826 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab0CNKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:52 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 01/11] lock monitor: New subsystem for lock event hooking
Date: Sun, 14 Mar 2010 19:38:38 +0900
Message-Id: <1268563128-6486-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current lockdep is too complicated because,
 * dependency validation
 * statistics
 * event tracing
are all implemented by it.
This cause problem of overhead.
If user enables one of them, overhead of rests part is not avoidable.
(tracing is exception. If user enables validation or stat,
overhead of tracing doesn't occur.)

So I suggest new subsystem lock monitor.
This is a general purpose lock event hooking mechanism.

Programmer who want to hook lock event should prepare this structure,

struct lock_monitor_hook {
	struct list_head list;
	const char *name;

	void (*acquire)(struct lock_monitor *monitor, unsigned int subclass,
			int trylock, int read, int check,
			struct lock_monitor *nest_monitor, unsigned long ip);
	void (*acquired)(struct lock_monitor *monitor, unsigned long ip);
	void (*contended)(struct lock_monitor *monitor, unsigned long ip);
	void (*release)(struct lock_monitor *monitor, int nested,
			unsigned long ip);
};

e.g. lockdep is like this,
static struct lock_monitor_hook lockdep_hook = {
	.name = "lockdep",
	.acquire = lockdep_acquire_hook,
	.acquired = lockdep_acquired_hook,
	.contended = lockdep_contended_hook,
	.release = lockdep_release_hook,
};

Then registering can be done
	lock_monitor_register(&lockdep_hook);

This subsystem makes it possible to enable/disable
each features of lock monitoring. And adding new hook is easy.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/lock_monitor.h |  171 ++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile              |    1 +
 kernel/lock_monitor.c        |  132 ++++++++++++++++++++++++++++++++
 lib/Kconfig.debug            |   16 +++-
 4 files changed, 316 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/lock_monitor.h
 create mode 100644 kernel/lock_monitor.c

diff --git a/include/linux/lock_monitor.h b/include/linux/lock_monitor.h
new file mode 100644
index 0000000..f1c8269
--- /dev/null
+++ b/include/linux/lock_monitor.h
@@ -0,0 +1,171 @@
+#ifndef __LINUX_LOCK_MONITOR_H
+#define __LINUX_LOCK_MONITOR_H
+
+#include <linux/list.h>
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#include <linux/lockdep.h>
+#endif
+
+struct lock_monitor {
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+};
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+#else
+# define DEP_MAP_INIT(lockname)
+#endif
+
+#define __LOCK_MONITOR_INIT(lockname)		\
+	DEP_MAP_INIT(lockname)
+
+struct lock_monitor_hook {
+	struct list_head list;
+	const char *name;
+
+	void (*acquire)(struct lock_monitor *monitor, unsigned int subclass,
+			int trylock, int read, int check,
+			struct lock_monitor *nest_monitor, unsigned long ip);
+	void (*acquired)(struct lock_monitor *monitor, unsigned long ip);
+	void (*contended)(struct lock_monitor *monitor, unsigned long ip);
+	void (*release)(struct lock_monitor *monitor, int nested,
+			unsigned long ip);
+};
+
+#ifdef CONFIG_LOCK_MONITOR
+
+extern void lock_monitor_register(struct lock_monitor_hook *new_hook);
+extern void lock_monitor_unregister(const char *name);
+
+/*
+ * Acquire a lock.
+ *
+ * Values for "read":
+ *
+ *   0: exclusive (write) acquire
+ *   1: read-acquire (no recursion allowed)
+ *   2: read-acquire with same-instance recursion allowed
+ *
+ * Values for check:
+ *
+ *   0: disabled
+ *   1: simple checks (freeing, held-at-exit-time, etc.)
+ *   2: full validation
+ */
+extern void lock_acquire(struct lock_monitor *monitor, unsigned int subclass,
+			 int trylock, int read, int check,
+			 struct lock_monitor *nest_monitor, unsigned long ip);
+extern void lock_acquired(struct lock_monitor *monitor, unsigned long ip);
+extern void lock_contended(struct lock_monitor *monitor, unsigned long ip);
+extern void lock_release(struct lock_monitor *monitor, int nested,
+			 unsigned long ip);
+
+#define LOCK_CONTENDED(_lock, try, lock)				\
+	do {								\
+	if (!try(_lock)) {						\
+		lock_contended(&(_lock)->monitor, _RET_IP_);	\
+		lock(_lock);						\
+	}								\
+	lock_acquired(&(_lock)->monitor, _RET_IP_);		\
+} while (0)
+
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
+	LOCK_CONTENDED((_lock), (try), (lock))
+
+#else  /* CONFIG_LOCK_MONITOR */
+
+static inline void lock_monitor_register(struct lock_monitor_hook *new_hook)
+{
+}
+
+static inline void lock_monitor_unregister(const char *name)
+{
+}
+
+static inline void lock_acquire(struct lock_monitor *monitor, unsigned int subclass,
+			 int trylock, int read, int check,
+			 struct lock_monitor *nest_monitor, unsigned long ip)
+{
+}
+
+static inline void lock_acquired(struct lock_monitor *monitor, unsigned long ip)
+{
+}
+
+static inline void lock_contended(struct lock_monitor *monitor, unsigned long ip)
+{
+}
+
+static inline void lock_release(struct lock_monitor *monitor, int nested,
+			 unsigned long ip)
+{
+}
+
+#define LOCK_CONTENDED(_lock, try, lock)	\
+	lock(_lock);
+
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags)	\
+	lock(_lock);
+
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
+# else
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
+# endif
+# define spin_release(l, n, i)			lock_release(l, n, i)
+#else
+# define spin_acquire(l, s, t, i)		do { } while (0)
+# define spin_release(l, n, i)			do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
+# else
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
+# endif
+# define rwlock_release(l, n, i)		lock_release(l, n, i)
+#else
+# define rwlock_acquire(l, s, t, i)		do { } while (0)
+# define rwlock_acquire_read(l, s, t, i)	do { } while (0)
+# define rwlock_release(l, n, i)		do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+# else
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+# endif
+# define mutex_release(l, n, i)			lock_release(l, n, i)
+#else
+# define mutex_acquire(l, s, t, i)		do { } while (0)
+# define mutex_release(l, n, i)			do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
+# else
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
+# endif
+# define rwsem_release(l, n, i)			lock_release(l, n, i)
+#else
+# define rwsem_acquire(l, s, t, i)		do { } while (0)
+# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
+# define rwsem_release(l, n, i)			do { } while (0)
+#endif
+
+#endif	/* __LINUX_LOCK_MONITOR_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 864ff75..aec9155 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
 obj-$(CONFIG_LOCKDEP) += lockdep.o
+obj-$(CONFIG_LOCK_MONITOR) += lock_monitor.o
 ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
diff --git a/kernel/lock_monitor.c b/kernel/lock_monitor.c
new file mode 100644
index 0000000..596aead
--- /dev/null
+++ b/kernel/lock_monitor.c
@@ -0,0 +1,132 @@
+/* 
+ * Lock monitor ... general lock event hooking mechanism
+ * Started by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> 
+ */
+
+#include <linux/lock_monitor.h>
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#include <linux/lockdep.h>
+#endif
+
+static arch_rwlock_t hook_lock = __ARCH_RW_LOCK_UNLOCKED;
+static LIST_HEAD(lock_monitor_hooks);
+
+void lock_monitor_register(struct lock_monitor_hook *new_hook)
+{
+	arch_write_lock(&hook_lock);
+	list_add(&new_hook->list, &lock_monitor_hooks);
+	arch_write_unlock(&hook_lock);
+
+	printk(KERN_INFO "new lock hook:%s registered\n", new_hook->name);
+}
+EXPORT_SYMBOL(lock_monitor_register);
+
+void lock_monitor_unregister(const char *name)
+{
+	struct list_head *l;
+	struct lock_monitor_hook *hook;
+
+	arch_write_lock(&hook_lock);
+
+	list_for_each(l, &lock_monitor_hooks) {
+		hook = container_of(l, struct lock_monitor_hook, list);
+		if (!strcmp(hook->name, name)) {
+			list_del(l);
+			printk(KERN_INFO "lock hook:%s unregistered\n", hook->name);
+			goto end;
+		}
+	}
+
+	printk(KERN_ERR "request occured for unregistering "
+	       "unknown look hook:%s\n", name);
+
+end:
+	arch_write_unlock(&hook_lock);
+}
+EXPORT_SYMBOL(lock_monitor_unregister);
+
+void lock_acquire(struct lock_monitor *monitor, unsigned int subclass,
+			 int trylock, int read, int check,
+			 struct lock_monitor *nest_monitor, unsigned long ip)
+{
+	struct list_head *l;
+	struct lock_monitor_hook *hook;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	arch_read_lock(&hook_lock);
+
+	list_for_each(l, &lock_monitor_hooks) {
+		hook = container_of(l, struct lock_monitor_hook, list);
+		hook->acquire(monitor, subclass, trylock, read, check, nest_monitor, ip);
+	}
+
+	arch_read_unlock(&hook_lock);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(lock_acquire);
+
+void lock_acquired(struct lock_monitor *monitor, unsigned long ip)
+{
+	struct list_head *l;
+	struct lock_monitor_hook *hook;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	arch_read_lock(&hook_lock);
+
+	list_for_each(l, &lock_monitor_hooks) {
+		hook = container_of(l, struct lock_monitor_hook, list);
+		hook->acquired(monitor, ip);
+	}
+
+	arch_read_unlock(&hook_lock);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(lock_acquired);
+
+
+void lock_contended(struct lock_monitor *monitor, unsigned long ip)
+{
+	struct list_head *l;
+	struct lock_monitor_hook *hook;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	arch_read_lock(&hook_lock);
+
+	list_for_each(l, &lock_monitor_hooks) {
+		hook = container_of(l, struct lock_monitor_hook, list);
+		hook->contended(monitor, ip);
+	}
+
+	arch_read_unlock(&hook_lock);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(lock_contended);
+
+void lock_release(struct lock_monitor *monitor, int nested,
+			 unsigned long ip)
+{
+	struct list_head *l;
+	struct lock_monitor_hook *hook;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	arch_read_lock(&hook_lock);
+
+	list_for_each(l, &lock_monitor_hooks) {
+		hook = container_of(l, struct lock_monitor_hook, list);
+		hook->release(monitor, nested, ip);
+	}
+
+	arch_read_unlock(&hook_lock);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(lock_release);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..89636c2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -443,9 +443,17 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config LOCK_MONITOR
+	bool "Lock monitoring"
+	depends on DEBUG_KERNEL
+	help
+	  Enable lock monitor.
+	  Lock monitor is a generic lock event hooking mechanism.
+	  You can add any hooks to events of acquire, acquired, contended, release.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && LOCK_MONITOR
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
 	select LOCKDEP
@@ -459,7 +467,7 @@ config DEBUG_LOCK_ALLOC
 
 config PROVE_LOCKING
 	bool "Lock debugging: prove locking correctness"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && LOCK_MONITOR
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
@@ -501,7 +509,7 @@ config PROVE_LOCKING
 
 config LOCKDEP
 	bool
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && LOCK_MONITOR
 	select STACKTRACE
 	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390
 	select KALLSYMS
@@ -509,7 +517,7 @@ config LOCKDEP
 
 config LOCK_STAT
 	bool "Lock usage statistics"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && LOCK_MONITOR
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-- 
1.6.5.2

