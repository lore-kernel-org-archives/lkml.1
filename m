Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZC3VrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZC3VrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZC3Vqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:46:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZC3Vqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:46:50 -0400
Date: Mon, 30 Mar 2009 23:46:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] locking updates for v2.6.30
Message-ID: <20090330214632.GA5712@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git locking-for-linus

Highlights:

 - Spinning mutexes by Peter Zijlstra: mutex_lock() primitives now 
   might behave like spinlocks if the lock is still held by
   a task (on another CPU)

 - GFP_FS tracking: subtly incorrect GFP_FS calls are
   now detected and reported preemptively.

 - timer deadlock tracking

 - large lockdep core refactoring/cleanup, to make it easier to extend

Known risks:

 - Spinning mutexes have performance regression risks:

     ac6e60e: mutex: adaptive spinnning, performance tweaks
     0d66bf6: mutex: implement adaptive spinning

 - The lockdep core refactoring is intrusive and has caused bugs 
   (lockups) during testing.

 - Increased dependency checking coverage caused several new bug 
   sightings, and some false positives as well.

 - No known regressions.

 Thanks,

	Ingo

------------------>
Chris Mason (2):
      mutex: adaptive spinnning, performance tweaks
      Btrfs: stop spinning on mutex_trylock and let the adaptive code spin for us

Ingo Molnar (2):
      lockdep: annotate reclaim context (__GFP_NOFS), fix
      lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB

Johannes Berg (1):
      timer: implement lockdep deadlock detection

Nick Piggin (1):
      lockdep: annotate reclaim context (__GFP_NOFS)

Peter Zijlstra (27):
      mutex: small cleanup
      mutex: preemption fixes
      mutex: implement adaptive spinning
      lockdep: sanitize bit names
      lockdep: sanitize reclaim bit names
      lockdep: lockdep_states.h
      lockdep: simplify mark_held_locks
      lockdep: simplify mark_lock()
      lockdep: move state bit definitions around
      lockdep: generate the state bit definitions
      lockdep: generate usage strings
      lockdep: split up mark_lock_irq()
      lockdep: simplify the mark_lock_irq() helpers
      lockdep: further simplify mark_lock_irq() helpers
      lockdep: simplify mark_lock_irq() helpers #3
      lockdep: merge the _READ mark_lock_irq() helpers
      lockdep: merge the !_READ mark_lock_irq() helpers
      lockdep: fully reduce mark_lock_irq()
      lockdep: remove macro usage from mark_held_locks()
      lockdep: add comments to mark_lock_irq()
      lockdep: simplify get_user_chars()
      lockdep: get_user_chars() redo
      lockdep: simplify check_prev_add_irq()
      lockdep: use stringify.h
      lockstat: warn about disabled lock debugging
      lockdep: build fix for !PROVE_LOCKING
      lockdep: fix deadlock in lockdep_trace_alloc


 Documentation/lockdep-design.txt |   30 ++-
 include/linux/lockdep.h          |   50 +---
 include/linux/mutex.h            |    5 +-
 include/linux/sched.h            |    3 +
 include/linux/timer.h            |   93 ++++++-
 kernel/lockdep.c                 |  528 +++++++++++++++++++------------------
 kernel/lockdep_internals.h       |   45 +++-
 kernel/lockdep_proc.c            |   22 +-
 kernel/lockdep_states.h          |    9 +
 kernel/mutex-debug.c             |    9 +-
 kernel/mutex-debug.h             |   18 +-
 kernel/mutex.c                   |  121 ++++++++--
 kernel/mutex.h                   |   22 ++-
 kernel/sched.c                   |   71 +++++-
 kernel/sched_features.h          |    1 +
 kernel/timer.c                   |   68 ++++-
 mm/page_alloc.c                  |    5 +
 mm/slab.c                        |    4 +
 mm/slob.c                        |    2 +
 mm/slub.c                        |    1 +
 mm/vmscan.c                      |    2 +
 21 files changed, 730 insertions(+), 379 deletions(-)
 create mode 100644 kernel/lockdep_states.h

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index 4887730..938ea22 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -27,33 +27,37 @@ lock-class.
 State
 -----
 
-The validator tracks lock-class usage history into 5 separate state bits:
+The validator tracks lock-class usage history into 4n + 1 separate state bits:
 
-- 'ever held in hardirq context'                    [ == hardirq-safe   ]
-- 'ever held in softirq context'                    [ == softirq-safe   ]
-- 'ever held with hardirqs enabled'                 [ == hardirq-unsafe ]
-- 'ever held with softirqs and hardirqs enabled'    [ == softirq-unsafe ]
+- 'ever held in STATE context'
+- 'ever head as readlock in STATE context'
+- 'ever head with STATE enabled'
+- 'ever head as readlock with STATE enabled'
+
+Where STATE can be either one of (kernel/lockdep_states.h)
+ - hardirq
+ - softirq
+ - reclaim_fs
 
 - 'ever used'                                       [ == !unused        ]
 
-When locking rules are violated, these 4 state bits are presented in the
-locking error messages, inside curlies.  A contrived example:
+When locking rules are violated, these state bits are presented in the
+locking error messages, inside curlies. A contrived example:
 
    modprobe/2287 is trying to acquire lock:
-    (&sio_locks[i].lock){--..}, at: [<c02867fd>] mutex_lock+0x21/0x24
+    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
 
    but task is already holding lock:
-    (&sio_locks[i].lock){--..}, at: [<c02867fd>] mutex_lock+0x21/0x24
+    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
 
 
-The bit position indicates hardirq, softirq, hardirq-read,
-softirq-read respectively, and the character displayed in each
-indicates:
+The bit position indicates STATE, STATE-read, for each of the states listed
+above, and the character displayed in each indicates:
 
    '.'  acquired while irqs disabled
    '+'  acquired in irq context
    '-'  acquired with irqs enabled
-   '?' read acquired in irq context with irqs enabled.
+   '?'  acquired in irq context with irqs enabled.
 
 Unused mutexes cannot be part of the cause of an error.
 
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 23bf02f..5a58ea3 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -20,43 +20,10 @@ struct lockdep_map;
 #include <linux/stacktrace.h>
 
 /*
- * Lock-class usage-state bits:
+ * We'd rather not expose kernel/lockdep_states.h this wide, but we do need
+ * the total number of states... :-(
  */
