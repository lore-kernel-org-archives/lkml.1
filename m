Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbXGCQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbXGCQlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbXGCQlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:41:23 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44671 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761034AbXGCQlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:41:20 -0400
Message-Id: <20070703164031.888938670@polymtl.ca>
References: <20070703163818.785635235@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:38:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 3/3] Text Edit Lock - kprobes i386
Content-Disposition: inline; filename=text-edit-lock-kprobes-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:40:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes can use the text edit lock to insure mutual exclusion when edition the
code and make sure the pages are writable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/i386/kernel/kprobes.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/kprobes.c	2007-06-29 14:15:38.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/kprobes.c	2007-06-29 14:25:08.000000000 -0400
@@ -169,42 +169,20 @@
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	unsigned long addr = (unsigned long) p->addr;
-	int page_readonly = 0;
-
-	if (kernel_readonly_text(addr)) {
-		page_readonly = 1;
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
-		global_flush_tlb();
-	}
-
+	kernel_text_lock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = BREAKPOINT_INSTRUCTION;
+	kernel_text_unlock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-
-	if (page_readonly) {
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
-		global_flush_tlb();
-	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	unsigned long addr = (unsigned long) p->addr;
-	int page_readonly = 0;
-
-	if (kernel_readonly_text(addr)) {
-		page_readonly = 1;
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
-		global_flush_tlb();
-	}
+	kernel_text_lock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = p->opcode;
+	kernel_text_unlock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-	if (page_readonly) {
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
-		global_flush_tlb();
-	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
