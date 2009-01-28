Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZA2AIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZA2AIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbZA1Xpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:53108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715AbZA1Xpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:47 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 062/114] x86, smp: refactor ->wait_for_init_deassert()
Date: Wed, 28 Jan 2009 23:42:08 +0000
Message-Id: <1233186180-29883-63-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the namespace on a per APIC driver basis

 - handle a NULL ->wait_for_init_deassert() as a 'dont wait' default method

 - remove NUMAQ and Summit handlers

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/wakecpu.h            |    2 +-
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    2 +-
 arch/x86/include/asm/mach-generic/mach_wakecpu.h |    1 -
 arch/x86/include/asm/numaq/wakecpu.h             |    5 -----
 arch/x86/kernel/es7000_32.c                      |    6 +-----
 arch/x86/kernel/smpboot.c                        |    3 ++-
 arch/x86/mach-generic/bigsmp.c                   |    4 +++-
 arch/x86/mach-generic/default.c                  |    4 +++-
 arch/x86/mach-generic/es7000.c                   |    4 +++-
 arch/x86/mach-generic/numaq.c                    |    5 ++++-
 arch/x86/mach-generic/summit.c                   |    4 +++-
 11 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
index 4c01be6..5c4d05f 100644
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ b/arch/x86/include/asm/es7000/wakecpu.h
@@ -4,7 +4,7 @@
 #define ES7000_TRAMPOLINE_PHYS_LOW	0x467
 #define ES7000_TRAMPOLINE_PHYS_HIGH	0x469
 
-static inline void wait_for_init_deassert(atomic_t *deassert)
+static inline void es7000_wait_for_init_deassert(atomic_t *deassert)
 {
 #ifndef CONFIG_ES7000_CLUSTERED_APIC
 	while (!atomic_read(deassert))
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index a327a67..1d34c69 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 #define _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 
-static inline void wait_for_init_deassert(atomic_t *deassert)
+static inline void default_wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
 		cpu_relax();
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
index 2031377..58e5412 100644
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 #define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 
-#define wait_for_init_deassert (apic->wait_for_init_deassert)
 #define smp_callin_clear_local_apic (apic->smp_callin_clear_local_apic)
 #define store_NMI_vector (apic->store_NMI_vector)
 #define restore_NMI_vector (apic->restore_NMI_vector)
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
index 8b6c16d..884b95c 100644
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ b/arch/x86/include/asm/numaq/wakecpu.h
@@ -6,11 +6,6 @@
 #define NUMAQ_TRAMPOLINE_PHYS_LOW (0x8)
 #define NUMAQ_TRAMPOLINE_PHYS_HIGH (0xa)
 
-/* We don't do anything here because we use NMI's to boot instead */
-static inline void wait_for_init_deassert(atomic_t *deassert)
-{
-}
-
 /*
  * Because we use NMIs rather than the INIT-STARTUP sequence to
  * bootstrap the CPUs, the APIC may be in a weird state. Kick it.
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index e73fe18..d7f433e 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -182,10 +182,6 @@ static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 	return 0;
 }
 
-static void noop_wait_for_deassert(atomic_t *deassert_not_used)
-{
-}
-
 static int __init es7000_update_genapic(void)
 {
 	apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
@@ -194,7 +190,7 @@ static int __init es7000_update_genapic(void)
 	if (boot_cpu_data.x86 == 6 &&
 	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11)) {
 		es7000_update_genapic_to_cluster();
-		apic->wait_for_init_deassert = noop_wait_for_deassert;
+		apic->wait_for_init_deassert = NULL;
 		apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
 	}
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ab83be2..558af37 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -196,7 +196,8 @@ static void __cpuinit smp_callin(void)
 	 * our local APIC.  We have to wait for the IPI or we'll
 	 * lock up on an APIC access.
 	 */
-	wait_for_init_deassert(&init_deasserted);
+	if (apic->wait_for_init_deassert)
+		apic->wait_for_init_deassert(&init_deasserted);
 
 	/*
 	 * (This works even if the APIC is not enabled.)
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index a317fbe..40910bf 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -106,7 +106,9 @@ struct genapic apic_bigsmp = {
 	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= wait_for_init_deassert,
+
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
+
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 17d8f9c..c246484 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -87,7 +87,9 @@ struct genapic apic_default = {
 	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= wait_for_init_deassert,
+
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
+
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 871e854..4cb3984 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -142,7 +142,9 @@ struct genapic apic_es7000 = {
 	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= wait_for_init_deassert,
+
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
+
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 0b496ab..fb03867 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -106,7 +106,10 @@ struct genapic apic_numaq = {
 	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= NUMAQ_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= NUMAQ_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= wait_for_init_deassert,
+
+	/* We don't do anything here because we use NMI's to boot instead */
+	.wait_for_init_deassert		= NULL,
+
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index c4799cd..fdca78b 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -86,7 +86,9 @@ struct genapic apic_summit = {
 	.wakeup_cpu			= NULL,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= wait_for_init_deassert,
+
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
+
 	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
-- 
1.6.0.2

