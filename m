Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbXDOVbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbXDOVbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXDOVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:31:41 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:60155 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbXDOVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:31:40 -0400
Message-ID: <46229868.7050709@hp.com>
Date: Sun, 15 Apr 2007 17:26:00 -0400
From: Jay Estabrook <jay.estabrook@hp.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: support graphics on non-zero PCI domains (take
 2)
References: <20070415111937.A12310@jurassic.park.msu.ru> <20070415090115.GA18103@uranus.ravnborg.org> <20070415152222.A12703@jurassic.park.msu.ru> <20070415123020.GA19688@uranus.ravnborg.org>
In-Reply-To: <20070415123020.GA19688@uranus.ravnborg.org>
Content-Type: multipart/mixed;
 boundary="------------000209040200030100050206"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000209040200030100050206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sam Ravnborg wrote:
>>>> +#ifndef CONFIG_ALPHA_GENERIC
>>>> +EXPORT_SYMBOL(tsunami_ioportmap);
>>>> +EXPORT_SYMBOL(tsunami_ioremap);
>>>> +#endif
>>> It looks strange that the function is always defined but conditionally exported.
>>> Also usual style is to place EXPORT right after closing brace of function -
>>> (with no empty lines in-between).
>> In a generic kernel the IO functions are never addressed directly,
>> only via machine vector, so there is no point in exporting them.
>> What about something like EXPORT_SYMBOL_NONGENERIC() macro?
> As I wrote it looked strange. Unconditionally exporting them should not harm
> and then we are one pair of ifdef/endif shorter?
> 
> Nitty gritty detail so do what you think match best.
> 
> 	Sam

Thanks for all the feedback, Sam.

Find attached a reworked set of patches that I think cleans up all the
areas with which you had issues.

