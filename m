Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZCDR6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZCDR6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZCDR6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:58:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:59993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbZCDR6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:58:08 -0500
Date: Wed, 4 Mar 2009 17:57:26 GMT
From: Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, edwintorok@gmail.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, edwintorok@gmail.com,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236166375.5330.7209.camel@laptop>
References: <1236166375.5330.7209.camel@laptop>
Subject: [tip:tracing/ftrace] tracing: add lockdep tracepoints for lock acquire/release
Message-ID: <tip-efed792d6738964f399a508ef9e831cd60fa4657@git.kernel.org>
Git-Commit-ID: efed792d6738964f399a508ef9e831cd60fa4657
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 17:57:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efed792d6738964f399a508ef9e831cd60fa4657
Gitweb:     http://git.kernel.org/tip/efed792d6738964f399a508ef9e831cd60fa4657
Author:     "Peter Zijlstra" <peterz@infradead.org>
AuthorDate: Wed, 4 Mar 2009 12:32:55 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 18:49:58 +0100

tracing: add lockdep tracepoints for lock acquire/release

Augment the traces with lock names when lockdep is available:

 1)               |  down_read_trylock() {
 1)               |    _spin_lock_irqsave() {
 1)               |      /* lock_acquire: &sem->wait_lock */
 1)   4.201 us    |    }
 1)               |    _spin_unlock_irqrestore() {
 1)               |      /* lock_release: &sem->wait_lock */
 1)   3.523 us    |    }
 1)               |  /* lock_acquire: try read &mm->mmap_sem */
 1) + 13.386 us   |  }
 1)   1.635 us    |  find_vma();
 1)               |  handle_mm_fault() {
 1)               |    __do_fault() {
 1)               |      filemap_fault() {
 1)               |        find_lock_page() {
 1)               |          find_get_page() {
 1)               |            /* lock_acquire: read rcu_read_lock */
 1)               |            /* lock_release: rcu_read_lock */
 1)   5.697 us    |          }
 1)   8.158 us    |        }
 1) + 11.079 us   |      }
 1)               |      _spin_lock() {
 1)               |        /* lock_acquire: __pte_lockptr(page) */
 1)   3.949 us    |      }
 1)   1.460 us    |      page_add_file_rmap();
 1)               |      _spin_unlock() {
 1)               |        /* lock_release: __pte_lockptr(page) */
 1)   3.115 us    |      }
 1)               |      unlock_page() {
 1)   1.421 us    |        page_waitqueue();
 1)   1.220 us    |        __wake_up_bit();
 1)   6.519 us    |      }
 1) + 34.328 us   |    }
 1) + 37.452 us   |  }
 1)               |  up_read() {
 1)               |  /* lock_release: &mm->mmap_sem */
 1)               |    _spin_lock_irqsave() {
 1)               |      /* lock_acquire: &sem->wait_lock */
 1)   3.865 us    |    }
 1)               |    _spin_unlock_irqrestore() {
 1)               |      /* lock_release: &sem->wait_lock */
 1)   8.562 us    |    }
 1) + 17.370 us   |  }

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1236166375.5330.7209.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/lockdep.h             |    9 +++++++
 include/trace/lockdep_event_types.h |   44 +++++++++++++++++++++++++++++++++++
 include/trace/trace_event_types.h   |    1 +
 include/trace/trace_events.h        |    1 +
 kernel/lockdep.c                    |   17 +++++++++++++
 kernel/trace/trace.c                |   14 ++++++----
 kernel/trace/trace_events_stage_3.h |    4 +-
 7 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/include/trace/lockdep.h b/include/trace/lockdep.h
new file mode 100644
index 0000000..5ca67df
--- /dev/null
+++ b/include/trace/lockdep.h
@@ -0,0 +1,9 @@
+#ifndef _TRACE_LOCKDEP_H
+#define _TRACE_LOCKDEP_H
+
+#include <linux/lockdep.h>
+#include <linux/tracepoint.h>
+
+#include <trace/lockdep_event_types.h>
+
+#endif
diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
new file mode 100644
index 0000000..f713d74
--- /dev/null
+++ b/include/trace/lockdep_event_types.h
@@ -0,0 +1,44 @@
+
+#ifndef TRACE_EVENT_FORMAT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM lock
+
+#ifdef CONFIG_LOCKDEP
+
+TRACE_FORMAT(lock_acquire,
+	TPPROTO(struct lockdep_map *lock, unsigned int subclass,
+		int trylock, int read, int check,
+		struct lockdep_map *next_lock, unsigned long ip),
+	TPARGS(lock, subclass, trylock, read, check, next_lock, ip),
+	TPFMT("%s%s%s", trylock ? "try " : "",
+		read ? "read " : "", lock->name)
+	);
+
+TRACE_FORMAT(lock_release,
+	TPPROTO(struct lockdep_map *lock, int nested, unsigned long ip),
+	TPARGS(lock, nested, ip),
+	TPFMT("%s", lock->name)
+	);
+
+#ifdef CONFIG_LOCK_STAT
+
+TRACE_FORMAT(lock_contended,
+	TPPROTO(struct lockdep_map *lock, unsigned long ip),
+	TPARGS(lock, ip),
+	TPFMT("%s", lock->name)
+	);
+
+TRACE_FORMAT(lock_acquired,
+	TPPROTO(struct lockdep_map *lock, unsigned long ip),
+	TPARGS(lock, ip),
+	TPFMT("%s", lock->name)
+	);
+
+#endif
+#endif
+
+#undef TRACE_SYSTEM
diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
index 33c8ed5..df56f56 100644
--- a/include/trace/trace_event_types.h
+++ b/include/trace/trace_event_types.h
@@ -2,3 +2,4 @@
 
 #include <trace/sched_event_types.h>
 #include <trace/irq_event_types.h>
