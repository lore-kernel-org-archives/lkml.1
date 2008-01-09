Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbYAICfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbYAICfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbYAICev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:34:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56428 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYAICet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:34:49 -0500
Date: Wed, 9 Jan 2008 02:34:46 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       hch@lst.de
cc: ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "x86: optimize page faults like all other achitectures
 and kill notifier cruft"
Message-ID: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[This an initial RFC but I'd like to have this patch in before 2.6.24 goes 
final as it really breaks this useful feature]

mmiotrace the MMIO access tracer used to reverse engineer binary blobs
used this notifier interface and is planned on being pushed upstream.

Having users able to just use the tracer module without having to rebuild 
their kernel to add in a page fault handler hack means we get a lot 
greater coverage for reverse engineering efforts.

Signed-off-by: David Airlie <airlied@linux.ie>

This reverts commit 74a0b5762713a26496db72eac34fbbed46f20fce.
Conflicts:

	include/asm-avr32/kprobes.h
	include/asm-ia64/kprobes.h
	include/asm-s390/kprobes.h
	include/asm-x86/kdebug_32.h
	include/asm-x86/kdebug_64.h
	include/asm-x86/kprobes_64.h
---
 arch/x86/kernel/kprobes_32.c  |    3 +-
 arch/x86/kernel/kprobes_64.c  |    1 +
 arch/x86/mm/fault_32.c        |   43 ++++++++++++++++++++++-----------------
 arch/x86/mm/fault_64.c        |   44 +++++++++++++++++++++++-----------------
 include/asm-avr32/kdebug.h    |   16 ++++++++++++++
 include/asm-avr32/kprobes.h   |    1 +
 include/asm-ia64/kdebug.h     |   15 ++++++++++++++
 include/asm-ia64/kprobes.h    |    1 +
 include/asm-powerpc/kdebug.h  |   19 +++++++++++++++++
 include/asm-powerpc/kprobes.h |    1 +
 include/asm-s390/kdebug.h     |   15 ++++++++++++++
 include/asm-s390/kprobes.h    |    1 +
 include/asm-sh/kdebug.h       |    2 +
 include/asm-sparc64/kdebug.h  |   18 ++++++++++++++++
 include/asm-sparc64/kprobes.h |    1 +
 include/asm-x86/kdebug.h      |    3 ++
 include/asm-x86/kprobes_32.h  |    2 +-
 include/asm-x86/kprobes_64.h  |    1 +
 kernel/kprobes.c              |   39 +++++++++++++++++++++++++++++++++--
 19 files changed, 183 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 3a020f7..1ba8fee 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -586,7 +586,7 @@ out:
 	return 1;
 }
 
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+static int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -668,6 +668,7 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
+	case DIE_PAGE_FAULT:
 		/* kprobe_running() needs smp_processor_id() */
 		preempt_disable();
 		if (kprobe_running() &&
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 5df19a9..279cea7 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -654,6 +654,7 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_GPF:
+	case DIE_PAGE_FAULT:
 		/* kprobe_running() needs smp_processor_id() */
 		preempt_disable();
 		if (kprobe_running() &&
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index a2273d4..f03cc93 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -25,7 +25,6 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
-#include <linux/kprobes.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -33,27 +32,33 @@
 
 extern void die(const char *,struct pt_regs *,long);
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
+static ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
+
+int register_page_fault_notifier(struct notifier_block *nb)
 {
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode_vm(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
+	vmalloc_sync_all();
+	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
+}
+EXPORT_SYMBOL_GPL(register_page_fault_notifier);
 
-	return ret;
+int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
 }
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
+EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
+
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
-	return 0;
+	struct die_args args = {
+		.regs = regs,
+		.str = "page fault",
+		.err = err,
+		.trapnr = 14,
+		.signr = SIGSEGV
+	};
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+	                                  DIE_PAGE_FAULT, &args);
 }
