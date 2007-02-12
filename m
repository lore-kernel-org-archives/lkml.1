Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXBLHiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXBLHiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXBLHiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:17 -0500
Received: from ns.suse.de ([195.135.220.2]:38399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbXBLHiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:12 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Alexey Dobriyan <adobriyan@openvz.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [23/39] i386: use smp_call_function_single()
Message-Id: <20070212073810.E198813DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexey Dobriyan <adobriyan@openvz.org>
It will execute rdmsr and wrmsr only on the cpu we need.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/msr.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux/arch/i386/kernel/msr.c
===================================================================
--- linux.orig/arch/i386/kernel/msr.c
+++ linux/arch/i386/kernel/msr.c
@@ -68,7 +68,6 @@ static inline int rdmsr_eio(u32 reg, u32
 #ifdef CONFIG_SMP
 
 struct msr_command {
-	int cpu;
 	int err;
 	u32 reg;
 	u32 data[2];
@@ -78,16 +77,14 @@ static void msr_smp_wrmsr(void *cmd_bloc
 {
 	struct msr_command *cmd = (struct msr_command *)cmd_block;
 
-	if (cmd->cpu == smp_processor_id())
-		cmd->err = wrmsr_eio(cmd->reg, cmd->data[0], cmd->data[1]);
+	cmd->err = wrmsr_eio(cmd->reg, cmd->data[0], cmd->data[1]);
 }
 
 static void msr_smp_rdmsr(void *cmd_block)
 {
 	struct msr_command *cmd = (struct msr_command *)cmd_block;
 
-	if (cmd->cpu == smp_processor_id())
-		cmd->err = rdmsr_eio(cmd->reg, &cmd->data[0], &cmd->data[1]);
+	cmd->err = rdmsr_eio(cmd->reg, &cmd->data[0], &cmd->data[1]);
 }
 
 static inline int do_wrmsr(int cpu, u32 reg, u32 eax, u32 edx)
@@ -99,12 +96,11 @@ static inline int do_wrmsr(int cpu, u32 
 	if (cpu == smp_processor_id()) {
 		ret = wrmsr_eio(reg, eax, edx);
 	} else {
-		cmd.cpu = cpu;
 		cmd.reg = reg;
 		cmd.data[0] = eax;
 		cmd.data[1] = edx;
 
-		smp_call_function(msr_smp_wrmsr, &cmd, 1, 1);
+		smp_call_function_single(cpu, msr_smp_wrmsr, &cmd, 1, 1);
 		ret = cmd.err;
 	}
 	preempt_enable();
@@ -120,10 +116,9 @@ static inline int do_rdmsr(int cpu, u32 
 	if (cpu == smp_processor_id()) {
 		ret = rdmsr_eio(reg, eax, edx);
 	} else {
-		cmd.cpu = cpu;
 		cmd.reg = reg;
 
-		smp_call_function(msr_smp_rdmsr, &cmd, 1, 1);
+		smp_call_function_single(cpu, msr_smp_rdmsr, &cmd, 1, 1);
 
 		*eax = cmd.data[0];
 		*edx = cmd.data[1];
