Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290AbXAXLdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbXAXLdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXAXLdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:33:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbXAXLdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:33:19 -0500
Date: Wed, 24 Jan 2007 12:31:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] lock stat for -rt 2.6.20-rc2-rt2.2.lock_stat.patch
Message-ID: <20070124113115.GA12667@elte.hu>
References: <9D2C22909C6E774EBFB8B5583AE5291C019998CA@fmsmsx414.amr.corp.intel.com> <20061229232618.GA11239@gnuppy.monkey.org> <20061230111940.GA8412@elte.hu> <20070103074124.GA25594@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070103074124.GA25594@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> Patch here:
> 
> 	http://mmlinux.sourceforge.net/public/patch-2.6.20-rc2-rt2.2.lock_stat.patch

hm, most of the review feedback i gave has not been addressed in the 
patch above. So i did it myself: find below various fixups for problems 
i outlined plus for a few other problems as well (ontop of 
2.3.lock_stat).

While it's now markedly better it's still not quite mergeable, for 
example the build fails quite spectacularly if LOCK_STAT is disabled in 
the .config.

Also, it would be nice to replace those #ifdef CONFIG_LOCK_STAT changes 
in rtmutex.c with some nice inline functions that do nothing on 
!CONFIG_LOCK_STAT.

but in general i'm positive about the direction this is heading, it just 
needs more work.

	Ingo

---
 include/linux/eventpoll.h |    3 
 include/linux/lock_stat.h |   50 +-----
 include/linux/sched.h     |    3 
 kernel/futex.c            |    6 
 kernel/lock_stat.c        |  352 +++++++++++++++-------------------------------
 kernel/rtmutex.c          |    4 
 6 files changed, 139 insertions(+), 279 deletions(-)

Index: linux/include/linux/eventpoll.h
===================================================================
--- linux.orig/include/linux/eventpoll.h
+++ linux/include/linux/eventpoll.h
@@ -15,7 +15,6 @@
 #define _LINUX_EVENTPOLL_H
 
 #include <linux/types.h>
-#include <linux/lock_stat.h>
 
 
 /* Valid opcodes to issue to sys_epoll_ctl() */
@@ -46,6 +45,8 @@ struct epoll_event {
 
 #ifdef __KERNEL__
 
+#include <linux/lock_stat.h>
+
 /* Forward declarations to avoid compiler errors */
 struct file;
 
Index: linux/include/linux/lock_stat.h
===================================================================
--- linux.orig/include/linux/lock_stat.h
+++ linux/include/linux/lock_stat.h
@@ -1,18 +1,8 @@
 /*
  * By Bill Huey (hui) at <billh@gnuppy.monkey.org>
  *
- * Release under the what ever the Linux kernel chooses for a
- * license, GNU Public License GPL v2
- *
- * Tue Sep  5 17:27:48 PDT 2006
- *	Created lock_stat.h
- *
- * Wed Sep  6 15:36:14 PDT 2006
- *	Thinking about the object lifetime of a spinlock. Please refer to
- *	comments in kernel/lock_stat.c instead.
- *
+ * Released under GNU Public License GPL v2
  */
-
 #ifndef	LOCK_STAT_H
 #define LOCK_STAT_H
 
@@ -86,23 +76,14 @@ extern void lock_stat_sys_init(void);
 #define lock_stat_is_initialized(o) ((unsigned long) (*o)->file)
 
 extern void lock_stat_note(lock_stat_ref_t *ls, struct task_struct *owner,
-				     			 unsigned long ip,
-								int handoff);
+			   unsigned long ip, int handoff);
 extern void lock_stat_print(void);
 extern int lock_stat_scoped_attach(lock_stat_ref_t *_s,
-				    LOCK_STAT_NOTE_PARAM_DECL);
+				   LOCK_STAT_NOTE_PARAM_DECL);
 
