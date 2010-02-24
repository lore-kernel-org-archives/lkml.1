Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0BXIVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:21:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:46002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0BXIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:21:17 -0500
Message-ID: <4B84E12A.5040206@kernel.org>
Date: Wed, 24 Feb 2010 00:19:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: kill smpboot_hooks.h
References: <4B84E09D.4090600@kernel.org>
In-Reply-To: <4B84E09D.4090600@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


only one user, move it back to smpboot.c

remove smpboot_clear_io_apic, and only keep smpboot_clear_io_apic_irqs.

and check nr_legacy_irqs before clear it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/smpboot_hooks.h |   61 -----------------------------------
 arch/x86/kernel/smpboot.c            |   57 ++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 64 deletions(-)

Index: linux-2.6/arch/x86/include/asm/smpboot_hooks.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smpboot_hooks.h
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
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -67,7 +67,6 @@
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
-#include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
 #ifdef CONFIG_X86_32
@@ -700,6 +699,35 @@ static void __cpuinit announce_cpu(int c
 			node, cpu, apicid);
 }
 
+static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
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
+static inline void smpboot_restore_warm_reset_vector(void)
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
@@ -927,6 +955,13 @@ int __cpuinit native_cpu_up(unsigned int
 	return 0;
 }
 
+static inline void smpboot_clear_io_apic_irqs(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (legacy_pic->nr_legacy_irqs)
+		io_apic_irqs = 0;
+#endif
+}
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -1026,7 +1061,7 @@ static int __init smp_sanity_check(unsig
 			pr_err("... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
 		}
-		smpboot_clear_io_apic();
+		smpboot_clear_io_apic_irqs();
 		arch_disable_smp_support();
 		return -1;
 	}
@@ -1038,7 +1073,7 @@ static int __init smp_sanity_check(unsig
 	 */
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated.\n");
-		smpboot_clear_io_apic();
+		smpboot_clear_io_apic_irqs();
 
 		localise_nmi_watchdog();
 
@@ -1063,6 +1098,22 @@ static void __init smp_cpu_index_default
 	}
 }
 
+static inline void __init smpboot_setup_io_apic(void)
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