-enum lock_usage_bit
-{
-	LOCK_USED = 0,
-	LOCK_USED_IN_HARDIRQ,
-	LOCK_USED_IN_SOFTIRQ,
-	LOCK_ENABLED_SOFTIRQS,
-	LOCK_ENABLED_HARDIRQS,
-	LOCK_USED_IN_HARDIRQ_READ,
-	LOCK_USED_IN_SOFTIRQ_READ,
-	LOCK_ENABLED_SOFTIRQS_READ,
-	LOCK_ENABLED_HARDIRQS_READ,
-	LOCK_USAGE_STATES
-};
-
-/*
- * Usage-state bitmasks:
- */
-#define LOCKF_USED			(1 << LOCK_USED)
-#define LOCKF_USED_IN_HARDIRQ		(1 << LOCK_USED_IN_HARDIRQ)
-#define LOCKF_USED_IN_SOFTIRQ		(1 << LOCK_USED_IN_SOFTIRQ)
-#define LOCKF_ENABLED_HARDIRQS		(1 << LOCK_ENABLED_HARDIRQS)
-#define LOCKF_ENABLED_SOFTIRQS		(1 << LOCK_ENABLED_SOFTIRQS)
-
-#define LOCKF_ENABLED_IRQS (LOCKF_ENABLED_HARDIRQS | LOCKF_ENABLED_SOFTIRQS)
-#define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
-
-#define LOCKF_USED_IN_HARDIRQ_READ	(1 << LOCK_USED_IN_HARDIRQ_READ)
-#define LOCKF_USED_IN_SOFTIRQ_READ	(1 << LOCK_USED_IN_SOFTIRQ_READ)
-#define LOCKF_ENABLED_HARDIRQS_READ	(1 << LOCK_ENABLED_HARDIRQS_READ)
-#define LOCKF_ENABLED_SOFTIRQS_READ	(1 << LOCK_ENABLED_SOFTIRQS_READ)
-
-#define LOCKF_ENABLED_IRQS_READ \
-		(LOCKF_ENABLED_HARDIRQS_READ | LOCKF_ENABLED_SOFTIRQS_READ)
-#define LOCKF_USED_IN_IRQ_READ \
-		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
+#define XXX_LOCK_USAGE_STATES		(1+3*4)
 
 #define MAX_LOCKDEP_SUBCLASSES		8UL
 
@@ -97,7 +64,7 @@ struct lock_class {
 	 * IRQ/softirq usage tracking bits:
 	 */
 	unsigned long			usage_mask;
-	struct stack_trace		usage_traces[LOCK_USAGE_STATES];
+	struct stack_trace		usage_traces[XXX_LOCK_USAGE_STATES];
 
 	/*
 	 * These fields represent a directed graph of lock dependencies,
@@ -324,7 +291,11 @@ static inline void lock_set_subclass(struct lockdep_map *lock,
 	lock_set_class(lock, lock->name, lock->key, subclass, ip);
 }
 
-# define INIT_LOCKDEP				.lockdep_recursion = 0,
+extern void lockdep_set_current_reclaim_state(gfp_t gfp_mask);
+extern void lockdep_clear_current_reclaim_state(void);
+extern void lockdep_trace_alloc(gfp_t mask);
+
+# define INIT_LOCKDEP				.lockdep_recursion = 0, .lockdep_reclaim_gfp = 0,
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
@@ -342,6 +313,9 @@ static inline void lockdep_on(void)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
+# define lockdep_set_current_reclaim_state(g)	do { } while (0)
+# define lockdep_clear_current_reclaim_state()	do { } while (0)
+# define lockdep_trace_alloc(g)			do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub) \
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 7a0e5c4..3069ec7 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -50,8 +50,10 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_MUTEXES
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct thread_info	*owner;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
 	void			*magic;
 #endif
@@ -68,7 +70,6 @@ struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
 #ifdef CONFIG_DEBUG_MUTEXES
-	struct mutex		*lock;
 	void			*magic;
 #endif
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2127e95..b00a77f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -331,7 +331,9 @@ extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
@@ -1311,6 +1313,7 @@ struct task_struct {
 	int lockdep_depth;
 	unsigned int lockdep_recursion;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
+	gfp_t lockdep_reclaim_gfp;
 #endif
 
 /* journalling filesystem info */
diff --git a/include/linux/timer.h b/include/linux/timer.h
index daf9685..51774eb 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -5,6 +5,7 @@
 #include <linux/ktime.h>
 #include <linux/stddef.h>
 #include <linux/debugobjects.h>
+#include <linux/stringify.h>
 
 struct tvec_base;
 
@@ -21,52 +22,126 @@ struct timer_list {
 	char start_comm[16];
 	int start_pid;
 #endif
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 extern struct tvec_base boot_tvec_bases;
 
+#ifdef CONFIG_LOCKDEP
+/*
+ * NB: because we have to copy the lockdep_map, setting the lockdep_map key
+ * (second argument) here is required, otherwise it could be initialised to
+ * the copy of the lockdep_map later! We use the pointer to and the string
+ * "<file>:<line>" as the key resp. the name of the lockdep_map.
+ */
+#define __TIMER_LOCKDEP_MAP_INITIALIZER(_kn)				\
+	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(_kn, &_kn),
+#else
+#define __TIMER_LOCKDEP_MAP_INITIALIZER(_kn)
+#endif
+
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.expires = (_expires),				\
 		.data = (_data),				\
 		.base = &boot_tvec_bases,			\
+		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
+			__FILE__ ":" __stringify(__LINE__))	\
 	}
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
 
-void init_timer(struct timer_list *timer);
-void init_timer_deferrable(struct timer_list *timer);
+void init_timer_key(struct timer_list *timer,
+		    const char *name,
+		    struct lock_class_key *key);
+void init_timer_deferrable_key(struct timer_list *timer,
+			       const char *name,
+			       struct lock_class_key *key);
+
+#ifdef CONFIG_LOCKDEP
+#define init_timer(timer)						\
+	do {								\
+		static struct lock_class_key __key;			\
+		init_timer_key((timer), #timer, &__key);		\
+	} while (0)
+
+#define init_timer_deferrable(timer)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		init_timer_deferrable_key((timer), #timer, &__key);	\
+	} while (0)
+
+#define init_timer_on_stack(timer)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		init_timer_on_stack_key((timer), #timer, &__key);	\
+	} while (0)
+
+#define setup_timer(timer, fn, data)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		setup_timer_key((timer), #timer, &__key, (fn), (data));\
+	} while (0)
+
+#define setup_timer_on_stack(timer, fn, data)				\
+	do {								\
+		static struct lock_class_key __key;			\
+		setup_timer_on_stack_key((timer), #timer, &__key,	\
+					 (fn), (data));			\
+	} while (0)
+#else
+#define init_timer(timer)\
+	init_timer_key((timer), NULL, NULL)
+#define init_timer_deferrable(timer)\
+	init_timer_deferrable_key((timer), NULL, NULL)
+#define init_timer_on_stack(timer)\
+	init_timer_on_stack_key((timer), NULL, NULL)
+#define setup_timer(timer, fn, data)\
+	setup_timer_key((timer), NULL, NULL, (fn), (data))
+#define setup_timer_on_stack(timer, fn, data)\
+	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
+#endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
-extern void init_timer_on_stack(struct timer_list *timer);
+extern void init_timer_on_stack_key(struct timer_list *timer,
+				    const char *name,
+				    struct lock_class_key *key);
 extern void destroy_timer_on_stack(struct timer_list *timer);
 #else
 static inline void destroy_timer_on_stack(struct timer_list *timer) { }