-#define ksym_strcmp(a, b) strncmp(a, b, KSYM_NAME_LEN)
-#define ksym_strcpy(a, b) strncpy(a, b, KSYM_NAME_LEN)
-#define ksym_strlen(a) strnlen(a, KSYM_NAME_LEN)
-
-/*
-static inline char * ksym_strdup(const char *a)
-{
-	char *s = (char *) kmalloc(ksym_strlen(a), GFP_KERNEL);
-	return strncpy(s, a, KSYM_NAME_LEN);
-}
-*/
+#define ksym_strcmp(a, b)	strncmp(a, b, KSYM_NAME_LEN)
+#define ksym_strcpy(a, b)	strncpy(a, b, KSYM_NAME_LEN)
+#define ksym_strlen(a)		strnlen(a, KSYM_NAME_LEN)
 
 #define LS_INIT(name, h) {				\
 	/*.function,*/ .file = h, .line = 1,		\
@@ -115,29 +96,14 @@ static inline char * ksym_strdup(const c
 #define DECLARE_LS_ENTRY(name)				\
 	extern struct lock_stat _lock_stat_##name##_entry
 
-/*	char _##name##_string[] = #name;		\
-*/
-
 #define DEFINE_LS_ENTRY(name)				\
 	struct lock_stat _lock_stat_##name##_entry = 	\
 		LS_INIT(_lock_stat_##name##_entry, #name "_string")
 
 DECLARE_LS_ENTRY(d_alloc);
 DECLARE_LS_ENTRY(eventpoll_init_file);
-/*
-DECLARE_LS_ENTRY(get_empty_filp);
-DECLARE_LS_ENTRY(init_once_1);
-DECLARE_LS_ENTRY(init_once_2);
-DECLARE_LS_ENTRY(inode_init_once_1);
-DECLARE_LS_ENTRY(inode_init_once_2);
-DECLARE_LS_ENTRY(inode_init_once_3);
-DECLARE_LS_ENTRY(inode_init_once_4);
-DECLARE_LS_ENTRY(inode_init_once_5);
-DECLARE_LS_ENTRY(inode_init_once_6);
-DECLARE_LS_ENTRY(inode_init_once_7);
-*/
 
-#else /* CONFIG_LOCK_STAT  */
+#else /* CONFIG_LOCK_STAT */
 
 #define __COMMA_LOCK_STAT_FN_DECL
 #define __COMMA_LOCK_STAT_FN_VAR
@@ -147,7 +113,7 @@ DECLARE_LS_ENTRY(inode_init_once_7);
 #define __COMMA_LOCK_STAT_NOTE_FLLN
 #define __COMMA_LOCK_STAT_NOTE_FLLN_VARS
 
-#define __COMMA_LOCK_STAT_INITIALIZER	
+#define __COMMA_LOCK_STAT_INITIALIZER
 
 #define __COMMA_LOCK_STAT_IP_DECL
 #define __COMMA_LOCK_STAT_IP
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -236,6 +236,9 @@ extern void sched_init(void);
 extern void sched_init_smp(void);
 extern void init_idle(struct task_struct *idle, int cpu);
 
+extern int task_on_rq(int cpu, struct task_struct *p);
+extern struct task_struct *get_task_on_rq(int cpu);
+
 extern cpumask_t nohz_cpu_mask;
 
 /*
Index: linux/kernel/futex.c
===================================================================
--- linux.orig/kernel/futex.c
+++ linux/kernel/futex.c
@@ -760,7 +760,8 @@ retry:
 		(*pi_state)->key = *key;
 
 		/* init the mutex without owner */
-		__rt_mutex_init(&(*pi_state)->pi_mutex, NULL);
+		__rt_mutex_init(&(*pi_state)->pi_mutex, NULL
+				__COMMA_LOCK_STAT_NOTE);
 	}
 
 	return 0;
@@ -2773,7 +2774,8 @@ retry:
 		(*pi_state)->key = *key;
 
 		/* init the mutex without owner */
-		__rt_mutex_init(&(*pi_state)->pi_mutex, NULL);
+		__rt_mutex_init(&(*pi_state)->pi_mutex, NULL
+				__COMMA_LOCK_STAT_NOTE);
 	}
 
 	return 0;
