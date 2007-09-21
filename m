Return-Path: <linux-kernel-owner+w=401wt.eu-S1765693AbXIUU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765693AbXIUU7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762567AbXIUUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:43 -0400
Received: from mail.suse.de ([195.135.220.2]:50113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763424AbXIUUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:28 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: avi@qumranet.com, hpa@zytor.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [44/45] i386: simplify smp_call_function_single() call sequence in cpuid
Message-Id: <20070921204527.AB6B814EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Avi Kivity <avi@qumranet.com>

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpuid.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

Index: linux/arch/i386/kernel/cpuid.c
===================================================================
--- linux.orig/arch/i386/kernel/cpuid.c
+++ linux/arch/i386/kernel/cpuid.c
@@ -45,8 +45,6 @@
 
 static struct class *cpuid_class;
 
-#ifdef CONFIG_SMP
-
 struct cpuid_command {
 	u32 reg;
 	u32 *data;
@@ -64,25 +62,11 @@ static inline void do_cpuid(int cpu, u32
 {
 	struct cpuid_command cmd;
 
-	preempt_disable();
-	if (cpu == smp_processor_id()) {
-		cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-	} else {
-		cmd.reg = reg;
-		cmd.data = data;
+	cmd.reg = reg;
+	cmd.data = data;
 
-		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
-	}
-	preempt_enable();
+	smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
 }
-#else				/* ! CONFIG_SMP */
-
-static inline void do_cpuid(int cpu, u32 reg, u32 * data)
-{
-	cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-}
-
-#endif				/* ! CONFIG_SMP */
 
 static loff_t cpuid_seek(struct file *file, loff_t offset, int orig)
 {