Sorry about putting it into an attachment, I've yet to figure out out
to do the verbatim inclusion of patch text into Thunderbird without
adverse side effects... :-(

Thanks again.

--Jay++

-- 
Jay A Estabrook                            HPTC - XC I & B
Hewlett-Packard Company - ZKO1-3/D-B.8     (603) 884-0301
110 Spit Brook Road, Nashua NH 03062       Jay.Estabrook@hp.com

--------------000209040200030100050206
Content-Type: text/plain;
 name="diffs-vga-20070415-1709"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diffs-vga-20070415-1709"

diff -Naurp a/arch/alpha/Kconfig c/arch/alpha/Kconfig
--- a/arch/alpha/Kconfig	2007-04-02 13:03:21.000000000 -0400
+++ c/arch/alpha/Kconfig	2007-04-15 14:03:24.000000000 -0400
@@ -481,6 +481,15 @@ config ALPHA_BROKEN_IRQ_MASK
 	depends on ALPHA_GENERIC || ALPHA_PC164
 	default y
 
+config VGA_HOSE
+	bool
+	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL || ALPHA_TSUNAMI
+	default y
+	help
+	  Support VGA on an arbitrary hose; needed for several platforms
+	  which always have multiple hoses, and whose consoles support it.
+	   
+
 config ALPHA_SRM
 	bool "Use SRM as bootloader" if ALPHA_CABRIOLET || ALPHA_AVANTI_CH || ALPHA_EB64P || ALPHA_PC164 || ALPHA_TAKARA || ALPHA_EB164 || ALPHA_ALCOR || ALPHA_MIATA || ALPHA_LX164 || ALPHA_SX164 || ALPHA_NAUTILUS || ALPHA_NONAME
 	default y if ALPHA_JENSEN || ALPHA_MIKASA || ALPHA_SABLE || ALPHA_LYNX || ALPHA_NORITAKE || ALPHA_DP264 || ALPHA_RAWHIDE || ALPHA_EIGER || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_SHARK || ALPHA_MARVEL
@@ -644,6 +653,13 @@ source "arch/alpha/oprofile/Kconfig"
 
 source "arch/alpha/Kconfig.debug"
 
+# DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
+# but we also need it if VGA_HOSE is set
+config DUMMY_CONSOLE
+	bool
+	depends on VGA_HOSE
+	default y
+
 source "security/Kconfig"
 
 source "crypto/Kconfig"
diff -Naurp a/arch/alpha/kernel/console.c c/arch/alpha/kernel/console.c
--- a/arch/alpha/kernel/console.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/console.c	2007-04-15 12:27:37.000000000 -0400
@@ -9,16 +9,20 @@
 #include <linux/init.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/vt.h>
 #include <asm/vga.h>
 #include <asm/machvec.h>
 
+#include "pci_impl.h"
+
 #ifdef CONFIG_VGA_HOSE
 
-/*
- * Externally-visible vga hose bases
- */
-unsigned long __vga_hose_io_base = 0;	/* base for default hose */
-unsigned long __vga_hose_mem_base = 0;	/* base for default hose */
+struct pci_controller *pci_vga_hose = NULL;
+static struct resource alpha_vga = {
+	.name	= "alpha-vga+",
+	.start	= 0x3C0,
+	.end	= 0x3DF
+};
 
 static struct pci_controller * __init 
 default_vga_hose_select(struct pci_controller *h1, struct pci_controller *h2)
@@ -30,36 +34,58 @@ default_vga_hose_select(struct pci_contr
 }
 
 void __init 
-set_vga_hose(struct pci_controller *hose)
-{
-	if (hose) {
-		__vga_hose_io_base = hose->io_space->start;
-		__vga_hose_mem_base = hose->mem_space->start;
-	}
-}
-
-void __init 
 locate_and_init_vga(void *(*sel_func)(void *, void *))
 {
 	struct pci_controller *hose = NULL;
 	struct pci_dev *dev = NULL;
 
+	/* Default the select function */
 	if (!sel_func) sel_func = (void *)default_vga_hose_select;
 
+	/* Find the console VGA device */
 	for(dev=NULL; (dev=pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, dev));) {
-		if (!hose) hose = dev->sysdata;
-		else hose = sel_func(hose, dev->sysdata);
+		if (!hose)
+			hose = dev->sysdata;
+		else
+			hose = sel_func(hose, dev->sysdata);
 	}
 
-	/* Did we already inititialize the correct one? */
-	if (conswitchp == &vga_con &&
-	    __vga_hose_io_base == hose->io_space->start &&
-	    __vga_hose_mem_base == hose->mem_space->start)
+	/* Did we already initialize the correct one? Is there one? */
+	if (!hose || (conswitchp == &vga_con && pci_vga_hose == hose))
 		return;
 
-	/* Set the VGA hose and init the new console */
-	set_vga_hose(hose);
+	/* Create a new VGA ioport resource WRT the hose it is on. */
+	alpha_vga.start += hose->io_space->start;
+	alpha_vga.end += hose->io_space->start;
+	request_resource(hose->io_space, &alpha_vga);
+
+	/* Set the VGA hose and init the new console. */
+	pci_vga_hose = hose;
 	take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
 }
 
+void __init
+find_console_vga_hose(void)
+{
+	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
+
+	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
+		struct pci_controller *hose;
+		int h = (pu64[30] >> 24) & 0xff;	/* console hose # */
+
+		/*
+		 * Our hose numbering DOES match the console's, so find
+		 * the right one...
+		 */
+		for (hose = hose_head; hose; hose = hose->next) {
+			if (hose->index == h) break;
+		}
+
+		if (hose) {
+			printk("Console graphics on hose %d\n", h);
+			pci_vga_hose = hose;
+		}
+	}
+}
+
 #endif
diff -Naurp a/arch/alpha/kernel/core_marvel.c c/arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/core_marvel.c	2007-04-15 13:33:31.000000000 -0400
@@ -25,6 +25,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/rtc.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "pci_impl.h"
@@ -366,10 +367,10 @@ marvel_io7_present(gct6_node *node)
 	alloc_io7(pe);
 }
 