Index: linux/kernel/lock_stat.c
===================================================================
--- linux.orig/kernel/lock_stat.c
+++ linux/kernel/lock_stat.c
@@ -1,45 +1,9 @@
 /*
- * lock_stat.h
+ * kernel/lock_stat.c
  *
  * By Bill Huey (hui) billh@gnuppy.monkey.org
- * Release under GPL license compatible with the Linux kernel
  *
- * Tue Sep  5 17:27:48 PDT 2006
- * Started after thinking about the problem the of Burning Man 2006 and lock
- * lifetimes, scoping of those objects, etc...
- *
- * Thu Sep 14 04:01:26 PDT 2006
- * Some of this elaborate list handling stuff might not be necessary since I
- * can attach all of the spinlocks at spin_lock_init() time, etc... It can be
- * done out of line from the contention event. It's just a matter of how to
- * detect and record contentions for spinlocks are statically initialized
- * being the last part of what I need get this all going. I thought about that
- * last night after going to BaG and talking to Mitch a bunch about this.
- *
- * Fri Sep 15 04:27:47 PDT 2006
- * I maybe have greatly simplified this today during the drive down here to
- * SD. Keep all of the statically defined stuff late, but protect the
- * persistent list by a simple spinlock and append it to the list immediately.
- * This is possible because the static initializer stuff handles proper insert
- * of the lock_stat struct during calls to spin_lock_init() for all other
- * insertion cases.
- * 
- * Special thanks go to Zwane and Peter for helping me with an initial
- * implemention using RCU and lists even though that's now been replaced by
- * something that's better and much simpler.
- *
- * Thu Sep 21 23:38:48 PDT 2006 
- * I'm in San Diego this last week or so and I've been auditing the kernel
- * for spinlock and rwlocks to see if they are statically defined or scoped.
- * I finished that audit last night.
- *
- * Mon Sep 25 21:49:43 PDT 2006
- * Back in SF as of last night. Think about what I need to do to get rudimentary
- * testing in place so that I know this code isn't going to crash the kernel.
- *
- * Fri Nov 24 19:06:31 PST 2006
- * As suggested by peterz, I removed the init_wait_queue stuff since lockdep
- * already apparently has handled it.
+ * Released under GNU Public License GPL v2
  */
 
 #include <linux/kernel.h>
@@ -78,8 +42,10 @@ static DEFINE_LS_ENTRY(inline);		/* lock
 static DEFINE_LS_ENTRY(untracked);	/* lock_stat_untracked_entry	*/
 static DEFINE_LS_ENTRY(preinit);	/* lock_stat_preinit_entry	*/
 
-/* To be use for avoiding the dynamic attachment of spinlocks at runtime
- * by attaching it inline with the lock initialization function */
+/*
+ * To be used for avoiding the dynamic attachment of spinlocks at runtime
+ * by attaching it inline with the lock initialization function:
+ */
 
 DEFINE_LS_ENTRY(d_alloc);
 EXPORT_SYMBOL(_lock_stat_d_alloc_entry);
@@ -88,64 +54,32 @@ DEFINE_LS_ENTRY(eventpoll_init_file);
 EXPORT_SYMBOL(_lock_stat_eventpoll_init_file_entry);
 
 /*
-static DEFINE_LS_ENTRY(__pte_alloc);
-static DEFINE_LS_ENTRY(get_empty_filp);
-static DEFINE_LS_ENTRY(init_waitqueue_head);
-static DEFINE_LS_ENTRY(init_buffer_head_1);
-static DEFINE_LS_ENTRY(init_buffer_head_2);
-static DEFINE_LS_ENTRY(init_once_1);
-static DEFINE_LS_ENTRY(init_once_2);
-static DEFINE_LS_ENTRY(inode_init_once_1);
-static DEFINE_LS_ENTRY(inode_init_once_2);
-static DEFINE_LS_ENTRY(inode_init_once_3);
-static DEFINE_LS_ENTRY(inode_init_once_4);
-static DEFINE_LS_ENTRY(inode_init_once_5);
-static DEFINE_LS_ENTRY(inode_init_once_6);
-static DEFINE_LS_ENTRY(inode_init_once_7);
-static DEFINE_LS_ENTRY(inode_init_once_8);
-static DEFINE_LS_ENTRY(mm_init_1);
-static DEFINE_LS_ENTRY(mm_init_2);
-static DEFINE_LS_ENTRY(mm_init_3);
-static DEFINE_LS_ENTRY(skb_queue_init);
-static DEFINE_LS_ENTRY(tcp_init_1);
-static DEFINE_LS_ENTRY(tcp_init_2);
-*/
-
-/*
- * I should never have to create more entries that this since I audited the
- * kernel and found out that there are only ~1500 or so places in the kernel
- * where these rw/spinlocks are initialized. Use the initialization points as a
+ * Should be enough for now. Use the initialization points as a
  * hash value to look up the backing objects
  */
