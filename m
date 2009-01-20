Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZATDgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZATDgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbZATDgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:36:08 -0500
Received: from ns.suse.de ([195.135.220.2]:47235 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZATDgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:36:06 -0500
Date: Tue, 20 Jan 2009 04:36:04 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       steiner@sgi.com
Subject: [patch] x86: make UV support configurable
Message-ID: <20090120033604.GF16304@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the EFI omission since the last patch. I have not changed the
Kconfig to include (what I think are) false dependencies (which really
frustrate me when things get badly tangled up). If people want to test
as much stuff as possible even that is not supported by their hardware,
we have allyesconfig/allmodconfig. I don't think UV is particularly
special in that respect (we allow Intel, AMD, etc CPUs to be configured
out)

If anything, X86_UV should *select* MAXSMP, rather than the other way
around. That would be more logical, but even then I don't like adding
still a false dep because one might have a small UV system, or want to
test with different NR_CPUS.

Anyway, I think this patch is good as-is. If someone wants to streamline
config options with subsequent patches, that's great. If Ingo can be
convinced of a better arrangement, fine.
---

Make X86 SGI Ultraviolet support configurable. Saves about 13K of text size
on my modest config.

   text    data     bss     dec     hex filename
6770537 1158680  694356 8623573  8395d5 vmlinux
6757492 1157664  694228 8609384  835e68 vmlinux.nouv

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 arch/x86/Kconfig                  |    7 +++++++
 arch/x86/include/asm/genapic.h    |   24 ++++++++++++++++++++++++
 arch/x86/include/asm/genapic_32.h |    7 -------
 arch/x86/include/asm/genapic_64.h |    9 ---------
 arch/x86/kernel/Makefile          |    5 +++--
 arch/x86/kernel/efi.c             |    2 ++
 arch/x86/kernel/entry_64.S        |    2 ++
 arch/x86/kernel/genapic_64.c      |    3 ++-
 arch/x86/kernel/io_apic.c         |    2 +-
 9 files changed, 41 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -391,6 +391,13 @@ config X86_RDC321X
 	  as R-8610-(G).
 	  If you don't have one of these chips, you should say N here.
 
+config X86_UV
+	bool "SGI Ultraviolet"
+	depends on X86_64
+	help
+	  This option is needed in order to support SGI Ultraviolet systems.
+	  If you don't have one of these, you should say N here.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
Index: linux-2.6/arch/x86/include/asm/genapic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic.h
+++ linux-2.6/arch/x86/include/asm/genapic.h
@@ -1,5 +1,29 @@
+#ifndef _ASM_X86_GENAPIC_H
+#define _ASM_X86_GENAPIC_H
+
 #ifdef CONFIG_X86_32
 # include "genapic_32.h"
 #else
 # include "genapic_64.h"
 #endif
+
+#ifdef CONFIG_X86_UV
+DECLARE_PER_CPU(int, x2apic_extra_bits);
+enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
+extern enum uv_system_type get_uv_system_type(void);
+extern int is_uv_system(void);
+
+extern struct genapic apic_x2apic_uv_x;
+extern void uv_cpu_init(void);
+extern void uv_system_init(void);
+extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
+#else
+enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
+#define get_uv_system_type()		UV_NONE
+#define is_uv_system()			0
+#define uv_wakeup_secondary(a, b)	1
+#define uv_system_init()		do {} while (0)
+#define uv_cpu_init()			do {} while (0)
+#endif
+
+#endif
Index: linux-2.6/arch/x86/include/asm/genapic_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic_32.h
+++ linux-2.6/arch/x86/include/asm/genapic_32.h
@@ -138,11 +138,4 @@ struct genapic {
 extern struct genapic *genapic;
 extern void es7000_update_genapic_to_cluster(void);
 
-enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
-#define get_uv_system_type()		UV_NONE
-#define is_uv_system()			0
-#define uv_wakeup_secondary(a, b)	1
-#define uv_system_init()		do {} while (0)
-
-
 #endif /* _ASM_X86_GENAPIC_32_H */
Index: linux-2.6/arch/x86/include/asm/genapic_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic_64.h
+++ linux-2.6/arch/x86/include/asm/genapic_64.h
@@ -51,15 +51,6 @@ extern struct genapic apic_x2apic_phys;
 extern int acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
-enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
-extern enum uv_system_type get_uv_system_type(void);
-extern int is_uv_system(void);
-
-extern struct genapic apic_x2apic_uv_x;
-DECLARE_PER_CPU(int, x2apic_extra_bits);
-extern void uv_cpu_init(void);
-extern void uv_system_init(void);
-extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 
 extern void setup_apic_routing(void);
 
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -114,10 +114,11 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_6
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
-        obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
-	obj-y				+= bios_uv.o uv_irq.o uv_sysfs.o
+        obj-y				+= genapic_64.o genapic_flat_64.o
         obj-y				+= genx2apic_cluster.o
         obj-y				+= genx2apic_phys.o
+	obj-$(CONFIG_X86_UV)		+= genx2apic_uv_x.o tlb_uv.o
+	obj-$(CONFIG_X86_UV)		+= bios_uv.o uv_irq.o uv_sysfs.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
 
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6/arch/x86/kernel/entry_64.S
@@ -981,8 +981,10 @@ apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
 	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
 #endif
 
+#ifdef CONFIG_X86_UV
 apicinterrupt UV_BAU_MESSAGE \
 	uv_bau_message_intr1 uv_bau_message_interrupt
+#endif
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
 
Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -25,14 +25,15 @@
 
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
-extern struct genapic apic_x2xpic_uv_x;
 extern struct genapic apic_x2apic_phys;
 extern struct genapic apic_x2apic_cluster;
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
 static struct genapic *apic_probe[] __initdata = {
+#ifdef CONFIG_X86_UV
 	&apic_x2apic_uv_x,
+#endif
 	&apic_x2apic_phys,
 	&apic_x2apic_cluster,
 	&apic_physflat,
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3760,7 +3760,7 @@ int arch_setup_ht_irq(unsigned int irq,
 }
 #endif /* CONFIG_HT_IRQ */
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_UV
 /*
  * Re-target the irq to the specified CPU and enable the specified MMR located
  * on the specified blade to allow the sending of MSIs to the specified CPU.
Index: linux-2.6/arch/x86/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -366,10 +366,12 @@ void __init efi_init(void)
 					SMBIOS_TABLE_GUID)) {
 			efi.smbios = config_tables[i].table;
 			printk(" SMBIOS=0x%lx ", config_tables[i].table);
+#ifdef CONFIG_X86_UV
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					UV_SYSTEM_TABLE_GUID)) {
 			efi.uv_systab = config_tables[i].table;
 			printk(" UVsystab=0x%lx ", config_tables[i].table);
+#endif
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					HCDP_TABLE_GUID)) {
 			efi.hcdp = config_tables[i].table;
