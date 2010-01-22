Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239Ab0AVSsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0AVSsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223Ab0AVSsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:48:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab0AVSsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:48:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v8 3/9] kprobes: Introduce kprobes jump optimization
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 22 Jan 2010 13:55:12 -0500
Message-ID: <20100122185512.9022.14998.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100122185450.9022.87506.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100122185450.9022.87506.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kprobes jump optimization arch-independent parts.
Kprobes uses breakpoint instruction for interrupting execution flow, on
some architectures, it can be replaced by a jump instruction and
interruption emulation code. This gains kprobs' performance drastically.

To enable this feature, set CONFIG_OPTPROBES=y (default y if the arch
supports OPTPROBE).

Changes in v6:
 - Cleanup coding style for readability.
 - Add comments around get/put_online_cpus().

Changes in v5:
 - Use get_online_cpus()/put_online_cpus() for avoiding text_mutex
   deadlock.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
---

 arch/Kconfig            |   13 +
 include/linux/kprobes.h |   36 ++++
 kernel/kprobes.c        |  439 ++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 442 insertions(+), 46 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 32e8b68..2622a9d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -57,6 +57,17 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config OPTPROBES
+	bool "Kprobes jump optimization support (EXPERIMENTAL)"
+	default y
+	depends on KPROBES
+	depends on !PREEMPT
+	depends on HAVE_OPTPROBES
+	select KALLSYMS_ALL
+	help
+	  This option will allow kprobes to optimize breakpoint to
+	  a jump for reducing its overhead.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -99,6 +110,8 @@ config HAVE_KPROBES
 config HAVE_KRETPROBES
 	bool
 
+config HAVE_OPTPROBES
+	bool
 #
 # An arch should select this if it provides all these things:
 #
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1b672f7..aed1f95 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -122,6 +122,11 @@ struct kprobe {
 /* Kprobe status flags */
 #define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
 #define KPROBE_FLAG_DISABLED	2 /* probe is temporarily disabled */
+#define KPROBE_FLAG_OPTIMIZED	4 /*
+				   * probe is really optimized.
+				   * NOTE:
+				   * this flag is only for optimized_kprobe.
+				   */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
@@ -134,6 +139,12 @@ static inline int kprobe_disabled(struct kprobe *p)
 {
 	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
 }
+
+/* Is this kprobe really running optimized path ? */
+static inline int kprobe_optimized(struct kprobe *p)
+{
+	return p->flags & KPROBE_FLAG_OPTIMIZED;
+}
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
@@ -249,6 +260,31 @@ extern kprobe_opcode_t *get_insn_slot(void);
 extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 
+#ifdef CONFIG_OPTPROBES
+/*
+ * Internal structure for direct jump optimized probe
+ */
+struct optimized_kprobe {
+	struct kprobe kp;
+	struct list_head list;	/* list for optimizing queue */
+	struct arch_optimized_insn optinsn;
+};
+
+/* Architecture dependent functions for direct jump optimization */
+extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
+extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
+extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
+extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
+extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
+extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
+extern kprobe_opcode_t *get_optinsn_slot(void);
+extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
+extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
+					unsigned long addr);
+
+extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
+#endif /* CONFIG_OPTPROBES */
+
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
 void kretprobe_hash_lock(struct task_struct *tsk,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 57a2a23..759bb8e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
+#include <linux/cpu.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -303,6 +304,33 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
 	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
 	mutex_unlock(&kprobe_insn_mutex);
 }
