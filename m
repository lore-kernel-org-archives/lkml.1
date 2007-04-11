Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXDKIxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXDKIxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXDKIxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:25 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1559 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXDKIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:21 -0400
Date: Wed, 11 Apr 2007 12:30:02 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ALPHA: fixes for specific machine types
Message-ID: <20070411123002.F17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files:

arch/alpha/kernel/core_mcpcia.c
arch/alpha/kernel/sys_rawhide.c
include/asm-alpha/core_mcpcia.h

	Determine correct hose configuration; RAWHIDE family can have
        2 or 4 hoses, so make sure non-existent hoses are ignored.

arch/alpha/kernel/err_titan.c

	Supply a needed #include <asm/irq_regs.h>

arch/alpha/kernel/module.c

	Add some useful output to the relocation overflow messages.

arch/alpha/kernel/sys_noritake.c

	Supply necessary noritake_end_irq() to correct interrupt handling.
	This fixes a problem first noted by hangs during boot probing with
	a DE500-BA TULIP NIC present.

arch/alpha/kernel/sys_sio.c

	Correct saving of original PIRQ register (PCI IRQ routing);
	change default PIRQ setting to leave PCI IRQs 9 and 14 free to
	be used for sound (Multia) and IDE (any), respectively.

include/asm-alpha/io.h

	Supply the "isa_virt_to_bus" routine.


Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

---

diff -Naurp a/arch/alpha/kernel/core_mcpcia.c b/arch/alpha/kernel/core_mcpcia.c
--- a/arch/alpha/kernel/core_mcpcia.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/core_mcpcia.c	2007-02-14 14:40:02.000000000 -0500
@@ -40,8 +40,6 @@
 # define DBG_CFG(args)
 #endif
 
-#define MCPCIA_MAX_HOSES 4
-
 /*
  * Given a bus, device, and function number, compute resulting
  * configuration space address and setup the MCPCIA_HAXR2 register
diff -Naurp a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
--- a/arch/alpha/kernel/err_titan.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/err_titan.c	2007-02-14 14:40:02.000000000 -0500
@@ -16,6 +16,7 @@
 #include <asm/smp.h>
 #include <asm/err_common.h>
 #include <asm/err_ev6.h>
+#include <asm/irq_regs.h>
 
 #include "err_impl.h"
 #include "proto.h"
diff -Naurp a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
--- a/arch/alpha/kernel/module.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/module.c	2007-02-14 14:40:02.000000000 -0500
@@ -285,12 +285,12 @@ apply_relocate_add(Elf64_Shdr *sechdrs, 
 		reloc_overflow:
 			if (ELF64_ST_TYPE (sym->st_info) == STT_SECTION)
 			  printk(KERN_ERR
-			         "module %s: Relocation overflow vs section %d\n",
-			         me->name, sym->st_shndx);
+			         "module %s: Relocation (type %lu) overflow vs section %d\n",
+			         me->name, r_type, sym->st_shndx);
 			else
 			  printk(KERN_ERR
-			         "module %s: Relocation overflow vs %s\n",
-			         me->name, strtab + sym->st_name);
+			         "module %s: Relocation (type %lu) overflow vs %s\n",
+			         me->name, r_type, strtab + sym->st_name);
 			return -ENOEXEC;
 		}
 	}
diff -Naurp a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
--- a/arch/alpha/kernel/sys_noritake.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/sys_noritake.c	2007-02-20 17:22:27.000000000 -0500
@@ -66,6 +66,13 @@ noritake_startup_irq(unsigned int irq)
 	return 0;
 }
 
+static void
+noritake_end_irq(unsigned int irq)
+{
+        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+                noritake_enable_irq(irq);
+}
+
 static struct hw_interrupt_type noritake_irq_type = {
 	.typename	= "NORITAKE",
 	.startup	= noritake_startup_irq,
@@ -73,7 +80,7 @@ static struct hw_interrupt_type noritake
 	.enable		= noritake_enable_irq,
 	.disable	= noritake_disable_irq,
 	.ack		= noritake_disable_irq,
-	.end		= noritake_enable_irq,
+	.end		= noritake_end_irq,
 };
 
 static void 
diff -Naurp a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
--- a/arch/alpha/kernel/sys_rawhide.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/sys_rawhide.c	2007-02-14 14:40:02.000000000 -0500
@@ -52,6 +52,9 @@ rawhide_update_irq_hw(int hose, int mask
 	*(vuip)MCPCIA_INT_MASK0(MCPCIA_HOSE2MID(hose));
 }
 
+#define hose_exists(h) \
+  (((h) < MCPCIA_MAX_HOSES) && (cached_irq_masks[(h)] != 0))
+
 static inline void 
 rawhide_enable_irq(unsigned int irq)
 {
@@ -59,6 +62,9 @@ rawhide_enable_irq(unsigned int irq)
 
 	irq -= 16;
 	hose = irq / 24;
+	if (!hose_exists(hose)) /* if hose non-existent, exit */
+		return;
+
 	irq -= hose * 24;
 	mask = 1 << irq;
 
