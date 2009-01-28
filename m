Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZA2ABn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZA2ABn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbZA1XpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:52950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbZA1Xo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:59 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 041/114] x86, apic: streamline the ->multi_timer_check() quirk
Date: Wed, 28 Jan 2009 23:41:47 +0000
Message-Id: <1233186180-29883-42-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only NUMAQ uses this quirk: to prevent the timer IRQ from being added
on secondary nodes.

All other genapic templates can have a NULL ->multi_timer_check()
callback.

Also, extend the generic code to treat a NULL pointer accordingly.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    5 -----
 arch/x86/include/asm/es7000/apic.h            |    5 -----
 arch/x86/include/asm/mach-default/mach_apic.h |    5 -----
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    2 +-
 arch/x86/include/asm/summit/apic.h            |    5 -----
 arch/x86/kernel/io_apic.c                     |   11 ++++++++---
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 321ea47..df59298 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -62,11 +62,6 @@ static inline void bigsmp_setup_apic_routing(void)
 		"Physflat", nr_ioapics);
 }
 
-static inline int multi_timer_check(int apic, int irq)
-{
-	return (0);
-}
-
 static inline int apicid_to_node(int logical_apicid)
 {
 	return apicid_2_node[hard_smp_processor_id()];
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index f118300..632e4cd 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -82,11 +82,6 @@ static inline void es7000_setup_apic_routing(void)
 			nr_ioapics, cpus_addr(*es7000_target_cpus())[0]);
 }
 
-static inline int multi_timer_check(int apic, int irq)
-{
-	return 0;
-}
-
 static inline int apicid_to_node(int logical_apicid)
 {
 	return 0;
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index d446774..f418d47 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -104,11 +104,6 @@ static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
 	return phys_map;
 }
 
-static inline int multi_timer_check(int apic, int irq)
-{
-	return 0;
-}
-
 /* Mapping from cpu number to logical apicid */
 static inline int cpu_to_logical_apicid(int cpu)
 {
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index ddf3692..bdea0a7 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define multi_timer_check (apic->multi_timer_check)
 #define apicid_to_node (apic->apicid_to_node)
 #define cpu_to_logical_apicid (apic->cpu_to_logical_apicid) 
 #define cpu_present_to_apicid (apic->cpu_present_to_apicid)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 2feb7e7..22bdf3d 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -43,7 +43,7 @@ static inline void numaq_setup_apic_routing(void)
  * Skip adding the timer int on secondary nodes, which causes
  * a small but painful rift in the time-space continuum.
  */
-static inline int multi_timer_check(int apic, int irq)
+static inline int numaq_multi_timer_check(int apic, int irq)
 {
 	return apic != 0 && irq == 0;
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 7ec2696..acb7bd1 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -64,11 +64,6 @@ static inline void summit_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline int multi_timer_check(int apic, int irq)
-{
-	return 0;
-}
-
 static inline int summit_apic_id_registered(void)
 {
 	return 1;
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index db79ad9..282ea11 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1618,10 +1618,15 @@ static void __init setup_IO_APIC_irqs(void)
 			}
 
 			irq = pin_2_irq(idx, apic_id, pin);
-#ifdef CONFIG_X86_32
-			if (multi_timer_check(apic_id, irq))
+
+			/*
+			 * Skip the timer IRQ if there's a quirk handler
+			 * installed and if it returns 1:
+			 */
+			if (apic->multi_timer_check &&
+					apic->multi_timer_check(apic_id, irq))
 				continue;
-#endif
+
 			desc = irq_to_desc_alloc_cpu(irq, cpu);
 			if (!desc) {
 				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index ad3837a..d074956 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -79,7 +79,7 @@ struct genapic apic_bigsmp = {
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
-	.multi_timer_check		= multi_timer_check,
+	.multi_timer_check		= NULL,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 67f287f..6a21aa7 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -60,7 +60,7 @@ struct genapic apic_default = {
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= default_setup_apic_routing,
-	.multi_timer_check		= multi_timer_check,
+	.multi_timer_check		= NULL,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index f611729..0be59a5 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -121,7 +121,7 @@ struct genapic apic_es7000 = {
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
-	.multi_timer_check		= multi_timer_check,
+	.multi_timer_check		= NULL,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 8c137f4..da4ed65 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -66,7 +66,7 @@ struct genapic apic_numaq = {
 
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
-	.multi_timer_check		= multi_timer_check,
+	.multi_timer_check		= numaq_multi_timer_check,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 0698566..b618a18 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -59,7 +59,7 @@ struct genapic apic_summit = {
 
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
-	.multi_timer_check		= multi_timer_check,
+	.multi_timer_check		= NULL,
 	.apicid_to_node			= apicid_to_node,
 	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= cpu_present_to_apicid,
-- 
1.6.0.2