+#ifdef CONFIG_OPTPROBES
+/* For optimized_kprobe buffer */
+static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
+static struct kprobe_insn_cache kprobe_optinsn_slots = {
+	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
+	/* .insn_size is initialized later */
+	.nr_garbage = 0,
+};
+/* Get a slot for optimized_kprobe buffer */
+kprobe_opcode_t __kprobes *get_optinsn_slot(void)
+{
+	kprobe_opcode_t *ret = NULL;
+
+	mutex_lock(&kprobe_optinsn_mutex);
+	ret = __get_insn_slot(&kprobe_optinsn_slots);
+	mutex_unlock(&kprobe_optinsn_mutex);
+
+	return ret;
+}
+
+void __kprobes free_optinsn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	mutex_lock(&kprobe_optinsn_mutex);
+	__free_insn_slot(&kprobe_optinsn_slots, slot, dirty);
+	mutex_unlock(&kprobe_optinsn_mutex);
+}
+#endif
 #endif
 
 /* We have preemption disabled.. so it is safe to use __ versions */
@@ -333,23 +361,303 @@ struct kprobe __kprobes *get_kprobe(void *addr)
 		if (p->addr == addr)
 			return p;
 	}
+
+	return NULL;
+}
+
+static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
+
+/* Return true if the kprobe is an aggregator */
+static inline int kprobe_aggrprobe(struct kprobe *p)
+{
+	return p->pre_handler == aggr_pre_handler;
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
+#ifdef CONFIG_OPTPROBES
+/*
+ * Call all pre_handler on the list, but ignores its return value.
+ * This must be called from arch-dep optimized caller.
+ */
+void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &p->list, list) {
+		if (kp->pre_handler && likely(!kprobe_disabled(kp))) {
+			set_kprobe_instance(kp);
+			kp->pre_handler(kp, regs);
+		}
+		reset_kprobe_instance();
+	}
+}
+
+/* Return true(!0) if the kprobe is ready for optimization. */
+static inline int kprobe_optready(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	if (kprobe_aggrprobe(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		return arch_prepared_optinsn(&op->optinsn);
+	}
+
+	return 0;
+}
+
+/* Return an optimized kprobe which replaces instructions including addr. */
+struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
+{
+	int i;
+	struct kprobe *p = NULL;
+	struct optimized_kprobe *op;
+
+	for (i = 0; !p && i < MAX_OPTIMIZED_LENGTH; i++)
+		p = get_kprobe((void *)(addr - i));
+
+	if (p && kprobe_optready(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		if (arch_within_optimized_kprobe(op, addr))
+			return p;
+	}
+
 	return NULL;
 }
 
+/* Optimization staging list, protected by kprobe_mutex */
+static LIST_HEAD(optimizing_list);
+
+static void kprobe_optimizer(struct work_struct *work);
+static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
+#define OPTIMIZE_DELAY 5
+
+/* Kprobe jump optimizer */
+static __kprobes void kprobe_optimizer(struct work_struct *work)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	/* Lock modules while optimizing kprobes */
+	mutex_lock(&module_mutex);
+	mutex_lock(&kprobe_mutex);
+	if (kprobes_all_disarmed)
+		goto end;
+
+	/*
+	 * Wait for quiesence period to ensure all running interrupts
+	 * are done. Because optprobe may modify multiple instructions
+	 * there is a chance that Nth instruction is interrupted. In that
+	 * case, running interrupt can return to 2nd-Nth byte of jump
+	 * instruction. This wait is for avoiding it.
+	 */
+	synchronize_sched();
+
+	/*
+	 * The optimization/unoptimization refers online_cpus via
+	 * stop_machine() and cpu-hotplug modifies online_cpus.
+	 * And same time, text_mutex will be held in cpu-hotplug and here.
+	 * This combination can cause a deadlock (cpu-hotplug try to lock
+	 * text_mutex but stop_machine can not be done because online_cpus
+	 * has been changed)
+	 * To avoid this deadlock, we need to call get_online_cpus()
+	 * for preventing cpu-hotplug outside of text_mutex locking.
+	 */
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	list_for_each_entry_safe(op, tmp, &optimizing_list, list) {
+		WARN_ON(kprobe_disabled(&op->kp));
+		if (arch_optimize_kprobe(op) < 0)
+			op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+		list_del_init(&op->list);
+	}
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+end:
+	mutex_unlock(&kprobe_mutex);
+	mutex_unlock(&module_mutex);
+}
+
+/* Optimize kprobe if p is ready to be optimized */
+static __kprobes void optimize_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	/* Check if the kprobe is disabled or not ready for optimization. */
+	if (!kprobe_optready(p) ||
+	    (kprobe_disabled(p) || kprobes_all_disarmed))
+		return;
+
+	/* Both of break_handler and post_handler are not supported. */
+	if (p->break_handler || p->post_handler)
+		return;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+
+	/* Check there is no other kprobes at the optimized instructions */
+	if (arch_check_optimized_kprobe(op) < 0)
+		return;
+
+	/* Check if it is already optimized. */
+	if (op->kp.flags & KPROBE_FLAG_OPTIMIZED)
+		return;
+
+	op->kp.flags |= KPROBE_FLAG_OPTIMIZED;
+	list_add(&op->list, &optimizing_list);
+	if (!delayed_work_pending(&optimizing_work))
+		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+}
+
+/* Unoptimize a kprobe if p is optimized */
+static __kprobes void unoptimize_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	if ((p->flags & KPROBE_FLAG_OPTIMIZED) && kprobe_aggrprobe(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		if (!list_empty(&op->list))
+			/* Dequeue from the optimization queue */
+			list_del_init(&op->list);
+		else
+			/* Replace jump with break */
+			arch_unoptimize_kprobe(op);
+		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	}
+}
+
+/* Remove optimized instructions */
+static void __kprobes kill_optimized_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	if (!list_empty(&op->list)) {
+		/* Dequeue from the optimization queue */
+		list_del_init(&op->list);
+		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	}
+	/* Don't unoptimize, because the target code will be freed. */
+	arch_remove_optimized_kprobe(op);
+}
+
+/* Try to prepare optimized instructions */
+static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	arch_prepare_optimized_kprobe(op);
+}
+
+/* Free optimized instructions and optimized_kprobe */
+static __kprobes void free_aggr_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	arch_remove_optimized_kprobe(op);
+	kfree(op);
+}
+
+/* Allocate new optimized_kprobe and try to prepare optimized instructions */
+static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = kzalloc(sizeof(struct optimized_kprobe), GFP_KERNEL);
+	if (!op)
+		return NULL;
+
+	INIT_LIST_HEAD(&op->list);
+	op->kp.addr = p->addr;
+	arch_prepare_optimized_kprobe(op);
+
+	return &op->kp;
+}
+
+static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p);
+
+/*
+ * Prepare an optimized_kprobe and optimize it
+ * NOTE: p must be a normal registered kprobe
+ */
+static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
+{
+	struct kprobe *ap;
+	struct optimized_kprobe *op;
+
+	ap = alloc_aggr_kprobe(p);
+	if (!ap)
+		return;
+
+	op = container_of(ap, struct optimized_kprobe, kp);
+	if (!arch_prepared_optinsn(&op->optinsn)) {
+		/* If failed to setup optimizing, fallback to kprobe */
+		free_aggr_kprobe(ap);
+		return;
+	}
+
+	init_aggr_kprobe(ap, p);
+	optimize_kprobe(ap);
+}
+#else /* !CONFIG_OPTPROBES */
+#define get_optimized_kprobe(addr)		(NULL)
+#define optimize_kprobe(p)			do {} while (0)
+#define unoptimize_kprobe(p)			do {} while (0)
+#define kill_optimized_kprobe(p)		do {} while (0)
+#define prepare_optimized_kprobe(p)		do {} while (0)
+#define try_to_optimize_kprobe(p)		do {} while (0)
+
+static __kprobes void free_aggr_kprobe(struct kprobe *p)
+{
+	kfree(p);
+}
+
+static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+{
+	return kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+}
+#endif /* CONFIG_OPTPROBES */
+
+static void __kprobes __arm_kprobe(struct kprobe *kp)
+{
+	arch_arm_kprobe(kp);
+	optimize_kprobe(kp);	/* Try to optimize (add kprobe to a list) */
+}
+
+static void __kprobes __disarm_kprobe(struct kprobe *kp)
+{
+	unoptimize_kprobe(kp);	/* Try to unoptimize */
+	arch_disarm_kprobe(kp);
+}
+
 /* Arm a kprobe with text_mutex */
 static void __kprobes arm_kprobe(struct kprobe *kp)
 {
+	/*
+	 * Here, since __arm_kprobe() doesn't use stop_machine(),
+	 * this doesn't cause deadlock on text_mutex. So, we don't
+	 * need get_online_cpus().
+	 */
 	mutex_lock(&text_mutex);
-	arch_arm_kprobe(kp);
+	__arm_kprobe(kp);
 	mutex_unlock(&text_mutex);
 }
 
 /* Disarm a kprobe with text_mutex */
 static void __kprobes disarm_kprobe(struct kprobe *kp)
 {
+	get_online_cpus();	/* For avoiding text_mutex deadlock */
 	mutex_lock(&text_mutex);
-	arch_disarm_kprobe(kp);
+	__disarm_kprobe(kp);
 	mutex_unlock(&text_mutex);
+	put_online_cpus();
 }
 
 /*
@@ -418,7 +726,7 @@ static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
 {
 	struct kprobe *kp;
-	if (p->pre_handler != aggr_pre_handler) {
+	if (!kprobe_aggrprobe(p)) {
 		p->nmissed++;
 	} else {
 		list_for_each_entry_rcu(kp, &p->list, list)
@@ -542,21 +850,16 @@ static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 }
 
 /*
- * Keep all fields in the kprobe consistent
- */
-static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
-{
-	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
-	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
-}
-
-/*
 * Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
 static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
+
+	if (p->break_handler || p->post_handler)
+		unoptimize_kprobe(ap);	/* Fall back to normal kprobe */
+
 	if (p->break_handler) {
 		if (ap->break_handler)
 			return -EEXIST;
@@ -571,7 +874,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 		ap->flags &= ~KPROBE_FLAG_DISABLED;
 		if (!kprobes_all_disarmed)
 			/* Arm the breakpoint again. */
-			arm_kprobe(ap);
+			__arm_kprobe(ap);
 	}
 	return 0;
 }
