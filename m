Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYDIQW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYDIQW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYDIQVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:21:20 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58349 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYDIQVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:21:19 -0400
Message-Id: <20080409152047.133203801@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 02/17] Kprobes - do not use kprobes mutex in arch code
Content-Disposition: inline; filename=kprobes-dont-use-kprobes-mutex-in-arch-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:07 +0000
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
--- linux-2.6-lttng.mm.orig/include/linux/kprobes.h	2008-04-09 10:43:10.000000000 -0400
+++ linux-2.6-lttng.mm/include/linux/kprobes.h	2008-04-09 10:43:38.000000000 -0400
@@ -35,7 +35,6 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
-#include <linux/mutex.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -202,7 +201,6 @@ static inline int init_test_probes(void)
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
 extern spinlock_t kretprobe_lock;
-extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
Index: linux-2.6-lttng.mm/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/kernel/kprobes.c	2008-04-09 10:43:10.000000000 -0400
+++ linux-2.6-lttng.mm/arch/x86/kernel/kprobes.c	2008-04-09 10:43:38.000000000 -0400
@@ -376,9 +376,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-	mutex_unlock(&kprobe_mutex);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
Index: linux-2.6-lttng.mm/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/ia64/kernel/kprobes.c	2008-04-09 10:43:10.000000000 -0400
+++ linux-2.6-lttng.mm/arch/ia64/kernel/kprobes.c	2008-04-09 10:43:38.000000000 -0400
@@ -672,9 +672,7 @@ void __kprobes arch_disarm_kprobe(struct
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	mutex_lock(&kprobe_mutex);
 	free_insn_slot(p->ainsn.insn, p->ainsn.inst_flag & INST_FLAG_BOOSTABLE);
-	mutex_unlock(&kprobe_mutex);
 }
 /*
  * We are resuming execution after a single step fault, so the pt_regs
Index: linux-2.6-lttng.mm/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/powerpc/kernel/kprobes.c	2008-04-09 10:43:10.000000000 -0400
+++ linux-2.6-lttng.mm/arch/powerpc/kernel/kprobes.c	2008-04-09 10:43:38.000000000 -0400
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
--- linux-2.6-lttng.mm.orig/arch/s390/kernel/kprobes.c	2008-04-09 10:43:10.000000000 -0400
+++ linux-2.6-lttng.mm/arch/s390/kernel/kprobes.c	2008-04-09 10:43:38.000000000 -0400
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
