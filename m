Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbXKPUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbXKPUCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763557AbXKPUBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:01:54 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38605 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760161AbXKPUBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:01:53 -0500
Message-Id: <20071116200137.299042657@polymtl.ca>
References: <20071116195747.448703304@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 14:57:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [rfc-patch 02/11] Kprobes - do not use kprobes mutex in arch code
Content-Disposition: inline; filename=kprobes-dont-use-kprobes-mutex-in-arch-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:01:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
remove all use of this mutex in the architecture specific code, replacing it by
a proper mutex lock/unlock in the architecture agnostic code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: prasanna@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/ia64/kernel/kprobes.c    |    2 --
 arch/powerpc/kernel/kprobes.c |    2 --
 arch/s390/kernel/kprobes.c    |    2 --
 arch/x86/kernel/kprobes_32.c  |    2 --
 arch/x86/kernel/kprobes_64.c  |    2 --
 include/linux/kprobes.h       |    2 --
 kernel/kprobes.c              |    2 ++
 7 files changed, 2 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/include/linux/kprobes.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kprobes.h	2007-11-13 09:45:33.000000000 -0500
+++ linux-2.6-lttng/include/linux/kprobes.h	2007-11-13 09:45:35.000000000 -0500
@@ -35,7 +35,6 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
-#include <linux/mutex.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -183,7 +182,6 @@ static inline void kretprobe_assert(stru
 }
 
 extern spinlock_t kretprobe_lock;
-extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
Index: linux-2.6-lttng/arch/x86/kernel/kprobes_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/kprobes_32.c	2007-11-13 09:45:33.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/kprobes_32.c	2007-11-13 09:45:35.000000000 -0500
@@ -186,9 +186,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-11-13 09:45:35.000000000 -0500
+++ linux-2.6-lttng/kernel/kprobes.c	2007-11-13 09:45:35.000000000 -0500
@@ -644,7 +644,9 @@ valid_p:
 			list_del_rcu(&p->list);
 			kfree(old_p);
 		}
+		mutex_lock(&kprobe_mutex);
 		arch_remove_kprobe(p);
+		mutex_unlock(&kprobe_mutex);
 	} else {
 		mutex_lock(&kprobe_mutex);
 		if (p->break_handler)
Index: linux-2.6-lttng/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/kernel/kprobes.c	2007-11-13 09:45:33.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/kernel/kprobes.c	2007-11-13 09:45:35.000000000 -0500
@@ -567,9 +567,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
Index: linux-2.6-lttng/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/kprobes.c	2007-11-13 09:45:33.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/kprobes.c	2007-11-13 09:45:35.000000000 -0500
@@ -88,9 +88,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6-lttng/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/kprobes.c	2007-11-13 09:45:33.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/kprobes.c	2007-11-13 09:45:35.000000000 -0500
@@ -220,9 +220,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6-lttng/arch/x86/kernel/kprobes_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/kprobes_64.c	2007-11-13 09:45:33.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/kprobes_64.c	2007-11-13 09:45:35.000000000 -0500
@@ -225,9 +225,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
