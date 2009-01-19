Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZASAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZASAwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZASAwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:52:30 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:52398 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbZASAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Axc8MkfT8KbqYEA2Czl69xfNvgjBFYP9bvSAr+Ugz/7kuSgXWWp90Cd6KX246npAwa
         RzS3RFijlRl+0n92U7jC0qtuRW4PsZXoMy5DbWXEqi5KQGIHo8N5R+pgZbAcZ5tHoOqN
         P1X/jRDxN/QV4xYf6bIyAg6S5NctrlNNPIi08=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/5] x86-64: Remove pda_init()
Date: Sun, 18 Jan 2009 19:52:21 -0500
Message-Id: <1232326345-3534-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the code to cpu_init() to satisfy the requirement that the cpu
be reinitialized.  Remove all other calls, since the segments are
already initialized in head_64.S.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h   |    1 -
 arch/x86/kernel/cpu/common.c |   15 +++------------
 arch/x86/kernel/head64.c     |    2 --
 arch/x86/xen/enlighten.c     |    1 -
 4 files changed, 3 insertions(+), 16 deletions(-)

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
index 7976a6a..f83a4d6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -895,15 +895,6 @@ EXPORT_PER_CPU_SYMBOL(kernel_stack);
 
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
-void __cpuinit pda_init(int cpu)
-{
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
@@ -967,9 +958,9 @@ void __cpuinit cpu_init(void)
 	struct task_struct *me;
 	int i;
 
-	/* CPU 0 is initialised in head64.c */
-	if (cpu != 0)
-		pda_init(cpu);
+	loadsegment(fs, 0);
+	loadsegment(gs, 0);
+	load_pda_offset(cpu);
 
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(node_number) == 0 &&
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

