Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYKKU5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYKKU5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYKKU5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:57:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYKKU5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:57:05 -0500
Message-ID: <4919F175.2050009@redhat.com>
Date: Tue, 11 Nov 2008 15:56:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/7] kprobes: Add kprobe_insn_mutex and cleanup arch_remove_kprobe()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kprobe_insn_mutex for protecting kprobe_insn_pages hlist, and remove
kprobe_mutex from architecture dependent code.

This allows us to call arch_remove_kprobe() (and free_insn_slot) while holding
kprobe_mutex.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/arm/kernel/kprobes.c     |    2 --
 arch/ia64/kernel/kprobes.c    |    8 +++++---
 arch/powerpc/kernel/kprobes.c |    7 ++++---
 arch/s390/kernel/kprobes.c    |    7 ++++---
 arch/x86/kernel/kprobes.c     |    7 ++++---
 include/linux/kprobes.h       |    1 -
 kernel/kprobes.c              |   25 +++++++++++++++++++++----
 7 files changed, 38 insertions(+), 19 deletions(-)

Index: 2.6.28-rc4/arch/arm/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/arch/arm/kernel/kprobes.c
+++ 2.6.28-rc4/arch/arm/kernel/kprobes.c
@@ -92,9 +92,7 @@ void __kprobes arch_disarm_kprobe(struct
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
 	if (p->ainsn.insn) {
-		mutex_lock(&kprobe_mutex);
 		free_insn_slot(p->ainsn.insn, 0);
-		mutex_unlock(&kprobe_mutex);
 		p->ainsn.insn = NULL;
 	}
 }
Index: 2.6.28-rc4/arch/ia64/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/arch/ia64/kernel/kprobes.c
+++ 2.6.28-rc4/arch/ia64/kernel/kprobes.c
@@ -670,9 +670,11 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, p->ainsn.inst_flag & INST_FLAG_BOOSTABLE);
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn,
+			       p->ainsn.inst_flag & INST_FLAG_BOOSTABLE);
+		p->ainsn.insn = NULL;
+	}
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
Index: 2.6.28-rc4/arch/powerpc/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/arch/powerpc/kernel/kprobes.c
+++ 2.6.28-rc4/arch/powerpc/kernel/kprobes.c
@@ -96,9 +96,10 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, 0);
+		p->ainsn.insn = NULL;
+	}
 }

 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: 2.6.28-rc4/arch/s390/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/arch/s390/kernel/kprobes.c
+++ 2.6.28-rc4/arch/s390/kernel/kprobes.c
@@ -218,9 +218,10 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, 0);
+		p->ainsn.insn = NULL;
+	}
 }

 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: 2.6.28-rc4/arch/x86/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/arch/x86/kernel/kprobes.c
+++ 2.6.28-rc4/arch/x86/kernel/kprobes.c
@@ -376,9 +376,10 @@ void __kprobes arch_disarm_kprobe(struct

 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
+		p->ainsn.insn = NULL;
+	}
 }

 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
Index: 2.6.28-rc4/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/kernel/kprobes.c
+++ 2.6.28-rc4/kernel/kprobes.c
@@ -69,7 +69,7 @@ static struct hlist_head kretprobe_inst_
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobe_enabled;

-DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
+static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
 	spinlock_t lock ____cacheline_aligned;
@@ -115,6 +115,7 @@ enum kprobe_slot_state {
 	SLOT_USED = 2,
 };

+static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_pages */
 static struct hlist_head kprobe_insn_pages;
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
@@ -144,10 +145,10 @@ loop_end:
 }

 /**
- * get_insn_slot() - Find a slot on an executable page for an instruction.
+ * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-kprobe_opcode_t __kprobes *get_insn_slot(void)
+static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 {
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
@@ -196,6 +197,15 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	return kip->insns;
 }

+kprobe_opcode_t __kprobes *get_insn_slot(void)
+{
+	kprobe_opcode_t *ret;
+	mutex_lock(&kprobe_insn_mutex);
+	ret = __get_insn_slot();
+	mutex_unlock(&kprobe_insn_mutex);
+	return ret;
+}
+
 /* Return 1 if all garbages are collected, otherwise 0. */
 static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 {
@@ -226,9 +236,13 @@ static int __kprobes collect_garbage_slo
 {
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos, *next;
+	int safety;

 	/* Ensure no-one is preepmted on the garbages */
-	if (check_safety() != 0)
+	mutex_unlock(&kprobe_insn_mutex);
+	safety = check_safety();
+	mutex_lock(&kprobe_insn_mutex);
+	if (safety != 0)
 		return -EAGAIN;

 	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
@@ -251,6 +265,7 @@ void __kprobes free_insn_slot(kprobe_opc
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;

+	mutex_lock(&kprobe_insn_mutex);
 	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->insns <= slot &&
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
@@ -267,6 +282,8 @@ void __kprobes free_insn_slot(kprobe_opc

 	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
 		collect_garbage_slots();
+
+	mutex_unlock(&kprobe_insn_mutex);
 }
 #endif

Index: 2.6.28-rc4/include/linux/kprobes.h
===================================================================
--- 2.6.28-rc4.orig/include/linux/kprobes.h
+++ 2.6.28-rc4/include/linux/kprobes.h
@@ -201,7 +201,6 @@ static inline int init_test_probes(void)
 }
 #endif /* CONFIG_KPROBES_SANITY_TEST */

-extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

