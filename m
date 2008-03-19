Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbYCSUUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbYCSUUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYCSTjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbYCSTi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:58 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 24/79] [PATCH] define bios to apicid mapping
Date: Wed, 19 Mar 2008 14:25:19 -0300
Message-Id: <12059476844196-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476802159-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This mapping already exists in x86_64, just provide it for
i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c            |    6 ++++++
 include/asm-x86/mach-bigsmp/mach_apic.h |    7 ++-----
 include/asm-x86/mach-es7000/mach_apic.h |    8 +++-----
 include/asm-x86/mach-summit/mach_apic.h |    3 +--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 0e86ccc..92a5df6 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -70,6 +70,12 @@ void *x86_cpu_to_apicid_early_ptr;
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
+u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
+				= { [0 ... NR_CPUS-1] = BAD_APICID };
+void *x86_bios_cpu_apicid_early_ptr;
+DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
+EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+
 u8 apicid_2_node[MAX_APICID];
 
 static void map_cpu_to_logical_apicid(void);
diff --git a/include/asm-x86/mach-bigsmp/mach_apic.h b/include/asm-x86/mach-bigsmp/mach_apic.h
index 6df235e..0d55b1f 100644
--- a/include/asm-x86/mach-bigsmp/mach_apic.h
+++ b/include/asm-x86/mach-bigsmp/mach_apic.h
@@ -1,10 +1,7 @@
 #ifndef __ASM_MACH_APIC_H
 #define __ASM_MACH_APIC_H
 
-
-extern u8 bios_cpu_apicid[];
-
-#define xapic_phys_to_log_apicid(cpu) (bios_cpu_apicid[cpu])
+#define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
 #define esr_disable (1)
 
 static inline int apic_id_registered(void)
@@ -90,7 +87,7 @@ static inline int apicid_to_node(int logical_apicid)
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < NR_CPUS)
-		return (int) bios_cpu_apicid[mps_cpu];
+		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
 
 	return BAD_APICID;
 }
diff --git a/include/asm-x86/mach-es7000/mach_apic.h b/include/asm-x86/mach-es7000/mach_apic.h
index d23011f..04cba9f 100644
--- a/include/asm-x86/mach-es7000/mach_apic.h
+++ b/include/asm-x86/mach-es7000/mach_apic.h
@@ -1,9 +1,7 @@
 #ifndef __ASM_MACH_APIC_H
 #define __ASM_MACH_APIC_H
 
-extern u8 bios_cpu_apicid[];
-
-#define xapic_phys_to_log_apicid(cpu) (bios_cpu_apicid[cpu])
+#define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
 #define esr_disable (1)
 
 static inline int apic_id_registered(void)
@@ -80,7 +78,7 @@ extern void enable_apic_mode(void);
 extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
-	int apic = bios_cpu_apicid[smp_processor_id()];
+	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ? 
 		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(TARGET_CPUS)[0]);
@@ -102,7 +100,7 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 	if (!mps_cpu)
 		return boot_cpu_physical_apicid;
 	else if (mps_cpu < NR_CPUS)
-		return (int) bios_cpu_apicid[mps_cpu];
+		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
 }
diff --git a/include/asm-x86/mach-summit/mach_apic.h b/include/asm-x86/mach-summit/mach_apic.h
index 062c97f..91d7641 100644
--- a/include/asm-x86/mach-summit/mach_apic.h
+++ b/include/asm-x86/mach-summit/mach_apic.h
@@ -40,7 +40,6 @@ static inline unsigned long check_apicid_present(int bit)
 
 #define apicid_cluster(apicid) ((apicid) & XAPIC_DEST_CLUSTER_MASK)
 
-extern u8 bios_cpu_apicid[];
 extern u8 cpu_2_logical_apicid[];
 
 static inline void init_apic_ldr(void)
@@ -110,7 +109,7 @@ static inline int cpu_to_logical_apicid(int cpu)
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < NR_CPUS)
-		return (int)bios_cpu_apicid[mps_cpu];
+		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
 }
-- 
1.5.0.6