+#ifdef CONFIG_VGA_HOSE
 static void __init
-marvel_init_vga_hose(void)
+marvel_find_console_vga_hose(void)
 {
-#ifdef CONFIG_VGA_HOSE
 	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
 
 	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
@@ -403,8 +404,10 @@ marvel_init_vga_hose(void)
 			pci_vga_hose = hose;
 		}
 	}
-#endif /* CONFIG_VGA_HOSE */
 }
+#else /* CONFIG_VGA_HOSE */
+# define marvel_find_console_vga_hose()             do { } while (0)
+#endif /* CONFIG_VGA_HOSE */
 
 gct6_search_struct gct_wanted_node_list[] = {
 	{ GCT_TYPE_HOSE, GCT_SUBTYPE_IO_PORT_MODULE, marvel_io7_present },
@@ -459,7 +462,7 @@ marvel_init_arch(void)
 		marvel_init_io7(io7);
 
 	/* Check for graphic console location (if any).  */
-	marvel_init_vga_hose();
+	marvel_find_console_vga_hose();
 }
 
 void
@@ -684,9 +687,6 @@ __marvel_rtc_io(u8 b, unsigned long addr
 /*
  * IO map support.
  */
-
-#define __marvel_is_mem_vga(a)	(((a) >= 0xa0000) && ((a) <= 0xc0000))
-
 void __iomem *
 marvel_ioremap(unsigned long addr, unsigned long size)
 {
@@ -698,13 +698,9 @@ marvel_ioremap(unsigned long addr, unsig
 	unsigned long pfn;
 
 	/*
-	 * Adjust the addr.
+	 * Adjust the address.
 	 */ 
-#ifdef CONFIG_VGA_HOSE
-	if (pci_vga_hose && __marvel_is_mem_vga(addr)) {
-		addr += pci_vga_hose->mem_space->start;
-	}
-#endif
+	FIXUP_MEMADDR_VGA(addr);
 
 	/*
 	 * Find the hose.
@@ -781,7 +777,9 @@ marvel_ioremap(unsigned long addr, unsig
 		return (void __iomem *) vaddr;
 	}
 
-	return NULL;
+	/* Assume it was already a reasonable address */
+	vaddr = baddr + hose->mem_space->start;
+	return (void __iomem *) vaddr;
 }
 
 void
@@ -803,21 +801,12 @@ marvel_is_mmio(const volatile void __iom
 		return (addr & 0xFF000000UL) == 0;
 }
 
-#define __marvel_is_port_vga(a)	\
-  (((a) >= 0x3b0) && ((a) < 0x3e0) && ((a) != 0x3b3) && ((a) != 0x3d3))
 #define __marvel_is_port_kbd(a)	(((a) == 0x60) || ((a) == 0x64))
 #define __marvel_is_port_rtc(a)	(((a) == 0x70) || ((a) == 0x71))
 
 void __iomem *marvel_ioportmap (unsigned long addr)
 {
-	if (__marvel_is_port_rtc (addr) || __marvel_is_port_kbd(addr))
-		;
-#ifdef CONFIG_VGA_HOSE
-	else if (__marvel_is_port_vga (addr) && pci_vga_hose)
-		addr += pci_vga_hose->io_space->start;
-#endif
-	else
-		return NULL;
+	FIXUP_IOADDR_VGA(addr);
 	return (void __iomem *)addr;
 }
 
@@ -829,8 +818,14 @@ marvel_ioread8(void __iomem *xaddr)
 		return 0;
 	else if (__marvel_is_port_rtc(addr))
 		return __marvel_rtc_io(0, addr, 0);
-	else
+	else if (marvel_is_ioaddr(addr))
 		return __kernel_ldbu(*(vucp)addr);
+	else
+		/* this should catch other legacy addresses
+		   that would normally fail on MARVEL,
+		   because there really is nothing there...
+		*/
+		return ~0;
 }
 
 void
@@ -841,7 +836,7 @@ marvel_iowrite8(u8 b, void __iomem *xadd
 		return;
 	else if (__marvel_is_port_rtc(addr)) 
 		__marvel_rtc_io(b, addr, 1);
-	else
+	else if (marvel_is_ioaddr(addr))
 		__kernel_stb(b, *(vucp)addr);
 }
 
diff -Naurp a/arch/alpha/kernel/core_titan.c c/arch/alpha/kernel/core_titan.c
--- a/arch/alpha/kernel/core_titan.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/core_titan.c	2007-04-15 12:28:32.000000000 -0400
@@ -21,6 +21,7 @@
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "pci_impl.h"
@@ -35,6 +36,11 @@ struct
 } saved_config[4] __attribute__((common));
 
 /*
+ * Is PChip 1 present? No need to query it more than once.
+ */
+static int titan_pchip1_present;
+
+/*
  * BIOS32-style PCI interface:
  */
 
