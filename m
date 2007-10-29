Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXJ2OcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXJ2OcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbXJ2Oa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:30:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39911 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758165AbXJ2OaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:30:04 -0400
Message-Id: <20071029142939.456446301@polymtl.ca>
References: <20071029142646.699058449@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 29 Oct 2007 10:26:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/10] Move kprobes to instrumentation/ and arch/*/instrumentation/
Content-Disposition: inline; filename=move-kprobes-to-instrumentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 29 Oct 2007 14:29:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the kprobes in the instrumentation directory.

- /instrumentation is compiled as a core-y
- Note : arch/*/instrumentation/kprobes.c is now compiled as a drivers-y. Was a
  core-y before. It is caused by oprofile being a drivers-y.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Prasanna S Panchamukhi <prasanna@in.ibm.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: David S. Miller <davem@davemloft.net>
---
 Makefile                               |    3 
 arch/avr32/instrumentation/Makefile    |    2 
 arch/avr32/instrumentation/kprobes.c   |  268 ++++++++
 arch/avr32/kernel/Makefile             |    1 
 arch/avr32/kernel/kprobes.c            |  268 --------
 arch/ia64/instrumentation/Makefile     |    2 
 arch/ia64/instrumentation/kprobes.c    | 1027 +++++++++++++++++++++++++++++++
 arch/ia64/kernel/kprobes.c             | 1027 -------------------------------
 arch/powerpc/instrumentation/Makefile  |    2 
 arch/powerpc/instrumentation/kprobes.c |  559 +++++++++++++++++
 arch/powerpc/kernel/kprobes.c          |  559 -----------------
 arch/s390/instrumentation/Makefile     |    2 
 arch/s390/instrumentation/kprobes.c    |  672 ++++++++++++++++++++
 arch/s390/kernel/kprobes.c             |  672 --------------------
 arch/sparc64/instrumentation/Makefile  |    2 
 arch/sparc64/instrumentation/kprobes.c |  487 +++++++++++++++
 arch/sparc64/kernel/kprobes.c          |  487 ---------------
 arch/x86/instrumentation/Makefile      |    6 
 arch/x86/instrumentation/kprobes_32.c  |  763 +++++++++++++++++++++++
 arch/x86/instrumentation/kprobes_64.c  |  761 +++++++++++++++++++++++
 arch/x86/kernel/Makefile_32            |    1 
 arch/x86/kernel/Makefile_64            |    1 
 arch/x86/kernel/kprobes_32.c           |  763 -----------------------
 arch/x86/kernel/kprobes_64.c           |  761 -----------------------
 instrumentation/Makefile               |    2 
 instrumentation/kprobes.c              | 1063 +++++++++++++++++++++++++++++++++
 kernel/Makefile                        |    1 
 kernel/kprobes.c                       | 1063 ---------------------------------
 28 files changed, 5620 insertions(+), 5605 deletions(-)

