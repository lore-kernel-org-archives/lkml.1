Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZA2AFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZA2AFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbZA1XpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:53032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333AbZA1XpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:20 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 054/114] x86: consolidate the ->mps_oem_check() code
Date: Wed, 28 Jan 2009 23:42:00 +0000
Message-Id: <1233186180-29883-55-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the mps_oem_check() namespace on a per APIC driver basis

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/mpparse.h            |    6 ------
 arch/x86/include/asm/mach-default/mach_mpparse.h |    2 +-
 arch/x86/include/asm/mach-generic/mach_mpparse.h |    3 +--
 arch/x86/include/asm/summit/mpparse.h            |    4 ++--
 arch/x86/kernel/mpparse.c                        |    2 +-
 arch/x86/mach-generic/bigsmp.c                   |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    5 +++--
 arch/x86/mach-generic/numaq.c                    |    4 ++--
 arch/x86/mach-generic/probe.c                    |    3 ++-
 arch/x86/mach-generic/summit.c                   |    2 +-
 11 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/es7000/mpparse.h b/arch/x86/include/asm/es7000/mpparse.h
index 30692c4..662eb1e 100644
--- a/arch/x86/include/asm/es7000/mpparse.h
+++ b/arch/x86/include/asm/es7000/mpparse.h
@@ -8,13 +8,7 @@ extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
 extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 extern void setup_unisys(void);
 
-#ifndef CONFIG_X86_GENERICARCH
-extern int default_acpi_madt_oem_check(char *oem_id, char *oem_table_id);
-extern int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid);
-#endif
-
 #ifdef CONFIG_ACPI
-
 static inline int es7000_check_dsdt(void)
 {
 	struct acpi_table_header header;
diff --git a/arch/x86/include/asm/mach-default/mach_mpparse.h b/arch/x86/include/asm/mach-default/mach_mpparse.h
index 8fa0177..af0da14 100644
--- a/arch/x86/include/asm/mach-default/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-default/mach_mpparse.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
 
 static inline int
-mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_mpparse.h b/arch/x86/include/asm/mach-generic/mach_mpparse.h
index f497d96..22bfb56 100644
--- a/arch/x86/include/asm/mach-generic/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-generic/mach_mpparse.h
@@ -1,8 +1,7 @@
 #ifndef _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H
 #define _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H
 
-
-extern int mps_oem_check(struct mpc_table *, char *, char *);
+extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
 
 extern int default_acpi_madt_oem_check(char *, char *);
 
diff --git a/arch/x86/include/asm/summit/mpparse.h b/arch/x86/include/asm/summit/mpparse.h
index 555ed82..4bbcce3 100644
--- a/arch/x86/include/asm/summit/mpparse.h
+++ b/arch/x86/include/asm/summit/mpparse.h
@@ -11,8 +11,8 @@ extern void setup_summit(void);
 #define setup_summit()	{}
 #endif
 
-static inline int mps_oem_check(struct mpc_table *mpc, char *oem,
-		char *productid)
+static inline int
+summit_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (!strncmp(oem, "IBM ENSW", 8) &&
 			(!strncmp(productid, "VIGIL SMP", 9)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index f6fb192..b12fa5c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -292,7 +292,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		return 0;
 
 #ifdef CONFIG_X86_32
-	mps_oem_check(mpc, oem, str);
+	generic_mps_oem_check(mpc, oem, str);
 #endif
 	/* save the local APIC address, it might be non-default */
 	if (!acpi_lapic)
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index d04b389..6bf6aaf 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -88,7 +88,7 @@ struct genapic apic_bigsmp = {
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
-	.mps_oem_check			= mps_oem_check,
+	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= NULL,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 5c9266f..e5f85cd 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -69,7 +69,7 @@ struct genapic apic_default = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
-	.mps_oem_check			= mps_oem_check,
+	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= NULL,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 52787e3..f861163 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -36,11 +36,12 @@ static int probe_es7000(void)
 }
 
 static __init int
-mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+es7000_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (mpc->oemptr) {
 		struct mpc_oemtable *oem_table =
 			(struct mpc_oemtable *)mpc->oemptr;
+
 		if (!strncmp(oem, "UNISYS", 6))
 			return parse_unisys_oem((char *)oem_table);
 	}
@@ -123,7 +124,7 @@ struct genapic apic_es7000 = {
 	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
 	.enable_apic_mode		= es7000_enable_apic_mode,
 	.phys_pkg_id			= es7000_phys_pkg_id,
-	.mps_oem_check			= mps_oem_check,
+	.mps_oem_check			= es7000_mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= NULL,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 6a1134e..517882c 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -19,7 +19,7 @@
 #include <asm/numaq/wakecpu.h>
 #include <asm/numaq.h>
 
-static int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+static int __numaq_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	numaq_mps_oem_check(mpc, oem, productid);
 	return found_numaq;
@@ -88,7 +88,7 @@ struct genapic apic_numaq = {
 	.check_phys_apicid_present	= numaq_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numaq_phys_pkg_id,
-	.mps_oem_check			= mps_oem_check,
+	.mps_oem_check			= __numaq_mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= NULL,
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index 799a70f..ab68c6e 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -110,7 +110,8 @@ void __init generic_apic_probe(void)
 
 /* These functions can switch the APIC even after the initial ->probe() */
 
-int __init mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+int __init
+generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	int i;
 
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 2d6843a..719e944 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -68,7 +68,7 @@ struct genapic apic_summit = {
 	.check_phys_apicid_present	= summit_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= summit_phys_pkg_id,
-	.mps_oem_check			= mps_oem_check,
+	.mps_oem_check			= summit_mps_oem_check,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= NULL,
-- 
1.6.0.2