-static inline void init_timer_on_stack(struct timer_list *timer)
+static inline void init_timer_on_stack_key(struct timer_list *timer,
+					   const char *name,
+					   struct lock_class_key *key)
 {
-	init_timer(timer);
+	init_timer_key(timer, name, key);
 }
 #endif
 
-static inline void setup_timer(struct timer_list * timer,
+static inline void setup_timer_key(struct timer_list * timer,
+				const char *name,
+				struct lock_class_key *key,
 				void (*function)(unsigned long),
 				unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;
-	init_timer(timer);
+	init_timer_key(timer, name, key);
 }
 
-static inline void setup_timer_on_stack(struct timer_list *timer,
+static inline void setup_timer_on_stack_key(struct timer_list *timer,
+					const char *name,
+					struct lock_class_key *key,
 					void (*function)(unsigned long),
 					unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;
-	init_timer_on_stack(timer);
+	init_timer_on_stack_key(timer, name, key);
 }
 
 /**
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06b0c35..3673a3f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -41,6 +41,7 @@
 #include <linux/utsname.h>
 #include <linux/hash.h>
 #include <linux/ftrace.h>
+#include <linux/stringify.h>
 
 #include <asm/sections.h>
 
@@ -310,12 +311,14 @@ EXPORT_SYMBOL(lockdep_on);
 #if VERBOSE
 # define HARDIRQ_VERBOSE	1
 # define SOFTIRQ_VERBOSE	1
+# define RECLAIM_VERBOSE	1
 #else
 # define HARDIRQ_VERBOSE	0
 # define SOFTIRQ_VERBOSE	0
+# define RECLAIM_VERBOSE	0
 #endif
 
-#if VERBOSE || HARDIRQ_VERBOSE || SOFTIRQ_VERBOSE
+#if VERBOSE || HARDIRQ_VERBOSE || SOFTIRQ_VERBOSE || RECLAIM_VERBOSE
 /*
  * Quick filtering for interesting events:
  */
@@ -443,17 +446,18 @@ atomic_t nr_find_usage_backwards_recursions;
  * Locking printouts:
  */
 
+#define __USAGE(__STATE)						\
+	[LOCK_USED_IN_##__STATE] = "IN-"__stringify(__STATE)"-W",	\
+	[LOCK_ENABLED_##__STATE] = __stringify(__STATE)"-ON-W",		\
+	[LOCK_USED_IN_##__STATE##_READ] = "IN-"__stringify(__STATE)"-R",\
+	[LOCK_ENABLED_##__STATE##_READ] = __stringify(__STATE)"-ON-R",
+
 static const char *usage_str[] =
 {
-	[LOCK_USED] =			"initial-use ",
-	[LOCK_USED_IN_HARDIRQ] =	"in-hardirq-W",
-	[LOCK_USED_IN_SOFTIRQ] =	"in-softirq-W",
-	[LOCK_ENABLED_SOFTIRQS] =	"softirq-on-W",
-	[LOCK_ENABLED_HARDIRQS] =	"hardirq-on-W",
-	[LOCK_USED_IN_HARDIRQ_READ] =	"in-hardirq-R",
-	[LOCK_USED_IN_SOFTIRQ_READ] =	"in-softirq-R",
-	[LOCK_ENABLED_SOFTIRQS_READ] =	"softirq-on-R",
-	[LOCK_ENABLED_HARDIRQS_READ] =	"hardirq-on-R",
+#define LOCKDEP_STATE(__STATE) __USAGE(__STATE)
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+	[LOCK_USED] = "INITIAL USE",
 };
 
 const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
@@ -461,46 +465,45 @@ const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
 	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
 }
 
-void
-get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3, char *c4)
+static inline unsigned long lock_flag(enum lock_usage_bit bit)
 {
-	*c1 = '.', *c2 = '.', *c3 = '.', *c4 = '.';
-
-	if (class->usage_mask & LOCKF_USED_IN_HARDIRQ)
-		*c1 = '+';
-	else
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS)
-			*c1 = '-';
+	return 1UL << bit;
+}
 
-	if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ)
-		*c2 = '+';
-	else
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS)
-			*c2 = '-';
+static char get_usage_char(struct lock_class *class, enum lock_usage_bit bit)
+{
+	char c = '.';
 
-	if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
-		*c3 = '-';
-	if (class->usage_mask & LOCKF_USED_IN_HARDIRQ_READ) {
-		*c3 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
-			*c3 = '?';
+	if (class->usage_mask & lock_flag(bit + 2))
+		c = '+';
+	if (class->usage_mask & lock_flag(bit)) {
+		c = '-';
+		if (class->usage_mask & lock_flag(bit + 2))
+			c = '?';
 	}
 
-	if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS_READ)
-		*c4 = '-';
-	if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ_READ) {
-		*c4 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS_READ)
-			*c4 = '?';
-	}
+	return c;
+}
+
+void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
+{
+	int i = 0;
+
+#define LOCKDEP_STATE(__STATE) 						\
+	usage[i++] = get_usage_char(class, LOCK_USED_IN_##__STATE);	\
+	usage[i++] = get_usage_char(class, LOCK_USED_IN_##__STATE##_READ);
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+
+	usage[i] = '\0';
 }
 
 static void print_lock_name(struct lock_class *class)
 {
-	char str[KSYM_NAME_LEN], c1, c2, c3, c4;
+	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
 	const char *name;
 
-	get_usage_chars(class, &c1, &c2, &c3, &c4);
+	get_usage_chars(class, usage);
 
 	name = class->name;
 	if (!name) {
@@ -513,7 +516,7 @@ static void print_lock_name(struct lock_class *class)
 		if (class->subclass)
 			printk("/%d", class->subclass);
 	}
-	printk("){%c%c%c%c}", c1, c2, c3, c4);
+	printk("){%s}", usage);
 }
 
 static void print_lockdep_cache(struct lockdep_map *lock)
@@ -1263,9 +1266,49 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 			bit_backwards, bit_forwards, irqclass);
 }
 
