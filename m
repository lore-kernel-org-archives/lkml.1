Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbYHFULw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbYHFULw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbYHFUKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:10:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9558 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbYHFUKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:10:33 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 16:10:32 EDT
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5202678"
From: Max.Krasnyansky@qualcomm.com
To: mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       lizf@cn.fujitsu.com, jeff.chua.linux@gmail.com
Subject: [PATCH] Resurect proper handling of maxcpus= kernel option
Date: Wed,  6 Aug 2008 13:00:54 -0700
Message-Id: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

For some reason we had redundant parsers registered for maxcpus=. 
One in init/main.c and another in arch/x86/smpboot.c
So I nuked the one in arch/x86.

Also 64-bit kernels used to handle maxcpus= as documented in
Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are initialized
but not booted. 32-bit version for some reason ignored them even though
all the infrastructure for booting them later is there.

In the current mainline both 64 and 32 bit versions are broken. I'm
too lazy to look through git history but I'm guessing it happened as
part of the i386 and x86_64 unification.

This patch restores the correct behaviour. I've tested x86_64 version on
4- and 8- way Core2 and 2-way Opteron based machines. Various config
combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG.
Booted with maxcpus=1 and maxcpus=4, etc. Everything is working as expected.

I cannot test 32-bit version (no 32-bit machines here).

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: lizf@cn.fujitsu.com
Cc: jeff.chua.linux@gmail.com
---
 arch/x86/kernel/apic_32.c |    8 --------
 arch/x86/kernel/apic_64.c |    7 -------
 arch/x86/kernel/smpboot.c |   14 --------------
 3 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d6c8983..71d49cc 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1454,8 +1454,6 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	}
 }
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
-
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
@@ -1482,12 +1480,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		return;
 	}
 
-	if (num_processors >= maxcpus) {
-		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-			" Processor ignored.\n", maxcpus);
-		return;
-	}
-
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 7f1f030..446c062 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -90,7 +90,6 @@ static unsigned long apic_phys;
 
 unsigned long mp_lapic_addr;
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
 /*
  * Get the LAPIC version
  */
@@ -1062,12 +1061,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		return;
 	}
 
-	if (num_processors >= maxcpus) {
-		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-		       " Processor ignored.\n", maxcpus);
-		return;
-	}
-
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3325127..4fcce79 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1370,17 +1370,3 @@ void __cpu_die(unsigned int cpu)
 	BUG();
 }
 #endif
-
-/*
- * If the BIOS enumerates physical processors before logical,
- * maxcpus=N at enumeration-time can be used to disable HT.
- */
-static int __init parse_maxcpus(char *arg)
-{
-	extern unsigned int maxcpus;
-
-	if (arg)
-		maxcpus = simple_strtoul(arg, NULL, 0);
-	return 0;
-}
-early_param("maxcpus", parse_maxcpus);
-- 
1.5.5.1