-
-#define MAGIC_ENTRIES 1600
+#define LOCKSTAT_ENTRIES 1600
 
 static int lock_stat_procfs_init(void);
 static void lock_stat_insert_object(struct lock_stat *);
 
-static int lock_stat_inited = 0;
+static int lock_stat_inited;
+
+static int missed, attached, left_insert, right_insert;
 
-static int missed = 0, attached = 0, left_insert = 0, right_insert = 0;
-	
-static int lookup_failed_scoped = 0, lookup_failed_static = 0, static_found = 0; 
-static int failure_events = 0;
+static int lookup_failed_scoped, lookup_failed_static, static_found;
+static int failure_events;
 
-static
-DEFINE_PER_CPU(atomic_t, lock_stat_total_events);
+static DEFINE_PER_CPU(atomic_t, lock_stat_total_events);
 
-static
-struct rb_root lock_stat_rbtree_db = RB_ROOT;
+static struct rb_root lock_stat_rbtree_db = RB_ROOT;
 
 static void lock_stat_rbtree_db_print(struct seq_file *seq);
 static void _lock_stat_rbtree_db_print(struct seq_file *seq,
-							struct rb_node *node,
-							int level);
-
+				       struct rb_node *node, int level);
 static void lock_stat_rbtree_db_zero(void);
 static void _lock_stat_rbtree_db_zero(struct rb_node *node);
 
-static
-void lock_stat_rbtree_db_zero(void)
+static void lock_stat_rbtree_db_zero(void)
 {
 	_lock_stat_rbtree_db_zero(lock_stat_rbtree_db.rb_node);
 }
@@ -153,10 +87,9 @@ void lock_stat_rbtree_db_zero(void)
 void lock_stat_init(struct lock_stat *oref)
 {
 	oref->function[0]	= 0;
-	oref->file	= NULL;
-	oref->line	= 0;
-
-	oref->ntracked	= 0;
+	oref->file		= NULL;
+	oref->line		= 0;
+	oref->ntracked		= 0;
 	atomic_set(&oref->ninlined, 0);
 	atomic_set(&oref->ncontended, 0);
 	atomic_set(&oref->nspinnable, 0);
@@ -172,9 +105,8 @@ void lock_stat_reset_stats(void)
 
 	lock_stat_rbtree_db_zero();
 
-	for_each_possible_cpu(cpu) {
+	for_each_possible_cpu(cpu)
 		atomic_set(&per_cpu(lock_stat_total_events, cpu), 0);
-	}
 }
 
 void lock_stat_sys_init(void)
@@ -182,24 +114,23 @@ void lock_stat_sys_init(void)
 	struct lock_stat *s;
 	int i;
 
