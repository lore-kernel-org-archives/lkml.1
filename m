Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbZA2ALY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbZA2ALY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZA1Xp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:53131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbZA1Xpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:53 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 068/114] x86, smp: eliminate asm/mach-default/mach_wakecpu.h
Date: Wed, 28 Jan 2009 23:42:14 +0000
Message-Id: <1233186180-29883-69-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spread mach_wakecpu.h's definitions into apic.h and genapic.h
and remove mach_wakecpu.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h                      |   15 +++++++++++++
 arch/x86/include/asm/genapic.h                   |    7 ++++++
 arch/x86/include/asm/mach-default/mach_wakecpu.h |   25 ----------------------
 arch/x86/kernel/smpboot.c                        |    1 -
 arch/x86/mach-generic/bigsmp.c                   |    1 -
 arch/x86/mach-generic/default.c                  |    1 -
 arch/x86/mach-generic/es7000.c                   |    1 -
 arch/x86/mach-generic/summit.c                   |    1 -
 8 files changed, 22 insertions(+), 30 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-default/mach_wakecpu.h

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ab1d51a..e8f0304 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -41,6 +41,21 @@ extern unsigned int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
 extern int disable_apic;
+
+#ifdef CONFIG_SMP
+extern void __inquire_remote_apic(int apicid);
+#else /* CONFIG_SMP */
+static inline void __inquire_remote_apic(int apicid)
+{
+}
+#endif /* CONFIG_SMP */
+
+static inline void default_inquire_remote_apic(int apicid)
+{
+	if (apic_verbosity >= APIC_DEBUG)
+		__inquire_remote_apic(apicid);
+}
+
 /*
  * Basic functions accessing APICs.
  */
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index e5f9c56..1772dad 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -113,4 +113,11 @@ extern int default_cpu_present_to_apicid(int mps_cpu);
 extern int default_check_phys_apicid_present(int boot_cpu_physical_apicid);
 #endif
 
+static inline void default_wait_for_init_deassert(atomic_t *deassert)
+{
+	while (!atomic_read(deassert))
+		cpu_relax();
+	return;
+}
+
 #endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
deleted file mode 100644
index b1cde56..0000000
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
-#define _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
-
-static inline void default_wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-	return;
-}
-
-#ifdef CONFIG_SMP
-extern void __inquire_remote_apic(int apicid);
-#else /* CONFIG_SMP */
-static inline void __inquire_remote_apic(int apicid)
-{
-}
-#endif /* CONFIG_SMP */
-
-static inline void default_inquire_remote_apic(int apicid)
-{
-	if (apic_verbosity >= APIC_DEBUG)
-		__inquire_remote_apic(apicid);
-}
-
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 170adc5..1fdc1a7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -66,7 +66,6 @@
 #include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
-#include <mach_wakecpu.h>
 #include <smpboot_hooks.h>
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 4d8b2d4..6fcccfb 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -17,7 +17,6 @@
 #include <asm/bigsmp/apic.h>
 #include <asm/bigsmp/ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
-#include <asm/mach-default/mach_wakecpu.h>
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index c12dd23..e3c5114 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -16,7 +16,6 @@
 #include <asm/mach-default/mach_apic.h>
 #include <asm/mach-default/mach_ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
-#include <asm/mach-default/mach_wakecpu.h>
 
 static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 8b6113e..bb11166 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -14,7 +14,6 @@
 #include <linux/acpi.h>
 #include <linux/smp.h>
 #include <asm/ipi.h>
-#include <asm/mach-default/mach_wakecpu.h>
 
 #define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
 #define INT_DELIVERY_MODE_CLUSTER	(dest_LowestPrio)
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index d5db304..673a64f 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -16,7 +16,6 @@
 #include <asm/summit/apic.h>
 #include <asm/summit/ipi.h>
 #include <asm/summit/mpparse.h>
-#include <asm/mach-default/mach_wakecpu.h>
 
 static int probe_summit(void)
 {
-- 
1.6.0.2

