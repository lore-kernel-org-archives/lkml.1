Return-Path: <linux-kernel-owner+w=401wt.eu-S935636AbZAPOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935636AbZAPOSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934577AbZAPOQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:46175 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934301AbZAPOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jDUN9vOxu0oF/AOOMwM2Amdb249/0WzkkmN5YLk37v7/GnG5/8oifrNbCvQF7W+PES
         XaSOxjNYru+hN2s0IWmPg/I14q1FIDM7feiPMkB3hQ2whuhWTcL8qJQCuUAFf/gKPiQA
         QZphlXqmFhYDq3qip2J2IKrKTEKz2UXwOuNqs=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 10/17] x86-64: Move nodenumber from PDA to per-cpu.
Date: Fri, 16 Jan 2009 09:16:29 -0500
Message-Id: <1232115396-26367-10-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-9-git-send-email-brgerst@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h      |    1 -
 arch/x86/include/asm/topology.h |    3 ++-
 arch/x86/kernel/cpu/common.c    |   11 ++++++-----
 arch/x86/kernel/setup_percpu.c  |    4 +++-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 4527d70..b30ef6b 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -22,7 +22,6 @@ struct x8664_pda {
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 #endif
-	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
 	short isidle;
 } ____cacheline_aligned_in_smp;
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 87ca3fd..90a8a15 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -83,7 +83,8 @@ extern cpumask_t *node_to_cpumask_map;
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
 /* Returns the number of the current Node. */
-#define numa_node_id()		read_pda(nodenumber)
+DECLARE_PER_CPU(int, nodenumber);
+#define numa_node_id()		percpu_read(nodenumber)
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 62f9665..ccc6f8a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -899,11 +899,6 @@ void __cpuinit pda_init(int cpu)
 	loadsegment(gs, 0);
 
 	load_pda_offset(cpu);
-
-	if (cpu != 0) {
-		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
-			pda->nodenumber = cpu_to_node(cpu);
-	}
 }
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
@@ -973,6 +968,12 @@ void __cpuinit cpu_init(void)
 	if (cpu != 0)
 		pda_init(cpu);
 
+#ifdef CONFIG_NUMA
+	if (cpu != 0 && percpu_read(nodenumber) == 0 &&
+	    cpu_to_node(cpu) != NUMA_NO_NODE)
+		percpu_write(nodenumber, cpu_to_node(cpu));
+#endif
+
 	me = current;
 
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index bd38127..0ddb184 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -44,6 +44,8 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 #define	X86_64_NUMA	1	/* (used later) */
+DEFINE_PER_CPU(int, nodenumber) = 0;
+EXPORT_PER_CPU_SYMBOL(nodenumber);
 
 /*
  * Map cpu index to node index
@@ -276,7 +278,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
 	if (node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
+		per_cpu(nodenumber, cpu) = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
-- 
1.6.1.rc1

