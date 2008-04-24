Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbYDXPRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbYDXPRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbYDXPOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56037 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759342AbYDXPOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:41 -0400
Message-Id: <20080424151354.705762842@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: [patch 07/37] Kprobes - do not use kprobes mutex in arch code
Content-Disposition: inline; filename=kprobes-dont-use-kprobes-mutex-in-arch-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
remove all use of this mutex in the architecture specific code, replacing it by
a proper mutex lock/unlock in the architecture agnostic code.

Changelog :
- remove unnecessary kprobe_mutex around arch_remove_kprobe()

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/ia64/kernel/kprobes.c    |    2 --
 arch/powerpc/kernel/kprobes.c |    2 --
 arch/s390/kernel/kprobes.c    |    2 --
 arch/x86/kernel/kprobes.c     |    2 --
 include/linux/kprobes.h       |    2 --
 5 files changed, 10 deletions(-)

Index: linux-2.6-sched-devel/include/linux/kprobes.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/kprobes.h	2008-04-19 17:41:25.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/kprobes.h	2008-04-22 20:12:38.000000000 -0400
@@ -35,7 +35,6 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
-#include <linux/mutex.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -195,7 +194,6 @@ static inline int init_test_probes(void)
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
 extern spinlock_t kretprobe_lock;
-extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
Index: linux-2.6-sched-devel/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/kprobes.c	2008-04-22 20:04:02.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/kprobes.c	2008-04-22 20:12:38.000000000 -0400
@@ -376,9 +376,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
Index: linux-2.6-sched-devel/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/ia64/kernel/kprobes.c	2008-04-22 20:04:00.000000000 -0400
+++ linux-2.6-sched-devel/arch/ia64/kernel/kprobes.c	2008-04-22 20:12:54.000000000 -0400
@@ -672,9 +672,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, p->ainsn.inst_flag & INST_FLAG_BOOSTABLE);
-	mutex_unlock(&kprobe_mutex);
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
Index: linux-2.6-sched-devel/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/powerpc/kernel/kprobes.c	2008-04-19 17:41:25.000000000 -0400
+++ linux-2.6-sched-devel/arch/powerpc/kernel/kprobes.c	2008-04-22 20:12:38.000000000 -0400
@@ -88,9 +88,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, 0);
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
Index: linux-2.6-sched-devel/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/s390/kernel/kprobes.c	2008-04-22 20:04:02.000000000 -0400
+++ linux-2.6-sched-devel/arch/s390/kernel/kprobes.c	2008-04-22 20:12:38.000000000 -0400
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
