Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbZAZGPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbZAZGPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZAZGPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:35843 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZAZGPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ghi+jqCi6KNt2771B4mWPFZWx86XnbKNHCjQhTam7Cfgwvcw5VksXz5xg5ZspLJhi/
         xDnjeMtcIyjGQNUwvlF/KNMG3roFXxpG9qUAwlGxEzwMEd8oBg3SGtBgI5WlUY+HAxyo
         cCKb7a/ZPtUPT+JvmW0lj4I+gWED5sG+Rml6M=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] x86: Merge setup_per_cpu_maps() into setup_per_cpu_areas().
Date: Mon, 26 Jan 2009 01:15:21 -0500
Message-Id: <1232950532-22923-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: minor optimization

Eliminates the need for two loops over possible cpus.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/setup_percpu.c |   48 +++++++++++++++------------------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 90b8e15..d0b1476 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -97,33 +97,6 @@ static inline void setup_cpu_local_masks(void)
 #endif /* CONFIG_X86_32 */
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
-/*
- * Copy data used in early init routines from the initial arrays to the
- * per cpu data areas.  These arrays then become expendable and the
- * *_early_ptr's are zeroed indicating that the static arrays are gone.
- */
-static void __init setup_per_cpu_maps(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		per_cpu(x86_cpu_to_apicid, cpu) =
-				early_per_cpu_map(x86_cpu_to_apicid, cpu);
-		per_cpu(x86_bios_cpu_apicid, cpu) =
-				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
-#ifdef X86_64_NUMA
-		per_cpu(x86_cpu_to_node_map, cpu) =
-				early_per_cpu_map(x86_cpu_to_node_map, cpu);
-#endif
-	}
-
-	/* indicate the early static arrays will soon be gone */
-	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
-	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
-#ifdef X86_64_NUMA
-	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
-#endif
-}
 
 #ifdef CONFIG_X86_64
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
@@ -181,6 +154,19 @@ void __init setup_per_cpu_areas(void)
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 		per_cpu(cpu_number, cpu) = cpu;
+		/*
+		 * Copy data used in early init routines from the initial arrays to the
+		 * per cpu data areas.  These arrays then become expendable and the
+		 * *_early_ptr's are zeroed indicating that the static arrays are gone.
+		 */
+		per_cpu(x86_cpu_to_apicid, cpu) =
+				early_per_cpu_map(x86_cpu_to_apicid, cpu);
+		per_cpu(x86_bios_cpu_apicid, cpu) =
+				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
+#ifdef X86_64_NUMA
+		per_cpu(x86_cpu_to_node_map, cpu) =
+				early_per_cpu_map(x86_cpu_to_node_map, cpu);
+#endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) + IRQ_STACK_SIZE - 64;
@@ -195,8 +181,12 @@ void __init setup_per_cpu_areas(void)
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
 
-	/* Setup percpu data maps */
-	setup_per_cpu_maps();
+	/* indicate the early static arrays will soon be gone */
+	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
+	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
+#ifdef X86_64_NUMA
+	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
+#endif
 
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
-- 
1.6.1

