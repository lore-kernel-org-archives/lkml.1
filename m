Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbXGNB1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbXGNB1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935531AbXGNBZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:25:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38229 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935465AbXGNBZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:25:07 -0400
Message-Id: <20070714012415.427453981@polymtl.ca>
References: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 8/8] Text Edit Lock - kprobes x86_64
Content-Disposition: inline; filename=text-edit-lock-kprobes-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes can use the text edit lock to insure mutual exclusion when editing the
code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/x86_64/kernel/kprobes.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/kprobes.c	2007-07-13 16:08:14.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/kprobes.c	2007-07-13 16:41:49.000000000 -0400
@@ -209,42 +209,20 @@
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	unsigned long addr = (unsigned long)p->addr;
-	int page_readonly = 0;
-
-	if (kernel_readonly_text(addr)) {
-		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
-		global_flush_tlb();
-		page_readonly = 1;
-	}
+	kernel_text_mark_rw((unsigned long) p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = BREAKPOINT_INSTRUCTION;
+	kernel_text_unmark((unsigned long) p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-	if (page_readonly) {
-		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
-		global_flush_tlb();
-	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	unsigned long addr = (unsigned long)p->addr;
-	int page_readonly = 0;
-
-	if (kernel_readonly_text(addr)) {
-		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
-		global_flush_tlb();
-		page_readonly = 1;
-	}
-
+	kernel_text_mark_rw((unsigned long) p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = p->opcode;
+	kernel_text_unmark((unsigned long) p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-
-	if (page_readonly) {
-		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
-		global_flush_tlb();
-	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
