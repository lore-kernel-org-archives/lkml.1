Return-Path: <linux-kernel-owner+w=401wt.eu-S1765131AbXGNB04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765131AbXGNB04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763491AbXGNBZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:25:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38225 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935416AbXGNBZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:25:07 -0400
Message-Id: <20070714012414.130353244@polymtl.ca>
References: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 6/8] Text Edit Lock - Kprobes architecture independent support
Content-Disposition: inline; filename=text-edit-lock-kprobes-architecture-independent.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the mutual exclusion provided by the text edit lock in the kprobes code. It
allows coherent manipulation of the kernel code by other subsystems.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 kernel/kprobes.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-07-13 18:47:57.000000000 -0400
+++ linux-2.6-lttng/kernel/kprobes.c	2007-07-13 18:48:32.000000000 -0400
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+#include <linux/memory.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -561,9 +562,10 @@
 		goto out;
 	}
 
+	kernel_text_lock();
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out;
+		goto out_unlock_text;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -576,6 +578,8 @@
 
 		arch_arm_kprobe(p);
 	}
+out_unlock_text:
+	kernel_text_unlock();
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -618,8 +622,11 @@
 		 * enabled - otherwise, the breakpoint would already have
 		 * been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled)
+		if (kprobe_enabled) {
+			kernel_text_lock();
 			arch_disarm_kprobe(p);
+			kernel_text_unlock();
+		}
 		hlist_del_rcu(&old_p->hlist);
 		cleanup_p = 1;
 	} else {
@@ -642,7 +649,9 @@
 			kfree(old_p);
 		}
 		mutex_lock(&kprobe_mutex);
+		kernel_text_lock();
 		arch_remove_kprobe(p);
+		kernel_text_unlock();
 		mutex_unlock(&kprobe_mutex);
 	} else {
 		mutex_lock(&kprobe_mutex);
@@ -723,8 +732,9 @@
 				 struct kretprobe_instance, uflist);
 		ri->rp = rp;
 		ri->task = current;
+		kernel_text_lock();
 		arch_prepare_kretprobe(ri, regs);
-
+		kernel_text_unlock();
 		/* XXX(hch): why is there no hlist_move_head? */
 		hlist_del(&ri->uflist);
 		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
@@ -932,8 +942,10 @@
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
+		kernel_text_lock();
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			arch_arm_kprobe(p);
+		kernel_text_unlock();
 	}
 
 	kprobe_enabled = true;
@@ -961,10 +973,12 @@
 	printk(KERN_INFO "Kprobes globally disabled\n");
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
+		kernel_text_lock();
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!arch_trampoline_kprobe(p))
 				arch_disarm_kprobe(p);
 		}
+		kernel_text_unlock();
 	}
 
 	mutex_unlock(&kprobe_mutex);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
