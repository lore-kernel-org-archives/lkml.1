Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYAXUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYAXUho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbYAXUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:34:17 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58232 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184AbYAXUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:34:12 -0500
Message-Id: <20080124203334.284567179@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 05/26] Kprobes - do not use kprobes mutex in arch code
Content-Disposition: inline; filename=kprobes-dont-use-kprobes-mutex-in-arch-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
remove all use of this mutex in the architecture specific code, replacing it by
a proper mutex lock/unlock in the architecture agnostic code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/ia64/kernel/kprobes.c    |    2 --
 arch/powerpc/kernel/kprobes.c |    2 --
 arch/s390/kernel/kprobes.c    |    2 --
 arch/x86/kernel/kprobes.c     |    2 --
 include/linux/kprobes.h       |    2 --
 kernel/kprobes.c              |    2 ++
 6 files changed, 2 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng.mm/include/linux/kprobes.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/linux/kprobes.h	2008-01-24 14:10:54.000000000 -0500
+++ linux-2.6-lttng.mm/include/linux/kprobes.h	2008-01-24 14:20:48.000000000 -0500
@@ -35,7 +35,6 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
-#include <linux/mutex.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -192,7 +191,6 @@ static inline int init_test_probes(void)
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
 extern spinlock_t kretprobe_lock;
-extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
Index: linux-2.6-lttng.mm/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/kernel/kprobes.c	2008-01-24 14:20:17.000000000 -0500
+++ linux-2.6-lttng.mm/kernel/kprobes.c	2008-01-24 14:20:48.000000000 -0500
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
Index: linux-2.6-lttng.mm/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/ia64/kernel/kprobes.c	2008-01-24 14:09:02.000000000 -0500
+++ linux-2.6-lttng.mm/arch/ia64/kernel/kprobes.c	2008-01-24 14:20:48.000000000 -0500
@@ -582,9 +582,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
Index: linux-2.6-lttng.mm/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/powerpc/kernel/kprobes.c	2008-01-24 14:03:11.000000000 -0500
+++ linux-2.6-lttng.mm/arch/powerpc/kernel/kprobes.c	2008-01-24 14:20:48.000000000 -0500
@@ -88,9 +88,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6-lttng.mm/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/s390/kernel/kprobes.c	2008-01-24 14:03:14.000000000 -0500
+++ linux-2.6-lttng.mm/arch/s390/kernel/kprobes.c	2008-01-24 14:20:48.000000000 -0500
@@ -220,9 +220,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6-lttng.mm/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/kernel/kprobes.c	2008-01-24 14:21:07.000000000 -0500
+++ linux-2.6-lttng.mm/arch/x86/kernel/kprobes.c	2008-01-24 14:22:46.000000000 -0500
@@ -376,9 +376,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
