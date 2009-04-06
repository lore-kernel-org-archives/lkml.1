Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZDFVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZDFVsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZDFVsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:48:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47652 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZDFVse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:48:34 -0400
Message-ID: <49DA78A7.1060102@redhat.com>
Date: Mon, 06 Apr 2009 17:48:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][PROTO][PATCH -tip 3/7] kprobes: kprobes jump optimization core
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kprobes jump optimization arch-independent parts.
Kprobes uses breakpoint instruction for interrupting execution flow, on
some kind of processors, it can be replaced by a jump instruction and
interruption emulation code. This gains kprobs' performance drastically.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 arch/Kconfig            |   11 +++
 include/linux/kprobes.h |   23 +++++++
 kernel/kprobes.c        |  156 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 184 insertions(+), 6 deletions(-)


diff --git a/arch/Kconfig b/arch/Kconfig
index dc81b34..6bc1a48 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -44,6 +44,15 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".

+config OPTPROBES
+	bool "Kprobes jump optimization support (EXPERIMENTAL)"
+	depends on KPROBES
+	depends on !PREEMPT
+	depends on HAVE_OPTPROBES
+	help
+	  This option will allow kprobes to optimize breakpoint to
+	  a jump for reducing its overhead.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -79,6 +88,8 @@ config HAVE_KPROBES
 config HAVE_KRETPROBES
 	bool

+config HAVE_OPTPROBES
+	bool
 #
 # An arch should select this if it provides all these things:
 #
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index bcd9c07..065bb24 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -122,6 +122,7 @@ struct kprobe {
 /* Kprobe status flags */
 #define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
 #define KPROBE_FLAG_DISABLED	2 /* probe is temporarily disabled */
+#define KPROBE_FLAG_OPTIMIZE	4 /* probe will be optimized by jump */

 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
@@ -248,6 +249,28 @@ extern void show_registers(struct pt_regs *regs);
 extern kprobe_opcode_t *get_insn_slot(void);
 extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
+extern int aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
+
+#ifdef CONFIG_OPTPROBES
+/*
+ * Internal structure for direct jump optimized probe
+ */
+struct optimized_kprobe {
+	struct kprobe kp;
+	struct list_head list;	/* list for commitment */
+	struct arch_optimized_insn optinsn;
+};
+
+/* architecture dependent functions for direct jump optimization */
+extern int arch_optimized_kprobe_address(struct optimized_kprobe *op,
+					 unsigned long addr);
+extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
+extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
+extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
+extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
+extern int arch_detour_optimized_kprobe(struct optimized_kprobe *op,
+					struct pt_regs *regs);
+#endif

 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ca4b03c..ba731ff 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -333,7 +333,7 @@ struct kprobe __kprobes *get_kprobe(void *addr)
  * Aggregate handlers for multiple kprobes support - these handlers
  * take care of invoking the individual kprobe handlers on p->list
  */
-static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
+int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *kp;

@@ -391,11 +391,35 @@ static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return ret;
 }

