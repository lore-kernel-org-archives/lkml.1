Return-Path: <linux-kernel-owner+w=401wt.eu-S936246AbZAPOZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936246AbZAPOZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935847AbZAPOXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:23:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:38605 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935792AbZAPOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:23:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vqDXdDzdYErWWvJH1bjTS5bHhkX2sDMFHZII/hp+TEjt9rPQwebojgIZQ4F7wEytBS
         yxdf64OP8PkZFB0e02KvR1ODzrUOaTJvwbcforBqm3pxd4CPRo4mXWuaZovH/fGu/kv5
         N0HE36TX0Sz9Qbdzsb29OH7br44FdBjIsvt8I=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 13/17] x86-64: Remove pda_init()
Date: Fri, 16 Jan 2009 09:16:32 -0500
Message-Id: <1232115396-26367-13-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-12-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
 <1232115396-26367-11-git-send-email-brgerst@gmail.com>
 <1232115396-26367-12-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove pda_init(), since it is now redundant with code in head_64.S.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h   |    1 -
 arch/x86/kernel/cpu/common.c |   15 ---------------
 arch/x86/kernel/head64.c     |    2 --
 arch/x86/xen/enlighten.c     |    1 -
 4 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index c31ca04..6ca7bc0 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -26,7 +26,6 @@ struct x8664_pda {
 } ____cacheline_aligned_in_smp;
 
 DECLARE_PER_CPU(struct x8664_pda, __pda);
-extern void pda_init(int);
 
 #define cpu_pda(cpu)		(&per_cpu(__pda, cpu))
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ccc6f8a..716c1e8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -890,17 +890,6 @@ EXPORT_PER_CPU_SYMBOL(kernelstack);
 
 DEFINE_PER_CPU(unsigned int, irqcount) = -1;
 
-void __cpuinit pda_init(int cpu)
-{
-	struct x8664_pda *pda = cpu_pda(cpu);
-
-	/* Setup up data that may be needed in __get_free_pages early */
-	loadsegment(fs, 0);
-	loadsegment(gs, 0);
-
-	load_pda_offset(cpu);
-}
-
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
 	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
 	__aligned(PAGE_SIZE);
@@ -964,10 +953,6 @@ void __cpuinit cpu_init(void)
 	struct task_struct *me;
 	int i;
 
-	/* CPU 0 is initialised in head64.c */
-	if (cpu != 0)
-		pda_init(cpu);
-
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(nodenumber) == 0 &&
 	    cpu_to_node(cpu) != NUMA_NO_NODE)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index af67d32..f5b2722 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -91,8 +91,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
-	pda_init(0);
-
 	x86_64_start_reservations(real_mode_data);
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75b9413..bef941f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1645,7 +1645,6 @@ asmlinkage void __init xen_start_kernel(void)
 #ifdef CONFIG_X86_64
 	/* Disable until direct per-cpu data access. */
 	have_vcpu_info_placement = 0;
-	pda_init(0);
 #endif
 
 	xen_smp_init();
-- 
1.6.1.rc1

