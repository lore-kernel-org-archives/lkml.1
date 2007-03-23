Return-Path: <linux-kernel-owner+w=401wt.eu-S1945900AbXCWOsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945900AbXCWOsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945896AbXCWOsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:48:12 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:55688 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945900AbXCWOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:48:09 -0400
Message-ID: <4603E7A4.50300@hitachi.com>
Date: Fri, 23 Mar 2007 23:43:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][Patch 1/4] kprobe fast unregistration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ananth,

Here is a series of patches which introduce two kinds of interfaces
for speeding up unregistering process of kprobes.

Currently, the unregister_*probe() function takes a long time to
unregister specified probe because it waits the rcu synchronization
after each unregistration. So we need to introduce new method for
unregistering a lot of probes at once.

I'd like to suggest introducing following two interfaces for this issue.
The first interface is unregister_*probe_fast(). This removes
breakpoint instruction from kernel code and adds specified probe
to the unregistering list.
The second interface is commit_kprobes(). This waits the rcu
synchronization and clean up each probe on the unregistering list.
This patch also adds a list_head member to the kprobe data structure
for linking to the unregistering list.

If using these interfaces, the probe handlers of unregistering probes
might be called after unregister_*probe_fast() is called. So, you MUST
call commit_kprobes() after calling unregisnter_*probe_fast() for all
probes.

It is safe even if several threads unregister probes simultaneously,
because the unregistration process is protected by kprobe_lock mutex.
If one thread calls commit_kprobes(), it will cleanup not only its probes
but also the other thread's probes. And it is transparently done.
If there is no unregistering probes, commit_kprobes() do nothing.

Here is an example code.
--
struct kprobes *p;
for_each_probe(p) {
	unregister_kprobe_fast(p);
}
commit_kprobes();
--

Best regards,

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
 This patch introduces unregister_kprobe_fast() and commit_kprobes().

 arch/i386/kernel/kprobes.c    |    2
 arch/ia64/kernel/kprobes.c    |    2
 arch/powerpc/kernel/kprobes.c |    2
 arch/s390/kernel/kprobes.c    |    2
 arch/x86_64/kernel/kprobes.c  |    2
 include/linux/kprobes.h       |   11 +++
 kernel/kprobes.c              |  138 +++++++++++++++++++++++++++++++-----------
 7 files changed, 115 insertions(+), 44 deletions(-)