@@ -580,12 +883,13 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
  * Fill in the required fields of the "manager kprobe". Replace the
  * earlier kprobe in the hlist with the manager kprobe
  */
-static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
+static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 {
+	/* Copy p's insn slot to ap */
 	copy_kprobe(p, ap);
 	flush_insn_slot(ap);
 	ap->addr = p->addr;
-	ap->flags = p->flags;
+	ap->flags = p->flags & ~KPROBE_FLAG_OPTIMIZED;
 	ap->pre_handler = aggr_pre_handler;
 	ap->fault_handler = aggr_fault_handler;
 	/* We don't care the kprobe which has gone. */
@@ -595,8 +899,9 @@ static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 		ap->break_handler = aggr_break_handler;
 
 	INIT_LIST_HEAD(&ap->list);
-	list_add_rcu(&p->list, &ap->list);
+	INIT_HLIST_NODE(&ap->hlist);
 
+	list_add_rcu(&p->list, &ap->list);
 	hlist_replace_rcu(&p->hlist, &ap->hlist);
 }
 
@@ -610,12 +915,12 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 	int ret = 0;
 	struct kprobe *ap = old_p;
 
-	if (old_p->pre_handler != aggr_pre_handler) {
-		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
-		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+	if (!kprobe_aggrprobe(old_p)) {
+		/* If old_p is not an aggr_kprobe, create new aggr_kprobe. */
+		ap = alloc_aggr_kprobe(old_p);
 		if (!ap)
 			return -ENOMEM;
-		add_aggr_kprobe(ap, old_p);
+		init_aggr_kprobe(ap, old_p);
 	}
 
 	if (kprobe_gone(ap)) {
@@ -634,6 +939,9 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 			 */
 			return ret;
 
+		/* Prepare optimized instructions if possible. */
+		prepare_optimized_kprobe(ap);
+
 		/*
 		 * Clear gone flag to prevent allocating new slot again, and
 		 * set disabled flag because it is not armed yet.
@@ -642,6 +950,7 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 			    | KPROBE_FLAG_DISABLED;
 	}
 
+	/* Copy ap's insn slot to p */
 	copy_kprobe(ap, p);
 	return add_new_kprobe(ap, p);
 }
@@ -791,16 +1100,25 @@ int __kprobes register_kprobe(struct kprobe *p)
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);
+
+	get_online_cpus();	/* For avoiding text_mutex deadlock. */
+	mutex_lock(&text_mutex);
+
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
+		/* Since this may unoptimize old_p, locking text_mutex. */
 		ret = register_aggr_kprobe(old_p, p);
 		goto out;
 	}
 