+#include <trace/lockdep_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index ea2ef20..fd13750 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -2,3 +2,4 @@
 
 #include <trace/sched.h>
 #include <trace/irq.h>
+#include <trace/lockdep.h>
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 02014f7..cb70c1d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -42,6 +42,7 @@
 #include <linux/hash.h>
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
+#include <trace/lockdep.h>
 
 #include <asm/sections.h>
 
@@ -2913,6 +2914,8 @@ void lock_set_class(struct lockdep_map *lock, const char *name,
 }
 EXPORT_SYMBOL_GPL(lock_set_class);
 
+DEFINE_TRACE(lock_acquire);
+
 /*
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
@@ -2923,6 +2926,8 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 {
 	unsigned long flags;
 
+	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2937,11 +2942,15 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 }
 EXPORT_SYMBOL_GPL(lock_acquire);
 
+DEFINE_TRACE(lock_release);
+
 void lock_release(struct lockdep_map *lock, int nested,
 			  unsigned long ip)
 {
 	unsigned long flags;
 
+	trace_lock_release(lock, nested, ip);
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -3090,10 +3099,14 @@ found_it:
 	lock->ip = ip;
 }
 
+DEFINE_TRACE(lock_contended);
+
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
+	trace_lock_contended(lock, ip);
+
 	if (unlikely(!lock_stat))
 		return;
 
@@ -3109,10 +3122,14 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
+DEFINE_TRACE(lock_acquired);
+
 void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
+	trace_lock_acquired(lock, ip);
+
 	if (unlikely(!lock_stat))
 		return;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 12539f7..c8abbb0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -623,7 +623,7 @@ static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
 static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
 static int cmdline_idx;
-static DEFINE_SPINLOCK(trace_cmdline_lock);
+static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
 
 /* temporary disable recording */
 static atomic_t trace_record_cmdline_disabled __read_mostly;
@@ -735,7 +735,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	 * nor do we want to disable interrupts,
 	 * so if we miss here, then better luck next time.
 	 */
-	if (!spin_trylock(&trace_cmdline_lock))
+	if (!__raw_spin_trylock(&trace_cmdline_lock))
 		return;
 
 	idx = map_pid_to_cmdline[tsk->pid];
@@ -753,7 +753,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
 
 	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
 
-	spin_unlock(&trace_cmdline_lock);
+	__raw_spin_unlock(&trace_cmdline_lock);
 }
 
 char *trace_find_cmdline(int pid)
@@ -3751,7 +3751,7 @@ static __init int tracer_init_debugfs(void)
 
 int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 {
-	static DEFINE_SPINLOCK(trace_buf_lock);
+	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
 
 	struct ring_buffer_event *event;
@@ -3773,7 +3773,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 		goto out;
 
 	pause_graph_tracing();
-	spin_lock_irqsave(&trace_buf_lock, irq_flags);
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&trace_buf_lock);
 	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	len = min(len, TRACE_BUF_SIZE-1);
@@ -3792,7 +3793,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	ring_buffer_unlock_commit(tr->buffer, event);
 
  out_unlock:
-	spin_unlock_irqrestore(&trace_buf_lock, irq_flags);
+	__raw_spin_unlock(&trace_buf_lock);
+	raw_local_irq_restore(irq_flags);
 	unpause_graph_tracing();
  out:
 	preempt_enable_notrace();
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 041789f..2c8d76c 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -5,7 +5,7 @@
  *
  * static void ftrace_event_<call>(proto)
  * {
- * 	event_trace_printk(_RET_IP_, "(<call>) " <fmt>);
+ * 	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
  * }
  *
  * static int ftrace_reg_event_<call>(void)
@@ -112,7 +112,7 @@
 #define _TRACE_FORMAT(call, proto, args, fmt)				\
 static void ftrace_event_##call(proto)					\
 {									\
-	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
+	event_trace_printk(_RET_IP_, #call ": " fmt);			\
 }									\
 									\
 static int ftrace_reg_event_##call(void)				\
