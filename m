Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbZA2AIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbZA2AIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbZA1Xps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:53097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZA1Xpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:43 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 060/114] x86, smp: clean up ->trampoline_phys_low/high handling
Date: Wed, 28 Jan 2009 23:42:06 +0000
Message-Id: <1233186180-29883-61-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the namespace on a per apic driver basis

 - remove wrapper macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/wakecpu.h             |    4 ++--
 arch/x86/include/asm/mach-default/mach_wakecpu.h  |    4 ++--
 arch/x86/include/asm/mach-default/smpboot_hooks.h |    6 +++---
 arch/x86/include/asm/mach-generic/mach_wakecpu.h  |    2 --
 arch/x86/include/asm/numaq/wakecpu.h              |   12 ++++++------
 arch/x86/mach-generic/bigsmp.c                    |    4 ++--
 arch/x86/mach-generic/default.c                   |    4 ++--
 arch/x86/mach-generic/es7000.c                    |    4 ++--
 arch/x86/mach-generic/numaq.c                     |    4 ++--
 arch/x86/mach-generic/summit.c                    |    4 ++--
 10 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
index 78f0daa..4c01be6 100644
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ b/arch/x86/include/asm/es7000/wakecpu.h
@@ -1,8 +1,8 @@
 #ifndef __ASM_ES7000_WAKECPU_H
 #define __ASM_ES7000_WAKECPU_H
 
-#define TRAMPOLINE_PHYS_LOW	0x467
-#define TRAMPOLINE_PHYS_HIGH	0x469
+#define ES7000_TRAMPOLINE_PHYS_LOW	0x467
+#define ES7000_TRAMPOLINE_PHYS_HIGH	0x469
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index 89897a6..0a8d786 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 #define _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 
-#define TRAMPOLINE_PHYS_LOW (0x467)
-#define TRAMPOLINE_PHYS_HIGH (0x469)
+#define DEFAULT_TRAMPOLINE_PHYS_LOW (0x467)
+#define DEFAULT_TRAMPOLINE_PHYS_HIGH (0x469)
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
diff --git a/arch/x86/include/asm/mach-default/smpboot_hooks.h b/arch/x86/include/asm/mach-default/smpboot_hooks.h
index 23bf521..1def601 100644
--- a/arch/x86/include/asm/mach-default/smpboot_hooks.h
+++ b/arch/x86/include/asm/mach-default/smpboot_hooks.h
@@ -13,10 +13,10 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 	CMOS_WRITE(0xa, 0xf);
 	local_flush_tlb();
 	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
 								 start_eip >> 4;
 	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
 							 start_eip & 0xf;
 	pr_debug("3.\n");
 }
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
+	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
index 22006bb..2031377 100644
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 #define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 
-#define TRAMPOLINE_PHYS_LOW (apic->trampoline_phys_low)
-#define TRAMPOLINE_PHYS_HIGH (apic->trampoline_phys_high)
 #define wait_for_init_deassert (apic->wait_for_init_deassert)
 #define smp_callin_clear_local_apic (apic->smp_callin_clear_local_apic)
 #define store_NMI_vector (apic->store_NMI_vector)
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
index 6f499df..8b6c16d 100644
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ b/arch/x86/include/asm/numaq/wakecpu.h
@@ -3,8 +3,8 @@
 
 /* This file copes with machines that wakeup secondary CPUs by NMIs */
 
-#define TRAMPOLINE_PHYS_LOW (0x8)
-#define TRAMPOLINE_PHYS_HIGH (0xa)
+#define NUMAQ_TRAMPOLINE_PHYS_LOW (0x8)
+#define NUMAQ_TRAMPOLINE_PHYS_HIGH (0xa)
 
 /* We don't do anything here because we use NMI's to boot instead */
 static inline void wait_for_init_deassert(atomic_t *deassert)
@@ -24,17 +24,17 @@ static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
 {
 	printk("Storing NMI vector\n");
 	*high =
-	  *((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH));
+	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH));
 	*low =
-	  *((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW));
+	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
 }
 
 static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
 {
 	printk("Restoring NMI vector\n");
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+	*((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH)) =
 								 *high;
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+	*((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW)) =
 								 *low;
 }
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 4782b55..a317fbe 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -104,8 +104,8 @@ struct genapic apic_bigsmp = {
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= TRAMPOLINE_PHYS_HIGH,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= wait_for_init_deassert,
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index bf4670d..17d8f9c 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -85,8 +85,8 @@ struct genapic apic_default = {
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= TRAMPOLINE_PHYS_HIGH,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= wait_for_init_deassert,
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index d36642e..871e854 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -140,8 +140,8 @@ struct genapic apic_es7000 = {
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= TRAMPOLINE_PHYS_HIGH,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= wait_for_init_deassert,
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 135b183..0b496ab 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -104,8 +104,8 @@ struct genapic apic_numaq = {
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= TRAMPOLINE_PHYS_HIGH,
+	.trampoline_phys_low		= NUMAQ_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= NUMAQ_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= wait_for_init_deassert,
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 77196a4..c4799cd 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -84,8 +84,8 @@ struct genapic apic_summit = {
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= TRAMPOLINE_PHYS_HIGH,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= wait_for_init_deassert,
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
-- 
1.6.0.2

