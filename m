Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbXGCQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbXGCQlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXGCQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:40:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44455 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbXGCQkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:40:35 -0400
Message-Id: <20070703164030.836768613@polymtl.ca>
References: <20070703163818.785635235@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:38:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/3] Text Edit Lock - Alternative i386
Content-Disposition: inline; filename=text-edit-lock-alternative-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:40:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alternative.c can use the text edit lock to remove CPU HOTPLUG special cases.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/kernel/alternative.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-lttng/arch/i386/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/alternative.c	2007-06-18 17:38:41.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/alternative.c	2007-06-18 17:42:30.000000000 -0400
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/cacheflush.h>
 
 static int noreplace_smp     = 0;
 static int smp_alt_once      = 0;
@@ -179,9 +180,11 @@
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
+		kernel_text_lock((unsigned long)instr, a->instrlen);
 		memcpy(instr, a->replacement, a->replacementlen);
 		diff = a->instrlen - a->replacementlen;
 		nop_out(instr + a->replacementlen, diff);
+		kernel_text_unlock((unsigned long)instr, a->instrlen);
 	}
 }
 
@@ -346,6 +349,7 @@
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
+		kernel_text_lock((unsigned long)p->instr, p->len);
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
 
@@ -353,6 +357,7 @@
 
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
+		kernel_text_unlock((unsigned long)p->instr, p->len);
 	}
 
 	/* Sync to be conservative, in case we patched following

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