-static int
-check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
-		struct held_lock *next)
+static const char *state_names[] = {
+#define LOCKDEP_STATE(__STATE) \
+	__stringify(__STATE),
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static const char *state_rnames[] = {
+#define LOCKDEP_STATE(__STATE) \
+	__stringify(__STATE)"-READ",
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static inline const char *state_name(enum lock_usage_bit bit)
+{
+	return (bit & 1) ? state_rnames[bit >> 2] : state_names[bit >> 2];
+}
+
+static int exclusive_bit(int new_bit)
+{
+	/*
+	 * USED_IN
+	 * USED_IN_READ
+	 * ENABLED
+	 * ENABLED_READ
+	 *
+	 * bit 0 - write/read
+	 * bit 1 - used_in/enabled
+	 * bit 2+  state
+	 */
+
+	int state = new_bit & ~3;
+	int dir = new_bit & 2;
+
+	/*
+	 * keep state, bit flip the direction and strip read.
+	 */
+	return state | (dir ^ 2);
+}
+
+static int check_irq_usage(struct task_struct *curr, struct held_lock *prev,
+			   struct held_lock *next, enum lock_usage_bit bit)
 {
 	/*
 	 * Prove that the new dependency does not connect a hardirq-safe
@@ -1273,38 +1316,34 @@ check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
 	 * the backwards-subgraph starting at <prev>, and the
 	 * forwards-subgraph starting at <next>:
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ,
-					LOCK_ENABLED_HARDIRQS, "hard"))
+	if (!check_usage(curr, prev, next, bit,
+			   exclusive_bit(bit), state_name(bit)))
 		return 0;
 
+	bit++; /* _READ */
+
 	/*
 	 * Prove that the new dependency does not connect a hardirq-safe-read
 	 * lock with a hardirq-unsafe lock - to achieve this we search
 	 * the backwards-subgraph starting at <prev>, and the
 	 * forwards-subgraph starting at <next>:
 	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ_READ,
-					LOCK_ENABLED_HARDIRQS, "hard-read"))
+	if (!check_usage(curr, prev, next, bit,
+			   exclusive_bit(bit), state_name(bit)))
 		return 0;
 
-	/*
-	 * Prove that the new dependency does not connect a softirq-safe
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ,
-					LOCK_ENABLED_SOFTIRQS, "soft"))
-		return 0;
-	/*
-	 * Prove that the new dependency does not connect a softirq-safe-read
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ_READ,
-					LOCK_ENABLED_SOFTIRQS, "soft"))
+	return 1;
+}
+
+static int
+check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
+		struct held_lock *next)
+{
+#define LOCKDEP_STATE(__STATE)						\
+	if (!check_irq_usage(curr, prev, next, LOCK_USED_IN_##__STATE))	\
 		return 0;
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 
 	return 1;
 }
@@ -1933,7 +1972,7 @@ void print_irqtrace_events(struct task_struct *curr)
 	print_ip_sym(curr->softirq_disable_ip);
 }
 
-static int hardirq_verbose(struct lock_class *class)
+static int HARDIRQ_verbose(struct lock_class *class)
 {
 #if HARDIRQ_VERBOSE
 	return class_filter(class);
@@ -1941,7 +1980,7 @@ static int hardirq_verbose(struct lock_class *class)
 	return 0;
 }
 
-static int softirq_verbose(struct lock_class *class)
+static int SOFTIRQ_verbose(struct lock_class *class)
 {
 #if SOFTIRQ_VERBOSE
 	return class_filter(class);
@@ -1949,185 +1988,94 @@ static int softirq_verbose(struct lock_class *class)
 	return 0;
 }
 
+static int RECLAIM_FS_verbose(struct lock_class *class)
+{
+#if RECLAIM_VERBOSE
+	return class_filter(class);
+#endif
+	return 0;
+}
+
 #define STRICT_READ_CHECKS	1
 
-static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
-		enum lock_usage_bit new_bit)
+static int (*state_verbose_f[])(struct lock_class *class) = {
+#define LOCKDEP_STATE(__STATE) \
+	__STATE##_verbose,
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
+static inline int state_verbose(enum lock_usage_bit bit,
+				struct lock_class *class)
 {
-	int ret = 1;
+	return state_verbose_f[bit >> 2](class);
+}
 
-	switch(new_bit) {
-	case LOCK_USED_IN_HARDIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQS))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_HARDIRQS_READ))
-			return 0;
-		/*
-		 * just marked it hardirq-safe, check that this lock
-		 * took no hardirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_HARDIRQS, "hard"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it hardirq-safe, check that this lock
-		 * took no hardirq-unsafe-read lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_HARDIRQS_READ, "hard-read"))
-			return 0;
-#endif
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_USED_IN_SOFTIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQS))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_SOFTIRQS_READ))
-			return 0;
-		/*
-		 * just marked it softirq-safe, check that this lock
-		 * took no softirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_SOFTIRQS, "soft"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-safe, check that this lock
-		 * took no softirq-unsafe-read lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_SOFTIRQS_READ, "soft-read"))
-			return 0;
-#endif
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_USED_IN_HARDIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQS))
-			return 0;
-		/*
-		 * just marked it hardirq-read-safe, check that this lock
-		 * took no hardirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_HARDIRQS, "hard"))
-			return 0;
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_USED_IN_SOFTIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQS))
-			return 0;
-		/*
-		 * just marked it softirq-read-safe, check that this lock
-		 * took no softirq-unsafe lock in the past:
-		 */
-		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_SOFTIRQS, "soft"))
-			return 0;
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_ENABLED_HARDIRQS:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_HARDIRQ))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_USED_IN_HARDIRQ_READ))
-			return 0;
-		/*
-		 * just marked it hardirq-unsafe, check that no hardirq-safe
-		 * lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_HARDIRQ, "hard"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it hardirq-unsafe, check that no
-		 * hardirq-safe-read lock in the system ever took
-		 * it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-				   LOCK_USED_IN_HARDIRQ_READ, "hard-read"))
-			return 0;
-#endif
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_ENABLED_SOFTIRQS:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_SOFTIRQ))
-			return 0;
-		if (!valid_state(curr, this, new_bit,
-				 LOCK_USED_IN_SOFTIRQ_READ))
-			return 0;
-		/*
-		 * just marked it softirq-unsafe, check that no softirq-safe
-		 * lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_SOFTIRQ, "soft"))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-unsafe, check that no
-		 * softirq-safe-read lock in the system ever took
-		 * it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-				   LOCK_USED_IN_SOFTIRQ_READ, "soft-read"))
-			return 0;
-#endif
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_ENABLED_HARDIRQS_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_HARDIRQ))
-			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it hardirq-read-unsafe, check that no
-		 * hardirq-safe lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_HARDIRQ, "hard"))
-			return 0;
-#endif
-		if (hardirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	case LOCK_ENABLED_SOFTIRQS_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_SOFTIRQ))
+typedef int (*check_usage_f)(struct task_struct *, struct held_lock *,
+			     enum lock_usage_bit bit, const char *name);
+
+static int
+mark_lock_irq(struct task_struct *curr, struct held_lock *this, int new_bit)
+{
+	int excl_bit = exclusive_bit(new_bit);
+	int read = new_bit & 1;
+	int dir = new_bit & 2;
+
+	/*
+	 * mark USED_IN has to look forwards -- to ensure no dependency
+	 * has ENABLED state, which would allow recursion deadlocks.
+	 *
+	 * mark ENABLED has to look backwards -- to ensure no dependee
+	 * has USED_IN state, which, again, would allow  recursion deadlocks.
+	 */
+	check_usage_f usage = dir ?
+		check_usage_backwards : check_usage_forwards;
+
+	/*
+	 * Validate that this particular lock does not have conflicting
+	 * usage states.
+	 */
+	if (!valid_state(curr, this, new_bit, excl_bit))
+		return 0;
+
+	/*
+	 * Validate that the lock dependencies don't have conflicting usage
+	 * states.
+	 */
+	if ((!read || !dir || STRICT_READ_CHECKS) &&
+			!usage(curr, this, excl_bit, state_name(new_bit)))
+		return 0;
+
+	/*
+	 * Check for read in write conflicts
+	 */
+	if (!read) {
+		if (!valid_state(curr, this, new_bit, excl_bit + 1))
 			return 0;
-#if STRICT_READ_CHECKS
-		/*
-		 * just marked it softirq-read-unsafe, check that no
-		 * softirq-safe lock in the system ever took it in the past:
-		 */
-		if (!check_usage_backwards(curr, this,
-					   LOCK_USED_IN_SOFTIRQ, "soft"))
+
+		if (STRICT_READ_CHECKS &&
+			!usage(curr, this, excl_bit + 1,
+				state_name(new_bit + 1)))
 			return 0;
-#endif
-		if (softirq_verbose(hlock_class(this)))
-			ret = 2;
-		break;
-	default:
-		WARN_ON(1);
-		break;
 	}
 
