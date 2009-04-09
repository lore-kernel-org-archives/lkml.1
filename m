Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZDIFiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZDIFiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZDIFhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58063
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbZDIFhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:31 -0400
Date: Wed, 08 Apr 2009 22:37:21 -0700 (PDT)
Message-Id: <20090408.223721.164905834.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/12]: sparc64: Reclaim trap_block[]->hdesc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This really isn't necessary at all, a local variable suits the
job just fine.

This frees up 8 bytes in the trap_block[] that we can use later
to store the per-cpu base addresses.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/cpudata_64.h |    2 +-
 arch/sparc/kernel/smp_64.c          |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/cpudata_64.h b/arch/sparc/include/asm/cpudata_64.h
index a11b89e..c58d87b 100644
--- a/arch/sparc/include/asm/cpudata_64.h
+++ b/arch/sparc/include/asm/cpudata_64.h
@@ -80,7 +80,7 @@ struct trap_per_cpu {
 	unsigned int		dev_mondo_qmask;
 	unsigned int		resum_qmask;
 	unsigned int		nonresum_qmask;
-	void			*hdesc;
+	unsigned long		__unused;
 } __attribute__((aligned(64)));
 extern struct trap_per_cpu trap_block[NR_CPUS];
 extern void init_cur_cpu_trap(struct thread_info *);
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 708e12a..662fea2 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -278,7 +278,7 @@ static unsigned long kimage_addr_to_ra(void *p)
 	return kern_base + (val - KERNBASE);
 }
 
-static void __cpuinit ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread_reg)
+static void __cpuinit ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread_reg, void **descrp)
 {
 	extern unsigned long sparc64_ttable_tl0;
 	extern unsigned long kern_locked_tte_data;
@@ -298,12 +298,12 @@ static void __cpuinit ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread
 		       "hvtramp_descr.\n");
 		return;
 	}
+	*descrp = hdesc;
 
 	hdesc->cpu = cpu;
 	hdesc->num_mappings = num_kernel_image_mappings;
 
 	tb = &trap_block[cpu];
-	tb->hdesc = hdesc;
 
 	hdesc->fault_info_va = (unsigned long) &tb->fault_info;
 	hdesc->fault_info_pa = kimage_addr_to_ra(&tb->fault_info);
@@ -341,12 +341,12 @@ static struct thread_info *cpu_new_thread = NULL;
 
 static int __cpuinit smp_boot_one_cpu(unsigned int cpu)
 {
-	struct trap_per_cpu *tb = &trap_block[cpu];
 	unsigned long entry =
 		(unsigned long)(&sparc64_cpu_startup);
 	unsigned long cookie =
 		(unsigned long)(&cpu_new_thread);
 	struct task_struct *p;
+	void *descr = NULL;
 	int timeout, ret;
 
 	p = fork_idle(cpu);
@@ -359,7 +359,8 @@ static int __cpuinit smp_boot_one_cpu(unsigned int cpu)
 #if defined(CONFIG_SUN_LDOMS) && defined(CONFIG_HOTPLUG_CPU)
 		if (ldom_domaining_enabled)
 			ldom_startcpu_cpuid(cpu,
-					    (unsigned long) cpu_new_thread);
+					    (unsigned long) cpu_new_thread,
+					    &descr);
 		else
 #endif
 			prom_startcpu_cpuid(cpu, entry, cookie);
@@ -383,10 +384,7 @@ static int __cpuinit smp_boot_one_cpu(unsigned int cpu)
 	}
 	cpu_new_thread = NULL;
 
-	if (tb->hdesc) {
-		kfree(tb->hdesc);
-		tb->hdesc = NULL;
-	}
+	kfree(descr);
 
 	return ret;
 }
-- 
1.6.2.2

