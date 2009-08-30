Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZH3NF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZH3NF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbZH3NFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:05:55 -0400
Received: from www.tglx.de ([62.245.132.106]:56895 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbZH3NFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:05:54 -0400
Message-Id: <20090830122528.727735101@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:05:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 4/4] x86: Add pci subarch init to x86_init
References: <20090830122225.608718729@linutronix.de>
Content-Disposition: inline; filename=x86-add-pci-subarch-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the #ifdef'ed olpc specific init function by a conditional
x86_init function. This hook is also helpful for the upcoming
Moorestown support.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/olpc.h     |   20 ++------------------
 arch/x86/include/asm/pci_x86.h  |    1 -
 arch/x86/include/asm/x86_init.h |    4 +++-
 arch/x86/kernel/olpc.c          |    8 +++++---
 arch/x86/pci/init.c             |    7 +++----
 arch/x86/pci/olpc.c             |    3 ---
 6 files changed, 13 insertions(+), 30 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/olpc.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/olpc.h
+++ linux-2.6-tip/arch/x86/include/asm/olpc.h
@@ -13,7 +13,6 @@ struct olpc_platform_t {
 
 #define OLPC_F_PRESENT		0x01
 #define OLPC_F_DCON		0x02
-#define OLPC_F_VSA		0x04
 
 #ifdef CONFIG_OLPC
 
@@ -51,18 +50,6 @@ static inline int olpc_has_dcon(void)
 }
 
 /*
- * The VSA is software from AMD that typical Geode bioses will include.
- * It is used to emulate the PCI bus, VGA, etc.  OLPC's Open Firmware does
- * not include the VSA; instead, PCI is emulated by the kernel.
- *
- * The VSA is described further in arch/x86/pci/olpc.c.
- */
-static inline int olpc_has_vsa(void)
-{
-	return (olpc_platform_info.flags & OLPC_F_VSA) ? 1 : 0;
-}
-
-/*
  * The "Mass Production" version of OLPC's XO is identified as being model
  * C2.  During the prototype phase, the following models (in chronological
  * order) were created: A1, B1, B2, B3, B4, C1.  The A1 through B2 models
@@ -87,13 +74,10 @@ static inline int olpc_has_dcon(void)
 	return 0;
 }
 
-static inline int olpc_has_vsa(void)
-{
-	return 0;
-}
-
 #endif
 
+extern int pci_olpc_init(void);
+
 /* EC related functions */
 
 extern int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
Index: linux-2.6-tip/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/pci_x86.h
+++ linux-2.6-tip/arch/x86/include/asm/pci_x86.h
@@ -104,7 +104,6 @@ extern bool port_cf9_safe;
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern int pci_olpc_init(void);
 extern void __init dmi_check_pciprobe(void);
 extern void __init dmi_check_skip_isa_align(void);
 
Index: linux-2.6-tip/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6-tip/arch/x86/include/asm/x86_init.h
@@ -93,11 +93,13 @@ struct x86_init_timers {
 
 /**
  * struct x86_init_pci - platform specific pci init functions
- * @init:			platform specific pci init
+ * @arch_init:			platform specific pci arch init call
+ * @init:			platform specific pci subsystem init
  * @init_irq:			platform specific pci irq init
  * @fixup_irqs:			platform specific pci irq fixup
  */
 struct x86_init_pci {
+	int (*arch_init)(void);
 	int (*init)(void);
 	void (*init_irq)(void);
 	void (*fixup_irqs)(void);
Index: linux-2.6-tip/arch/x86/kernel/olpc.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/olpc.c
+++ linux-2.6-tip/arch/x86/kernel/olpc.c
@@ -17,6 +17,8 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/string.h>
+
+#include <asm/setup.h>
 #include <asm/geode.h>
 #include <asm/olpc.h>
 
@@ -243,9 +245,9 @@ static int __init olpc_init(void)
 	olpc_ec_cmd(EC_FIRMWARE_REV, NULL, 0,
 			(unsigned char *) &olpc_platform_info.ecver, 1);
 
-	/* check to see if the VSA exists */
-	if (geode_has_vsa2())
-		olpc_platform_info.flags |= OLPC_F_VSA;
+	/* If the VSA exists let it emulate PCI, if not emulate in kernel */
+	if (!geode_has_vsa2())
+		x86_init.pci.arch_init = pci_olpc_init;
 
 	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
 			((olpc_platform_info.boardrev & 0xf) < 8) ? "pre" : "",
Index: linux-2.6-tip/arch/x86/pci/init.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/init.c
+++ linux-2.6-tip/arch/x86/pci/init.c
@@ -15,10 +15,9 @@ static __init int pci_arch_init(void)
 	if (!(pci_probe & PCI_PROBE_NOEARLY))
 		pci_mmcfg_early_init();
 
-#ifdef CONFIG_PCI_OLPC
-	if (!pci_olpc_init())
-		return 0;	/* skip additional checks if it's an XO */
-#endif
+	if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
+		return 0;
+
 #ifdef CONFIG_PCI_BIOS
 	pci_pcbios_init();
 #endif
Index: linux-2.6-tip/arch/x86/pci/olpc.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/olpc.c
+++ linux-2.6-tip/arch/x86/pci/olpc.c
@@ -304,9 +304,6 @@ static struct pci_raw_ops pci_olpc_conf 
 
 int __init pci_olpc_init(void)
 {
-	if (!machine_is_olpc() || olpc_has_vsa())
-		return -ENODEV;
-
 	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();