-	return ret;
+	if (state_verbose(new_bit, hlock_class(this)))
+		return 2;
+
+	return 1;
 }
 
+enum mark_type {
+#define LOCKDEP_STATE(__STATE)	__STATE,
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+};
+
 /*
  * Mark all held locks with a usage bit:
  */
 static int
-mark_held_locks(struct task_struct *curr, int hardirq)
+mark_held_locks(struct task_struct *curr, enum mark_type mark)
 {
 	enum lock_usage_bit usage_bit;
 	struct held_lock *hlock;
@@ -2136,17 +2084,12 @@ mark_held_locks(struct task_struct *curr, int hardirq)
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		hlock = curr->held_locks + i;
 
-		if (hardirq) {
-			if (hlock->read)
-				usage_bit = LOCK_ENABLED_HARDIRQS_READ;
-			else
-				usage_bit = LOCK_ENABLED_HARDIRQS;
-		} else {
-			if (hlock->read)
-				usage_bit = LOCK_ENABLED_SOFTIRQS_READ;
-			else
-				usage_bit = LOCK_ENABLED_SOFTIRQS;
-		}
+		usage_bit = 2 + (mark << 2); /* ENABLED */
+		if (hlock->read)
+			usage_bit += 1; /* READ */
+
+		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
+
 		if (!mark_lock(curr, hlock, usage_bit))
 			return 0;
 	}
@@ -2200,7 +2143,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	 * We are going to turn hardirqs on, so set the
 	 * usage bit for all held locks:
 	 */
-	if (!mark_held_locks(curr, 1))
+	if (!mark_held_locks(curr, HARDIRQ))
 		return;
 	/*
 	 * If we have softirqs enabled, then set the usage
@@ -2208,7 +2151,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	 * this bit from being set before)
 	 */
 	if (curr->softirqs_enabled)
-		if (!mark_held_locks(curr, 0))
+		if (!mark_held_locks(curr, SOFTIRQ))
 			return;
 
 	curr->hardirq_enable_ip = ip;
@@ -2288,7 +2231,7 @@ void trace_softirqs_on(unsigned long ip)
 	 * enabled too:
 	 */
 	if (curr->hardirqs_enabled)
