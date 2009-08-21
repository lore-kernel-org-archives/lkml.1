Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbZHUVbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbZHUVbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbZHUVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:42 -0400
Received: from www.tglx.de ([62.245.132.106]:51559 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbZHUVbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:41 -0400
Message-Id: <20090821205602.192415240@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:30:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 08/32] x86: Move mpc_apic_id to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-mpc_apic_id-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mpc_apic_id setup is handled by a x86_quirk. Make it a
platform_setup function with a default implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/mpspec.h    |    2 ++
 arch/x86/include/asm/platform.h  |    4 ++++
 arch/x86/include/asm/setup.h     |    2 --
 arch/x86/kernel/apic/numaq_32.c  |    2 +-
 arch/x86/kernel/mpparse.c        |   10 ++++++----
 arch/x86/kernel/platform_setup.c |    2 ++
 6 files changed, 15 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -62,10 +62,12 @@ extern void get_smp_config(void);
 extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
 extern int enable_update_mptable;
+extern int default_mpc_apic_id(struct mpc_cpu *m);
 #else
 static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
 #define enable_update_mptable 0
+#define default_mpc_apic_id NULL
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PLATFORM_H
 #define _ASM_X86_PLATFORM_H
 
+struct mpc_cpu;
+
 /**
  * struct platform_setup_quirks - platform specific quirks
  * @mpc_record:			platform specific mpc record accounting
@@ -12,9 +14,11 @@ struct platform_setup_quirks {
 /**
  * struct platform_setup_mpparse - platform specific mpparse ops
  * @setup_ioapic_ids:		platform specific ioapic id override
+ * @mpc_apic_id:		platform specific mpc apic id assignment
  */
 struct platform_setup_mpparse {
 	void (*setup_ioapic_ids)(void);
+	int (*mpc_apic_id)(struct mpc_cpu *m);
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
-struct mpc_cpu;
 struct mpc_bus;
 struct mpc_oemtable;
 
@@ -25,7 +24,6 @@ struct x86_quirks {
 	int (*mach_get_smp_config)(unsigned int early);
 	int (*mach_find_smp_config)(unsigned int reserve);
 
-	int (*mpc_apic_id)(struct mpc_cpu *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -270,7 +270,6 @@ static struct x86_quirks numaq_x86_quirk
 	.arch_trap_init			= NULL,
 	.mach_get_smp_config		= NULL,
 	.mach_find_smp_config		= NULL,
-	.mpc_apic_id			= mpc_apic_id,
 	.mpc_oem_bus_info		= mpc_oem_bus_info,
 	.mpc_oem_pci_bus		= mpc_oem_pci_bus,
 	.smp_read_mpc_oem		= smp_read_mpc_oem,
@@ -293,6 +292,7 @@ static __init void early_check_numaq(voi
 		x86_quirks = &numaq_x86_quirks;
 		platform_setup.quirks.mpc_record = numaq_mpc_record;
 		platform_setup.mpparse.setup_ioapic_ids = platform_setup_noop;
+		platform_setup.mpparse.mpc_apic_id = mpc_apic_id;
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -45,6 +45,11 @@ static int __init mpf_checksum(unsigned 
 	return sum & 0xFF;
 }
 
+int __init default_mpc_apic_id(struct mpc_cpu *m)
+{
+	return m->apicid;
+}
+
 static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int apicid;
@@ -55,10 +60,7 @@ static void __init MP_processor_info(str
 		return;
 	}
 
-	if (x86_quirks->mpc_apic_id)
-		apicid = x86_quirks->mpc_apic_id(m);
-	else
-		apicid = m->apicid;
+	apicid = platform_setup.mpparse.mpc_apic_id(m);
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 
 #include <asm/bios_ebda.h>
+#include <asm/mpspec.h>
 #include <asm/setup.h>
 #include <asm/e820.h>
 
@@ -27,6 +28,7 @@ struct __initdata platform_setup_ops pla
 
 	.mpparse = {
 		.setup_ioapic_ids = platform_setup_noop,
+		.mpc_apic_id = default_mpc_apic_id,
 	},
 
 	.quirks = {


