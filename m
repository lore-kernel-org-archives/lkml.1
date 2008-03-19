Return-Path: <linux-kernel-owner+w=401wt.eu-S1764873AbYCSUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764873AbYCSUMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYCSTiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbYCSTih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:37 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 18/79] [PATCH] isolate sanity checking
Date: Wed, 19 Mar 2008 14:25:13 -0300
Message-Id: <1205947657993-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476531095-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Isolate all sanity checking in a smp_sanity_check()
function as x86_64 does.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   57 ++++++++++++++++++++++-------------------
 1 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index a232f4d..b44a743 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -735,10 +735,6 @@ exit:
 }
 #endif
 
-/*
- * Cycle through the processors sending APIC IPIs to boot each.
- */
-
 static int boot_cpu_logical_apicid;
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
 void *xquad_portio;
@@ -746,26 +742,8 @@ void *xquad_portio;
 EXPORT_SYMBOL(xquad_portio);
 #endif
 
-static void __init smp_boot_cpus(unsigned int max_cpus)
+static int __init smp_sanity_check(unsigned max_cpus)
 {
-	int apicid, cpu, bit, kicked;
-	unsigned long bogosum = 0;
-
-	/*
-	 * Setup boot CPU information
-	 */
-	smp_store_cpu_info(0); /* Final full version of the data */
-	printk("CPU%d: ", 0);
-	print_cpu_info(&cpu_data(0));
-
-	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
-	boot_cpu_logical_apicid = logical_smp_processor_id();
-	per_cpu(x86_cpu_to_apicid, 0) = boot_cpu_physical_apicid;
-
-	current_thread_info()->cpu = 0;
-
-	set_cpu_sibling_map(0);
-
 	/*
 	 * If we couldn't find an SMP configuration at boot time,
 	 * get out of here now!
@@ -780,7 +758,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 		map_cpu_to_logical_apicid();
 		cpu_set(0, per_cpu(cpu_sibling_map, 0));
 		cpu_set(0, per_cpu(cpu_core_map, 0));
-		return;
+		return -1;
 	}
 
 	/*
@@ -806,7 +784,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 		map_cpu_to_logical_apicid();
 		cpu_set(0, per_cpu(cpu_sibling_map, 0));
 		cpu_set(0, per_cpu(cpu_core_map, 0));
-		return;
+		return -1;
 	}
 
 	verify_local_APIC();
@@ -828,9 +806,36 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 		map_cpu_to_logical_apicid();
 		cpu_set(0, per_cpu(cpu_sibling_map, 0));
 		cpu_set(0, per_cpu(cpu_core_map, 0));
-		return;
+		return -1;
 	}
+	return 0;
+}
+
+
+/*
+ * Cycle through the processors sending APIC IPIs to boot each.
+ */
+static void __init smp_boot_cpus(unsigned int max_cpus)
+{
+	int apicid, cpu, bit, kicked;
+	unsigned long bogosum = 0;
+
+	/*
+	 * Setup boot CPU information
+	 */
+	smp_store_cpu_info(0); /* Final full version of the data */
+	printk(KERN_INFO "CPU%d: ", 0);
+	print_cpu_info(&cpu_data(0));
+
+	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
+	boot_cpu_logical_apicid = logical_smp_processor_id();
+	per_cpu(x86_cpu_to_apicid, 0) = boot_cpu_physical_apicid;
+
+	current_thread_info()->cpu = 0;
+
+	set_cpu_sibling_map(0);
 
+	smp_sanity_check(max_cpus);
 	connect_bsp_APIC();
 	setup_local_APIC();
 	map_cpu_to_logical_apicid();
-- 
1.5.0.6

