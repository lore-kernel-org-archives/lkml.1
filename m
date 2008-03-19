Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbYCSUIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbYCSUIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYCSTih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbYCSTi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:29 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 19/79] [PATCH] isolate logic to disable smp
Date: Wed, 19 Mar 2008 14:25:14 -0300
Message-Id: <1205947661385-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947657993-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Put it in a disable_smp() function, as x86_64 does

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index b44a743..8144aa3 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -742,6 +742,15 @@ void *xquad_portio;
 EXPORT_SYMBOL(xquad_portio);
 #endif
 
+static void __init disable_smp(void)
+{
+	smpboot_clear_io_apic_irqs();
+	phys_cpu_present_map = physid_mask_of_physid(0);
+	map_cpu_to_logical_apicid();
+	cpu_set(0, per_cpu(cpu_sibling_map, 0));
+	cpu_set(0, per_cpu(cpu_core_map, 0));
+}
+
 static int __init smp_sanity_check(unsigned max_cpus)
 {
 	/*
@@ -750,14 +759,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!smp_found_config && !acpi_lapic) {
 		printk(KERN_NOTICE "SMP motherboard not detected.\n");
-		smpboot_clear_io_apic_irqs();
-		phys_cpu_present_map = physid_mask_of_physid(0);
+		disable_smp();
 		if (APIC_init_uniprocessor())
 			printk(KERN_NOTICE "Local APIC not detected."
 					   " Using dummy APIC emulation.\n");
-		map_cpu_to_logical_apicid();
-		cpu_set(0, per_cpu(cpu_sibling_map, 0));
-		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return -1;
 	}
 
@@ -779,11 +784,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
 			boot_cpu_physical_apicid);
 		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
-		smpboot_clear_io_apic_irqs();
-		phys_cpu_present_map = physid_mask_of_physid(0);
-		map_cpu_to_logical_apicid();
-		cpu_set(0, per_cpu(cpu_sibling_map, 0));
-		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return -1;
 	}
 
@@ -801,11 +801,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
 			connect_bsp_APIC();
 			setup_local_APIC();
 		}
-		smpboot_clear_io_apic_irqs();
-		phys_cpu_present_map = physid_mask_of_physid(0);
-		map_cpu_to_logical_apicid();
-		cpu_set(0, per_cpu(cpu_sibling_map, 0));
-		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return -1;
 	}
 	return 0;
@@ -835,7 +830,12 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 
 	set_cpu_sibling_map(0);
 
-	smp_sanity_check(max_cpus);
+	if (smp_sanity_check(max_cpus) < 0) {
+		printk(KERN_INFO "SMP disabled\n");
+		disable_smp();
+		return;
+	}
+
 	connect_bsp_APIC();
 	setup_local_APIC();
 	map_cpu_to_logical_apicid();
-- 
1.5.0.6