+#ifdef CONFIG_OPTPROBES
+static int __kprobes opt_pre_handler(struct kprobe *kp,
+					 struct pt_regs *regs)
+{
+	struct optimized_kprobe *op;
+	op = container_of(kp, struct optimized_kprobe, kp);
+	return arch_detour_optimized_kprobe(op, regs);
+}
+
+/* return true if the kprobe is a jump optimized probe */
+static inline int kprobe_optimized(struct kprobe *p)
+{
+	return p->pre_handler == opt_pre_handler;
+}
+#else /* !cONFIG_OPTPROBES */
+#define kprobe_optimized(p) (0)
+#endif
+
+/* return true if the kprobe is an aggregator */
+static inline int kprobe_aggregated(struct kprobe *p)
+{
+	return p->pre_handler == aggr_pre_handler || kprobe_optimized(p);
+}
+
 /* Walks the list and increments nmissed count for multiprobe case */
 void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
 {
 	struct kprobe *kp;
-	if (p->pre_handler != aggr_pre_handler) {
+	if (!kprobe_aggregated(p)) {
 		p->nmissed++;
 	} else {
 		list_for_each_entry_rcu(kp, &p->list, list)
@@ -534,6 +558,8 @@ static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
 static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
+	if (kprobe_optimized(ap) && (p->break_handler || p->post_handler))
+		return -EEXIST;	/*FIXME: fallback to kprobe */
 	if (p->break_handler) {
 		if (ap->break_handler)
 			return -EEXIST;
@@ -587,7 +613,7 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 	int ret = 0;
 	struct kprobe *ap = old_p;

-	if (old_p->pre_handler != aggr_pre_handler) {
+	if (!kprobe_aggregated(old_p)) {
 		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
 		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
 		if (!ap)
@@ -640,6 +666,104 @@ static int __kprobes try_to_disable_aggr_kprobe(struct kprobe *p)
 	return 1;
 }

+#ifdef CONFIG_OPTPROBES
+static LIST_HEAD(optimizing_list);
+static DEFINE_MUTEX(optimizing_lock);
+
+static void kprobe_optimizer(struct work_struct *work)
+{
+	struct optimized_kprobe *op, *tmp;
+	mutex_lock(&optimizing_lock);
+	/* wait quiesence period for safety */
+	synchronize_sched();
+	list_for_each_entry_safe(op, tmp, &optimizing_list, list) {
+		if (!arch_optimize_kprobe(op))
+			list_del_init(&op->list);
+	}
+	mutex_unlock(&optimizing_lock);
+}
+
+static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
+#define OPTIMIZE_DELAY 10
+
+static void start_optimizing(struct optimized_kprobe *op)
+{
+	mutex_lock(&optimizing_lock);
+	list_add(&op->list, &optimizing_list);
+	mutex_unlock(&optimizing_lock);
+	if (!delayed_work_pending(&optimizing_work))
+		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+}
+
+/* p must be a registered kprobe */
+static int optimize_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+	int ret;
+	if (p->break_handler || p->post_handler)
+		return -EINVAL;
+
+	op = kzalloc(sizeof(struct optimized_kprobe), GFP_KERNEL);
+	if (!op)
+		return -ENOMEM;
+	copy_kprobe(p, &op->kp);
+	op->kp.addr = p->addr;
+	op->kp.flags = p->flags;
+	op->kp.pre_handler = opt_pre_handler;
+	op->kp.fault_handler = aggr_fault_handler;
+	INIT_LIST_HEAD(&op->list);
+	INIT_LIST_HEAD(&op->kp.list);
+
+	/* preparing arch specific insn buffer */
+	ret = arch_prepare_optimized_kprobe(op);
+	if (ret) {
+		/* if failed to setup optimizing, fallback to kprobe */
+		kfree(op);
+		return ret;
+	}
+
+	/* replace with original kprobe */
+	list_add_rcu(&p->list, &op->kp.list);
+	hlist_replace_rcu(&p->hlist, &op->kp.hlist);
+
+	/* enqueue on the optimization queue */
+	start_optimizing(op);
+	return 0;
+}
+
+static void unoptimize_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+	op = container_of(p, struct optimized_kprobe, kp);
+	if (!list_empty(&op->list))
+		/* dequeue from the optimization queue */
+		list_del_init(&op->list);
+	else
+		/* replace jump with break */
+		arch_unoptimize_kprobe(op);
+}
+
+static struct kprobe *get_optimized_kprobe(unsigned long addr)
+{
+	int i;
+	struct kprobe *p;
+	struct optimized_kprobe *op;
+	for (i = 0; i < MAX_OPTIMIZED_LENGTH; i++) {
+		p = get_kprobe((void *)(addr - i));
+		if (p && kprobe_optimized(p)) {
+			op = container_of(p, struct optimized_kprobe, kp);
+			if (arch_optimized_kprobe_address(op, addr - i))
+				return p;
+		}
+	}
+	return NULL;
+}
+#else /* !CONFIG_OPTPROBES */
+#define optimize_kprobe(p) (-ENOSYS)
+#define unoptimize_kprobe(p) do {} while (0)
+#define get_optimized_kprobe(addr) (NULL)
+#endif
+
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
@@ -698,8 +822,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 		return -EINVAL;
 	}

-	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
-	p->flags &= KPROBE_FLAG_DISABLED;
+	/* User can pass only DISABLED or OPTIMIZE to register_kprobe */
+	p->flags &= KPROBE_FLAG_DISABLED | KPROBE_FLAG_OPTIMIZE;

 	/*
 	 * Check if are we probing a module.
@@ -725,6 +849,11 @@ int __kprobes register_kprobe(struct kprobe *p)
 			return -EINVAL;
 		}
 	}
+
+	/* check collision with other optimized kprobes */
+	old_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (old_p && old_p->addr != p->addr)
+		unoptimize_kprobe(old_p); /* fallback to kprobe */
 	preempt_enable();

 	p->nmissed = 0;
@@ -748,6 +877,10 @@ int __kprobes register_kprobe(struct kprobe *p)
 	if (!kprobes_all_disarmed && !kprobe_disabled(p))
 		arch_arm_kprobe(p);

+	if (p->flags & KPROBE_FLAG_OPTIMIZE)
+		if (optimize_kprobe(p))
+			p->flags &= ~KPROBE_FLAG_OPTIMIZE;
+
 out_unlock_text:
 	mutex_unlock(&text_mutex);
 out:
@@ -792,7 +925,7 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		return -EINVAL;

 	if (old_p == p ||
-	    (old_p->pre_handler == aggr_pre_handler &&
+	    (kprobe_aggregated(old_p) &&
 	     list_is_singular(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
@@ -801,6 +934,8 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		 */
 		if (!kprobes_all_disarmed && !kprobe_disabled(old_p)) {
 			mutex_lock(&text_mutex);
+			if (kprobe_optimized(old_p))
+				unoptimize_kprobe(old_p);
 			arch_disarm_kprobe(p);
 			mutex_unlock(&text_mutex);
 		}
@@ -836,6 +971,15 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 		/* "p" is the last child of an aggr_kprobe */
 		old_p = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
+#ifdef CONFIG_OPTPROBES
+		if (kprobe_optimized(old_p)) {
+			struct optimized_kprobe *op;
+			op = container_of(old_p, struct optimized_kprobe, kp);
+			arch_remove_optimized_kprobe(op);
+			kfree(op);
+			return;
+		}
+#endif
 		arch_remove_kprobe(old_p);
 		kfree(old_p);
 	}
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


