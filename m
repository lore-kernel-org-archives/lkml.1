Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0AKMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0AKMZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353Ab0AKMZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:25:53 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42610 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0AKMZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:25:51 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:55:45 +0530
Message-Id: <20100111122545.22050.64994.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 3/7] Execution out of line (XOL)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Execution out of line (XOL)

Slot allocation mechanism for Execution Out of Line strategy in User
space breakpointing Inftrastructure. (XOL)

This patch provides slot allocation mechanism for execution out of
line strategy for use with user space breakpoint infrastructure.
This patch requires utrace support in kernel.

This patch provides five functions xol_get_insn_slot(),
xol_free_insn_slot(), xol_put_area(), xol_get_area() and
xol_validate_vaddr().

Current slot allocation mechanism:
1. Allocate one dedicated slot per user breakpoint.
2. If the allocated vma is completely used, expand current vma.
3. If we cant expand the vma, allocate a new vma.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/Kconfig            |    4 
 include/linux/ubp_xol.h |   56 ++++
 kernel/Makefile         |    1 
 kernel/ubp_xol.c        |  644 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 705 insertions(+)

Index: new_uprobes.git/arch/Kconfig
===================================================================
--- new_uprobes.git.orig/arch/Kconfig
+++ new_uprobes.git/arch/Kconfig
@@ -102,6 +102,10 @@ config USER_RETURN_NOTIFIER
 config HAVE_UBP
 	def_bool n
 
+config UBP_XOL
+	def_bool y
+	depends on UBP && UTRACE
+
 config HAVE_IOREMAP_PROT
 	bool
 