@@ -76,6 +82,9 @@ rawhide_disable_irq(unsigned int irq)
 
 	irq -= 16;
 	hose = irq / 24;
+	if (!hose_exists(hose)) /* if hose non-existent, exit */
+		return;
+
 	irq -= hose * 24;
 	mask = ~(1 << irq) | hose_irq_masks[hose];
 
@@ -93,6 +102,9 @@ rawhide_mask_and_ack_irq(unsigned int ir
 
 	irq -= 16;
 	hose = irq / 24;
+	if (!hose_exists(hose)) /* if hose non-existent, exit */
+		return;
+
 	irq -= hose * 24;
 	mask1 = 1 << irq;
 	mask = ~mask1 | hose_irq_masks[hose];
@@ -169,6 +181,9 @@ rawhide_init_irq(void)
 
 	mcpcia_init_hoses();
 
+	/* Clear them all; only hoses that exist will be non-zero. */
+	for (i = 0; i < MCPCIA_MAX_HOSES; i++) cached_irq_masks[i] = 0;
+
 	for (hose = hose_head; hose; hose = hose->next) {
 		unsigned int h = hose->index;
 		unsigned int mask = hose_irq_masks[h];
diff -Naurp a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
--- a/arch/alpha/kernel/sys_sio.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/sys_sio.c	2007-02-14 14:40:02.000000000 -0500
@@ -84,12 +84,16 @@ alphabook1_init_arch(void)
 static void __init
 sio_pci_route(void)
 {
-#if defined(ALPHA_RESTORE_SRM_SETUP)
-	/* First, read and save the original setting. */
+	unsigned int orig_route_tab;
+
+	/* First, ALWAYS read and print the original setting. */
 	pci_bus_read_config_dword(pci_isa_hose->bus, PCI_DEVFN(7, 0), 0x60,
-				  &saved_config.orig_route_tab);
+				  &orig_route_tab);
 	printk("%s: PIRQ original 0x%x new 0x%x\n", __FUNCTION__,
-	       saved_config.orig_route_tab, alpha_mv.sys.sio.route_tab);
+	       orig_route_tab, alpha_mv.sys.sio.route_tab);
+
+#if defined(ALPHA_RESTORE_SRM_SETUP)
+	saved_config.orig_route_tab = orig_route_tab;
 #endif
 
 	/* Now override with desired setting. */
@@ -334,7 +338,7 @@ struct alpha_machine_vector avanti_mv __
 	.pci_swizzle		= common_swizzle,
 
 	.sys = { .sio = {
-		.route_tab	= 0x0b0a0e0f,
+		.route_tab	= 0x0b0a050f, /* leave 14 for IDE, 9 for SND */
 	}}
 };
 ALIAS_MV(avanti)
diff -Naurp a/include/asm-alpha/core_mcpcia.h b/include/asm-alpha/core_mcpcia.h
--- a/include/asm-alpha/core_mcpcia.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/core_mcpcia.h	2007-02-14 14:40:02.000000000 -0500
@@ -72,6 +72,8 @@
  *
  */
 
+#define MCPCIA_MAX_HOSES 4
+
 #define MCPCIA_MID(m)		((unsigned long)(m) << 33)
 
 /* Dodge has PCI0 and PCI1 at MID 4 and 5 respectively. 
diff -Naurp a/include/asm-alpha/io.h b/include/asm-alpha/io.h
--- a/include/asm-alpha/io.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/io.h	2007-03-19 14:33:58.000000000 -0400
@@ -113,6 +113,7 @@ static inline unsigned long virt_to_bus(
 	unsigned long bus = phys + __direct_map_base;
 	return phys <= __direct_map_size ? bus : 0;
 }
+#define isa_virt_to_bus virt_to_bus
 
 static inline void *bus_to_virt(unsigned long address)
 {
