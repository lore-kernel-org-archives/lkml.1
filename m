Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457Ab0AKM0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0AKM0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459Ab0AKM0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:26:06 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55945 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0AKM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:26:00 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:55:53 +0530
Message-Id: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 4/7] Uprobes Implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uprobes Implementation

Uprobes Infrastructure enables user to dynamically establish
probepoints in user applications and collect information by executing
a handler functions when the probepoints are hit.
Please refer Documentation/uprobes.txt for more details.

This patch provides the core implementation of uprobes.
This patch builds on utrace infrastructure.

You need to follow this up with the uprobes patch for your
architecture.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/Kconfig            |   12 
 include/linux/uprobes.h |  292 ++++++
 kernel/Makefile         |    1 
 kernel/uprobes_core.c   | 2017 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 2322 insertions(+)

Index: new_uprobes.git/arch/Kconfig
===================================================================
--- new_uprobes.git.orig/arch/Kconfig
+++ new_uprobes.git/arch/Kconfig
@@ -66,6 +66,16 @@ config UBP
 	  in user applications. This service is used by components
 	  such as uprobes. If in doubt, say "N".
 
+config UPROBES
+	bool "User-space probes (EXPERIMENTAL)"
+	depends on UTRACE && MODULES && UBP
+	depends on HAVE_UPROBES
+	help
+	  Uprobes enables kernel modules to establish probepoints
+	  in user applications and execute handler functions when
+	  the probepoints are hit. For more information, refer to
+	  Documentation/uprobes.txt. If in doubt, say "N".
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -115,6 +125,8 @@ config HAVE_KPROBES
 config HAVE_KRETPROBES
 	bool
 
+config HAVE_UPROBES
+	def_bool n
 #
 # An arch should select this if it provides all these things:
 #
Index: new_uprobes.git/include/linux/uprobes.h
===================================================================
--- /dev/null
+++ new_uprobes.git/include/linux/uprobes.h
@@ -0,0 +1,292 @@
+#ifndef _LINUX_UPROBES_H
+#define _LINUX_UPROBES_H
+/*
+ * Userspace Probes (UProbes)
+ * include/linux/uprobes.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2006, 2009
+ */
+#include <linux/types.h>
+#include <linux/list.h>
+
+struct pt_regs;
+
+/* This is what the user supplies us. */
+struct uprobe {
+	/*
+	 * The pid of the probed process.  Currently, this can be the
+	 * thread ID (task->pid) of any active thread in the process.
+	 */
+	pid_t pid;
+
+	/* Location of the probepoint */
+	unsigned long vaddr;
+
+	/* Handler to run when the probepoint is hit */
+	void (*handler)(struct uprobe*, struct pt_regs*);
+
+	/*
+	 * This function, if non-NULL, will be called upon completion of
+	 * an ASYNCHRONOUS registration (i.e., one initiated by a uprobe
+	 * handler).  reg = 1 for register, 0 for unregister.
+	 */
+	void (*registration_callback)(struct uprobe *u, int reg, int result);
+
+	/* Reserved for use by uprobes */
+	void *kdata;
+};
+
+#if defined(CONFIG_UPROBES)
+extern int register_uprobe(struct uprobe *u);
+extern void unregister_uprobe(struct uprobe *u);
+#else
+static inline int register_uprobe(struct uprobe *u)
+{
+	return -ENOSYS;
+}
+static inline void unregister_uprobe(struct uprobe *u)
+{
+}
+#endif	/* CONFIG_UPROBES */
+
+#ifdef UPROBES_IMPLEMENTATION
+
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+#include <linux/ubp.h>
+#include <linux/ubp_xol.h>
+#include <asm/uprobes.h>
+
+struct utrace_engine;
+struct task_struct;
+struct pid;
+
+enum uprobe_probept_state {
+	UPROBE_INSERTING,	/* process quiescing prior to insertion	*/
+	UPROBE_BP_SET,		/* breakpoint in place			*/
+	UPROBE_REMOVING,	/* process quiescing prior to removal	*/
+	UPROBE_DISABLED		/* removal completed			*/
+};
+
+enum uprobe_task_state {
+	UPTASK_QUIESCENT,
+	UPTASK_SLEEPING,	/* See utask_fake_quiesce(). 		*/
+	UPTASK_RUNNING,
+	UPTASK_BP_HIT,
+	UPTASK_SSTEP
+};
+
+enum uprobe_ssil_state {
+	SSIL_DISABLE,
+	SSIL_CLEAR,
+	SSIL_SET
+};
+
+#define UPROBE_HASH_BITS 5
+#define UPROBE_TABLE_SIZE (1 << UPROBE_HASH_BITS)
+
+/*
+ * uprobe_process -- not a user-visible struct.
+ * A uprobe_process represents a probed process.  A process can have
+ * multiple probepoints (each represented by a uprobe_probept) and
+ * one or more threads (each represented by a uprobe_task).
+ */
+struct uprobe_process {
+	/*
+	 * rwsem is write-locked for any change to the uprobe_process's
+	 * graph (including uprobe_tasks, uprobe_probepts, and uprobe_kimgs) --
+	 * e.g., due to probe [un]registration or special events like exit.
+	 * It's read-locked during the whole time we process a probepoint hit.
+	 */
+	struct rw_semaphore rwsem;
+
+	/* Table of uprobe_probepts registered for this process */
+	/* TODO: Switch to list_head[] per Ingo. */
+	struct hlist_head uprobe_table[UPROBE_TABLE_SIZE];
+
+	/* List of uprobe_probepts awaiting insertion or removal */
+	struct list_head pending_uprobes;
+
+	/* List of uprobe_tasks in this task group */
+	struct list_head thread_list;
+	int nthreads;
+	int n_quiescent_threads;
+
+	/* this goes on the uproc_table */
+	struct hlist_node hlist;
+
+	/*
+	 * All threads (tasks) in a process share the same uprobe_process.
+	 */
+	struct pid *tg_leader;
+	pid_t tgid;
+
+	/* Threads in UTASK_SLEEPING state wait here to be roused. */
+	wait_queue_head_t waitq;
+
+	/*
+	 * We won't free the uprobe_process while...
+	 * - any register/unregister operations on it are in progress; or
+	 * - any uprobe_report_* callbacks are running; or
+	 * - uprobe_table[] is not empty; or
+	 * - any tasks are UTASK_SLEEPING in the waitq;
+	 * refcount reflects this.  We do NOT ref-count tasks (threads),
+	 * since once the last thread has exited, the rest is academic.
+	 */
+	atomic_t refcount;
+
+	/*
+	 * finished = 1 means the process is execing or the last thread
+	 * is exiting, and we're cleaning up the uproc.  If the execed
+	 * process is probed, a new uproc will be created.
+	 */
+	bool finished;
+
+	/*
+	 * 1 to single-step out of line; 0 for inline.  This can drop to
+	 * 0 if we can't set up the XOL area, but never goes from 0 to 1.
+	 */
+	bool sstep_out_of_line;
+
+	/*
+	 * Manages slots for instruction-copies to be single-stepped
+	 * out of line.
+	 */
+	void *xol_area;
+};
+
+/*
+ * uprobe_kimg -- not a user-visible struct.
+ * Holds implementation-only per-uprobe data.
+ * uprobe->kdata points to this.
+ */
+struct uprobe_kimg {
+	struct uprobe *uprobe;
+	struct uprobe_probept *ppt;
+
+	/*
+	 * -EBUSY while we're waiting for all threads to quiesce so the
+	 * associated breakpoint can be inserted or removed.
+	 * 0 if the the insert/remove operation has succeeded, or -errno
+	 * otherwise.
+	 */
+	int status;
+
+	/* on ppt's list */
+	struct list_head list;
+};
+
+/*
+ * uprobe_probept -- not a user-visible struct.
+ * A probepoint, at which several uprobes can be registered.
+ * Guarded by uproc->rwsem.
+ */
+struct uprobe_probept {
+	/* breakpoint/XOL details */
+	struct ubp_bkpt ubp;
+
+	/* The uprobe_kimg(s) associated with this uprobe_probept */
+	struct list_head uprobe_list;
+
+	enum uprobe_probept_state state;
+
+	/* The parent uprobe_process */
+	struct uprobe_process *uproc;
+
+	/*
+	 * ppt goes in the uprobe_process->uprobe_table when registered --
+	 * even before the breakpoint has been inserted.
+	 */
+	struct hlist_node ut_node;
+
+	/*
+	 * ppt sits in the uprobe_process->pending_uprobes queue while
+	 * awaiting insertion or removal of the breakpoint.
+	 */
+	struct list_head pd_node;
+
+	/* [un]register_uprobe() waits 'til bkpt inserted/removed */
+	wait_queue_head_t waitq;
+
+	/*
+	 * ssil_lock, ssilq and ssil_state are used to serialize
+	 * single-stepping inline, so threads don't clobber each other
+	 * swapping the breakpoint instruction in and out.  This helps
+	 * prevent crashing the probed app, but it does NOT prevent
+	 * probe misses while the breakpoint is swapped out.
+	 * ssilq - threads wait for their chance to single-step inline.
+	 */
+	spinlock_t ssil_lock;
+	wait_queue_head_t ssilq;
+	enum uprobe_ssil_state ssil_state;
+};
+
+/*
+ * uprobe_utask -- not a user-visible struct.
+ * Corresponds to a thread in a probed process.
+ * Guarded by uproc->rwsem.
+ */
+struct uprobe_task {
+	/* Lives in the global utask_table */
+	struct hlist_node hlist;
+
+	/* Lives on the thread_list for the uprobe_process */
+	struct list_head list;
+
+	struct task_struct *tsk;
+	struct pid *pid;
+
+	/* The utrace engine for this task */
+	struct utrace_engine *engine;
+
+	/* Back pointer to the associated uprobe_process */
+	struct uprobe_process *uproc;
+
+	enum uprobe_task_state state;
+
+	/*
+	 * quiescing = 1 means this task has been asked to quiesce.
+	 * It may not be able to comply immediately if it's hit a bkpt.
+	 */
+	bool quiescing;
+
+	/* Set before running handlers; cleared after single-stepping. */
+	struct uprobe_probept *active_probe;
+
+	/* Saved address of copied original instruction */
+	long singlestep_addr;
+
+	struct ubp_task_arch_info arch_info;
+
+	/*
+	 * Unexpected error in probepoint handling has left task's
+	 * text or stack corrupted.  Kill task ASAP.
+	 */
+	bool doomed;
+
+	/* [un]registrations initiated by handlers must be asynchronous. */
+	struct list_head deferred_registrations;
+
+	/* Delay handler-destined signals 'til after single-step done. */
+	struct list_head delayed_signals;
+};
+
+#endif	/* UPROBES_IMPLEMENTATION */
+
+#endif	/* _LINUX_UPROBES_H */
Index: new_uprobes.git/kernel/Makefile
===================================================================
--- new_uprobes.git.orig/kernel/Makefile
+++ new_uprobes.git/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_b
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_UBP) += ubp_core.o
 obj-$(CONFIG_UBP_XOL) += ubp_xol.o
