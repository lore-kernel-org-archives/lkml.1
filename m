Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZAFGD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZAFGD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZAFGDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:03:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZAFGDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:03:50 -0500
Date: Tue, 6 Jan 2009 07:03:48 +0100
From: Nick Piggin <npiggin@suse.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: [patch] x86: make UV support optional
Message-ID: <20090106060348.GA16738@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UV is fairly rare.... and much of the support is already there to cope with
32-bit builds. So this makes sense I think.

--
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
 arch/x86/kernel/entry_64.S        |    2 ++
 arch/x86/kernel/genapic_64.c      |    3 ++-
 arch/x86/kernel/io_apic.c         |    2 +-
 8 files changed, 39 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -390,6 +390,13 @@ config X86_RDC321X
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
@@ -3762,7 +3762,7 @@ int arch_setup_ht_irq(unsigned int irq,
 }
 #endif /* CONFIG_HT_IRQ */
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_UV
 /*
  * Re-target the irq to the specified CPU and enable the specified MMR located
  * on the specified blade to allow the sending of MSIs to the specified CPU.
