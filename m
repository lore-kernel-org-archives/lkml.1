Return-Path: <linux-kernel-owner+w=401wt.eu-S935763AbZAPOT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763AbZAPOT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935069AbZAPOQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:58 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:32961 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934997AbZAPOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iw1PRix2nuz3w5ZkjviNUAa+0CaNpwEb/D9bvY6ve3VuC3abX4WAUFNi8K95j+d/Bc
         YPl/elvHGZcTxvdfG70xnR6tVRTj5rgpR0BZ2b5ZbT8+8Ph+m/mlgcNbW2RowfBtXKTH
         Ly9WyWJz1liPJ6igTxQZHj1MFr4Acw/KVq17A=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 14/17] x86-64: Remove load_pda_offset()
Date: Fri, 16 Jan 2009 09:16:33 -0500
Message-Id: <1232115396-26367-14-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-13-git-send-email-brgerst@gmail.com>
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
 <1232115396-26367-13-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one place now where the %gs base is changed after boot.
Move the code inline to setup_per_cpu_areas().

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/percpu.h  |    6 ------
 arch/x86/kernel/setup_percpu.c |   20 ++++++--------------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 165d527..ce980db 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -133,12 +133,6 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
-#ifdef CONFIG_X86_64
-extern void load_pda_offset(int cpu);
-#else
-static inline void load_pda_offset(int cpu) { }
-#endif
-
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0ddb184..916e2cf 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -69,23 +69,12 @@ static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
 /*
- * Define load_pda_offset() and per-cpu __pda for x86_64.
- * load_pda_offset() is responsible for loading the offset of pda into
- * %gs.
- *
  * On SMP, pda offset also duals as percpu base address and thus it
  * should be at the start of per-cpu area.  To achieve this, it's
  * preallocated in vmlinux_64.lds.S directly instead of using
  * DEFINE_PER_CPU().
  */
 #ifdef CONFIG_X86_64
-void __cpuinit load_pda_offset(int cpu)
-{
-	/* Memory clobbers used to order pda/percpu accesses */
-	mb();
-	wrmsrl(MSR_GS_BASE, cpu_pda(cpu));
-	mb();
-}
 #ifndef CONFIG_SMP
 DEFINE_PER_CPU(struct x8664_pda, __pda);
 #endif
@@ -205,9 +194,12 @@ void __init setup_per_cpu_areas(void)
 		 * CPU0 modified pda in the init data area, reload pda
 		 * offset for CPU0 and clear the area for others.
 		 */
-		if (cpu == 0)
-			load_pda_offset(0);
-		else
+		if (cpu == 0) {
+			/* Memory clobbers used to order pda/percpu accesses */
+			mb();
+			wrmsrl(MSR_GS_BASE, cpu_pda(0));
+			mb();
+		} else
 			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
 #endif
 
-- 
1.6.1.rc1

