Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZEPQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZEPQp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZEPQpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 12:45:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:59439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZEPQpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 12:45:47 -0400
Message-ID: <4A0EED8B.6040704@kernel.org>
Date: Sat, 16 May 2009 09:44:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] x86: add X86_UPDATE_MPTABLE option
References: <4A0DC7DC.7000204@kernel.org>
In-Reply-To: <4A0DC7DC.7000204@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so could enable it for special purpose.
1. for acpi enabled kernel kexec kernel without acpi
2. for crossing check mptable or have correct mptable

even with this option enabled, user still need to use
update_mpatble or alloc_mptable in command line

[ Impact: new config option to disable update_mptable ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig              |   10 ++++++++++
 arch/x86/include/asm/mpspec.h |    9 +++++++--
 arch/x86/kernel/acpi/boot.c   |    3 ++-
 arch/x86/kernel/mpparse.c     |    4 ++++
 4 files changed, 23 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -292,6 +292,16 @@ config X86_MPPARSE
 	  For old smp systems that do not have proper acpi support. Newer systems
 	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
 
+config X86_UPDATE_MPTABLE
+	bool "Enable update mptable according to acpi" if ACPI
+	default n
+	depends on X86_MPPARSE && ACPI
+	---help---
+	  some systems do not have correct mptable. with "update_mptable" or
+	  "alloc_mptable" kernel could try to update mptable according to DSDT.
+	  Then could use kexec to start second kernel (even old) without acpi
+	  support or "acpi=off"
+
 config X86_BIGSMP
 	bool "Support for big SMP systems with more than 8 CPUs"
 	depends on X86_32 && SMP
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1159,7 +1159,7 @@ void __init mp_config_acpi_legacy_irqs(v
 static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 			int polarity)
 {
-#ifdef CONFIG_X86_MPPARSE
+#ifdef CONFIG_X86_UPDATE_MPTABLE
 	struct mpc_intsrc mp_irq;
 	struct pci_dev *pdev;
 	unsigned char number;
@@ -1191,6 +1191,7 @@ static int mp_config_acpi_gsi(struct dev
 
 	save_mp_irq(&mp_irq);
 #endif
+
 	return 0;
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -797,6 +797,8 @@ void __init find_smp_config(void)
 	__find_smp_config(1);
 }
 
+#ifdef CONFIG_X86_UPDATE_MPTABLE
+
 #ifdef CONFIG_X86_IO_APIC
 static u8 __initdata irq_used[MAX_IRQ_SOURCES];
 
@@ -1086,3 +1088,5 @@ static int __init update_mp_table(void)
 }
 
 late_initcall(update_mp_table);
+
+#endif /* CONFIG_X86_UPDATE_MPTABLE */
Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -60,9 +60,15 @@ extern void get_smp_config(void);
 
 #ifdef CONFIG_X86_MPPARSE
 extern void find_smp_config(void);
-extern void early_reserve_e820_mpc_new(void);
 #else
 static inline void find_smp_config(void) { }
+#endif
+
+#ifdef CONFIG_X86_UPDATE_MPTABLE
+extern int enable_update_mptable;
+extern void early_reserve_e820_mpc_new(void);
+#else
+#define enable_update_mptable (0)
 static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
@@ -72,7 +78,6 @@ extern void mp_register_ioapic(int id, u
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
-extern int enable_update_mptable;
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