+obj-$(CONFIG_UPROBES) += uprobes_core.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: new_uprobes.git/kernel/uprobes_core.c
===================================================================
--- /dev/null
+++ new_uprobes.git/kernel/uprobes_core.c
@@ -0,0 +1,2017 @@
+/*
+ *  Userspace Probes (UProbes)
+ *  kernel/uprobes_core.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2006, 2009
+ */
+#include <linux/types.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+#include <linux/err.h>
+#include <linux/kref.h>
+#include <linux/utrace.h>
+#include <linux/regset.h>
+#define UPROBES_IMPLEMENTATION 1
+#include <linux/uprobes.h>
+#include <linux/tracehook.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+#include <linux/mman.h>
+
+#define UPROBE_SET_FLAGS	1
+#define UPROBE_CLEAR_FLAGS	0
+
+#define MAX_XOL_SLOTS	1024
+
+static int utask_fake_quiesce(struct uprobe_task *utask);
+static int uprobe_post_ssout(struct uprobe_task *utask,
+	struct uprobe_probept *ppt, struct pt_regs *regs);
+
+typedef void (*uprobe_handler_t)(struct uprobe*, struct pt_regs*);
+
+/*
+ * Table of currently probed processes, hashed by task-group leader's
+ * struct pid.
+ */
+static struct hlist_head uproc_table[UPROBE_TABLE_SIZE];
+
+/* Protects uproc_table during uprobe (un)registration */
+static DEFINE_MUTEX(uproc_mutex);
+
+/* Table of uprobe_tasks, hashed by task_struct pointer. */
+static struct hlist_head utask_table[UPROBE_TABLE_SIZE];
+static DEFINE_SPINLOCK(utask_table_lock);
+
+/* p_uprobe_utrace_ops = &uprobe_utrace_ops.  Fwd refs are a pain w/o this. */
+static const struct utrace_engine_ops *p_uprobe_utrace_ops;
+
+struct deferred_registration {
+	struct list_head list;
+	struct uprobe *uprobe;
+	int regflag;	/* 0 - unregister, 1 - register */
+};
+
+/*
+ * Calling a signal handler cancels single-stepping, so uprobes delays
+ * calling the handler, as necessary, until after single-stepping is completed.
+ */
+struct delayed_signal {
+	struct list_head list;
+	siginfo_t info;
+};
+
+static u16 ubp_strategies;
+
+static struct uprobe_task *uprobe_find_utask(struct task_struct *tsk)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct uprobe_task *utask;
+	unsigned long flags;
+
+	head = &utask_table[hash_ptr(tsk, UPROBE_HASH_BITS)];
+	spin_lock_irqsave(&utask_table_lock, flags);
+	hlist_for_each_entry(utask, node, head, hlist) {
+		if (utask->tsk == tsk) {
+			spin_unlock_irqrestore(&utask_table_lock, flags);
+			return utask;
+		}
+	}
+	spin_unlock_irqrestore(&utask_table_lock, flags);
+	return NULL;
+}
+
+static void uprobe_hash_utask(struct uprobe_task *utask)
+{
+	struct hlist_head *head;
+	unsigned long flags;
+
+	INIT_HLIST_NODE(&utask->hlist);
+	head = &utask_table[hash_ptr(utask->tsk, UPROBE_HASH_BITS)];
+	spin_lock_irqsave(&utask_table_lock, flags);
+	hlist_add_head(&utask->hlist, head);
+	spin_unlock_irqrestore(&utask_table_lock, flags);
+}
+
+static void uprobe_unhash_utask(struct uprobe_task *utask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&utask_table_lock, flags);
+	hlist_del(&utask->hlist);
+	spin_unlock_irqrestore(&utask_table_lock, flags);
+}
+
+static inline void uprobe_get_process(struct uprobe_process *uproc)
+{
+	atomic_inc(&uproc->refcount);
+}
+
+/*
+ * Decrement uproc's refcount in a situation where we "know" it can't
+ * reach zero.  It's OK to call this with uproc locked.  Compare with
+ * uprobe_put_process().
+ */
+static inline void uprobe_decref_process(struct uprobe_process *uproc)
+{
+	if (atomic_dec_and_test(&uproc->refcount))
+		BUG();
+}
+
+/*
+ * Runs with the uproc_mutex held.  Returns with uproc ref-counted and
+ * write-locked.
+ *
+ * Around exec time, briefly, it's possible to have one (finished) uproc
+ * for the old image and one for the new image.  We find the latter.
+ */
+static struct uprobe_process *uprobe_find_process(struct pid *tg_leader)
+{
+	struct uprobe_process *uproc;
+	struct hlist_head *head;
+	struct hlist_node *node;
+
+	head = &uproc_table[hash_ptr(tg_leader, UPROBE_HASH_BITS)];
+	hlist_for_each_entry(uproc, node, head, hlist) {
+		if (uproc->tg_leader == tg_leader && !uproc->finished) {
+			uprobe_get_process(uproc);
+			down_write(&uproc->rwsem);
+			return uproc;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * In the given uproc's hash table of probepoints, find the one with the
+ * specified virtual address.  Runs with uproc->rwsem locked.
+ */
+static struct uprobe_probept *uprobe_find_probept(struct uprobe_process *uproc,
+		unsigned long vaddr)
+{
+	struct uprobe_probept *ppt;
+	struct hlist_node *node;
+	struct hlist_head *head = &uproc->uprobe_table[hash_long(vaddr,
+		UPROBE_HASH_BITS)];
+
+	hlist_for_each_entry(ppt, node, head, ut_node) {
+		if (ppt->ubp.vaddr == vaddr && ppt->state != UPROBE_DISABLED)
+			return ppt;
+	}
+	return NULL;
+}
+
+/*
+ * Save a copy of the original instruction (so it can be single-stepped
+ * out of line), insert the breakpoint instruction, and awake
+ * register_uprobe().
+ */
+static void uprobe_insert_bkpt(struct uprobe_probept *ppt,
+						struct task_struct *tsk)
+{
+	struct uprobe_kimg *uk;
+	int result;
+
+	if (tsk)
+		result = ubp_insert_bkpt(tsk, &ppt->ubp);
+	else
+		/* No surviving tasks associated with ppt->uproc */
+		result = -ESRCH;
+	ppt->state = (result ? UPROBE_DISABLED : UPROBE_BP_SET);
+	list_for_each_entry(uk, &ppt->uprobe_list, list)
+		uk->status = result;
+	wake_up_all(&ppt->waitq);
+}
+
+/*
+ * Check if task has just stepped on a trap instruction at the
+ * indicated address. If it has indeed stepped on that address,
+ * then reset Instruction Pointer for the task.
+ *
+ * tsk should either be current thread or already quiesced thread.
+ */
+static inline void reset_thread_ip(struct task_struct *tsk,
+				struct pt_regs *regs, unsigned long addr)
+{
+	if ((ubp_get_bkpt_addr(regs) == addr) &&
+				!test_tsk_thread_flag(tsk, TIF_SINGLESTEP))
+		ubp_set_ip(regs, addr);
+}
+
+/*
+ * ppt's breakpoint has been removed.  If any threads are in the middle of
+ * single-stepping at this probepoint, fix things up so they can proceed.
+ * If any threads have just hit breakpoint but are yet to start
+ * pre-processing, reset their instruction pointers.
+ *
+ * Runs with all of ppt->uproc's threads quiesced and ppt->uproc->rwsem
+ * write-locked
+ */
+static inline void adjust_trapped_thread_ip(struct uprobe_probept *ppt)
+{
+	struct uprobe_process *uproc = ppt->uproc;
+	struct uprobe_task *utask;
+	struct pt_regs *regs;
+
+	list_for_each_entry(utask, &uproc->thread_list, list) {
+		regs = task_pt_regs(utask->tsk);
+		if (utask->active_probe != ppt) {
+			reset_thread_ip(utask->tsk, regs, ppt->ubp.vaddr);
+			continue;
+		}
+
+		/*
+		 * Current thread cannot have an active breakpoint
+		 * and still request for a breakpoint removal. The
+		 * above case is handled by utask_fake_quiesce().
+		 */
+		BUG_ON(utask->tsk == current);
+
+#ifdef CONFIG_UBP_XOL
+		if (instruction_pointer(regs) == ppt->ubp.xol_vaddr)
+			/* adjust the ip to breakpoint addr.  */
+			ubp_set_ip(regs, ppt->ubp.vaddr);
+		else
+			/* adjust the ip to next instruction.  */
+			uprobe_post_ssout(utask, ppt, regs);
+#endif
+	}
+}
+
+static void uprobe_remove_bkpt(struct uprobe_probept *ppt,
+						struct task_struct *tsk)
+{
+	if (tsk) {
+		if (ubp_remove_bkpt(tsk, &ppt->ubp) != 0) {
+			printk(KERN_ERR
+				"Error removing uprobe at pid %d vaddr %#lx:"
+				" can't restore original instruction\n",
+				tsk->tgid, ppt->ubp.vaddr);
+			/*
+			 * This shouldn't happen, since we were previously
+			 * able to write the breakpoint at that address.
+			 * There's not much we can do besides let the
+			 * process die with a SIGTRAP the next time the
+			 * breakpoint is hit.
+			 */
+		}
+		adjust_trapped_thread_ip(ppt);
+		if (ppt->ubp.strategy & UBP_HNT_INLINE) {
+			unsigned long flags;
+			spin_lock_irqsave(&ppt->ssil_lock, flags);
+			ppt->ssil_state = SSIL_DISABLE;
+			wake_up_all(&ppt->ssilq);
+			spin_unlock_irqrestore(&ppt->ssil_lock, flags);
+		}
+	}
+	/* Wake up unregister_uprobe(). */
+	ppt->state = UPROBE_DISABLED;
+	wake_up_all(&ppt->waitq);
+}
+
+/*
+ * Runs with all of uproc's threads quiesced and uproc->rwsem write-locked.
+ * As specified, insert or remove the breakpoint instruction for each
+ * uprobe_probept on uproc's pending list.
+ * tsk = one of the tasks associated with uproc -- NULL if there are
+ * no surviving threads.
+ * It's OK for uproc->pending_uprobes to be empty here.  It can happen
+ * if a register and an unregister are requested (by different probers)
+ * simultaneously for the same pid/vaddr.
+ */
+static void handle_pending_uprobes(struct uprobe_process *uproc,
+	struct task_struct *tsk)
+{
+	struct uprobe_probept *ppt, *tmp;
+
+	list_for_each_entry_safe(ppt, tmp, &uproc->pending_uprobes, pd_node) {
+		switch (ppt->state) {
+		case UPROBE_INSERTING:
+			uprobe_insert_bkpt(ppt, tsk);
+			break;
+		case UPROBE_REMOVING:
+			uprobe_remove_bkpt(ppt, tsk);
+			break;
+		default:
+			BUG();
+		}
+		list_del(&ppt->pd_node);
+	}
+}
+
+static void utask_adjust_flags(struct uprobe_task *utask, int set,
+	unsigned long flags)
+{
+	unsigned long newflags, oldflags;
+
+	oldflags = utask->engine->flags;
+	newflags = oldflags;
+	if (set)
+		newflags |= flags;
+	else
+		newflags &= ~flags;
+	/*
+	 * utrace_barrier[_pid] is not appropriate here.  If we're
+	 * adjusting current, it's not needed.  And if we're adjusting
+	 * some other task, we're holding utask->uproc->rwsem, which
+	 * could prevent that task from completing the callback we'd
+	 * be waiting on.
+	 */
+	if (newflags != oldflags) {
+		if (utrace_set_events_pid(utask->pid, utask->engine,
+							newflags) != 0)
+			/* We don't care. */
+			;
+	}
+}
+
+static inline void clear_utrace_quiesce(struct uprobe_task *utask, bool resume)
+{
+	utask_adjust_flags(utask, UPROBE_CLEAR_FLAGS, UTRACE_EVENT(QUIESCE));
+	if (resume) {
+		if (utrace_control_pid(utask->pid, utask->engine,
+						UTRACE_RESUME) != 0)
+			/* We don't care. */
+			;
+	}
+}
+
+/* Opposite of quiesce_all_threads().  Same locking applies. */
+static void rouse_all_threads(struct uprobe_process *uproc)
+{
+	struct uprobe_task *utask;
+
+	list_for_each_entry(utask, &uproc->thread_list, list) {
+		if (utask->quiescing) {
+			utask->quiescing = false;
+			if (utask->state == UPTASK_QUIESCENT) {
+				utask->state = UPTASK_RUNNING;
+				uproc->n_quiescent_threads--;
+				clear_utrace_quiesce(utask, true);
+			}
+		}
+	}
+	/* Wake any threads that decided to sleep rather than quiesce. */
+	wake_up_all(&uproc->waitq);
+}
+
+/*
+ * If all of uproc's surviving threads have quiesced, do the necessary
+ * breakpoint insertions or removals, un-quiesce everybody, and return 1.
+ * tsk is a surviving thread, or NULL if there is none.  Runs with
+ * uproc->rwsem write-locked.
+ */
+static int check_uproc_quiesced(struct uprobe_process *uproc,
+		struct task_struct *tsk)
+{
+	if (uproc->n_quiescent_threads >= uproc->nthreads) {
+		handle_pending_uprobes(uproc, tsk);
+		rouse_all_threads(uproc);
+		return 1;
+	}
+	return 0;
+}
+
+/* Direct the indicated thread to quiesce. */
+static void uprobe_stop_thread(struct uprobe_task *utask)
+{
+	int result;
+
+	/*
+	 * As with utask_adjust_flags, calling utrace_barrier_pid below
+	 * could deadlock.
+	 */
+	BUG_ON(utask->tsk == current);
+	result = utrace_control_pid(utask->pid, utask->engine, UTRACE_STOP);
+	if (result == 0) {
+		/* Already stopped. */
+		utask->state = UPTASK_QUIESCENT;
+		utask->uproc->n_quiescent_threads++;
+	} else if (result == -EINPROGRESS) {
+		if (utask->tsk->state & TASK_INTERRUPTIBLE) {
+			/*
+			 * Task could be in interruptible wait for a long
+			 * time -- e.g., if stopped for I/O.  But we know
+			 * it's not going to run user code before all
+			 * threads quiesce, so pretend it's quiesced.
+			 * This avoids terminating a system call via
+			 * UTRACE_INTERRUPT.
+			 */
+			utask->state = UPTASK_QUIESCENT;
+			utask->uproc->n_quiescent_threads++;
+		} else {
+			/*
+			 * Task will eventually stop, but it may be a long time.
+			 * Don't wait.
+			 */
+			result = utrace_control_pid(utask->pid, utask->engine,
+							UTRACE_INTERRUPT);
+			if (result != 0)
+				/* We don't care. */
+				;
+		}
+	}
+}
+
+/*
+ * Quiesce all threads in the specified process -- e.g., prior to
+ * breakpoint insertion.  Runs with uproc->rwsem write-locked.
+ * Returns false if all threads have died.
+ */
+static bool quiesce_all_threads(struct uprobe_process *uproc,
+		struct uprobe_task **cur_utask_quiescing)
+{
+	struct uprobe_task *utask;
+	struct task_struct *survivor = NULL;    /* any survivor */
+	bool survivors = false;
+
+	*cur_utask_quiescing = NULL;
+	list_for_each_entry(utask, &uproc->thread_list, list) {
+		if (!survivors) {
+			survivor = pid_task(utask->pid, PIDTYPE_PID);
+			if (survivor)
+				survivors = true;
+		}
+		if (!utask->quiescing) {
+			/*
+			 * If utask is currently handling a probepoint, it'll
+			 * check utask->quiescing and quiesce when it's done.
+			 */
+			utask->quiescing = true;
+			if (utask->tsk == current)
+				*cur_utask_quiescing = utask;
+			else if (utask->state == UPTASK_RUNNING) {
+				utask_adjust_flags(utask, UPROBE_SET_FLAGS,
+						UTRACE_EVENT(QUIESCE));
+				uprobe_stop_thread(utask);
+			}
+		}
+	}
+	/*
+	 * If all the (other) threads are already quiesced, it's up to the
+	 * current thread to do the necessary work.
+	 */
+	check_uproc_quiesced(uproc, survivor);
+	return survivors;
+}
+
+/* Called with utask->uproc write-locked. */
+static void uprobe_free_task(struct uprobe_task *utask, bool in_callback)
+{
+	struct deferred_registration *dr, *d;
+	struct delayed_signal *ds, *ds2;
+	int result;
+
+	if (utask->engine && (utask->tsk != current || !in_callback)) {
+		/*
+		 * No other tasks in this process should be running
+		 * uprobe_report_* callbacks.  (If they are, utrace_barrier()
+		 * here could deadlock.)
+		 */
+		result = utrace_control_pid(utask->pid, utask->engine,
+							UTRACE_DETACH);
+		BUG_ON(result == -EINPROGRESS);
+	}
+	put_pid(utask->pid);	/* null pid OK */
+
+	uprobe_unhash_utask(utask);
+	list_del(&utask->list);
+	list_for_each_entry_safe(dr, d, &utask->deferred_registrations, list) {
+		list_del(&dr->list);
+		kfree(dr);
+	}
+
+	list_for_each_entry_safe(ds, ds2, &utask->delayed_signals, list) {
+		list_del(&ds->list);
+		kfree(ds);
+	}
+
+	kfree(utask);
+}
+
+/*
+ * Dismantle uproc and all its remaining uprobe_tasks.
+ * in_callback = 1 if the caller is a uprobe_report_* callback who will
+ * handle the UTRACE_DETACH operation.
+ * Runs with uproc_mutex held; called with uproc->rwsem write-locked.
+ */
+static void uprobe_free_process(struct uprobe_process *uproc, int in_callback)
+{
+	struct uprobe_task *utask, *tmp;
+
+	if (!hlist_unhashed(&uproc->hlist))
+		hlist_del(&uproc->hlist);
+	list_for_each_entry_safe(utask, tmp, &uproc->thread_list, list)
+		uprobe_free_task(utask, in_callback);
+	put_pid(uproc->tg_leader);
+	if (uproc->xol_area)
+		xol_put_area(uproc->xol_area);
+	up_write(&uproc->rwsem);	/* So kfree doesn't complain */
+	kfree(uproc);
+}
+
+/*
+ * Decrement uproc's ref count.  If it's zero, free uproc and return
+ * 1.  Else return 0.  If uproc is locked, don't call this; use
+ * uprobe_decref_process().
+ */
+static int uprobe_put_process(struct uprobe_process *uproc, bool in_callback)
+{
+	int freed = 0;
+
+	if (atomic_dec_and_test(&uproc->refcount)) {
+		mutex_lock(&uproc_mutex);
+		down_write(&uproc->rwsem);
+		if (unlikely(atomic_read(&uproc->refcount) != 0)) {
+			/*
+			 * The works because uproc_mutex is held any
+			 * time the ref count can go from 0 to 1 -- e.g.,
+			 * register_uprobe() sneaks in with a new probe.
+			 */
+			up_write(&uproc->rwsem);
+		} else {
+			uprobe_free_process(uproc, in_callback);
+			freed = 1;
+		}
+		mutex_unlock(&uproc_mutex);
+	}
+	return freed;
+}
+
+static struct uprobe_kimg *uprobe_mk_kimg(struct uprobe *u)
+{
+	struct uprobe_kimg *uk = kzalloc(sizeof *uk,
+		GFP_USER);
+
+	if (unlikely(!uk))
+		return ERR_PTR(-ENOMEM);
+	u->kdata = uk;
+	uk->uprobe = u;
+	uk->ppt = NULL;
+	INIT_LIST_HEAD(&uk->list);
+	uk->status = -EBUSY;
+	return uk;
+}
+
+/*
+ * Allocate a uprobe_task object for p and add it to uproc's list.
+ * Called with p "got" and uproc->rwsem write-locked.  Called in one of
+ * the following cases:
+ * - before setting the first uprobe in p's process
+ * - we're in uprobe_report_clone() and p is the newly added thread
+ * Returns:
+ * - pointer to new uprobe_task on success
+ * - NULL if t dies before we can utrace_attach it
+ * - negative errno otherwise
+ */
+static struct uprobe_task *uprobe_add_task(struct pid *p,
+		struct uprobe_process *uproc)
+{
+	struct uprobe_task *utask;
+	struct utrace_engine *engine;
+	struct task_struct *t = pid_task(p, PIDTYPE_PID);
+
+	if (!t)
+		return NULL;
+	utask = kzalloc(sizeof *utask, GFP_USER);
+	if (unlikely(utask == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	utask->pid = p;
+	utask->tsk = t;
+	utask->state = UPTASK_RUNNING;
+	utask->quiescing = false;
+	utask->uproc = uproc;
+	utask->active_probe = NULL;
+	utask->doomed = false;
+	INIT_LIST_HEAD(&utask->deferred_registrations);
+	INIT_LIST_HEAD(&utask->delayed_signals);
+	INIT_LIST_HEAD(&utask->list);
+	list_add_tail(&utask->list, &uproc->thread_list);
+	uprobe_hash_utask(utask);
+
+	engine = utrace_attach_pid(p, UTRACE_ATTACH_CREATE,
+						p_uprobe_utrace_ops, utask);
+	if (IS_ERR(engine)) {
+		long err = PTR_ERR(engine);
+		printk("uprobes: utrace_attach_task failed, returned %ld\n",
+									err);
+		uprobe_free_task(utask, 0);
+		if (err == -ESRCH)
+			return NULL;
+		return ERR_PTR(err);
+	}
+	utask->engine = engine;
+	/*
+	 * Always watch for traps, clones, execs and exits. Caller must
+	 * set any other engine flags.
+	 */
+	utask_adjust_flags(utask, UPROBE_SET_FLAGS,
+			UTRACE_EVENT(SIGNAL) | UTRACE_EVENT(SIGNAL_IGN) |
+			UTRACE_EVENT(SIGNAL_CORE) | UTRACE_EVENT(EXEC) |
+			UTRACE_EVENT(CLONE) | UTRACE_EVENT(EXIT));
+	/*
+	 * Note that it's OK if t dies just after utrace_attach, because
+	 * with the engine in place, the appropriate report_* callback
+	 * should handle it after we release uproc->rwsem.
+	 */
+	utrace_engine_put(engine);
+	return utask;
+}
+
+/*
+ * start_pid is the pid for a thread in the probed process.  Find the
+ * next thread that doesn't have a corresponding uprobe_task yet.  Return
+ * a ref-counted pid for that task, if any, else NULL.
+ */
+static struct pid *find_next_thread_to_add(struct uprobe_process *uproc,
+						struct pid *start_pid)
+{
+	struct task_struct *t, *start;
+	struct uprobe_task *utask;
+	struct pid *pid = NULL;
+
+	rcu_read_lock();
+	start = pid_task(start_pid, PIDTYPE_PID);
+	t = start;
+	if (t) {
+		do {
+			if (unlikely(t->flags & PF_EXITING))
+				goto dont_add;
+			list_for_each_entry(utask, &uproc->thread_list, list) {
+				if (utask->tsk == t)
+					/* Already added */
+					goto dont_add;
+			}
+			/* Found thread/task to add. */
+			pid = get_pid(task_pid(t));
+			break;
+dont_add:
+			t = next_thread(t);
+		} while (t != start);
+	}
+	rcu_read_unlock();
+	return pid;
+}
+
+/* Runs with uproc_mutex held; returns with uproc->rwsem write-locked. */
+static struct uprobe_process *uprobe_mk_process(struct pid *tg_leader)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_task *utask;
+	struct pid *add_me;
+	int i;
+	long err;
+
+	uproc = kzalloc(sizeof *uproc, GFP_USER);
+	if (unlikely(uproc == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize fields */
+	atomic_set(&uproc->refcount, 1);
+	init_rwsem(&uproc->rwsem);
+	down_write(&uproc->rwsem);
+	init_waitqueue_head(&uproc->waitq);
+	for (i = 0; i < UPROBE_TABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&uproc->uprobe_table[i]);
+	INIT_LIST_HEAD(&uproc->pending_uprobes);
+	INIT_LIST_HEAD(&uproc->thread_list);
+	uproc->nthreads = 0;
+	uproc->n_quiescent_threads = 0;
+	INIT_HLIST_NODE(&uproc->hlist);
+	uproc->tg_leader = get_pid(tg_leader);
+	uproc->tgid = pid_task(tg_leader, PIDTYPE_PID)->tgid;
+	uproc->finished = false;
+
+#ifdef CONFIG_UBP_XOL
+	if (!(ubp_strategies & UBP_HNT_INLINE))
+		uproc->sstep_out_of_line = true;
+	else
+#endif
+		uproc->sstep_out_of_line = false;
+
+	/*
+	 * Create and populate one utask per thread in this process.  We
+	 * can't call uprobe_add_task() while holding RCU lock, so we:
+	 *	1. rcu_read_lock()
+	 *	2. Find the next thread, add_me, in this process that's not
+	 *	already on uproc's thread_list.
+	 *	3. rcu_read_unlock()
+	 *	4. uprobe_add_task(add_me, uproc)
+	 *	Repeat 1-4 'til we have utasks for all threads.
+	 */
+	add_me = tg_leader;
+	while ((add_me = find_next_thread_to_add(uproc, add_me)) != NULL) {
+		utask = uprobe_add_task(add_me, uproc);
+		if (IS_ERR(utask)) {
+			err = PTR_ERR(utask);
+			goto fail;
+		}
+		if (utask)
+			uproc->nthreads++;
+	}
+
+	if (uproc->nthreads == 0) {
+		/* All threads -- even p -- are dead. */
+		err = -ESRCH;
+		goto fail;
+	}
+	return uproc;
+
+fail:
+	uprobe_free_process(uproc, 0);
+	return ERR_PTR(err);
+}
+
+/*
+ * Creates a uprobe_probept and connects it to uk and uproc.  Runs with
+ * uproc->rwsem write-locked.
+ */
+static struct uprobe_probept *uprobe_add_probept(struct uprobe_kimg *uk,
+	struct uprobe_process *uproc)
+{
+	struct uprobe_probept *ppt;
+
+	ppt = kzalloc(sizeof *ppt, GFP_USER);
+	if (unlikely(ppt == NULL))
+		return ERR_PTR(-ENOMEM);
+	init_waitqueue_head(&ppt->waitq);
+	init_waitqueue_head(&ppt->ssilq);
+	spin_lock_init(&ppt->ssil_lock);
+	ppt->ssil_state = SSIL_CLEAR;
+
+	/* Connect to uk. */
+	INIT_LIST_HEAD(&ppt->uprobe_list);
+	list_add_tail(&uk->list, &ppt->uprobe_list);
+	uk->ppt = ppt;
+	uk->status = -EBUSY;
+	ppt->ubp.vaddr = uk->uprobe->vaddr;
+	ppt->ubp.xol_vaddr = 0;
+
+	/* Connect to uproc. */
+	if (!uproc->sstep_out_of_line)
+		ppt->ubp.strategy = UBP_HNT_INLINE;
+	else
+		ppt->ubp.strategy = ubp_strategies;
+	ppt->state = UPROBE_INSERTING;
+	ppt->uproc = uproc;
+	INIT_LIST_HEAD(&ppt->pd_node);
+	list_add_tail(&ppt->pd_node, &uproc->pending_uprobes);
+	INIT_HLIST_NODE(&ppt->ut_node);
+	hlist_add_head(&ppt->ut_node,
+			&uproc->uprobe_table[hash_long(ppt->ubp.vaddr,
+			UPROBE_HASH_BITS)]);
+	uprobe_get_process(uproc);
+	return ppt;
+}
+
+/*
+ * Runs with ppt->uproc write-locked.  Frees ppt and decrements the ref
+ * count on ppt->uproc (but ref count shouldn't hit 0).
+ */
+static void uprobe_free_probept(struct uprobe_probept *ppt)
+{
+	struct uprobe_process *uproc = ppt->uproc;
+
+	xol_free_insn_slot(ppt->ubp.xol_vaddr, uproc->xol_area);
+	hlist_del(&ppt->ut_node);
+	kfree(ppt);
+	uprobe_decref_process(uproc);
+}
+
+static void uprobe_free_kimg(struct uprobe_kimg *uk)
+{
+	uk->uprobe->kdata = NULL;
+	kfree(uk);
+}
+
+/*
+ * Runs with uprobe_process write-locked.
+ * Note that we never free uk->uprobe, because the user owns that.
+ */
+static void purge_uprobe(struct uprobe_kimg *uk)
+{
+	struct uprobe_probept *ppt = uk->ppt;
+
+	list_del(&uk->list);
+	uprobe_free_kimg(uk);
+	if (list_empty(&ppt->uprobe_list))
+		uprobe_free_probept(ppt);
+}
+
+/*
+ * Runs with utask->uproc locked.
+ * read lock if called from uprobe handler.
+ * else write lock.
+ * Returns -EINPROGRESS on success.
+ * Returns -EBUSY if a request for defer registration already exists.
+ * Returns 0 if we have deferred request for both register/unregister.
+ *
+ */
+static int defer_registration(struct uprobe *u, int regflag,
+		struct uprobe_task *utask)
+{
+	struct deferred_registration *dr, *d;
+
+	/* Check if we already have such a defer request */
+	list_for_each_entry_safe(dr, d, &utask->deferred_registrations, list) {
+		if (dr->uprobe == u) {
+			if (dr->regflag != regflag) {
+				/* same as successful register + unregister */
+				list_del(&dr->list);
+				kfree(dr);
+				return 0;
+			} else
+				/* we already have identical request */
+				return -EBUSY;
+		}
+	}
+
+	/* We have a new unique request */
+	dr = kmalloc(sizeof(struct deferred_registration), GFP_USER);
+	if (!dr)
+		return -ENOMEM;
+	dr->uprobe = u;
+	dr->regflag = regflag;
+	INIT_LIST_HEAD(&dr->list);
+	list_add_tail(&dr->list, &utask->deferred_registrations);
+	return -EINPROGRESS;
+}
+
+/*
+ * Given a numeric thread ID, return a ref-counted struct pid for the
+ * task-group-leader thread.
+ */
+static struct pid *uprobe_get_tg_leader(pid_t p)
+{
+	struct pid *pid = NULL;
+
+	rcu_read_lock();
+	if (current->nsproxy)
+		pid = find_vpid(p);
+	if (pid) {
+		struct task_struct *t = pid_task(pid, PIDTYPE_PID);
+		if (t)
+			pid = task_tgid(t);
+		else
+			pid = NULL;
+	}
+	rcu_read_unlock();
+	return get_pid(pid);	/* null pid OK here */
+}
+
+/* See Documentation/uprobes.txt. */
+int register_uprobe(struct uprobe *u)
+{
+	struct uprobe_task *cur_utask, *cur_utask_quiescing = NULL;
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct uprobe_kimg *uk;
+	struct pid *p;
+	int ret = 0, uproc_is_new = 0;
+	bool survivors;
+#ifndef CONFIG_UBP_XOL
+	struct task_struct *tsk;
+#endif
+
+	if (!u || !u->handler)
+		return -EINVAL;
+
+	p = uprobe_get_tg_leader(u->pid);
+	if (!p)
+		return -ESRCH;
+
+	cur_utask = uprobe_find_utask(current);
+	if (cur_utask && cur_utask->active_probe) {
+		/*
+		 * Called from handler; cur_utask->uproc is read-locked.
+		 * Do this registration later.
+		 */
+		put_pid(p);
+		return defer_registration(u, 1, cur_utask);
+	}
+
+	/* Get the uprobe_process for this pid, or make a new one. */
+	mutex_lock(&uproc_mutex);
+	uproc = uprobe_find_process(p);
+
+	if (uproc) {
+		struct uprobe_task *utask;
+
+		mutex_unlock(&uproc_mutex);
+		list_for_each_entry(utask, &uproc->thread_list, list) {
+			if (!utask->active_probe)
+				continue;
+			/*
+			 * utask is at a probepoint, but has dropped
+			 * uproc->rwsem to single-step.  If utask is
+			 * stopped, then it's probably because some
+			 * other engine has asserted UTRACE_STOP;
+			 * that engine may not allow UTRACE_RESUME
+			 * until register_uprobe() returns.  But, for
+			 * reasons we won't go into here, utask wants
+			 * to finish with utask->active_probe before
+			 * allowing handle_pending_uprobes() to run
+			 * (via utask_fake_quiesce()).  So we defer this
+			 * registration operation; it will be run after
+			 * utask->active_probe is taken care of.
+			 */
+			BUG_ON(utask->state != UPTASK_SSTEP);
+			if (task_is_stopped_or_traced(utask->tsk)) {
+				ret =  defer_registration(u, 1, utask);
+				goto fail_uproc;
+			}
+		}
+	} else {
+		uproc = uprobe_mk_process(p);
+		if (IS_ERR(uproc)) {
+			ret = (int) PTR_ERR(uproc);
+			mutex_unlock(&uproc_mutex);
+			goto fail_tsk;
+		}
+		/* Hold uproc_mutex until we've added uproc to uproc_table. */
+		uproc_is_new = 1;
+	}
+
+#ifdef CONFIG_UBP_XOL
+	ret = xol_validate_vaddr(p, u->vaddr, uproc->xol_area);
+#else
+	tsk = pid_task(p, PIDTYPE_PID);
+	ret = ubp_validate_insn_addr(tsk, u->vaddr);
+#endif
+	if (ret < 0)
+		goto fail_uproc;
+
+	if (u->kdata) {
+		/*
+		 * Probe is already/still registered.  This is the only
+		 * place we return -EBUSY to the user.
+		 */
+		ret = -EBUSY;
+		goto fail_uproc;
+	}
+
+	uk = uprobe_mk_kimg(u);
+	if (IS_ERR(uk)) {
+		ret = (int) PTR_ERR(uk);
+		goto fail_uproc;
+	}
+
+	/* See if we already have a probepoint at the vaddr. */
+	ppt = (uproc_is_new ? NULL : uprobe_find_probept(uproc, u->vaddr));
+	if (ppt) {
+		/* Breakpoint is already in place, or soon will be. */
+		uk->ppt = ppt;
+		list_add_tail(&uk->list, &ppt->uprobe_list);
+		switch (ppt->state) {
+		case UPROBE_INSERTING:
+			uk->status = -EBUSY;	/* in progress */
+			if (uproc->tg_leader == task_tgid(current)) {
+				cur_utask_quiescing = cur_utask;
+				BUG_ON(!cur_utask_quiescing);
+			}
+			break;
+		case UPROBE_REMOVING:
+			/* Wait!  Don't remove that bkpt after all! */
+			ppt->state = UPROBE_BP_SET;
+			/* Remove from pending list. */
+			list_del(&ppt->pd_node);
+			/* Wake unregister_uprobe(). */
+			wake_up_all(&ppt->waitq);
+			/*FALLTHROUGH*/
+		case UPROBE_BP_SET:
+			uk->status = 0;
+			break;
+		default:
+			BUG();
+		}
+		up_write(&uproc->rwsem);
+		put_pid(p);
+		if (uk->status == 0) {
+			uprobe_decref_process(uproc);
+			return 0;
+		}
+		goto await_bkpt_insertion;
+	} else {
+		ppt = uprobe_add_probept(uk, uproc);
+		if (IS_ERR(ppt)) {
+			ret = (int) PTR_ERR(ppt);
+			goto fail_uk;
+		}
+	}
+
+	if (uproc_is_new) {
+		hlist_add_head(&uproc->hlist,
+				&uproc_table[hash_ptr(uproc->tg_leader,
+				UPROBE_HASH_BITS)]);
+		mutex_unlock(&uproc_mutex);
+	}
+	put_pid(p);
+	survivors = quiesce_all_threads(uproc, &cur_utask_quiescing);
+
+	if (!survivors) {
+		purge_uprobe(uk);
+		up_write(&uproc->rwsem);
+		uprobe_put_process(uproc, false);
+		return -ESRCH;
+	}
+	up_write(&uproc->rwsem);
+
+await_bkpt_insertion:
+	if (cur_utask_quiescing)
+		/* Current task is probing its own process. */
+		(void) utask_fake_quiesce(cur_utask_quiescing);
+	else
+		wait_event(ppt->waitq, ppt->state != UPROBE_INSERTING);
+	ret = uk->status;
+	if (ret != 0) {
+		down_write(&uproc->rwsem);
+		purge_uprobe(uk);
+		up_write(&uproc->rwsem);
+	}
+	uprobe_put_process(uproc, false);
+	return ret;
+
+fail_uk:
+	uprobe_free_kimg(uk);
+
+fail_uproc:
+	if (uproc_is_new) {
+		uprobe_free_process(uproc, 0);
+		mutex_unlock(&uproc_mutex);
+	} else {
+		up_write(&uproc->rwsem);
+		uprobe_put_process(uproc, false);
+	}
+
+fail_tsk:
+	put_pid(p);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_uprobe);
+
+/* See Documentation/uprobes.txt. */
+void unregister_uprobe(struct uprobe *u)
+{
+	struct pid *p;
+	struct uprobe_process *uproc;
+	struct uprobe_kimg *uk;
+	struct uprobe_probept *ppt;
+	struct uprobe_task *cur_utask, *cur_utask_quiescing = NULL;
+	struct uprobe_task *utask;
+
+	if (!u)
+		return;
+	p = uprobe_get_tg_leader(u->pid);
+	if (!p)
+		return;
+
+	cur_utask = uprobe_find_utask(current);
+	if (cur_utask && cur_utask->active_probe) {
+		/* Called from handler; uproc is read-locked; do this later */
+		put_pid(p);
+		(void) defer_registration(u, 0, cur_utask);
+		return;
+	}
+
+	/*
+	 * Lock uproc before walking the graph, in case the process we're
+	 * probing is exiting.
+	 */
+	mutex_lock(&uproc_mutex);
+	uproc = uprobe_find_process(p);
+	mutex_unlock(&uproc_mutex);
+	put_pid(p);
+	if (!uproc)
+		return;
+
+	list_for_each_entry(utask, &uproc->thread_list, list) {
+		if (!utask->active_probe)
+			continue;
+
+		/* See comment in register_uprobe(). */
+		BUG_ON(utask->state != UPTASK_SSTEP);
+		if (task_is_stopped_or_traced(utask->tsk)) {
+			(void) defer_registration(u, 0, utask);
+			goto done;
+		}
+	}
+	uk = (struct uprobe_kimg *)u->kdata;
+	if (!uk)
+		/*
+		 * This probe was never successfully registered, or
+		 * has already been unregistered.
+		 */
+		goto done;
+	if (uk->status == -EBUSY)
+		/* Looks like register or unregister is already in progress. */
+		goto done;
+	ppt = uk->ppt;
+
+	list_del(&uk->list);
+	uprobe_free_kimg(uk);
+
+	if (!list_empty(&ppt->uprobe_list))
+		goto done;
+
+	/*
+	 * The last uprobe at ppt's probepoint is being unregistered.
+	 * Queue the breakpoint for removal.
+	 */
+	ppt->state = UPROBE_REMOVING;
+	list_add_tail(&ppt->pd_node, &uproc->pending_uprobes);
+
+	(void) quiesce_all_threads(uproc, &cur_utask_quiescing);
+	up_write(&uproc->rwsem);
+	if (cur_utask_quiescing)
+		/* Current task is probing its own process. */
+		(void) utask_fake_quiesce(cur_utask_quiescing);
+	else
+		wait_event(ppt->waitq, ppt->state != UPROBE_REMOVING);
+
+	if (likely(ppt->state == UPROBE_DISABLED)) {
+		down_write(&uproc->rwsem);
+		uprobe_free_probept(ppt);
+		/* else somebody else's register_uprobe() resurrected ppt. */
+		up_write(&uproc->rwsem);
+	}
+	uprobe_put_process(uproc, false);
+	return;
+
+done:
+	up_write(&uproc->rwsem);
+	uprobe_put_process(uproc, false);
+}
+EXPORT_SYMBOL_GPL(unregister_uprobe);
+
+/* Find a surviving thread in uproc.  Runs with uproc->rwsem locked. */
+static struct task_struct *find_surviving_thread(struct uprobe_process *uproc)
+{
+	struct uprobe_task *utask;
+
+	list_for_each_entry(utask, &uproc->thread_list, list) {
+		if (!(utask->tsk->flags & PF_EXITING))
+			return utask->tsk;
+	}
+	return NULL;
+}
+
+/*
+ * Run all the deferred_registrations previously queued by the current utask.
+ * Runs with no locks or mutexes held.  The current utask's uprobe_process
+ * is ref-counted, so it won't disappear as the result of unregister_u*probe()
+ * called here.
+ */
+static void uprobe_run_def_regs(struct list_head *drlist)
+{
+	struct deferred_registration *dr, *d;
+
+	list_for_each_entry_safe(dr, d, drlist, list) {
+		int result = 0;
+		struct uprobe *u = dr->uprobe;
+
+		if (dr->regflag)
+			result = register_uprobe(u);
+		else
+			unregister_uprobe(u);
+		if (u && u->registration_callback)
+			u->registration_callback(u, dr->regflag, result);
+		list_del(&dr->list);
+		kfree(dr);
+	}
+}
+
+/*
+ * utrace engine report callbacks
+ */
+
+/*
+ * We've been asked to quiesce, but aren't in a position to do so.
+ * This could happen in either of the following cases:
+ *
+ * 1) Our own thread is doing a register or unregister operation --
+ * e.g., as called from a uprobe handler or a non-uprobes utrace
+ * callback.  We can't wait_event() for ourselves in [un]register_uprobe().
+ *
+ * 2) We've been asked to quiesce, but we hit a probepoint first.  Now
+ * we're in the report_signal callback, having handled the probepoint.
+ * We'd like to just turn on UTRACE_EVENT(QUIESCE) and coast into
+ * quiescence.  Unfortunately, it's possible to hit a probepoint again
+ * before we quiesce.  When processing the SIGTRAP, utrace would call
+ * uprobe_report_quiesce(), which must decline to take any action so
+ * as to avoid removing the uprobe just hit.  As a result, we could
+ * keep hitting breakpoints and never quiescing.
+ *
+ * So here we do essentially what we'd prefer to do in uprobe_report_quiesce().
+ * If we're the last thread to quiesce, handle_pending_uprobes() and
+ * rouse_all_threads().  Otherwise, pretend we're quiescent and sleep until
+ * the last quiescent thread handles that stuff and then wakes us.
+ *
+ * Called and returns with no mutexes held.  Returns 1 if we free utask->uproc,
+ * else 0.
+ */
+static int utask_fake_quiesce(struct uprobe_task *utask)
+{
+	struct uprobe_process *uproc = utask->uproc;
+	enum uprobe_task_state prev_state = utask->state;
+
+	down_write(&uproc->rwsem);
+
+	/* In case we're somehow set to quiesce for real... */
+	clear_utrace_quiesce(utask, false);
+
+	if (uproc->n_quiescent_threads == uproc->nthreads-1) {
+		/* We're the last thread to "quiesce." */
+		handle_pending_uprobes(uproc, utask->tsk);
+		rouse_all_threads(uproc);
+		up_write(&uproc->rwsem);
+		return 0;
+	} else {
+		utask->state = UPTASK_SLEEPING;
+		uproc->n_quiescent_threads++;
+		up_write(&uproc->rwsem);
+		/* We ref-count sleepers. */
+		uprobe_get_process(uproc);
+
+		wait_event(uproc->waitq, !utask->quiescing);
+
+		down_write(&uproc->rwsem);
+		utask->state = prev_state;
+		uproc->n_quiescent_threads--;
+		up_write(&uproc->rwsem);
+
+		/*
+		 * If uproc's last uprobe has been unregistered, and
+		 * unregister_uprobe() woke up before we did, it's up
+		 * to us to free uproc.
+		 */
+		return uprobe_put_process(uproc, false);
+	}
+}
+
+/* Prepare to single-step ppt's probed instruction inline. */
+static void uprobe_pre_ssin(struct uprobe_task *utask,
+	struct uprobe_probept *ppt, struct pt_regs *regs)
+{
+	unsigned long flags;
+
+	if (unlikely(ppt->ssil_state == SSIL_DISABLE)) {
+		reset_thread_ip(utask->tsk, regs, ppt->ubp.vaddr);
+		return;
+	}
+	spin_lock_irqsave(&ppt->ssil_lock, flags);
+	while (ppt->ssil_state == SSIL_SET) {
+		spin_unlock_irqrestore(&ppt->ssil_lock, flags);
+		up_read(&utask->uproc->rwsem);
+		wait_event(ppt->ssilq, ppt->ssil_state != SSIL_SET);
+		down_read(&utask->uproc->rwsem);
+		spin_lock_irqsave(&ppt->ssil_lock, flags);
+	}
+	if (unlikely(ppt->ssil_state == SSIL_DISABLE)) {
+		/*
+		 * While waiting to single step inline, breakpoint has
+		 * been removed. Thread continues as if nothing happened.
+		 */
+		spin_unlock_irqrestore(&ppt->ssil_lock, flags);
+		reset_thread_ip(utask->tsk, regs, ppt->ubp.vaddr);
+		return;
+	}
+	ppt->ssil_state = SSIL_SET;
+	spin_unlock_irqrestore(&ppt->ssil_lock, flags);
+
+	if (unlikely(ubp_pre_sstep(utask->tsk, &ppt->ubp,
+					&utask->arch_info, regs) != 0)) {
+		printk(KERN_ERR "Failed to temporarily restore original "
+			"instruction for single-stepping: "
+			"pid/tgid=%d/%d, vaddr=%#lx\n",
+			utask->tsk->pid, utask->tsk->tgid, ppt->ubp.vaddr);
+		utask->doomed = true;
+	}
+}
+
+/* Prepare to continue execution after single-stepping inline. */
+static void uprobe_post_ssin(struct uprobe_task *utask,
+	struct uprobe_probept *ppt, struct pt_regs *regs)
+{
+	unsigned long flags;
+
+	if (unlikely(ubp_post_sstep(utask->tsk, &ppt->ubp,
+					&utask->arch_info, regs) != 0))
+		printk("Couldn't restore bp: pid/tgid=%d/%d, addr=%#lx\n",
+			utask->tsk->pid, utask->tsk->tgid, ppt->ubp.vaddr);
+	spin_lock_irqsave(&ppt->ssil_lock, flags);
+	if (likely(ppt->ssil_state == SSIL_SET)) {
+		ppt->ssil_state = SSIL_CLEAR;
+		wake_up(&ppt->ssilq);
+	}
+	spin_unlock_irqrestore(&ppt->ssil_lock, flags);
+}
+
+#ifdef CONFIG_UBP_XOL
+/*
+ * This architecture wants to do single-stepping out of line, but now we've
+ * discovered that it can't -- typically because we couldn't set up the XOL
+ * vma.  Make all probepoints use inline single-stepping.
+ */
+static void uproc_cancel_xol(struct uprobe_process *uproc)
+{
+	down_write(&uproc->rwsem);
+	if (likely(uproc->sstep_out_of_line)) {
+		/* No other task beat us to it. */
+		int i;
+		struct uprobe_probept *ppt;
+		struct hlist_node *node;
+		struct hlist_head *head;
+		for (i = 0; i < UPROBE_TABLE_SIZE; i++) {
+			head = &uproc->uprobe_table[i];
+			hlist_for_each_entry(ppt, node, head, ut_node) {
+				if (!(ppt->ubp.strategy & UBP_HNT_INLINE))
+					ubp_cancel_xol(current, &ppt->ubp);
+			}
+		}
+		/* Do this last, so other tasks don't proceed too soon. */
+		uproc->sstep_out_of_line = false;
+	}
+	up_write(&uproc->rwsem);
+}
+
+/* Prepare to single-step ppt's probed instruction out of line. */
+static int uprobe_pre_ssout(struct uprobe_task *utask,
+	struct uprobe_probept *ppt, struct pt_regs *regs)
+{
+	if (!ppt->ubp.xol_vaddr)
+		ppt->ubp.xol_vaddr = xol_get_insn_slot(&ppt->ubp,
+						ppt->uproc->xol_area);
+	if (unlikely(!ppt->ubp.xol_vaddr)) {
+		ubp_cancel_xol(utask->tsk, &ppt->ubp);
+		return -1;
+	}
+	utask->singlestep_addr = ppt->ubp.xol_vaddr;
+	return ubp_pre_sstep(utask->tsk, &ppt->ubp, &utask->arch_info, regs);
+}
+
+/* Prepare to continue execution after single-stepping out of line. */
+static int uprobe_post_ssout(struct uprobe_task *utask,
+	struct uprobe_probept *ppt, struct pt_regs *regs)
+{
+	int ret;
+
+	ret = ubp_post_sstep(utask->tsk, &ppt->ubp, &utask->arch_info, regs);
+	return ret;
+}
+#endif
+
+/*
+ * If this thread is supposed to be quiescing, mark it quiescent; and
+ * if it was the last thread to quiesce, do the work we quiesced for.
+ * Runs with utask->uproc->rwsem write-locked.  Returns true if we can
+ * let this thread resume.
+ */
+static bool utask_quiesce(struct uprobe_task *utask)
+{
+	if (utask->quiescing) {
+		if (utask->state != UPTASK_QUIESCENT) {
+			utask->state = UPTASK_QUIESCENT;
+			utask->uproc->n_quiescent_threads++;
+		}
+		return check_uproc_quiesced(utask->uproc, current);
+	} else {
+		clear_utrace_quiesce(utask, false);
+		return true;
+	}
+}
+
+/*
+ * Delay delivery of the indicated signal until after single-step.
+ * Otherwise single-stepping will be cancelled as part of calling
+ * the signal handler.
+ */
+static void uprobe_delay_signal(struct uprobe_task *utask, siginfo_t *info)
+{
+	struct delayed_signal *ds;
+
+	ds = kmalloc(sizeof(*ds), GFP_USER);
+	if (ds) {
+		ds->info = *info;
+		INIT_LIST_HEAD(&ds->list);
+		list_add_tail(&ds->list, &utask->delayed_signals);
+	}
+}
+
+static void uprobe_inject_delayed_signals(struct list_head *delayed_signals)
+{
+	struct delayed_signal *ds, *tmp;
+
+	list_for_each_entry_safe(ds, tmp, delayed_signals, list) {
+		send_sig_info(ds->info.si_signo, &ds->info, current);
+		list_del(&ds->list);
+		kfree(ds);
+	}
+}
+
+/*
+ * Verify from Instruction Pointer if singlestep has indeed occurred.
+ * If Singlestep has occurred, then do post singlestep fix-ups.
+ */
+static bool validate_and_post_sstep(struct uprobe_task *utask,
+				struct pt_regs *regs,
+				struct uprobe_probept *ppt)
+{
+	unsigned long vaddr = instruction_pointer(regs);
+
+	if (ppt->ubp.strategy & UBP_HNT_INLINE) {
+		/*
+		 * If we have singlestepped, Instruction pointer cannot
+		 * be same as virtual address of probepoint.
+		 */
+		if (vaddr == ppt->ubp.vaddr)
+			return false;
+		uprobe_post_ssin(utask, ppt, regs);
+#ifdef CONFIG_UBP_XOL
+	} else {
+		/*
+		 * If we have executed out of line, Instruction pointer
+		 * cannot be same as virtual address of XOL slot.
+		 */
+		if (vaddr == ppt->ubp.xol_vaddr)
+			return false;
+		uprobe_post_ssout(utask, ppt, regs);
+#endif
+	}
+	return true;
+}
+
+/*
+ * Helper routine for uprobe_report_signal().
+ * We get called here with:
+ *	state = UPTASK_RUNNING => we are here due to a breakpoint hit
+ *		- Read-lock the process
+ *		- Figure out which probepoint, based on regs->IP
+ *		- Set state = UPTASK_BP_HIT
+ *		- Invoke handler for each uprobe at this probepoint
+ *		- Reset regs->IP to beginning of the insn, if necessary
+ *		- Start watching for quiesce events, in case another
+ *			engine cancels our UTRACE_SINGLESTEP with a
+ *			UTRACE_STOP.
+ *		- Set singlestep in motion (UTRACE_SINGLESTEP),
+ *			with state = UPTASK_SSTEP
+ *		- Read-unlock the process
+ *
+ *	state = UPTASK_SSTEP => here after single-stepping
+ *		- Read-lock the process
+ *		- Validate we are here per the state machine
+ *		- Clean up after single-stepping
+ *		- Set state = UPTASK_RUNNING
+ *		- Read-unlock the process
+ *		- If it's time to quiesce, take appropriate action.
+ *		- If the handler(s) we ran called [un]register_uprobe(),
+ *			complete those via uprobe_run_def_regs().
+ *
+ *	state = ANY OTHER STATE
+ *		- Not our signal, pass it on (UTRACE_RESUME)
+ */
+static u32 uprobe_handle_signal(u32 action,
+				struct uprobe_task *utask,
+				struct pt_regs *regs,
+				siginfo_t *info,
+				const struct k_sigaction *orig_ka)
+{
+	struct uprobe_probept *ppt;
+	struct uprobe_process *uproc;
+	struct uprobe_kimg *uk;
+	unsigned long probept;
+	enum utrace_resume_action resume_action;
+	enum utrace_signal_action signal_action = utrace_signal_action(action);
+
+	uproc = utask->uproc;
+
+	/*
+	 * We may need to re-assert UTRACE_SINGLESTEP if this signal
+	 * is not associated with the breakpoint.
+	 */
+	if (utask->state == UPTASK_SSTEP)
+		resume_action = UTRACE_SINGLESTEP;
+	else
+		resume_action = UTRACE_RESUME;
+	/*
+	 * This might be UTRACE_SIGNAL_REPORT request but some other
+	 * engine's callback might have changed the signal action to
+	 * something other than UTRACE_SIGNAL_REPORT. Use orig_ka to figure
+	 * out such cases.
+	 */
+	if (unlikely(signal_action == UTRACE_SIGNAL_REPORT) || !orig_ka) {
+		/* This thread was quiesced using UTRACE_INTERRUPT. */
+		bool done_quiescing;
+		if (utask->active_probe)
+			/*
+			 * We'll fake quiescence after we're done
+			 * processing the probepoint.
+			 */
+			return UTRACE_SIGNAL_IGN | resume_action;
+
+		down_write(&uproc->rwsem);
+		done_quiescing = utask_quiesce(utask);
+		up_write(&uproc->rwsem);
+		if (done_quiescing)
+			resume_action = UTRACE_RESUME;
+		else
+			resume_action = UTRACE_STOP;
+		return UTRACE_SIGNAL_IGN | resume_action;
+	}
+
+	/*
+	 * info will be null if we're called with action=UTRACE_SIGNAL_HANDLER,
+	 * which means that single-stepping has been disabled so a signal
+	 * handler can be called in the probed process.  That should never
+	 * happen because we intercept and delay handled signals (action =
+	 * UTRACE_RESUME) until after we're done single-stepping.
+	 */
+	BUG_ON(!info);
+	if (signal_action == UTRACE_SIGNAL_DELIVER && utask->active_probe &&
+					info->si_signo != SSTEP_SIGNAL) {
+		uprobe_delay_signal(utask, info);
+		return UTRACE_SIGNAL_IGN | UTRACE_SINGLESTEP;
+	}
+
+	if (info->si_signo != BREAKPOINT_SIGNAL &&
+					info->si_signo != SSTEP_SIGNAL)
+		goto no_interest;
+
+	switch (utask->state) {
+	case UPTASK_RUNNING:
+		if (info->si_signo != BREAKPOINT_SIGNAL)
+			goto no_interest;
+
+#ifdef CONFIG_UBP_XOL
+		/*
+		 * Set up the XOL area if it's not already there.  We
+		 * do this here because we have to do it before
+		 * handling the first probepoint hit, the probed
+		 * process has to do it, and this may be the first
+		 * time our probed process runs uprobes code.  We need
+		 * the XOL area for the uretprobe trampoline even if
+		 * this architectures doesn't single-step out of line.
+		 */
+		if (uproc->sstep_out_of_line && !uproc->xol_area) {
+			uproc->xol_area = xol_get_area(uproc->tg_leader);
+			if (unlikely(uproc->sstep_out_of_line) &&
+					unlikely(!uproc->xol_area))
+				uproc_cancel_xol(uproc);
+		}
+#endif
+
+		down_read(&uproc->rwsem);
+		/* Don't quiesce while running handlers. */
+		clear_utrace_quiesce(utask, false);
+		probept = ubp_get_bkpt_addr(regs);
+		ppt = uprobe_find_probept(uproc, probept);
+		if (!ppt) {
+			up_read(&uproc->rwsem);
+			goto no_interest;
+		}
+		utask->active_probe = ppt;
+		utask->state = UPTASK_BP_HIT;
+
+		if (likely(ppt->state == UPROBE_BP_SET)) {
+			list_for_each_entry(uk, &ppt->uprobe_list, list) {
+				struct uprobe *u = uk->uprobe;
+				if (u->handler)
+					u->handler(u, regs);
+			}
+		}
+
+#ifdef CONFIG_UBP_XOL
+		if ((ppt->ubp.strategy & UBP_HNT_INLINE) ||
+				uprobe_pre_ssout(utask, ppt, regs) != 0)
+#endif
+			uprobe_pre_ssin(utask, ppt, regs);
+		if (unlikely(utask->doomed)) {
+			utask->active_probe = NULL;
+			utask->state = UPTASK_RUNNING;
+			up_read(&uproc->rwsem);
+			goto no_interest;
+		}
+		utask->state = UPTASK_SSTEP;
+		/* In case another engine cancels our UTRACE_SINGLESTEP... */
+		utask_adjust_flags(utask, UPROBE_SET_FLAGS,
+							UTRACE_EVENT(QUIESCE));
+		/* Don't deliver this signal to the process. */
+		resume_action = UTRACE_SINGLESTEP;
+		signal_action = UTRACE_SIGNAL_IGN;
+
+		up_read(&uproc->rwsem);
+		break;
+
+	case UPTASK_SSTEP:
+		if (info->si_signo != SSTEP_SIGNAL)
+			goto no_interest;
+
+		down_read(&uproc->rwsem);
+		ppt = utask->active_probe;
+		BUG_ON(!ppt);
+
+		/*
+		 * Havent singlestepped yet? then re-assert
+		 * UTRACE_SINGLESTEP.
+		 */
+		if (!validate_and_post_sstep(utask, regs, ppt)) {
+			up_read(&uproc->rwsem);
+			goto no_interest;
+		}
+
+		/* No further need to re-assert UTRACE_SINGLESTEP. */
+		clear_utrace_quiesce(utask, false);
+
+		utask->active_probe = NULL;
+		utask->state = UPTASK_RUNNING;
+		if (unlikely(utask->doomed)) {
+			up_read(&uproc->rwsem);
+			goto no_interest;
+		}
+
+		if (utask->quiescing) {
+			int uproc_freed;
+			up_read(&uproc->rwsem);
+			uproc_freed = utask_fake_quiesce(utask);
+			BUG_ON(uproc_freed);
+		} else
+			up_read(&uproc->rwsem);
+
+		/*
+		 * We hold a ref count on uproc, so this should never
+		 * make utask or uproc disappear.
+		 */
+		uprobe_run_def_regs(&utask->deferred_registrations);
+
+		uprobe_inject_delayed_signals(&utask->delayed_signals);
+
+		resume_action = UTRACE_RESUME;
+		signal_action = UTRACE_SIGNAL_IGN;
+		break;
+	default:
+		goto no_interest;
+	}
+
+no_interest:
+	return signal_action | resume_action;
+}
+
+/*
+ * Signal callback:
+ */
+static u32 uprobe_report_signal(u32 action,
+				struct utrace_engine *engine,
+				struct pt_regs *regs,
+				siginfo_t *info,
+				const struct k_sigaction *orig_ka,
+				struct k_sigaction *return_ka)
+{
+	struct uprobe_task *utask;
+	struct uprobe_process *uproc;
+	bool doomed;
+	enum utrace_resume_action report_action;
+
+	utask = (struct uprobe_task *)rcu_dereference(engine->data);
+	BUG_ON(!utask);
+	uproc = utask->uproc;
+
+	/* Keep uproc intact until just before we return. */
+	uprobe_get_process(uproc);
+	report_action = uprobe_handle_signal(action, utask, regs, info,
+								orig_ka);
+	doomed = utask->doomed;
+
+	if (uprobe_put_process(uproc, true))
+		report_action = utrace_signal_action(report_action) |
+					UTRACE_DETACH;
+	if (doomed)
+		do_exit(SIGSEGV);
+	return report_action;
+}
+
+/*
+ * Quiesce callback: The associated process has one or more breakpoint
+ * insertions or removals pending.  If we're the last thread in this
+ * process to quiesce, do the insertion(s) and/or removal(s).
+ */
+static u32 uprobe_report_quiesce(u32 action,
+				struct utrace_engine *engine,
+				unsigned long event)
+{
+	struct uprobe_task *utask;
+	struct uprobe_process *uproc;
+	bool done_quiescing = false;
+
+	utask = (struct uprobe_task *)rcu_dereference(engine->data);
+	BUG_ON(!utask);
+
+	if (utask->state == UPTASK_SSTEP)
+		/*
+		 * We got a breakpoint trap and tried to single-step,
+		 * but somebody else's report_signal callback overrode
+		 * our UTRACE_SINGLESTEP with a UTRACE_STOP.  Try again.
+		 */
+		return UTRACE_SINGLESTEP;
+
+	BUG_ON(utask->active_probe);
+	uproc = utask->uproc;
+	down_write(&uproc->rwsem);
+	done_quiescing = utask_quiesce(utask);
+	up_write(&uproc->rwsem);
+	return done_quiescing ? UTRACE_RESUME : UTRACE_STOP;
+}
+
+/*
+ * uproc's process is exiting or exec-ing.  Runs with uproc->rwsem
+ * write-locked.  Caller must ref-count uproc before calling this
+ * function, to ensure that uproc doesn't get freed in the middle of
+ * this.
+ */
+static void uprobe_cleanup_process(struct uprobe_process *uproc)
+{
+	struct hlist_node *pnode1, *pnode2;
+	struct uprobe_kimg *uk, *unode;
+	struct uprobe_probept *ppt;
+	struct hlist_head *head;
+	int i;
+
+	uproc->finished = true;
+	for (i = 0; i < UPROBE_TABLE_SIZE; i++) {
+		head = &uproc->uprobe_table[i];
+		hlist_for_each_entry_safe(ppt, pnode1, pnode2, head, ut_node) {
+			if (ppt->state == UPROBE_INSERTING ||
+					ppt->state == UPROBE_REMOVING) {
+				/*
+				 * This task is (exec/exit)ing with
+				 * a [un]register_uprobe pending.
+				 * [un]register_uprobe will free ppt.
+				 */
+				ppt->state = UPROBE_DISABLED;
+				list_del(&ppt->pd_node);
+				list_for_each_entry_safe(uk, unode,
+					       &ppt->uprobe_list, list)
+					uk->status = -ESRCH;
+				wake_up_all(&ppt->waitq);
+			} else if (ppt->state == UPROBE_BP_SET) {
+				list_for_each_entry_safe(uk, unode,
+					       &ppt->uprobe_list, list) {
+					list_del(&uk->list);
+					uprobe_free_kimg(uk);
+				}
+				uprobe_free_probept(ppt);
+			/* else */
+				/*
+				 * If ppt is UPROBE_DISABLED, assume that
+				 * [un]register_uprobe() has been notified
+				 * and will free it soon.
+				 */
+			}
+		}
+	}
+}
+
+static u32 uprobe_exec_exit(struct utrace_engine *engine,
+				struct task_struct *tsk, int exit)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_probept *ppt;
+	struct uprobe_task *utask;
+	bool utask_quiescing;
+
+	utask = (struct uprobe_task *)rcu_dereference(engine->data);
+	uproc = utask->uproc;
+	uprobe_get_process(uproc);
+
+	ppt = utask->active_probe;
+	if (ppt) {
+		printk(KERN_WARNING "Task handler called %s while at uprobe"
+				" probepoint: pid/tgid = %d/%d, probepoint"
+				" = %#lx\n", (exit ? "exit" : "exec"),
+				tsk->pid, tsk->tgid, ppt->ubp.vaddr);
+		/*
+		 * Mutex cleanup depends on where do_execve()/do_exit() was
+		 * called and on ubp strategy (XOL vs. SSIL).
+		 */
+		if (ppt->ubp.strategy & UBP_HNT_INLINE) {
+			switch (utask->state) {
+				unsigned long flags;
+			case UPTASK_SSTEP:
+				spin_lock_irqsave(&ppt->ssil_lock, flags);
+				ppt->ssil_state = SSIL_CLEAR;
+				wake_up(&ppt->ssilq);
+				spin_unlock_irqrestore(&ppt->ssil_lock, flags);
+				break;
+			default:
+				break;
+			}
+		}
+		if (utask->state == UPTASK_BP_HIT) {
+			/* uprobe handler called do_exit()/do_execve(). */
+			up_read(&uproc->rwsem);
+			uprobe_decref_process(uproc);
+		}
+	}
+
+	down_write(&uproc->rwsem);
+	utask_quiescing = utask->quiescing;
+	uproc->nthreads--;
+	if (utrace_set_events_pid(utask->pid, engine, 0))
+		/* We don't care. */
+		;
+	uprobe_free_task(utask, 1);
+	if (uproc->nthreads) {
+		/*
+		 * In case other threads are waiting for us to quiesce...
+		 */
+		if (utask_quiescing)
+			(void) check_uproc_quiesced(uproc,
+				       find_surviving_thread(uproc));
+	} else
+		/*
+		 * We were the last remaining thread - clean up the uprobe
+		 * remnants a la unregister_uprobe(). We don't have to
+		 * remove the breakpoints, though.
+		 */
+		uprobe_cleanup_process(uproc);
+
+	up_write(&uproc->rwsem);
+	uprobe_put_process(uproc, true);
+	return UTRACE_DETACH;
+}
+
+/*
+ * Exit callback: The associated task/thread is exiting.
+ */
+static u32 uprobe_report_exit(u32 action,
+			struct utrace_engine *engine,
+			long orig_code, long *code)
+{
+	return uprobe_exec_exit(engine, current, 1);
+}
+/*
+ * Clone callback: The current task has spawned a thread/process.
+ * Utrace guarantees that parent and child pointers will be valid
+ * for the duration of this callback.
+ *
+ * NOTE: For now, we don't pass on uprobes from the parent to the
+ * child. We now do the necessary clearing of breakpoints in the
+ * child's address space.
+ *
+ * TODO:
+ *	- Provide option for child to inherit uprobes.
+ */
+static u32 uprobe_report_clone(u32 action,
+				struct utrace_engine *engine,
+				unsigned long clone_flags,
+				struct task_struct *child)
+{
+	struct uprobe_process *uproc;
+	struct uprobe_task *ptask, *ctask;
+
+	ptask = (struct uprobe_task *)rcu_dereference(engine->data);
+	uproc = ptask->uproc;
+
+	/*
+	 * Lock uproc so no new uprobes can be installed 'til all
+	 * report_clone activities are completed.
+	 */
+	mutex_lock(&uproc_mutex);
+	down_write(&uproc->rwsem);
+
+	if (clone_flags & CLONE_THREAD) {
+		/* New thread in the same process. */
+		ctask = uprobe_find_utask(child);
+		if (unlikely(ctask)) {
+			/*
+			 * uprobe_mk_process() ran just as this clone
+			 * happened, and has already accounted for the
+			 * new child.
+			 */
+		} else {
+			struct pid *child_pid = get_pid(task_pid(child));
+			BUG_ON(!child_pid);
+			ctask = uprobe_add_task(child_pid, uproc);
+			BUG_ON(!ctask);
+			if (IS_ERR(ctask))
+				goto done;
+			uproc->nthreads++;
+			/*
+			 * FIXME: Handle the case where uproc is quiescing
+			 * (assuming it's possible to clone while quiescing).
+			 */
+		}
+	} else {
+		/*
+		 * New process spawned by parent.  Remove the probepoints
+		 * in the child's text.
+		 *
+		 * Its not necessary to quiesce the child as we are assured
+		 * by utrace that this callback happens *before* the child
+		 * gets to run userspace.
+		 *
+		 * We also hold the uproc->rwsem for the parent - so no
+		 * new uprobes will be registered 'til we return.
+		 */
+		int i;
+		struct uprobe_probept *ppt;
+		struct hlist_node *node;
+		struct hlist_head *head;
+
+		for (i = 0; i < UPROBE_TABLE_SIZE; i++) {
+			head = &uproc->uprobe_table[i];
+			hlist_for_each_entry(ppt, node, head, ut_node) {
+				if (ubp_remove_bkpt(child, &ppt->ubp) != 0) {
+					/* Ratelimit this? */
+					printk(KERN_ERR "Pid %d forked %d;"
+						" failed to remove probepoint"
+						" at %#lx in child\n",
+						current->pid, child->pid,
+						ppt->ubp.vaddr);
+				}
+			}
+		}
+	}
+
+done:
+	up_write(&uproc->rwsem);
+	mutex_unlock(&uproc_mutex);
+	return UTRACE_RESUME;
+}
+
+/*
+ * Exec callback: The associated process called execve() or friends
+ *
+ * The new program is about to start running and so there is no
+ * possibility of a uprobe from the previous user address space
+ * to be hit.
+ *
+ * NOTE:
+ *	Typically, this process would have passed through the clone
+ *	callback, where the necessary action *should* have been
+ *	taken. However, if we still end up at this callback:
+ *		- We don't have to clear the uprobes - memory image
+ *		  will be overlaid.
+ *		- We have to free up uprobe resources associated with
+ *		  this process.
+ */
+static u32 uprobe_report_exec(u32 action,
+				struct utrace_engine *engine,
+				const struct linux_binfmt *fmt,
+				const struct linux_binprm *bprm,
+				struct pt_regs *regs)
+{
+	return uprobe_exec_exit(engine, current, 0);
+}
+
+static const struct utrace_engine_ops uprobe_utrace_ops = {
+	.report_quiesce = uprobe_report_quiesce,
+	.report_signal = uprobe_report_signal,
+	.report_exit = uprobe_report_exit,
+	.report_clone = uprobe_report_clone,
+	.report_exec = uprobe_report_exec
+};
+
+static int __init init_uprobes(void)
+{
+	int ret, i;
+
+	ubp_strategies = UBP_HNT_TSKINFO;
+	ret = ubp_init(&ubp_strategies);
+	if (ret != 0) {
+		printk(KERN_ERR "Can't start uprobes: ubp_init() returned %d\n",
+								ret);
+		return ret;
+	}
+	for (i = 0; i < UPROBE_TABLE_SIZE; i++) {
+		INIT_HLIST_HEAD(&uproc_table[i]);
+		INIT_HLIST_HEAD(&utask_table[i]);
+	}
+
+	p_uprobe_utrace_ops = &uprobe_utrace_ops;
+	return 0;
+}
+
+static void __exit exit_uprobes(void)
+{
+}
+
+module_init(init_uprobes);
+module_exit(exit_uprobes);
