Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYJEWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYJEWOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYJEWOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:14:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbYJEWOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:14:12 -0400
Date: Sun, 5 Oct 2008 18:14:02 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: [PATCH 1/3] bit mutexes
In-Reply-To: <20081001225404.4e973465.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810051812010.23248@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit mutex implementation.

Bit mutex is a space-efficient mutex that consumes exactly one bit in
the apropriate structure (if mutex debugging is turned off).  Bit mutex
is implemented as a bit in unsigned long field. Other bits in the field
may be used for other purposes, if test/set/clear_bit functions are used
to manipulate them. There is no wait queue in the structure containing
the bit mutex; hashed wait queues for waiting on bits are used.

Additional structure struct bit_mutex is needed, it contains lock
debugging & dependency information. When the kernel is compiled without
lock debugging, this structure is empty.

Bit mutexes are used with functions
bit_mutex_init
bit_mutex_lock
bit_mutex_unlock
bit_mutex_is_locked
These functions take 3 arguments: pointer to the unsigned long field,
the bit position and pointer to struct bit_mutex.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/bit-mutex.h |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/wait.h      |    8 +++
 kernel/Makefile           |    2 
 kernel/bit-mutex-debug.c  |   55 +++++++++++++++++++++++++
 kernel/wait.c             |    7 +++
 5 files changed, 169 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc8-devel/include/linux/bit-mutex.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27-rc8-devel/include/linux/bit-mutex.h	2008-10-05 19:58:30.000000000 +0200
