Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbYGOCfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbYGOCfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbYGOCeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:04 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:11538 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329AbYGOCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:01 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 03/14] [ALPHA] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Richard Henderson <rth@twiddle.net>
Date: Mon, 14 Jul 2008 20:33:59 -0600
Message-ID: <20080715023359.2528.87647.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the cpu_enabled_map correctly.

Note that this patch does not actually make any decisions based
on the contents of the map.

However, as the map is presented via sysfs in:

	/sys/devices/system/cpu/

It should be populated correctly.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Richard Henderson <rth@twiddle.net>
---

 arch/alpha/kernel/process.c |    2 ++
 arch/alpha/kernel/smp.c     |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 96ed82f..7a261e2 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -94,6 +94,7 @@ common_shutdown_1(void *generic_ptr)
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
 		cpu_clear(cpuid, cpu_present_map);
+		cpu_clear(cpuid, cpu_enabled_map);
 		halt();
 	}
 #endif
@@ -120,6 +121,7 @@ common_shutdown_1(void *generic_ptr)
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
 	cpu_clear(boot_cpuid, cpu_present_map);
+	cpu_clear(boot_cpuid, cpu_enabled_map);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 2525692..ec53061 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -436,6 +436,7 @@ setup_smp(void)
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
 				cpu_set(i, cpu_present_map);
+				cpu_set(i, cpu_enabled_map);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
 
@@ -469,6 +470,7 @@ smp_prepare_cpus(unsigned int max_cpus)
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
 		cpu_present_map = cpumask_of_cpu(boot_cpuid);
+		cpu_enabled_map = cpumask_of_cpu(boot_cpuid);
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
 	}

