Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYDIQVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYDIQVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYDIQVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:21:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58321 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbYDIQVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:21:11 -0400
Message-Id: <20080409152049.161264339@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Roel Kluin <12o3l@tiscali.nl>
Subject: [patch 08/17] Text Edit Lock - kprobes architecture independent support
Content-Disposition: inline; filename=text-edit-lock-kprobes-architecture-independent-support.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the mutual exclusion provided by the text edit lock in the kprobes code. It
allows coherent manipulation of the kernel code by other subsystems.

Changelog:

Move the kernel_text_lock/unlock out of the for loops.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
CC: Roel Kluin <12o3l@tiscali.nl>
---
 kernel/kprobes.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng.mm/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.mm.orig/kernel/kprobes.c	2008-04-09 10:52:33.000000000 -0400
+++ linux-2.6-lttng.mm/kernel/kprobes.c	2008-04-09 10:52:43.000000000 -0400
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+#include <linux/memory.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -618,9 +619,10 @@ static int __kprobes __register_kprobe(s
 		goto out;
 	}
 
+	kernel_text_lock();
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out;
+		goto out_unlock_text;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -628,7 +630,8 @@ static int __kprobes __register_kprobe(s
 
 	if (kprobe_enabled)
 		arch_arm_kprobe(p);
-
+out_unlock_text:
+	kernel_text_unlock();
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -664,8 +667,11 @@ valid_p:
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
 	} else {
 		if (p->break_handler)
@@ -862,7 +868,6 @@ static int __kprobes pre_handler_kretpro
 		}
 
 		arch_prepare_kretprobe(ri, regs);
-
 		/* XXX(hch): why is there no hlist_move_head? */
 		hlist_del(&ri->uflist);
 		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
@@ -1162,11 +1167,13 @@ static void __kprobes enable_all_kprobes
 	if (kprobe_enabled)
 		goto already_enabled;
 
+	kernel_text_lock();
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			arch_arm_kprobe(p);
 	}
+	kernel_text_unlock();
 
 	kprobe_enabled = true;
 	printk(KERN_INFO "Kprobes globally enabled\n");
@@ -1191,6 +1198,7 @@ static void __kprobes disable_all_kprobe
 
 	kprobe_enabled = false;
 	printk(KERN_INFO "Kprobes globally disabled\n");
+	kernel_text_lock();
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
@@ -1198,6 +1206,7 @@ static void __kprobes disable_all_kprobe
 				arch_disarm_kprobe(p);
 		}
 	}
+	kernel_text_unlock();
 
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
