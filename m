Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbZA1X4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbZA1X4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbZA1Xo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:37573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbZA1Xo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:27 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 031/114] x86: clean up esr_disable() methods
Date: Wed, 28 Jan 2009 23:41:37 +0000
Message-Id: <1233186180-29883-32-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Most subarchitectures want to disable the APIC ESR (Error Status Register),
because they generally have hardware hacks that wrap standard CPUs into
a bigger system and hence the APIC bus is quite non-standard and weirdnesses
(lockups) have been seen with ESR reporting.

Remove the esr_disable macros and put the desired flag into each
subarchitecture's genapic template directly.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    1 -
 arch/x86/include/asm/es7000/apic.h            |    1 -
 arch/x86/include/asm/mach-default/mach_apic.h |    1 -
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    1 -
 arch/x86/include/asm/summit/apic.h            |    1 -
 arch/x86/kernel/apic.c                        |    4 ++--
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 12 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index d6aeca3..b550cb1 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -2,7 +2,6 @@
 #define __ASM_MACH_APIC_H
 
 #define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
-#define esr_disable (1)
 
 static inline int bigsmp_apic_id_registered(void)
 {
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 53adda0..aa11c76 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -4,7 +4,6 @@
 #include <linux/gfp.h>
 
 #define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
-#define esr_disable (1)
 
 static inline int es7000_apic_id_registered(void)
 {
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 77a9724..5f8d17f 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -18,7 +18,6 @@ static inline const struct cpumask *default_target_cpus(void)
 } 
 
 #define NO_BALANCE_IRQ (0)
-#define esr_disable (0)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index da2d778..63fe985 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -3,7 +3,6 @@
 
 #include <asm/genapic.h>
 
-#define esr_disable (apic->ESR_DISABLE)
 #define NO_BALANCE_IRQ (apic->no_balance_irq)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL (apic->apic_destination_logical)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 1111ff9..8ecb3b4 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -13,7 +13,6 @@ static inline const cpumask_t *numaq_target_cpus(void)
 }
 
 #define NO_BALANCE_IRQ (1)
-#define esr_disable (1)
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index cf5036f..84679e6 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -4,7 +4,6 @@
 #include <asm/smp.h>
 #include <linux/gfp.h>
 
-#define esr_disable (1)
 #define NO_BALANCE_IRQ (0)
 
 /* In clustered mode, the high nibble of APIC ID is a cluster number.
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index b6740de..69d8c30 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1107,7 +1107,7 @@ static void __cpuinit lapic_setup_esr(void)
 		return;
 	}
 
-	if (esr_disable) {
+	if (apic->ESR_DISABLE) {
 		/*
 		 * Something untraceable is creating bad interrupts on
 		 * secondary quads ... for the moment, just leave the
@@ -1157,7 +1157,7 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
-	if (lapic_is_integrated() && esr_disable) {
+	if (lapic_is_integrated() && apic->ESR_DISABLE) {
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index d3cead2..f0bb726 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -69,7 +69,7 @@ struct genapic apic_bigsmp = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= bigsmp_target_cpus,
-	.ESR_DISABLE			= esr_disable,
+	.ESR_DISABLE			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index a483e22..c30141a 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -36,7 +36,7 @@ struct genapic apic_default = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= default_target_cpus,
-	.ESR_DISABLE			= esr_disable,
+	.ESR_DISABLE			= 0,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index e31f0c3..e8aa8fd 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -112,7 +112,7 @@ struct genapic apic_es7000 = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= es7000_target_cpus,
-	.ESR_DISABLE			= esr_disable,
+	.ESR_DISABLE			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 4b84b59..860edc8 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -56,7 +56,7 @@ struct genapic apic_numaq = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= numaq_target_cpus,
-	.ESR_DISABLE			= esr_disable,
+	.ESR_DISABLE			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index e6b956a..cd5ef11 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -49,7 +49,7 @@ struct genapic apic_summit = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= summit_target_cpus,
-	.ESR_DISABLE			= esr_disable,
+	.ESR_DISABLE			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
-- 
1.6.0.2

