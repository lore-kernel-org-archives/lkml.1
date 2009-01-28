Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbZA2AJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbZA2AJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZA1Xpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:53115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbZA1Xpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:49 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 064/114] x86, smp: refactor ->store/restore_NMI_vector() methods
Date: Wed, 28 Jan 2009 23:42:10 +0000
Message-Id: <1233186180-29883-65-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only NUMAQ does something substantial here, because it initializes
via NMIs (not via INIT as standard SMP startup) - so it needs to
store and restore the NMI vector.

 - extend the generic code to handle NULL methods

 - clear out dummy methods and replace them with NULL

 - clean up: remove wrapper macros, etc.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/wakecpu.h            |    8 --------
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    8 --------
 arch/x86/include/asm/mach-generic/mach_wakecpu.h |    2 --
 arch/x86/include/asm/numaq/wakecpu.h             |    6 ++++--
 arch/x86/kernel/smpboot.c                        |    3 ++-
 arch/x86/mach-generic/bigsmp.c                   |    5 ++---
 arch/x86/mach-generic/default.c                  |    4 ++--
 arch/x86/mach-generic/es7000.c                   |    5 ++---
 arch/x86/mach-generic/numaq.c                    |    4 ++--
 arch/x86/mach-generic/summit.c                   |    5 ++---
 10 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
index e8e0396..71a3a41 100644
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ b/arch/x86/include/asm/es7000/wakecpu.h
@@ -13,14 +13,6 @@ static inline void es7000_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
-static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
 extern void __inquire_remote_apic(int apicid);
 
 static inline void inquire_remote_apic(int apicid)
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index d059807..656bb5e 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -8,14 +8,6 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
-static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
 #ifdef CONFIG_SMP
 extern void __inquire_remote_apic(int apicid);
 #else /* CONFIG_SMP */
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
index 30515a1..93207df 100644
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 #define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 
-#define store_NMI_vector (apic->store_NMI_vector)
-#define restore_NMI_vector (apic->restore_NMI_vector)
 #define inquire_remote_apic (apic->inquire_remote_apic)
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
index 61d0a7d..1232017 100644
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ b/arch/x86/include/asm/numaq/wakecpu.h
@@ -15,7 +15,8 @@ static inline void numaq_smp_callin_clear_local_apic(void)
 	clear_local_APIC();
 }
 
-static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
+static inline void
+numaq_store_NMI_vector(unsigned short *high, unsigned short *low)
 {
 	printk("Storing NMI vector\n");
 	*high =
@@ -24,7 +25,8 @@ static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
 	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
 }
 
-static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
+static inline void
+numaq_restore_NMI_vector(unsigned short *high, unsigned short *low)
 {
 	printk("Restoring NMI vector\n");
 	*((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH)) =
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 10873a4..1492024 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -826,7 +826,8 @@ do_rest:
 
 		pr_debug("Setting warm reset code and vector.\n");
 
-		store_NMI_vector(&nmi_high, &nmi_low);
+		if (apic->store_NMI_vector)
+			apic->store_NMI_vector(&nmi_high, &nmi_low);
 
 		smpboot_setup_warm_reset_vector(start_ip);
 		/*
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index bd069e7..ecdb230 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -110,8 +110,7 @@ struct genapic apic_bigsmp = {
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	.smp_callin_clear_local_apic	= NULL,
-
-	.store_NMI_vector		= store_NMI_vector,
-	.restore_NMI_vector		= restore_NMI_vector,
+	.store_NMI_vector		= NULL,
+	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index a25e6ef..9509256 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -91,7 +91,7 @@ struct genapic apic_default = {
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= store_NMI_vector,
-	.restore_NMI_vector		= restore_NMI_vector,
+	.store_NMI_vector		= NULL,
+	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index ab41b54..1319070 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -147,8 +147,7 @@ struct genapic apic_es7000 = {
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
-
-	.store_NMI_vector		= store_NMI_vector,
-	.restore_NMI_vector		= restore_NMI_vector,
+	.store_NMI_vector		= NULL,
+	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 4d3924f..d7f7fcf 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -111,7 +111,7 @@ struct genapic apic_numaq = {
 	.wait_for_init_deassert		= NULL,
 
 	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
-	.store_NMI_vector		= store_NMI_vector,
-	.restore_NMI_vector		= restore_NMI_vector,
+	.store_NMI_vector		= numaq_store_NMI_vector,
+	.restore_NMI_vector		= numaq_restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 2595baa..46fca79 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -90,8 +90,7 @@ struct genapic apic_summit = {
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	.smp_callin_clear_local_apic	= NULL,
-
-	.store_NMI_vector		= store_NMI_vector,
-	.restore_NMI_vector		= restore_NMI_vector,
+	.store_NMI_vector		= NULL,
+	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
-- 
1.6.0.2