@@ -344,43 +350,17 @@ titan_init_one_pachip_port(titan_pachip_
 static void __init
 titan_init_pachips(titan_pachip *pachip0, titan_pachip *pachip1)
 {
-	int pchip1_present = TITAN_cchip->csc.csr & 1L<<14;
+	titan_pchip1_present = TITAN_cchip->csc.csr & 1L<<14;
 
 	/* Init the ports in hose order... */
 	titan_init_one_pachip_port(&pachip0->g_port, 0);	/* hose 0 */
-	if (pchip1_present)
+	if (titan_pchip1_present)
 		titan_init_one_pachip_port(&pachip1->g_port, 1);/* hose 1 */
 	titan_init_one_pachip_port(&pachip0->a_port, 2);	/* hose 2 */
-	if (pchip1_present)
+	if (titan_pchip1_present)
 		titan_init_one_pachip_port(&pachip1->a_port, 3);/* hose 3 */
 }
 
-static void __init
-titan_init_vga_hose(void)
-{
-#ifdef CONFIG_VGA_HOSE
-	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
-
-	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
-		struct pci_controller *hose;
-		int h = (pu64[30] >> 24) & 0xff;	/* console hose # */
-
-		/*
-		 * Our hose numbering matches the console's, so just find
-		 * the right one...
-		 */
-		for (hose = hose_head; hose; hose = hose->next) {
-			if (hose->index == h) break;
-		}
-
-		if (hose) {
-			printk("Console graphics on hose %d\n", hose->index);
-			pci_vga_hose = hose;
-		}
-	}
-#endif /* CONFIG_VGA_HOSE */
-}
-
 void __init
 titan_init_arch(void)
 {
@@ -406,6 +386,7 @@ titan_init_arch(void)
 
 	/* With multiple PCI busses, we play with I/O as physical addrs.  */
 	ioport_resource.end = ~0UL;
+	iomem_resource.end = ~0UL;
 
 	/* PCI DMA Direct Mapping is 1GB at 2GB.  */
 	__direct_map_base = 0x80000000;
@@ -415,7 +396,7 @@ titan_init_arch(void)
 	titan_init_pachips(TITAN_pachip0, TITAN_pachip1);
 
 	/* Check for graphic console location (if any).  */
-	titan_init_vga_hose();
+	find_console_vga_hose();
 }
 
 static void