-	for (i = 0; i < MAGIC_ENTRIES; ++i) {
+	for (i = 0; i < LOCKSTAT_ENTRIES; ++i) {
 		s = kmalloc(sizeof(struct lock_stat), GFP_KERNEL);
 
 		if (s) {
 			lock_stat_init(s);
 			list_add_tail(&s->list_head, &lock_stat_free_store);
-		}
-		else {
+		} else {
 			printk("%s: kmalloc returned NULL\n", __func__);
 			return;
 		}
 	}
 
-	lock_stat_insert_object(&_lock_stat_inline_entry); 
-	lock_stat_insert_object(&_lock_stat_untracked_entry); 
-	lock_stat_insert_object(&_lock_stat_preinit_entry); 
+	lock_stat_insert_object(&_lock_stat_inline_entry);
+	lock_stat_insert_object(&_lock_stat_untracked_entry);
+	lock_stat_insert_object(&_lock_stat_preinit_entry);
 
-	lock_stat_insert_object(&_lock_stat_d_alloc_entry); 
+	lock_stat_insert_object(&_lock_stat_d_alloc_entry);
 	lock_stat_insert_object(&_lock_stat_eventpoll_init_file_entry);
 
 	lock_stat_procfs_init();
@@ -208,9 +139,9 @@ void lock_stat_sys_init(void)
 	lock_stat_inited = 1;
 }
 
-static
-struct lock_stat *lock_stat_allocate_object(void)
+static struct lock_stat *lock_stat_allocate_object(void)
 {
+	struct lock_stat *s = NULL;
 	unsigned long flags;
 
 	if (!lock_stat_inited)
@@ -219,65 +150,57 @@ struct lock_stat *lock_stat_allocate_obj
 	spin_lock_irqsave(&free_store_lock, flags);
 	if (!list_empty(&lock_stat_free_store)) {
 		struct list_head *e = lock_stat_free_store.next;
-		struct lock_stat *s;
 
 		s = container_of(e, struct lock_stat, list_head);
 		list_del(e);
-
-		spin_unlock_irqrestore(&free_store_lock, flags);
-
-		return s;
 	}
 	spin_unlock_irqrestore(&free_store_lock, flags);
 
-	return NULL;
+	return s;
 }
 
 /*
  * For ordered insertion into a tree. The (entry - object) order of
  * comparison is switched from the parameter definition.
  */
-static
-int lock_stat_compare_objs(struct lock_stat *x, struct lock_stat *y)
+static int lock_stat_compare_objs(struct lock_stat *x, struct lock_stat *y)
 {
-	int a = 0, b = 0, c = 0;
+	if (!ksym_strcmp(x->function, y->function))
+		return 0;
 
-	(a = ksym_strcmp(x->function, y->function))	||
-	(b = ksym_strcmp(x->file, y->file))		||
-	(c = (x->line - y->line));
+	if (!ksym_strcmp(x->file, y->file))
+		return 0;
 
-	return a | b | c;
+	return x->line == y->line;
 }
 
-static
-int lock_stat_compare_key_to_obj(LOCK_STAT_NOTE_PARAM_DECL, struct lock_stat *x)
+static int
+lock_stat_compare_key_to_obj(LOCK_STAT_NOTE_PARAM_DECL, struct lock_stat *x)
 {
-	int a = 0, b = 0, c = 0;
+	if (!ksym_strcmp(_function, x->function))
+		return 0;
 
-	(a = ksym_strcmp(_function, x->function))	||
-	(b = ksym_strcmp(_file, x->file))		||
-	(c = (_line - x->line));
+	if (!ksym_strcmp(_file, x->file))
+		return 0;
 
-	return a | b | c;
+	return _line - x->line;
 }
 
-static
-void lock_stat_print_entry(struct seq_file *seq, struct lock_stat *o)
+static void lock_stat_print_entry(struct seq_file *seq, struct lock_stat *o)
 {
 	seq_printf(seq, "[%d, %d, %d -- %d, %d]\t\t{%s, %s, %d}\n",
-						atomic_read(&o->ncontended),
-						atomic_read(&o->nspinnable),
-						atomic_read(&o->nhandoff),
-						o->ntracked,
-						atomic_read(&o->ninlined),
-						o->function,
-						o->file,
-						o->line
-						);
+			atomic_read(&o->ncontended),
+			atomic_read(&o->nspinnable),
+			atomic_read(&o->nhandoff),
+			o->ntracked,
+			atomic_read(&o->ninlined),
+			o->function,
+			o->file,
+			o->line
+	);
 }
 
