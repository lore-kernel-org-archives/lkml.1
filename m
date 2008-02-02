Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbYBBUk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbYBBUk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934340AbYBBUkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:40:42 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:41063 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934086AbYBBUki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:40:38 -0500
Message-Id: <20080202204022.968356780@polymtl.ca>
References: <20080202203722.628843686@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:37:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 2/3] Kprobes - do not use kprobes mutex in arch code
Content-Disposition: inline; filename=kprobes-dont-use-kprobes-mutex-in-arch-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:40:25 +0000
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

Index: linux-2.6-lttng/include/linux/kprobes.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/kprobes.h	2008-01-30 09:06:02.000000000 -0500
+++ linux-2.6-lttng/include/linux/kprobes.h	2008-01-30 09:15:48.000000000 -0500
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
Index: linux-2.6-lttng/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/kprobes.c	2008-01-30 09:06:01.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/kprobes.c	2008-01-30 09:15:48.000000000 -0500
@@ -376,9 +376,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2008-01-30 09:14:29.000000000 -0500
+++ linux-2.6-lttng/kernel/kprobes.c	2008-01-30 09:15:48.000000000 -0500
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
--- linux-2.6-lttng.orig/arch/ia64/kernel/kprobes.c	2008-01-30 09:04:21.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/kernel/kprobes.c	2008-01-30 09:15:48.000000000 -0500
@@ -582,9 +582,7 @@ void __kprobes arch_disarm_kprobe(struct
 
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
--- linux-2.6-lttng.orig/arch/powerpc/kernel/kprobes.c	2008-01-30 09:04:21.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/kprobes.c	2008-01-30 09:15:48.000000000 -0500
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
--- linux-2.6-lttng.orig/arch/s390/kernel/kprobes.c	2008-01-30 09:04:21.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/kprobes.c	2008-01-30 09:15:48.000000000 -0500
@@ -220,9 +220,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