-		mark_held_locks(curr, 0);
+		mark_held_locks(curr, SOFTIRQ);
 }
 
 /*
@@ -2317,6 +2260,48 @@ void trace_softirqs_off(unsigned long ip)
 		debug_atomic_inc(&redundant_softirqs_off);
 }
 
+static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
+{
+	struct task_struct *curr = current;
+
+	if (unlikely(!debug_locks))
+		return;
+
+	/* no reclaim without waiting on it */
+	if (!(gfp_mask & __GFP_WAIT))
+		return;
+
+	/* this guy won't enter reclaim */
+	if ((curr->flags & PF_MEMALLOC) && !(gfp_mask & __GFP_NOMEMALLOC))
+		return;
+
+	/* We're only interested __GFP_FS allocations for now */
+	if (!(gfp_mask & __GFP_FS))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
+		return;
+
+	mark_held_locks(curr, RECLAIM_FS);
+}
+
+static void check_flags(unsigned long flags);
+
+void lockdep_trace_alloc(gfp_t gfp_mask)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lockdep_trace_alloc(gfp_mask, flags);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
 static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 {
 	/*
@@ -2345,19 +2330,35 @@ static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 	if (!hlock->hardirqs_off) {
 		if (hlock->read) {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS_READ))
+					LOCK_ENABLED_HARDIRQ_READ))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS_READ))
+						LOCK_ENABLED_SOFTIRQ_READ))
 					return 0;
 		} else {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS))
+					LOCK_ENABLED_HARDIRQ))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS))
+						LOCK_ENABLED_SOFTIRQ))
+					return 0;
+		}
+	}
+
+	/*
+	 * We reuse the irq context infrastructure more broadly as a general
+	 * context checking code. This tests GFP_FS recursion (a lock taken
+	 * during reclaim for a GFP_FS allocation is held over a GFP_FS
+	 * allocation).
+	 */
+	if (!hlock->trylock && (curr->lockdep_reclaim_gfp & __GFP_FS)) {
+		if (hlock->read) {
+			if (!mark_lock(curr, hlock, LOCK_USED_IN_RECLAIM_FS_READ))
+					return 0;
+		} else {
+			if (!mark_lock(curr, hlock, LOCK_USED_IN_RECLAIM_FS))
 					return 0;
 		}
 	}
@@ -2412,6 +2413,10 @@ static inline int separate_irq_context(struct task_struct *curr,
 	return 0;
 }
 
+void lockdep_trace_alloc(gfp_t gfp_mask)
+{
+}
+
 #endif
 
 /*
@@ -2445,14 +2450,13 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 		return 0;
 
 	switch (new_bit) {
-	case LOCK_USED_IN_HARDIRQ:
-	case LOCK_USED_IN_SOFTIRQ:
-	case LOCK_USED_IN_HARDIRQ_READ:
-	case LOCK_USED_IN_SOFTIRQ_READ:
-	case LOCK_ENABLED_HARDIRQS:
-	case LOCK_ENABLED_SOFTIRQS:
-	case LOCK_ENABLED_HARDIRQS_READ:
-	case LOCK_ENABLED_SOFTIRQS_READ:
+#define LOCKDEP_STATE(__STATE)			\
+	case LOCK_USED_IN_##__STATE:		\
+	case LOCK_USED_IN_##__STATE##_READ:	\
+	case LOCK_ENABLED_##__STATE:		\
+	case LOCK_ENABLED_##__STATE##_READ:
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 		ret = mark_lock_irq(curr, this, new_bit);
 		if (!ret)
 			return 0;
@@ -2966,6 +2970,16 @@ void lock_release(struct lockdep_map *lock, int nested,
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
+void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
+{
+	current->lockdep_reclaim_gfp = gfp_mask;
+}
+
+void lockdep_clear_current_reclaim_state(void)
+{
+	current->lockdep_reclaim_gfp = 0;
+}
+
 #ifdef CONFIG_LOCK_STAT
 static int
 print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 56b1969..a2cc7e9 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -7,6 +7,45 @@
  */
 
 /*
+ * Lock-class usage-state bits:
+ */
+enum lock_usage_bit {
+#define LOCKDEP_STATE(__STATE)		\
+	LOCK_USED_IN_##__STATE,		\
+	LOCK_USED_IN_##__STATE##_READ,	\
+	LOCK_ENABLED_##__STATE,		\
+	LOCK_ENABLED_##__STATE##_READ,
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+	LOCK_USED,
+	LOCK_USAGE_STATES
+};
+
+/*
+ * Usage-state bitmasks:
+ */
+#define __LOCKF(__STATE)	LOCKF_##__STATE = (1 << LOCK_##__STATE),
+
+enum {
+#define LOCKDEP_STATE(__STATE)						\
+	__LOCKF(USED_IN_##__STATE)					\
+	__LOCKF(USED_IN_##__STATE##_READ)				\
+	__LOCKF(ENABLED_##__STATE)					\
+	__LOCKF(ENABLED_##__STATE##_READ)
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+	__LOCKF(USED)
+};
+
+#define LOCKF_ENABLED_IRQ (LOCKF_ENABLED_HARDIRQ | LOCKF_ENABLED_SOFTIRQ)
+#define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
+
+#define LOCKF_ENABLED_IRQ_READ \
+		(LOCKF_ENABLED_HARDIRQ_READ | LOCKF_ENABLED_SOFTIRQ_READ)
+#define LOCKF_USED_IN_IRQ_READ \
+		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
+
+/*
  * MAX_LOCKDEP_ENTRIES is the maximum number of lock dependencies
  * we track.
  *
@@ -31,8 +70,10 @@
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
 
-extern void
-get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3, char *c4);
+#define LOCK_USAGE_CHARS (1+LOCK_USAGE_STATES/2)
+
+extern void get_usage_chars(struct lock_class *class,
+			    char usage[LOCK_USAGE_CHARS]);
 
 extern const char * __get_key_name(struct lockdep_subclass_key *key, char *str);
 
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 13716b8..d7135aa 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -84,7 +84,7 @@ static int l_show(struct seq_file *m, void *v)
 {
 	struct lock_class *class = v;
 	struct lock_list *entry;
-	char c1, c2, c3, c4;
+	char usage[LOCK_USAGE_CHARS];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(m, "all lock classes:\n");
@@ -100,8 +100,8 @@ static int l_show(struct seq_file *m, void *v)
 	seq_printf(m, " BD:%5ld", lockdep_count_backward_deps(class));
 #endif
 
-	get_usage_chars(class, &c1, &c2, &c3, &c4);
-	seq_printf(m, " %c%c%c%c", c1, c2, c3, c4);
+	get_usage_chars(class, usage);
+	seq_printf(m, " %s", usage);
 
 	seq_printf(m, ": ");
 	print_name(m, class);
@@ -300,27 +300,27 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_uncategorized++;
 		if (class->usage_mask & LOCKF_USED_IN_IRQ)
 			nr_irq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_IRQS)
+		if (class->usage_mask & LOCKF_ENABLED_IRQ)
 			nr_irq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ)
 			nr_softirq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS)
+		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ)
 			nr_softirq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_HARDIRQ)
 			nr_hardirq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS)
+		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ)
 			nr_hardirq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_IRQ_READ)
 			nr_irq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_IRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_IRQ_READ)
 			nr_irq_read_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ_READ)
 			nr_softirq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
 			nr_softirq_read_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_HARDIRQ_READ)
 			nr_hardirq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
 			nr_hardirq_read_unsafe++;
 
 #ifdef CONFIG_PROVE_LOCKING
@@ -601,6 +601,10 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 static void seq_header(struct seq_file *m)
 {
 	seq_printf(m, "lock_stat version 0.3\n");
+
+	if (unlikely(!debug_locks))
+		seq_printf(m, "*WARNING* lock debugging disabled!! - possibly due to a lockdep warning\n");
+
 	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
 	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",
diff --git a/kernel/lockdep_states.h b/kernel/lockdep_states.h
new file mode 100644
index 0000000..995b0cc
--- /dev/null
+++ b/kernel/lockdep_states.h
@@ -0,0 +1,9 @@
+/*
+ * Lockdep states,
+ *
+ * please update XXX_LOCK_USAGE_STATES in include/linux/lockdep.h whenever
+ * you add one, or come up with a nice dynamic solution.
+ */
+LOCKDEP_STATE(HARDIRQ)
+LOCKDEP_STATE(SOFTIRQ)
+LOCKDEP_STATE(RECLAIM_FS)
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index 1d94160..50d022e 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -26,11 +26,6 @@
 /*
  * Must be called with lock->wait_lock held.
  */
-void debug_mutex_set_owner(struct mutex *lock, struct thread_info *new_owner)
-{
-	lock->owner = new_owner;
-}
-
 void debug_mutex_lock_common(struct mutex *lock, struct mutex_waiter *waiter)
 {
 	memset(waiter, MUTEX_DEBUG_INIT, sizeof(*waiter));
@@ -59,7 +54,6 @@ void debug_mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 
 	/* Mark the current thread as blocked on the lock: */
 	ti->task->blocked_on = waiter;
-	waiter->lock = lock;
 }
 
 void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
@@ -82,7 +76,7 @@ void debug_mutex_unlock(struct mutex *lock)
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	mutex_clear_owner(lock);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +89,6 @@ void debug_mutex_init(struct mutex *lock, const char *name,
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->owner = NULL;
 	lock->magic = lock;
 }
 
diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index babfbdf..6b2d735 100644
--- a/kernel/mutex-debug.h
+++ b/kernel/mutex-debug.h
@@ -13,14 +13,6 @@
 /*
  * This must be called with lock->wait_lock held.
  */
-extern void
-debug_mutex_set_owner(struct mutex *lock, struct thread_info *new_owner);
-
-static inline void debug_mutex_clear_owner(struct mutex *lock)
-{
-	lock->owner = NULL;
-}
-
 extern void debug_mutex_lock_common(struct mutex *lock,
 				    struct mutex_waiter *waiter);
 extern void debug_mutex_wake_waiter(struct mutex *lock,
@@ -35,6 +27,16 @@ extern void debug_mutex_unlock(struct mutex *lock);
 extern void debug_mutex_init(struct mutex *lock, const char *name,
 			     struct lock_class_key *key);
 
+static inline void mutex_set_owner(struct mutex *lock)
+{
+	lock->owner = current_thread_info();
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+	lock->owner = NULL;
+}
+
 #define spin_lock_mutex(lock, flags)			\
 	do {						\
 		struct mutex *l = container_of(lock, struct mutex, wait_lock); \
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 4f45d4b..5d79781 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -10,6 +10,11 @@
  * Many thanks to Arjan van de Ven, Thomas Gleixner, Steven Rostedt and
  * David Howells for suggestions and improvements.
  *
+ *  - Adaptive spinning for mutexes by Peter Zijlstra. (Ported to mainline
+ *    from the -rt tree, where it was originally implemented for rtmutexes
+ *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
+ *    and Sven Dietrich.
+ *
  * Also see Documentation/mutex-design.txt.
  */
 #include <linux/mutex.h>
@@ -46,6 +51,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
+	mutex_clear_owner(lock);
 
 	debug_mutex_init(lock, name, key);
 }
@@ -91,6 +97,7 @@ void inline __sched mutex_lock(struct mutex *lock)
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	mutex_set_owner(lock);
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,6 +122,14 @@ void __sched mutex_unlock(struct mutex *lock)
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+#ifndef CONFIG_DEBUG_MUTEXES
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_clear_owner(lock);
+#endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -129,21 +144,75 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
-	unsigned int old_val;
 	unsigned long flags;
 
+	preempt_disable();
+	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+	/*
+	 * Optimistic spinning.
+	 *
+	 * We try to spin for acquisition when we find that there are no
+	 * pending waiters and the lock owner is currently running on a
+	 * (different) CPU.
+	 *
+	 * The rationale is that if the lock owner is running, it is likely to
+	 * release the lock soon.
+	 *
+	 * Since this needs the lock owner, and this mutex implementation
+	 * doesn't track the owner atomically in the lock field, we need to
+	 * track it non-atomically.
+	 *
+	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
+	 * to serialize everything.
+	 */
+
+	for (;;) {
+		struct thread_info *owner;
+
+		/*
+		 * If there's an owner, wait for it to either
+		 * release the lock or go to sleep.
+		 */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
+
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			mutex_set_owner(lock);
+			preempt_enable();
+			return 0;
+		}
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(task)))
+			break;
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		cpu_relax();
+	}
+#endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	old_val = atomic_xchg(&lock->count, -1);
-	if (old_val == 1)
+	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 
 	lock_contended(&lock->dep_map, ip);
@@ -158,8 +227,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		old_val = atomic_xchg(&lock->count, -1);
-		if (old_val == 1)
+		if (atomic_xchg(&lock->count, -1) == 1)
 			break;
 
 		/*
@@ -173,21 +241,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
 			debug_mutex_free_waiter(&waiter);
+			preempt_enable();
 			return -EINTR;
 		}
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
+		__schedule();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
+	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -196,6 +265,7 @@ done:
 	spin_unlock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_free_waiter(&waiter);
+	preempt_enable();
 
 	return 0;
 }
@@ -222,7 +292,8 @@ int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
+				   subclass, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -260,8 +331,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 
@@ -298,18 +367,30 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
  */
 int __sched mutex_lock_interruptible(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	ret =  __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_interruptible_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
 int __sched mutex_lock_killable(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	ret = __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_killable_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -352,9 +433,10 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+		mutex_set_owner(lock);
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
+
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -380,8 +462,13 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	return __mutex_fastpath_trylock(&lock->count,
-					__mutex_trylock_slowpath);
+	int ret;
+
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	if (ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_trylock);
diff --git a/kernel/mutex.h b/kernel/mutex.h
index a075daf..67578ca 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -16,8 +16,26 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#define debug_mutex_set_owner(lock, new_owner)		do { } while (0)
-#define debug_mutex_clear_owner(lock)			do { } while (0)
+#ifdef CONFIG_SMP
+static inline void mutex_set_owner(struct mutex *lock)
+{
+	lock->owner = current_thread_info();
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+	lock->owner = NULL;
+}
+#else
+static inline void mutex_set_owner(struct mutex *lock)
+{
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+}
+#endif
+
 #define debug_mutex_wake_waiter(lock, waiter)		do { } while (0)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)
diff --git a/kernel/sched.c b/kernel/sched.c
index 8ee437a..186c6fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4548,15 +4548,13 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 /*
  * schedule() is the main scheduler function.
  */
-asmlinkage void __sched schedule(void)
+asmlinkage void __sched __schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
-need_resched:
-	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_qsctr_inc(cpu);
@@ -4613,13 +4611,80 @@ need_resched_nonpreemptible:
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
+}
 
+asmlinkage void __sched schedule(void)
+{
+need_resched:
+	preempt_disable();
+	__schedule();
 	preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
 }
 EXPORT_SYMBOL(schedule);
 
+#ifdef CONFIG_SMP
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+{
+	unsigned int cpu;
+	struct rq *rq;
+
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * Need to access the cpu field knowing that
+	 * DEBUG_PAGEALLOC could have unmapped it if
+	 * the mutex owner just released it and exited.
+	 */
+	if (probe_kernel_address(&owner->cpu, cpu))
+		goto out;
+#else
+	cpu = owner->cpu;
+#endif
+
+	/*
+	 * Even if the access succeeded (likely case),
+	 * the cpu field may no longer be valid.
+	 */
+	if (cpu >= nr_cpumask_bits)
+		goto out;
+
+	/*
+	 * We need to validate that we can do a
+	 * get_cpu() and that we have the percpu area.
+	 */
+	if (!cpu_online(cpu))
+		goto out;
+
+	rq = cpu_rq(cpu);
+
+	for (;;) {
+		/*
+		 * Owner changed, break to re-assess state.
+		 */
+		if (lock->owner != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner || need_resched())
+			return 0;
+
+		cpu_relax();
+	}
+out:
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..07bc02e 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(OWNER_SPIN, 1)
diff --git a/kernel/timer.c b/kernel/timer.c
index 13dd64f..ef1c385 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -491,14 +491,18 @@ static inline void debug_timer_free(struct timer_list *timer)
 	debug_object_free(timer, &timer_debug_descr);
 }
 
-static void __init_timer(struct timer_list *timer);
+static void __init_timer(struct timer_list *timer,
+			 const char *name,
+			 struct lock_class_key *key);
 
-void init_timer_on_stack(struct timer_list *timer)
+void init_timer_on_stack_key(struct timer_list *timer,
+			     const char *name,
+			     struct lock_class_key *key)
 {
 	debug_object_init_on_stack(timer, &timer_debug_descr);
-	__init_timer(timer);
+	__init_timer(timer, name, key);
 }
-EXPORT_SYMBOL_GPL(init_timer_on_stack);
+EXPORT_SYMBOL_GPL(init_timer_on_stack_key);
 
 void destroy_timer_on_stack(struct timer_list *timer)
 {
@@ -512,7 +516,9 @@ static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
 #endif
 
-static void __init_timer(struct timer_list *timer)
+static void __init_timer(struct timer_list *timer,
+			 const char *name,
+			 struct lock_class_key *key)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -521,6 +527,7 @@ static void __init_timer(struct timer_list *timer)
 	timer->start_pid = -1;
 	memset(timer->start_comm, 0, TASK_COMM_LEN);
 #endif
+	lockdep_init_map(&timer->lockdep_map, name, key, 0);
 }
 
 /**
@@ -530,19 +537,23 @@ static void __init_timer(struct timer_list *timer)
  * init_timer() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
-void init_timer(struct timer_list *timer)
+void init_timer_key(struct timer_list *timer,
+		    const char *name,
+		    struct lock_class_key *key)
 {
 	debug_timer_init(timer);
-	__init_timer(timer);
+	__init_timer(timer, name, key);
 }
-EXPORT_SYMBOL(init_timer);
+EXPORT_SYMBOL(init_timer_key);
 
-void init_timer_deferrable(struct timer_list *timer)
+void init_timer_deferrable_key(struct timer_list *timer,
+			       const char *name,
+			       struct lock_class_key *key)
 {
-	init_timer(timer);
+	init_timer_key(timer, name, key);
 	timer_set_deferrable(timer);
 }
-EXPORT_SYMBOL(init_timer_deferrable);
+EXPORT_SYMBOL(init_timer_deferrable_key);
 
 static inline void detach_timer(struct timer_list *timer,
 				int clear_pending)
@@ -789,6 +800,15 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  */
 int del_timer_sync(struct timer_list *timer)
 {
+#ifdef CONFIG_LOCKDEP
+	unsigned long flags;
+
+	local_irq_save(flags);
+	lock_map_acquire(&timer->lockdep_map);
+	lock_map_release(&timer->lockdep_map);
+	local_irq_restore(flags);
+#endif
+
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -861,10 +881,36 @@ static inline void __run_timers(struct tvec_base *base)
 
 			set_running_timer(base, timer);
 			detach_timer(timer, 1);
+
 			spin_unlock_irq(&base->lock);
 			{
 				int preempt_count = preempt_count();
+
+#ifdef CONFIG_LOCKDEP
+				/*
+				 * It is permissible to free the timer from
+				 * inside the function that is called from
+				 * it, this we need to take into account for
+				 * lockdep too. To avoid bogus "held lock
+				 * freed" warnings as well as problems when
+				 * looking into timer->lockdep_map, make a
+				 * copy and use that here.
+				 */
+				struct lockdep_map lockdep_map =
+					timer->lockdep_map;
+#endif
+				/*
+				 * Couple the lock chain with the lock chain at
+				 * del_timer_sync() by acquiring the lock_map
+				 * around the fn() call here and in
+				 * del_timer_sync().
+				 */
+				lock_map_acquire(&lockdep_map);
+
 				fn(data);
+
+				lock_map_release(&lockdep_map);
+
 				if (preempt_count != preempt_count()) {
 					printk(KERN_ERR "huh, entered %p "
 					       "with preempt_count %08x, exited"
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5675b30..22b15a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1479,6 +1479,8 @@ __alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
 	unsigned long did_some_progress;
 	unsigned long pages_reclaimed = 0;
 
+	lockdep_trace_alloc(gfp_mask);
+
 	might_sleep_if(wait);
 
 	if (should_fail_alloc_page(gfp_mask, order))
@@ -1578,12 +1580,15 @@ nofail_alloc:
 	 */
 	cpuset_update_task_memory_state();
 	p->flags |= PF_MEMALLOC;
+
+	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
 	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
 
 	p->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
 	p->flags &= ~PF_MEMALLOC;
 
 	cond_resched();
diff --git a/mm/slab.c b/mm/slab.c
index ddc41f3..6b61de8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3318,6 +3318,8 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	unsigned long save_flags;
 	void *ptr;
 
+	lockdep_trace_alloc(flags);
+
 	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
@@ -3394,6 +3396,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	unsigned long save_flags;
 	void *objp;
 
+	lockdep_trace_alloc(flags);
+
 	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
diff --git a/mm/slob.c b/mm/slob.c
index bf7e8fc..4b1c0c1 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -464,6 +464,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 
+	lockdep_trace_alloc(gfp);
+
 	if (size < PAGE_SIZE - align) {
 		if (!size)
 			return ZERO_SIZE_PTR;
diff --git a/mm/slub.c b/mm/slub.c
index bdc9abb..214eb20 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1596,6 +1596,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	unsigned long flags;
 	unsigned int objsize;
 
+	lockdep_trace_alloc(gfpflags);
 	might_sleep_if(gfpflags & __GFP_WAIT);
 
 	if (should_failslab(s->objsize, gfpflags))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9a27c44..cf84413 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1965,6 +1965,8 @@ static int kswapd(void *p)
 	};
 	node_to_cpumask_ptr(cpumask, pgdat->node_id);
 
+	lockdep_set_current_reclaim_state(GFP_KERNEL);
+
 	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(tsk, cpumask);
 	current->reclaim_state = &reclaim_state;
