Return-Path: <linux-kernel-owner+w=401wt.eu-S936308AbXHLPJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936308AbXHLPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936090AbXHLPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:07:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47452 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936074AbXHLPHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:07:40 -0400
Message-Id: <20070812150640.755158754@polymtl.ca>
References: <20070812150402.148764478@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:04:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 7/9] Text Edit Lock - kprobes architecture independent support
Content-Disposition: inline; filename=text-edit-lock-kprobes-architecture-independent.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:06:41 +0000
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
 kernel/kprobes.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-08-09 15:22:49.000000000 -0400
+++ linux-2.6-lttng/kernel/kprobes.c	2007-08-09 15:25:00.000000000 -0400
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+#include <linux/memory.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -568,9 +569,10 @@ static int __kprobes __register_kprobe(s
 		goto out;
 	}
 
+	kernel_text_lock();
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out;
+		goto out_unlock_text;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -578,7 +580,8 @@ static int __kprobes __register_kprobe(s
 
 	if (kprobe_enabled)
 		arch_arm_kprobe(p);
-
+out_unlock_text:
+	kernel_text_unlock();
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -621,8 +624,11 @@ valid_p:
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
@@ -644,9 +650,7 @@ valid_p:
 			list_del_rcu(&p->list);
 			kfree(old_p);
 		}
-		mutex_lock(&kprobe_mutex);
 		arch_remove_kprobe(p);
-		mutex_unlock(&kprobe_mutex);
 	} else {
 		mutex_lock(&kprobe_mutex);
 		if (p->break_handler)
@@ -716,8 +720,9 @@ static int __kprobes pre_handler_kretpro
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
@@ -917,8 +922,10 @@ static void __kprobes enable_all_kprobes
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
+		kernel_text_lock();
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			arch_arm_kprobe(p);
+		kernel_text_unlock();
 	}
 
 	kprobe_enabled = true;
@@ -946,10 +953,12 @@ static void __kprobes disable_all_kprobe
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
