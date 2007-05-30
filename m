Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbXE3OFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbXE3OFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXE3ODQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:03:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46570 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbXE3ODM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:03:12 -0400
Message-Id: <20070530140229.811672406@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 9/9] Scheduler profiling - Use conditional calls
Content-Disposition: inline; filename=profiling-use-cond-calls.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:02:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use conditional calls with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

---
 kernel/profile.c |    4 ++++
 kernel/sched.c   |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/profile.c
===================================================================
--- linux-2.6-lttng.orig/kernel/profile.c	2007-05-30 08:42:29.000000000 -0400
+++ linux-2.6-lttng/kernel/profile.c	2007-05-30 08:45:22.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
+#include <linux/condcall.h>
 #include <asm/sections.h>
 #include <asm/semaphore.h>
 #include <asm/irq_regs.h>
@@ -92,6 +93,8 @@
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
+	if (prof_on)
+		BUG_ON(cond_call_arm("profile_on"));
 	return 1;
 }
 __setup("profile=", profile_setup);
@@ -556,6 +559,7 @@
 	return 0;
 out_cleanup:
 	prof_on = 0;
+	cond_call_disarm("profile_on");
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-05-30 08:43:02.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-05-30 08:45:22.000000000 -0400
@@ -59,6 +59,7 @@
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
+#include <linux/condcall.h>
 
 #include <asm/tlb.h>
 #include <asm/unistd.h>
@@ -2990,7 +2991,8 @@
 			print_irqtrace_events(prev);
 		dump_stack();
 	}
-	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+	cond_call(profile_on,
+		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
 
 	/*
 	 * The idle thread is not allowed to schedule!

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