@@ -441,9 +422,7 @@ titan_kill_one_pachip_port(titan_pachip_
 static void
 titan_kill_pachips(titan_pachip *pachip0, titan_pachip *pachip1)
 {
-	int pchip1_present = TITAN_cchip->csc.csr & 1L<<14;
-
-	if (pchip1_present) {
+	if (titan_pchip1_present) {
 		titan_kill_one_pachip_port(&pachip1->g_port, 1);
 		titan_kill_one_pachip_port(&pachip1->a_port, 3);
 	}
@@ -463,6 +442,14 @@ titan_kill_arch(int mode)
  */
 
 void __iomem *
+titan_ioportmap(unsigned long addr)
+{
+	FIXUP_IOADDR_VGA(addr);
+	return (void __iomem *)(addr + TITAN_IO_BIAS);
+}
+
+
+void __iomem *
 titan_ioremap(unsigned long addr, unsigned long size)
 {
 	int h = (addr & TITAN_HOSE_MASK) >> TITAN_HOSE_SHIFT;
@@ -475,14 +462,12 @@ titan_ioremap(unsigned long addr, unsign
 	unsigned long pfn;
 
 	/*
-	 * Adjust the addr.
+	 * Adjust the address and hose, if necessary.
 	 */ 
-#ifdef CONFIG_VGA_HOSE
-	if (pci_vga_hose && __titan_is_mem_vga(addr)) {
+	if (pci_vga_hose && __is_mem_vga(addr)) {
 		h = pci_vga_hose->index;
 		addr += pci_vga_hose->mem_space->start;
 	}
-#endif
 
 	/*
 	 * Find the hose.
@@ -521,8 +506,10 @@ titan_ioremap(unsigned long addr, unsign
 		 * Map it
 		 */
 		area = get_vm_area(size, VM_IOREMAP);
-		if (!area)
+		if (!area) {
+			printk("ioremap failed... no vm_area...\n");
 			return NULL;
+		}
 
 		ptes = hose->sg_pci->ptes;
 		for (vaddr = (unsigned long)area->addr; 
@@ -539,7 +526,7 @@ titan_ioremap(unsigned long addr, unsign
 			if (__alpha_remap_area_pages(vaddr,
 						     pfn << PAGE_SHIFT, 
 						     PAGE_SIZE, 0)) {
-				printk("FAILED to map...\n");
+				printk("FAILED to remap_area_pages...\n");
 				vfree(area->addr);
 				return NULL;
 			}
@@ -551,7 +538,8 @@ titan_ioremap(unsigned long addr, unsign
 		return (void __iomem *) vaddr;
 	}
 
-	return NULL;
+	/* Assume a legacy (read: VGA) address, and return appropriately. */
+	return (void __iomem *)(addr + TITAN_MEM_BIAS);
 }
 
 void
@@ -574,6 +562,7 @@ titan_is_mmio(const volatile void __iome
 }
 
 #ifndef CONFIG_ALPHA_GENERIC
+EXPORT_SYMBOL(titan_ioportmap);
 EXPORT_SYMBOL(titan_ioremap);
 EXPORT_SYMBOL(titan_iounmap);
 EXPORT_SYMBOL(titan_is_mmio);
@@ -750,6 +739,7 @@ titan_agp_info(void)
 	if (titan_query_agp(port))
 		hosenum = 2;
 	if (hosenum < 0 && 
+	    titan_pchip1_present &&
 	    titan_query_agp(port = &TITAN_pachip1->a_port)) 
 		hosenum = 3;
 	
diff -Naurp a/arch/alpha/kernel/core_tsunami.c c/arch/alpha/kernel/core_tsunami.c
--- a/arch/alpha/kernel/core_tsunami.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/core_tsunami.c	2007-04-15 12:28:48.000000000 -0400
@@ -19,6 +19,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/smp.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "pci_impl.h"
@@ -349,6 +350,26 @@ tsunami_init_one_pchip(tsunami_pchip *pc
 	tsunami_pci_tbi(hose, 0, -1);
 }
 
+
+void __iomem *
+tsunami_ioportmap(unsigned long addr)
+{
+	FIXUP_IOADDR_VGA(addr);
+	return (void __iomem *)(addr + TSUNAMI_IO_BIAS);
+}
+
+void __iomem *
+tsunami_ioremap(unsigned long addr, unsigned long size)
+{
+	FIXUP_MEMADDR_VGA(addr);
+	return (void __iomem *)(addr + TSUNAMI_MEM_BIAS);
+}
+
+#ifndef CONFIG_ALPHA_GENERIC
+EXPORT_SYMBOL(tsunami_ioportmap);
+EXPORT_SYMBOL(tsunami_ioremap);
+#endif
+
 void __init
 tsunami_init_arch(void)
 {
@@ -393,6 +414,9 @@ tsunami_init_arch(void)
 	tsunami_init_one_pchip(TSUNAMI_pchip0, 0);
 	if (TSUNAMI_cchip->csc.csr & 1L<<14)
 		tsunami_init_one_pchip(TSUNAMI_pchip1, 1);
+
+	/* Check for graphic console location (if any).  */
+	find_console_vga_hose();
 }
 
 static void
diff -Naurp a/arch/alpha/kernel/sys_dp264.c c/arch/alpha/kernel/sys_dp264.c
--- a/arch/alpha/kernel/sys_dp264.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/sys_dp264.c	2007-04-15 14:11:17.000000000 -0400
@@ -30,6 +30,7 @@
 #include <asm/core_tsunami.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "irq_impl.h"
@@ -543,6 +544,7 @@ dp264_init_pci(void)
 {
 	common_init_pci();
 	SMC669_Init(0);
+	locate_and_init_vga(NULL);
 }
 
 static void __init
@@ -551,6 +553,14 @@ monet_init_pci(void)
 	common_init_pci();
 	SMC669_Init(1);
 	es1888_init();
+	locate_and_init_vga(NULL);
+}
+
+static void __init
+clipper_init_pci(void)
+{
+	common_init_pci();
+	locate_and_init_vga(NULL);
 }
 
 static void __init
@@ -655,7 +665,7 @@ struct alpha_machine_vector clipper_mv _
 	.init_arch		= tsunami_init_arch,
 	.init_irq		= clipper_init_irq,
 	.init_rtc		= common_init_rtc,
-	.init_pci		= common_init_pci,
+	.init_pci		= clipper_init_pci,
 	.kill_arch		= tsunami_kill_arch,
 	.pci_map_irq		= clipper_map_irq,
 	.pci_swizzle		= common_swizzle,
diff -Naurp a/arch/alpha/kernel/sys_marvel.c c/arch/alpha/kernel/sys_marvel.c
--- a/arch/alpha/kernel/sys_marvel.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/sys_marvel.c	2007-04-15 14:29:53.000000000 -0400
@@ -22,6 +22,7 @@
 #include <asm/core_marvel.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "err_impl.h"
@@ -412,10 +413,7 @@ marvel_init_pci(void)
 
 	pci_probe_only = 1;
 	common_init_pci();
-
-#ifdef CONFIG_VGA_HOSE
 	locate_and_init_vga(NULL);
-#endif
 
 	/* Clear any io7 errors.  */
 	for (io7 = NULL; (io7 = marvel_next_io7(io7)) != NULL; ) 
diff -Naurp a/arch/alpha/kernel/sys_titan.c c/arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c	2007-02-04 13:44:54.000000000 -0500
+++ c/arch/alpha/kernel/sys_titan.c	2007-04-15 14:29:08.000000000 -0400
@@ -30,6 +30,7 @@
 #include <asm/core_titan.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "irq_impl.h"
@@ -332,9 +333,7 @@ titan_init_pci(void)
 	pci_probe_only = 1;
 	common_init_pci();
 	SMC669_Init(0);
-#ifdef CONFIG_VGA_HOSE
 	locate_and_init_vga(NULL);
-#endif
 }
 
 
diff -Naurp a/include/asm-alpha/core_titan.h c/include/asm-alpha/core_titan.h
--- a/include/asm-alpha/core_titan.h	2007-02-04 13:44:54.000000000 -0500
+++ c/include/asm-alpha/core_titan.h	2007-04-15 11:32:58.000000000 -0400
@@ -380,12 +380,7 @@ struct el_PRIVATEER_envdata_mcheck {
 /*
  * Memory functions.  all accesses are done through linear space.
  */
-
-__EXTERN_INLINE void __iomem *titan_ioportmap(unsigned long addr)
-{
-	return (void __iomem *)(addr + TITAN_IO_BIAS);
-}
-
+extern void __iomem *titan_ioportmap(unsigned long addr);
 extern void __iomem *titan_ioremap(unsigned long addr, unsigned long size);
 extern void titan_iounmap(volatile void __iomem *addr);
 
diff -Naurp a/include/asm-alpha/core_tsunami.h c/include/asm-alpha/core_tsunami.h
--- a/include/asm-alpha/core_tsunami.h	2007-02-04 13:44:54.000000000 -0500
+++ c/include/asm-alpha/core_tsunami.h	2007-04-15 11:32:58.000000000 -0400
@@ -2,6 +2,7 @@
 #define __ALPHA_TSUNAMI__H__
 
 #include <linux/types.h>
+#include <linux/pci.h>
 #include <asm/compiler.h>
 
 /*
@@ -302,18 +303,8 @@ struct el_TSUNAMI_sysdata_mcheck {
 /*
  * Memory functions.  all accesses are done through linear space.
  */
-
-__EXTERN_INLINE void __iomem *tsunami_ioportmap(unsigned long addr)
-{
-	return (void __iomem *)(addr + TSUNAMI_IO_BIAS);
-}
-
-__EXTERN_INLINE void __iomem *tsunami_ioremap(unsigned long addr, 
-					      unsigned long size)
-{
-	return (void __iomem *)(addr + TSUNAMI_MEM_BIAS);
-}
-
+extern void __iomem *tsunami_ioportmap(unsigned long addr);
+extern void __iomem *tsunami_ioremap(unsigned long addr, unsigned long size);
 __EXTERN_INLINE int tsunami_is_ioaddr(unsigned long addr)
 {
 	return addr >= TSUNAMI_BASE;
diff -Naurp a/include/asm-alpha/vga.h c/include/asm-alpha/vga.h
--- a/include/asm-alpha/vga.h	2007-02-04 13:44:54.000000000 -0500
+++ c/include/asm-alpha/vga.h	2007-04-15 12:28:03.000000000 -0400
@@ -46,6 +46,42 @@ extern void scr_memcpyw(u16 *d, const u1
 #define vga_readb(a)	readb((u8 __iomem *)(a))
 #define vga_writeb(v,a)	writeb(v, (u8 __iomem *)(a))
 
+#ifdef CONFIG_VGA_HOSE
+#include <linux/ioport.h>
+#include <linux/pci.h>
+
+extern struct pci_controller *pci_vga_hose;
+ 
+# define __is_port_vga(a)       \
+	(((a) >= 0x3b0) && ((a) < 0x3e0) && \
+	 ((a) != 0x3b3) && ((a) != 0x3d3))
+
+# define __is_mem_vga(a) \
+	(((a) >= 0xa0000) && ((a) <= 0xc0000))
+
+# define FIXUP_IOADDR_VGA(a) do {                       \
+	if (pci_vga_hose && __is_port_vga(a))     \
+		a += pci_vga_hose->io_space->start;     \
+ } while(0)
+
+# define FIXUP_MEMADDR_VGA(a) do {                       \
+	if (pci_vga_hose && __is_mem_vga(a))     \
+		(a) += pci_vga_hose->mem_space->start; \
+ } while(0)
+
+extern void find_console_vga_hose(void);
+extern void locate_and_init_vga(void *(*)(void *, void *));
+
+#else /* CONFIG_VGA_HOSE */
+# define pci_vga_hose 0
+# define __is_port_vga(a) 0
+# define __is_mem_vga(a) 0
+# define FIXUP_IOADDR_VGA(a)
+# define FIXUP_MEMADDR_VGA(a)
+# define find_console_vga_hose()  do { } while (0)
+# define locate_and_init_vga()	do { } while (0)
+#endif /* CONFIG_VGA_HOSE */
+
 #define VGA_MAP_MEM(x,s)	((unsigned long) ioremap(x, s))
 
 #endif

--------------000209040200030100050206--
