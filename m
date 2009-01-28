Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbZA2ADJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbZA2ADJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZA1XpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:52991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751AbZA1XpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:06 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 048/114] x86: refactor ->enable_apic_mode() subarch methods
Date: Wed, 28 Jan 2009 23:41:54 +0000
Message-Id: <1233186180-29883-49-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only ES7000 has a real ->enable_apic_mode() method, the other
subarchitectures define it but keep it empty.

So mark the vector as NULL, extend the generic code to handle
NULL -setup_portio_remap() entries and remove all the empty
handlers.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    4 ----
 arch/x86/include/asm/mach-default/mach_apic.h |    3 ---
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 -
 arch/x86/include/asm/numaq/apic.h             |    4 ----
 arch/x86/include/asm/summit/apic.h            |    4 ----
 arch/x86/kernel/apic.c                        |    3 ++-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/es7000.c                |    6 +++---
 arch/x86/mach-generic/numaq.c                 |    2 +-
 arch/x86/mach-generic/summit.c                |    2 +-
 11 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 5ba4118..f49d440 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -104,10 +104,6 @@ static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 	return 1;
 }
 
-static inline void enable_apic_mode(void)
-{
-}
-
 /* As we are using single CPU as destination, pick only one CPU here */
 static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 0a824d3..3647c92 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -145,8 +145,5 @@ static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
 	return physid_mask_of_physid(phys_apicid);
 }
 
-static inline void enable_apic_mode(void)
-{
-}
 #endif /* CONFIG_X86_LOCAL_APIC */
 #endif /* _ASM_X86_MACH_DEFAULT_MACH_APIC_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index efd762d..6fed521 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -5,7 +5,6 @@
 
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
-#define enable_apic_mode (apic->enable_apic_mode)
 #define phys_pkg_id (apic->phys_pkg_id)
 #define wakeup_secondary_cpu (apic->wakeup_cpu)
 
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 3be735e..dc93c30 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -97,10 +97,6 @@ static inline int numaq_check_phys_apicid_present(int boot_cpu_physical_apicid)
 	return 1;
 }
 
-static inline void enable_apic_mode(void)
-{
-}
-
 /*
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index fe578f6..526d19e 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -125,10 +125,6 @@ static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 	return 1;
 }
 
-static inline void enable_apic_mode(void)
-{
-}
-
 static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index fcbcc03..9d6374d 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1763,7 +1763,8 @@ void __init connect_bsp_APIC(void)
 		outb(0x01, 0x23);
 	}
 #endif
-	enable_apic_mode();
+	if (apic->enable_apic_mode)
+		apic->enable_apic_mode();
 }
 
 /**
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 82743d1..e151b47 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -86,7 +86,7 @@ struct genapic apic_bigsmp = {
 	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
-	.enable_apic_mode		= enable_apic_mode,
+	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index d0374c6..ac6be19 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -67,7 +67,7 @@ struct genapic apic_default = {
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= enable_apic_mode,
+	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 52b3eb5..9acb711 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -36,10 +36,10 @@ static int probe_es7000(void)
 }
 
 extern void es7000_sw_apic(void);
-static void __init enable_apic_mode(void)
+
+static void __init es7000_enable_apic_mode(void)
 {
 	es7000_sw_apic();
-	return;
 }
 
 static __init int
@@ -128,7 +128,7 @@ struct genapic apic_es7000 = {
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
-	.enable_apic_mode		= enable_apic_mode,
+	.enable_apic_mode		= es7000_enable_apic_mode,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 7ec2ca4..8d3358d 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -86,7 +86,7 @@ struct genapic apic_numaq = {
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
 	.check_phys_apicid_present	= numaq_check_phys_apicid_present,
-	.enable_apic_mode		= enable_apic_mode,
+	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index acf12de..cb83bcb 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -66,7 +66,7 @@ struct genapic apic_summit = {
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= summit_check_phys_apicid_present,
-	.enable_apic_mode		= enable_apic_mode,
+	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= phys_pkg_id,
 	.mps_oem_check			= mps_oem_check,
 
-- 
1.6.0.2