-#endif
 
 /*
  * Return EIP plus the CS segment base.  The segment limit is also
@@ -331,7 +336,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(regs))
+		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -340,7 +345,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 0e26230..0b0d3d4 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -25,7 +25,6 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
-#include <linux/kprobes.h>
 
 #include <asm/system.h>
 #include <asm/pgalloc.h>
@@ -41,27 +40,34 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-#ifdef CONFIG_KPROBES
-static inline int notify_page_fault(struct pt_regs *regs)
+static ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
+
+/* Hook to register for page fault notifications */
+int register_page_fault_notifier(struct notifier_block *nb)
 {
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
+	vmalloc_sync_all();
+	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
+}
+EXPORT_SYMBOL_GPL(register_page_fault_notifier);
 
-	return ret;
+int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
 }
-#else
-static inline int notify_page_fault(struct pt_regs *regs)
+EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
+
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
-	return 0;
+	struct die_args args = {
+		.regs = regs,
+		.str = "page fault",
+		.err = err,
+		.trapnr = 14,
+		.signr = SIGSEGV
+	};
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+	                                  DIE_PAGE_FAULT, &args);
 }
-#endif
 
 /* Sometimes the CPU reports invalid exceptions on prefetch.
    Check that here and ignore.
@@ -343,7 +349,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
-		if (notify_page_fault(regs))
+		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -352,7 +358,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs))
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
diff --git a/include/asm-avr32/kdebug.h b/include/asm-avr32/kdebug.h
index fd7e990..7f54e2b 100644
--- a/include/asm-avr32/kdebug.h
+++ b/include/asm-avr32/kdebug.h
@@ -1,10 +1,26 @@
 #ifndef __ASM_AVR32_KDEBUG_H
 #define __ASM_AVR32_KDEBUG_H
 
+#include <linux/notifier.h>
+
 /* Grossly misnamed. */
 enum die_val {
 	DIE_BREAKPOINT,
 	DIE_SSTEP,
 };
 
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation.  Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
 #endif /* __ASM_AVR32_KDEBUG_H */
diff --git a/include/asm-avr32/kprobes.h b/include/asm-avr32/kprobes.h
index 996cb65..99de3a6 100644
--- a/include/asm-avr32/kprobes.h
+++ b/include/asm-avr32/kprobes.h
@@ -18,6 +18,7 @@ typedef u16	kprobe_opcode_t;
 #define MAX_INSN_SIZE		2
 
 #define kretprobe_blacklist_size 0
+#define ARCH_INACTIVE_KPROBE_COUNT 1
 
 #define arch_remove_kprobe(p)	do { } while (0)
 
diff --git a/include/asm-ia64/kdebug.h b/include/asm-ia64/kdebug.h
index 35e4940..320cd8e 100644
--- a/include/asm-ia64/kdebug.h
+++ b/include/asm-ia64/kdebug.h
@@ -26,6 +26,21 @@
  * 2005-Oct	Keith Owens <kaos@sgi.com>.  Expand notify_die to cover more
  *		events.
  */
