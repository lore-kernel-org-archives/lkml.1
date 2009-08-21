Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbZHUVcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbZHUVcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbZHUVcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:12 -0400
Received: from www.tglx.de ([62.245.132.106]:51641 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946AbZHUVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:58 -0400
Message-Id: <20090821205602.360168460@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 11/32] x86: Move oem_bus_info to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-oem-bus-info-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/mpspec.h    |    6 ++++++
 arch/x86/include/asm/platform.h  |    2 ++
 arch/x86/include/asm/setup.h     |    3 ---
 arch/x86/kernel/apic/numaq_32.c  |    2 +-
 arch/x86/kernel/mpparse.c        |   14 ++++++++------
 arch/x86/kernel/platform_setup.c |    1 +
 6 files changed, 18 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -64,12 +64,18 @@ extern void early_reserve_e820_mpc_new(v
 extern int enable_update_mptable;
 extern int default_mpc_apic_id(struct mpc_cpu *m);
 extern void default_smp_read_mpc_oem(struct mpc_table *mpc);
+# ifdef CONFIG_X86_IO_APIC
+extern void default_mpc_oem_bus_info(struct mpc_bus *m, char *str);
+# else
+#  define default_mpc_oem_bus_info NULL
+# endif
 #else
 static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
 #define enable_update_mptable 0
 #define default_mpc_apic_id NULL
 #define default_smp_read_mpc_oem NULL
+#define default_mpc_oem_bus_info NULL
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -19,12 +19,14 @@ struct platform_setup_quirks {
  * @mpc_apic_id:		platform specific mpc apic id assignment
  * @smp_read_mpc_oem:		platform specific oem mpc table setup
  * @mpc_oem_pci_bus:		platform specific pci bus setup (default NULL)
+ * @mpc_oem_bus_info:		platform specific mpc bus info
  */
 struct platform_setup_mpparse {
 	void (*setup_ioapic_ids)(void);
 	int (*mpc_apic_id)(struct mpc_cpu *m);
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
+	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -12,7 +12,6 @@
 /*
  * Any setup quirks to be performed?
  */
-struct mpc_bus;
 
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
@@ -22,8 +21,6 @@ struct x86_quirks {
 	int (*arch_trap_init)(void);
 	int (*mach_get_smp_config)(unsigned int early);
 	int (*mach_find_smp_config)(unsigned int reserve);
-
-	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 };
 
 extern void x86_quirk_intr_init(void);
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -270,7 +270,6 @@ static struct x86_quirks numaq_x86_quirk
 	.arch_trap_init			= NULL,
 	.mach_get_smp_config		= NULL,
 	.mach_find_smp_config		= NULL,
-	.mpc_oem_bus_info		= mpc_oem_bus_info,
 };
 
 static __init void early_check_numaq(void)
@@ -293,6 +292,7 @@ static __init void early_check_numaq(voi
 		platform_setup.mpparse.mpc_apic_id = mpc_apic_id;
 		platform_setup.mpparse.smp_read_mpc_oem	= smp_read_mpc_oem;
 		platform_setup.mpparse.mpc_oem_pci_bus = mpc_oem_pci_bus;
+		platform_setup.mpparse.mpc_oem_bus_info	= mpc_oem_bus_info;
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -72,16 +72,18 @@ static void __init MP_processor_info(str
 }
 
 #ifdef CONFIG_X86_IO_APIC
-static void __init MP_bus_info(struct mpc_bus *m)
+void __init default_mpc_oem_bus_info(struct mpc_bus *m, char *str)
 {
-	char str[7];
 	memcpy(str, m->bustype, 6);
 	str[6] = 0;
+	apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->busid, str);
+}
+
+static void __init MP_bus_info(struct mpc_bus *m)
+{
+	char str[7];
 
-	if (x86_quirks->mpc_oem_bus_info)
-		x86_quirks->mpc_oem_bus_info(m, str);
-	else
-		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->busid, str);
+	platform_setup.mpparse.mpc_oem_bus_info(m, str);
 
 #if MAX_MP_BUSSES < 256
 	if (m->busid >= MAX_MP_BUSSES) {
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -30,6 +30,7 @@ struct __initdata platform_setup_ops pla
 		.setup_ioapic_ids = platform_setup_noop,
 		.mpc_apic_id = default_mpc_apic_id,
 		.smp_read_mpc_oem = default_smp_read_mpc_oem,
+		.mpc_oem_bus_info = default_mpc_oem_bus_info,
 	},
 
 	.quirks = {


