Return-Path: <linux-kernel-owner+w=401wt.eu-S1764084AbXGNBZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764084AbXGNBZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763567AbXGNBYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:24:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38143 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763059AbXGNBYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:24:44 -0400
Message-Id: <20070714012413.461733262@polymtl.ca>
References: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 5/8] Text Edit Lock - Alternative code for i386 and x86_64
Content-Disposition: inline; filename=text-edit-lock-alternative-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alternative.c can use the text edit lock to remove CPU HOTPLUG special cases.
Also used by x86_64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/kernel/alternative.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6-lttng/arch/i386/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/alternative.c	2007-07-13 16:08:14.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/alternative.c	2007-07-13 16:39:26.000000000 -0400
@@ -2,8 +2,10 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/memory.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/cacheflush.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -185,9 +187,13 @@
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
+		kernel_text_lock();
+		kernel_text_mark_rw((unsigned long)instr, a->instrlen);
 		memcpy(instr, a->replacement, a->replacementlen);
 		diff = a->instrlen - a->replacementlen;
 		nop_out(instr + a->replacementlen, diff);
+		kernel_text_unmark((unsigned long)instr, a->instrlen);
+		kernel_text_unlock();
 	}
 }
 
@@ -352,6 +358,8 @@
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
+		kernel_text_lock();
+		kernel_text_mark_rw((unsigned long)p->instr, p->len);
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
 
@@ -359,6 +367,8 @@
 
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
+		kernel_text_unmark((unsigned long)p->instr, p->len);
+		kernel_text_unlock();
 	}
 
 	/* Sync to be conservative, in case we patched following

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
