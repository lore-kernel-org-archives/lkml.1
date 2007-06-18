Return-Path: <linux-kernel-owner+w=401wt.eu-S933524AbXFRWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524AbXFRWGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932573AbXFRWGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:06:01 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49711 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbXFRWGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:06:00 -0400
Message-Id: <20070618220459.776019802@polymtl.ca>
References: <20070618215846.247539382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 17:58:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Chuck Ebbert <cebbert@redhat.com>, prasanna@in.ibm.com, ananth@in.ibm.com,
       jkenisto@us.ibm.com, ak@suse.de,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/3] Text Edit Lock - kprobes i386
Content-Disposition: inline; filename=text-edit-lock-kprobes-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 18 Jun 2007 22:05:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes can use the text edit lock to insure mutual exclusion when edition the
code and make sure the pages are writable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/kernel/kprobes.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-lttng/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/kprobes.c	2007-06-18 17:41:27.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/kprobes.c	2007-06-18 17:41:31.000000000 -0400
@@ -169,14 +169,18 @@
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
+	kernel_text_lock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = BREAKPOINT_INSTRUCTION;
+	kernel_text_unlock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+	kernel_text_lock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = p->opcode;
+	kernel_text_unlock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
