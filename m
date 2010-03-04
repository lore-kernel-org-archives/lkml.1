Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0CDKK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:10:29 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51076 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0CDKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/12] x86: kill smpboot_hooks.h
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only one user, move it back to smpboot.c

remove smpboot_clear_io_apic, and only keep smpboot_clear_io_apic_irqs.

and check nr_legacy_irqs before clear it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/smpboot_hooks.h |   61 ----------------------------------
 arch/x86/kernel/smpboot.c            |   57 ++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 64 deletions(-)
 delete mode 100644 arch/x86/include/asm/smpboot_hooks.h

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
deleted file mode 100644
index 1def601..0000000
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
- * which needs to alter them. */
-
-static inline void smpboot_clear_io_apic_irqs(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	io_apic_irqs = 0;
-#endif
-}
-
-static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
-{
-	CMOS_WRITE(0xa, 0xf);
-	local_flush_tlb();
-	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
-								 start_eip >> 4;
-	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
-							 start_eip & 0xf;
-	pr_debug("3.\n");
-}
-
-static inline void smpboot_restore_warm_reset_vector(void)
-{
-	/*
-	 * Install writable page 0 entry to set BIOS data area.
-	 */
-	local_flush_tlb();
-
-	/*
-	 * Paranoid:  Set warm reset code and vector here back
-	 * to default values.
-	 */
-	CMOS_WRITE(0, 0xf);
-
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
-}
-
-static inline void __init smpboot_setup_io_apic(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * Here we can be sure that there is an IO-APIC in the system. Let's
-	 * go and set it up:
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
-		nr_ioapics = 0;
-		localise_nmi_watchdog();
-	}
-#endif
-}
-
-static inline void smpboot_clear_io_apic(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	nr_ioapics = 0;
-#endif
-}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a02e80c..5c85a8f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -67,7 +67,6 @@
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
-#include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
 #ifdef CONFIG_X86_32
@@ -701,6 +700,35 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
 			node, cpu, apicid);
 }
 
+static void smpboot_setup_warm_reset_vector(unsigned long start_eip)
+{
+	CMOS_WRITE(0xa, 0xf);
+	local_flush_tlb();
+	pr_debug("1.\n");
+	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
+								 start_eip >> 4;
+	pr_debug("2.\n");
+	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
+							 start_eip & 0xf;
+	pr_debug("3.\n");
+}
+
+static void smpboot_restore_warm_reset_vector(void)
+{
+	/*
+	 * Install writable page 0 entry to set BIOS data area.
+	 */
+	local_flush_tlb();
+
+	/*
+	 * Paranoid:  Set warm reset code and vector here back
+	 * to default values.
+	 */
+	CMOS_WRITE(0, 0xf);
+
+	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+}
+
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -928,6 +956,13 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+static void smpboot_clear_io_apic_irqs(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (legacy_pic->nr_legacy_irqs)
+		io_apic_irqs = 0;
+#endif
+}
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -1027,7 +1062,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 			pr_err("... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
 		}
-		smpboot_clear_io_apic();
+		smpboot_clear_io_apic_irqs();
 		arch_disable_smp_support();
 		return -1;
 	}
@@ -1039,7 +1074,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated.\n");
-		smpboot_clear_io_apic();
+		smpboot_clear_io_apic_irqs();
 
 		localise_nmi_watchdog();
 
@@ -1064,6 +1099,22 @@ static void __init smp_cpu_index_default(void)
 	}
 }
 
+static void __init smpboot_setup_io_apic(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Here we can be sure that there is an IO-APIC in the system. Let's
+	 * go and set it up:
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		setup_IO_APIC();
+	else {
+		nr_ioapics = 0;
+		localise_nmi_watchdog();
+	}
+#endif
+}
+
 /*
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
-- 
1.6.4.2