-static
-void _lock_stat_rbtree_db_zero(struct rb_node *node)
+static void _lock_stat_rbtree_db_zero(struct rb_node *node)
 {
 	struct lock_stat *o = container_of(node, struct lock_stat, rb_node);
 
@@ -292,15 +215,14 @@ void _lock_stat_rbtree_db_zero(struct rb
 	_lock_stat_rbtree_db_zero(node->rb_right);
 }
 
-static
-void lock_stat_rbtree_db_print(struct seq_file *seq)
+static void lock_stat_rbtree_db_print(struct seq_file *seq)
 {
 	_lock_stat_rbtree_db_print(seq, lock_stat_rbtree_db.rb_node, 0);
 }
 
-static
-void _lock_stat_rbtree_db_print(struct seq_file *seq, struct rb_node *node,
-							int level)
+static void
+_lock_stat_rbtree_db_print(struct seq_file *seq, struct rb_node *node,
+			   int level)
 {
 	struct lock_stat *o = container_of(node, struct lock_stat, rb_node);
 
@@ -314,8 +236,7 @@ void _lock_stat_rbtree_db_print(struct s
 	_lock_stat_rbtree_db_print(seq, node->rb_right, level);
 }
 
-static
-struct lock_stat *lock_stat_insert_rbtree_db(struct lock_stat *o)
+static struct lock_stat *lock_stat_insert_rbtree_db(struct lock_stat *o)
 {
 	struct rb_node **p = &lock_stat_rbtree_db.rb_node;
 	struct rb_node *parent = NULL;
@@ -339,7 +260,7 @@ struct lock_stat *lock_stat_insert_rbtre
 		}
 	}
 
-        rb_link_node(&o->rb_node, parent, p);
+	rb_link_node(&o->rb_node, parent, p);
 	rb_insert_color(&o->rb_node, &lock_stat_rbtree_db);
 
 	++attached;
@@ -347,14 +268,12 @@ struct lock_stat *lock_stat_insert_rbtre
 	return NULL;
 }
 