-	mutex_lock(&text_mutex);
+	/* Check collision with other optimized kprobes */
+	old_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(old_p))
+		unoptimize_kprobe(old_p); /* Fallback to unoptimized kprobe */
+
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out_unlock_text;
+		goto out;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -809,9 +1127,12 @@ int __kprobes register_kprobe(struct kprobe *p)
 	if (!kprobes_all_disarmed && !kprobe_disabled(p))
 		arch_arm_kprobe(p);
 
-out_unlock_text:
-	mutex_unlock(&text_mutex);
+	/* Try to optimize kprobe */
+	try_to_optimize_kprobe(p);
+
 out:
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
 	mutex_unlock(&kprobe_mutex);
 
 	if (probed_mod)
@@ -833,7 +1154,7 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		return -EINVAL;
 
 	if (old_p == p ||
-	    (old_p->pre_handler == aggr_pre_handler &&
+	    (kprobe_aggrprobe(old_p) &&
 	     list_is_singular(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
@@ -841,8 +1162,13 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		 * already have been removed. We save on flushing icache.
 		 */
 		if (!kprobes_all_disarmed && !kprobe_disabled(old_p))
-			disarm_kprobe(p);
+			disarm_kprobe(old_p);
 		hlist_del_rcu(&old_p->hlist);
+
+		/* If another kprobe was blocked, optimize it. */
+		old_p = get_optimized_kprobe((unsigned long)p->addr);
+		if (unlikely(old_p))
+			optimize_kprobe(old_p);
 	} else {
 		if (p->break_handler && !kprobe_gone(p))
 			old_p->break_handler = NULL;
@@ -857,8 +1183,13 @@ noclean:
 		list_del_rcu(&p->list);
 		if (!kprobe_disabled(old_p)) {
 			try_to_disable_aggr_kprobe(old_p);
-			if (!kprobes_all_disarmed && kprobe_disabled(old_p))
-				disarm_kprobe(old_p);
+			if (!kprobes_all_disarmed) {
+				if (kprobe_disabled(old_p))
+					disarm_kprobe(old_p);
+				else
+					/* Try to optimize this probe again */
+					optimize_kprobe(old_p);
+			}
 		}
 	}
 	return 0;
@@ -875,7 +1206,7 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 		old_p = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
 		arch_remove_kprobe(old_p);
-		kfree(old_p);
+		free_aggr_kprobe(old_p);
 	}
 }
 
@@ -1171,7 +1502,7 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 	struct kprobe *kp;
 
 	p->flags |= KPROBE_FLAG_GONE;
-	if (p->pre_handler == aggr_pre_handler) {
+	if (kprobe_aggrprobe(p)) {
 		/*
 		 * If this is an aggr_kprobe, we have to list all the
 		 * chained probes and mark them GONE.
@@ -1180,6 +1511,7 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 			kp->flags |= KPROBE_FLAG_GONE;
 		p->post_handler = NULL;
 		p->break_handler = NULL;
+		kill_optimized_kprobe(p);
 	}
 	/*
 	 * Here, we can remove insn_slot safely, because no thread calls
@@ -1289,6 +1621,11 @@ static int __init init_kprobes(void)
 		}
 	}
 
+#if defined(CONFIG_OPTPROBES) && defined(__ARCH_WANT_KPROBES_INSN_SLOT)
+	/* Init kprobe_optinsn_slots */
+	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
+#endif
+
 	/* By default, kprobes are armed */
 	kprobes_all_disarmed = false;
 
@@ -1307,7 +1644,7 @@ static int __init init_kprobes(void)
 
 #ifdef CONFIG_DEBUG_FS
 static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
-		const char *sym, int offset,char *modname)
+		const char *sym, int offset, char *modname, struct kprobe *pp)
 {
 	char *kprobe_type;
 
@@ -1317,19 +1654,21 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
 		kprobe_type = "j";
 	else
 		kprobe_type = "k";
+
 	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s %s%s\n",
+		seq_printf(pi, "%p  %s  %s+0x%x  %s ",
 			p->addr, kprobe_type, sym, offset,
-			(modname ? modname : " "),
-			(kprobe_gone(p) ? "[GONE]" : ""),
-			((kprobe_disabled(p) && !kprobe_gone(p)) ?
-			 "[DISABLED]" : ""));
+			(modname ? modname : " "));
 	else
-		seq_printf(pi, "%p  %s  %p %s%s\n",
-			p->addr, kprobe_type, p->addr,
-			(kprobe_gone(p) ? "[GONE]" : ""),
-			((kprobe_disabled(p) && !kprobe_gone(p)) ?
-			 "[DISABLED]" : ""));
+		seq_printf(pi, "%p  %s  %p ",
+			p->addr, kprobe_type, p->addr);
+
+	if (!pp)
+		pp = p;
+	seq_printf(pi, "%s%s%s\n",
+		(kprobe_gone(p) ? "[GONE]" : ""),
+		((kprobe_disabled(p) && !kprobe_gone(p)) ?  "[DISABLED]" : ""),
+		(kprobe_optimized(pp) ? "[OPTIMIZED]" : ""));
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -1365,11 +1704,11 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 	hlist_for_each_entry_rcu(p, node, head, hlist) {
 		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
 					&offset, &modname, namebuf);
-		if (p->pre_handler == aggr_pre_handler) {
+		if (kprobe_aggrprobe(p)) {
 			list_for_each_entry_rcu(kp, &p->list, list)
-				report_probe(pi, kp, sym, offset, modname);
+				report_probe(pi, kp, sym, offset, modname, p);
 		} else
-			report_probe(pi, p, sym, offset, modname);
+			report_probe(pi, p, sym, offset, modname, NULL);
 	}
 	preempt_enable();
 	return 0;
@@ -1472,12 +1811,13 @@ static void __kprobes arm_all_kprobes(void)
 	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
+	/* Arming kprobes doesn't optimize kprobe itself */
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			if (!kprobe_disabled(p))
-				arch_arm_kprobe(p);
+				__arm_kprobe(p);
 	}
 	mutex_unlock(&text_mutex);
 
@@ -1504,16 +1844,23 @@ static void __kprobes disarm_all_kprobes(void)
 
 	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
+
+	/*
+	 * Here we call get_online_cpus() for avoiding text_mutex deadlock,
+	 * because disarming may also unoptimize kprobes.
+	 */
+	get_online_cpus();
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
-				arch_disarm_kprobe(p);
+				__disarm_kprobe(p);
 		}
 	}
 
 	mutex_unlock(&text_mutex);
+	put_online_cpus();
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */
 	synchronize_sched();


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
