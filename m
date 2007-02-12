Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbXBLHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbXBLHoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXBLHn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:49631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXBLHiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:16 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Alexey Dobriyan <adobriyan@openvz.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [24/39] i386: use smp_call_function_single()
Message-Id: <20070212073811.EF43213D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexey Dobriyan <adobriyan@openvz.org>
It will execure cpuid only on the cpu we need.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpuid.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/cpuid.c
===================================================================
--- linux.orig/arch/i386/kernel/cpuid.c
+++ linux/arch/i386/kernel/cpuid.c
@@ -48,7 +48,6 @@ static struct class *cpuid_class;
 #ifdef CONFIG_SMP
 
 struct cpuid_command {
-	int cpu;
 	u32 reg;
 	u32 *data;
 };
@@ -57,8 +56,7 @@ static void cpuid_smp_cpuid(void *cmd_bl
 {
 	struct cpuid_command *cmd = (struct cpuid_command *)cmd_block;
 
-	if (cmd->cpu == smp_processor_id())
-		cpuid(cmd->reg, &cmd->data[0], &cmd->data[1], &cmd->data[2],
+	cpuid(cmd->reg, &cmd->data[0], &cmd->data[1], &cmd->data[2],
 		      &cmd->data[3]);
 }
 
@@ -70,11 +68,10 @@ static inline void do_cpuid(int cpu, u32
 	if (cpu == smp_processor_id()) {
 		cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
 	} else {
-		cmd.cpu = cpu;
 		cmd.reg = reg;
 		cmd.data = data;
 
-		smp_call_function(cpuid_smp_cpuid, &cmd, 1, 1);
+		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
 	}
 	preempt_enable();
 }