-static
-struct lock_stat *lock_stat_lookup_rbtree_db(LOCK_STAT_NOTE_PARAM_DECL)
+static struct lock_stat *lock_stat_lookup_rbtree_db(LOCK_STAT_NOTE_PARAM_DECL)
 {
 	struct rb_node *node = lock_stat_rbtree_db.rb_node;
 	struct lock_stat *cursor;
 
-	while (node)
-	{
+	while (node) {
 		cursor = container_of(node, struct lock_stat, rb_node);
 		/*
 		 * item less than-> left
@@ -374,15 +293,13 @@ struct lock_stat *lock_stat_lookup_rbtre
 }
 
 /* must hold object_store_lock */
-static
-struct lock_stat * lock_stat_lookup_object(LOCK_STAT_NOTE_PARAM_DECL)
+static struct lock_stat * lock_stat_lookup_object(LOCK_STAT_NOTE_PARAM_DECL)
 {
 	return lock_stat_lookup_rbtree_db(LOCK_STAT_NOTE_VARS);
 }
 
 /* Must hold object_store_lock */
-static
-void lock_stat_insert_object(struct lock_stat *o)
+static void lock_stat_insert_object(struct lock_stat *o)
 {
 	lock_stat_insert_rbtree_db(o);
 }
@@ -401,26 +318,25 @@ void lock_stat_insert_object(struct lock
  * instances, you still track it with one backing object but it's connect to
  * this object by the initialization point (file, function, line) of the
  * rtmutex. That place in the source file is also used as an identifying key
- * for that instance and it is used as to associate it with a backing statistical
- * object. They are forever connected together from that point by that key. That
- * backing object holds the total number of contentions and other stats for all
- * objects associated with that key.
+ * for that instance and it is used as to associate it with a backing
+ * statistical object. They are forever connected together from that point by
+ * that key. That backing object holds the total number of contentions and
+ * other stats for all objects associated with that key.
  *
  * There maybe other initialization points for that same structure effecting
  * how the keys are utilized, but they should * all effectively be connected
  * to a single lock_stat object representing the * overall contention behavior
  * and use of that object.
  *
- * Connecting the rtmutex to the lock_stat object at spin_lock_init() time. It's
- * not a critical path. There are cases where a C99 style struct initializer is
- * used so I can't insert it into the lock_stat dictionary and those initializer
- * must be converted to use spin_lock_init() instead.
- *
+ * Connecting the rtmutex to the lock_stat object at spin_lock_init() time.
+ * It's not a critical path. There are cases where a C99 style struct
+ * initializer is used so we can't insert it into the lock_stat dictionary
+ * and those initializer must be converted to use spin_lock_init() instead.
  */
 int lock_stat_scoped_attach(lock_stat_ref_t *oref, LOCK_STAT_NOTE_PARAM_DECL)
 {
-	unsigned long flags;
 	struct lock_stat *o = NULL;
+	unsigned long flags;
 
 	/* Failed error condition and ignore instrumentation calls before it's
 	 * intialized */
@@ -475,11 +391,11 @@ failure:
  * structures.
  */
 
-static
-void lock_stat_static_attach(lock_stat_ref_t *oref, LOCK_STAT_NOTE_PARAM_DECL)
+static void
+lock_stat_static_attach(lock_stat_ref_t *oref, LOCK_STAT_NOTE_PARAM_DECL)
 {
-	unsigned long flags;
 	struct lock_stat *o, *p;
+	unsigned long flags;
 
 	if (!oref || !lock_stat_inited)
 		return;
@@ -494,8 +410,7 @@ void lock_stat_static_attach(lock_stat_r
 	if ((p = lock_stat_lookup_object(LOCK_STAT_NOTE_VARS))) {
 		o = p;
 		static_found++;
-	}
-	else {
+	} else {
 		o = lock_stat_allocate_object();
 		lookup_failed_static++;
 	}
@@ -520,36 +435,32 @@ failure:
 	spin_unlock_irqrestore(&object_store_lock, flags);
 }
 
-static
-char *ksym_get(unsigned long address, char *namebuffer)
-{ 
+static char *ksym_get(unsigned long address, char *namebuffer)
+{
 	unsigned long offset = 0, symsize;
-	char *modname;
 	const char *symname;
+	char *modname;
 
 	symname = kallsyms_lookup(address, &symsize, &offset, &modname,
-								namebuffer); 
+				  namebuffer);
 
-	if (!symname) {
+	if (!symname)
 		return null_string;
-	}
 
 	return (char *) symname;
 }
 
-extern int task_on_rq(int cpu, struct task_struct *p);
-
 void lock_stat_note(lock_stat_ref_t *oref, struct task_struct *owner,
-							unsigned long ip,
-							int handoff)
+		    unsigned long ip, int handoff)
 {
-	int cpu;
 	char ksym_scoped_namebuf[KSYM_NAME_LEN+1];
-	extern struct task_struct *get_task_on_rq(int cpu);
+	int cpu;
 
 	/* Invalid parameters, just do a return instead of crash */
-	if (!oref || !owner || !lock_stat_inited)
-		goto failure;
+	if (!oref || !owner || !lock_stat_inited) {
+		failure_events++;
+		goto out;
+	}
 
 	cpu = task_cpu(owner);
 
@@ -570,75 +481,30 @@ void lock_stat_note(lock_stat_ref_t *ore
 							>= KSYM_NAME_LEN);
 	if (!*oref)
 		lock_stat_static_attach(oref, special_static_string,
-							ksym_scoped_namebuf,
-							0);
+					ksym_scoped_namebuf, 0);
 	if (handoff == LOCK_STAT_NOTE_TYPE_HANDOFF) {
 		atomic_inc(&((*oref)->nhandoff));
-	}
-	else {
+	} else {
 		if (owner && (owner == get_task_on_rq(cpu)))
 			atomic_inc(&((*oref)->nspinnable));
 
 		atomic_inc(&((*oref)->ncontended));
 	}
 
-	atomic_inc(&per_cpu(lock_stat_total_events, get_cpu()));
-	put_cpu();
-
-	return;
-failure:
-	failure_events++;
-
+out:
 	atomic_inc(&per_cpu(lock_stat_total_events, get_cpu()));
 	put_cpu();
 }
 
-static int lock_stat_procfs_open(struct inode *, struct file *);
-static int lock_stat_procfs_write(struct file *file, const char *buf,
-								size_t count,
-								loff_t *off);
-
 struct proc_dir_entry *lock_stat_procfs_dir;
 struct proc_dir_entry *lock_stat_procfs_entry;
 
-static struct file_operations lock_stat_procfs_ops = {
-	.open		= lock_stat_procfs_open,
-	.read		= seq_read,
-	.write		= lock_stat_procfs_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static int lock_stat_procfs_init(void)
-{
-	int error = 0;
-
-	lock_stat_procfs_dir = proc_mkdir("lock_stat", NULL);
-	if (lock_stat_procfs_dir == NULL) {
-		error = -ENOMEM;
-		return error;
-	}
-
-	lock_stat_procfs_entry = create_proc_entry("contention", 0666,
-							lock_stat_procfs_dir);
-	if (lock_stat_procfs_entry == NULL) {
-		error = -ENOMEM;
-		return error;
-	}
-	else {
-		lock_stat_procfs_entry->proc_fops = &lock_stat_procfs_ops;
-	}
-
-	return 0;
-}
-
 static int lock_stat_procfs_show(struct seq_file *seq, void *v)
 {
 	int cpu, count = 0;
 
-	for_each_possible_cpu(cpu) {
+	for_each_possible_cpu(cpu)
 		count += atomic_read(&per_cpu(lock_stat_total_events, cpu));
-	}
 
 	seq_printf(seq, "@contention events = %d\n", count);
 	seq_printf(seq, "@failure_events = %d\n", failure_events);
@@ -650,15 +516,41 @@ static int lock_stat_procfs_show(struct 
 	return 0;
 }
 
-static int lock_stat_procfs_write (struct file *file, const char *buf,
-								size_t count,
-								loff_t *off)
+static ssize_t
+lock_stat_procfs_write(struct file *file, const char __user *buf,
+		       size_t count, loff_t *ppos)
 {
 	lock_stat_reset_stats();
 	return count;
 }
 
-static int lock_stat_procfs_open(struct inode *inode, struct file *file) {
+static int lock_stat_procfs_open(struct inode *inode, struct file *file)
+{
 	return single_open (file, &lock_stat_procfs_show, NULL );
 }
 
+static struct file_operations lock_stat_procfs_ops = {
+	.open		= lock_stat_procfs_open,
+	.read		= seq_read,
+	.write		= lock_stat_procfs_write,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int lock_stat_procfs_init(void)
+{
+	lock_stat_procfs_dir = proc_mkdir("lock_stat", NULL);
+	if (lock_stat_procfs_dir == NULL)
+		return -ENOMEM;
+
+	lock_stat_procfs_entry = create_proc_entry("contention", 0666,
+						   lock_stat_procfs_dir);
+	if (lock_stat_procfs_entry == NULL)
+		return -ENOMEM;
+
+	lock_stat_procfs_entry->proc_fops = &lock_stat_procfs_ops;
+
+	return 0;
+}
+
+
Index: linux/kernel/rtmutex.c
===================================================================
--- linux.orig/kernel/rtmutex.c
+++ linux/kernel/rtmutex.c
@@ -970,9 +970,6 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	int ret = 0, saved_lock_depth = -1;
 	struct rt_mutex_waiter waiter;
 	unsigned long flags;
-#ifdef CONFIG_LOCK_STAT
-	struct task_struct *owner;
-#endif
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -1113,7 +1110,6 @@ rt_mutex_slowtrylock(struct rt_mutex *lo
 	unsigned long flags;
 	int ret = 0;
 #ifdef CONFIG_LOCK_STAT
-	struct task_struct *owner;
 	int type;
 #endif
 