@@ -0,0 +1,98 @@
+#ifndef __LINUX_BIT_MUTEX_H
+#define __LINUX_BIT_MUTEX_H
+
+#include <linux/bitops.h>
+#include <linux/lockdep.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+struct bit_mutex {
+#ifdef CONFIG_DEBUG_MUTEXES
+	unsigned long		*field;
+	int 			bit;
+	struct thread_info	*owner;
+	const char		*name;
+	void			*magic;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+#ifndef CONFIG_DEBUG_MUTEXES
+
+static inline void bit_mutex_init(unsigned long *field, int bit, struct bit_mutex *mtx)
+{
+	clear_bit(bit, field);
+	smp_mb__after_clear_bit();
+}
+
+static inline void bit_mutex_lock(unsigned long *field, int bit, struct bit_mutex *mtx)
+{
+	wait_on_bit_lock(field, bit, wait_action_schedule, TASK_UNINTERRUPTIBLE);
+}
+
+static inline void bit_mutex_unlock(unsigned long *field, int bit, struct bit_mutex *mtx)
+{
+	smp_mb__before_clear_bit();
+	clear_bit(bit, field);
+	smp_mb__after_clear_bit();
+	wake_up_bit(field, bit);
+}
+
+static inline int bit_mutex_is_locked(unsigned long *field, int bit, struct bit_mutex *mtx)
+{
+	return test_bit(bit, field);
+}
+
+#define __DEBUG_BIT_MUTEX_INITIALIZER(field, bit, mtx)
+
+#else
+
+void __bit_mutex_init(unsigned long *field, int bit, struct bit_mutex *mtx, const char *name, struct lock_class_key *key);
+
+#define bit_mutex_init(field, bit, mtx)				\
+do {								\
+	static struct lock_class_key __key;			\
+	__bit_mutex_init(field, bit, mtx, #mtx, &__key);	\
+} while (0)
+
+void __bit_mutex_lock(unsigned long *field, int bit, struct bit_mutex *mtx, int subclass);
+
+#define bit_mutex_lock(field, bit, mtx)				\
+	__bit_mutex_lock(field, bit, mtx, 0)
+
+void __bit_mutex_unlock(unsigned long *field, int bit, struct bit_mutex *mtx, int subclass);
+
+#define bit_mutex_unlock(field, bit, mtx)			\
+	__bit_mutex_unlock(field, bit, mtx, 0)
+
+int bit_mutex_is_locked(unsigned long *field, int bit, struct bit_mutex *mtx);
+
+#define __DEBUG_BIT_MUTEX_INITIALIZER(field_, bit_, mtx)	\
+	.magic = &(mtx),					\
+	.field = (field_),					\
+	.bit = (bit_)
+
+#endif
+
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+#define __DEP_MAP_BIT_MUTEX_INITIALIZER(field, bit, mtx)	\
+	, .dep_map = { .name = #mtx }
+
+#else
+
+#define __DEP_MAP_BIT_MUTEX_INITIALIZER(field, bit, mtx)
+
+#endif
+
+
+#define __BIT_MUTEX_INITIALIZER(field, bit, mtx)		\
+	{							\
+		__DEBUG_BIT_MUTEX_INITIALIZER(field, bit, mtx)	\
+		__DEP_MAP_BIT_MUTEX_INITIALIZER(field, bit, mtx)\
+	}
+
+#endif
Index: linux-2.6.27-rc8-devel/include/linux/wait.h
===================================================================
--- linux-2.6.27-rc8-devel.orig/include/linux/wait.h	2008-10-04 13:40:46.000000000 +0200
+++ linux-2.6.27-rc8-devel/include/linux/wait.h	2008-10-04 13:41:21.000000000 +0200
@@ -513,7 +513,13 @@ static inline int wait_on_bit_lock(void 
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
 }
-	
+
+/**
+ * wait_action_schedule - this function can be passed to wait_on_bit or
+ * wait_on_bit_lock and it will call just schedule().
+ */
+int wait_action_schedule(void *);
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6.27-rc8-devel/kernel/wait.c
===================================================================
--- linux-2.6.27-rc8-devel.orig/kernel/wait.c	2008-10-04 13:37:24.000000000 +0200
+++ linux-2.6.27-rc8-devel/kernel/wait.c	2008-10-04 13:38:21.000000000 +0200
@@ -251,3 +251,10 @@ wait_queue_head_t *bit_waitqueue(void *w
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];
 }
 EXPORT_SYMBOL(bit_waitqueue);
+
+int wait_action_schedule(void *word)
+{
+	schedule();
+	return 0;
+}
+EXPORT_SYMBOL(wait_action_schedule);
Index: linux-2.6.27-rc8-devel/kernel/Makefile
===================================================================
--- linux-2.6.27-rc8-devel.orig/kernel/Makefile	2008-10-05 14:03:24.000000000 +0200
+++ linux-2.6.27-rc8-devel/kernel/Makefile	2008-10-05 14:11:25.000000000 +0200
@@ -17,6 +17,7 @@ ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
 CFLAGS_REMOVE_lockdep_proc.o = -pg
+CFLAGS_REMOVE_bit-mutex-debug.o = -pg
 CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
@@ -29,6 +30,7 @@ obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sy
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
+obj-$(CONFIG_DEBUG_MUTEXES) += bit-mutex-debug.o
 obj-$(CONFIG_LOCKDEP) += lockdep.o
 ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
Index: linux-2.6.27-rc8-devel/kernel/bit-mutex-debug.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27-rc8-devel/kernel/bit-mutex-debug.c	2008-10-05 19:12:06.000000000 +0200
@@ -0,0 +1,55 @@
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/debug_locks.h>
+#include <linux/bit-mutex.h>
+
+void __bit_mutex_init(unsigned long *field, int bit, struct bit_mutex *mtx, const char *name, struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	debug_check_no_locks_freed((void *)mtx, sizeof(*mtx));
+	lockdep_init_map(&mtx->dep_map, name, key, 0);
+#endif
+	mtx->field = field;
+	mtx->bit = bit;
+	mtx->owner = NULL;
+	mtx->magic = mtx;
+	clear_bit(bit, field);
+	smp_mb__after_clear_bit();
+}
+EXPORT_SYMBOL(__bit_mutex_init);
+
+void __bit_mutex_lock(unsigned long *field, int bit, struct bit_mutex *mtx, int subclass)
+{
+	DEBUG_LOCKS_WARN_ON(mtx->magic != mtx);
+	DEBUG_LOCKS_WARN_ON(field != mtx->field);
+	DEBUG_LOCKS_WARN_ON(bit != mtx->bit);
+	mutex_acquire(&mtx->dep_map, subclass, 0, _RET_IP_);
+	wait_on_bit_lock(field, bit, wait_action_schedule, TASK_UNINTERRUPTIBLE);
+	lock_acquired(&mtx->dep_map);
+	mtx->owner = current_thread_info();
+}
+EXPORT_SYMBOL(__bit_mutex_lock);
+
+void __bit_mutex_unlock(unsigned long *field, int bit, struct bit_mutex *mtx, int nested)
+{
+	DEBUG_LOCKS_WARN_ON(mtx->magic != mtx);
+	DEBUG_LOCKS_WARN_ON(mtx->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(mtx->field != field);
+	DEBUG_LOCKS_WARN_ON(mtx->bit != bit);
+	mtx->owner = NULL;
+	mutex_release(&mtx->dep_map, nested, _RET_IP_);
+	smp_mb__before_clear_bit();
+	clear_bit(bit, field);
+	smp_mb__after_clear_bit();
+	wake_up_bit(field, bit);
+}
+EXPORT_SYMBOL(__bit_mutex_unlock);
+
+int bit_mutex_is_locked(unsigned long *field, int bit, struct bit_mutex *mtx)
+{
+	DEBUG_LOCKS_WARN_ON(mtx->magic != mtx);
+	DEBUG_LOCKS_WARN_ON(field != mtx->field);
+	DEBUG_LOCKS_WARN_ON(bit != mtx->bit);
+	return test_bit(bit, field);
+}
+EXPORT_SYMBOL(bit_mutex_is_locked);
