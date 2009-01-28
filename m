Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbZA2AJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbZA2AJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZA1Xpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:53111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbZA1Xps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:48 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 063/114] x86, smp: refactor ->smp_callin_clear_local_apic() methods
Date: Wed, 28 Jan 2009 23:42:09 +0000
Message-Id: <1233186180-29883-64-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only NUMAQ does something substantial here, because it initializes
via NMIs (not via INIT as standard SMP startup) - so it needs to
reset the APIC.

 - extend the generic code to handle NULL methods

 - clear out dummy methods and replace them with NULL

 - clean up: remove wrapper macros, etc.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/wakecpu.h            |    5 -----
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    5 -----
 arch/x86/include/asm/mach-generic/mach_wakecpu.h |    1 -
 arch/x86/include/asm/numaq/wakecpu.h             |    4 ++--
 arch/x86/kernel/smpboot.c                        |    3 ++-
 arch/x86/mach-generic/bigsmp.c                   |    3 ++-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    4 +++-
 arch/x86/mach-generic/numaq.c                    |    2 +-
 arch/x86/mach-generic/summit.c                   |    3 ++-
 10 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
index 5c4d05f..e8e0396 100644
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ b/arch/x86/include/asm/es7000/wakecpu.h
@@ -13,11 +13,6 @@ static inline void es7000_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-/* Nothing to do for most platforms, since cleared by the INIT cycle */
-static inline void smp_callin_clear_local_apic(void)
-{
-}
-
 static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
 {
 }
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index 1d34c69..d059807 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -8,11 +8,6 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-/* Nothing to do for most platforms, since cleared by the INIT cycle */
-static inline void smp_callin_clear_local_apic(void)
-{
-}
-
 static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
 {
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
index 58e5412..30515a1 100644
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 #define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 
-#define smp_callin_clear_local_apic (apic->smp_callin_clear_local_apic)
 #define store_NMI_vector (apic->store_NMI_vector)
 #define restore_NMI_vector (apic->restore_NMI_vector)
 #define inquire_remote_apic (apic->inquire_remote_apic)
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
index 884b95c..61d0a7d 100644
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ b/arch/x86/include/asm/numaq/wakecpu.h
@@ -8,9 +8,9 @@
 
 /*
  * Because we use NMIs rather than the INIT-STARTUP sequence to
- * bootstrap the CPUs, the APIC may be in a weird state. Kick it.
+ * bootstrap the CPUs, the APIC may be in a weird state. Kick it:
  */
-static inline void smp_callin_clear_local_apic(void)
+static inline void numaq_smp_callin_clear_local_apic(void)
 {
 	clear_local_APIC();
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 558af37..10873a4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -244,7 +244,8 @@ static void __cpuinit smp_callin(void)
 	 */
 
 	pr_debug("CALLIN, before setup_local_APIC().\n");
-	smp_callin_clear_local_apic();
+	if (apic->smp_callin_clear_local_apic)
+		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 40910bf..bd069e7 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -109,7 +109,8 @@ struct genapic apic_bigsmp = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
+	.smp_callin_clear_local_apic	= NULL,
+
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index c246484..a25e6ef 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -90,7 +90,7 @@ struct genapic apic_default = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
+	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 4cb3984..ab41b54 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -145,7 +145,9 @@ struct genapic apic_es7000 = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
+	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
+	.smp_callin_clear_local_apic	= NULL,
+
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index fb03867..4d3924f 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -110,7 +110,7 @@ struct genapic apic_numaq = {
 	/* We don't do anything here because we use NMI's to boot instead */
 	.wait_for_init_deassert		= NULL,
 
-	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
+	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index fdca78b..2595baa 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -89,7 +89,8 @@ struct genapic apic_summit = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
+	.smp_callin_clear_local_apic	= NULL,
+
 	.store_NMI_vector		= store_NMI_vector,
 	.restore_NMI_vector		= restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
-- 
1.6.0.2

