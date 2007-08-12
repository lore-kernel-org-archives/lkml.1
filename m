Return-Path: <linux-kernel-owner+w=401wt.eu-S936539AbXHLPK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936539AbXHLPK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934459AbXHLPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:07:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47457 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936107AbXHLPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:07:50 -0400
Message-Id: <20070812150641.294372391@polymtl.ca>
References: <20070812150402.148764478@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:04:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 8/9] Text Edit Lock - kprobes i386
Content-Disposition: inline; filename=text-edit-lock-kprobes-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:06:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes can use the text edit lock to insure mutual exclusion when editing the
code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 arch/i386/kernel/kprobes.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/kprobes.c	2007-08-10 13:47:25.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/kprobes.c	2007-08-10 13:49:21.000000000 -0400
@@ -170,12 +170,16 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	kernel_text_mark_rw((unsigned long) p->addr, sizeof(kprobe_opcode_t));
+	*p->addr = BREAKPOINT_INSTRUCTION;
+	kernel_text_unmark((unsigned long) p->addr, sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	kernel_text_mark_rw((unsigned long) p->addr, sizeof(kprobe_opcode_t));
+	*p->addr = p->opcode;
+	kernel_text_unmark((unsigned long) p->addr, sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