+#include <linux/notifier.h>
+
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation.  Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 
 enum die_val {
 	DIE_BREAK = 1,
diff --git a/include/asm-ia64/kprobes.h b/include/asm-ia64/kprobes.h
index a93ce9e..b8467a0 100644
--- a/include/asm-ia64/kprobes.h
+++ b/include/asm-ia64/kprobes.h
@@ -84,6 +84,7 @@ struct kprobe_ctlblk {
 
 #define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
+#define  ARCH_INACTIVE_KPROBE_COUNT 1
 
 #define SLOT0_OPCODE_SHIFT	(37)
 #define SLOT1_p1_OPCODE_SHIFT	(37 - (64-46))
diff --git a/include/asm-powerpc/kdebug.h b/include/asm-powerpc/kdebug.h
index ae6d206..295f016 100644
--- a/include/asm-powerpc/kdebug.h
+++ b/include/asm-powerpc/kdebug.h
@@ -2,6 +2,25 @@
 #define _ASM_POWERPC_KDEBUG_H
 #ifdef __KERNEL__
 
+/* nearly identical to x86_64/i386 code */
+
+#include <linux/notifier.h>
+
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation.  Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+extern struct atomic_notifier_head powerpc_die_chain;
+
 /* Grossly misnamed. */
 enum die_val {
 	DIE_OOPS = 1,
diff --git a/include/asm-powerpc/kprobes.h b/include/asm-powerpc/kprobes.h
index afabad2..54de529 100644
--- a/include/asm-powerpc/kprobes.h
+++ b/include/asm-powerpc/kprobes.h
@@ -81,6 +81,7 @@ typedef unsigned int kprobe_opcode_t;
 #endif
 
 #define ARCH_SUPPORTS_KRETPROBES
+#define  ARCH_INACTIVE_KPROBE_COUNT 1
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
diff --git a/include/asm-s390/kdebug.h b/include/asm-s390/kdebug.h
index 40db27c..04418af 100644
--- a/include/asm-s390/kdebug.h
+++ b/include/asm-s390/kdebug.h
@@ -4,9 +4,24 @@
 /*
  * Feb 2006 Ported to s390 <grundym@us.ibm.com>
  */
+#include <linux/notifier.h>
 
 struct pt_regs;
 
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation. Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
 enum die_val {
 	DIE_OOPS = 1,
 	DIE_BPT,
diff --git a/include/asm-s390/kprobes.h b/include/asm-s390/kprobes.h
index 948db3d..a504709 100644
--- a/include/asm-s390/kprobes.h
+++ b/include/asm-s390/kprobes.h
@@ -48,6 +48,7 @@ typedef u16 kprobe_opcode_t;
 
 #define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
+#define ARCH_INACTIVE_KPROBE_COUNT 0
 
 #define KPROBE_SWAP_INST	0x10
 
diff --git a/include/asm-sh/kdebug.h b/include/asm-sh/kdebug.h
index 49cd690..382cfc7 100644
--- a/include/asm-sh/kdebug.h
+++ b/include/asm-sh/kdebug.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_KDEBUG_H
 #define __ASM_SH_KDEBUG_H
 
+#include <linux/notifier.h>
+
 /* Grossly misnamed. */
 enum die_val {
 	DIE_TRAP,
diff --git a/include/asm-sparc64/kdebug.h b/include/asm-sparc64/kdebug.h
index f905b77..9974c7b 100644
--- a/include/asm-sparc64/kdebug.h
+++ b/include/asm-sparc64/kdebug.h
@@ -1,8 +1,26 @@
 #ifndef _SPARC64_KDEBUG_H
 #define _SPARC64_KDEBUG_H
 
+/* Nearly identical to x86_64/i386 code. */
+
+#include <linux/notifier.h>
+
 struct pt_regs;
 
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation.  Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
 extern void bad_trap(struct pt_regs *, long);
 
 /* Grossly misnamed. */
diff --git a/include/asm-sparc64/kprobes.h b/include/asm-sparc64/kprobes.h
index 5020eaf..a646a12 100644
--- a/include/asm-sparc64/kprobes.h
+++ b/include/asm-sparc64/kprobes.h
@@ -13,6 +13,7 @@ typedef u32 kprobe_opcode_t;
 #define kretprobe_blacklist_size 0
 
 #define arch_remove_kprobe(p)	do {} while (0)
+#define  ARCH_INACTIVE_KPROBE_COUNT 0
 
 #define flush_insn_slot(p)		\
 do { 	flushi(&(p)->ainsn.insn[0]);	\
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index e2f9b62..375acd7 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -5,6 +5,9 @@
 
 struct pt_regs;
 
+extern int register_page_fault_notifier(struct notifier_block *);
+extern int unregister_page_fault_notifier(struct notifier_block *);
+
 /* Grossly misnamed. */
 enum die_val {
 	DIE_OOPS = 1,
diff --git a/include/asm-x86/kprobes_32.h b/include/asm-x86/kprobes_32.h
index 9fe8f3b..44268fa 100644
--- a/include/asm-x86/kprobes_32.h
+++ b/include/asm-x86/kprobes_32.h
@@ -43,6 +43,7 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
+#define  ARCH_INACTIVE_KPROBE_COUNT 0
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
@@ -90,5 +91,4 @@ static inline void restore_interrupts(struct pt_regs *regs)
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
-extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 #endif				/* _ASM_KPROBES_H */
diff --git a/include/asm-x86/kprobes_64.h b/include/asm-x86/kprobes_64.h
index 743d762..b2878e2 100644
--- a/include/asm-x86/kprobes_64.h
+++ b/include/asm-x86/kprobes_64.h
@@ -43,6 +43,7 @@ typedef u8 kprobe_opcode_t;
 
 #define ARCH_SUPPORTS_KRETPROBES
 extern const int kretprobe_blacklist_size;
+#define  ARCH_INACTIVE_KPROBE_COUNT 1
 
 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e3a5d81..a655f36 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -64,6 +64,7 @@
 
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
+static atomic_t kprobe_count;
 
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobe_enabled;
@@ -72,6 +73,11 @@ DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 
+static struct notifier_block kprobe_page_fault_nb = {
+	.notifier_call = kprobe_exceptions_notify,
+	.priority = 0x7fffffff /* we need to notified first */
+};
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -550,6 +556,8 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
 		ret = register_aggr_kprobe(old_p, p);
+		if (!ret)
+			atomic_inc(&kprobe_count);
 		goto out;
 	}
 
@@ -561,9 +569,13 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (kprobe_enabled)
-		arch_arm_kprobe(p);
+	if (kprobe_enabled) {
+		if (atomic_add_return(1, &kprobe_count) == \
+				(ARCH_INACTIVE_KPROBE_COUNT + 1))
+			register_page_fault_notifier(&kprobe_page_fault_nb);
 
+		arch_arm_kprobe(p);
+	}
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -646,6 +658,16 @@ valid_p:
 		}
 		mutex_unlock(&kprobe_mutex);
 	}
+
+	/* Call unregister_page_fault_notifier()
+	 * if no probes are active
+	 */
+	mutex_lock(&kprobe_mutex);
+	if (atomic_add_return(-1, &kprobe_count) == \
+				ARCH_INACTIVE_KPROBE_COUNT)
+		unregister_page_fault_notifier(&kprobe_page_fault_nb);
+	mutex_unlock(&kprobe_mutex);
+	return;
 }
 
 static struct notifier_block kprobe_exceptions_nb = {
@@ -805,6 +827,7 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kprobe_table[i]);
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}
+	atomic_set(&kprobe_count, 0);
 
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
@@ -921,6 +944,13 @@ static void __kprobes enable_all_kprobes(void)
 	if (kprobe_enabled)
 		goto already_enabled;
 
+	/*
+	 * Re-register the page fault notifier only if there are any
+	 * active probes at the time of enabling kprobes globally
+	 */
+	if (atomic_read(&kprobe_count) > ARCH_INACTIVE_KPROBE_COUNT)
+		register_page_fault_notifier(&kprobe_page_fault_nb);
+
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
@@ -961,7 +991,10 @@ static void __kprobes disable_all_kprobes(void)
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */
 	synchronize_sched();
-	return;
+
+	mutex_lock(&kprobe_mutex);
+	/* Unconditionally unregister the page_fault notifier */
+	unregister_page_fault_notifier(&kprobe_page_fault_nb);
 
 already_disabled:
 	mutex_unlock(&kprobe_mutex);
-- 
1.5.3.3

