Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZA2AWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZA2AWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbZA1Xq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:53353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841AbZA1Xqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:54 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 093/114] x86: generalize boot_cpu_id
Date: Wed, 28 Jan 2009 23:42:39 +0000
Message-Id: <1233186180-29883-94-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager can boot on non-zero processors. While that can probably
be fixed by properly remapping the physical CPU IDs, keep boot_cpu_id
for now for easier transition - and expand it to all of x86.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig           |    4 ----
 arch/x86/include/asm/cpu.h |    6 +-----
 arch/x86/kernel/setup.c    |   14 ++++++++++++++
 arch/x86/kernel/smpboot.c  |   12 ------------
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3671506..f4dd851 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -238,10 +238,6 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
-config X86_HAS_BOOT_CPU_ID
-	def_bool y
-	depends on X86_VOYAGER
-
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on PCI_MSI || HT_IRQ
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index f03b23e..b185091 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,10 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
-extern unsigned char boot_cpu_id;
-#else
-#define boot_cpu_id				0
-#endif
+extern unsigned int boot_cpu_id;
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index eeb180b..609e5af 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,6 +112,20 @@
 #define ARCH_SETUP
 #endif
 
+unsigned int boot_cpu_id __read_mostly;
+
+#ifdef CONFIG_X86_64
+int default_cpu_present_to_apicid(int mps_cpu)
+{
+	return __default_cpu_present_to_apicid(mps_cpu);
+}
+
+int default_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return __default_check_phys_apicid_present(boot_cpu_physical_apicid);
+}
+#endif
+
 #ifndef CONFIG_DEBUG_BOOT_PARAMS
 struct boot_params __initdata boot_params;
 #else
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e90b3e5..bc7e220 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -905,18 +905,6 @@ do_rest:
 	return boot_error;
 }
 
-#ifdef CONFIG_X86_64
-int default_cpu_present_to_apicid(int mps_cpu)
-{
-	return __default_cpu_present_to_apicid(mps_cpu);
-}
-
-int default_check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return __default_check_phys_apicid_present(boot_cpu_physical_apicid);
-}
-#endif
-
 int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
-- 
1.6.0.2