Index: linux-2.6-lttng.stable/instrumentation/kprobes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/instrumentation/kprobes.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,1063 @@
+/*
+ *  Kernel Probes (KProbes)
+ *  kernel/kprobes.c
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
+ * Copyright (C) IBM Corporation, 2002, 2004
+ *
+ * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
+ *		Probes initial implementation (includes suggestions from
+ *		Rusty Russell).
+ * 2004-Aug	Updated by Prasanna S Panchamukhi <prasanna@in.ibm.com> with
+ *		hlists and exceptions notifier as suggested by Andi Kleen.
+ * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
+ *		interface to access function arguments.
+ * 2004-Sep	Prasanna S Panchamukhi <prasanna@in.ibm.com> Changed Kprobes
+ *		exceptions notifier to be first on the priority list.
+ * 2005-May	Hien Nguyen <hien@us.ibm.com>, Jim Keniston
+ *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
+ *		<prasanna@in.ibm.com> added function-return probes.
+ */
+#include <linux/kprobes.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/stddef.h>
+#include <linux/module.h>
+#include <linux/moduleloader.h>
+#include <linux/kallsyms.h>
+#include <linux/freezer.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/kdebug.h>
+
+#include <asm-generic/sections.h>
+#include <asm/cacheflush.h>
+#include <asm/errno.h>
+#include <asm/uaccess.h>
+
+#define KPROBE_HASH_BITS 6
+#define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
+
+
+/*
+ * Some oddball architectures like 64bit powerpc have function descriptors
+ * so this must be overridable.
+ */
+#ifndef kprobe_lookup_name
+#define kprobe_lookup_name(name, addr) \
+	addr = ((kprobe_opcode_t *)(kallsyms_lookup_name(name)))
+#endif
+
+static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
+static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
+
+/* NOTE: change this value only with kprobe_mutex held */
+static bool kprobe_enabled;
+
+DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
+DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
+static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
+
+#ifdef __ARCH_WANT_KPROBES_INSN_SLOT
+/*
+ * kprobe->ainsn.insn points to the copy of the instruction to be
+ * single-stepped. x86_64, POWER4 and above have no-exec support and
+ * stepping on the instruction on a vmalloced/kmalloced/data page
+ * is a recipe for disaster
+ */
+#define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
+
+struct kprobe_insn_page {
+	struct hlist_node hlist;
+	kprobe_opcode_t *insns;		/* Page of instruction slots */
+	char slot_used[INSNS_PER_PAGE];
+	int nused;
+	int ngarbage;
+};
+
+enum kprobe_slot_state {
+	SLOT_CLEAN = 0,
+	SLOT_DIRTY = 1,
+	SLOT_USED = 2,
+};
+
+static struct hlist_head kprobe_insn_pages;
+static int kprobe_garbage_slots;
+static int collect_garbage_slots(void);
+
+static int __kprobes check_safety(void)
+{
+	int ret = 0;
+#if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
+	ret = freeze_processes();
+	if (ret == 0) {
+		struct task_struct *p, *q;
+		do_each_thread(p, q) {
+			if (p != current && p->state == TASK_RUNNING &&
+			    p->pid != 0) {
+				printk("Check failed: %s is running\n",p->comm);
+				ret = -1;
+				goto loop_end;
+			}
+		} while_each_thread(p, q);
+	}
+loop_end:
+	thaw_processes();
+#else
+	synchronize_sched();
+#endif
+	return ret;
+}
+
+/**
+ * get_insn_slot() - Find a slot on an executable page for an instruction.
+ * We allocate an executable page if there's no room on existing ones.
+ */
+kprobe_opcode_t __kprobes *get_insn_slot(void)
+{
+	struct kprobe_insn_page *kip;
+	struct hlist_node *pos;
+
+ retry:
+	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
+		if (kip->nused < INSNS_PER_PAGE) {
+			int i;
+			for (i = 0; i < INSNS_PER_PAGE; i++) {
+				if (kip->slot_used[i] == SLOT_CLEAN) {
+					kip->slot_used[i] = SLOT_USED;
+					kip->nused++;
+					return kip->insns + (i * MAX_INSN_SIZE);
+				}
+			}
+			/* Surprise!  No unused slots.  Fix kip->nused. */
+			kip->nused = INSNS_PER_PAGE;
+		}
+	}
+
+	/* If there are any garbage slots, collect it and try again. */
+	if (kprobe_garbage_slots && collect_garbage_slots() == 0) {
+		goto retry;
+	}
+	/* All out of space.  Need to allocate a new page. Use slot 0. */
+	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
+	if (!kip)
+		return NULL;
+
+	/*
+	 * Use module_alloc so this page is within +/- 2GB of where the
+	 * kernel image and loaded module images reside. This is required
+	 * so x86_64 can correctly handle the %rip-relative fixups.
+	 */
+	kip->insns = module_alloc(PAGE_SIZE);
+	if (!kip->insns) {
+		kfree(kip);
+		return NULL;
+	}
+	INIT_HLIST_NODE(&kip->hlist);
+	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
+	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
+	kip->slot_used[0] = SLOT_USED;
+	kip->nused = 1;
+	kip->ngarbage = 0;
+	return kip->insns;
+}
+
+/* Return 1 if all garbages are collected, otherwise 0. */
+static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
+{
+	kip->slot_used[idx] = SLOT_CLEAN;
+	kip->nused--;
+	if (kip->nused == 0) {
+		/*
+		 * Page is no longer in use.  Free it unless
+		 * it's the last one.  We keep the last one
+		 * so as not to have to set it up again the
+		 * next time somebody inserts a probe.
+		 */
+		hlist_del(&kip->hlist);
+		if (hlist_empty(&kprobe_insn_pages)) {
+			INIT_HLIST_NODE(&kip->hlist);
+			hlist_add_head(&kip->hlist,
+				       &kprobe_insn_pages);
+		} else {
+			module_free(NULL, kip->insns);
+			kfree(kip);
+		}
+		return 1;
+	}
+	return 0;
+}
+
+static int __kprobes collect_garbage_slots(void)
+{
+	struct kprobe_insn_page *kip;
+	struct hlist_node *pos, *next;
+
+	/* Ensure no-one is preepmted on the garbages */
+	if (check_safety() != 0)
+		return -EAGAIN;
+
+	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
+		int i;
+		if (kip->ngarbage == 0)
+			continue;
+		kip->ngarbage = 0;	/* we will collect all garbages */
+		for (i = 0; i < INSNS_PER_PAGE; i++) {
+			if (kip->slot_used[i] == SLOT_DIRTY &&
+			    collect_one_slot(kip, i))
+				break;
+		}
+	}
+	kprobe_garbage_slots = 0;
+	return 0;
+}
+
+void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	struct kprobe_insn_page *kip;
+	struct hlist_node *pos;
+
+	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
+		if (kip->insns <= slot &&
+		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
+			int i = (slot - kip->insns) / MAX_INSN_SIZE;
+			if (dirty) {
+				kip->slot_used[i] = SLOT_DIRTY;
+				kip->ngarbage++;
+			} else {
+				collect_one_slot(kip, i);
+			}
+			break;
+		}
+	}
+
+	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
+		collect_garbage_slots();
+}
+#endif
+
+/* We have preemption disabled.. so it is safe to use __ versions */
+static inline void set_kprobe_instance(struct kprobe *kp)
+{
+	__get_cpu_var(kprobe_instance) = kp;
+}
+
+static inline void reset_kprobe_instance(void)
+{
+	__get_cpu_var(kprobe_instance) = NULL;
+}
+
+/*
+ * This routine is called either:
+ * 	- under the kprobe_mutex - during kprobe_[un]register()
+ * 				OR
+ * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
+ */
+struct kprobe __kprobes *get_kprobe(void *addr)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+
+	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
+	hlist_for_each_entry_rcu(p, node, head, hlist) {
+		if (p->addr == addr)
+			return p;
+	}
+	return NULL;
+}
+
+/*
+ * Aggregate handlers for multiple kprobes support - these handlers
+ * take care of invoking the individual kprobe handlers on p->list
+ */
+static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &p->list, list) {
+		if (kp->pre_handler) {
+			set_kprobe_instance(kp);
+			if (kp->pre_handler(kp, regs))
+				return 1;
+		}
+		reset_kprobe_instance();
+	}
+	return 0;
+}
+
+static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
+					unsigned long flags)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &p->list, list) {
+		if (kp->post_handler) {
+			set_kprobe_instance(kp);
+			kp->post_handler(kp, regs, flags);
+			reset_kprobe_instance();
+		}
+	}
+}
+
+static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
+					int trapnr)
+{
+	struct kprobe *cur = __get_cpu_var(kprobe_instance);
+
+	/*
+	 * if we faulted "during" the execution of a user specified
+	 * probe handler, invoke just that probe's fault handler
+	 */
+	if (cur && cur->fault_handler) {
+		if (cur->fault_handler(cur, regs, trapnr))
+			return 1;
+	}
+	return 0;
+}
+
+static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe *cur = __get_cpu_var(kprobe_instance);
+	int ret = 0;
+
+	if (cur && cur->break_handler) {
+		if (cur->break_handler(cur, regs))
+			ret = 1;
+	}
+	reset_kprobe_instance();
+	return ret;
+}
+
+/* Walks the list and increments nmissed count for multiprobe case */
+void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
+{
+	struct kprobe *kp;
+	if (p->pre_handler != aggr_pre_handler) {
+		p->nmissed++;
+	} else {
+		list_for_each_entry_rcu(kp, &p->list, list)
+			kp->nmissed++;
+	}
+	return;
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
+				struct hlist_head *head)
+{
+	/* remove rp inst off the rprobe_inst_table */
+	hlist_del(&ri->hlist);
+	if (ri->rp) {
+		/* remove rp inst off the used list */
+		hlist_del(&ri->uflist);
+		/* put rp inst back onto the free list */
+		INIT_HLIST_NODE(&ri->uflist);
+		hlist_add_head(&ri->uflist, &ri->rp->free_instances);
+	} else
+		/* Unregistering */
+		hlist_add_head(&ri->hlist, head);
+}
+
+struct hlist_head __kprobes *kretprobe_inst_table_head(struct task_struct *tsk)
+{
+	return &kretprobe_inst_table[hash_ptr(tsk, KPROBE_HASH_BITS)];
+}
+
+/*
+ * This function is called from finish_task_switch when task tk becomes dead,
+ * so that we can recycle any function-return probe instances associated
+ * with this task. These left over instances represent probed functions
+ * that have been called but will never return.
+ */
+void __kprobes kprobe_flush_task(struct task_struct *tk)
+{
+	struct kretprobe_instance *ri;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags = 0;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(tk);
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task == tk)
+			recycle_rp_inst(ri, &empty_rp);
+	}
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+}
+
+static inline void free_rp_inst(struct kretprobe *rp)
+{
+	struct kretprobe_instance *ri;
+	struct hlist_node *pos, *next;
+
+	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
+		hlist_del(&ri->uflist);
+		kfree(ri);
+	}
+}
+
+/*
+ * Keep all fields in the kprobe consistent
+ */
+static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
+{
+	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
+	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
+}
+
+/*
+* Add the new probe to old_p->list. Fail if this is the
+* second jprobe at the address - two jprobes can't coexist
+*/
+static int __kprobes add_new_kprobe(struct kprobe *old_p, struct kprobe *p)
+{
+	if (p->break_handler) {
+		if (old_p->break_handler)
+			return -EEXIST;
+		list_add_tail_rcu(&p->list, &old_p->list);
+		old_p->break_handler = aggr_break_handler;
+	} else
+		list_add_rcu(&p->list, &old_p->list);
+	if (p->post_handler && !old_p->post_handler)
+		old_p->post_handler = aggr_post_handler;
+	return 0;
+}
+
+/*
+ * Fill in the required fields of the "manager kprobe". Replace the
+ * earlier kprobe in the hlist with the manager kprobe
+ */
+static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
+{
+	copy_kprobe(p, ap);
+	flush_insn_slot(ap);
+	ap->addr = p->addr;
+	ap->pre_handler = aggr_pre_handler;
+	ap->fault_handler = aggr_fault_handler;
+	if (p->post_handler)
+		ap->post_handler = aggr_post_handler;
+	if (p->break_handler)
+		ap->break_handler = aggr_break_handler;
+
+	INIT_LIST_HEAD(&ap->list);
+	list_add_rcu(&p->list, &ap->list);
+
+	hlist_replace_rcu(&p->hlist, &ap->hlist);
+}
+
+/*
+ * This is the second or subsequent kprobe at the address - handle
+ * the intricacies
+ */
+static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
+					  struct kprobe *p)
+{
+	int ret = 0;
+	struct kprobe *ap;
+
+	if (old_p->pre_handler == aggr_pre_handler) {
+		copy_kprobe(old_p, p);
+		ret = add_new_kprobe(old_p, p);
+	} else {
+		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+		if (!ap)
+			return -ENOMEM;
+		add_aggr_kprobe(ap, old_p);
+		copy_kprobe(ap, p);
+		ret = add_new_kprobe(ap, p);
+	}
+	return ret;
+}
+
+static int __kprobes in_kprobes_functions(unsigned long addr)
+{
+	if (addr >= (unsigned long)__kprobes_text_start &&
+	    addr < (unsigned long)__kprobes_text_end)
+		return -EINVAL;
+	return 0;
+}
+
+static int __kprobes __register_kprobe(struct kprobe *p,
+	unsigned long called_from)
+{
+	int ret = 0;
+	struct kprobe *old_p;
+	struct module *probed_mod;
+
+	/*
+	 * If we have a symbol_name argument look it up,
+	 * and add it to the address.  That way the addr
+	 * field can either be global or relative to a symbol.
+	 */
+	if (p->symbol_name) {
+		if (p->addr)
+			return -EINVAL;
+		kprobe_lookup_name(p->symbol_name, p->addr);
+	}
+
+	if (!p->addr)
+		return -EINVAL;
+	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
+
+	if (!kernel_text_address((unsigned long) p->addr) ||
+	    in_kprobes_functions((unsigned long) p->addr))
+		return -EINVAL;
+
+	p->mod_refcounted = 0;
+
+	/*
+	 * Check if are we probing a module.
+	 */
+	probed_mod = module_text_address((unsigned long) p->addr);
+	if (probed_mod) {
+		struct module *calling_mod = module_text_address(called_from);
+		/*
+		 * We must allow modules to probe themself and in this case
+		 * avoid incrementing the module refcount, so as to allow
+		 * unloading of self probing modules.
+		 */
+		if (calling_mod && calling_mod != probed_mod) {
+			if (unlikely(!try_module_get(probed_mod)))
+				return -EINVAL;
+			p->mod_refcounted = 1;
+		} else
+			probed_mod = NULL;
+	}
+
+	p->nmissed = 0;
+	mutex_lock(&kprobe_mutex);
+	old_p = get_kprobe(p->addr);
+	if (old_p) {
+		ret = register_aggr_kprobe(old_p, p);
+		goto out;
+	}
+
+	ret = arch_prepare_kprobe(p);
+	if (ret)
+		goto out;
+
+	INIT_HLIST_NODE(&p->hlist);
+	hlist_add_head_rcu(&p->hlist,
+		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
+
+	if (kprobe_enabled)
+		arch_arm_kprobe(p);
+
+out:
+	mutex_unlock(&kprobe_mutex);
+
+	if (ret && probed_mod)
+		module_put(probed_mod);
+	return ret;
+}
+
+int __kprobes register_kprobe(struct kprobe *p)
+{
+	return __register_kprobe(p, (unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kprobe(struct kprobe *p)
+{
+	struct module *mod;
+	struct kprobe *old_p, *list_p;
+	int cleanup_p;
+
+	mutex_lock(&kprobe_mutex);
+	old_p = get_kprobe(p->addr);
+	if (unlikely(!old_p)) {
+		mutex_unlock(&kprobe_mutex);
+		return;
+	}
+	if (p != old_p) {
+		list_for_each_entry_rcu(list_p, &old_p->list, list)
+			if (list_p == p)
+			/* kprobe p is a valid probe */
+				goto valid_p;
+		mutex_unlock(&kprobe_mutex);
+		return;
+	}
+valid_p:
+	if (old_p == p ||
+	    (old_p->pre_handler == aggr_pre_handler &&
+	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
+		/*
+		 * Only probe on the hash list. Disarm only if kprobes are
+		 * enabled - otherwise, the breakpoint would already have
+		 * been removed. We save on flushing icache.
+		 */
+		if (kprobe_enabled)
+			arch_disarm_kprobe(p);
+		hlist_del_rcu(&old_p->hlist);
+		cleanup_p = 1;
+	} else {
+		list_del_rcu(&p->list);
+		cleanup_p = 0;
+	}
+
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	if (p->mod_refcounted) {
+		mod = module_text_address((unsigned long)p->addr);
+		if (mod)
+			module_put(mod);
+	}
+
+	if (cleanup_p) {
+		if (p != old_p) {
+			list_del_rcu(&p->list);
+			kfree(old_p);
+		}
+		arch_remove_kprobe(p);
+	} else {
+		mutex_lock(&kprobe_mutex);
+		if (p->break_handler)
+			old_p->break_handler = NULL;
+		if (p->post_handler){
+			list_for_each_entry_rcu(list_p, &old_p->list, list){
+				if (list_p->post_handler){
+					cleanup_p = 2;
+					break;
+				}
+			}
+			if (cleanup_p == 0)
+				old_p->post_handler = NULL;
+		}
+		mutex_unlock(&kprobe_mutex);
+	}
+}
+
+static struct notifier_block kprobe_exceptions_nb = {
+	.notifier_call = kprobe_exceptions_notify,
+	.priority = 0x7fffffff /* we need to be notified first */
+};
+
+unsigned long __weak arch_deref_entry_point(void *entry)
+{
+	return (unsigned long)entry;
+}
+
+int __kprobes register_jprobe(struct jprobe *jp)
+{
+	unsigned long addr = arch_deref_entry_point(jp->entry);
+
+	if (!kernel_text_address(addr))
+		return -EINVAL;
+
+	/* Todo: Verify probepoint is a function entry point */
+	jp->kp.pre_handler = setjmp_pre_handler;
+	jp->kp.break_handler = longjmp_break_handler;
+
+	return __register_kprobe(&jp->kp,
+		(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_jprobe(struct jprobe *jp)
+{
+	unregister_kprobe(&jp->kp);
+}
+
+#ifdef ARCH_SUPPORTS_KRETPROBES
+
+/*
+ * This kprobe pre_handler is registered with every kretprobe. When probe
+ * hits it will set up the return probe.
+ */
+static int __kprobes pre_handler_kretprobe(struct kprobe *p,
+					   struct pt_regs *regs)
+{
+	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
+	unsigned long flags = 0;
+
+	/*TODO: consider to only swap the RA after the last pre_handler fired */
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	if (!hlist_empty(&rp->free_instances)) {
+		struct kretprobe_instance *ri;
+
+		ri = hlist_entry(rp->free_instances.first,
+				 struct kretprobe_instance, uflist);
+		ri->rp = rp;
+		ri->task = current;
+		arch_prepare_kretprobe(ri, regs);
+
+		/* XXX(hch): why is there no hlist_move_head? */
+		hlist_del(&ri->uflist);
+		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
+		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
+	} else
+		rp->nmissed++;
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	return 0;
+}
+
+int __kprobes register_kretprobe(struct kretprobe *rp)
+{
+	int ret = 0;
+	struct kretprobe_instance *inst;
+	int i;
+	void *addr = rp->kp.addr;
+
+	if (kretprobe_blacklist_size) {
+		if (addr == NULL)
+			kprobe_lookup_name(rp->kp.symbol_name, addr);
+		addr += rp->kp.offset;
+
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			if (kretprobe_blacklist[i].addr == addr)
+				return -EINVAL;
+		}
+	}
+
+	rp->kp.pre_handler = pre_handler_kretprobe;
+	rp->kp.post_handler = NULL;
+	rp->kp.fault_handler = NULL;
+	rp->kp.break_handler = NULL;
+
+	/* Pre-allocate memory for max kretprobe instances */
+	if (rp->maxactive <= 0) {
+#ifdef CONFIG_PREEMPT
+		rp->maxactive = max(10, 2 * NR_CPUS);
+#else
+		rp->maxactive = NR_CPUS;
+#endif
+	}
+	INIT_HLIST_HEAD(&rp->used_instances);
+	INIT_HLIST_HEAD(&rp->free_instances);
+	for (i = 0; i < rp->maxactive; i++) {
+		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
+		if (inst == NULL) {
+			free_rp_inst(rp);
+			return -ENOMEM;
+		}
+		INIT_HLIST_NODE(&inst->uflist);
+		hlist_add_head(&inst->uflist, &rp->free_instances);
+	}
+
+	rp->nmissed = 0;
+	/* Establish function entry probe point */
+	if ((ret = __register_kprobe(&rp->kp,
+		(unsigned long)__builtin_return_address(0))) != 0)
+		free_rp_inst(rp);
+	return ret;
+}
+
+#else /* ARCH_SUPPORTS_KRETPROBES */
+
+int __kprobes register_kretprobe(struct kretprobe *rp)
+{
+	return -ENOSYS;
+}
+
+static int __kprobes pre_handler_kretprobe(struct kprobe *p,
+					   struct pt_regs *regs)
+{
+	return 0;
+}
+
+#endif /* ARCH_SUPPORTS_KRETPROBES */
+
+void __kprobes unregister_kretprobe(struct kretprobe *rp)
+{
+	unsigned long flags;
+	struct kretprobe_instance *ri;
+	struct hlist_node *pos, *next;
+
+	unregister_kprobe(&rp->kp);
+
+	/* No race here */
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
+		ri->rp = NULL;
+		hlist_del(&ri->uflist);
+	}
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	free_rp_inst(rp);
+}
+
+static int __init init_kprobes(void)
+{
+	int i, err = 0;
+
+	/* FIXME allocate the probe table, currently defined statically */
+	/* initialize all list heads */
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		INIT_HLIST_HEAD(&kprobe_table[i]);
+		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
+	}
+
+	if (kretprobe_blacklist_size) {
+		/* lookup the function address from its name */
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			kprobe_lookup_name(kretprobe_blacklist[i].name,
+					   kretprobe_blacklist[i].addr);
+			if (!kretprobe_blacklist[i].addr)
+				printk("kretprobe: lookup failed: %s\n",
+				       kretprobe_blacklist[i].name);
+		}
+	}
+
+	/* By default, kprobes are enabled */
+	kprobe_enabled = true;
+
+	err = arch_init_kprobes();
+	if (!err)
+		err = register_die_notifier(&kprobe_exceptions_nb);
+
+	return err;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
+		const char *sym, int offset,char *modname)
+{
+	char *kprobe_type;
+
+	if (p->pre_handler == pre_handler_kretprobe)
+		kprobe_type = "r";
+	else if (p->pre_handler == setjmp_pre_handler)
+		kprobe_type = "j";
+	else
+		kprobe_type = "k";
+	if (sym)
+		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
+			sym, offset, (modname ? modname : " "));
+	else
+		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
+}
+
+static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
+}
+
+static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= KPROBE_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+static void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p, *kp;
+	const char *sym = NULL;
+	unsigned int i = *(loff_t *) v;
+	unsigned long offset = 0;
+	char *modname, namebuf[128];
+
+	head = &kprobe_table[i];
+	preempt_disable();
+	hlist_for_each_entry_rcu(p, node, head, hlist) {
+		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
+					&offset, &modname, namebuf);
+		if (p->pre_handler == aggr_pre_handler) {
+			list_for_each_entry_rcu(kp, &p->list, list)
+				report_probe(pi, kp, sym, offset, modname);
+		} else
+			report_probe(pi, p, sym, offset, modname);
+	}
+	preempt_enable();
+	return 0;
+}
+
+static struct seq_operations kprobes_seq_ops = {
+	.start = kprobe_seq_start,
+	.next  = kprobe_seq_next,
+	.stop  = kprobe_seq_stop,
+	.show  = show_kprobe_addr
+};
+
+static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &kprobes_seq_ops);
+}
+
+static struct file_operations debugfs_kprobes_operations = {
+	.open           = kprobes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static void __kprobes enable_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* If kprobes are already enabled, just return */
+	if (kprobe_enabled)
+		goto already_enabled;
+
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			arch_arm_kprobe(p);
+	}
+
+	kprobe_enabled = true;
+	printk(KERN_INFO "Kprobes globally enabled\n");
+
+already_enabled:
+	mutex_unlock(&kprobe_mutex);
+	return;
+}
+
+static void __kprobes disable_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* If kprobes are already disabled, just return */
+	if (!kprobe_enabled)
+		goto already_disabled;
+
+	kprobe_enabled = false;
+	printk(KERN_INFO "Kprobes globally disabled\n");
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist) {
+			if (!arch_trampoline_kprobe(p))
+				arch_disarm_kprobe(p);
+		}
+	}
+
+	mutex_unlock(&kprobe_mutex);
+	/* Allow all currently running kprobes to complete */
+	synchronize_sched();
+	return;
+
+already_disabled:
+	mutex_unlock(&kprobe_mutex);
+	return;
+}
+
+/*
+ * XXX: The debugfs bool file interface doesn't allow for callbacks
+ * when the bool state is switched. We can reuse that facility when
+ * available
+ */
+static ssize_t read_enabled_file_bool(struct file *file,
+	       char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (kprobe_enabled)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_enabled_file_bool(struct file *file,
+	       const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		enable_all_kprobes();
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		disable_all_kprobes();
+		break;
+	}
+
+	return count;
+}
+
+static struct file_operations fops_kp = {
+	.read =         read_enabled_file_bool,
+	.write =        write_enabled_file_bool,
+};
+
+static int __kprobes debugfs_kprobe_init(void)
+{
+	struct dentry *dir, *file;
+	unsigned int value = 1;
+
+	dir = debugfs_create_dir("kprobes", NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	file = debugfs_create_file("list", 0444, dir, NULL,
+				&debugfs_kprobes_operations);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
+	file = debugfs_create_file("enabled", 0600, dir,
+					&value, &fops_kp);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+late_initcall(debugfs_kprobe_init);
+#endif /* CONFIG_DEBUG_FS */
+
+module_init(init_kprobes);
+
+EXPORT_SYMBOL_GPL(register_kprobe);
+EXPORT_SYMBOL_GPL(unregister_kprobe);
+EXPORT_SYMBOL_GPL(register_jprobe);
+EXPORT_SYMBOL_GPL(unregister_jprobe);
+#ifdef CONFIG_KPROBES
+EXPORT_SYMBOL_GPL(jprobe_return);
+#endif
+
+#ifdef CONFIG_KPROBES
+EXPORT_SYMBOL_GPL(register_kretprobe);
+EXPORT_SYMBOL_GPL(unregister_kretprobe);
+#endif
Index: linux-2.6-lttng.stable/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.stable.orig/kernel/kprobes.c	2007-10-29 09:51:06.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,1063 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *  kernel/kprobes.c
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- *
- * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
- *		Probes initial implementation (includes suggestions from
- *		Rusty Russell).
- * 2004-Aug	Updated by Prasanna S Panchamukhi <prasanna@in.ibm.com> with
- *		hlists and exceptions notifier as suggested by Andi Kleen.
- * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
- *		interface to access function arguments.
- * 2004-Sep	Prasanna S Panchamukhi <prasanna@in.ibm.com> Changed Kprobes
- *		exceptions notifier to be first on the priority list.
- * 2005-May	Hien Nguyen <hien@us.ibm.com>, Jim Keniston
- *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
- *		<prasanna@in.ibm.com> added function-return probes.
- */
-#include <linux/kprobes.h>
-#include <linux/hash.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/stddef.h>
-#include <linux/module.h>
-#include <linux/moduleloader.h>
-#include <linux/kallsyms.h>
-#include <linux/freezer.h>
-#include <linux/seq_file.h>
-#include <linux/debugfs.h>
-#include <linux/kdebug.h>
-
-#include <asm-generic/sections.h>
-#include <asm/cacheflush.h>
-#include <asm/errno.h>
-#include <asm/uaccess.h>
-
-#define KPROBE_HASH_BITS 6
-#define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
-
-
-/*
- * Some oddball architectures like 64bit powerpc have function descriptors
- * so this must be overridable.
- */
-#ifndef kprobe_lookup_name
-#define kprobe_lookup_name(name, addr) \
-	addr = ((kprobe_opcode_t *)(kallsyms_lookup_name(name)))
-#endif
-
-static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
-static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
-
-/* NOTE: change this value only with kprobe_mutex held */
-static bool kprobe_enabled;
-
-DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
-DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
-static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
-
-#ifdef __ARCH_WANT_KPROBES_INSN_SLOT
-/*
- * kprobe->ainsn.insn points to the copy of the instruction to be
- * single-stepped. x86_64, POWER4 and above have no-exec support and
- * stepping on the instruction on a vmalloced/kmalloced/data page
- * is a recipe for disaster
- */
-#define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
-
-struct kprobe_insn_page {
-	struct hlist_node hlist;
-	kprobe_opcode_t *insns;		/* Page of instruction slots */
-	char slot_used[INSNS_PER_PAGE];
-	int nused;
-	int ngarbage;
-};
-
-enum kprobe_slot_state {
-	SLOT_CLEAN = 0,
-	SLOT_DIRTY = 1,
-	SLOT_USED = 2,
-};
-
-static struct hlist_head kprobe_insn_pages;
-static int kprobe_garbage_slots;
-static int collect_garbage_slots(void);
-
-static int __kprobes check_safety(void)
-{
-	int ret = 0;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
-	ret = freeze_processes();
-	if (ret == 0) {
-		struct task_struct *p, *q;
-		do_each_thread(p, q) {
-			if (p != current && p->state == TASK_RUNNING &&
-			    p->pid != 0) {
-				printk("Check failed: %s is running\n",p->comm);
-				ret = -1;
-				goto loop_end;
-			}
-		} while_each_thread(p, q);
-	}
-loop_end:
-	thaw_processes();
-#else
-	synchronize_sched();
-#endif
-	return ret;
-}
-
-/**
- * get_insn_slot() - Find a slot on an executable page for an instruction.
- * We allocate an executable page if there's no room on existing ones.
- */
-kprobe_opcode_t __kprobes *get_insn_slot(void)
-{
-	struct kprobe_insn_page *kip;
-	struct hlist_node *pos;
-
- retry:
-	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
-		if (kip->nused < INSNS_PER_PAGE) {
-			int i;
-			for (i = 0; i < INSNS_PER_PAGE; i++) {
-				if (kip->slot_used[i] == SLOT_CLEAN) {
-					kip->slot_used[i] = SLOT_USED;
-					kip->nused++;
-					return kip->insns + (i * MAX_INSN_SIZE);
-				}
-			}
-			/* Surprise!  No unused slots.  Fix kip->nused. */
-			kip->nused = INSNS_PER_PAGE;
-		}
-	}
-
-	/* If there are any garbage slots, collect it and try again. */
-	if (kprobe_garbage_slots && collect_garbage_slots() == 0) {
-		goto retry;
-	}
-	/* All out of space.  Need to allocate a new page. Use slot 0. */
-	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
-	if (!kip)
-		return NULL;
-
-	/*
-	 * Use module_alloc so this page is within +/- 2GB of where the
-	 * kernel image and loaded module images reside. This is required
-	 * so x86_64 can correctly handle the %rip-relative fixups.
-	 */
-	kip->insns = module_alloc(PAGE_SIZE);
-	if (!kip->insns) {
-		kfree(kip);
-		return NULL;
-	}
-	INIT_HLIST_NODE(&kip->hlist);
-	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
-	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
-	kip->slot_used[0] = SLOT_USED;
-	kip->nused = 1;
-	kip->ngarbage = 0;
-	return kip->insns;
-}
-
-/* Return 1 if all garbages are collected, otherwise 0. */
-static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
-{
-	kip->slot_used[idx] = SLOT_CLEAN;
-	kip->nused--;
-	if (kip->nused == 0) {
-		/*
-		 * Page is no longer in use.  Free it unless
-		 * it's the last one.  We keep the last one
-		 * so as not to have to set it up again the
-		 * next time somebody inserts a probe.
-		 */
-		hlist_del(&kip->hlist);
-		if (hlist_empty(&kprobe_insn_pages)) {
-			INIT_HLIST_NODE(&kip->hlist);
-			hlist_add_head(&kip->hlist,
-				       &kprobe_insn_pages);
-		} else {
-			module_free(NULL, kip->insns);
-			kfree(kip);
-		}
-		return 1;
-	}
-	return 0;
-}
-
-static int __kprobes collect_garbage_slots(void)
-{
-	struct kprobe_insn_page *kip;
-	struct hlist_node *pos, *next;
-
-	/* Ensure no-one is preepmted on the garbages */
-	if (check_safety() != 0)
-		return -EAGAIN;
-
-	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
-		int i;
-		if (kip->ngarbage == 0)
-			continue;
-		kip->ngarbage = 0;	/* we will collect all garbages */
-		for (i = 0; i < INSNS_PER_PAGE; i++) {
-			if (kip->slot_used[i] == SLOT_DIRTY &&
-			    collect_one_slot(kip, i))
-				break;
-		}
-	}
-	kprobe_garbage_slots = 0;
-	return 0;
-}
-
-void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
-{
-	struct kprobe_insn_page *kip;
-	struct hlist_node *pos;
-
-	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
-		if (kip->insns <= slot &&
-		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
-			int i = (slot - kip->insns) / MAX_INSN_SIZE;
-			if (dirty) {
-				kip->slot_used[i] = SLOT_DIRTY;
-				kip->ngarbage++;
-			} else {
-				collect_one_slot(kip, i);
-			}
-			break;
-		}
-	}
-
-	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
-		collect_garbage_slots();
-}
-#endif
-
-/* We have preemption disabled.. so it is safe to use __ versions */
-static inline void set_kprobe_instance(struct kprobe *kp)
-{
-	__get_cpu_var(kprobe_instance) = kp;
-}
-
-static inline void reset_kprobe_instance(void)
-{
-	__get_cpu_var(kprobe_instance) = NULL;
-}
-
-/*
- * This routine is called either:
- * 	- under the kprobe_mutex - during kprobe_[un]register()
- * 				OR
- * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
- */
-struct kprobe __kprobes *get_kprobe(void *addr)
-{
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct kprobe *p;
-
-	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
-	hlist_for_each_entry_rcu(p, node, head, hlist) {
-		if (p->addr == addr)
-			return p;
-	}
-	return NULL;
-}
-
-/*
- * Aggregate handlers for multiple kprobes support - these handlers
- * take care of invoking the individual kprobe handlers on p->list
- */
-static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe *kp;
-
-	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->pre_handler) {
-			set_kprobe_instance(kp);
-			if (kp->pre_handler(kp, regs))
-				return 1;
-		}
-		reset_kprobe_instance();
-	}
-	return 0;
-}
-
-static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
-					unsigned long flags)
-{
-	struct kprobe *kp;
-
-	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->post_handler) {
-			set_kprobe_instance(kp);
-			kp->post_handler(kp, regs, flags);
-			reset_kprobe_instance();
-		}
-	}
-}
-
-static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
-					int trapnr)
-{
-	struct kprobe *cur = __get_cpu_var(kprobe_instance);
-
-	/*
-	 * if we faulted "during" the execution of a user specified
-	 * probe handler, invoke just that probe's fault handler
-	 */
-	if (cur && cur->fault_handler) {
-		if (cur->fault_handler(cur, regs, trapnr))
-			return 1;
-	}
-	return 0;
-}
-
-static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe *cur = __get_cpu_var(kprobe_instance);
-	int ret = 0;
-
-	if (cur && cur->break_handler) {
-		if (cur->break_handler(cur, regs))
-			ret = 1;
-	}
-	reset_kprobe_instance();
-	return ret;
-}
-
-/* Walks the list and increments nmissed count for multiprobe case */
-void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
-{
-	struct kprobe *kp;
-	if (p->pre_handler != aggr_pre_handler) {
-		p->nmissed++;
-	} else {
-		list_for_each_entry_rcu(kp, &p->list, list)
-			kp->nmissed++;
-	}
-	return;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
-				struct hlist_head *head)
-{
-	/* remove rp inst off the rprobe_inst_table */
-	hlist_del(&ri->hlist);
-	if (ri->rp) {
-		/* remove rp inst off the used list */
-		hlist_del(&ri->uflist);
-		/* put rp inst back onto the free list */
-		INIT_HLIST_NODE(&ri->uflist);
-		hlist_add_head(&ri->uflist, &ri->rp->free_instances);
-	} else
-		/* Unregistering */
-		hlist_add_head(&ri->hlist, head);
-}
-
-struct hlist_head __kprobes *kretprobe_inst_table_head(struct task_struct *tsk)
-{
-	return &kretprobe_inst_table[hash_ptr(tsk, KPROBE_HASH_BITS)];
-}
-
-/*
- * This function is called from finish_task_switch when task tk becomes dead,
- * so that we can recycle any function-return probe instances associated
- * with this task. These left over instances represent probed functions
- * that have been called but will never return.
- */
-void __kprobes kprobe_flush_task(struct task_struct *tk)
-{
-	struct kretprobe_instance *ri;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags = 0;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(tk);
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task == tk)
-			recycle_rp_inst(ri, &empty_rp);
-	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-}
-
-static inline void free_rp_inst(struct kretprobe *rp)
-{
-	struct kretprobe_instance *ri;
-	struct hlist_node *pos, *next;
-
-	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
-		hlist_del(&ri->uflist);
-		kfree(ri);
-	}
-}
-
-/*
- * Keep all fields in the kprobe consistent
- */
-static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
-{
-	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
-	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
-}
-
-/*
-* Add the new probe to old_p->list. Fail if this is the
-* second jprobe at the address - two jprobes can't coexist
-*/
-static int __kprobes add_new_kprobe(struct kprobe *old_p, struct kprobe *p)
-{
-	if (p->break_handler) {
-		if (old_p->break_handler)
-			return -EEXIST;
-		list_add_tail_rcu(&p->list, &old_p->list);
-		old_p->break_handler = aggr_break_handler;
-	} else
-		list_add_rcu(&p->list, &old_p->list);
-	if (p->post_handler && !old_p->post_handler)
-		old_p->post_handler = aggr_post_handler;
-	return 0;
-}
-
-/*
- * Fill in the required fields of the "manager kprobe". Replace the
- * earlier kprobe in the hlist with the manager kprobe
- */
-static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
-{
-	copy_kprobe(p, ap);
-	flush_insn_slot(ap);
-	ap->addr = p->addr;
-	ap->pre_handler = aggr_pre_handler;
-	ap->fault_handler = aggr_fault_handler;
-	if (p->post_handler)
-		ap->post_handler = aggr_post_handler;
-	if (p->break_handler)
-		ap->break_handler = aggr_break_handler;
-
-	INIT_LIST_HEAD(&ap->list);
-	list_add_rcu(&p->list, &ap->list);
-
-	hlist_replace_rcu(&p->hlist, &ap->hlist);
-}
-
-/*
- * This is the second or subsequent kprobe at the address - handle
- * the intricacies
- */
-static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
-					  struct kprobe *p)
-{
-	int ret = 0;
-	struct kprobe *ap;
-
-	if (old_p->pre_handler == aggr_pre_handler) {
-		copy_kprobe(old_p, p);
-		ret = add_new_kprobe(old_p, p);
-	} else {
-		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
-		if (!ap)
-			return -ENOMEM;
-		add_aggr_kprobe(ap, old_p);
-		copy_kprobe(ap, p);
-		ret = add_new_kprobe(ap, p);
-	}
-	return ret;
-}
-
-static int __kprobes in_kprobes_functions(unsigned long addr)
-{
-	if (addr >= (unsigned long)__kprobes_text_start &&
-	    addr < (unsigned long)__kprobes_text_end)
-		return -EINVAL;
-	return 0;
-}
-
-static int __kprobes __register_kprobe(struct kprobe *p,
-	unsigned long called_from)
-{
-	int ret = 0;
-	struct kprobe *old_p;
-	struct module *probed_mod;
-
-	/*
-	 * If we have a symbol_name argument look it up,
-	 * and add it to the address.  That way the addr
-	 * field can either be global or relative to a symbol.
-	 */
-	if (p->symbol_name) {
-		if (p->addr)
-			return -EINVAL;
-		kprobe_lookup_name(p->symbol_name, p->addr);
-	}
-
-	if (!p->addr)
-		return -EINVAL;
-	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
-
-	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr))
-		return -EINVAL;
-
-	p->mod_refcounted = 0;
-
-	/*
-	 * Check if are we probing a module.
-	 */
-	probed_mod = module_text_address((unsigned long) p->addr);
-	if (probed_mod) {
-		struct module *calling_mod = module_text_address(called_from);
-		/*
-		 * We must allow modules to probe themself and in this case
-		 * avoid incrementing the module refcount, so as to allow
-		 * unloading of self probing modules.
-		 */
-		if (calling_mod && calling_mod != probed_mod) {
-			if (unlikely(!try_module_get(probed_mod)))
-				return -EINVAL;
-			p->mod_refcounted = 1;
-		} else
-			probed_mod = NULL;
-	}
-
-	p->nmissed = 0;
-	mutex_lock(&kprobe_mutex);
-	old_p = get_kprobe(p->addr);
-	if (old_p) {
-		ret = register_aggr_kprobe(old_p, p);
-		goto out;
-	}
-
-	ret = arch_prepare_kprobe(p);
-	if (ret)
-		goto out;
-
-	INIT_HLIST_NODE(&p->hlist);
-	hlist_add_head_rcu(&p->hlist,
-		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
-
-	if (kprobe_enabled)
-		arch_arm_kprobe(p);
-
-out:
-	mutex_unlock(&kprobe_mutex);
-
-	if (ret && probed_mod)
-		module_put(probed_mod);
-	return ret;
-}
-
-int __kprobes register_kprobe(struct kprobe *p)
-{
-	return __register_kprobe(p, (unsigned long)__builtin_return_address(0));
-}
-
-void __kprobes unregister_kprobe(struct kprobe *p)
-{
-	struct module *mod;
-	struct kprobe *old_p, *list_p;
-	int cleanup_p;
-
-	mutex_lock(&kprobe_mutex);
-	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p)) {
-		mutex_unlock(&kprobe_mutex);
-		return;
-	}
-	if (p != old_p) {
-		list_for_each_entry_rcu(list_p, &old_p->list, list)
-			if (list_p == p)
-			/* kprobe p is a valid probe */
-				goto valid_p;
-		mutex_unlock(&kprobe_mutex);
-		return;
-	}
-valid_p:
-	if (old_p == p ||
-	    (old_p->pre_handler == aggr_pre_handler &&
-	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
-		/*
-		 * Only probe on the hash list. Disarm only if kprobes are
-		 * enabled - otherwise, the breakpoint would already have
-		 * been removed. We save on flushing icache.
-		 */
-		if (kprobe_enabled)
-			arch_disarm_kprobe(p);
-		hlist_del_rcu(&old_p->hlist);
-		cleanup_p = 1;
-	} else {
-		list_del_rcu(&p->list);
-		cleanup_p = 0;
-	}
-
-	mutex_unlock(&kprobe_mutex);
-
-	synchronize_sched();
-	if (p->mod_refcounted) {
-		mod = module_text_address((unsigned long)p->addr);
-		if (mod)
-			module_put(mod);
-	}
-
-	if (cleanup_p) {
-		if (p != old_p) {
-			list_del_rcu(&p->list);
-			kfree(old_p);
-		}
-		arch_remove_kprobe(p);
-	} else {
-		mutex_lock(&kprobe_mutex);
-		if (p->break_handler)
-			old_p->break_handler = NULL;
-		if (p->post_handler){
-			list_for_each_entry_rcu(list_p, &old_p->list, list){
-				if (list_p->post_handler){
-					cleanup_p = 2;
-					break;
-				}
-			}
-			if (cleanup_p == 0)
-				old_p->post_handler = NULL;
-		}
-		mutex_unlock(&kprobe_mutex);
-	}
-}
-
-static struct notifier_block kprobe_exceptions_nb = {
-	.notifier_call = kprobe_exceptions_notify,
-	.priority = 0x7fffffff /* we need to be notified first */
-};
-
-unsigned long __weak arch_deref_entry_point(void *entry)
-{
-	return (unsigned long)entry;
-}
-
-int __kprobes register_jprobe(struct jprobe *jp)
-{
-	unsigned long addr = arch_deref_entry_point(jp->entry);
-
-	if (!kernel_text_address(addr))
-		return -EINVAL;
-
-	/* Todo: Verify probepoint is a function entry point */
-	jp->kp.pre_handler = setjmp_pre_handler;
-	jp->kp.break_handler = longjmp_break_handler;
-
-	return __register_kprobe(&jp->kp,
-		(unsigned long)__builtin_return_address(0));
-}
-
-void __kprobes unregister_jprobe(struct jprobe *jp)
-{
-	unregister_kprobe(&jp->kp);
-}
-
-#ifdef ARCH_SUPPORTS_KRETPROBES
-
-/*
- * This kprobe pre_handler is registered with every kretprobe. When probe
- * hits it will set up the return probe.
- */
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
-{
-	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
-	unsigned long flags = 0;
-
-	/*TODO: consider to only swap the RA after the last pre_handler fired */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	if (!hlist_empty(&rp->free_instances)) {
-		struct kretprobe_instance *ri;
-
-		ri = hlist_entry(rp->free_instances.first,
-				 struct kretprobe_instance, uflist);
-		ri->rp = rp;
-		ri->task = current;
-		arch_prepare_kretprobe(ri, regs);
-
-		/* XXX(hch): why is there no hlist_move_head? */
-		hlist_del(&ri->uflist);
-		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
-		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
-	} else
-		rp->nmissed++;
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	return 0;
-}
-
-int __kprobes register_kretprobe(struct kretprobe *rp)
-{
-	int ret = 0;
-	struct kretprobe_instance *inst;
-	int i;
-	void *addr = rp->kp.addr;
-
-	if (kretprobe_blacklist_size) {
-		if (addr == NULL)
-			kprobe_lookup_name(rp->kp.symbol_name, addr);
-		addr += rp->kp.offset;
-
-		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
-			if (kretprobe_blacklist[i].addr == addr)
-				return -EINVAL;
-		}
-	}
-
-	rp->kp.pre_handler = pre_handler_kretprobe;
-	rp->kp.post_handler = NULL;
-	rp->kp.fault_handler = NULL;
-	rp->kp.break_handler = NULL;
-
-	/* Pre-allocate memory for max kretprobe instances */
-	if (rp->maxactive <= 0) {
-#ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * NR_CPUS);
-#else
-		rp->maxactive = NR_CPUS;
-#endif
-	}
-	INIT_HLIST_HEAD(&rp->used_instances);
-	INIT_HLIST_HEAD(&rp->free_instances);
-	for (i = 0; i < rp->maxactive; i++) {
-		inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
-		if (inst == NULL) {
-			free_rp_inst(rp);
-			return -ENOMEM;
-		}
-		INIT_HLIST_NODE(&inst->uflist);
-		hlist_add_head(&inst->uflist, &rp->free_instances);
-	}
-
-	rp->nmissed = 0;
-	/* Establish function entry probe point */
-	if ((ret = __register_kprobe(&rp->kp,
-		(unsigned long)__builtin_return_address(0))) != 0)
-		free_rp_inst(rp);
-	return ret;
-}
-
-#else /* ARCH_SUPPORTS_KRETPROBES */
-
-int __kprobes register_kretprobe(struct kretprobe *rp)
-{
-	return -ENOSYS;
-}
-
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
-{
-	return 0;
-}
-
-#endif /* ARCH_SUPPORTS_KRETPROBES */
-
-void __kprobes unregister_kretprobe(struct kretprobe *rp)
-{
-	unsigned long flags;
-	struct kretprobe_instance *ri;
-	struct hlist_node *pos, *next;
-
-	unregister_kprobe(&rp->kp);
-
-	/* No race here */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
-		ri->rp = NULL;
-		hlist_del(&ri->uflist);
-	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	free_rp_inst(rp);
-}
-
-static int __init init_kprobes(void)
-{
-	int i, err = 0;
-
-	/* FIXME allocate the probe table, currently defined statically */
-	/* initialize all list heads */
-	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
-		INIT_HLIST_HEAD(&kprobe_table[i]);
-		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
-	}
-
-	if (kretprobe_blacklist_size) {
-		/* lookup the function address from its name */
-		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
-			kprobe_lookup_name(kretprobe_blacklist[i].name,
-					   kretprobe_blacklist[i].addr);
-			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
-				       kretprobe_blacklist[i].name);
-		}
-	}
-
-	/* By default, kprobes are enabled */
-	kprobe_enabled = true;
-
-	err = arch_init_kprobes();
-	if (!err)
-		err = register_die_notifier(&kprobe_exceptions_nb);
-
-	return err;
-}
-
-#ifdef CONFIG_DEBUG_FS
-static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
-		const char *sym, int offset,char *modname)
-{
-	char *kprobe_type;
-
-	if (p->pre_handler == pre_handler_kretprobe)
-		kprobe_type = "r";
-	else if (p->pre_handler == setjmp_pre_handler)
-		kprobe_type = "j";
-	else
-		kprobe_type = "k";
-	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
-			sym, offset, (modname ? modname : " "));
-	else
-		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
-}
-
-static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
-{
-	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
-}
-
-static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
-{
-	(*pos)++;
-	if (*pos >= KPROBE_TABLE_SIZE)
-		return NULL;
-	return pos;
-}
-
-static void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
-{
-	/* Nothing to do */
-}
-
-static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
-{
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct kprobe *p, *kp;
-	const char *sym = NULL;
-	unsigned int i = *(loff_t *) v;
-	unsigned long offset = 0;
-	char *modname, namebuf[128];
-
-	head = &kprobe_table[i];
-	preempt_disable();
-	hlist_for_each_entry_rcu(p, node, head, hlist) {
-		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
-					&offset, &modname, namebuf);
-		if (p->pre_handler == aggr_pre_handler) {
-			list_for_each_entry_rcu(kp, &p->list, list)
-				report_probe(pi, kp, sym, offset, modname);
-		} else
-			report_probe(pi, p, sym, offset, modname);
-	}
-	preempt_enable();
-	return 0;
-}
-
-static struct seq_operations kprobes_seq_ops = {
-	.start = kprobe_seq_start,
-	.next  = kprobe_seq_next,
-	.stop  = kprobe_seq_stop,
-	.show  = show_kprobe_addr
-};
-
-static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &kprobes_seq_ops);
-}
-
-static struct file_operations debugfs_kprobes_operations = {
-	.open           = kprobes_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
-
-static void __kprobes enable_all_kprobes(void)
-{
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct kprobe *p;
-	unsigned int i;
-
-	mutex_lock(&kprobe_mutex);
-
-	/* If kprobes are already enabled, just return */
-	if (kprobe_enabled)
-		goto already_enabled;
-
-	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
-		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist)
-			arch_arm_kprobe(p);
-	}
-
-	kprobe_enabled = true;
-	printk(KERN_INFO "Kprobes globally enabled\n");
-
-already_enabled:
-	mutex_unlock(&kprobe_mutex);
-	return;
-}
-
-static void __kprobes disable_all_kprobes(void)
-{
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct kprobe *p;
-	unsigned int i;
-
-	mutex_lock(&kprobe_mutex);
-
-	/* If kprobes are already disabled, just return */
-	if (!kprobe_enabled)
-		goto already_disabled;
-
-	kprobe_enabled = false;
-	printk(KERN_INFO "Kprobes globally disabled\n");
-	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
-		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist) {
-			if (!arch_trampoline_kprobe(p))
-				arch_disarm_kprobe(p);
-		}
-	}
-
-	mutex_unlock(&kprobe_mutex);
-	/* Allow all currently running kprobes to complete */
-	synchronize_sched();
-	return;
-
-already_disabled:
-	mutex_unlock(&kprobe_mutex);
-	return;
-}
-
-/*
- * XXX: The debugfs bool file interface doesn't allow for callbacks
- * when the bool state is switched. We can reuse that facility when
- * available
- */
-static ssize_t read_enabled_file_bool(struct file *file,
-	       char __user *user_buf, size_t count, loff_t *ppos)
-{
-	char buf[3];
-
-	if (kprobe_enabled)
-		buf[0] = '1';
-	else
-		buf[0] = '0';
-	buf[1] = '\n';
-	buf[2] = 0x00;
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static ssize_t write_enabled_file_bool(struct file *file,
-	       const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	char buf[32];
-	int buf_size;
-
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
-	switch (buf[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		enable_all_kprobes();
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		disable_all_kprobes();
-		break;
-	}
-
-	return count;
-}
-
-static struct file_operations fops_kp = {
-	.read =         read_enabled_file_bool,
-	.write =        write_enabled_file_bool,
-};
-
-static int __kprobes debugfs_kprobe_init(void)
-{
-	struct dentry *dir, *file;
-	unsigned int value = 1;
-
-	dir = debugfs_create_dir("kprobes", NULL);
-	if (!dir)
-		return -ENOMEM;
-
-	file = debugfs_create_file("list", 0444, dir, NULL,
-				&debugfs_kprobes_operations);
-	if (!file) {
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
-
-	file = debugfs_create_file("enabled", 0600, dir,
-					&value, &fops_kp);
-	if (!file) {
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-late_initcall(debugfs_kprobe_init);
-#endif /* CONFIG_DEBUG_FS */
-
-module_init(init_kprobes);
-
-EXPORT_SYMBOL_GPL(register_kprobe);
-EXPORT_SYMBOL_GPL(unregister_kprobe);
-EXPORT_SYMBOL_GPL(register_jprobe);
-EXPORT_SYMBOL_GPL(unregister_jprobe);
-#ifdef CONFIG_KPROBES
-EXPORT_SYMBOL_GPL(jprobe_return);
-#endif
-
-#ifdef CONFIG_KPROBES
-EXPORT_SYMBOL_GPL(register_kretprobe);
-EXPORT_SYMBOL_GPL(unregister_kretprobe);
-#endif
Index: linux-2.6-lttng.stable/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/instrumentation/Makefile	2007-10-29 09:51:12.000000000 -0400
+++ linux-2.6-lttng.stable/instrumentation/Makefile	2007-10-29 09:51:46.000000000 -0400
@@ -1,3 +1,5 @@
 #
 # Makefile for the linux kernel instrumentation
 #
+
+obj-$(CONFIG_KPROBES) += kprobes.o
Index: linux-2.6-lttng.stable/kernel/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/kernel/Makefile	2007-10-29 09:51:06.000000000 -0400
+++ linux-2.6-lttng.stable/kernel/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -47,7 +47,6 @@ obj-$(CONFIG_STOP_MACHINE) += stop_machi
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
-obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_SYSFS) += ksysfs.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
Index: linux-2.6-lttng.stable/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/Makefile	2007-10-29 09:51:22.000000000 -0400
+++ linux-2.6-lttng.stable/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -574,7 +574,8 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ \
+		     instrumentation/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
Index: linux-2.6-lttng.stable/arch/avr32/instrumentation/kprobes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/avr32/instrumentation/kprobes.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,268 @@
+/*
+ *  Kernel Probes (KProbes)
+ *
+ * Copyright (C) 2005-2006 Atmel Corporation
+ *
+ * Based on arch/ppc64/kernel/kprobes.c
+ *  Copyright (C) IBM Corporation, 2002, 2004
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+
+#include <asm/cacheflush.h>
+#include <linux/kdebug.h>
+#include <asm/ocd.h>
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe);
+static unsigned long kprobe_status;
+static struct pt_regs jprobe_saved_regs;
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	int ret = 0;
+
+	if ((unsigned long)p->addr & 0x01) {
+		printk("Attempt to register kprobe at an unaligned address\n");
+		ret = -EINVAL;
+	}
+
+	/* XXX: Might be a good idea to check if p->addr is a valid
+	 * kernel address as well... */
+
+	if (!ret) {
+		pr_debug("copy kprobe at %p\n", p->addr);
+		memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+		p->opcode = *p->addr;
+	}
+
+	return ret;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	pr_debug("arming kprobe at %p\n", p->addr);
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	pr_debug("disarming kprobe at %p\n", p->addr);
+	*p->addr = p->opcode;
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long dc;
+
+	pr_debug("preparing to singlestep over %p (PC=%08lx)\n",
+		 p->addr, regs->pc);
+
+	BUG_ON(!(sysreg_read(SR) & SYSREG_BIT(SR_D)));
+
+	dc = __mfdr(DBGREG_DC);
+	dc |= DC_SS;
+	__mtdr(DBGREG_DC, dc);
+
+	/*
+	 * We must run the instruction from its original location
+	 * since it may actually reference PC.
+	 *
+	 * TODO: Do the instruction replacement directly in icache.
+	 */
+	*p->addr = p->opcode;
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+}
+
+static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long dc;
+
+	pr_debug("resuming execution at PC=%08lx\n", regs->pc);
+
+	dc = __mfdr(DBGREG_DC);
+	dc &= ~DC_SS;
+	__mtdr(DBGREG_DC, dc);
+
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flush_icache_range((unsigned long)p->addr,
+			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p)
+{
+	__get_cpu_var(current_kprobe) = p;
+}
+
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	void *addr = (void *)regs->pc;
+	int ret = 0;
+
+	pr_debug("kprobe_handler: kprobe_running=%p\n",
+		 kprobe_running());
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+
+	/* Check that we're not recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kprobe_status == KPROBE_HIT_SS) {
+				printk("FIXME: kprobe hit while single-stepping!\n");
+				goto no_kprobe;
+			}
+
+			printk("FIXME: kprobe hit while handling another kprobe\n");
+			goto no_kprobe;
+		} else {
+			p = kprobe_running();
+			if (p->break_handler && p->break_handler(p, regs))
+				goto ss_probe;
+		}
+		/* If it's not ours, can't be delete race, (we hold lock). */
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p)
+		goto no_kprobe;
+
+	kprobe_status = KPROBE_HIT_ACTIVE;
+	set_current_kprobe(p);
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+
+ss_probe:
+	prepare_singlestep(p, regs);
+	kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+
+	pr_debug("post_kprobe_handler, cur=%p\n", cur);
+
+	if (!cur)
+		return 0;
+
+	if (cur->post_handler) {
+		kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs);
+	reset_current_kprobe();
+	preempt_enable_no_resched();
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+
+	pr_debug("kprobe_fault_handler: trapnr=%d\n", trapnr);
+
+	if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+		return 1;
+
+	if (kprobe_status & KPROBE_HIT_SS) {
+		resume_execution(cur, regs);
+		preempt_enable_no_resched();
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine to for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	pr_debug("kprobe_exceptions_notify: val=%lu, data=%p\n",
+		 val, data);
+
+	switch (val) {
+	case DIE_BREAKPOINT:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_SSTEP:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+
+	memcpy(&jprobe_saved_regs, regs, sizeof(struct pt_regs));
+
+	/*
+	 * TODO: We should probably save some of the stack here as
+	 * well, since gcc may pass arguments on the stack for certain
+	 * functions (lots of arguments, large aggregates, varargs)
+	 */
+
+	/* setup return addr to the jprobe handler routine */
+	regs->pc = (unsigned long)jp->entry;
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	asm volatile("breakpoint" ::: "memory");
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	/*
+	 * FIXME - we should ideally be validating that we got here 'cos
+	 * of the "trap" in jprobe_return() above, before restoring the
+	 * saved regs...
+	 */
+	memcpy(regs, &jprobe_saved_regs, sizeof(struct pt_regs));
+	return 1;
+}
+
+int __init arch_init_kprobes(void)
+{
+	printk("KPROBES: Enabling monitor mode (MM|DBE)...\n");
+	__mtdr(DBGREG_DC, DC_MM | DC_DBE);
+
+	/* TODO: Register kretprobe trampoline */
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/avr32/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/avr32/kernel/kprobes.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,268 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * Copyright (C) 2005-2006 Atmel Corporation
- *
- * Based on arch/ppc64/kernel/kprobes.c
- *  Copyright (C) IBM Corporation, 2002, 2004
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-
-#include <asm/cacheflush.h>
-#include <linux/kdebug.h>
-#include <asm/ocd.h>
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe);
-static unsigned long kprobe_status;
-static struct pt_regs jprobe_saved_regs;
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	int ret = 0;
-
-	if ((unsigned long)p->addr & 0x01) {
-		printk("Attempt to register kprobe at an unaligned address\n");
-		ret = -EINVAL;
-	}
-
-	/* XXX: Might be a good idea to check if p->addr is a valid
-	 * kernel address as well... */
-
-	if (!ret) {
-		pr_debug("copy kprobe at %p\n", p->addr);
-		memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-		p->opcode = *p->addr;
-	}
-
-	return ret;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	pr_debug("arming kprobe at %p\n", p->addr);
-	*p->addr = BREAKPOINT_INSTRUCTION;
-	flush_icache_range((unsigned long)p->addr,
-			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	pr_debug("disarming kprobe at %p\n", p->addr);
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long)p->addr,
-			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	unsigned long dc;
-
-	pr_debug("preparing to singlestep over %p (PC=%08lx)\n",
-		 p->addr, regs->pc);
-
-	BUG_ON(!(sysreg_read(SR) & SYSREG_BIT(SR_D)));
-
-	dc = __mfdr(DBGREG_DC);
-	dc |= DC_SS;
-	__mtdr(DBGREG_DC, dc);
-
-	/*
-	 * We must run the instruction from its original location
-	 * since it may actually reference PC.
-	 *
-	 * TODO: Do the instruction replacement directly in icache.
-	 */
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long)p->addr,
-			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
-}
-
-static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
-{
-	unsigned long dc;
-
-	pr_debug("resuming execution at PC=%08lx\n", regs->pc);
-
-	dc = __mfdr(DBGREG_DC);
-	dc &= ~DC_SS;
-	__mtdr(DBGREG_DC, dc);
-
-	*p->addr = BREAKPOINT_INSTRUCTION;
-	flush_icache_range((unsigned long)p->addr,
-			   (unsigned long)p->addr + sizeof(kprobe_opcode_t));
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p)
-{
-	__get_cpu_var(current_kprobe) = p;
-}
-
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	void *addr = (void *)regs->pc;
-	int ret = 0;
-
-	pr_debug("kprobe_handler: kprobe_running=%p\n",
-		 kprobe_running());
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-
-	/* Check that we're not recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kprobe_status == KPROBE_HIT_SS) {
-				printk("FIXME: kprobe hit while single-stepping!\n");
-				goto no_kprobe;
-			}
-
-			printk("FIXME: kprobe hit while handling another kprobe\n");
-			goto no_kprobe;
-		} else {
-			p = kprobe_running();
-			if (p->break_handler && p->break_handler(p, regs))
-				goto ss_probe;
-		}
-		/* If it's not ours, can't be delete race, (we hold lock). */
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p)
-		goto no_kprobe;
-
-	kprobe_status = KPROBE_HIT_ACTIVE;
-	set_current_kprobe(p);
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-	prepare_singlestep(p, regs);
-	kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-
-	pr_debug("post_kprobe_handler, cur=%p\n", cur);
-
-	if (!cur)
-		return 0;
-
-	if (cur->post_handler) {
-		kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs);
-	reset_current_kprobe();
-	preempt_enable_no_resched();
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-
-	pr_debug("kprobe_fault_handler: trapnr=%d\n", trapnr);
-
-	if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-		return 1;
-
-	if (kprobe_status & KPROBE_HIT_SS) {
-		resume_execution(cur, regs);
-		preempt_enable_no_resched();
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine to for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	pr_debug("kprobe_exceptions_notify: val=%lu, data=%p\n",
-		 val, data);
-
-	switch (val) {
-	case DIE_BREAKPOINT:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_SSTEP:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-
-	return ret;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-
-	memcpy(&jprobe_saved_regs, regs, sizeof(struct pt_regs));
-
-	/*
-	 * TODO: We should probably save some of the stack here as
-	 * well, since gcc may pass arguments on the stack for certain
-	 * functions (lots of arguments, large aggregates, varargs)
-	 */
-
-	/* setup return addr to the jprobe handler routine */
-	regs->pc = (unsigned long)jp->entry;
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	asm volatile("breakpoint" ::: "memory");
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	/*
-	 * FIXME - we should ideally be validating that we got here 'cos
-	 * of the "trap" in jprobe_return() above, before restoring the
-	 * saved regs...
-	 */
-	memcpy(regs, &jprobe_saved_regs, sizeof(struct pt_regs));
-	return 1;
-}
-
-int __init arch_init_kprobes(void)
-{
-	printk("KPROBES: Enabling monitor mode (MM|DBE)...\n");
-	__mtdr(DBGREG_DC, DC_MM | DC_DBE);
-
-	/* TODO: Register kretprobe trampoline */
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/ia64/instrumentation/kprobes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/ia64/instrumentation/kprobes.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,1027 @@
+/*
+ *  Kernel Probes (KProbes)
+ *  arch/ia64/kernel/kprobes.c
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
+ * Copyright (C) IBM Corporation, 2002, 2004
+ * Copyright (C) Intel Corporation, 2005
+ *
+ * 2005-Apr     Rusty Lynch <rusty.lynch@intel.com> and Anil S Keshavamurthy
+ *              <anil.s.keshavamurthy@intel.com> adapted from i386
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/preempt.h>
+#include <linux/moduleloader.h>
+#include <linux/kdebug.h>
+
+#include <asm/pgtable.h>
+#include <asm/sections.h>
+#include <asm/uaccess.h>
+
+extern void jprobe_inst_return(void);
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
+enum instruction_type {A, I, M, F, B, L, X, u};
+static enum instruction_type bundle_encoding[32][3] = {
+  { M, I, I },				/* 00 */
+  { M, I, I },				/* 01 */
+  { M, I, I },				/* 02 */
+  { M, I, I },				/* 03 */
+  { M, L, X },				/* 04 */
+  { M, L, X },				/* 05 */
+  { u, u, u },  			/* 06 */
+  { u, u, u },  			/* 07 */
+  { M, M, I },				/* 08 */
+  { M, M, I },				/* 09 */
+  { M, M, I },				/* 0A */
+  { M, M, I },				/* 0B */
+  { M, F, I },				/* 0C */
+  { M, F, I },				/* 0D */
+  { M, M, F },				/* 0E */
+  { M, M, F },				/* 0F */
+  { M, I, B },				/* 10 */
+  { M, I, B },				/* 11 */
+  { M, B, B },				/* 12 */
+  { M, B, B },				/* 13 */
+  { u, u, u },  			/* 14 */
+  { u, u, u },  			/* 15 */
+  { B, B, B },				/* 16 */
+  { B, B, B },				/* 17 */
+  { M, M, B },				/* 18 */
+  { M, M, B },				/* 19 */
+  { u, u, u },  			/* 1A */
+  { u, u, u },  			/* 1B */
+  { M, F, B },				/* 1C */
+  { M, F, B },				/* 1D */
+  { u, u, u },  			/* 1E */
+  { u, u, u },  			/* 1F */
+};
+
+/*
+ * In this function we check to see if the instruction
+ * is IP relative instruction and update the kprobe
+ * inst flag accordingly
+ */
+static void __kprobes update_kprobe_inst_flag(uint template, uint  slot,
+					      uint major_opcode,
+					      unsigned long kprobe_inst,
+					      struct kprobe *p)
+{
+	p->ainsn.inst_flag = 0;
+	p->ainsn.target_br_reg = 0;
+	p->ainsn.slot = slot;
+
+	/* Check for Break instruction
+	 * Bits 37:40 Major opcode to be zero
+	 * Bits 27:32 X6 to be zero
+	 * Bits 32:35 X3 to be zero
+	 */
+	if ((!major_opcode) && (!((kprobe_inst >> 27) & 0x1FF)) ) {
+		/* is a break instruction */
+	 	p->ainsn.inst_flag |= INST_FLAG_BREAK_INST;
+		return;
+	}
+
+	if (bundle_encoding[template][slot] == B) {
+		switch (major_opcode) {
+		  case INDIRECT_CALL_OPCODE:
+	 		p->ainsn.inst_flag |= INST_FLAG_FIX_BRANCH_REG;
+			p->ainsn.target_br_reg = ((kprobe_inst >> 6) & 0x7);
+			break;
+		  case IP_RELATIVE_PREDICT_OPCODE:
+		  case IP_RELATIVE_BRANCH_OPCODE:
+			p->ainsn.inst_flag |= INST_FLAG_FIX_RELATIVE_IP_ADDR;
+			break;
+		  case IP_RELATIVE_CALL_OPCODE:
+			p->ainsn.inst_flag |= INST_FLAG_FIX_RELATIVE_IP_ADDR;
+			p->ainsn.inst_flag |= INST_FLAG_FIX_BRANCH_REG;
+			p->ainsn.target_br_reg = ((kprobe_inst >> 6) & 0x7);
+			break;
+		}
+	} else if (bundle_encoding[template][slot] == X) {
+		switch (major_opcode) {
+		  case LONG_CALL_OPCODE:
+			p->ainsn.inst_flag |= INST_FLAG_FIX_BRANCH_REG;
+			p->ainsn.target_br_reg = ((kprobe_inst >> 6) & 0x7);
+		  break;
+		}
+	}
+	return;
+}
+
+/*
+ * In this function we check to see if the instruction
+ * (qp) cmpx.crel.ctype p1,p2=r2,r3
+ * on which we are inserting kprobe is cmp instruction
+ * with ctype as unc.
+ */
+static uint __kprobes is_cmp_ctype_unc_inst(uint template, uint slot,
+					    uint major_opcode,
+					    unsigned long kprobe_inst)
+{
+	cmp_inst_t cmp_inst;
+	uint ctype_unc = 0;
+
+	if (!((bundle_encoding[template][slot] == I) ||
+		(bundle_encoding[template][slot] == M)))
+		goto out;
+
+	if (!((major_opcode == 0xC) || (major_opcode == 0xD) ||
+		(major_opcode == 0xE)))
+		goto out;
+
+	cmp_inst.l = kprobe_inst;
+	if ((cmp_inst.f.x2 == 0) || (cmp_inst.f.x2 == 1)) {
+		/* Integer compare - Register Register (A6 type)*/
+		if ((cmp_inst.f.tb == 0) && (cmp_inst.f.ta == 0)
+				&&(cmp_inst.f.c == 1))
+			ctype_unc = 1;
+	} else if ((cmp_inst.f.x2 == 2)||(cmp_inst.f.x2 == 3)) {
+		/* Integer compare - Immediate Register (A8 type)*/
+		if ((cmp_inst.f.ta == 0) &&(cmp_inst.f.c == 1))
+			ctype_unc = 1;
+	}
+out:
+	return ctype_unc;
+}
+
+/*
+ * In this function we check to see if the instruction
+ * on which we are inserting kprobe is supported.
+ * Returns qp value if supported
+ * Returns -EINVAL if unsupported
+ */
+static int __kprobes unsupported_inst(uint template, uint  slot,
+				      uint major_opcode,
+				      unsigned long kprobe_inst,
+				      unsigned long addr)
+{
+	int qp;
+
+	qp = kprobe_inst & 0x3f;
+	if (is_cmp_ctype_unc_inst(template, slot, major_opcode, kprobe_inst)) {
+		if (slot == 1 && qp)  {
+			printk(KERN_WARNING "Kprobes on cmp unc"
+					"instruction on slot 1 at <0x%lx>"
+					"is not supported\n", addr);
+			return -EINVAL;
+
+		}
+		qp = 0;
+	}
+	else if (bundle_encoding[template][slot] == I) {
+		if (major_opcode == 0) {
+			/*
+			 * Check for Integer speculation instruction
+			 * - Bit 33-35 to be equal to 0x1
+			 */
+			if (((kprobe_inst >> 33) & 0x7) == 1) {
+				printk(KERN_WARNING
+					"Kprobes on speculation inst at <0x%lx> not supported\n",
+						addr);
+				return -EINVAL;
+			}
+			/*
+			 * IP relative mov instruction
+			 *  - Bit 27-35 to be equal to 0x30
+			 */
+			if (((kprobe_inst >> 27) & 0x1FF) == 0x30) {
+				printk(KERN_WARNING
+					"Kprobes on \"mov r1=ip\" at <0x%lx> not supported\n",
+						addr);
+				return -EINVAL;
+
+			}
+		}
+		else if ((major_opcode == 5) &&	!(kprobe_inst & (0xFUl << 33)) &&
+				(kprobe_inst & (0x1UL << 12))) {
+			/* test bit instructions, tbit,tnat,tf
+			 * bit 33-36 to be equal to 0
+			 * bit 12 to be equal to 1
+			 */
+			if (slot == 1 && qp) {
+				printk(KERN_WARNING "Kprobes on test bit"
+						"instruction on slot at <0x%lx>"
+						"is not supported\n", addr);
+				return -EINVAL;
+			}
+			qp = 0;
+		}
+	}
+	else if (bundle_encoding[template][slot] == B) {
+		if (major_opcode == 7) {
+			/* IP-Relative Predict major code is 7 */
+			printk(KERN_WARNING "Kprobes on IP-Relative"
+					"Predict is not supported\n");
+			return -EINVAL;
+		}
+		else if (major_opcode == 2) {
+			/* Indirect Predict, major code is 2
+			 * bit 27-32 to be equal to 10 or 11
+			 */
+			int x6=(kprobe_inst >> 27) & 0x3F;
+			if ((x6 == 0x10) || (x6 == 0x11)) {
+				printk(KERN_WARNING "Kprobes on"
+					"Indirect Predict is not supported\n");
+				return -EINVAL;
+			}
+		}
+	}
+	/* kernel does not use float instruction, here for safety kprobe
+	 * will judge whether it is fcmp/flass/float approximation instruction
+	 */
+	else if (unlikely(bundle_encoding[template][slot] == F)) {
+		if ((major_opcode == 4 || major_opcode == 5) &&
+				(kprobe_inst  & (0x1 << 12))) {
+			/* fcmp/fclass unc instruction */
+			if (slot == 1 && qp) {
+				printk(KERN_WARNING "Kprobes on fcmp/fclass "
+					"instruction on slot at <0x%lx> "
+					"is not supported\n", addr);
+				return -EINVAL;
+
+			}
+			qp = 0;
+		}
+		if ((major_opcode == 0 || major_opcode == 1) &&
+			(kprobe_inst & (0x1UL << 33))) {
+			/* float Approximation instruction */
+			if (slot == 1 && qp) {
+				printk(KERN_WARNING "Kprobes on float Approx "
+					"instr at <0x%lx> is not supported\n",
+						addr);
+				return -EINVAL;
+			}
+			qp = 0;
+		}
+	}
+	return qp;
+}
+
+/*
+ * In this function we override the bundle with
+ * the break instruction at the given slot.
+ */
+static void __kprobes prepare_break_inst(uint template, uint  slot,
+					 uint major_opcode,
+					 unsigned long kprobe_inst,
+					 struct kprobe *p,
+					 int qp)
+{
+	unsigned long break_inst = BREAK_INST;
+	bundle_t *bundle = &p->opcode.bundle;
+
+	/*
+	 * Copy the original kprobe_inst qualifying predicate(qp)
+	 * to the break instruction
+	 */
+	break_inst |= qp;
+
+	switch (slot) {
+	  case 0:
+		bundle->quad0.slot0 = break_inst;
+		break;
+	  case 1:
+		bundle->quad0.slot1_p0 = break_inst;
+		bundle->quad1.slot1_p1 = break_inst >> (64-46);
+		break;
+	  case 2:
+		bundle->quad1.slot2 = break_inst;
+		break;
+	}
+
+	/*
+	 * Update the instruction flag, so that we can
+	 * emulate the instruction properly after we
+	 * single step on original instruction
+	 */
+	update_kprobe_inst_flag(template, slot, major_opcode, kprobe_inst, p);
+}
+
+static void __kprobes get_kprobe_inst(bundle_t *bundle, uint slot,
+	       	unsigned long *kprobe_inst, uint *major_opcode)
+{
+	unsigned long kprobe_inst_p0, kprobe_inst_p1;
+	unsigned int template;
+
+	template = bundle->quad0.template;
+
+	switch (slot) {
+	  case 0:
+		*major_opcode = (bundle->quad0.slot0 >> SLOT0_OPCODE_SHIFT);
+		*kprobe_inst = bundle->quad0.slot0;
+		  break;
+	  case 1:
+		*major_opcode = (bundle->quad1.slot1_p1 >> SLOT1_p1_OPCODE_SHIFT);
+		kprobe_inst_p0 = bundle->quad0.slot1_p0;
+		kprobe_inst_p1 = bundle->quad1.slot1_p1;
+		*kprobe_inst = kprobe_inst_p0 | (kprobe_inst_p1 << (64-46));
+		break;
+	  case 2:
+		*major_opcode = (bundle->quad1.slot2 >> SLOT2_OPCODE_SHIFT);
+		*kprobe_inst = bundle->quad1.slot2;
+		break;
+	}
+}
+
+/* Returns non-zero if the addr is in the Interrupt Vector Table */
+static int __kprobes in_ivt_functions(unsigned long addr)
+{
+	return (addr >= (unsigned long)__start_ivt_text
+		&& addr < (unsigned long)__end_ivt_text);
+}
+
+static int __kprobes valid_kprobe_addr(int template, int slot,
+				       unsigned long addr)
+{
+	if ((slot > 2) || ((bundle_encoding[template][1] == L) && slot > 1)) {
+		printk(KERN_WARNING "Attempting to insert unaligned kprobe "
+				"at 0x%lx\n", addr);
+		return -EINVAL;
+	}
+
+	if (in_ivt_functions(addr)) {
+		printk(KERN_WARNING "Kprobes can't be inserted inside "
+				"IVT functions at 0x%lx\n", addr);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	unsigned int i;
+	i = atomic_add_return(1, &kcb->prev_kprobe_index);
+	kcb->prev_kprobe[i-1].kp = kprobe_running();
+	kcb->prev_kprobe[i-1].status = kcb->kprobe_status;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	unsigned int i;
+	i = atomic_sub_return(1, &kcb->prev_kprobe_index);
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i].kp;
+	kcb->kprobe_status = kcb->prev_kprobe[i].status;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p,
+			struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+}
+
+static void kretprobe_trampoline(void)
+{
+}
+
+/*
+ * At this point the target function has been tricked into
+ * returning into our trampoline.  Lookup the associated instance
+ * and then:
+ *    - call the handler function
+ *    - cleanup by marking the instance as unused
+ *    - long jump back to the original return address
+ */
+int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =
+		((struct fnptr *)kretprobe_trampoline)->ip;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(current);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more then one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
+	regs->cr_iip = orig_ret_address;
+
+	reset_current_kprobe();
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
+
+	/* Replace the return addr with trampoline addr */
+	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	unsigned long addr = (unsigned long) p->addr;
+	unsigned long *kprobe_addr = (unsigned long *)(addr & ~0xFULL);
+	unsigned long kprobe_inst=0;
+	unsigned int slot = addr & 0xf, template, major_opcode = 0;
+	bundle_t *bundle;
+	int qp;
+
+	bundle = &((kprobe_opcode_t *)kprobe_addr)->bundle;
+	template = bundle->quad0.template;
+
+	if(valid_kprobe_addr(template, slot, addr))
+		return -EINVAL;
+
+	/* Move to slot 2, if bundle is MLX type and kprobe slot is 1 */
+	if (slot == 1 && bundle_encoding[template][1] == L)
+		slot++;
+
+	/* Get kprobe_inst and major_opcode from the bundle */
+	get_kprobe_inst(bundle, slot, &kprobe_inst, &major_opcode);
+
+	qp = unsupported_inst(template, slot, major_opcode, kprobe_inst, addr);
+	if (qp < 0)
+		return -EINVAL;
+
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn)
+		return -ENOMEM;
+	memcpy(&p->opcode, kprobe_addr, sizeof(kprobe_opcode_t));
+	memcpy(p->ainsn.insn, kprobe_addr, sizeof(kprobe_opcode_t));
+
+	prepare_break_inst(template, slot, major_opcode, kprobe_inst, p, qp);
+
+	return 0;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	unsigned long arm_addr;
+	bundle_t *src, *dest;
+
+	arm_addr = ((unsigned long)p->addr) & ~0xFUL;
+	dest = &((kprobe_opcode_t *)arm_addr)->bundle;
+	src = &p->opcode.bundle;
+
+	flush_icache_range((unsigned long)p->ainsn.insn,
+			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
+	switch (p->ainsn.slot) {
+		case 0:
+			dest->quad0.slot0 = src->quad0.slot0;
+			break;
+		case 1:
+			dest->quad1.slot1_p1 = src->quad1.slot1_p1;
+			break;
+		case 2:
+			dest->quad1.slot2 = src->quad1.slot2;
+			break;
+	}
+	flush_icache_range(arm_addr, arm_addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	unsigned long arm_addr;
+	bundle_t *src, *dest;
+
+	arm_addr = ((unsigned long)p->addr) & ~0xFUL;
+	dest = &((kprobe_opcode_t *)arm_addr)->bundle;
+	/* p->ainsn.insn contains the original unaltered kprobe_opcode_t */
+	src = &p->ainsn.insn->bundle;
+	switch (p->ainsn.slot) {
+		case 0:
+			dest->quad0.slot0 = src->quad0.slot0;
+			break;
+		case 1:
+			dest->quad1.slot1_p1 = src->quad1.slot1_p1;
+			break;
+		case 2:
+			dest->quad1.slot2 = src->quad1.slot2;
+			break;
+	}
+	flush_icache_range(arm_addr, arm_addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	mutex_lock(&kprobe_mutex);
+	free_insn_slot(p->ainsn.insn, 0);
+	mutex_unlock(&kprobe_mutex);
+}
+/*
+ * We are resuming execution after a single step fault, so the pt_regs
+ * structure reflects the register state after we executed the instruction
+ * located in the kprobe (p->ainsn.insn.bundle).  We still need to adjust
+ * the ip to point back to the original stack address. To set the IP address
+ * to original stack address, handle the case where we need to fixup the
+ * relative IP address and/or fixup branch register.
+ */
+static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long bundle_addr = (unsigned long) (&p->ainsn.insn->bundle);
+	unsigned long resume_addr = (unsigned long)p->addr & ~0xFULL;
+	unsigned long template;
+	int slot = ((unsigned long)p->addr & 0xf);
+
+	template = p->ainsn.insn->bundle.quad0.template;
+
+	if (slot == 1 && bundle_encoding[template][1] == L)
+		slot = 2;
+
+	if (p->ainsn.inst_flag) {
+
+		if (p->ainsn.inst_flag & INST_FLAG_FIX_RELATIVE_IP_ADDR) {
+			/* Fix relative IP address */
+			regs->cr_iip = (regs->cr_iip - bundle_addr) +
+					resume_addr;
+		}
+
+		if (p->ainsn.inst_flag & INST_FLAG_FIX_BRANCH_REG) {
+		/*
+		 * Fix target branch register, software convention is
+		 * to use either b0 or b6 or b7, so just checking
+		 * only those registers
+		 */
+			switch (p->ainsn.target_br_reg) {
+			case 0:
+				if ((regs->b0 == bundle_addr) ||
+					(regs->b0 == bundle_addr + 0x10)) {
+					regs->b0 = (regs->b0 - bundle_addr) +
+						resume_addr;
+				}
+				break;
+			case 6:
+				if ((regs->b6 == bundle_addr) ||
+					(regs->b6 == bundle_addr + 0x10)) {
+					regs->b6 = (regs->b6 - bundle_addr) +
+						resume_addr;
+				}
+				break;
+			case 7:
+				if ((regs->b7 == bundle_addr) ||
+					(regs->b7 == bundle_addr + 0x10)) {
+					regs->b7 = (regs->b7 - bundle_addr) +
+						resume_addr;
+				}
+				break;
+			} /* end switch */
+		}
+		goto turn_ss_off;
+	}
+
+	if (slot == 2) {
+		if (regs->cr_iip == bundle_addr + 0x10) {
+			regs->cr_iip = resume_addr + 0x10;
+		}
+	} else {
+		if (regs->cr_iip == bundle_addr) {
+			regs->cr_iip = resume_addr;
+		}
+	}
+
+turn_ss_off:
+	/* Turn off Single Step bit */
+	ia64_psr(regs)->ss = 0;
+}
+
+static void __kprobes prepare_ss(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long bundle_addr = (unsigned long) &p->ainsn.insn->bundle;
+	unsigned long slot = (unsigned long)p->addr & 0xf;
+
+	/* single step inline if break instruction */
+	if (p->ainsn.inst_flag == INST_FLAG_BREAK_INST)
+		regs->cr_iip = (unsigned long)p->addr & ~0xFULL;
+	else
+		regs->cr_iip = bundle_addr & ~0xFULL;
+
+	if (slot > 2)
+		slot = 0;
+
+	ia64_psr(regs)->ri = slot;
+
+	/* turn on single stepping */
+	ia64_psr(regs)->ss = 1;
+}
+
+static int __kprobes is_ia64_break_inst(struct pt_regs *regs)
+{
+	unsigned int slot = ia64_psr(regs)->ri;
+	unsigned int template, major_opcode;
+	unsigned long kprobe_inst;
+	unsigned long *kprobe_addr = (unsigned long *)regs->cr_iip;
+	bundle_t bundle;
+
+	memcpy(&bundle, kprobe_addr, sizeof(bundle_t));
+	template = bundle.quad0.template;
+
+	/* Move to slot 2, if bundle is MLX type and kprobe slot is 1 */
+	if (slot == 1 && bundle_encoding[template][1] == L)
+		slot++;
+
+	/* Get Kprobe probe instruction at given slot*/
+	get_kprobe_inst(&bundle, slot, &kprobe_inst, &major_opcode);
+
+	/* For break instruction,
+	 * Bits 37:40 Major opcode to be zero
+	 * Bits 27:32 X6 to be zero
+	 * Bits 32:35 X3 to be zero
+	 */
+	if (major_opcode || ((kprobe_inst >> 27) & 0x1FF) ) {
+		/* Not a break instruction */
+		return 0;
+	}
+
+	/* Is a break instruction */
+	return 1;
+}
+
+static int __kprobes pre_kprobes_handler(struct die_args *args)
+{
+	struct kprobe *p;
+	int ret = 0;
+	struct pt_regs *regs = args->regs;
+	kprobe_opcode_t *addr = (kprobe_opcode_t *)instruction_pointer(regs);
+	struct kprobe_ctlblk *kcb;
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Handle recursion cases */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if ((kcb->kprobe_status == KPROBE_HIT_SS) &&
+	 		     (p->ainsn.inst_flag == INST_FLAG_BREAK_INST)) {
+				ia64_psr(regs)->ss = 0;
+				goto no_kprobe;
+			}
+			/* We have reentered the pre_kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_ss(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+		} else if (args->err == __IA64_BREAK_JPROBE) {
+			/*
+			 * jprobe instrumented function just completed
+			 */
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs)) {
+				goto ss_probe;
+			}
+		} else if (!is_ia64_break_inst(regs)) {
+			/* The breakpoint instruction was removed by
+			 * another cpu right after we hit, no further
+			 * handling of this interrupt is appropriate
+			 */
+			ret = 1;
+			goto no_kprobe;
+		} else {
+			/* Not our break */
+			goto no_kprobe;
+		}
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (!is_ia64_break_inst(regs)) {
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 */
+			ret = 1;
+
+		}
+
+		/* Not one of our break, let kernel handle it */
+		goto no_kprobe;
+	}
+
+	set_current_kprobe(p, kcb);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/*
+		 * Our pre-handler is specifically requesting that we just
+		 * do a return.  This is used for both the jprobe pre-handler
+		 * and the kretprobe trampoline
+		 */
+		return 1;
+
+ss_probe:
+	prepare_ss(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+static int __kprobes post_kprobes_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs);
+
+	/*Restore back the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+
+out:
+	preempt_enable_no_resched();
+	return 1;
+}
+
+int __kprobes kprobes_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the instruction pointer points back to
+		 * the probe address and allow the page fault handler
+		 * to continue as a normal page fault.
+		 */
+		regs->cr_iip = ((unsigned long)cur->addr) & ~0xFULL;
+		ia64_psr(regs)->ri = ((unsigned long)cur->addr) & 0xf;
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+		if (ia64_done_with_exception(regs))
+			return 1;
+
+		/*
+		 * Let ia64_do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	if (args->regs && user_mode(args->regs))
+		return ret;
+
+	switch(val) {
+	case DIE_BREAK:
+		/* err is break number from ia64_bad_break() */
+		if ((args->err >> 12) == (__IA64_BREAK_KPROBE >> 12)
+			|| args->err == __IA64_BREAK_JPROBE
+			|| args->err == 0)
+			if (pre_kprobes_handler(args))
+				ret = NOTIFY_STOP;
+		break;
+	case DIE_FAULT:
+		/* err is vector number from ia64_fault() */
+		if (args->err == 36)
+			if (post_kprobes_handler(args->regs))
+				ret = NOTIFY_STOP;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+struct param_bsp_cfm {
+	unsigned long ip;
+	unsigned long *bsp;
+	unsigned long cfm;
+};
+
+static void ia64_get_bsp_cfm(struct unw_frame_info *info, void *arg)
+{
+	unsigned long ip;
+	struct param_bsp_cfm *lp = arg;
+
+	do {
+		unw_get_ip(info, &ip);
+		if (ip == 0)
+			break;
+		if (ip == lp->ip) {
+			unw_get_bsp(info, (unsigned long*)&lp->bsp);
+			unw_get_cfm(info, (unsigned long*)&lp->cfm);
+			return;
+		}
+	} while (unw_unwind(info) >= 0);
+	lp->bsp = NULL;
+	lp->cfm = 0;
+	return;
+}
+
+unsigned long arch_deref_entry_point(void *entry)
+{
+	return ((struct fnptr *)entry)->ip;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	unsigned long addr = arch_deref_entry_point(jp->entry);
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	struct param_bsp_cfm pa;
+	int bytes;
+
+	/*
+	 * Callee owns the argument space and could overwrite it, eg
+	 * tail call optimization. So to be absolutely safe
+	 * we save the argument space before transferring the control
+	 * to instrumented jprobe function which runs in
+	 * the process context
+	 */
+	pa.ip = regs->cr_iip;
+	unw_init_running(ia64_get_bsp_cfm, &pa);
+	bytes = (char *)ia64_rse_skip_regs(pa.bsp, pa.cfm & 0x3f)
+				- (char *)pa.bsp;
+	memcpy( kcb->jprobes_saved_stacked_regs,
+		pa.bsp,
+		bytes );
+	kcb->bsp = pa.bsp;
+	kcb->cfm = pa.cfm;
+
+	/* save architectural state */
+	kcb->jprobe_saved_regs = *regs;
+
+	/* after rfi, execute the jprobe instrumented function */
+	regs->cr_iip = addr & ~0xFULL;
+	ia64_psr(regs)->ri = addr & 0xf;
+	regs->r1 = ((struct fnptr *)(jp->entry))->gp;
+
+	/*
+	 * fix the return address to our jprobe_inst_return() function
+	 * in the jprobes.S file
+	 */
+	regs->b0 = ((struct fnptr *)(jprobe_inst_return))->ip;
+
+	return 1;
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	int bytes;
+
+	/* restoring architectural state */
+	*regs = kcb->jprobe_saved_regs;
+
+	/* restoring the original argument space */
+	flush_register_stack();
+	bytes = (char *)ia64_rse_skip_regs(kcb->bsp, kcb->cfm & 0x3f)
+				- (char *)kcb->bsp;
+	memcpy( kcb->bsp,
+		kcb->jprobes_saved_stacked_regs,
+		bytes );
+	invalidate_stacked_regs();
+
+	preempt_enable_no_resched();
+	return 1;
+}
+
+static struct kprobe trampoline_p = {
+	.pre_handler = trampoline_probe_handler
+};
+
+int __init arch_init_kprobes(void)
+{
+	trampoline_p.addr =
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
+	return register_kprobe(&trampoline_p);
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr ==
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
+		return 1;
+
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ia64/kernel/kprobes.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,1027 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *  arch/ia64/kernel/kprobes.c
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- * Copyright (C) Intel Corporation, 2005
- *
- * 2005-Apr     Rusty Lynch <rusty.lynch@intel.com> and Anil S Keshavamurthy
- *              <anil.s.keshavamurthy@intel.com> adapted from i386
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/preempt.h>
-#include <linux/moduleloader.h>
-#include <linux/kdebug.h>
-
-#include <asm/pgtable.h>
-#include <asm/sections.h>
-#include <asm/uaccess.h>
-
-extern void jprobe_inst_return(void);
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
-
-enum instruction_type {A, I, M, F, B, L, X, u};
-static enum instruction_type bundle_encoding[32][3] = {
-  { M, I, I },				/* 00 */
-  { M, I, I },				/* 01 */
-  { M, I, I },				/* 02 */
-  { M, I, I },				/* 03 */
-  { M, L, X },				/* 04 */
-  { M, L, X },				/* 05 */
-  { u, u, u },  			/* 06 */
-  { u, u, u },  			/* 07 */
-  { M, M, I },				/* 08 */
-  { M, M, I },				/* 09 */
-  { M, M, I },				/* 0A */
-  { M, M, I },				/* 0B */
-  { M, F, I },				/* 0C */
-  { M, F, I },				/* 0D */
-  { M, M, F },				/* 0E */
-  { M, M, F },				/* 0F */
-  { M, I, B },				/* 10 */
-  { M, I, B },				/* 11 */
-  { M, B, B },				/* 12 */
-  { M, B, B },				/* 13 */
-  { u, u, u },  			/* 14 */
-  { u, u, u },  			/* 15 */
-  { B, B, B },				/* 16 */
-  { B, B, B },				/* 17 */
-  { M, M, B },				/* 18 */
-  { M, M, B },				/* 19 */
-  { u, u, u },  			/* 1A */
-  { u, u, u },  			/* 1B */
-  { M, F, B },				/* 1C */
-  { M, F, B },				/* 1D */
-  { u, u, u },  			/* 1E */
-  { u, u, u },  			/* 1F */
-};
-
-/*
- * In this function we check to see if the instruction
- * is IP relative instruction and update the kprobe
- * inst flag accordingly
- */
-static void __kprobes update_kprobe_inst_flag(uint template, uint  slot,
-					      uint major_opcode,
-					      unsigned long kprobe_inst,
-					      struct kprobe *p)
-{
-	p->ainsn.inst_flag = 0;
-	p->ainsn.target_br_reg = 0;
-	p->ainsn.slot = slot;
-
-	/* Check for Break instruction
-	 * Bits 37:40 Major opcode to be zero
-	 * Bits 27:32 X6 to be zero
-	 * Bits 32:35 X3 to be zero
-	 */
-	if ((!major_opcode) && (!((kprobe_inst >> 27) & 0x1FF)) ) {
-		/* is a break instruction */
-	 	p->ainsn.inst_flag |= INST_FLAG_BREAK_INST;
-		return;
-	}
-
-	if (bundle_encoding[template][slot] == B) {
-		switch (major_opcode) {
-		  case INDIRECT_CALL_OPCODE:
-	 		p->ainsn.inst_flag |= INST_FLAG_FIX_BRANCH_REG;
-			p->ainsn.target_br_reg = ((kprobe_inst >> 6) & 0x7);
-			break;
-		  case IP_RELATIVE_PREDICT_OPCODE:
-		  case IP_RELATIVE_BRANCH_OPCODE:
-			p->ainsn.inst_flag |= INST_FLAG_FIX_RELATIVE_IP_ADDR;
-			break;
-		  case IP_RELATIVE_CALL_OPCODE:
-			p->ainsn.inst_flag |= INST_FLAG_FIX_RELATIVE_IP_ADDR;
-			p->ainsn.inst_flag |= INST_FLAG_FIX_BRANCH_REG;
-			p->ainsn.target_br_reg = ((kprobe_inst >> 6) & 0x7);
-			break;
-		}
-	} else if (bundle_encoding[template][slot] == X) {
-		switch (major_opcode) {
-		  case LONG_CALL_OPCODE:
-			p->ainsn.inst_flag |= INST_FLAG_FIX_BRANCH_REG;
-			p->ainsn.target_br_reg = ((kprobe_inst >> 6) & 0x7);
-		  break;
-		}
-	}
-	return;
-}
-
-/*
- * In this function we check to see if the instruction
- * (qp) cmpx.crel.ctype p1,p2=r2,r3
- * on which we are inserting kprobe is cmp instruction
- * with ctype as unc.
- */
-static uint __kprobes is_cmp_ctype_unc_inst(uint template, uint slot,
-					    uint major_opcode,
-					    unsigned long kprobe_inst)
-{
-	cmp_inst_t cmp_inst;
-	uint ctype_unc = 0;
-
-	if (!((bundle_encoding[template][slot] == I) ||
-		(bundle_encoding[template][slot] == M)))
-		goto out;
-
-	if (!((major_opcode == 0xC) || (major_opcode == 0xD) ||
-		(major_opcode == 0xE)))
-		goto out;
-
-	cmp_inst.l = kprobe_inst;
-	if ((cmp_inst.f.x2 == 0) || (cmp_inst.f.x2 == 1)) {
-		/* Integer compare - Register Register (A6 type)*/
-		if ((cmp_inst.f.tb == 0) && (cmp_inst.f.ta == 0)
-				&&(cmp_inst.f.c == 1))
-			ctype_unc = 1;
-	} else if ((cmp_inst.f.x2 == 2)||(cmp_inst.f.x2 == 3)) {
-		/* Integer compare - Immediate Register (A8 type)*/
-		if ((cmp_inst.f.ta == 0) &&(cmp_inst.f.c == 1))
-			ctype_unc = 1;
-	}
-out:
-	return ctype_unc;
-}
-
-/*
- * In this function we check to see if the instruction
- * on which we are inserting kprobe is supported.
- * Returns qp value if supported
- * Returns -EINVAL if unsupported
- */
-static int __kprobes unsupported_inst(uint template, uint  slot,
-				      uint major_opcode,
-				      unsigned long kprobe_inst,
-				      unsigned long addr)
-{
-	int qp;
-
-	qp = kprobe_inst & 0x3f;
-	if (is_cmp_ctype_unc_inst(template, slot, major_opcode, kprobe_inst)) {
-		if (slot == 1 && qp)  {
-			printk(KERN_WARNING "Kprobes on cmp unc"
-					"instruction on slot 1 at <0x%lx>"
-					"is not supported\n", addr);
-			return -EINVAL;
-
-		}
-		qp = 0;
-	}
-	else if (bundle_encoding[template][slot] == I) {
-		if (major_opcode == 0) {
-			/*
-			 * Check for Integer speculation instruction
-			 * - Bit 33-35 to be equal to 0x1
-			 */
-			if (((kprobe_inst >> 33) & 0x7) == 1) {
-				printk(KERN_WARNING
-					"Kprobes on speculation inst at <0x%lx> not supported\n",
-						addr);
-				return -EINVAL;
-			}
-			/*
-			 * IP relative mov instruction
-			 *  - Bit 27-35 to be equal to 0x30
-			 */
-			if (((kprobe_inst >> 27) & 0x1FF) == 0x30) {
-				printk(KERN_WARNING
-					"Kprobes on \"mov r1=ip\" at <0x%lx> not supported\n",
-						addr);
-				return -EINVAL;
-
-			}
-		}
-		else if ((major_opcode == 5) &&	!(kprobe_inst & (0xFUl << 33)) &&
-				(kprobe_inst & (0x1UL << 12))) {
-			/* test bit instructions, tbit,tnat,tf
-			 * bit 33-36 to be equal to 0
-			 * bit 12 to be equal to 1
-			 */
-			if (slot == 1 && qp) {
-				printk(KERN_WARNING "Kprobes on test bit"
-						"instruction on slot at <0x%lx>"
-						"is not supported\n", addr);
-				return -EINVAL;
-			}
-			qp = 0;
-		}
-	}
-	else if (bundle_encoding[template][slot] == B) {
-		if (major_opcode == 7) {
-			/* IP-Relative Predict major code is 7 */
-			printk(KERN_WARNING "Kprobes on IP-Relative"
-					"Predict is not supported\n");
-			return -EINVAL;
-		}
-		else if (major_opcode == 2) {
-			/* Indirect Predict, major code is 2
-			 * bit 27-32 to be equal to 10 or 11
-			 */
-			int x6=(kprobe_inst >> 27) & 0x3F;
-			if ((x6 == 0x10) || (x6 == 0x11)) {
-				printk(KERN_WARNING "Kprobes on"
-					"Indirect Predict is not supported\n");
-				return -EINVAL;
-			}
-		}
-	}
-	/* kernel does not use float instruction, here for safety kprobe
-	 * will judge whether it is fcmp/flass/float approximation instruction
-	 */
-	else if (unlikely(bundle_encoding[template][slot] == F)) {
-		if ((major_opcode == 4 || major_opcode == 5) &&
-				(kprobe_inst  & (0x1 << 12))) {
-			/* fcmp/fclass unc instruction */
-			if (slot == 1 && qp) {
-				printk(KERN_WARNING "Kprobes on fcmp/fclass "
-					"instruction on slot at <0x%lx> "
-					"is not supported\n", addr);
-				return -EINVAL;
-
-			}
-			qp = 0;
-		}
-		if ((major_opcode == 0 || major_opcode == 1) &&
-			(kprobe_inst & (0x1UL << 33))) {
-			/* float Approximation instruction */
-			if (slot == 1 && qp) {
-				printk(KERN_WARNING "Kprobes on float Approx "
-					"instr at <0x%lx> is not supported\n",
-						addr);
-				return -EINVAL;
-			}
-			qp = 0;
-		}
-	}
-	return qp;
-}
-
-/*
- * In this function we override the bundle with
- * the break instruction at the given slot.
- */
-static void __kprobes prepare_break_inst(uint template, uint  slot,
-					 uint major_opcode,
-					 unsigned long kprobe_inst,
-					 struct kprobe *p,
-					 int qp)
-{
-	unsigned long break_inst = BREAK_INST;
-	bundle_t *bundle = &p->opcode.bundle;
-
-	/*
-	 * Copy the original kprobe_inst qualifying predicate(qp)
-	 * to the break instruction
-	 */
-	break_inst |= qp;
-
-	switch (slot) {
-	  case 0:
-		bundle->quad0.slot0 = break_inst;
-		break;
-	  case 1:
-		bundle->quad0.slot1_p0 = break_inst;
-		bundle->quad1.slot1_p1 = break_inst >> (64-46);
-		break;
-	  case 2:
-		bundle->quad1.slot2 = break_inst;
-		break;
-	}
-
-	/*
-	 * Update the instruction flag, so that we can
-	 * emulate the instruction properly after we
-	 * single step on original instruction
-	 */
-	update_kprobe_inst_flag(template, slot, major_opcode, kprobe_inst, p);
-}
-
-static void __kprobes get_kprobe_inst(bundle_t *bundle, uint slot,
-	       	unsigned long *kprobe_inst, uint *major_opcode)
-{
-	unsigned long kprobe_inst_p0, kprobe_inst_p1;
-	unsigned int template;
-
-	template = bundle->quad0.template;
-
-	switch (slot) {
-	  case 0:
-		*major_opcode = (bundle->quad0.slot0 >> SLOT0_OPCODE_SHIFT);
-		*kprobe_inst = bundle->quad0.slot0;
-		  break;
-	  case 1:
-		*major_opcode = (bundle->quad1.slot1_p1 >> SLOT1_p1_OPCODE_SHIFT);
-		kprobe_inst_p0 = bundle->quad0.slot1_p0;
-		kprobe_inst_p1 = bundle->quad1.slot1_p1;
-		*kprobe_inst = kprobe_inst_p0 | (kprobe_inst_p1 << (64-46));
-		break;
-	  case 2:
-		*major_opcode = (bundle->quad1.slot2 >> SLOT2_OPCODE_SHIFT);
-		*kprobe_inst = bundle->quad1.slot2;
-		break;
-	}
-}
-
-/* Returns non-zero if the addr is in the Interrupt Vector Table */
-static int __kprobes in_ivt_functions(unsigned long addr)
-{
-	return (addr >= (unsigned long)__start_ivt_text
-		&& addr < (unsigned long)__end_ivt_text);
-}
-
-static int __kprobes valid_kprobe_addr(int template, int slot,
-				       unsigned long addr)
-{
-	if ((slot > 2) || ((bundle_encoding[template][1] == L) && slot > 1)) {
-		printk(KERN_WARNING "Attempting to insert unaligned kprobe "
-				"at 0x%lx\n", addr);
-		return -EINVAL;
-	}
-
-	if (in_ivt_functions(addr)) {
-		printk(KERN_WARNING "Kprobes can't be inserted inside "
-				"IVT functions at 0x%lx\n", addr);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	unsigned int i;
-	i = atomic_add_return(1, &kcb->prev_kprobe_index);
-	kcb->prev_kprobe[i-1].kp = kprobe_running();
-	kcb->prev_kprobe[i-1].status = kcb->kprobe_status;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	unsigned int i;
-	i = atomic_sub_return(1, &kcb->prev_kprobe_index);
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i].kp;
-	kcb->kprobe_status = kcb->prev_kprobe[i].status;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p,
-			struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-}
-
-static void kretprobe_trampoline(void)
-{
-}
-
-/*
- * At this point the target function has been tricked into
- * returning into our trampoline.  Lookup the associated instance
- * and then:
- *    - call the handler function
- *    - cleanup by marking the instance as unused
- *    - long jump back to the original return address
- */
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =
-		((struct fnptr *)kretprobe_trampoline)->ip;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-
-	regs->cr_iip = orig_ret_address;
-
-	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	preempt_enable_no_resched();
-
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
-{
-	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
-
-	/* Replace the return addr with trampoline addr */
-	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	unsigned long addr = (unsigned long) p->addr;
-	unsigned long *kprobe_addr = (unsigned long *)(addr & ~0xFULL);
-	unsigned long kprobe_inst=0;
-	unsigned int slot = addr & 0xf, template, major_opcode = 0;
-	bundle_t *bundle;
-	int qp;
-
-	bundle = &((kprobe_opcode_t *)kprobe_addr)->bundle;
-	template = bundle->quad0.template;
-
-	if(valid_kprobe_addr(template, slot, addr))
-		return -EINVAL;
-
-	/* Move to slot 2, if bundle is MLX type and kprobe slot is 1 */
-	if (slot == 1 && bundle_encoding[template][1] == L)
-		slot++;
-
-	/* Get kprobe_inst and major_opcode from the bundle */
-	get_kprobe_inst(bundle, slot, &kprobe_inst, &major_opcode);
-
-	qp = unsupported_inst(template, slot, major_opcode, kprobe_inst, addr);
-	if (qp < 0)
-		return -EINVAL;
-
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn)
-		return -ENOMEM;
-	memcpy(&p->opcode, kprobe_addr, sizeof(kprobe_opcode_t));
-	memcpy(p->ainsn.insn, kprobe_addr, sizeof(kprobe_opcode_t));
-
-	prepare_break_inst(template, slot, major_opcode, kprobe_inst, p, qp);
-
-	return 0;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	unsigned long arm_addr;
-	bundle_t *src, *dest;
-
-	arm_addr = ((unsigned long)p->addr) & ~0xFUL;
-	dest = &((kprobe_opcode_t *)arm_addr)->bundle;
-	src = &p->opcode.bundle;
-
-	flush_icache_range((unsigned long)p->ainsn.insn,
-			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
-	switch (p->ainsn.slot) {
-		case 0:
-			dest->quad0.slot0 = src->quad0.slot0;
-			break;
-		case 1:
-			dest->quad1.slot1_p1 = src->quad1.slot1_p1;
-			break;
-		case 2:
-			dest->quad1.slot2 = src->quad1.slot2;
-			break;
-	}
-	flush_icache_range(arm_addr, arm_addr + sizeof(kprobe_opcode_t));
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	unsigned long arm_addr;
-	bundle_t *src, *dest;
-
-	arm_addr = ((unsigned long)p->addr) & ~0xFUL;
-	dest = &((kprobe_opcode_t *)arm_addr)->bundle;
-	/* p->ainsn.insn contains the original unaltered kprobe_opcode_t */
-	src = &p->ainsn.insn->bundle;
-	switch (p->ainsn.slot) {
-		case 0:
-			dest->quad0.slot0 = src->quad0.slot0;
-			break;
-		case 1:
-			dest->quad1.slot1_p1 = src->quad1.slot1_p1;
-			break;
-		case 2:
-			dest->quad1.slot2 = src->quad1.slot2;
-			break;
-	}
-	flush_icache_range(arm_addr, arm_addr + sizeof(kprobe_opcode_t));
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
-}
-/*
- * We are resuming execution after a single step fault, so the pt_regs
- * structure reflects the register state after we executed the instruction
- * located in the kprobe (p->ainsn.insn.bundle).  We still need to adjust
- * the ip to point back to the original stack address. To set the IP address
- * to original stack address, handle the case where we need to fixup the
- * relative IP address and/or fixup branch register.
- */
-static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
-{
-	unsigned long bundle_addr = (unsigned long) (&p->ainsn.insn->bundle);
-	unsigned long resume_addr = (unsigned long)p->addr & ~0xFULL;
-	unsigned long template;
-	int slot = ((unsigned long)p->addr & 0xf);
-
-	template = p->ainsn.insn->bundle.quad0.template;
-
-	if (slot == 1 && bundle_encoding[template][1] == L)
-		slot = 2;
-
-	if (p->ainsn.inst_flag) {
-
-		if (p->ainsn.inst_flag & INST_FLAG_FIX_RELATIVE_IP_ADDR) {
-			/* Fix relative IP address */
-			regs->cr_iip = (regs->cr_iip - bundle_addr) +
-					resume_addr;
-		}
-
-		if (p->ainsn.inst_flag & INST_FLAG_FIX_BRANCH_REG) {
-		/*
-		 * Fix target branch register, software convention is
-		 * to use either b0 or b6 or b7, so just checking
-		 * only those registers
-		 */
-			switch (p->ainsn.target_br_reg) {
-			case 0:
-				if ((regs->b0 == bundle_addr) ||
-					(regs->b0 == bundle_addr + 0x10)) {
-					regs->b0 = (regs->b0 - bundle_addr) +
-						resume_addr;
-				}
-				break;
-			case 6:
-				if ((regs->b6 == bundle_addr) ||
-					(regs->b6 == bundle_addr + 0x10)) {
-					regs->b6 = (regs->b6 - bundle_addr) +
-						resume_addr;
-				}
-				break;
-			case 7:
-				if ((regs->b7 == bundle_addr) ||
-					(regs->b7 == bundle_addr + 0x10)) {
-					regs->b7 = (regs->b7 - bundle_addr) +
-						resume_addr;
-				}
-				break;
-			} /* end switch */
-		}
-		goto turn_ss_off;
-	}
-
-	if (slot == 2) {
-		if (regs->cr_iip == bundle_addr + 0x10) {
-			regs->cr_iip = resume_addr + 0x10;
-		}
-	} else {
-		if (regs->cr_iip == bundle_addr) {
-			regs->cr_iip = resume_addr;
-		}
-	}
-
-turn_ss_off:
-	/* Turn off Single Step bit */
-	ia64_psr(regs)->ss = 0;
-}
-
-static void __kprobes prepare_ss(struct kprobe *p, struct pt_regs *regs)
-{
-	unsigned long bundle_addr = (unsigned long) &p->ainsn.insn->bundle;
-	unsigned long slot = (unsigned long)p->addr & 0xf;
-
-	/* single step inline if break instruction */
-	if (p->ainsn.inst_flag == INST_FLAG_BREAK_INST)
-		regs->cr_iip = (unsigned long)p->addr & ~0xFULL;
-	else
-		regs->cr_iip = bundle_addr & ~0xFULL;
-
-	if (slot > 2)
-		slot = 0;
-
-	ia64_psr(regs)->ri = slot;
-
-	/* turn on single stepping */
-	ia64_psr(regs)->ss = 1;
-}
-
-static int __kprobes is_ia64_break_inst(struct pt_regs *regs)
-{
-	unsigned int slot = ia64_psr(regs)->ri;
-	unsigned int template, major_opcode;
-	unsigned long kprobe_inst;
-	unsigned long *kprobe_addr = (unsigned long *)regs->cr_iip;
-	bundle_t bundle;
-
-	memcpy(&bundle, kprobe_addr, sizeof(bundle_t));
-	template = bundle.quad0.template;
-
-	/* Move to slot 2, if bundle is MLX type and kprobe slot is 1 */
-	if (slot == 1 && bundle_encoding[template][1] == L)
-		slot++;
-
-	/* Get Kprobe probe instruction at given slot*/
-	get_kprobe_inst(&bundle, slot, &kprobe_inst, &major_opcode);
-
-	/* For break instruction,
-	 * Bits 37:40 Major opcode to be zero
-	 * Bits 27:32 X6 to be zero
-	 * Bits 32:35 X3 to be zero
-	 */
-	if (major_opcode || ((kprobe_inst >> 27) & 0x1FF) ) {
-		/* Not a break instruction */
-		return 0;
-	}
-
-	/* Is a break instruction */
-	return 1;
-}
-
-static int __kprobes pre_kprobes_handler(struct die_args *args)
-{
-	struct kprobe *p;
-	int ret = 0;
-	struct pt_regs *regs = args->regs;
-	kprobe_opcode_t *addr = (kprobe_opcode_t *)instruction_pointer(regs);
-	struct kprobe_ctlblk *kcb;
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Handle recursion cases */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if ((kcb->kprobe_status == KPROBE_HIT_SS) &&
-	 		     (p->ainsn.inst_flag == INST_FLAG_BREAK_INST)) {
-				ia64_psr(regs)->ss = 0;
-				goto no_kprobe;
-			}
-			/* We have reentered the pre_kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_ss(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-		} else if (args->err == __IA64_BREAK_JPROBE) {
-			/*
-			 * jprobe instrumented function just completed
-			 */
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		} else if (!is_ia64_break_inst(regs)) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-			ret = 1;
-			goto no_kprobe;
-		} else {
-			/* Not our break */
-			goto no_kprobe;
-		}
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (!is_ia64_break_inst(regs)) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 */
-			ret = 1;
-
-		}
-
-		/* Not one of our break, let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/*
-		 * Our pre-handler is specifically requesting that we just
-		 * do a return.  This is used for both the jprobe pre-handler
-		 * and the kretprobe trampoline
-		 */
-		return 1;
-
-ss_probe:
-	prepare_ss(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-static int __kprobes post_kprobes_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs);
-
-	/*Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-
-out:
-	preempt_enable_no_resched();
-	return 1;
-}
-
-int __kprobes kprobes_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the instruction pointer points back to
-		 * the probe address and allow the page fault handler
-		 * to continue as a normal page fault.
-		 */
-		regs->cr_iip = ((unsigned long)cur->addr) & ~0xFULL;
-		ia64_psr(regs)->ri = ((unsigned long)cur->addr) & 0xf;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-		if (ia64_done_with_exception(regs))
-			return 1;
-
-		/*
-		 * Let ia64_do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	if (args->regs && user_mode(args->regs))
-		return ret;
-
-	switch(val) {
-	case DIE_BREAK:
-		/* err is break number from ia64_bad_break() */
-		if ((args->err >> 12) == (__IA64_BREAK_KPROBE >> 12)
-			|| args->err == __IA64_BREAK_JPROBE
-			|| args->err == 0)
-			if (pre_kprobes_handler(args))
-				ret = NOTIFY_STOP;
-		break;
-	case DIE_FAULT:
-		/* err is vector number from ia64_fault() */
-		if (args->err == 36)
-			if (post_kprobes_handler(args->regs))
-				ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-struct param_bsp_cfm {
-	unsigned long ip;
-	unsigned long *bsp;
-	unsigned long cfm;
-};
-
-static void ia64_get_bsp_cfm(struct unw_frame_info *info, void *arg)
-{
-	unsigned long ip;
-	struct param_bsp_cfm *lp = arg;
-
-	do {
-		unw_get_ip(info, &ip);
-		if (ip == 0)
-			break;
-		if (ip == lp->ip) {
-			unw_get_bsp(info, (unsigned long*)&lp->bsp);
-			unw_get_cfm(info, (unsigned long*)&lp->cfm);
-			return;
-		}
-	} while (unw_unwind(info) >= 0);
-	lp->bsp = NULL;
-	lp->cfm = 0;
-	return;
-}
-
-unsigned long arch_deref_entry_point(void *entry)
-{
-	return ((struct fnptr *)entry)->ip;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr = arch_deref_entry_point(jp->entry);
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	struct param_bsp_cfm pa;
-	int bytes;
-
-	/*
-	 * Callee owns the argument space and could overwrite it, eg
-	 * tail call optimization. So to be absolutely safe
-	 * we save the argument space before transferring the control
-	 * to instrumented jprobe function which runs in
-	 * the process context
-	 */
-	pa.ip = regs->cr_iip;
-	unw_init_running(ia64_get_bsp_cfm, &pa);
-	bytes = (char *)ia64_rse_skip_regs(pa.bsp, pa.cfm & 0x3f)
-				- (char *)pa.bsp;
-	memcpy( kcb->jprobes_saved_stacked_regs,
-		pa.bsp,
-		bytes );
-	kcb->bsp = pa.bsp;
-	kcb->cfm = pa.cfm;
-
-	/* save architectural state */
-	kcb->jprobe_saved_regs = *regs;
-
-	/* after rfi, execute the jprobe instrumented function */
-	regs->cr_iip = addr & ~0xFULL;
-	ia64_psr(regs)->ri = addr & 0xf;
-	regs->r1 = ((struct fnptr *)(jp->entry))->gp;
-
-	/*
-	 * fix the return address to our jprobe_inst_return() function
-	 * in the jprobes.S file
-	 */
-	regs->b0 = ((struct fnptr *)(jprobe_inst_return))->ip;
-
-	return 1;
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	int bytes;
-
-	/* restoring architectural state */
-	*regs = kcb->jprobe_saved_regs;
-
-	/* restoring the original argument space */
-	flush_register_stack();
-	bytes = (char *)ia64_rse_skip_regs(kcb->bsp, kcb->cfm & 0x3f)
-				- (char *)kcb->bsp;
-	memcpy( kcb->bsp,
-		kcb->jprobes_saved_stacked_regs,
-		bytes );
-	invalidate_stacked_regs();
-
-	preempt_enable_no_resched();
-	return 1;
-}
-
-static struct kprobe trampoline_p = {
-	.pre_handler = trampoline_probe_handler
-};
-
-int __init arch_init_kprobes(void)
-{
-	trampoline_p.addr =
-		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
-	return register_kprobe(&trampoline_p);
-}
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-	if (p->addr ==
-		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
-		return 1;
-
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/powerpc/instrumentation/kprobes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/powerpc/instrumentation/kprobes.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,559 @@
+/*
+ *  Kernel Probes (KProbes)
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
+ * Copyright (C) IBM Corporation, 2002, 2004
+ *
+ * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
+ *		Probes initial implementation ( includes contributions from
+ *		Rusty Russell).
+ * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
+ *		interface to access function arguments.
+ * 2004-Nov	Ananth N Mavinakayanahalli <ananth@in.ibm.com> kprobes port
+ *		for PPC64
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <asm/cacheflush.h>
+#include <asm/sstep.h>
+#include <asm/uaccess.h>
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	int ret = 0;
+	kprobe_opcode_t insn = *p->addr;
+
+	if ((unsigned long)p->addr & 0x03) {
+		printk("Attempt to register kprobe at an unaligned address\n");
+		ret = -EINVAL;
+	} else if (IS_MTMSRD(insn) || IS_RFID(insn) || IS_RFI(insn)) {
+		printk("Cannot register a kprobe on rfi/rfid or mtmsr[d]\n");
+		ret = -EINVAL;
+	}
+
+	/* insn must be on a special executable page on ppc64 */
+	if (!ret) {
+		p->ainsn.insn = get_insn_slot();
+		if (!p->ainsn.insn)
+			ret = -ENOMEM;
+	}
+
+	if (!ret) {
+		memcpy(p->ainsn.insn, p->addr,
+				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+		p->opcode = *p->addr;
+		flush_icache_range((unsigned long)p->ainsn.insn,
+			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
+	}
+
+	p->ainsn.boostable = 0;
+	return ret;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	*p->addr = p->opcode;
+	flush_icache_range((unsigned long) p->addr,
+			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	mutex_lock(&kprobe_mutex);
+	free_insn_slot(p->ainsn.insn, 0);
+	mutex_unlock(&kprobe_mutex);
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	regs->msr |= MSR_SE;
+
+	/*
+	 * On powerpc we should single step on the original
+	 * instruction even if the probed insn is a trap
+	 * variant as values in regs could play a part in
+	 * if the trap is taken or not
+	 */
+	regs->nip = (unsigned long)p->ainsn.insn;
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.saved_msr = kcb->kprobe_saved_msr;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_saved_msr = kcb->prev_kprobe.saved_msr;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+				struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	kcb->kprobe_saved_msr = regs->msr;
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	ri->ret_addr = (kprobe_opcode_t *)regs->link;
+
+	/* Replace the return addr with trampoline addr */
+	regs->link = (unsigned long)kretprobe_trampoline;
+}
+
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	unsigned int *addr = (unsigned int *)regs->nip;
+	struct kprobe_ctlblk *kcb;
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			kprobe_opcode_t insn = *p->ainsn.insn;
+			if (kcb->kprobe_status == KPROBE_HIT_SS &&
+					is_trap(insn)) {
+				regs->msr &= ~MSR_SE;
+				regs->msr |= kcb->kprobe_saved_msr;
+				goto no_kprobe;
+			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kcb->kprobe_saved_msr = regs->msr;
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+		} else {
+			if (*addr != BREAKPOINT_INSTRUCTION) {
+				/* If trap variant, then it belongs not to us */
+				kprobe_opcode_t cur_insn = *addr;
+				if (is_trap(cur_insn))
+		       			goto no_kprobe;
+				/* The breakpoint instruction was removed by
+				 * another cpu right after we hit, no further
+				 * handling of this interrupt is appropriate
+				 */
+				ret = 1;
+				goto no_kprobe;
+			}
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs)) {
+				goto ss_probe;
+			}
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (*addr != BREAKPOINT_INSTRUCTION) {
+			/*
+			 * PowerPC has multiple variants of the "trap"
+			 * instruction. If the current instruction is a
+			 * trap variant, it could belong to someone else
+			 */
+			kprobe_opcode_t cur_insn = *addr;
+			if (is_trap(cur_insn))
+		       		goto no_kprobe;
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 */
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+	set_current_kprobe(p, regs, kcb);
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+
+ss_probe:
+	if (p->ainsn.boostable >= 0) {
+		unsigned int insn = *p->ainsn.insn;
+
+		/* regs->nip is also adjusted if emulate_step returns 1 */
+		ret = emulate_step(regs, insn);
+		if (ret > 0) {
+			/*
+			 * Once this instruction has been boosted
+			 * successfully, set the boostable flag
+			 */
+			if (unlikely(p->ainsn.boostable == 0))
+				p->ainsn.boostable = 1;
+
+			if (p->post_handler)
+				p->post_handler(p, regs, 0);
+
+			kcb->kprobe_status = KPROBE_HIT_SSDONE;
+			reset_current_kprobe();
+			preempt_enable_no_resched();
+			return 1;
+		} else if (ret < 0) {
+			/*
+			 * We don't allow kprobes on mtmsr(d)/rfi(d), etc.
+			 * So, we should never get here... but, its still
+			 * good to catch them, just in case...
+			 */
+			printk("Can't step on instruction %x\n", insn);
+			BUG();
+		} else if (ret == 0)
+			/* This instruction can't be boosted */
+			p->ainsn.boostable = -1;
+	}
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * Function return probe trampoline:
+ * 	- init_kprobes() establishes a probepoint here
+ * 	- When the probed function returns, this probe
+ * 		causes the handlers to fire
+ */
+void kretprobe_trampoline_holder(void)
+{
+	asm volatile(".global kretprobe_trampoline\n"
+			"kretprobe_trampoline:\n"
+			"nop\n");
+}
+
+/*
+ * Called when the probe at kretprobe trampoline is hit
+ */
+int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(current);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more then one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	regs->nip = orig_ret_address;
+
+	reset_current_kprobe();
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "breakpoint"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ */
+static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
+{
+	int ret;
+	unsigned int insn = *p->ainsn.insn;
+
+	regs->nip = (unsigned long)p->addr;
+	ret = emulate_step(regs, insn);
+	if (ret == 0)
+		regs->nip = (unsigned long)p->addr + 4;
+}
+
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs);
+	regs->msr |= kcb->kprobe_saved_msr;
+
+	/*Restore back the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, msr
+	 * will have SE set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (regs->msr & MSR_SE)
+		return 0;
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	const struct exception_table_entry *entry;
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the nip points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		regs->nip = (unsigned long)cur->addr;
+		regs->msr &= ~MSR_SE;
+		regs->msr |= kcb->kprobe_saved_msr;
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+		if ((entry = search_exception_tables(regs->nip)) != NULL) {
+			regs->nip = entry->fixup;
+			return 1;
+		}
+
+		/*
+		 * fixup_exception() could not handle it,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine to for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	if (args->regs && user_mode(args->regs))
+		return ret;
+
+	switch (val) {
+	case DIE_BPT:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_SSTEP:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+#ifdef CONFIG_PPC64
+unsigned long arch_deref_entry_point(void *entry)
+{
+	return (unsigned long)(((func_descr_t *)entry)->entry);
+}
+#endif
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	memcpy(&kcb->jprobe_saved_regs, regs, sizeof(struct pt_regs));
+
+	/* setup return addr to the jprobe handler routine */
+	regs->nip = arch_deref_entry_point(jp->entry);
+#ifdef CONFIG_PPC64
+	regs->gpr[2] = (unsigned long)(((func_descr_t *)jp->entry)->toc);
+#endif
+
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	asm volatile("trap" ::: "memory");
+}
+
+void __kprobes jprobe_return_end(void)
+{
+};
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	/*
+	 * FIXME - we should ideally be validating that we got here 'cos
+	 * of the "trap" in jprobe_return() above, before restoring the
+	 * saved regs...
+	 */
+	memcpy(regs, &kcb->jprobe_saved_regs, sizeof(struct pt_regs));
+	preempt_enable_no_resched();
+	return 1;
+}
+
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+
+int __init arch_init_kprobes(void)
+{
+	return register_kprobe(&trampoline_p);
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/powerpc/kernel/kprobes.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,559 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- *
- * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
- *		Probes initial implementation ( includes contributions from
- *		Rusty Russell).
- * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
- *		interface to access function arguments.
- * 2004-Nov	Ananth N Mavinakayanahalli <ananth@in.ibm.com> kprobes port
- *		for PPC64
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/preempt.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-#include <asm/cacheflush.h>
-#include <asm/sstep.h>
-#include <asm/uaccess.h>
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	int ret = 0;
-	kprobe_opcode_t insn = *p->addr;
-
-	if ((unsigned long)p->addr & 0x03) {
-		printk("Attempt to register kprobe at an unaligned address\n");
-		ret = -EINVAL;
-	} else if (IS_MTMSRD(insn) || IS_RFID(insn) || IS_RFI(insn)) {
-		printk("Cannot register a kprobe on rfi/rfid or mtmsr[d]\n");
-		ret = -EINVAL;
-	}
-
-	/* insn must be on a special executable page on ppc64 */
-	if (!ret) {
-		p->ainsn.insn = get_insn_slot();
-		if (!p->ainsn.insn)
-			ret = -ENOMEM;
-	}
-
-	if (!ret) {
-		memcpy(p->ainsn.insn, p->addr,
-				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-		p->opcode = *p->addr;
-		flush_icache_range((unsigned long)p->ainsn.insn,
-			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
-	}
-
-	p->ainsn.boostable = 0;
-	return ret;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	*p->addr = BREAKPOINT_INSTRUCTION;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	regs->msr |= MSR_SE;
-
-	/*
-	 * On powerpc we should single step on the original
-	 * instruction even if the probed insn is a trap
-	 * variant as values in regs could play a part in
-	 * if the trap is taken or not
-	 */
-	regs->nip = (unsigned long)p->ainsn.insn;
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.saved_msr = kcb->kprobe_saved_msr;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_saved_msr = kcb->prev_kprobe.saved_msr;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_msr = regs->msr;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
-{
-	ri->ret_addr = (kprobe_opcode_t *)regs->link;
-
-	/* Replace the return addr with trampoline addr */
-	regs->link = (unsigned long)kretprobe_trampoline;
-}
-
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	int ret = 0;
-	unsigned int *addr = (unsigned int *)regs->nip;
-	struct kprobe_ctlblk *kcb;
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			kprobe_opcode_t insn = *p->ainsn.insn;
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-					is_trap(insn)) {
-				regs->msr &= ~MSR_SE;
-				regs->msr |= kcb->kprobe_saved_msr;
-				goto no_kprobe;
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kcb->kprobe_saved_msr = regs->msr;
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-				/* If trap variant, then it belongs not to us */
-				kprobe_opcode_t cur_insn = *addr;
-				if (is_trap(cur_insn))
-		       			goto no_kprobe;
-				/* The breakpoint instruction was removed by
-				 * another cpu right after we hit, no further
-				 * handling of this interrupt is appropriate
-				 */
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * PowerPC has multiple variants of the "trap"
-			 * instruction. If the current instruction is a
-			 * trap variant, it could belong to someone else
-			 */
-			kprobe_opcode_t cur_insn = *addr;
-			if (is_trap(cur_insn))
-		       		goto no_kprobe;
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 */
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-	set_current_kprobe(p, regs, kcb);
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-	if (p->ainsn.boostable >= 0) {
-		unsigned int insn = *p->ainsn.insn;
-
-		/* regs->nip is also adjusted if emulate_step returns 1 */
-		ret = emulate_step(regs, insn);
-		if (ret > 0) {
-			/*
-			 * Once this instruction has been boosted
-			 * successfully, set the boostable flag
-			 */
-			if (unlikely(p->ainsn.boostable == 0))
-				p->ainsn.boostable = 1;
-
-			if (p->post_handler)
-				p->post_handler(p, regs, 0);
-
-			kcb->kprobe_status = KPROBE_HIT_SSDONE;
-			reset_current_kprobe();
-			preempt_enable_no_resched();
-			return 1;
-		} else if (ret < 0) {
-			/*
-			 * We don't allow kprobes on mtmsr(d)/rfi(d), etc.
-			 * So, we should never get here... but, its still
-			 * good to catch them, just in case...
-			 */
-			printk("Can't step on instruction %x\n", insn);
-			BUG();
-		} else if (ret == 0)
-			/* This instruction can't be boosted */
-			p->ainsn.boostable = -1;
-	}
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/*
- * Function return probe trampoline:
- * 	- init_kprobes() establishes a probepoint here
- * 	- When the probed function returns, this probe
- * 		causes the handlers to fire
- */
-void kretprobe_trampoline_holder(void)
-{
-	asm volatile(".global kretprobe_trampoline\n"
-			"kretprobe_trampoline:\n"
-			"nop\n");
-}
-
-/*
- * Called when the probe at kretprobe trampoline is hit
- */
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	regs->nip = orig_ret_address;
-
-	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	preempt_enable_no_resched();
-
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "breakpoint"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- */
-static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
-{
-	int ret;
-	unsigned int insn = *p->ainsn.insn;
-
-	regs->nip = (unsigned long)p->addr;
-	ret = emulate_step(regs, insn);
-	if (ret == 0)
-		regs->nip = (unsigned long)p->addr + 4;
-}
-
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs);
-	regs->msr |= kcb->kprobe_saved_msr;
-
-	/*Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	/*
-	 * if somebody else is singlestepping across a probe point, msr
-	 * will have SE set, in which case, continue the remaining processing
-	 * of do_debug, as if this is not a probe hit.
-	 */
-	if (regs->msr & MSR_SE)
-		return 0;
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	const struct exception_table_entry *entry;
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the nip points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->nip = (unsigned long)cur->addr;
-		regs->msr &= ~MSR_SE;
-		regs->msr |= kcb->kprobe_saved_msr;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-		if ((entry = search_exception_tables(regs->nip)) != NULL) {
-			regs->nip = entry->fixup;
-			return 1;
-		}
-
-		/*
-		 * fixup_exception() could not handle it,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine to for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	if (args->regs && user_mode(args->regs))
-		return ret;
-
-	switch (val) {
-	case DIE_BPT:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_SSTEP:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-#ifdef CONFIG_PPC64
-unsigned long arch_deref_entry_point(void *entry)
-{
-	return (unsigned long)(((func_descr_t *)entry)->entry);
-}
-#endif
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	memcpy(&kcb->jprobe_saved_regs, regs, sizeof(struct pt_regs));
-
-	/* setup return addr to the jprobe handler routine */
-	regs->nip = arch_deref_entry_point(jp->entry);
-#ifdef CONFIG_PPC64
-	regs->gpr[2] = (unsigned long)(((func_descr_t *)jp->entry)->toc);
-#endif
-
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	asm volatile("trap" ::: "memory");
-}
-
-void __kprobes jprobe_return_end(void)
-{
-};
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	/*
-	 * FIXME - we should ideally be validating that we got here 'cos
-	 * of the "trap" in jprobe_return() above, before restoring the
-	 * saved regs...
-	 */
-	memcpy(regs, &kcb->jprobe_saved_regs, sizeof(struct pt_regs));
-	preempt_enable_no_resched();
-	return 1;
-}
-
-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-
-int __init arch_init_kprobes(void)
-{
-	return register_kprobe(&trampoline_p);
-}
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
-		return 1;
-
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/s390/instrumentation/kprobes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/s390/instrumentation/kprobes.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,672 @@
+/*
+ *  Kernel Probes (KProbes)
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
+ * Copyright (C) IBM Corporation, 2002, 2006
+ *
+ * s390 port, used ppc64 as template. Mike Grundy <grundym@us.ibm.com>
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <linux/stop_machine.h>
+#include <linux/kdebug.h>
+#include <asm/cacheflush.h>
+#include <asm/sections.h>
+#include <asm/uaccess.h>
+#include <linux/module.h>
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* Make sure the probe isn't going on a difficult instruction */
+	if (is_prohibited_opcode((kprobe_opcode_t *) p->addr))
+		return -EINVAL;
+
+	if ((unsigned long)p->addr & 0x01) {
+		printk("Attempt to register kprobe at an unaligned address\n");
+		return -EINVAL;
+		}
+
+	/* Use the get_insn_slot() facility for correctness */
+	if (!(p->ainsn.insn = get_insn_slot()))
+		return -ENOMEM;
+
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+
+	get_instruction_type(&p->ainsn);
+	p->opcode = *p->addr;
+	return 0;
+}
+
+int __kprobes is_prohibited_opcode(kprobe_opcode_t *instruction)
+{
+	switch (*(__u8 *) instruction) {
+	case 0x0c:	/* bassm */
+	case 0x0b:	/* bsm	 */
+	case 0x83:	/* diag  */
+	case 0x44:	/* ex	 */
+		return -EINVAL;
+	}
+	switch (*(__u16 *) instruction) {
+	case 0x0101:	/* pr	 */
+	case 0xb25a:	/* bsa	 */
+	case 0xb240:	/* bakr  */
+	case 0xb258:	/* bsg	 */
+	case 0xb218:	/* pc	 */
+	case 0xb228:	/* pt	 */
+		return -EINVAL;
+	}
+	return 0;
+}
+
+void __kprobes get_instruction_type(struct arch_specific_insn *ainsn)
+{
+	/* default fixup method */
+	ainsn->fixup = FIXUP_PSW_NORMAL;
+
+	/* save r1 operand */
+	ainsn->reg = (*ainsn->insn & 0xf0) >> 4;
+
+	/* save the instruction length (pop 5-5) in bytes */
+	switch (*(__u8 *) (ainsn->insn) >> 6) {
+	case 0:
+		ainsn->ilen = 2;
+		break;
+	case 1:
+	case 2:
+		ainsn->ilen = 4;
+		break;
+	case 3:
+		ainsn->ilen = 6;
+		break;
+	}
+
+	switch (*(__u8 *) ainsn->insn) {
+	case 0x05:	/* balr	*/
+	case 0x0d:	/* basr */
+		ainsn->fixup = FIXUP_RETURN_REGISTER;
+		/* if r2 = 0, no branch will be taken */
+		if ((*ainsn->insn & 0x0f) == 0)
+			ainsn->fixup |= FIXUP_BRANCH_NOT_TAKEN;
+		break;
+	case 0x06:	/* bctr	*/
+	case 0x07:	/* bcr	*/
+		ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
+		break;
+	case 0x45:	/* bal	*/
+	case 0x4d:	/* bas	*/
+		ainsn->fixup = FIXUP_RETURN_REGISTER;
+		break;
+	case 0x47:	/* bc	*/
+	case 0x46:	/* bct	*/
+	case 0x86:	/* bxh	*/
+	case 0x87:	/* bxle	*/
+		ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
+		break;
+	case 0x82:	/* lpsw	*/
+		ainsn->fixup = FIXUP_NOT_REQUIRED;
+		break;
+	case 0xb2:	/* lpswe */
+		if (*(((__u8 *) ainsn->insn) + 1) == 0xb2) {
+			ainsn->fixup = FIXUP_NOT_REQUIRED;
+		}
+		break;
+	case 0xa7:	/* bras	*/
+		if ((*ainsn->insn & 0x0f) == 0x05) {
+			ainsn->fixup |= FIXUP_RETURN_REGISTER;
+		}
+		break;
+	case 0xc0:
+		if ((*ainsn->insn & 0x0f) == 0x00  /* larl  */
+			|| (*ainsn->insn & 0x0f) == 0x05) /* brasl */
+		ainsn->fixup |= FIXUP_RETURN_REGISTER;
+		break;
+	case 0xeb:
+		if (*(((__u8 *) ainsn->insn) + 5 ) == 0x44 ||	/* bxhg  */
+			*(((__u8 *) ainsn->insn) + 5) == 0x45) {/* bxleg */
+			ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
+		}
+		break;
+	case 0xe3:	/* bctg	*/
+		if (*(((__u8 *) ainsn->insn) + 5) == 0x46) {
+			ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
+		}
+		break;
+	}
+}
+
+static int __kprobes swap_instruction(void *aref)
+{
+	struct ins_replace_args *args = aref;
+	u32 *addr;
+	u32 instr;
+	int err = -EFAULT;
+
+	/*
+	 * Text segment is read-only, hence we use stura to bypass dynamic
+	 * address translation to exchange the instruction. Since stura
+	 * always operates on four bytes, but we only want to exchange two
+	 * bytes do some calculations to get things right. In addition we
+	 * shall not cross any page boundaries (vmalloc area!) when writing
+	 * the new instruction.
+	 */
+	addr = (u32 *)((unsigned long)args->ptr & -4UL);
+	if ((unsigned long)args->ptr & 2)
+		instr = ((*addr) & 0xffff0000) | args->new;
+	else
+		instr = ((*addr) & 0x0000ffff) | args->new << 16;
+
+	asm volatile(
+		"	lra	%1,0(%1)\n"
+		"0:	stura	%2,%1\n"
+		"1:	la	%0,0\n"
+		"2:\n"
+		EX_TABLE(0b,2b)
+		: "+d" (err)
+		: "a" (addr), "d" (instr)
+		: "memory", "cc");
+
+	return err;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long status = kcb->kprobe_status;
+	struct ins_replace_args args;
+
+	args.ptr = p->addr;
+	args.old = p->opcode;
+	args.new = BREAKPOINT_INSTRUCTION;
+
+	kcb->kprobe_status = KPROBE_SWAP_INST;
+	stop_machine_run(swap_instruction, &args, NR_CPUS);
+	kcb->kprobe_status = status;
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long status = kcb->kprobe_status;
+	struct ins_replace_args args;
+
+	args.ptr = p->addr;
+	args.old = BREAKPOINT_INSTRUCTION;
+	args.new = p->opcode;
+
+	kcb->kprobe_status = KPROBE_SWAP_INST;
+	stop_machine_run(swap_instruction, &args, NR_CPUS);
+	kcb->kprobe_status = status;
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	mutex_lock(&kprobe_mutex);
+	free_insn_slot(p->ainsn.insn, 0);
+	mutex_unlock(&kprobe_mutex);
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	per_cr_bits kprobe_per_regs[1];
+
+	memset(kprobe_per_regs, 0, sizeof(per_cr_bits));
+	regs->psw.addr = (unsigned long)p->ainsn.insn | PSW_ADDR_AMODE;
+
+	/* Set up the per control reg info, will pass to lctl */
+	kprobe_per_regs[0].em_instruction_fetch = 1;
+	kprobe_per_regs[0].starting_addr = (unsigned long)p->ainsn.insn;
+	kprobe_per_regs[0].ending_addr = (unsigned long)p->ainsn.insn + 1;
+
+	/* Set the PER control regs, turns on single step for this address */
+	__ctl_load(kprobe_per_regs, 9, 11);
+	regs->psw.mask |= PSW_MASK_PER;
+	regs->psw.mask &= ~(PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK);
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.kprobe_saved_imask = kcb->kprobe_saved_imask;
+	memcpy(kcb->prev_kprobe.kprobe_saved_ctl, kcb->kprobe_saved_ctl,
+					sizeof(kcb->kprobe_saved_ctl));
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_saved_imask = kcb->prev_kprobe.kprobe_saved_imask;
+	memcpy(kcb->kprobe_saved_ctl, kcb->prev_kprobe.kprobe_saved_ctl,
+					sizeof(kcb->kprobe_saved_ctl));
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+						struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	/* Save the interrupt and per flags */
+	kcb->kprobe_saved_imask = regs->psw.mask &
+	    (PSW_MASK_PER | PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK);
+	/* Save the control regs that govern PER */
+	__ctl_store(kcb->kprobe_saved_ctl, 9, 11);
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+					struct pt_regs *regs)
+{
+	ri->ret_addr = (kprobe_opcode_t *) regs->gprs[14];
+
+	/* Replace the return addr with trampoline addr */
+	regs->gprs[14] = (unsigned long)&kretprobe_trampoline;
+}
+
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	unsigned long *addr = (unsigned long *)
+		((regs->psw.addr & PSW_ADDR_INSN) - 2);
+	struct kprobe_ctlblk *kcb;
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kcb->kprobe_status == KPROBE_HIT_SS &&
+			    *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+				regs->psw.mask &= ~PSW_MASK_PER;
+				regs->psw.mask |= kcb->kprobe_saved_imask;
+				goto no_kprobe;
+			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+		} else {
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs)) {
+				goto ss_probe;
+			}
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p)
+		/*
+		 * No kprobe at this address. The fault has not been
+		 * caused by a kprobe breakpoint. The race of breakpoint
+		 * vs. kprobe remove does not exist because on s390 we
+		 * use stop_machine_run to arm/disarm the breakpoints.
+		 */
+		goto no_kprobe;
+
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+	set_current_kprobe(p, regs, kcb);
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+
+ss_probe:
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * Function return probe trampoline:
+ *	- init_kprobes() establishes a probepoint here
+ *	- When the probed function returns, this probe
+ *		causes the handlers to fire
+ */
+void kretprobe_trampoline_holder(void)
+{
+	asm volatile(".global kretprobe_trampoline\n"
+		     "kretprobe_trampoline: bcr 0,0\n");
+}
+
+/*
+ * Called when the probe at kretprobe trampoline is hit
+ */
+static int __kprobes trampoline_probe_handler(struct kprobe *p,
+					      struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(current);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more then one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *	 function, the first instance's ret_addr will point to the
+	 *	 real return address, and all the rest will point to
+	 *	 kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address) {
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+		}
+	}
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
+
+	reset_current_kprobe();
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "breakpoint"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ */
+static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	regs->psw.addr &= PSW_ADDR_INSN;
+
+	if (p->ainsn.fixup & FIXUP_PSW_NORMAL)
+		regs->psw.addr = (unsigned long)p->addr +
+				((unsigned long)regs->psw.addr -
+				 (unsigned long)p->ainsn.insn);
+
+	if (p->ainsn.fixup & FIXUP_BRANCH_NOT_TAKEN)
+		if ((unsigned long)regs->psw.addr -
+		    (unsigned long)p->ainsn.insn == p->ainsn.ilen)
+			regs->psw.addr = (unsigned long)p->addr + p->ainsn.ilen;
+
+	if (p->ainsn.fixup & FIXUP_RETURN_REGISTER)
+		regs->gprs[p->ainsn.reg] = ((unsigned long)p->addr +
+						(regs->gprs[p->ainsn.reg] -
+						(unsigned long)p->ainsn.insn))
+						| PSW_ADDR_AMODE;
+
+	regs->psw.addr |= PSW_ADDR_AMODE;
+	/* turn off PER mode */
+	regs->psw.mask &= ~PSW_MASK_PER;
+	/* Restore the original per control regs */
+	__ctl_load(kcb->kprobe_saved_ctl, 9, 11);
+	regs->psw.mask |= kcb->kprobe_saved_imask;
+}
+
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs);
+
+	/*Restore back the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, psw mask
+	 * will have PER set, in which case, continue the remaining processing
+	 * of do_single_step, as if this is not a probe hit.
+	 */
+	if (regs->psw.mask & PSW_MASK_PER) {
+		return 0;
+	}
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	const struct exception_table_entry *entry;
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_SWAP_INST:
+		/* We are here because the instruction replacement failed */
+		return 0;
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the nip points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		regs->psw.addr = (unsigned long)cur->addr | PSW_ADDR_AMODE;
+		regs->psw.mask &= ~PSW_MASK_PER;
+		regs->psw.mask |= kcb->kprobe_saved_imask;
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+		entry = search_exception_tables(regs->psw.addr & PSW_ADDR_INSN);
+		if (entry) {
+			regs->psw.addr = entry->fixup | PSW_ADDR_AMODE;
+			return 1;
+		}
+
+		/*
+		 * fixup_exception() could not handle it,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine to for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	switch (val) {
+	case DIE_BPT:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_SSTEP:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_TRAP:
+		/* kprobe_running() needs smp_processor_id() */
+		preempt_disable();
+		if (kprobe_running() &&
+		    kprobe_fault_handler(args->regs, args->trapnr))
+			ret = NOTIFY_STOP;
+		preempt_enable();
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	unsigned long addr;
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	memcpy(&kcb->jprobe_saved_regs, regs, sizeof(struct pt_regs));
+
+	/* setup return addr to the jprobe handler routine */
+	regs->psw.addr = (unsigned long)(jp->entry) | PSW_ADDR_AMODE;
+
+	/* r14 is the function return address */
+	kcb->jprobe_saved_r14 = (unsigned long)regs->gprs[14];
+	/* r15 is the stack pointer */
+	kcb->jprobe_saved_r15 = (unsigned long)regs->gprs[15];
+	addr = (unsigned long)kcb->jprobe_saved_r15;
+
+	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *) addr,
+	       MIN_STACK_SIZE(addr));
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	asm volatile(".word 0x0002");
+}
+
+void __kprobes jprobe_return_end(void)
+{
+	asm volatile("bcr 0,0");
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_r15);
+
+	/* Put the regs back */
+	memcpy(regs, &kcb->jprobe_saved_regs, sizeof(struct pt_regs));
+	/* put the stack back */
+	memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
+	       MIN_STACK_SIZE(stack_addr));
+	preempt_enable_no_resched();
+	return 1;
+}
+
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) & kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+
+int __init arch_init_kprobes(void)
+{
+	return register_kprobe(&trampoline_p);
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *) & kretprobe_trampoline)
+		return 1;
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/s390/kernel/kprobes.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,672 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2006
- *
- * s390 port, used ppc64 as template. Mike Grundy <grundym@us.ibm.com>
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/preempt.h>
-#include <linux/stop_machine.h>
-#include <linux/kdebug.h>
-#include <asm/cacheflush.h>
-#include <asm/sections.h>
-#include <asm/uaccess.h>
-#include <linux/module.h>
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* Make sure the probe isn't going on a difficult instruction */
-	if (is_prohibited_opcode((kprobe_opcode_t *) p->addr))
-		return -EINVAL;
-
-	if ((unsigned long)p->addr & 0x01) {
-		printk("Attempt to register kprobe at an unaligned address\n");
-		return -EINVAL;
-		}
-
-	/* Use the get_insn_slot() facility for correctness */
-	if (!(p->ainsn.insn = get_insn_slot()))
-		return -ENOMEM;
-
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-
-	get_instruction_type(&p->ainsn);
-	p->opcode = *p->addr;
-	return 0;
-}
-
-int __kprobes is_prohibited_opcode(kprobe_opcode_t *instruction)
-{
-	switch (*(__u8 *) instruction) {
-	case 0x0c:	/* bassm */
-	case 0x0b:	/* bsm	 */
-	case 0x83:	/* diag  */
-	case 0x44:	/* ex	 */
-		return -EINVAL;
-	}
-	switch (*(__u16 *) instruction) {
-	case 0x0101:	/* pr	 */
-	case 0xb25a:	/* bsa	 */
-	case 0xb240:	/* bakr  */
-	case 0xb258:	/* bsg	 */
-	case 0xb218:	/* pc	 */
-	case 0xb228:	/* pt	 */
-		return -EINVAL;
-	}
-	return 0;
-}
-
-void __kprobes get_instruction_type(struct arch_specific_insn *ainsn)
-{
-	/* default fixup method */
-	ainsn->fixup = FIXUP_PSW_NORMAL;
-
-	/* save r1 operand */
-	ainsn->reg = (*ainsn->insn & 0xf0) >> 4;
-
-	/* save the instruction length (pop 5-5) in bytes */
-	switch (*(__u8 *) (ainsn->insn) >> 6) {
-	case 0:
-		ainsn->ilen = 2;
-		break;
-	case 1:
-	case 2:
-		ainsn->ilen = 4;
-		break;
-	case 3:
-		ainsn->ilen = 6;
-		break;
-	}
-
-	switch (*(__u8 *) ainsn->insn) {
-	case 0x05:	/* balr	*/
-	case 0x0d:	/* basr */
-		ainsn->fixup = FIXUP_RETURN_REGISTER;
-		/* if r2 = 0, no branch will be taken */
-		if ((*ainsn->insn & 0x0f) == 0)
-			ainsn->fixup |= FIXUP_BRANCH_NOT_TAKEN;
-		break;
-	case 0x06:	/* bctr	*/
-	case 0x07:	/* bcr	*/
-		ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
-		break;
-	case 0x45:	/* bal	*/
-	case 0x4d:	/* bas	*/
-		ainsn->fixup = FIXUP_RETURN_REGISTER;
-		break;
-	case 0x47:	/* bc	*/
-	case 0x46:	/* bct	*/
-	case 0x86:	/* bxh	*/
-	case 0x87:	/* bxle	*/
-		ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
-		break;
-	case 0x82:	/* lpsw	*/
-		ainsn->fixup = FIXUP_NOT_REQUIRED;
-		break;
-	case 0xb2:	/* lpswe */
-		if (*(((__u8 *) ainsn->insn) + 1) == 0xb2) {
-			ainsn->fixup = FIXUP_NOT_REQUIRED;
-		}
-		break;
-	case 0xa7:	/* bras	*/
-		if ((*ainsn->insn & 0x0f) == 0x05) {
-			ainsn->fixup |= FIXUP_RETURN_REGISTER;
-		}
-		break;
-	case 0xc0:
-		if ((*ainsn->insn & 0x0f) == 0x00  /* larl  */
-			|| (*ainsn->insn & 0x0f) == 0x05) /* brasl */
-		ainsn->fixup |= FIXUP_RETURN_REGISTER;
-		break;
-	case 0xeb:
-		if (*(((__u8 *) ainsn->insn) + 5 ) == 0x44 ||	/* bxhg  */
-			*(((__u8 *) ainsn->insn) + 5) == 0x45) {/* bxleg */
-			ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
-		}
-		break;
-	case 0xe3:	/* bctg	*/
-		if (*(((__u8 *) ainsn->insn) + 5) == 0x46) {
-			ainsn->fixup = FIXUP_BRANCH_NOT_TAKEN;
-		}
-		break;
-	}
-}
-
-static int __kprobes swap_instruction(void *aref)
-{
-	struct ins_replace_args *args = aref;
-	u32 *addr;
-	u32 instr;
-	int err = -EFAULT;
-
-	/*
-	 * Text segment is read-only, hence we use stura to bypass dynamic
-	 * address translation to exchange the instruction. Since stura
-	 * always operates on four bytes, but we only want to exchange two
-	 * bytes do some calculations to get things right. In addition we
-	 * shall not cross any page boundaries (vmalloc area!) when writing
-	 * the new instruction.
-	 */
-	addr = (u32 *)((unsigned long)args->ptr & -4UL);
-	if ((unsigned long)args->ptr & 2)
-		instr = ((*addr) & 0xffff0000) | args->new;
-	else
-		instr = ((*addr) & 0x0000ffff) | args->new << 16;
-
-	asm volatile(
-		"	lra	%1,0(%1)\n"
-		"0:	stura	%2,%1\n"
-		"1:	la	%0,0\n"
-		"2:\n"
-		EX_TABLE(0b,2b)
-		: "+d" (err)
-		: "a" (addr), "d" (instr)
-		: "memory", "cc");
-
-	return err;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long status = kcb->kprobe_status;
-	struct ins_replace_args args;
-
-	args.ptr = p->addr;
-	args.old = p->opcode;
-	args.new = BREAKPOINT_INSTRUCTION;
-
-	kcb->kprobe_status = KPROBE_SWAP_INST;
-	stop_machine_run(swap_instruction, &args, NR_CPUS);
-	kcb->kprobe_status = status;
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long status = kcb->kprobe_status;
-	struct ins_replace_args args;
-
-	args.ptr = p->addr;
-	args.old = BREAKPOINT_INSTRUCTION;
-	args.new = p->opcode;
-
-	kcb->kprobe_status = KPROBE_SWAP_INST;
-	stop_machine_run(swap_instruction, &args, NR_CPUS);
-	kcb->kprobe_status = status;
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	per_cr_bits kprobe_per_regs[1];
-
-	memset(kprobe_per_regs, 0, sizeof(per_cr_bits));
-	regs->psw.addr = (unsigned long)p->ainsn.insn | PSW_ADDR_AMODE;
-
-	/* Set up the per control reg info, will pass to lctl */
-	kprobe_per_regs[0].em_instruction_fetch = 1;
-	kprobe_per_regs[0].starting_addr = (unsigned long)p->ainsn.insn;
-	kprobe_per_regs[0].ending_addr = (unsigned long)p->ainsn.insn + 1;
-
-	/* Set the PER control regs, turns on single step for this address */
-	__ctl_load(kprobe_per_regs, 9, 11);
-	regs->psw.mask |= PSW_MASK_PER;
-	regs->psw.mask &= ~(PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK);
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.kprobe_saved_imask = kcb->kprobe_saved_imask;
-	memcpy(kcb->prev_kprobe.kprobe_saved_ctl, kcb->kprobe_saved_ctl,
-					sizeof(kcb->kprobe_saved_ctl));
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_saved_imask = kcb->prev_kprobe.kprobe_saved_imask;
-	memcpy(kcb->kprobe_saved_ctl, kcb->prev_kprobe.kprobe_saved_ctl,
-					sizeof(kcb->kprobe_saved_ctl));
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-						struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	/* Save the interrupt and per flags */
-	kcb->kprobe_saved_imask = regs->psw.mask &
-	    (PSW_MASK_PER | PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK);
-	/* Save the control regs that govern PER */
-	__ctl_store(kcb->kprobe_saved_ctl, 9, 11);
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-					struct pt_regs *regs)
-{
-	ri->ret_addr = (kprobe_opcode_t *) regs->gprs[14];
-
-	/* Replace the return addr with trampoline addr */
-	regs->gprs[14] = (unsigned long)&kretprobe_trampoline;
-}
-
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	int ret = 0;
-	unsigned long *addr = (unsigned long *)
-		((regs->psw.addr & PSW_ADDR_INSN) - 2);
-	struct kprobe_ctlblk *kcb;
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-			    *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->psw.mask &= ~PSW_MASK_PER;
-				regs->psw.mask |= kcb->kprobe_saved_imask;
-				goto no_kprobe;
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-		} else {
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p)
-		/*
-		 * No kprobe at this address. The fault has not been
-		 * caused by a kprobe breakpoint. The race of breakpoint
-		 * vs. kprobe remove does not exist because on s390 we
-		 * use stop_machine_run to arm/disarm the breakpoints.
-		 */
-		goto no_kprobe;
-
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-	set_current_kprobe(p, regs, kcb);
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/*
- * Function return probe trampoline:
- *	- init_kprobes() establishes a probepoint here
- *	- When the probed function returns, this probe
- *		causes the handlers to fire
- */
-void kretprobe_trampoline_holder(void)
-{
-	asm volatile(".global kretprobe_trampoline\n"
-		     "kretprobe_trampoline: bcr 0,0\n");
-}
-
-/*
- * Called when the probe at kretprobe trampoline is hit
- */
-static int __kprobes trampoline_probe_handler(struct kprobe *p,
-					      struct pt_regs *regs)
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *	 function, the first instance's ret_addr will point to the
-	 *	 real return address, and all the rest will point to
-	 *	 kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address) {
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-		}
-	}
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
-
-	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	preempt_enable_no_resched();
-
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "breakpoint"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- */
-static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	regs->psw.addr &= PSW_ADDR_INSN;
-
-	if (p->ainsn.fixup & FIXUP_PSW_NORMAL)
-		regs->psw.addr = (unsigned long)p->addr +
-				((unsigned long)regs->psw.addr -
-				 (unsigned long)p->ainsn.insn);
-
-	if (p->ainsn.fixup & FIXUP_BRANCH_NOT_TAKEN)
-		if ((unsigned long)regs->psw.addr -
-		    (unsigned long)p->ainsn.insn == p->ainsn.ilen)
-			regs->psw.addr = (unsigned long)p->addr + p->ainsn.ilen;
-
-	if (p->ainsn.fixup & FIXUP_RETURN_REGISTER)
-		regs->gprs[p->ainsn.reg] = ((unsigned long)p->addr +
-						(regs->gprs[p->ainsn.reg] -
-						(unsigned long)p->ainsn.insn))
-						| PSW_ADDR_AMODE;
-
-	regs->psw.addr |= PSW_ADDR_AMODE;
-	/* turn off PER mode */
-	regs->psw.mask &= ~PSW_MASK_PER;
-	/* Restore the original per control regs */
-	__ctl_load(kcb->kprobe_saved_ctl, 9, 11);
-	regs->psw.mask |= kcb->kprobe_saved_imask;
-}
-
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs);
-
-	/*Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	/*
-	 * if somebody else is singlestepping across a probe point, psw mask
-	 * will have PER set, in which case, continue the remaining processing
-	 * of do_single_step, as if this is not a probe hit.
-	 */
-	if (regs->psw.mask & PSW_MASK_PER) {
-		return 0;
-	}
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	const struct exception_table_entry *entry;
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_SWAP_INST:
-		/* We are here because the instruction replacement failed */
-		return 0;
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the nip points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->psw.addr = (unsigned long)cur->addr | PSW_ADDR_AMODE;
-		regs->psw.mask &= ~PSW_MASK_PER;
-		regs->psw.mask |= kcb->kprobe_saved_imask;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-		entry = search_exception_tables(regs->psw.addr & PSW_ADDR_INSN);
-		if (entry) {
-			regs->psw.addr = entry->fixup | PSW_ADDR_AMODE;
-			return 1;
-		}
-
-		/*
-		 * fixup_exception() could not handle it,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine to for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	switch (val) {
-	case DIE_BPT:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_SSTEP:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_TRAP:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		preempt_enable();
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr;
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	memcpy(&kcb->jprobe_saved_regs, regs, sizeof(struct pt_regs));
-
-	/* setup return addr to the jprobe handler routine */
-	regs->psw.addr = (unsigned long)(jp->entry) | PSW_ADDR_AMODE;
-
-	/* r14 is the function return address */
-	kcb->jprobe_saved_r14 = (unsigned long)regs->gprs[14];
-	/* r15 is the stack pointer */
-	kcb->jprobe_saved_r15 = (unsigned long)regs->gprs[15];
-	addr = (unsigned long)kcb->jprobe_saved_r15;
-
-	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *) addr,
-	       MIN_STACK_SIZE(addr));
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	asm volatile(".word 0x0002");
-}
-
-void __kprobes jprobe_return_end(void)
-{
-	asm volatile("bcr 0,0");
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_r15);
-
-	/* Put the regs back */
-	memcpy(regs, &kcb->jprobe_saved_regs, sizeof(struct pt_regs));
-	/* put the stack back */
-	memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-	       MIN_STACK_SIZE(stack_addr));
-	preempt_enable_no_resched();
-	return 1;
-}
-
-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) & kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-
-int __init arch_init_kprobes(void)
-{
-	return register_kprobe(&trampoline_p);
-}
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-	if (p->addr == (kprobe_opcode_t *) & kretprobe_trampoline)
-		return 1;
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/sparc64/instrumentation/kprobes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/sparc64/instrumentation/kprobes.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,487 @@
+/* arch/sparc64/kernel/kprobes.c
+ *
+ * Copyright (C) 2004 David S. Miller <davem@davemloft.net>
+ */
+
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <asm/signal.h>
+#include <asm/cacheflush.h>
+#include <asm/uaccess.h>
+
+/* We do not have hardware single-stepping on sparc64.
+ * So we implement software single-stepping with breakpoint
+ * traps.  The top-level scheme is similar to that used
+ * in the x86 kprobes implementation.
+ *
+ * In the kprobe->ainsn.insn[] array we store the original
+ * instruction at index zero and a break instruction at
+ * index one.
+ *
+ * When we hit a kprobe we:
+ * - Run the pre-handler
+ * - Remember "regs->tnpc" and interrupt level stored in
+ *   "regs->tstate" so we can restore them later
+ * - Disable PIL interrupts
+ * - Set regs->tpc to point to kprobe->ainsn.insn[0]
+ * - Set regs->tnpc to point to kprobe->ainsn.insn[1]
+ * - Mark that we are actively in a kprobe
+ *
+ * At this point we wait for the second breakpoint at
+ * kprobe->ainsn.insn[1] to hit.  When it does we:
+ * - Run the post-handler
+ * - Set regs->tpc to "remembered" regs->tnpc stored above,
+ *   restore the PIL interrupt level in "regs->tstate" as well
+ * - Make any adjustments necessary to regs->tnpc in order
+ *   to handle relative branches correctly.  See below.
+ * - Mark that we are no longer actively in a kprobe.
+ */
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	p->ainsn.insn[0] = *p->addr;
+	flushi(&p->ainsn.insn[0]);
+
+	p->ainsn.insn[1] = BREAKPOINT_INSTRUCTION_2;
+	flushi(&p->ainsn.insn[1]);
+
+	p->opcode = *p->addr;
+	return 0;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	flushi(p->addr);
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	*p->addr = p->opcode;
+	flushi(p->addr);
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.orig_tnpc = kcb->kprobe_orig_tnpc;
+	kcb->prev_kprobe.orig_tstate_pil = kcb->kprobe_orig_tstate_pil;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_orig_tnpc = kcb->prev_kprobe.orig_tnpc;
+	kcb->kprobe_orig_tstate_pil = kcb->prev_kprobe.orig_tstate_pil;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+				struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	kcb->kprobe_orig_tnpc = regs->tnpc;
+	kcb->kprobe_orig_tstate_pil = (regs->tstate & TSTATE_PIL);
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs,
+			struct kprobe_ctlblk *kcb)
+{
+	regs->tstate |= TSTATE_PIL;
+
+	/*single step inline, if it a breakpoint instruction*/
+	if (p->opcode == BREAKPOINT_INSTRUCTION) {
+		regs->tpc = (unsigned long) p->addr;
+		regs->tnpc = kcb->kprobe_orig_tnpc;
+	} else {
+		regs->tpc = (unsigned long) &p->ainsn.insn[0];
+		regs->tnpc = (unsigned long) &p->ainsn.insn[1];
+	}
+}
+
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	void *addr = (void *) regs->tpc;
+	int ret = 0;
+	struct kprobe_ctlblk *kcb;
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kcb->kprobe_status == KPROBE_HIT_SS) {
+				regs->tstate = ((regs->tstate & ~TSTATE_PIL) |
+					kcb->kprobe_orig_tstate_pil);
+				goto no_kprobe;
+			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			kcb->kprobe_status = KPROBE_REENTER;
+			prepare_singlestep(p, regs, kcb);
+			return 1;
+		} else {
+			if (*(u32 *)addr != BREAKPOINT_INSTRUCTION) {
+			/* The breakpoint instruction was removed by
+			 * another cpu right after we hit, no further
+			 * handling of this interrupt is appropriate
+			 */
+				ret = 1;
+				goto no_kprobe;
+			}
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs))
+				goto ss_probe;
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (*(u32 *)addr != BREAKPOINT_INSTRUCTION) {
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 */
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	set_current_kprobe(p, regs, kcb);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+	if (p->pre_handler && p->pre_handler(p, regs))
+		return 1;
+
+ss_probe:
+	prepare_singlestep(p, regs, kcb);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/* If INSN is a relative control transfer instruction,
+ * return the corrected branch destination value.
+ *
+ * regs->tpc and regs->tnpc still hold the values of the
+ * program counters at the time of trap due to the execution
+ * of the BREAKPOINT_INSTRUCTION_2 at p->ainsn.insn[1]
+ * 
+ */
+static unsigned long __kprobes relbranch_fixup(u32 insn, struct kprobe *p,
+					       struct pt_regs *regs)
+{
+	unsigned long real_pc = (unsigned long) p->addr;
+
+	/* Branch not taken, no mods necessary.  */
+	if (regs->tnpc == regs->tpc + 0x4UL)
+		return real_pc + 0x8UL;
+
+	/* The three cases are call, branch w/prediction,
+	 * and traditional branch.
+	 */
+	if ((insn & 0xc0000000) == 0x40000000 ||
+	    (insn & 0xc1c00000) == 0x00400000 ||
+	    (insn & 0xc1c00000) == 0x00800000) {
+		unsigned long ainsn_addr;
+
+		ainsn_addr = (unsigned long) &p->ainsn.insn[0];
+
+		/* The instruction did all the work for us
+		 * already, just apply the offset to the correct
+		 * instruction location.
+		 */
+		return (real_pc + (regs->tnpc - ainsn_addr));
+	}
+
+	/* It is jmpl or some other absolute PC modification instruction,
+	 * leave NPC as-is.
+	 */
+	return regs->tnpc;
+}
+
+/* If INSN is an instruction which writes it's PC location
+ * into a destination register, fix that up.
+ */
+static void __kprobes retpc_fixup(struct pt_regs *regs, u32 insn,
+				  unsigned long real_pc)
+{
+	unsigned long *slot = NULL;
+
+	/* Simplest case is 'call', which always uses %o7 */
+	if ((insn & 0xc0000000) == 0x40000000) {
+		slot = &regs->u_regs[UREG_I7];
+	}
+
+	/* 'jmpl' encodes the register inside of the opcode */
+	if ((insn & 0xc1f80000) == 0x81c00000) {
+		unsigned long rd = ((insn >> 25) & 0x1f);
+
+		if (rd <= 15) {
+			slot = &regs->u_regs[rd];
+		} else {
+			/* Hard case, it goes onto the stack. */
+			flushw_all();
+
+			rd -= 16;
+			slot = (unsigned long *)
+				(regs->u_regs[UREG_FP] + STACK_BIAS);
+			slot += rd;
+		}
+	}
+	if (slot != NULL)
+		*slot = real_pc;
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction which has been replaced by the breakpoint
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is &p->ainsn.insn[0].
+ *
+ * This function prepares to return from the post-single-step
+ * breakpoint trap.
+ */
+static void __kprobes resume_execution(struct kprobe *p,
+		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+{
+	u32 insn = p->ainsn.insn[0];
+
+	regs->tnpc = relbranch_fixup(insn, p, regs);
+
+	/* This assignment must occur after relbranch_fixup() */
+	regs->tpc = kcb->kprobe_orig_tnpc;
+
+	retpc_fixup(regs, insn, (unsigned long) p->addr);
+
+	regs->tstate = ((regs->tstate & ~TSTATE_PIL) |
+			kcb->kprobe_orig_tstate_pil);
+}
+
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs, kcb);
+
+	/*Restore back the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	const struct exception_table_entry *entry;
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the tpc points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		regs->tpc = (unsigned long)cur->addr;
+		regs->tnpc = kcb->kprobe_orig_tnpc;
+		regs->tstate = ((regs->tstate & ~TSTATE_PIL) |
+				kcb->kprobe_orig_tstate_pil);
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+
+		entry = search_exception_tables(regs->tpc);
+		if (entry) {
+			regs->tpc = entry->fixup;
+			regs->tnpc = regs->tpc + 4;
+			return 1;
+		}
+
+		/*
+		 * fixup_exception() could not handle it,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Wrapper routine to for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	if (args->regs && user_mode(args->regs))
+		return ret;
+
+	switch (val) {
+	case DIE_DEBUG:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_DEBUG_2:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+asmlinkage void __kprobes kprobe_trap(unsigned long trap_level,
+				      struct pt_regs *regs)
+{
+	BUG_ON(trap_level != 0x170 && trap_level != 0x171);
+
+	if (user_mode(regs)) {
+		local_irq_enable();
+		bad_trap(regs, trap_level);
+		return;
+	}
+
+	/* trap_level == 0x170 --> ta 0x70
+	 * trap_level == 0x171 --> ta 0x71
+	 */
+	if (notify_die((trap_level == 0x170) ? DIE_DEBUG : DIE_DEBUG_2,
+		       (trap_level == 0x170) ? "debug" : "debug_2",
+		       regs, 0, trap_level, SIGTRAP) != NOTIFY_STOP)
+		bad_trap(regs, trap_level);
+}
+
+/* Jprobes support.  */
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	memcpy(&(kcb->jprobe_saved_regs), regs, sizeof(*regs));
+
+	regs->tpc  = (unsigned long) jp->entry;
+	regs->tnpc = ((unsigned long) jp->entry) + 0x4UL;
+	regs->tstate |= TSTATE_PIL;
+
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	register unsigned long orig_fp asm("g1");
+
+	orig_fp = kcb->jprobe_saved_regs.u_regs[UREG_FP];
+	__asm__ __volatile__("\n"
+"1:	cmp		%%sp, %0\n\t"
+	"blu,a,pt	%%xcc, 1b\n\t"
+	" restore\n\t"
+	".globl		jprobe_return_trap_instruction\n"
+"jprobe_return_trap_instruction:\n\t"
+	"ta		0x70"
+	: /* no outputs */
+	: "r" (orig_fp));
+}
+
+extern void jprobe_return_trap_instruction(void);
+
+extern void __show_regs(struct pt_regs * regs);
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	u32 *addr = (u32 *) regs->tpc;
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (addr == (u32 *) jprobe_return_trap_instruction) {
+		memcpy(regs, &(kcb->jprobe_saved_regs), sizeof(*regs));
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+
+/* architecture specific initialization */
+int arch_init_kprobes(void)
+{
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/sparc64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sparc64/kernel/kprobes.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,487 +0,0 @@
-/* arch/sparc64/kernel/kprobes.c
- *
- * Copyright (C) 2004 David S. Miller <davem@davemloft.net>
- */
-
-#include <linux/kernel.h>
-#include <linux/kprobes.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-#include <asm/signal.h>
-#include <asm/cacheflush.h>
-#include <asm/uaccess.h>
-
-/* We do not have hardware single-stepping on sparc64.
- * So we implement software single-stepping with breakpoint
- * traps.  The top-level scheme is similar to that used
- * in the x86 kprobes implementation.
- *
- * In the kprobe->ainsn.insn[] array we store the original
- * instruction at index zero and a break instruction at
- * index one.
- *
- * When we hit a kprobe we:
- * - Run the pre-handler
- * - Remember "regs->tnpc" and interrupt level stored in
- *   "regs->tstate" so we can restore them later
- * - Disable PIL interrupts
- * - Set regs->tpc to point to kprobe->ainsn.insn[0]
- * - Set regs->tnpc to point to kprobe->ainsn.insn[1]
- * - Mark that we are actively in a kprobe
- *
- * At this point we wait for the second breakpoint at
- * kprobe->ainsn.insn[1] to hit.  When it does we:
- * - Run the post-handler
- * - Set regs->tpc to "remembered" regs->tnpc stored above,
- *   restore the PIL interrupt level in "regs->tstate" as well
- * - Make any adjustments necessary to regs->tnpc in order
- *   to handle relative branches correctly.  See below.
- * - Mark that we are no longer actively in a kprobe.
- */
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	p->ainsn.insn[0] = *p->addr;
-	flushi(&p->ainsn.insn[0]);
-
-	p->ainsn.insn[1] = BREAKPOINT_INSTRUCTION_2;
-	flushi(&p->ainsn.insn[1]);
-
-	p->opcode = *p->addr;
-	return 0;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	*p->addr = BREAKPOINT_INSTRUCTION;
-	flushi(p->addr);
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	*p->addr = p->opcode;
-	flushi(p->addr);
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.orig_tnpc = kcb->kprobe_orig_tnpc;
-	kcb->prev_kprobe.orig_tstate_pil = kcb->kprobe_orig_tstate_pil;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_orig_tnpc = kcb->prev_kprobe.orig_tnpc;
-	kcb->kprobe_orig_tstate_pil = kcb->prev_kprobe.orig_tstate_pil;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_orig_tnpc = regs->tnpc;
-	kcb->kprobe_orig_tstate_pil = (regs->tstate & TSTATE_PIL);
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs,
-			struct kprobe_ctlblk *kcb)
-{
-	regs->tstate |= TSTATE_PIL;
-
-	/*single step inline, if it a breakpoint instruction*/
-	if (p->opcode == BREAKPOINT_INSTRUCTION) {
-		regs->tpc = (unsigned long) p->addr;
-		regs->tnpc = kcb->kprobe_orig_tnpc;
-	} else {
-		regs->tpc = (unsigned long) &p->ainsn.insn[0];
-		regs->tnpc = (unsigned long) &p->ainsn.insn[1];
-	}
-}
-
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	void *addr = (void *) regs->tpc;
-	int ret = 0;
-	struct kprobe_ctlblk *kcb;
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS) {
-				regs->tstate = ((regs->tstate & ~TSTATE_PIL) |
-					kcb->kprobe_orig_tstate_pil);
-				goto no_kprobe;
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			kcb->kprobe_status = KPROBE_REENTER;
-			prepare_singlestep(p, regs, kcb);
-			return 1;
-		} else {
-			if (*(u32 *)addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs))
-				goto ss_probe;
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*(u32 *)addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 */
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-	if (p->pre_handler && p->pre_handler(p, regs))
-		return 1;
-
-ss_probe:
-	prepare_singlestep(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/* If INSN is a relative control transfer instruction,
- * return the corrected branch destination value.
- *
- * regs->tpc and regs->tnpc still hold the values of the
- * program counters at the time of trap due to the execution
- * of the BREAKPOINT_INSTRUCTION_2 at p->ainsn.insn[1]
- * 
- */
-static unsigned long __kprobes relbranch_fixup(u32 insn, struct kprobe *p,
-					       struct pt_regs *regs)
-{
-	unsigned long real_pc = (unsigned long) p->addr;
-
-	/* Branch not taken, no mods necessary.  */
-	if (regs->tnpc == regs->tpc + 0x4UL)
-		return real_pc + 0x8UL;
-
-	/* The three cases are call, branch w/prediction,
-	 * and traditional branch.
-	 */
-	if ((insn & 0xc0000000) == 0x40000000 ||
-	    (insn & 0xc1c00000) == 0x00400000 ||
-	    (insn & 0xc1c00000) == 0x00800000) {
-		unsigned long ainsn_addr;
-
-		ainsn_addr = (unsigned long) &p->ainsn.insn[0];
-
-		/* The instruction did all the work for us
-		 * already, just apply the offset to the correct
-		 * instruction location.
-		 */
-		return (real_pc + (regs->tnpc - ainsn_addr));
-	}
-
-	/* It is jmpl or some other absolute PC modification instruction,
-	 * leave NPC as-is.
-	 */
-	return regs->tnpc;
-}
-
-/* If INSN is an instruction which writes it's PC location
- * into a destination register, fix that up.
- */
-static void __kprobes retpc_fixup(struct pt_regs *regs, u32 insn,
-				  unsigned long real_pc)
-{
-	unsigned long *slot = NULL;
-
-	/* Simplest case is 'call', which always uses %o7 */
-	if ((insn & 0xc0000000) == 0x40000000) {
-		slot = &regs->u_regs[UREG_I7];
-	}
-
-	/* 'jmpl' encodes the register inside of the opcode */
-	if ((insn & 0xc1f80000) == 0x81c00000) {
-		unsigned long rd = ((insn >> 25) & 0x1f);
-
-		if (rd <= 15) {
-			slot = &regs->u_regs[rd];
-		} else {
-			/* Hard case, it goes onto the stack. */
-			flushw_all();
-
-			rd -= 16;
-			slot = (unsigned long *)
-				(regs->u_regs[UREG_FP] + STACK_BIAS);
-			slot += rd;
-		}
-	}
-	if (slot != NULL)
-		*slot = real_pc;
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction which has been replaced by the breakpoint
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is &p->ainsn.insn[0].
- *
- * This function prepares to return from the post-single-step
- * breakpoint trap.
- */
-static void __kprobes resume_execution(struct kprobe *p,
-		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
-{
-	u32 insn = p->ainsn.insn[0];
-
-	regs->tnpc = relbranch_fixup(insn, p, regs);
-
-	/* This assignment must occur after relbranch_fixup() */
-	regs->tpc = kcb->kprobe_orig_tnpc;
-
-	retpc_fixup(regs, insn, (unsigned long) p->addr);
-
-	regs->tstate = ((regs->tstate & ~TSTATE_PIL) |
-			kcb->kprobe_orig_tstate_pil);
-}
-
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs, kcb);
-
-	/*Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	const struct exception_table_entry *entry;
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the tpc points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->tpc = (unsigned long)cur->addr;
-		regs->tnpc = kcb->kprobe_orig_tnpc;
-		regs->tstate = ((regs->tstate & ~TSTATE_PIL) |
-				kcb->kprobe_orig_tstate_pil);
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-
-		entry = search_exception_tables(regs->tpc);
-		if (entry) {
-			regs->tpc = entry->fixup;
-			regs->tnpc = regs->tpc + 4;
-			return 1;
-		}
-
-		/*
-		 * fixup_exception() could not handle it,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-/*
- * Wrapper routine to for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	if (args->regs && user_mode(args->regs))
-		return ret;
-
-	switch (val) {
-	case DIE_DEBUG:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG_2:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-asmlinkage void __kprobes kprobe_trap(unsigned long trap_level,
-				      struct pt_regs *regs)
-{
-	BUG_ON(trap_level != 0x170 && trap_level != 0x171);
-
-	if (user_mode(regs)) {
-		local_irq_enable();
-		bad_trap(regs, trap_level);
-		return;
-	}
-
-	/* trap_level == 0x170 --> ta 0x70
-	 * trap_level == 0x171 --> ta 0x71
-	 */
-	if (notify_die((trap_level == 0x170) ? DIE_DEBUG : DIE_DEBUG_2,
-		       (trap_level == 0x170) ? "debug" : "debug_2",
-		       regs, 0, trap_level, SIGTRAP) != NOTIFY_STOP)
-		bad_trap(regs, trap_level);
-}
-
-/* Jprobes support.  */
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	memcpy(&(kcb->jprobe_saved_regs), regs, sizeof(*regs));
-
-	regs->tpc  = (unsigned long) jp->entry;
-	regs->tnpc = ((unsigned long) jp->entry) + 0x4UL;
-	regs->tstate |= TSTATE_PIL;
-
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	register unsigned long orig_fp asm("g1");
-
-	orig_fp = kcb->jprobe_saved_regs.u_regs[UREG_FP];
-	__asm__ __volatile__("\n"
-"1:	cmp		%%sp, %0\n\t"
-	"blu,a,pt	%%xcc, 1b\n\t"
-	" restore\n\t"
-	".globl		jprobe_return_trap_instruction\n"
-"jprobe_return_trap_instruction:\n\t"
-	"ta		0x70"
-	: /* no outputs */
-	: "r" (orig_fp));
-}
-
-extern void jprobe_return_trap_instruction(void);
-
-extern void __show_regs(struct pt_regs * regs);
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	u32 *addr = (u32 *) regs->tpc;
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (addr == (u32 *) jprobe_return_trap_instruction) {
-		memcpy(regs, &(kcb->jprobe_saved_regs), sizeof(*regs));
-		preempt_enable_no_resched();
-		return 1;
-	}
-	return 0;
-}
-
-/* architecture specific initialization */
-int arch_init_kprobes(void)
-{
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/avr32/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/avr32/instrumentation/Makefile	2007-10-29 09:51:29.000000000 -0400
+++ linux-2.6-lttng.stable/arch/avr32/instrumentation/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -1,3 +1,5 @@
 #
 # avr32 instrumentation Makefile
 #
+
+obj-$(CONFIG_KPROBES)		+= kprobes.o
Index: linux-2.6-lttng.stable/arch/avr32/kernel/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/avr32/kernel/Makefile	2007-10-29 09:51:07.000000000 -0400
+++ linux-2.6-lttng.stable/arch/avr32/kernel/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -10,4 +10,3 @@ obj-y				+= setup.o traps.o semaphore.o 
 obj-y				+= signal.o sys_avr32.o process.o time.o
 obj-y				+= init_task.o switch_to.o cpu.o
 obj-$(CONFIG_MODULES)		+= module.o avr32_ksyms.o
-obj-$(CONFIG_KPROBES)		+= kprobes.o
Index: linux-2.6-lttng.stable/arch/ia64/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ia64/instrumentation/Makefile	2007-10-29 09:51:29.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ia64/instrumentation/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -8,3 +8,5 @@ DRIVER_OBJS := $(addprefix ../../../driv
 
 oprofile-y := $(DRIVER_OBJS) init.o backtrace.o
 oprofile-$(CONFIG_PERFMON) += perfmon.o
+
+obj-$(CONFIG_KPROBES) += kprobes.o jprobes.o
Index: linux-2.6-lttng.stable/arch/powerpc/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/powerpc/instrumentation/Makefile	2007-10-29 09:51:29.000000000 -0400
+++ linux-2.6-lttng.stable/arch/powerpc/instrumentation/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -17,3 +17,5 @@ oprofile-$(CONFIG_OPROFILE_CELL) += op_m
 oprofile-$(CONFIG_PPC64) += op_model_rs64.o op_model_power4.o op_model_pa6t.o
 oprofile-$(CONFIG_FSL_BOOKE) += op_model_fsl_booke.o
 oprofile-$(CONFIG_6xx) += op_model_7450.o
+
+obj-$(CONFIG_KPROBES) += kprobes.o
Index: linux-2.6-lttng.stable/arch/s390/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/s390/instrumentation/Makefile	2007-10-29 09:51:29.000000000 -0400
+++ linux-2.6-lttng.stable/arch/s390/instrumentation/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -7,3 +7,5 @@ DRIVER_OBJS = $(addprefix ../../../drive
 		timer_int.o )
 
 oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
+
+obj-$(CONFIG_KPROBES)			+= kprobes.o
Index: linux-2.6-lttng.stable/arch/sparc64/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sparc64/instrumentation/Makefile	2007-10-29 09:51:29.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sparc64/instrumentation/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -7,3 +7,5 @@ DRIVER_OBJS = $(addprefix ../../../drive
 		timer_int.o )
 
 oprofile-y				:= $(DRIVER_OBJS) init.o
+
+obj-$(CONFIG_KPROBES)			+= kprobes.o
Index: linux-2.6-lttng.stable/arch/x86/instrumentation/kprobes_32.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/x86/instrumentation/kprobes_32.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,763 @@
+/*
+ *  Kernel Probes (KProbes)
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
+ * Copyright (C) IBM Corporation, 2002, 2004
+ *
+ * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
+ *		Probes initial implementation ( includes contributions from
+ *		Rusty Russell).
+ * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
+ *		interface to access function arguments.
+ * 2005-May	Hien Nguyen <hien@us.ibm.com>, Jim Keniston
+ *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
+ *		<prasanna@in.ibm.com> added function-return probes.
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <linux/kdebug.h>
+#include <asm/cacheflush.h>
+#include <asm/desc.h>
+#include <asm/uaccess.h>
+#include <asm/alternative.h>
+
+void jprobe_return_end(void);
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			     doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
+/* insert a jmp code */
+static __always_inline void set_jmp_op(void *from, void *to)
+{
+	struct __arch_jmp_op {
+		char op;
+		long raddr;
+	} __attribute__((packed)) *jop;
+	jop = (struct __arch_jmp_op *)from;
+	jop->raddr = (long)(to) - ((long)(from) + 5);
+	jop->op = RELATIVEJUMP_INSTRUCTION;
+}
+
+/*
+ * returns non-zero if opcodes can be boosted.
+ */
+static __always_inline int can_boost(kprobe_opcode_t *opcodes)
+{
+#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+	/*
+	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
+	 * Groups, and some special opcodes can not be boost.
+	 */
+	static const unsigned long twobyte_is_boostable[256 / 32] = {
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+		/*      -------------------------------         */
+		W(0x00, 0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0)| /* 00 */
+		W(0x10, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 10 */
+		W(0x20, 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0)| /* 20 */
+		W(0x30, 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 30 */
+		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 40 */
+		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 50 */
+		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1)| /* 60 */
+		W(0x70, 0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1), /* 70 */
+		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 80 */
+		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1), /* 90 */
+		W(0xa0, 1,1,0,1,1,1,0,0,1,1,0,1,1,1,0,1)| /* a0 */
+		W(0xb0, 1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1), /* b0 */
+		W(0xc0, 1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1)| /* c0 */
+		W(0xd0, 0,1,1,1,0,1,0,0,1,1,0,1,1,1,0,1), /* d0 */
+		W(0xe0, 0,1,1,0,0,1,0,0,1,1,0,1,1,1,0,1)| /* e0 */
+		W(0xf0, 0,1,1,1,0,1,0,0,1,1,1,0,1,1,1,0)  /* f0 */
+		/*      -------------------------------         */
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+	};
+#undef W
+	kprobe_opcode_t opcode;
+	kprobe_opcode_t *orig_opcodes = opcodes;
+retry:
+	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+		return 0;
+	opcode = *(opcodes++);
+
+	/* 2nd-byte opcode */
+	if (opcode == 0x0f) {
+		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+			return 0;
+		return test_bit(*opcodes, twobyte_is_boostable);
+	}
+
+	switch (opcode & 0xf0) {
+	case 0x60:
+		if (0x63 < opcode && opcode < 0x67)
+			goto retry; /* prefixes */
+		/* can't boost Address-size override and bound */
+		return (opcode != 0x62 && opcode != 0x67);
+	case 0x70:
+		return 0; /* can't boost conditional jump */
+	case 0xc0:
+		/* can't boost software-interruptions */
+		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
+	case 0xd0:
+		/* can boost AA* and XLAT */
+		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
+	case 0xe0:
+		/* can boost in/out and absolute jmps */
+		return ((opcode & 0x04) || opcode == 0xea);
+	case 0xf0:
+		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
+			goto retry; /* lock/rep(ne) prefix */
+		/* clear and set flags can be boost */
+		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
+	default:
+		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
+			goto retry; /* prefixes */
+		/* can't boost CS override and call */
+		return (opcode != 0x2e && opcode != 0x9a);
+	}
+}
+
+/*
+ * returns non-zero if opcode modifies the interrupt flag.
+ */
+static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
+{
+	switch (opcode) {
+	case 0xfa:		/* cli */
+	case 0xfb:		/* sti */
+	case 0xcf:		/* iret/iretd */
+	case 0x9d:		/* popf/popfd */
+		return 1;
+	}
+	return 0;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* insn: must be on special executable page on i386. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn)
+		return -ENOMEM;
+
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	p->opcode = *p->addr;
+	if (can_boost(p->addr)) {
+		p->ainsn.boostable = 0;
+	} else {
+		p->ainsn.boostable = -1;
+	}
+	return 0;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	text_poke(p->addr, &p->opcode, 1);
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	mutex_lock(&kprobe_mutex);
+	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
+	mutex_unlock(&kprobe_mutex);
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.old_eflags = kcb->kprobe_old_eflags;
+	kcb->prev_kprobe.saved_eflags = kcb->kprobe_saved_eflags;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_old_eflags = kcb->prev_kprobe.old_eflags;
+	kcb->kprobe_saved_eflags = kcb->prev_kprobe.saved_eflags;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+				struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	kcb->kprobe_saved_eflags = kcb->kprobe_old_eflags
+		= (regs->eflags & (TF_MASK | IF_MASK));
+	if (is_IF_modifier(p->opcode))
+		kcb->kprobe_saved_eflags &= ~IF_MASK;
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	regs->eflags |= TF_MASK;
+	regs->eflags &= ~IF_MASK;
+	/*single step inline if the instruction is an int3*/
+	if (p->opcode == BREAKPOINT_INSTRUCTION)
+		regs->eip = (unsigned long)p->addr;
+	else
+		regs->eip = (unsigned long)p->ainsn.insn;
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	unsigned long *sara = (unsigned long *)&regs->esp;
+
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
+
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
+}
+
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate and they
+ * remain disabled thorough out this function.
+ */
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	kprobe_opcode_t *addr;
+	struct kprobe_ctlblk *kcb;
+
+	addr = (kprobe_opcode_t *)(regs->eip - sizeof(kprobe_opcode_t));
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kcb->kprobe_status == KPROBE_HIT_SS &&
+				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+				regs->eflags &= ~TF_MASK;
+				regs->eflags |= kcb->kprobe_saved_eflags;
+				goto no_kprobe;
+			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+		} else {
+			if (*addr != BREAKPOINT_INSTRUCTION) {
+			/* The breakpoint instruction was removed by
+			 * another cpu right after we hit, no further
+			 * handling of this interrupt is appropriate
+			 */
+				regs->eip -= sizeof(kprobe_opcode_t);
+				ret = 1;
+				goto no_kprobe;
+			}
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs)) {
+				goto ss_probe;
+			}
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (*addr != BREAKPOINT_INSTRUCTION) {
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 * Back up over the (now missing) int3 and run
+			 * the original instruction.
+			 */
+			regs->eip -= sizeof(kprobe_opcode_t);
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	set_current_kprobe(p, regs, kcb);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+
+ss_probe:
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+	if (p->ainsn.boostable == 1 && !p->post_handler){
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->eip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+		return 1;
+	}
+#endif
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * For function-return probes, init_kprobes() establishes a probepoint
+ * here. When a retprobed function returns, this probe is hit and
+ * trampoline_probe_handler() runs, calling the kretprobe's handler.
+ */
+ void __kprobes kretprobe_trampoline_holder(void)
+ {
+	asm volatile ( ".global kretprobe_trampoline\n"
+			"kretprobe_trampoline: \n"
+			"	pushf\n"
+			/* skip cs, eip, orig_eax */
+			"	subl $12, %esp\n"
+			"	pushl %fs\n"
+			"	pushl %ds\n"
+			"	pushl %es\n"
+			"	pushl %eax\n"
+			"	pushl %ebp\n"
+			"	pushl %edi\n"
+			"	pushl %esi\n"
+			"	pushl %edx\n"
+			"	pushl %ecx\n"
+			"	pushl %ebx\n"
+			"	movl %esp, %eax\n"
+			"	call trampoline_handler\n"
+			/* move eflags to cs */
+			"	movl 52(%esp), %edx\n"
+			"	movl %edx, 48(%esp)\n"
+			/* save true return address on eflags */
+			"	movl %eax, 52(%esp)\n"
+			"	popl %ebx\n"
+			"	popl %ecx\n"
+			"	popl %edx\n"
+			"	popl %esi\n"
+			"	popl %edi\n"
+			"	popl %ebp\n"
+			"	popl %eax\n"
+			/* skip eip, orig_eax, es, ds, fs */
+			"	addl $20, %esp\n"
+			"	popf\n"
+			"	ret\n");
+}
+
+/*
+ * Called from kretprobe_trampoline
+ */
+fastcall void *__kprobes trampoline_handler(struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(current);
+	/* fixup registers */
+	regs->xcs = __KERNEL_CS | get_kernel_rpl();
+	regs->eip = trampoline_address;
+	regs->orig_eax = 0xffffffff;
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more then one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler){
+			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->rp->handler(ri, regs);
+			__get_cpu_var(current_kprobe) = NULL;
+		}
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+	return (void*)orig_ret_address;
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "int 3"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ *
+ * This function prepares to return from the post-single-step
+ * interrupt.  We have to fix up the stack as follows:
+ *
+ * 0) Except in the case of absolute or indirect jump or call instructions,
+ * the new eip is relative to the copied instruction.  We need to make
+ * it relative to the original instruction.
+ *
+ * 1) If the single-stepped instruction was pushfl, then the TF and IF
+ * flags are set in the just-pushed eflags, and may need to be cleared.
+ *
+ * 2) If the single-stepped instruction was a call, the return address
+ * that is atop the stack is the address following the copied instruction.
+ * We need to make it the address following the original instruction.
+ *
+ * This function also checks instruction size for preparing direct execution.
+ */
+static void __kprobes resume_execution(struct kprobe *p,
+		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+{
+	unsigned long *tos = (unsigned long *)&regs->esp;
+	unsigned long copy_eip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_eip = (unsigned long)p->addr;
+
+	regs->eflags &= ~TF_MASK;
+	switch (p->ainsn.insn[0]) {
+	case 0x9c:		/* pushfl */
+		*tos &= ~(TF_MASK | IF_MASK);
+		*tos |= kcb->kprobe_old_eflags;
+		break;
+	case 0xc2:		/* iret/ret/lret */
+	case 0xc3:
+	case 0xca:
+	case 0xcb:
+	case 0xcf:
+	case 0xea:		/* jmp absolute -- eip is correct */
+		/* eip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
+		goto no_change;
+	case 0xe8:		/* call relative - Fix return addr */
+		*tos = orig_eip + (*tos - copy_eip);
+		break;
+	case 0x9a:		/* call absolute -- same as call absolute, indirect */
+		*tos = orig_eip + (*tos - copy_eip);
+		goto no_change;
+	case 0xff:
+		if ((p->ainsn.insn[1] & 0x30) == 0x10) {
+			/*
+			 * call absolute, indirect
+			 * Fix return addr; eip is correct.
+			 * But this is not boostable
+			 */
+			*tos = orig_eip + (*tos - copy_eip);
+			goto no_change;
+		} else if (((p->ainsn.insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((p->ainsn.insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+			/* eip is correct. And this is boostable */
+			p->ainsn.boostable = 1;
+			goto no_change;
+		}
+	default:
+		break;
+	}
+
+	if (p->ainsn.boostable == 0) {
+		if ((regs->eip > copy_eip) &&
+		    (regs->eip - copy_eip) + 5 < MAX_INSN_SIZE) {
+			/*
+			 * These instructions can be executed directly if it
+			 * jumps back to correct address.
+			 */
+			set_jmp_op((void *)regs->eip,
+				   (void *)orig_eip + (regs->eip - copy_eip));
+			p->ainsn.boostable = 1;
+		} else {
+			p->ainsn.boostable = -1;
+		}
+	}
+
+	regs->eip = orig_eip + (regs->eip - copy_eip);
+
+no_change:
+	return;
+}
+
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate and they
+ * remain disabled thoroughout this function.
+ */
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs, kcb);
+	regs->eflags |= kcb->kprobe_saved_eflags;
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	if (raw_irqs_disabled_flags(regs->eflags))
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+#endif
+
+	/*Restore back the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, eflags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (regs->eflags & TF_MASK)
+		return 0;
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the eip points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		regs->eip = (unsigned long)cur->addr;
+		regs->eflags |= kcb->kprobe_old_eflags;
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+		if (fixup_exception(regs))
+			return 1;
+
+		/*
+		 * fixup_exception() could not handle it,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine to for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	if (args->regs && user_mode_vm(args->regs))
+		return ret;
+
+	switch (val) {
+	case DIE_INT3:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_DEBUG:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_GPF:
+		/* kprobe_running() needs smp_processor_id() */
+		preempt_disable();
+		if (kprobe_running() &&
+		    kprobe_fault_handler(args->regs, args->trapnr))
+			ret = NOTIFY_STOP;
+		preempt_enable();
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	unsigned long addr;
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	kcb->jprobe_saved_regs = *regs;
+	kcb->jprobe_saved_esp = &regs->esp;
+	addr = (unsigned long)(kcb->jprobe_saved_esp);
+
+	/*
+	 * TBD: As Linus pointed out, gcc assumes that the callee
+	 * owns the argument space and could overwrite it, e.g.
+	 * tailcall optimization. So, to be absolutely safe
+	 * we also save and restore enough stack bytes to cover
+	 * the argument area.
+	 */
+	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
+			MIN_STACK_SIZE(addr));
+	regs->eflags &= ~IF_MASK;
+	trace_hardirqs_off();
+	regs->eip = (unsigned long)(jp->entry);
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	asm volatile ("       xchgl   %%ebx,%%esp     \n"
+		      "       int3			\n"
+		      "       .globl jprobe_return_end	\n"
+		      "       jprobe_return_end:	\n"
+		      "       nop			\n"::"b"
+		      (kcb->jprobe_saved_esp):"memory");
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	u8 *addr = (u8 *) (regs->eip - 1);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_esp);
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+
+	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
+		if (&regs->esp != kcb->jprobe_saved_esp) {
+			struct pt_regs *saved_regs =
+			    container_of(kcb->jprobe_saved_esp,
+					    struct pt_regs, esp);
+			printk("current esp %p does not match saved esp %p\n",
+			       &regs->esp, kcb->jprobe_saved_esp);
+			printk("Saved registers for jprobe %p\n", jp);
+			show_registers(saved_regs);
+			printk("Current registers\n");
+			show_registers(regs);
+			BUG();
+		}
+		*regs = kcb->jprobe_saved_regs;
+		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
+		       MIN_STACK_SIZE(stack_addr));
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	return 0;
+}
+
+int __init arch_init_kprobes(void)
+{
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/x86/instrumentation/kprobes_64.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/arch/x86/instrumentation/kprobes_64.c	2007-10-29 09:51:38.000000000 -0400
@@ -0,0 +1,761 @@
+/*
+ *  Kernel Probes (KProbes)
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
+ * Copyright (C) IBM Corporation, 2002, 2004
+ *
+ * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
+ *		Probes initial implementation ( includes contributions from
+ *		Rusty Russell).
+ * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
+ *		interface to access function arguments.
+ * 2004-Oct	Jim Keniston <kenistoj@us.ibm.com> and Prasanna S Panchamukhi
+ *		<prasanna@in.ibm.com> adapted for x86_64
+ * 2005-Mar	Roland McGrath <roland@redhat.com>
+ *		Fixed to handle %rip-relative addressing mode correctly.
+ * 2005-May     Rusty Lynch <rusty.lynch@intel.com>
+ *              Added function return probes functionality
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/preempt.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/alternative.h>
+
+void jprobe_return_end(void);
+static void __kprobes arch_copy_kprobe(struct kprobe *p);
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
+/*
+ * returns non-zero if opcode modifies the interrupt flag.
+ */
+static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
+{
+	switch (*insn) {
+	case 0xfa:		/* cli */
+	case 0xfb:		/* sti */
+	case 0xcf:		/* iret/iretd */
+	case 0x9d:		/* popf/popfd */
+		return 1;
+	}
+
+	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
+		return 1;
+	return 0;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* insn: must be on special executable page on x86_64. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn) {
+		return -ENOMEM;
+	}
+	arch_copy_kprobe(p);
+	return 0;
+}
+
+/*
+ * Determine if the instruction uses the %rip-relative addressing mode.
+ * If it does, return the address of the 32-bit displacement word.
+ * If not, return null.
+ */
+static s32 __kprobes *is_riprel(u8 *insn)
+{
+#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 64))
+	static const u64 onebyte_has_modrm[256 / 64] = {
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+		/*      -------------------------------         */
+		W(0x00, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 00 */
+		W(0x10, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 10 */
+		W(0x20, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 20 */
+		W(0x30, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0), /* 30 */
+		W(0x40, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 40 */
+		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 50 */
+		W(0x60, 0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0)| /* 60 */
+		W(0x70, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 70 */
+		W(0x80, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 80 */
+		W(0x90, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 90 */
+		W(0xa0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* a0 */
+		W(0xb0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* b0 */
+		W(0xc0, 1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0)| /* c0 */
+		W(0xd0, 1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1)| /* d0 */
+		W(0xe0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* e0 */
+		W(0xf0, 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1)  /* f0 */
+		/*      -------------------------------         */
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+	};
+	static const u64 twobyte_has_modrm[256 / 64] = {
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+		/*      -------------------------------         */
+		W(0x00, 1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1)| /* 0f */
+		W(0x10, 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0)| /* 1f */
+		W(0x20, 1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,1)| /* 2f */
+		W(0x30, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 3f */
+		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 4f */
+		W(0x50, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 5f */
+		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 6f */
+		W(0x70, 1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1), /* 7f */
+		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 8f */
+		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 9f */
+		W(0xa0, 0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1)| /* af */
+		W(0xb0, 1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1), /* bf */
+		W(0xc0, 1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)| /* cf */
+		W(0xd0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* df */
+		W(0xe0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* ef */
+		W(0xf0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)  /* ff */
+		/*      -------------------------------         */
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+	};
+#undef	W
+	int need_modrm;
+
+	/* Skip legacy instruction prefixes.  */
+	while (1) {
+		switch (*insn) {
+		case 0x66:
+		case 0x67:
+		case 0x2e:
+		case 0x3e:
+		case 0x26:
+		case 0x64:
+		case 0x65:
+		case 0x36:
+		case 0xf0:
+		case 0xf3:
+		case 0xf2:
+			++insn;
+			continue;
+		}
+		break;
+	}
+
+	/* Skip REX instruction prefix.  */
+	if ((*insn & 0xf0) == 0x40)
+		++insn;
+
+	if (*insn == 0x0f) {	/* Two-byte opcode.  */
+		++insn;
+		need_modrm = test_bit(*insn, twobyte_has_modrm);
+	} else {		/* One-byte opcode.  */
+		need_modrm = test_bit(*insn, onebyte_has_modrm);
+	}
+
+	if (need_modrm) {
+		u8 modrm = *++insn;
+		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
+			/* Displacement follows ModRM byte.  */
+			return (s32 *) ++insn;
+		}
+	}
+
+	/* No %rip-relative addressing mode here.  */
+	return NULL;
+}
+
+static void __kprobes arch_copy_kprobe(struct kprobe *p)
+{
+	s32 *ripdisp;
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
+	ripdisp = is_riprel(p->ainsn.insn);
+	if (ripdisp) {
+		/*
+		 * The copied instruction uses the %rip-relative
+		 * addressing mode.  Adjust the displacement for the
+		 * difference between the original location of this
+		 * instruction and the location of the copy that will
+		 * actually be run.  The tricky bit here is making sure
+		 * that the sign extension happens correctly in this
+		 * calculation, since we need a signed 32-bit result to
+		 * be sign-extended to 64 bits when it's added to the
+		 * %rip value and yield the same 64-bit result that the
+		 * sign-extension of the original signed 32-bit
+		 * displacement would have given.
+		 */
+		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
+		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
+		*ripdisp = disp;
+	}
+	p->opcode = *p->addr;
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	text_poke(p->addr, &p->opcode, 1);
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	mutex_lock(&kprobe_mutex);
+	free_insn_slot(p->ainsn.insn, 0);
+	mutex_unlock(&kprobe_mutex);
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.old_rflags = kcb->kprobe_old_rflags;
+	kcb->prev_kprobe.saved_rflags = kcb->kprobe_saved_rflags;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_old_rflags = kcb->prev_kprobe.old_rflags;
+	kcb->kprobe_saved_rflags = kcb->prev_kprobe.saved_rflags;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+				struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	kcb->kprobe_saved_rflags = kcb->kprobe_old_rflags
+		= (regs->eflags & (TF_MASK | IF_MASK));
+	if (is_IF_modifier(p->ainsn.insn))
+		kcb->kprobe_saved_rflags &= ~IF_MASK;
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	regs->eflags |= TF_MASK;
+	regs->eflags &= ~IF_MASK;
+	/*single step inline if the instruction is an int3*/
+	if (p->opcode == BREAKPOINT_INSTRUCTION)
+		regs->rip = (unsigned long)p->addr;
+	else
+		regs->rip = (unsigned long)p->ainsn.insn;
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	unsigned long *sara = (unsigned long *)regs->rsp;
+
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
+}
+
+int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	kprobe_opcode_t *addr = (kprobe_opcode_t *)(regs->rip - sizeof(kprobe_opcode_t));
+	struct kprobe_ctlblk *kcb;
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kcb->kprobe_status == KPROBE_HIT_SS &&
+				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+				regs->eflags &= ~TF_MASK;
+				regs->eflags |= kcb->kprobe_saved_rflags;
+				goto no_kprobe;
+			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
+				/* TODO: Provide re-entrancy from
+				 * post_kprobes_handler() and avoid exception
+				 * stack corruption while single-stepping on
+				 * the instruction of the new probe.
+				 */
+				arch_disarm_kprobe(p);
+				regs->rip = (unsigned long)p->addr;
+				reset_current_kprobe();
+				ret = 1;
+			} else {
+				/* We have reentered the kprobe_handler(), since
+				 * another probe was hit while within the
+				 * handler. We here save the original kprobe
+				 * variables and just single step on instruction
+				 * of the new probe without calling any user
+				 * handlers.
+				 */
+				save_previous_kprobe(kcb);
+				set_current_kprobe(p, regs, kcb);
+				kprobes_inc_nmissed_count(p);
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_REENTER;
+				return 1;
+			}
+		} else {
+			if (*addr != BREAKPOINT_INSTRUCTION) {
+			/* The breakpoint instruction was removed by
+			 * another cpu right after we hit, no further
+			 * handling of this interrupt is appropriate
+			 */
+				regs->rip = (unsigned long)addr;
+				ret = 1;
+				goto no_kprobe;
+			}
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs)) {
+				goto ss_probe;
+			}
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (*addr != BREAKPOINT_INSTRUCTION) {
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 * Back up over the (now missing) int3 and run
+			 * the original instruction.
+			 */
+			regs->rip = (unsigned long)addr;
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	set_current_kprobe(p, regs, kcb);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+
+ss_probe:
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * For function-return probes, init_kprobes() establishes a probepoint
+ * here. When a retprobed function returns, this probe is hit and
+ * trampoline_probe_handler() runs, calling the kretprobe's handler.
+ */
+ void kretprobe_trampoline_holder(void)
+ {
+ 	asm volatile (  ".global kretprobe_trampoline\n"
+ 			"kretprobe_trampoline: \n"
+ 			"nop\n");
+ }
+
+/*
+ * Called when we hit the probe point at kretprobe_trampoline
+ */
+int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(current);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more then one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+	regs->rip = orig_ret_address;
+
+	reset_current_kprobe();
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "int 3"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ *
+ * This function prepares to return from the post-single-step
+ * interrupt.  We have to fix up the stack as follows:
+ *
+ * 0) Except in the case of absolute or indirect jump or call instructions,
+ * the new rip is relative to the copied instruction.  We need to make
+ * it relative to the original instruction.
+ *
+ * 1) If the single-stepped instruction was pushfl, then the TF and IF
+ * flags are set in the just-pushed eflags, and may need to be cleared.
+ *
+ * 2) If the single-stepped instruction was a call, the return address
+ * that is atop the stack is the address following the copied instruction.
+ * We need to make it the address following the original instruction.
+ */
+static void __kprobes resume_execution(struct kprobe *p,
+		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+{
+	unsigned long *tos = (unsigned long *)regs->rsp;
+	unsigned long next_rip = 0;
+	unsigned long copy_rip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_rip = (unsigned long)p->addr;
+	kprobe_opcode_t *insn = p->ainsn.insn;
+
+	/*skip the REX prefix*/
+	if (*insn >= 0x40 && *insn <= 0x4f)
+		insn++;
+
+	switch (*insn) {
+	case 0x9c:		/* pushfl */
+		*tos &= ~(TF_MASK | IF_MASK);
+		*tos |= kcb->kprobe_old_rflags;
+		break;
+	case 0xc3:		/* ret/lret */
+	case 0xcb:
+	case 0xc2:
+	case 0xca:
+		regs->eflags &= ~TF_MASK;
+		/* rip is already adjusted, no more changes required*/
+		return;
+	case 0xe8:		/* call relative - Fix return addr */
+		*tos = orig_rip + (*tos - copy_rip);
+		break;
+	case 0xff:
+		if ((insn[1] & 0x30) == 0x10) {
+			/* call absolute, indirect */
+			/* Fix return addr; rip is correct. */
+			next_rip = regs->rip;
+			*tos = orig_rip + (*tos - copy_rip);
+		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+			/* rip is correct. */
+			next_rip = regs->rip;
+		}
+		break;
+	case 0xea:		/* jmp absolute -- rip is correct */
+		next_rip = regs->rip;
+		break;
+	default:
+		break;
+	}
+
+	regs->eflags &= ~TF_MASK;
+	if (next_rip) {
+		regs->rip = next_rip;
+	} else {
+		regs->rip = orig_rip + (regs->rip - copy_rip);
+	}
+}
+
+int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs, kcb);
+	regs->eflags |= kcb->kprobe_saved_rflags;
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	if (raw_irqs_disabled_flags(regs->eflags))
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+#endif
+
+	/* Restore the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, eflags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (regs->eflags & TF_MASK)
+		return 0;
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	const struct exception_table_entry *fixup;
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the rip points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		regs->rip = (unsigned long)cur->addr;
+		regs->eflags |= kcb->kprobe_old_rflags;
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+		fixup = search_exception_tables(regs->rip);
+		if (fixup) {
+			regs->rip = fixup->fixup;
+			return 1;
+		}
+
+		/*
+		 * fixup() could not handle it,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+	if (args->regs && user_mode(args->regs))
+		return ret;
+
+	switch (val) {
+	case DIE_INT3:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_DEBUG:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_GPF:
+		/* kprobe_running() needs smp_processor_id() */
+		preempt_disable();
+		if (kprobe_running() &&
+		    kprobe_fault_handler(args->regs, args->trapnr))
+			ret = NOTIFY_STOP;
+		preempt_enable();
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	unsigned long addr;
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	kcb->jprobe_saved_regs = *regs;
+	kcb->jprobe_saved_rsp = (long *) regs->rsp;
+	addr = (unsigned long)(kcb->jprobe_saved_rsp);
+	/*
+	 * As Linus pointed out, gcc assumes that the callee
+	 * owns the argument space and could overwrite it, e.g.
+	 * tailcall optimization. So, to be absolutely safe
+	 * we also save and restore enough stack bytes to cover
+	 * the argument area.
+	 */
+	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
+			MIN_STACK_SIZE(addr));
+	regs->eflags &= ~IF_MASK;
+	trace_hardirqs_off();
+	regs->rip = (unsigned long)(jp->entry);
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	asm volatile ("       xchg   %%rbx,%%rsp     \n"
+		      "       int3			\n"
+		      "       .globl jprobe_return_end	\n"
+		      "       jprobe_return_end:	\n"
+		      "       nop			\n"::"b"
+		      (kcb->jprobe_saved_rsp):"memory");
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	u8 *addr = (u8 *) (regs->rip - 1);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_rsp);
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+
+	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
+		if ((long *)regs->rsp != kcb->jprobe_saved_rsp) {
+			struct pt_regs *saved_regs =
+			    container_of(kcb->jprobe_saved_rsp,
+					    struct pt_regs, rsp);
+			printk("current rsp %p does not match saved rsp %p\n",
+			       (long *)regs->rsp, kcb->jprobe_saved_rsp);
+			printk("Saved registers for jprobe %p\n", jp);
+			show_registers(saved_regs);
+			printk("Current registers\n");
+			show_registers(regs);
+			BUG();
+		}
+		*regs = kcb->jprobe_saved_regs;
+		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
+		       MIN_STACK_SIZE(stack_addr));
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+
+int __init arch_init_kprobes(void)
+{
+	return register_kprobe(&trampoline_p);
+}
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+
+	return 0;
+}
Index: linux-2.6-lttng.stable/arch/x86/kernel/kprobes_32.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/kernel/kprobes_32.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,763 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- *
- * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
- *		Probes initial implementation ( includes contributions from
- *		Rusty Russell).
- * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
- *		interface to access function arguments.
- * 2005-May	Hien Nguyen <hien@us.ibm.com>, Jim Keniston
- *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
- *		<prasanna@in.ibm.com> added function-return probes.
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/preempt.h>
-#include <linux/kdebug.h>
-#include <asm/cacheflush.h>
-#include <asm/desc.h>
-#include <asm/uaccess.h>
-#include <asm/alternative.h>
-
-void jprobe_return_end(void);
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {
-	{"__switch_to", }, /* This function switches only current task, but
-			     doesn't switch kernel stack.*/
-	{NULL, NULL}	/* Terminator */
-};
-const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
-
-/* insert a jmp code */
-static __always_inline void set_jmp_op(void *from, void *to)
-{
-	struct __arch_jmp_op {
-		char op;
-		long raddr;
-	} __attribute__((packed)) *jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (long)(to) - ((long)(from) + 5);
-	jop->op = RELATIVEJUMP_INSTRUCTION;
-}
-
-/*
- * returns non-zero if opcodes can be boosted.
- */
-static __always_inline int can_boost(kprobe_opcode_t *opcodes)
-{
-#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 32))
-	/*
-	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
-	 * Groups, and some special opcodes can not be boost.
-	 */
-	static const unsigned long twobyte_is_boostable[256 / 32] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0)| /* 00 */
-		W(0x10, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 10 */
-		W(0x20, 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0)| /* 20 */
-		W(0x30, 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 30 */
-		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 40 */
-		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 50 */
-		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1)| /* 60 */
-		W(0x70, 0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1), /* 70 */
-		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 80 */
-		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1), /* 90 */
-		W(0xa0, 1,1,0,1,1,1,0,0,1,1,0,1,1,1,0,1)| /* a0 */
-		W(0xb0, 1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1), /* b0 */
-		W(0xc0, 1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1)| /* c0 */
-		W(0xd0, 0,1,1,1,0,1,0,0,1,1,0,1,1,1,0,1), /* d0 */
-		W(0xe0, 0,1,1,0,0,1,0,0,1,1,0,1,1,1,0,1)| /* e0 */
-		W(0xf0, 0,1,1,1,0,1,0,0,1,1,1,0,1,1,1,0)  /* f0 */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-#undef W
-	kprobe_opcode_t opcode;
-	kprobe_opcode_t *orig_opcodes = opcodes;
-retry:
-	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
-		return 0;
-	opcode = *(opcodes++);
-
-	/* 2nd-byte opcode */
-	if (opcode == 0x0f) {
-		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
-			return 0;
-		return test_bit(*opcodes, twobyte_is_boostable);
-	}
-
-	switch (opcode & 0xf0) {
-	case 0x60:
-		if (0x63 < opcode && opcode < 0x67)
-			goto retry; /* prefixes */
-		/* can't boost Address-size override and bound */
-		return (opcode != 0x62 && opcode != 0x67);
-	case 0x70:
-		return 0; /* can't boost conditional jump */
-	case 0xc0:
-		/* can't boost software-interruptions */
-		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
-	case 0xd0:
-		/* can boost AA* and XLAT */
-		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
-	case 0xe0:
-		/* can boost in/out and absolute jmps */
-		return ((opcode & 0x04) || opcode == 0xea);
-	case 0xf0:
-		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
-			goto retry; /* lock/rep(ne) prefix */
-		/* clear and set flags can be boost */
-		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
-	default:
-		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
-			goto retry; /* prefixes */
-		/* can't boost CS override and call */
-		return (opcode != 0x2e && opcode != 0x9a);
-	}
-}
-
-/*
- * returns non-zero if opcode modifies the interrupt flag.
- */
-static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
-{
-	switch (opcode) {
-	case 0xfa:		/* cli */
-	case 0xfb:		/* sti */
-	case 0xcf:		/* iret/iretd */
-	case 0x9d:		/* popf/popfd */
-		return 1;
-	}
-	return 0;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* insn: must be on special executable page on i386. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn)
-		return -ENOMEM;
-
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-	if (can_boost(p->addr)) {
-		p->ainsn.boostable = 0;
-	} else {
-		p->ainsn.boostable = -1;
-	}
-	return 0;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, &p->opcode, 1);
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_eflags = kcb->kprobe_old_eflags;
-	kcb->prev_kprobe.saved_eflags = kcb->kprobe_saved_eflags;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_eflags = kcb->prev_kprobe.old_eflags;
-	kcb->kprobe_saved_eflags = kcb->prev_kprobe.saved_eflags;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_eflags = kcb->kprobe_old_eflags
-		= (regs->eflags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->opcode))
-		kcb->kprobe_saved_eflags &= ~IF_MASK;
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	regs->eflags |= TF_MASK;
-	regs->eflags &= ~IF_MASK;
-	/*single step inline if the instruction is an int3*/
-	if (p->opcode == BREAKPOINT_INSTRUCTION)
-		regs->eip = (unsigned long)p->addr;
-	else
-		regs->eip = (unsigned long)p->ainsn.insn;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
-{
-	unsigned long *sara = (unsigned long *)&regs->esp;
-
-	ri->ret_addr = (kprobe_opcode_t *) *sara;
-
-	/* Replace the return addr with trampoline addr */
-	*sara = (unsigned long) &kretprobe_trampoline;
-}
-
-/*
- * Interrupts are disabled on entry as trap3 is an interrupt gate and they
- * remain disabled thorough out this function.
- */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	int ret = 0;
-	kprobe_opcode_t *addr;
-	struct kprobe_ctlblk *kcb;
-
-	addr = (kprobe_opcode_t *)(regs->eip - sizeof(kprobe_opcode_t));
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->eflags &= ~TF_MASK;
-				regs->eflags |= kcb->kprobe_saved_eflags;
-				goto no_kprobe;
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				regs->eip -= sizeof(kprobe_opcode_t);
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 * Back up over the (now missing) int3 and run
-			 * the original instruction.
-			 */
-			regs->eip -= sizeof(kprobe_opcode_t);
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
-	if (p->ainsn.boostable == 1 && !p->post_handler){
-		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
-		regs->eip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
-		return 1;
-	}
-#endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
- */
- void __kprobes kretprobe_trampoline_holder(void)
- {
-	asm volatile ( ".global kretprobe_trampoline\n"
-			"kretprobe_trampoline: \n"
-			"	pushf\n"
-			/* skip cs, eip, orig_eax */
-			"	subl $12, %esp\n"
-			"	pushl %fs\n"
-			"	pushl %ds\n"
-			"	pushl %es\n"
-			"	pushl %eax\n"
-			"	pushl %ebp\n"
-			"	pushl %edi\n"
-			"	pushl %esi\n"
-			"	pushl %edx\n"
-			"	pushl %ecx\n"
-			"	pushl %ebx\n"
-			"	movl %esp, %eax\n"
-			"	call trampoline_handler\n"
-			/* move eflags to cs */
-			"	movl 52(%esp), %edx\n"
-			"	movl %edx, 48(%esp)\n"
-			/* save true return address on eflags */
-			"	movl %eax, 52(%esp)\n"
-			"	popl %ebx\n"
-			"	popl %ecx\n"
-			"	popl %edx\n"
-			"	popl %esi\n"
-			"	popl %edi\n"
-			"	popl %ebp\n"
-			"	popl %eax\n"
-			/* skip eip, orig_eax, es, ds, fs */
-			"	addl $20, %esp\n"
-			"	popf\n"
-			"	ret\n");
-}
-
-/*
- * Called from kretprobe_trampoline
- */
-fastcall void *__kprobes trampoline_handler(struct pt_regs *regs)
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-	/* fixup registers */
-	regs->xcs = __KERNEL_CS | get_kernel_rpl();
-	regs->eip = trampoline_address;
-	regs->orig_eax = 0xffffffff;
-
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		if (ri->rp && ri->rp->handler){
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
-			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
-			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
-		}
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-	return (void*)orig_ret_address;
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "int 3"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- *
- * This function prepares to return from the post-single-step
- * interrupt.  We have to fix up the stack as follows:
- *
- * 0) Except in the case of absolute or indirect jump or call instructions,
- * the new eip is relative to the copied instruction.  We need to make
- * it relative to the original instruction.
- *
- * 1) If the single-stepped instruction was pushfl, then the TF and IF
- * flags are set in the just-pushed eflags, and may need to be cleared.
- *
- * 2) If the single-stepped instruction was a call, the return address
- * that is atop the stack is the address following the copied instruction.
- * We need to make it the address following the original instruction.
- *
- * This function also checks instruction size for preparing direct execution.
- */
-static void __kprobes resume_execution(struct kprobe *p,
-		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
-{
-	unsigned long *tos = (unsigned long *)&regs->esp;
-	unsigned long copy_eip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_eip = (unsigned long)p->addr;
-
-	regs->eflags &= ~TF_MASK;
-	switch (p->ainsn.insn[0]) {
-	case 0x9c:		/* pushfl */
-		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_eflags;
-		break;
-	case 0xc2:		/* iret/ret/lret */
-	case 0xc3:
-	case 0xca:
-	case 0xcb:
-	case 0xcf:
-	case 0xea:		/* jmp absolute -- eip is correct */
-		/* eip is already adjusted, no more changes required */
-		p->ainsn.boostable = 1;
-		goto no_change;
-	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_eip + (*tos - copy_eip);
-		break;
-	case 0x9a:		/* call absolute -- same as call absolute, indirect */
-		*tos = orig_eip + (*tos - copy_eip);
-		goto no_change;
-	case 0xff:
-		if ((p->ainsn.insn[1] & 0x30) == 0x10) {
-			/*
-			 * call absolute, indirect
-			 * Fix return addr; eip is correct.
-			 * But this is not boostable
-			 */
-			*tos = orig_eip + (*tos - copy_eip);
-			goto no_change;
-		} else if (((p->ainsn.insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((p->ainsn.insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* eip is correct. And this is boostable */
-			p->ainsn.boostable = 1;
-			goto no_change;
-		}
-	default:
-		break;
-	}
-
-	if (p->ainsn.boostable == 0) {
-		if ((regs->eip > copy_eip) &&
-		    (regs->eip - copy_eip) + 5 < MAX_INSN_SIZE) {
-			/*
-			 * These instructions can be executed directly if it
-			 * jumps back to correct address.
-			 */
-			set_jmp_op((void *)regs->eip,
-				   (void *)orig_eip + (regs->eip - copy_eip));
-			p->ainsn.boostable = 1;
-		} else {
-			p->ainsn.boostable = -1;
-		}
-	}
-
-	regs->eip = orig_eip + (regs->eip - copy_eip);
-
-no_change:
-	return;
-}
-
-/*
- * Interrupts are disabled on entry as trap1 is an interrupt gate and they
- * remain disabled thoroughout this function.
- */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs, kcb);
-	regs->eflags |= kcb->kprobe_saved_eflags;
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-	if (raw_irqs_disabled_flags(regs->eflags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-#endif
-
-	/*Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	/*
-	 * if somebody else is singlestepping across a probe point, eflags
-	 * will have TF set, in which case, continue the remaining processing
-	 * of do_debug, as if this is not a probe hit.
-	 */
-	if (regs->eflags & TF_MASK)
-		return 0;
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the eip points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->eip = (unsigned long)cur->addr;
-		regs->eflags |= kcb->kprobe_old_eflags;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-		if (fixup_exception(regs))
-			return 1;
-
-		/*
-		 * fixup_exception() could not handle it,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine to for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	if (args->regs && user_mode_vm(args->regs))
-		return ret;
-
-	switch (val) {
-	case DIE_INT3:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_GPF:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		preempt_enable();
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr;
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_esp = &regs->esp;
-	addr = (unsigned long)(kcb->jprobe_saved_esp);
-
-	/*
-	 * TBD: As Linus pointed out, gcc assumes that the callee
-	 * owns the argument space and could overwrite it, e.g.
-	 * tailcall optimization. So, to be absolutely safe
-	 * we also save and restore enough stack bytes to cover
-	 * the argument area.
-	 */
-	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
-			MIN_STACK_SIZE(addr));
-	regs->eflags &= ~IF_MASK;
-	trace_hardirqs_off();
-	regs->eip = (unsigned long)(jp->entry);
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	asm volatile ("       xchgl   %%ebx,%%esp     \n"
-		      "       int3			\n"
-		      "       .globl jprobe_return_end	\n"
-		      "       jprobe_return_end:	\n"
-		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_esp):"memory");
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	u8 *addr = (u8 *) (regs->eip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_esp);
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-
-	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->esp != kcb->jprobe_saved_esp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_esp,
-					    struct pt_regs, esp);
-			printk("current esp %p does not match saved esp %p\n",
-			       &regs->esp, kcb->jprobe_saved_esp);
-			printk("Saved registers for jprobe %p\n", jp);
-			show_registers(saved_regs);
-			printk("Current registers\n");
-			show_registers(regs);
-			BUG();
-		}
-		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-		       MIN_STACK_SIZE(stack_addr));
-		preempt_enable_no_resched();
-		return 1;
-	}
-	return 0;
-}
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-	return 0;
-}
-
-int __init arch_init_kprobes(void)
-{
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/x86/kernel/kprobes_64.c
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/kernel/kprobes_64.c	2007-10-29 09:51:07.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,761 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- *
- * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
- *		Probes initial implementation ( includes contributions from
- *		Rusty Russell).
- * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
- *		interface to access function arguments.
- * 2004-Oct	Jim Keniston <kenistoj@us.ibm.com> and Prasanna S Panchamukhi
- *		<prasanna@in.ibm.com> adapted for x86_64
- * 2005-Mar	Roland McGrath <roland@redhat.com>
- *		Fixed to handle %rip-relative addressing mode correctly.
- * 2005-May     Rusty Lynch <rusty.lynch@intel.com>
- *              Added function return probes functionality
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/preempt.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/alternative.h>
-
-void jprobe_return_end(void);
-static void __kprobes arch_copy_kprobe(struct kprobe *p);
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {
-	{"__switch_to", }, /* This function switches only current task, but
-			      doesn't switch kernel stack.*/
-	{NULL, NULL}	/* Terminator */
-};
-const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
-
-/*
- * returns non-zero if opcode modifies the interrupt flag.
- */
-static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
-{
-	switch (*insn) {
-	case 0xfa:		/* cli */
-	case 0xfb:		/* sti */
-	case 0xcf:		/* iret/iretd */
-	case 0x9d:		/* popf/popfd */
-		return 1;
-	}
-
-	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
-		return 1;
-	return 0;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* insn: must be on special executable page on x86_64. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn) {
-		return -ENOMEM;
-	}
-	arch_copy_kprobe(p);
-	return 0;
-}
-
-/*
- * Determine if the instruction uses the %rip-relative addressing mode.
- * If it does, return the address of the 32-bit displacement word.
- * If not, return null.
- */
-static s32 __kprobes *is_riprel(u8 *insn)
-{
-#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 64))
-	static const u64 onebyte_has_modrm[256 / 64] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 00 */
-		W(0x10, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 10 */
-		W(0x20, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 20 */
-		W(0x30, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0), /* 30 */
-		W(0x40, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 40 */
-		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 50 */
-		W(0x60, 0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0)| /* 60 */
-		W(0x70, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 70 */
-		W(0x80, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 80 */
-		W(0x90, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 90 */
-		W(0xa0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* a0 */
-		W(0xb0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* b0 */
-		W(0xc0, 1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0)| /* c0 */
-		W(0xd0, 1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1)| /* d0 */
-		W(0xe0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* e0 */
-		W(0xf0, 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1)  /* f0 */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-	static const u64 twobyte_has_modrm[256 / 64] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1)| /* 0f */
-		W(0x10, 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0)| /* 1f */
-		W(0x20, 1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,1)| /* 2f */
-		W(0x30, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 3f */
-		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 4f */
-		W(0x50, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 5f */
-		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 6f */
-		W(0x70, 1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1), /* 7f */
-		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 8f */
-		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 9f */
-		W(0xa0, 0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1)| /* af */
-		W(0xb0, 1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1), /* bf */
-		W(0xc0, 1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)| /* cf */
-		W(0xd0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* df */
-		W(0xe0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* ef */
-		W(0xf0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)  /* ff */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-#undef	W
-	int need_modrm;
-
-	/* Skip legacy instruction prefixes.  */
-	while (1) {
-		switch (*insn) {
-		case 0x66:
-		case 0x67:
-		case 0x2e:
-		case 0x3e:
-		case 0x26:
-		case 0x64:
-		case 0x65:
-		case 0x36:
-		case 0xf0:
-		case 0xf3:
-		case 0xf2:
-			++insn;
-			continue;
-		}
-		break;
-	}
-
-	/* Skip REX instruction prefix.  */
-	if ((*insn & 0xf0) == 0x40)
-		++insn;
-
-	if (*insn == 0x0f) {	/* Two-byte opcode.  */
-		++insn;
-		need_modrm = test_bit(*insn, twobyte_has_modrm);
-	} else {		/* One-byte opcode.  */
-		need_modrm = test_bit(*insn, onebyte_has_modrm);
-	}
-
-	if (need_modrm) {
-		u8 modrm = *++insn;
-		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
-			/* Displacement follows ModRM byte.  */
-			return (s32 *) ++insn;
-		}
-	}
-
-	/* No %rip-relative addressing mode here.  */
-	return NULL;
-}
-
-static void __kprobes arch_copy_kprobe(struct kprobe *p)
-{
-	s32 *ripdisp;
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
-	ripdisp = is_riprel(p->ainsn.insn);
-	if (ripdisp) {
-		/*
-		 * The copied instruction uses the %rip-relative
-		 * addressing mode.  Adjust the displacement for the
-		 * difference between the original location of this
-		 * instruction and the location of the copy that will
-		 * actually be run.  The tricky bit here is making sure
-		 * that the sign extension happens correctly in this
-		 * calculation, since we need a signed 32-bit result to
-		 * be sign-extended to 64 bits when it's added to the
-		 * %rip value and yield the same 64-bit result that the
-		 * sign-extension of the original signed 32-bit
-		 * displacement would have given.
-		 */
-		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
-		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
-		*ripdisp = disp;
-	}
-	p->opcode = *p->addr;
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, &p->opcode, 1);
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_rflags = kcb->kprobe_old_rflags;
-	kcb->prev_kprobe.saved_rflags = kcb->kprobe_saved_rflags;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_rflags = kcb->prev_kprobe.old_rflags;
-	kcb->kprobe_saved_rflags = kcb->prev_kprobe.saved_rflags;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_rflags = kcb->kprobe_old_rflags
-		= (regs->eflags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_rflags &= ~IF_MASK;
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	regs->eflags |= TF_MASK;
-	regs->eflags &= ~IF_MASK;
-	/*single step inline if the instruction is an int3*/
-	if (p->opcode == BREAKPOINT_INSTRUCTION)
-		regs->rip = (unsigned long)p->addr;
-	else
-		regs->rip = (unsigned long)p->ainsn.insn;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
-{
-	unsigned long *sara = (unsigned long *)regs->rsp;
-
-	ri->ret_addr = (kprobe_opcode_t *) *sara;
-	/* Replace the return addr with trampoline addr */
-	*sara = (unsigned long) &kretprobe_trampoline;
-}
-
-int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	int ret = 0;
-	kprobe_opcode_t *addr = (kprobe_opcode_t *)(regs->rip - sizeof(kprobe_opcode_t));
-	struct kprobe_ctlblk *kcb;
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->eflags &= ~TF_MASK;
-				regs->eflags |= kcb->kprobe_saved_rflags;
-				goto no_kprobe;
-			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
-				/* TODO: Provide re-entrancy from
-				 * post_kprobes_handler() and avoid exception
-				 * stack corruption while single-stepping on
-				 * the instruction of the new probe.
-				 */
-				arch_disarm_kprobe(p);
-				regs->rip = (unsigned long)p->addr;
-				reset_current_kprobe();
-				ret = 1;
-			} else {
-				/* We have reentered the kprobe_handler(), since
-				 * another probe was hit while within the
-				 * handler. We here save the original kprobe
-				 * variables and just single step on instruction
-				 * of the new probe without calling any user
-				 * handlers.
-				 */
-				save_previous_kprobe(kcb);
-				set_current_kprobe(p, regs, kcb);
-				kprobes_inc_nmissed_count(p);
-				prepare_singlestep(p, regs);
-				kcb->kprobe_status = KPROBE_REENTER;
-				return 1;
-			}
-		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				regs->rip = (unsigned long)addr;
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 * Back up over the (now missing) int3 and run
-			 * the original instruction.
-			 */
-			regs->rip = (unsigned long)addr;
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
- */
- void kretprobe_trampoline_holder(void)
- {
- 	asm volatile (  ".global kretprobe_trampoline\n"
- 			"kretprobe_trampoline: \n"
- 			"nop\n");
- }
-
-/*
- * Called when we hit the probe point at kretprobe_trampoline
- */
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	regs->rip = orig_ret_address;
-
-	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	preempt_enable_no_resched();
-
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "int 3"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- *
- * This function prepares to return from the post-single-step
- * interrupt.  We have to fix up the stack as follows:
- *
- * 0) Except in the case of absolute or indirect jump or call instructions,
- * the new rip is relative to the copied instruction.  We need to make
- * it relative to the original instruction.
- *
- * 1) If the single-stepped instruction was pushfl, then the TF and IF
- * flags are set in the just-pushed eflags, and may need to be cleared.
- *
- * 2) If the single-stepped instruction was a call, the return address
- * that is atop the stack is the address following the copied instruction.
- * We need to make it the address following the original instruction.
- */
-static void __kprobes resume_execution(struct kprobe *p,
-		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
-{
-	unsigned long *tos = (unsigned long *)regs->rsp;
-	unsigned long next_rip = 0;
-	unsigned long copy_rip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_rip = (unsigned long)p->addr;
-	kprobe_opcode_t *insn = p->ainsn.insn;
-
-	/*skip the REX prefix*/
-	if (*insn >= 0x40 && *insn <= 0x4f)
-		insn++;
-
-	switch (*insn) {
-	case 0x9c:		/* pushfl */
-		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_rflags;
-		break;
-	case 0xc3:		/* ret/lret */
-	case 0xcb:
-	case 0xc2:
-	case 0xca:
-		regs->eflags &= ~TF_MASK;
-		/* rip is already adjusted, no more changes required*/
-		return;
-	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_rip + (*tos - copy_rip);
-		break;
-	case 0xff:
-		if ((insn[1] & 0x30) == 0x10) {
-			/* call absolute, indirect */
-			/* Fix return addr; rip is correct. */
-			next_rip = regs->rip;
-			*tos = orig_rip + (*tos - copy_rip);
-		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* rip is correct. */
-			next_rip = regs->rip;
-		}
-		break;
-	case 0xea:		/* jmp absolute -- rip is correct */
-		next_rip = regs->rip;
-		break;
-	default:
-		break;
-	}
-
-	regs->eflags &= ~TF_MASK;
-	if (next_rip) {
-		regs->rip = next_rip;
-	} else {
-		regs->rip = orig_rip + (regs->rip - copy_rip);
-	}
-}
-
-int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs, kcb);
-	regs->eflags |= kcb->kprobe_saved_rflags;
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-	if (raw_irqs_disabled_flags(regs->eflags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-#endif
-
-	/* Restore the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	/*
-	 * if somebody else is singlestepping across a probe point, eflags
-	 * will have TF set, in which case, continue the remaining processing
-	 * of do_debug, as if this is not a probe hit.
-	 */
-	if (regs->eflags & TF_MASK)
-		return 0;
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	const struct exception_table_entry *fixup;
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the rip points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->rip = (unsigned long)cur->addr;
-		regs->eflags |= kcb->kprobe_old_rflags;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-		fixup = search_exception_tables(regs->rip);
-		if (fixup) {
-			regs->rip = fixup->fixup;
-			return 1;
-		}
-
-		/*
-		 * fixup() could not handle it,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-	if (args->regs && user_mode(args->regs))
-		return ret;
-
-	switch (val) {
-	case DIE_INT3:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_GPF:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		preempt_enable();
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr;
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_rsp = (long *) regs->rsp;
-	addr = (unsigned long)(kcb->jprobe_saved_rsp);
-	/*
-	 * As Linus pointed out, gcc assumes that the callee
-	 * owns the argument space and could overwrite it, e.g.
-	 * tailcall optimization. So, to be absolutely safe
-	 * we also save and restore enough stack bytes to cover
-	 * the argument area.
-	 */
-	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
-			MIN_STACK_SIZE(addr));
-	regs->eflags &= ~IF_MASK;
-	trace_hardirqs_off();
-	regs->rip = (unsigned long)(jp->entry);
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	asm volatile ("       xchg   %%rbx,%%rsp     \n"
-		      "       int3			\n"
-		      "       .globl jprobe_return_end	\n"
-		      "       jprobe_return_end:	\n"
-		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_rsp):"memory");
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	u8 *addr = (u8 *) (regs->rip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_rsp);
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-
-	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if ((long *)regs->rsp != kcb->jprobe_saved_rsp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_rsp,
-					    struct pt_regs, rsp);
-			printk("current rsp %p does not match saved rsp %p\n",
-			       (long *)regs->rsp, kcb->jprobe_saved_rsp);
-			printk("Saved registers for jprobe %p\n", jp);
-			show_registers(saved_regs);
-			printk("Current registers\n");
-			show_registers(regs);
-			BUG();
-		}
-		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-		       MIN_STACK_SIZE(stack_addr));
-		preempt_enable_no_resched();
-		return 1;
-	}
-	return 0;
-}
-
-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-
-int __init arch_init_kprobes(void)
-{
-	return register_kprobe(&trampoline_p);
-}
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
-		return 1;
-
-	return 0;
-}
Index: linux-2.6-lttng.stable/arch/x86/instrumentation/Makefile
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/instrumentation/Makefile	2007-10-29 09:51:29.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/instrumentation/Makefile	2007-10-29 09:51:38.000000000 -0400
@@ -10,3 +10,9 @@ oprofile-y				:= $(DRIVER_OBJS) init.o b
 oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_athlon.o \
 					   op_model_ppro.o op_model_p4.o
 oprofile-$(CONFIG_X86_IO_APIC)		+= nmi_timer_int.o
+
+ifeq ($(CONFIG_X86_32),y)
+obj-$(CONFIG_KPROBES)			+= kprobes_32.o
+else
+obj-$(CONFIG_KPROBES)			+= kprobes_64.o
+endif
Index: linux-2.6-lttng.stable/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/kernel/Makefile_32	2007-10-29 09:51:07.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/kernel/Makefile_32	2007-10-29 09:51:38.000000000 -0400
@@ -30,7 +30,6 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_32
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_32.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
-obj-$(CONFIG_KPROBES)		+= kprobes_32.o
 obj-$(CONFIG_MODULES)		+= module_32.o
 obj-y				+= sysenter_32.o vsyscall_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
Index: linux-2.6-lttng.stable/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/kernel/Makefile_64	2007-10-29 09:51:07.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/kernel/Makefile_64	2007-10-29 09:51:38.000000000 -0400
@@ -28,7 +28,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_IOMMU)		+= pci-gart_64.o aperture_64.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
-obj-$(CONFIG_KPROBES)		+= kprobes_64.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
