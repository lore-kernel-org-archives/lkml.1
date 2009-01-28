Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZA2AK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZA2AK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbZA1Xp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:53128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673AbZA1Xpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:53 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 066/114] x86, smp: refactor ->inquire_remote_apic() methods
Date: Wed, 28 Jan 2009 23:42:12 +0000
Message-Id: <1233186180-29883-67-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing exciting - a few subarches dont want APIC remote reads to
be performed - the others are content with the default method.

 - extend the generic code to handle NULL methods

 - clear out dummy methods and replace them with NULL

 - clean up: remove wrapper macros, etc.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/wakecpu.h            |    8 --------
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    2 +-
 arch/x86/include/asm/mach-generic/mach_wakecpu.h |    2 --
 arch/x86/include/asm/numaq/wakecpu.h             |    4 ----
 arch/x86/kernel/smpboot.c                        |    4 ++--
 arch/x86/mach-generic/bigsmp.c                   |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    2 +-
 arch/x86/mach-generic/numaq.c                    |    2 +-
 arch/x86/mach-generic/summit.c                   |    2 +-
 10 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
index 71a3a41..99c72be 100644
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ b/arch/x86/include/asm/es7000/wakecpu.h
@@ -13,12 +13,4 @@ static inline void es7000_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-extern void __inquire_remote_apic(int apicid);
-
-static inline void inquire_remote_apic(int apicid)
-{
-	if (apic_verbosity >= APIC_DEBUG)
-		__inquire_remote_apic(apicid);
-}
-
 #endif /* __ASM_MACH_WAKECPU_H */
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index 656bb5e..b1cde56 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -16,7 +16,7 @@ static inline void __inquire_remote_apic(int apicid)
 }
 #endif /* CONFIG_SMP */
 
-static inline void inquire_remote_apic(int apicid)
+static inline void default_inquire_remote_apic(int apicid)
 {
 	if (apic_verbosity >= APIC_DEBUG)
 		__inquire_remote_apic(apicid);
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
index 93207df..0b884c0 100644
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -1,6 +1,4 @@
 #ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 #define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
 
-#define inquire_remote_apic (apic->inquire_remote_apic)
-
 #endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
index 920dcfe..afe8143 100644
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ b/arch/x86/include/asm/numaq/wakecpu.h
@@ -25,8 +25,4 @@ numaq_store_NMI_vector(unsigned short *high, unsigned short *low)
 	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
 }
 
-static inline void inquire_remote_apic(int apicid)
-{
-}
-
 #endif /* __ASM_NUMAQ_WAKECPU_H */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 1492024..170adc5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -876,8 +876,8 @@ do_rest:
 			else
 				/* trampoline code not run */
 				printk(KERN_ERR "Not responding.\n");
-			if (get_uv_system_type() != UV_NON_UNIQUE_APIC)
-				inquire_remote_apic(apicid);
+			if (apic->inquire_remote_apic)
+				apic->inquire_remote_apic(apicid);
 		}
 	}
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index d9377af..4d8b2d4 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -111,5 +111,5 @@ struct genapic apic_bigsmp = {
 
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.inquire_remote_apic		= inquire_remote_apic,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index b004257..c12dd23 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -92,5 +92,5 @@ struct genapic apic_default = {
 
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.inquire_remote_apic		= inquire_remote_apic,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 62673a8..be090b2 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -148,5 +148,5 @@ struct genapic apic_es7000 = {
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.inquire_remote_apic		= inquire_remote_apic,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 2c33415..ddb50fb 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -112,5 +112,5 @@ struct genapic apic_numaq = {
 
 	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
 	.store_NMI_vector		= numaq_store_NMI_vector,
-	.inquire_remote_apic		= inquire_remote_apic,
+	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index c2471a9..d5db304 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -91,5 +91,5 @@ struct genapic apic_summit = {
 
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.inquire_remote_apic		= inquire_remote_apic,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 };
-- 
1.6.0.2

