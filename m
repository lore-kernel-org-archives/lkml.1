Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZH3Nqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZH3Nqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZH3Nqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:46:49 -0400
Received: from www.tglx.de ([62.245.132.106]:53102 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbZH3Nqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:46:48 -0400
Message-Id: <20090830134517.650652025@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:46:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [patch 1/3] x86: Add early platform detection
References: <20090830134446.843410397@linutronix.de>
Content-Disposition: inline; filename=x86-add-early-platform-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms like Moorestown require early setup and want to avoid the
call to reserve_ebda_region. The x86_init override is too late when
the MRST detection happens in setup_arch. Move the default i386
x86_init overrides and the call to reserve_ebda_region into a separate
function which is called as the default of a switch case depending on
the hardware_subarch id in boot params. This allows us to add a case
for MRST and let MRST have its own early setup function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/x86_init.h |    3 +--
 arch/x86/kernel/head32.c        |   22 +++++++++++++++++-----
 arch/x86/kernel/head64.c        |    3 ++-
 arch/x86/kernel/x86_init.c      |    1 -
 4 files changed, 20 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6-tip/arch/x86/include/asm/x86_init.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PLATFORM_H
 
 #include <asm/pgtable_types.h>
+#include <asm/bootparam.h>
 
 struct mpc_bus;
 struct mpc_cpu;
@@ -34,14 +35,12 @@ struct x86_init_mpparse {
  * @probe_roms:			probe BIOS roms
  * @reserve_resources:		reserve the standard resources for the
  *				platform
- * @reserve_ebda_region:	reserve the extended bios data area
  * @memory_setup:		platform specific memory setup
  *
  */
 struct x86_init_resources {
 	void (*probe_roms)(void);
 	void (*reserve_resources)(void);
-	void (*reserve_ebda_region)(void);
 	char *(*memory_setup)(void);
 };
 
Index: linux-2.6-tip/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/head32.c
+++ linux-2.6-tip/arch/x86/kernel/head32.c
@@ -15,6 +15,17 @@
 #include <asm/trampoline.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
+#include <asm/bios_ebda.h>
+
+static void __init i386_default_early_setup(void)
+{
+	/* Initilize 32bit specific setup functions */
+	x86_init.resources.probe_roms = probe_roms;
+	x86_init.resources.reserve_resources = i386_reserve_resources;
+	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
+
+	reserve_ebda_region();
+}
 
 void __init i386_start_kernel(void)
 {
@@ -31,12 +42,13 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	/* Initilize 32bit specific setup functions */
-	x86_init.resources.probe_roms = probe_roms;
-	x86_init.resources.reserve_resources = i386_reserve_resources;
-	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
-	x86_init.resources.reserve_ebda_region();
+	/* Call the subarch specific early setup function */
+	switch (boot_params.hdr.hardware_subarch) {
+	default:
+		i386_default_early_setup();
+		break;
+	}
 
 	/*
 	 * At this point everything still needed from the boot loader
Index: linux-2.6-tip/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/head64.c
+++ linux-2.6-tip/arch/x86/kernel/head64.c
@@ -24,6 +24,7 @@
 #include <asm/kdebug.h>
 #include <asm/e820.h>
 #include <asm/trampoline.h>
+#include <asm/bios_ebda.h>
 
 static void __init zap_identity_mappings(void)
 {
@@ -111,7 +112,7 @@ void __init x86_64_start_reservations(ch
 	}
 #endif
 
-	x86_init.resources.reserve_ebda_region();
+	reserve_ebda_region();
 
 	/*
 	 * At this point everything still needed from the boot loader
Index: linux-2.6-tip/arch/x86/kernel/x86_init.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/x86_init.c
+++ linux-2.6-tip/arch/x86/kernel/x86_init.c
@@ -28,7 +28,6 @@ struct __initdata x86_init_ops x86_init 
 	.resources = {
 		.probe_roms		= x86_init_noop,
 		.reserve_resources	= reserve_standard_io_resources,
-		.reserve_ebda_region	= reserve_ebda_region,
 		.memory_setup		= default_machine_specific_memory_setup,
 	},
 