Index: linux-2.6.21-rc4-mm1/include/linux/kprobes.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/include/linux/kprobes.h
+++ linux-2.6.21-rc4-mm1/include/linux/kprobes.h
@@ -68,6 +68,9 @@ struct kprobe {
 	/* list of kprobes for multi-handler support */
 	struct list_head list;

+	/* list of kprobes for fast unregistering support */
+	struct list_head commit_list;
+
 	/* Indicates that the corresponding module has been ref counted */
 	unsigned int mod_refcounted;

@@ -190,6 +193,8 @@ static inline struct kprobe_ctlblk *get_

 int register_kprobe(struct kprobe *p);
 void unregister_kprobe(struct kprobe *p);
+void unregister_kprobe_fast(struct kprobe *p);
+void commit_kprobes(void);
 int setjmp_pre_handler(struct kprobe *, struct pt_regs *);
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
@@ -220,6 +225,9 @@ static inline int register_kprobe(struct
 static inline void unregister_kprobe(struct kprobe *p)
 {
 }
+static inline void unregister_kprobe_fast(struct kprobe *p)
+{
+}
 static inline int register_jprobe(struct jprobe *p)
 {
 	return -ENOSYS;
@@ -240,5 +248,8 @@ static inline void unregister_kretprobe(
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline void commit_kprobes(void)
+{
+}
 #endif				/* CONFIG_KPROBES */
 #endif				/* _LINUX_KPROBES_H */
Index: linux-2.6.21-rc4-mm1/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/kernel/kprobes.c
@@ -62,6 +62,8 @@
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 static atomic_t kprobe_count;
+static LIST_HEAD(clean_probe_list);
+static LIST_HEAD(dirty_probe_list);

 DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
@@ -584,6 +586,8 @@ static int __kprobes __register_kprobe(s
 	}

 	p->nmissed = 0;
+	/* Initialize multiprobe list for __unregister_kprobe_bottom() */
+	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
@@ -596,6 +600,7 @@ static int __kprobes __register_kprobe(s
 	if ((ret = arch_prepare_kprobe(p)) != 0)
 		goto out;

+	INIT_LIST_HEAD(&p->commit_list);
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
@@ -620,80 +625,143 @@ int __kprobes register_kprobe(struct kpr
 		(unsigned long)__builtin_return_address(0));
 }

-void __kprobes unregister_kprobe(struct kprobe *p)
+/*
+ * Unregister a kprobe without a scheduler synchronization.
+ * You have to invoke commit_kprobes before releasing the kprobe.
+ */
+static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
-	struct module *mod;
 	struct kprobe *old_p, *list_p;
-	int cleanup_p;
+	int cleanup;

-	mutex_lock(&kprobe_mutex);
 	old_p = get_kprobe(p->addr);
 	if (unlikely(!old_p)) {
-		mutex_unlock(&kprobe_mutex);
-		return;
+		return -EINVAL;
 	}
 	if (p != old_p) {
 		list_for_each_entry_rcu(list_p, &old_p->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
 				goto valid_p;
-		mutex_unlock(&kprobe_mutex);
-		return;
+		return -EINVAL;
 	}
 valid_p:
 	if ((old_p == p) || ((old_p->pre_handler == aggr_pre_handler) &&
 		(p->list.next == &old_p->list) &&
 		(p->list.prev == &old_p->list))) {
-		/* Only probe on the hash list */
-		arch_disarm_kprobe(p);
-		hlist_del_rcu(&old_p->hlist);
-		cleanup_p = 1;
+		/* Only this probe on the hash list */
+  		arch_disarm_kprobe(p);
+  		hlist_del_rcu(&old_p->hlist);
+		cleanup = 1;
 	} else {
+		if (p->break_handler)
+			old_p->break_handler = NULL;
+		if (p->post_handler){
+			list_for_each_entry_rcu(list_p, &old_p->list, list){
+				if ((list_p != p) && (list_p->post_handler)){
+					goto noclean;
+				}
+			}
+			old_p->post_handler = NULL;
+		}
+noclean:
 		list_del_rcu(&p->list);
-		cleanup_p = 0;
+		cleanup = 0;
 	}

-	mutex_unlock(&kprobe_mutex);
+	return cleanup;
+}
+
+static void __kprobes __unregister_kprobe_bottom(struct kprobe *p, int cleanup)
+{
+	struct module *mod;
+	struct kprobe *old_p;

-	synchronize_sched();
 	if (p->mod_refcounted &&
 	    (mod = module_text_address((unsigned long)p->addr)))
 		module_put(mod);

-	if (cleanup_p) {
-		if (p != old_p) {
+	if (cleanup) {
+		if (!list_empty(&p->list)) {
+			/* "p" is the last child of an aggr_kprobe */
+			old_p = list_entry(p->list.next, struct kprobe, list);
 			list_del_rcu(&p->list);
 			kfree(old_p);
 		}
 		arch_remove_kprobe(p);
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
 	}

 	/* Call unregister_page_fault_notifier()
 	 * if no probes are active
 	 */
-	mutex_lock(&kprobe_mutex);
 	if (atomic_add_return(-1, &kprobe_count) == \
 				ARCH_INACTIVE_KPROBE_COUNT)
 		unregister_page_fault_notifier(&kprobe_page_fault_nb);
-	mutex_unlock(&kprobe_mutex);
 	return;
 }

+/*
+ * Commit to optimize kprobes and remove optimized kprobes.
+ */
+void __kprobes commit_kprobes(void)
+{
+	struct kprobe *kp;
+	/* Protect from unregistering probes while waiting on synchronize_sched()*/
+	mutex_lock(&kprobe_mutex);
+
+	if (!list_empty(&clean_probe_list) ||
+	    !list_empty(&dirty_probe_list)) {
+		/* synchronize for cleaning up running probes */
+		synchronize_sched();
+
+		while (!list_empty(&clean_probe_list)) {
+			kp = list_entry(clean_probe_list.next, struct kprobe,
+					commit_list);
+			list_del_init(&kp->commit_list);
+			__unregister_kprobe_bottom(kp, 0);
+		}
+		while (!list_empty(&dirty_probe_list)) {
+			kp = list_entry(dirty_probe_list.next, struct kprobe,
+					commit_list);
+			list_del_init(&kp->commit_list);
+			__unregister_kprobe_bottom(kp, 1);
+		}
+	}
+	mutex_unlock(&kprobe_mutex);
+	return ;
+}
+
+void __kprobes unregister_kprobe_fast(struct kprobe *p)
+{
+	int cleanup;
+
+	mutex_lock(&kprobe_mutex);
+	cleanup = __unregister_kprobe_top(p);
+	if (cleanup == 0) {
+		list_add(&p->commit_list, &clean_probe_list);
+	} else if (cleanup == 1) {
+		list_add(&p->commit_list, &dirty_probe_list);
+	}
+	mutex_unlock(&kprobe_mutex);
+}
+
+void __kprobes unregister_kprobe(struct kprobe *p)
+{
+	int cleanup;
+
+	mutex_lock(&kprobe_mutex);
+	cleanup = __unregister_kprobe_top(p);
+	mutex_unlock(&kprobe_mutex);
+
+	if (cleanup < 0) return ;
+
+	synchronize_sched();
+
+	mutex_lock(&kprobe_mutex);
+	__unregister_kprobe_bottom(p, cleanup);
+	mutex_unlock(&kprobe_mutex);
+}
+
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
 	.priority = 0x7fffffff /* we need to be notified first */
@@ -929,6 +997,8 @@ module_init(init_kprobes);

 EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
+EXPORT_SYMBOL_GPL(unregister_kprobe_fast);
+EXPORT_SYMBOL_GPL(commit_kprobes);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(jprobe_return);
Index: linux-2.6.21-rc4-mm1/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/i386/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/kprobes.c
@@ -183,9 +183,7 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
 }

 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
Index: linux-2.6.21-rc4-mm1/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/ia64/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/arch/ia64/kernel/kprobes.c
@@ -570,9 +570,7 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
Index: linux-2.6.21-rc4-mm1/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/powerpc/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/arch/powerpc/kernel/kprobes.c
@@ -84,9 +84,7 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }

 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6.21-rc4-mm1/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/s390/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/arch/s390/kernel/kprobes.c
@@ -218,9 +218,7 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }

 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6.21-rc4-mm1/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/x86_64/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/arch/x86_64/kernel/kprobes.c
@@ -223,9 +223,7 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }

 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)