Index: new_uprobes.git/include/linux/ubp_xol.h
===================================================================
--- /dev/null
+++ new_uprobes.git/include/linux/ubp_xol.h
@@ -0,0 +1,56 @@
+#ifndef _LINUX_XOL_H
+#define _LINUX_XOL_H
+/*
+ * User-space BreakPoint support (ubp) -- Allocation of instruction
+ * slots for execution out of line (XOL)
+ * include/linux/ubp_xol.h
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
+ * Copyright (C) IBM Corporation, 2009
+ */
+
+
+#if defined(CONFIG_UBP_XOL)
+extern unsigned long xol_get_insn_slot(struct ubp_bkpt *ubp, void *xol_area);
+extern void xol_free_insn_slot(unsigned long, void *xol_area);
+extern int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
+							void *xol_area);
+extern void *xol_get_area(struct pid *pid);
+extern void xol_put_area(void *xol_area);
+#else /* CONFIG_UBP_XOL */
+static inline unsigned long xol_get_insn_slot(struct ubp_bkpt *ubp,
+							void *xol_area)
+{
+	return 0;
+}
+static inline void xol_free_insn_slot(unsigned long slot_addr, void *xol_area)
+{
+}
+static inline int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
+							void *xol_area)
+{
+	return -ENOSYS;
+}
+static inline void *xol_get_area(struct pid *pid)
+{
+	return NULL;
+}
+static inline void xol_put_area(void *xol_area)
+{
+}
+#endif /* CONFIG_UBP_XOL */
+
+#endif  /* _LINUX_XOL_H */
Index: new_uprobes.git/kernel/Makefile
===================================================================
--- new_uprobes.git.orig/kernel/Makefile
+++ new_uprobes.git/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_UBP) += ubp_core.o
+obj-$(CONFIG_UBP_XOL) += ubp_xol.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: new_uprobes.git/kernel/ubp_xol.c
===================================================================
--- /dev/null
+++ new_uprobes.git/kernel/ubp_xol.c
@@ -0,0 +1,644 @@
+/*
+ * User-space BreakPoint support (ubp) -- Allocation of instruction
+ * slots for execution out of line (XOL)
+ * kernel/ubp_xol.c
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
+ * Copyright (C) IBM Corporation, 2009
+ */
+
+/*
+ * Every probepoint gets its own slot.  Once it's assigned a slot, it
+ * keeps that slot until the probepoint goes away.  If we run out of
+ * slots in the XOL vma, we try to expand it by one page.  If we can't
+ * expand it, we allocate an additional vma. Only the probed process
+ * itself can add or expand vmas.
+ */
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/err.h>
+#include <linux/kref.h>
+#include <linux/utrace.h>
+#include <linux/ubp.h>
+#include <linux/errno.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+
+#define UINSNS_PER_PAGE	(PAGE_SIZE/UBP_XOL_SLOT_BYTES)
+
+struct ubp_xol_vma {
+	struct list_head list;
+	unsigned long *bitmap;		/* 0 = free slot */
+
+	/*
+	 * We keep the vma's vm_start rather than a pointer to the vma
+	 * itself.  The probed process or a naughty kernel module could make
+	 * the vma go away, and we must handle that reasonably gracefully.
+	 */
+	unsigned long vaddr;		/* Page(s) of instruction slots */
+	int npages;
+	int nslots;
+};
+
+struct ubp_xol_area {
+	struct list_head vmas;
+	struct mutex mutex;	/* Serializes access to list of vmas */
+
+	/*
+	 * We ref-count threads and clients.  The xol_report_* callbacks
+	 * are all about noticing when the last thread goes away.
+	 */
+	struct kref kref;
+	struct ubp_xol_vma *last_vma;
+	pid_t tgid;
+	bool can_expand;
+};
+
+static const struct utrace_engine_ops xol_engine_ops;
+static void xol_free_area(struct kref *kref);
+
+/*
+ * xol_mutex allows creation of unique ubp_xol_area.
+ * Critical region for xol_mutex includes creation and initialization
+ * of ubp_xol_area and attaching an exclusive engine with
+ * xol_engine_ops for the thread whose pid is thread group id.
+ */
+static DEFINE_MUTEX(xol_mutex);
+
+/**
+ * xol_put_area - release a reference to ubp_xol_area.
+ * If this happens to be the last reference, free the ubp_xol_area.
+ * @xol_area: unique per process ubp_xol_area for this process.
+ */
+void xol_put_area(void *xol_area)
+{
+	struct ubp_xol_area *area = (struct ubp_xol_area *) xol_area;
+
+	if (unlikely(!area))
+		return;
+	kref_put(&area->kref, xol_free_area);
+}
+
+/*
+ * Need unique ubp_xol_area. This is achieved by using utrace engines.
+ * However code using utrace could be avoided if mm_struct /
+ * mm_context_t had a pointer to ubp_xol_area.
+ */
+
+/*
+ * xol_create_engine - add a thread to watch
+ * xol_create_engine can return these values:
+ *  0: successfully created an engine.
+ *  -EEXIST: don't bother because an engine already exists for this
+ *  thread.
+ *  -ESRCH: Process or thread is exiting; don't need to create an
+ *  engine.
+ *  -ENOMEM: utrace can't allocate memory for the engine
+ *
+ *  This function is called holding a reference to pid.
+ */
+static int xol_create_engine(struct pid *pid, struct ubp_xol_area *area)
+{
+	struct utrace_engine *engine;
+	int result;
+
+	engine = utrace_attach_pid(pid, UTRACE_ATTACH_CREATE |
+			UTRACE_ATTACH_EXCLUSIVE | UTRACE_ATTACH_MATCH_OPS,
+			&xol_engine_ops, area);
+	if (IS_ERR(engine)) {
+		put_pid(pid);
+		return PTR_ERR(engine);
+	}
+	result = utrace_set_events_pid(pid, engine,
+		UTRACE_EVENT(EXEC) | UTRACE_EVENT(CLONE) | UTRACE_EVENT(EXIT));
+	/*
+	 * Since this is the first and only time we set events for this
+	 * engine, there shouldn't be any callbacks in progress.
+	 */
+	WARN_ON(result == -EINPROGRESS);
+	kref_get(&area->kref);
+	put_pid(pid);
+	utrace_engine_put(engine);
+	return 0;
+}
+
+/*
+ * If a thread clones while xol_get_area() is running, it's possible
+ * for xol_create_engine() to be called both from there and from
+ * here.  No problem, since xol_create_engine() refuses to create (or
+ * ref-count) a second engine for the same task.
+ */
+static u32 xol_report_clone(u32 action,
+				struct utrace_engine *engine,
+				unsigned long clone_flags,
+				struct task_struct *child)
+{
+	if (clone_flags & CLONE_THREAD) {
+		struct pid *child_pid = get_pid(task_pid(child));
+
+		BUG_ON(!child_pid);
+		(void)xol_create_engine(child_pid,
+			(struct ubp_xol_area *) engine->data);
+	}
+	return UTRACE_RESUME;
+}
+
+/*
+ * When a multithreaded app execs, the exec-ing thread reports the
+ * exec, and the other threads report exit.
+ */
+static u32 xol_report_exec(u32 action,
+				struct utrace_engine *engine,
+				const struct linux_binfmt *fmt,
+				const struct linux_binprm *bprm,
+				struct pt_regs *regs)
+{
+	xol_put_area((struct ubp_xol_area *)engine->data);
+	return UTRACE_DETACH;
+}
+
+static u32 xol_report_exit(u32 action, struct utrace_engine *engine,
+			long orig_code, long *code)
+{
+	xol_put_area((struct ubp_xol_area *)engine->data);
+	return UTRACE_DETACH;
+}
+
+static const struct utrace_engine_ops xol_engine_ops = {
+	.report_exit = xol_report_exit,
+	.report_clone = xol_report_clone,
+	.report_exec = xol_report_exec
+};
+
+/*
+ * @start_pid is the pid for a thread in the traced process.
+ * Creating engines for a hugely multithreaded process can be
+ * time consuming. Hence engines for other threads are created
+ * outside the critical region.
+ */
+static void create_engine_sibling_threads(struct pid *start_pid,
+						struct ubp_xol_area *area)
+{
+	struct task_struct *t, *start;
+	struct utrace_engine *engine;
+	struct pid *pid = NULL;
+
+	rcu_read_lock();
+	start = pid_task(start_pid, PIDTYPE_PID);
+	t = start;
+	if (t) {
+		do {
+			if (t->exit_state) {
+				t = next_thread(t);
+				continue;
+			}
+
+			/*
+			 * This doesn't sleep, does minimal error checking.
+			 */
+			engine = utrace_attach_task(t,
+				UTRACE_ATTACH_MATCH_OPS,
+				&xol_engine_ops, NULL);
+			if (PTR_ERR(engine) == -ENOENT) {
+				pid = get_pid(task_pid(t));
+				(void)xol_create_engine(pid, area);
+			} else if (!IS_ERR(engine))
+				utrace_engine_put(engine);
+
+			t = next_thread(t);
+		} while (t != start);
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * xol_get_area - Get a reference to process's ubp_xol_area.
+ * If an ubp_xol_area doesn't exist for @tg_leader's process, create
+ * one.  In any case, increment its refcount and return a pointer
+ * to it.
+ * @tg_leader: pointer to struct pid of a thread whose tid is the
+ * thread group id
+ */
+void *xol_get_area(struct pid *tg_leader)
+{
+	struct ubp_xol_area *area = NULL;
+	struct utrace_engine *engine;
+	struct pid *pid;
+	int ret;
+
+	pid = get_pid(tg_leader);
+	mutex_lock(&xol_mutex);
+	engine = utrace_attach_pid(tg_leader, UTRACE_ATTACH_MATCH_OPS,
+			&xol_engine_ops, NULL);
+	if (!IS_ERR(engine)) {
+		area = engine->data;
+		utrace_engine_put(engine);
+		mutex_unlock(&xol_mutex);
+		goto found_area;
+	}
+
+	area = kzalloc(sizeof(*area), GFP_USER);
+	if (unlikely(!area)) {
+		mutex_unlock(&xol_mutex);
+		return NULL;
+	}
+	mutex_init(&area->mutex);
+	kref_init(&area->kref);
+	area->last_vma = NULL;
+	area->can_expand = true;
+	area->tgid = pid_task(tg_leader, PIDTYPE_PID)->tgid;
+	INIT_LIST_HEAD(&area->vmas);
+	ret = xol_create_engine(pid, area);
+	mutex_unlock(&xol_mutex);
+
+	if (ret != 0) {
+		kfree(area);
+		return NULL;
+	}
+	create_engine_sibling_threads(pid, area);
+
+found_area:
+	if (likely(area))
+		kref_get(&area->kref);
+	return (void *) area;
+}
+
+static void xol_free_area(struct kref *kref)
+{
+	struct ubp_xol_vma *usv, *tmp;
+	struct ubp_xol_area *area;
+
+	area = container_of(kref, struct ubp_xol_area, kref);
+	list_for_each_entry_safe(usv, tmp, &area->vmas, list) {
+		kfree(usv->bitmap);
+		kfree(usv);
+	}
+	kfree(area);
+}
+
+/*
+ * Allocate a bitmap for a new vma, or expand an existing bitmap.
+ * if old_bitmap is non-NULL, xol_realloc_bitmap() never returns
+ * old_bitmap.
+ */
+static unsigned long *xol_realloc_bitmap(unsigned long *old_bitmap,
+					 int old_nslots, int new_nslots)
+{
+	unsigned long *new_bitmap;
+
+	BUG_ON(new_nslots < old_nslots);
+
+	new_bitmap = kzalloc(BITS_TO_LONGS(new_nslots) * sizeof(long),
+								GFP_USER);
+	if (!new_bitmap) {
+		printk(KERN_ERR "ubp_xol: cannot %sallocate bitmap for XOL "
+			"area for pid/tgid %d/%d\n", (old_bitmap ? "re" : ""),
+			current->pid, current->tgid);
+		return NULL;
+	}
+	if (old_bitmap)
+		memcpy(new_bitmap, old_bitmap,
+				BITS_TO_LONGS(old_nslots) * sizeof(long));
+	return new_bitmap;
+}
+
+static struct ubp_xol_vma *xol_alloc_vma(void)
+{
+	struct ubp_xol_vma *usv;
+
+	usv = kzalloc(sizeof(struct ubp_xol_vma), GFP_USER);
+	if (!usv) {
+		printk(KERN_ERR "ubp_xol: cannot allocate kmem for XOL vma"
+			" for pid/tgid %d/%d\n", current->pid, current->tgid);
+		return NULL;
+	}
+	usv->bitmap = xol_realloc_bitmap(NULL, 0, UINSNS_PER_PAGE);
+	if (!usv->bitmap) {
+		kfree(usv);
+		return NULL;
+	}
+	return usv;
+}
+
+static inline struct ubp_xol_vma *xol_add_vma(struct ubp_xol_area *area)
+{
+	struct vm_area_struct *vma;
+	struct ubp_xol_vma *usv;
+	struct mm_struct *mm;
+	struct file *file;
+	unsigned long addr;
+
+	mm = get_task_mm(current);
+	if (!mm)
+		return ERR_PTR(-ESRCH);
+
+	usv = xol_alloc_vma();
+	if (!usv) {
+		mmput(mm);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	down_write(&mm->mmap_sem);
+	/*
+	 * Find the end of the top mapping and skip a page.
+	 * If there is no space for PAGE_SIZE above
+	 * that, mmap will ignore our address hint.
+	 *
+	 * We allocate a "fake" unlinked shmem file because
+	 * anonymous memory might not be granted execute
+	 * permission when the selinux security hooks have
+	 * their way.
+	 */
+	vma = rb_entry(rb_last(&mm->mm_rb), struct vm_area_struct, vm_rb);
+	addr = vma->vm_end + PAGE_SIZE;
+	file = shmem_file_setup("uprobes/ssol", PAGE_SIZE, VM_NORESERVE);
+	if (!file) {
+		printk(KERN_ERR "ubp_xol failed to setup shmem_file while "
+			"allocating vma for pid/tgid %d/%d for "
+			"single-stepping out of line.\n",
+			current->pid, current->tgid);
+		goto fail;
+	}
+	addr = do_mmap_pgoff(file, addr, PAGE_SIZE, PROT_EXEC, MAP_PRIVATE, 0);
+	fput(file);
+
+	if (addr & ~PAGE_MASK) {
+		printk(KERN_ERR "ubp_xol failed to allocate a vma for pid/tgid"
+				" %d/%d for single-stepping out of line.\n",
+				current->pid, current->tgid);
+		goto fail;
+	}
+	vma = find_vma(mm, addr);
+	BUG_ON(!vma);
+
+	/* Don't expand vma on mremap(). */
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
+	usv->vaddr = vma->vm_start;
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	usv->npages = 1;
+	usv->nslots = UINSNS_PER_PAGE;
+	INIT_LIST_HEAD(&usv->list);
+	list_add_tail(&usv->list, &area->vmas);
+	area->last_vma = usv;
+	return usv;
+
+fail:
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	kfree(usv->bitmap);
+	kfree(usv);
+	return ERR_PTR(-ENOMEM);
+}
+
+/* Runs with area->mutex locked */
+static long xol_expand_vma(struct ubp_xol_vma *usv)
+{
+	struct vm_area_struct *vma;
+	unsigned long *new_bitmap;
+	struct mm_struct *mm;
+	unsigned long new_length, result;
+	int new_nslots;
+
+	new_length = PAGE_SIZE * (usv->npages + 1);
+	new_nslots = (int) ((usv->npages + 1) * UINSNS_PER_PAGE);
+
+	/* xol_realloc_bitmap() never returns usv->bitmap. */
+	new_bitmap = xol_realloc_bitmap(usv->bitmap, usv->nslots, new_nslots);
+	if (!new_bitmap)
+		return -ENOMEM;
+
+	mm = get_task_mm(current);
+	if (!mm)
+		return -ESRCH;
+
+	down_write(&mm->mmap_sem);
+	vma = find_vma(mm, usv->vaddr);
+	if (!vma) {
+		printk(KERN_ERR "pid/tgid %d/%d: ubp XOL vma at %#lx"
+			" has disappeared!\n", current->pid, current->tgid,
+			usv->vaddr);
+		result = -ENOMEM;
+		goto fail;
+	}
+	if (vma_pages(vma) != usv->npages || vma->vm_start != usv->vaddr) {
+		printk(KERN_ERR "pid/tgid %d/%d: ubp XOL vma has been"
+			" altered: %#lx/%ld pages; should be %#lx/%d pages\n",
+			current->pid, current->tgid, vma->vm_start,
+			vma_pages(vma), usv->vaddr, usv->npages);
+		result = -ENOMEM;
+		goto fail;
+	}
+	vma->vm_flags &= ~VM_DONTEXPAND;
+	result = do_mremap(usv->vaddr, usv->npages*PAGE_SIZE, new_length, 0, 0);
+	vma->vm_flags |= VM_DONTEXPAND;
+	if (IS_ERR_VALUE(result)) {
+		printk(KERN_WARNING "ubp_xol failed to expand the vma "
+			"for pid/tgid %d/%d for single-stepping out of line.\n",
+			current->pid, current->tgid);
+		goto fail;
+	}
+	BUG_ON(result != usv->vaddr);
+	up_write(&mm->mmap_sem);
+
+	kfree(usv->bitmap);
+	usv->bitmap = new_bitmap;
+	usv->nslots = new_nslots;
+	usv->npages++;
+	return 0;
+
+fail:
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	kfree(new_bitmap);
+	return result;
+}
+
+/*
+ * Find a slot
+ *  - searching in existing vmas for a free slot.
+ *  - If no free slot in existing vmas, try expanding the last vma.
+ *  - If unable to expand a vma, try adding a new vma.
+ *
+ * Runs with area->mutex locked.
+ */
+static unsigned long xol_take_insn_slot(struct ubp_xol_area *area)
+{
+	struct ubp_xol_vma *usv;
+	unsigned long slot_addr;
+	int slot_nr;
+
+	list_for_each_entry(usv, &area->vmas, list) {
+		slot_nr = find_first_zero_bit(usv->bitmap, usv->nslots);
+		if (slot_nr < usv->nslots) {
+			set_bit(slot_nr, usv->bitmap);
+			slot_addr = usv->vaddr +
+				(slot_nr * UBP_XOL_SLOT_BYTES);
+			return slot_addr;
+		}
+	}
+
+	/*
+	 * All out of space.  Need to allocate a new page.
+	 * Only the probed process itself can add or expand vmas.
+	 */
+	if (!area->can_expand || (area->tgid != current->tgid))
+		goto fail;
+
+	usv = area->last_vma;
+	if (usv) {
+		/* Expand vma, take first of newly added slots. */
+		slot_nr = usv->nslots;
+		if (xol_expand_vma(usv) != 0) {
+			printk(KERN_WARNING "Allocating additional vma.\n");
+			usv = NULL;
+		}
+	}
+	if (!usv) {
+		slot_nr = 0;
+		usv = xol_add_vma(area);
+		if (IS_ERR(usv))
+			goto cant_expand;
+	}
+
+	/* Take first slot of new page. */
+	set_bit(slot_nr, usv->bitmap);
+	slot_addr = usv->vaddr + (slot_nr * UBP_XOL_SLOT_BYTES);
+	return slot_addr;
+
+cant_expand:
+	area->can_expand = false;
+fail:
+	return 0;
+}
+
+/**
+ * xol_get_insn_slot - If ubp was not allocated a slot, then
+ * allocate a slot. If ubp_insert_bkpt is already called, (i.e
+ * ubp.vaddr != 0) then copy the instruction into the slot.
+ * Allocating a free slot could result in
+ *	- using a free slot in the current vma or
+ * 	- expanding the last vma or
+ * 	- adding a new vma.
+ * Returns the allocated slot address or 0.
+ * @ubp: probepoint information
+ * @xol_area refers the unique per process ubp_xol_area for
+ * this process.
+ */
+unsigned long xol_get_insn_slot(struct ubp_bkpt *ubp, void *xol_area)
+{
+	struct ubp_xol_area *area = (struct ubp_xol_area *) xol_area;
+	int len;
+
+	if (unlikely(!area))
+		return 0;
+	mutex_lock(&area->mutex);
+	if (likely(!ubp->xol_vaddr)) {
+		ubp->xol_vaddr = xol_take_insn_slot(area);
+		/*
+		 * Initialize the slot if ubp->vaddr points to valid
+		 * instruction slot.
+		 */
+		if (likely(ubp->xol_vaddr) && ubp->vaddr) {
+			len = access_process_vm(current, ubp->xol_vaddr,
+					ubp->insn, UBP_XOL_SLOT_BYTES, 1);
+			if (unlikely(len < UBP_XOL_SLOT_BYTES))
+				printk(KERN_ERR "Failed to copy instruction"
+						" at %#lx len = %d\n",
+						ubp->vaddr, len);
+		}
+	}
+	mutex_unlock(&area->mutex);
+	return ubp->xol_vaddr;
+}
+
+/**
+ * xol_free_insn_slot - If slot was earlier allocated by
+ * @xol_get_insn_slot(), make the slot available for
+ * subsequent requests.
+ * @slot_addr: slot address as returned by
+ * @xol_get_insn_area().
+ * @xol_area refers the unique per process ubp_xol_area for
+ * this process.
+ */
+void xol_free_insn_slot(unsigned long slot_addr, void *xol_area)
+{
+	struct ubp_xol_area *area = (struct ubp_xol_area *) xol_area;
+	struct ubp_xol_vma *usv;
+	int found = 0;
+
+	if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
+		return;
+	if (unlikely(!area))
+		return;
+	mutex_lock(&area->mutex);
+	list_for_each_entry(usv, &area->vmas, list) {
+		unsigned long vma_end = usv->vaddr + usv->npages*PAGE_SIZE;
+		if (usv->vaddr <= slot_addr && slot_addr < vma_end) {
+			int slot_nr;
+			unsigned long offset = slot_addr - usv->vaddr;
+			BUG_ON(offset % UBP_XOL_SLOT_BYTES);
+			slot_nr = offset / UBP_XOL_SLOT_BYTES;
+			BUG_ON(slot_nr >= usv->nslots);
+			clear_bit(slot_nr, usv->bitmap);
+			found = 1;
+		}
+	}
+	mutex_unlock(&area->mutex);
+	if (!found)
+		printk(KERN_ERR "%s: no XOL vma for slot address %#lx\n",
+						__func__, slot_addr);
+}
+
+/**
+ * xol_validate_vaddr - Verify if the specified address is in an
+ * executable vma, but not in an XOL vma.
+ * 	- Return 0 if the specified virtual address is in an
+ * 	  executable vma, but not in an XOL vma.
+ * 	- Return 1 if the specified virtual address is in an
+ * 	  XOL vma.
+ * 	- Return -EINTR otherwise.(i.e non executable vma, or
+ *	  not a valid address
+ * @pid: the probed process
+ * @vaddr: virtual address of the instruction to be validated.
+ * @xol_area refers the unique per process ubp_xol_area for
+ * this process.
+ */
+int xol_validate_vaddr(struct pid *pid, unsigned long vaddr, void *xol_area)
+{
+	struct ubp_xol_area *area = (struct ubp_xol_area *) xol_area;
+	struct ubp_xol_vma *usv;
+	struct task_struct *tsk;
+	int result;
+
+	tsk = pid_task(pid, PIDTYPE_PID);
+	result = ubp_validate_insn_addr(tsk, vaddr);
+	if (result != 0)
+		return result;
+
+	if (unlikely(!area))
+		return 0;
+	mutex_lock(&area->mutex);
+	list_for_each_entry(usv, &area->vmas, list) {
+		unsigned long vma_end = usv->vaddr + usv->npages*PAGE_SIZE;
+		if (usv->vaddr <= vaddr && vaddr < vma_end) {
+			result = 1;
+			break;
+		}
+	}
+	mutex_unlock(&area->mutex);
+	return result;
+}
