Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbXGAUYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbXGAUYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXGAUV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:21:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46859 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758945AbXGAUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:21:45 -0400
Date: Sun, 1 Jul 2007 22:22:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kumar Gala <galak@freescale.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: [RFC: 2.6 patch] ppc: remove APUS support
Message-ID: <20070701202206.GO10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current status of APUS:
- arch/powerpc/: a patch to remove it is in powerpc.git
- arch/ppc/: marked BROKEN since 2 years

This patch therefore removes the remaining parts of APUS support.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/m68k/amiga/chipram.c           |    2 
 arch/powerpc/kernel/setup_32.c      |    1 
 arch/ppc/Kconfig                    |  148 ----
 arch/ppc/Makefile                   |    1 
 arch/ppc/amiga/Makefile             |    8 
 arch/ppc/amiga/amiga_ksyms.c        |    1 
 arch/ppc/amiga/amiints.c            |  322 ---------
 arch/ppc/amiga/amisound.c           |    1 
 arch/ppc/amiga/bootinfo.c           |   78 --
 arch/ppc/amiga/chipram.c            |    1 
 arch/ppc/amiga/cia.c                |  176 -----
 arch/ppc/amiga/config.c             |  947 ----------------------------
 arch/ppc/amiga/ints.c               |  158 ----
 arch/ppc/amiga/pcmcia.c             |    1 
 arch/ppc/amiga/time.c               |   57 -
 arch/ppc/configs/apus_defconfig     |  920 ---------------------------
 arch/ppc/kernel/head.S              |  117 ---
 arch/ppc/kernel/ppc_ksyms.c         |    3 
 arch/ppc/kernel/setup.c             |    1 
 arch/ppc/mm/pgtable.c               |   38 -
 arch/ppc/platforms/Makefile         |    4 
 arch/ppc/platforms/apus_pci.c       |  207 ------
 arch/ppc/platforms/apus_pci.h       |   34 -
 arch/ppc/platforms/apus_setup.c     |  792 -----------------------
 drivers/ide/ide-probe.c             |    8 
 drivers/isdn/hisax/avm_pci.c        |    8 
 drivers/scsi/a2091.c                |    3 
 drivers/scsi/a3000.c                |    3 
 drivers/scsi/gvp11.c                |    3 
 drivers/scsi/oktagon_esp.c          |    2 
 drivers/scsi/oktagon_io.S           |   72 --
 drivers/video/console/fbcon.c       |    2 
 drivers/video/console/fonts.c       |    4 
 include/asm-m68k/pgtable.h          |    2 
 include/asm-powerpc/ide.h           |    2 
 include/asm-powerpc/reg.h           |    4 
 include/asm-ppc/amigahw.h           |   16 
 include/asm-ppc/amigaints.h         |  133 ---
 include/asm-ppc/amigappc.h          |   85 --
 include/asm-ppc/bootinfo.h          |    5 
 include/asm-ppc/io.h                |   48 -
 include/asm-ppc/machdep.h           |    4 
 include/asm-ppc/page.h              |   44 -
 include/asm-ppc/pgtable.h           |    8 
 sound/oss/dmasound/Kconfig          |    2 
 sound/oss/dmasound/dmasound_paula.c |    4 
 46 files changed, 24 insertions(+), 4456 deletions(-)

--- linux-2.6.22-rc6-mm1/arch/ppc/Kconfig.old	2007-06-30 00:50:49.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/Kconfig	2007-06-30 01:37:18.000000000 +0200
@@ -573,24 +573,9 @@ choice
 
 	  Select PReP if configuring for a PReP machine.
 
-	  Select Gemini if configuring for a Synergy Microsystems' Gemini
-	  series Single Board Computer.  More information is available at:
-	  <http://www.synergymicro.com/PressRel/97_10_15.html>.
-
-	  Select APUS if configuring for a PowerUP Amiga.  More information is
-	  available at: <http://linux-apus.sourceforge.net/>.
-
 config PPC_PREP
 	bool "PReP"
 
-config APUS
-	bool "Amiga-APUS"
-	depends on BROKEN
-	help
-	  Select APUS if configuring for a PowerUP Amiga.
-	  More information is available at:
-	  <http://linux-apus.sourceforge.net/>.
-
 config KATANA
 	bool "Artesyn-Katana"
 	help
@@ -1027,132 +1012,6 @@ config CMDLINE
 	  some command-line options at build time by entering them here.  In
 	  most cases you will need to specify the root device here.
 
-config AMIGA
-	bool
-	depends on APUS
-	default y
-	help
-	  This option enables support for the Amiga series of computers.
-
-config ZORRO
-	bool
-	depends on APUS
-	default y
-	help
-	  This enables support for the Zorro bus in the Amiga. If you have
-	  expansion cards in your Amiga that conform to the Amiga
-	  AutoConfig(tm) specification, say Y, otherwise N. Note that even
-	  expansion cards that do not fit in the Zorro slots but fit in e.g.
-	  the CPU slot may fall in this category, so you have to say Y to let
-	  Linux use these.
-
-config ABSTRACT_CONSOLE
-	bool
-	depends on APUS
-	default y
-
-config APUS_FAST_EXCEPT
-	bool
-	depends on APUS
-	default y
-
-config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support"
-	depends on APUS && EXPERIMENTAL
-	help
-	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
-	  600. If you intend to use pcmcia cards say Y; otherwise say N.
-
-config AMIGA_BUILTIN_SERIAL
-	tristate "Amiga builtin serial support"
-	depends on APUS
-	help
-	  If you want to use your Amiga's built-in serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config GVPIOEXT
-	tristate "GVP IO-Extender support"
-	depends on APUS
-	help
-	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
-	  Otherwise, say N.
-
-config GVPIOEXT_LP
-	tristate "GVP IO-Extender parallel printer support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable driving a printer from the parallel port on your
-	  GVP IO-Extender card, N otherwise.
-
-config GVPIOEXT_PLIP
-	tristate "GVP IO-Extender PLIP support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable doing IP over the parallel port on your GVP
-	  IO-Extender card, N otherwise.
-
-config MULTIFACE_III_TTY
-	tristate "Multiface Card III serial support"
-	depends on APUS
-	help
-	  If you want to use a Multiface III card's serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config A2232
-	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && APUS
-	---help---
-	  This option supports the 2232 7-port serial card shipped with the
-	  Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
-	  a max of 19,200 bps, the ports are served by a 6551 ACIA UART chip
-	  each, plus a 8520 CIA, and a master 6502 CPU and buffer as well. The
-	  ports were connected with 8 pin DIN connectors on the card bracket,
-	  for which 8 pin to DB25 adapters were supplied. The card also had
-	  jumpers internally to toggle various pinning configurations.
-
-	  This driver can be built as a module; but then "generic_serial"
-	  will also be built as a module. This has to be loaded before
-	  "ser_a2232". If you want to do this, answer M here.
-
-config WHIPPET_SERIAL
-	tristate "Hisoft Whippet PCMCIA serial support"
-	depends on AMIGA_PCMCIA
-	help
-	  HiSoft has a web page at <http://www.hisoft.co.uk/>, but there
-	  is no listing for the Whippet in their Amiga section.
-
-config APNE
-	tristate "PCMCIA NE2000 support"
-	depends on AMIGA_PCMCIA
-	help
-	  If you have a PCMCIA NE2000 compatible adapter, say Y.  Otherwise,
-	  say N.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called apne.
-
-config SERIAL_CONSOLE
-	bool "Support for serial port console"
-	depends on APUS && (AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y)
-
-config HEARTBEAT
-	bool "Use power LED as a heartbeat"
-	depends on APUS
-	help
-	  Use the power-on LED on your machine as a load meter.  The exact
-	  behavior is platform-dependent, but normally the flash frequency is
-	  a hyperbolic function of the 5-minute load average.
-
-config PROC_HARDWARE
-	bool "/proc/hardware support"
-	depends on APUS
-
-source "drivers/zorro/Kconfig"
-
 if !44x || BROKEN
 source kernel/power/Kconfig
 endif
@@ -1227,8 +1086,7 @@ config MCA
 
 config PCI
 	bool "PCI support" if 40x || CPM2 || 83xx || 85xx || PPC_MPC52xx
-	default y if !40x && !CPM2 && !8xx && !APUS && !83xx && !85xx
-	default PCI_PERMEDIA if !4xx && !CPM2 && !8xx && APUS
+	default y if !40x && !CPM2 && !8xx && !83xx && !85xx
 	default PCI_QSPAN if !4xx && !CPM2 && 8xx
 	help
 	  Find out whether your system includes a PCI bus. PCI is the name of
@@ -1282,10 +1140,6 @@ config 8260_PCI9_IDMA4
 
 endchoice
 
-config PCI_PERMEDIA
-	bool "PCI for Permedia2"
-	depends on !4xx && !8xx && APUS
-
 source "drivers/pci/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
--- linux-2.6.22-rc6-mm1/sound/oss/dmasound/Kconfig.old	2007-06-30 00:59:18.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/oss/dmasound/Kconfig	2007-06-30 00:59:31.000000000 +0200
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
 
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
-	depends on (AMIGA || APUS) && SOUND
+	depends on AMIGA && SOUND
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Amiga in Linux, answer
--- linux-2.6.22-rc6-mm1/arch/m68k/amiga/chipram.c.old	2007-06-30 01:01:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/m68k/amiga/chipram.c	2007-06-30 01:01:08.000000000 +0200
@@ -29,12 +29,10 @@ void __init amiga_chip_init(void)
     if (!AMIGAHW_PRESENT(CHIP_RAM))
 	return;
 
-#ifndef CONFIG_APUS_FAST_EXCEPT
     /*
      *  Remove the first 4 pages where PPC exception handlers will be located
      */
     amiga_chip_size -= 0x4000;
-#endif
     chipram_res.end = amiga_chip_size-1;
     request_resource(&iomem_resource, &chipram_res);
 
--- linux-2.6.22-rc6-mm1/arch/ppc/Makefile.old	2007-06-30 01:01:52.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/Makefile	2007-06-30 01:01:57.000000000 +0200
@@ -69,7 +69,6 @@ core-$(CONFIG_83xx)		+= arch/ppc/platfor
 core-$(CONFIG_85xx)		+= arch/ppc/platforms/85xx/
 core-$(CONFIG_MATH_EMULATION)	+= arch/powerpc/math-emu/
 core-$(CONFIG_XMON)		+= arch/ppc/xmon/
-core-$(CONFIG_APUS)		+= arch/ppc/amiga/
 drivers-$(CONFIG_8xx)		+= arch/ppc/8xx_io/
 drivers-$(CONFIG_4xx)		+= arch/ppc/4xx_io/
 drivers-$(CONFIG_CPM2)		+= arch/ppc/8260_io/
--- linux-2.6.22-rc6-mm1/arch/ppc/kernel/head.S.old	2007-06-30 01:03:15.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/kernel/head.S	2007-06-30 01:04:54.000000000 +0200
@@ -32,10 +32,6 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
 
-#ifdef CONFIG_APUS
-#include <asm/amigappc.h>
-#endif
-
 /* 601 only have IBAT; cr0.eq is set on 601 when using this macro */
 #define LOAD_BAT(n, reg, RA, RB)	\
 	/* see the comment for clear_bats() -- Cort */ \
@@ -128,14 +124,6 @@ __start:
  */
 	bl	early_init
 
-#ifdef CONFIG_APUS
-/* On APUS the __va/__pa constants need to be set to the correct
- * values before continuing.
- */
-	mr	r4,r30
-	bl	fix_mem_constants
-#endif /* CONFIG_APUS */
-
 /* Switch MMU off, clear BATs and flush TLB. At this point, r3 contains
  * the physical address we are running at, returned by early_init()
  */
@@ -145,7 +133,7 @@ __after_mmu_off:
 	bl	flush_tlbs
 
 	bl	initial_bats
-#if !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT)
+#ifdef CONFIG_BOOTX_TEXT
 	bl	setup_disp_bat
 #endif
 
@@ -161,7 +149,6 @@ __after_mmu_off:
 #endif /* CONFIG_6xx */
 
 
-#ifndef CONFIG_APUS
 /*
  * We need to run with _start at physical address 0.
  * If the MMU is already turned on, we copy stuff to KERNELBASE,
@@ -172,7 +159,7 @@ __after_mmu_off:
 	addis	r4,r3,KERNELBASE@h	/* current address of _start */
 	cmpwi	0,r4,0			/* are we already running at 0? */
 	bne	relocate_kernel
-#endif /* CONFIG_APUS */
+
 /*
  * we now have the 1st 16M of ram mapped with the bats.
  * prep needs the mmu to be turned on here, but pmac already has it on.
@@ -812,85 +799,6 @@ copy_and_flush:
 	addi	r6,r6,4
 	blr
 
-#ifdef CONFIG_APUS
-/*
- * On APUS the physical base address of the kernel is not known at compile
- * time, which means the __pa/__va constants used are incorrect. In the
- * __init section is recorded the virtual addresses of instructions using
- * these constants, so all that has to be done is fix these before
- * continuing the kernel boot.
- *
- * r4 = The physical address of the kernel base.
- */
-fix_mem_constants:
-	mr	r10,r4
-	addis	r10,r10,-KERNELBASE@h    /* virt_to_phys constant */
-	neg	r11,r10	                 /* phys_to_virt constant */
-
-	lis	r12,__vtop_table_begin@h
-	ori	r12,r12,__vtop_table_begin@l
-	add	r12,r12,r10	         /* table begin phys address */
-	lis	r13,__vtop_table_end@h
-	ori	r13,r13,__vtop_table_end@l
-	add	r13,r13,r10	         /* table end phys address */
-	subi	r12,r12,4
-	subi	r13,r13,4
-1:	lwzu	r14,4(r12)               /* virt address of instruction */
-	add     r14,r14,r10              /* phys address of instruction */
-	lwz     r15,0(r14)               /* instruction, now insert top */
-	rlwimi  r15,r10,16,16,31         /* half of vp const in low half */
-	stw	r15,0(r14)               /* of instruction and restore. */
-	dcbst	r0,r14			 /* write it to memory */
-	sync
-	icbi	r0,r14			 /* flush the icache line */
-	cmpw	r12,r13
-	bne     1b
-	sync				/* additional sync needed on g4 */
-	isync
-
-/*
- * Map the memory where the exception handlers will
- * be copied to when hash constants have been patched.
- */
-#ifdef CONFIG_APUS_FAST_EXCEPT
-	lis	r8,0xfff0
-#else
-	lis	r8,0
-#endif
-	ori	r8,r8,0x2		/* 128KB, supervisor */
-	mtspr	SPRN_DBAT3U,r8
-	mtspr	SPRN_DBAT3L,r8
-
-	lis	r12,__ptov_table_begin@h
-	ori	r12,r12,__ptov_table_begin@l
-	add	r12,r12,r10	         /* table begin phys address */
-	lis	r13,__ptov_table_end@h
-	ori	r13,r13,__ptov_table_end@l
-	add	r13,r13,r10	         /* table end phys address */
-	subi	r12,r12,4
-	subi	r13,r13,4
-1:	lwzu	r14,4(r12)               /* virt address of instruction */
-	add     r14,r14,r10              /* phys address of instruction */
-	lwz     r15,0(r14)               /* instruction, now insert top */
-	rlwimi  r15,r11,16,16,31         /* half of pv const in low half*/
-	stw	r15,0(r14)               /* of instruction and restore. */
-	dcbst	r0,r14			 /* write it to memory */
-	sync
-	icbi	r0,r14			 /* flush the icache line */
-	cmpw	r12,r13
-	bne     1b
-
-	sync				/* additional sync needed on g4 */
-	isync				/* No speculative loading until now */
-	blr
-
-/***********************************************************************
- *  Please note that on APUS the exception handlers are located at the
- *  physical address 0xfff0000. For this reason, the exception handlers
- *  cannot use relative branches to access the code below.
- ***********************************************************************/
-#endif /* CONFIG_APUS */
-
 #ifdef CONFIG_SMP
 	.globl	__secondary_start_pmac_0
 __secondary_start_pmac_0:
@@ -1043,19 +951,6 @@ start_here:
 	bl	machine_init
 	bl	MMU_init
 
-#ifdef CONFIG_APUS
-	/* Copy exception code to exception vector base on APUS. */
-	lis	r4,KERNELBASE@h
-#ifdef CONFIG_APUS_FAST_EXCEPT
-	lis	r3,0xfff0		/* Copy to 0xfff00000 */
-#else
-	lis	r3,0			/* Copy to 0x00000000 */
-#endif
-	li	r5,0x4000		/* # bytes of memory to copy */
-	li	r6,0
-	bl	copy_and_flush		/* copy the first 0x4000 bytes */
-#endif  /* CONFIG_APUS */
-
 /*
  * Go back to running unmapped so we can load up new values
  * for SDR1 (hash table pointer) and the segment registers
@@ -1232,11 +1127,7 @@ initial_bats:
 #else
 	ori	r8,r8,2			/* R/W access */
 #endif /* CONFIG_SMP */
-#ifdef CONFIG_APUS
-	ori	r11,r11,BL_8M<<2|0x2	/* set up 8MB BAT registers for 604 */
-#else
 	ori	r11,r11,BL_256M<<2|0x2	/* set up BAT registers for 604 */
-#endif /* CONFIG_APUS */
 
 	mtspr	SPRN_DBAT0L,r8		/* N.B. 6xx (not 601) have valid */
 	mtspr	SPRN_DBAT0U,r11		/* bit in upper BAT register */
@@ -1245,7 +1136,7 @@ initial_bats:
 	isync
 	blr
 
-#if !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT)
+#ifdef CONFIG_BOOTX_TEXT
 setup_disp_bat:
 	/*
 	 * setup the display bat prepared for us in prom.c
@@ -1268,7 +1159,7 @@ setup_disp_bat:
 	mtspr	SPRN_IBAT3U,r11
 	blr
 
-#endif /* !defined(CONFIG_APUS) && defined(CONFIG_BOOTX_TEXT) */
+#endif /* defined(CONFIG_BOOTX_TEXT) */
 
 #ifdef CONFIG_8260
 /* Jump into the system reset for the rom.
--- linux-2.6.22-rc6-mm1/arch/ppc/platforms/Makefile.old	2007-06-30 01:05:05.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/platforms/Makefile	2007-06-30 01:05:19.000000000 +0200
@@ -2,10 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-obj-$(CONFIG_APUS)		+= apus_setup.o
-ifeq ($(CONFIG_APUS),y)
-obj-$(CONFIG_PCI)		+= apus_pci.o
-endif
 obj-$(CONFIG_PPC_PREP)		+= prep_pci.o prep_setup.o
 obj-$(CONFIG_PREP_RESIDUAL)	+= residual.o
 obj-$(CONFIG_PQ2ADS)		+= pq2ads.o
--- linux-2.6.22-rc6-mm1/drivers/ide/ide-probe.c.old	2007-06-30 01:06:35.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/ide/ide-probe.c	2007-06-30 01:07:23.000000000 +0200
@@ -1096,9 +1096,9 @@ static int init_irq (ide_hwif_t *hwif)
 	 */
 	if (!match || match->irq != hwif->irq) {
 		int sa = IRQF_DISABLED;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 		sa = IRQF_SHARED;
-#endif /* __mc68000__ || CONFIG_APUS */
+#endif /* __mc68000__ */
 
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset)) {
 			sa = IRQF_SHARED;
@@ -1141,7 +1141,7 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_unlock_irq(&ide_lock);
 	}
 
-#if !defined(__mc68000__) && !defined(CONFIG_APUS)
+#if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
 		hwif->io_ports[IDE_DATA_OFFSET]+7,
@@ -1149,7 +1149,7 @@ static int init_irq (ide_hwif_t *hwif)
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
-#endif /* __mc68000__ && CONFIG_APUS */
+#endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
--- linux-2.6.22-rc6-mm1/drivers/isdn/hisax/avm_pci.c.old	2007-06-30 01:07:31.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/isdn/hisax/avm_pci.c	2007-06-30 01:07:48.000000000 +0200
@@ -264,11 +264,7 @@ hdlc_empty_fifo(struct BCState *bcs, int
 		outl(idx, cs->hw.avm.cfg_reg + 4);
 		while (cnt < count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			*ptr++ = in_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#else
 			*ptr++ = in_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#endif /* CONFIG_APUS */
 #else
 			*ptr++ = inl(cs->hw.avm.isac);
 #endif /* __powerpc__ */
@@ -329,11 +325,7 @@ hdlc_fill_fifo(struct BCState *bcs)
 	if (cs->subtyp == AVM_FRITZ_PCI) {
 		while (cnt<count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			out_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#else
 			out_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#endif /* CONFIG_APUS */
 #else
 			outl(*ptr++, cs->hw.avm.isac);
 #endif /* __powerpc__ */
--- linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_esp.c.old	2007-06-30 01:07:59.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_esp.c	2007-06-30 01:08:10.000000000 +0200
@@ -7,7 +7,7 @@
  */
 
 
-#if defined(CONFIG_AMIGA) || defined(CONFIG_APUS)
+#if defined(CONFIG_AMIGA)
 #define USE_BOTTOM_HALF
 #endif
 
--- linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_io.S.old	2007-06-30 01:08:38.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/oktagon_io.S	2007-06-30 01:09:05.000000000 +0200
@@ -24,77 +24,6 @@ int oktag_from_io(long *addr,long *paddr
  */
 
 
-#ifdef CONFIG_APUS
-
-	.file	"oktagon_io.c"
-
-gcc2_compiled.:
-/*
-	.section ".text"
-*/
-	.align 2
-	.globl oktag_to_io
-	.type	 oktag_to_io,@function
-oktag_to_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	mr 3,4
-	addi 5,5,-1
-	bc 12,6,.L3
-.L5:
-	cmpwi 1,5,0
-	lwz 0,0(3)
-	addi 3,3,4
-	addi 5,5,-1
-exp1:	stw 0,0(9)
-	bc 4,6,.L5
-.L3:
-ret1:	subf 3,4,3
-	srawi 3,3,2
-	blr
-.Lfe1:
-	.size	 oktag_to_io,.Lfe1-oktag_to_io
-	.align 2
-	.globl oktag_from_io
-	.type	 oktag_from_io,@function
-oktag_from_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	addi 5,5,-1
-	bc 12,6,.L9
-.L11:
-	cmpwi 1,5,0
-exp2:	lwz 0,0(4)
-	addi 5,5,-1
-	stw 0,0(3)
-	addi 3,3,4
-	bc 4,6,.L11
-.L9:
-ret2:	subf 3,9,3
-	srawi 3,3,2
-	blr
-.Lfe2:
-	.size	 oktag_from_io,.Lfe2-oktag_from_io
-	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
-
-/*
- * Exception table.
- * Second longword shows where to jump when an exception at the addr the first
- * longword is pointing to is caught.
- */
-
-.section __ex_table,"a"
-	.align	2
-oktagon_except:
-	.long	exp1,ret1
-	.long	exp2,ret2
-
-#else
-
 /*
 The code which follows is for 680x0 based assembler and is meant for
 Linux/m68k. It was created by cross compiling the code using the
@@ -191,4 +120,3 @@ oktagon_except:
 	.long	exp2,ret2
 
 #endif
-#endif
--- linux-2.6.22-rc6-mm1/drivers/video/console/fbcon.c.old	2007-06-30 01:09:16.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/console/fbcon.c	2007-06-30 01:09:23.000000000 +0200
@@ -85,7 +85,7 @@
 #ifdef CONFIG_MAC
 #include <asm/macints.h>
 #endif
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/machdep.h>
 #include <asm/setup.h>
 #endif
--- linux-2.6.22-rc6-mm1/drivers/video/console/fonts.c.old	2007-06-30 01:09:33.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/video/console/fonts.c	2007-06-30 01:09:44.000000000 +0200
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/setup.h>
 #endif
 #include <linux/font.h>
@@ -120,7 +120,7 @@ const struct font_desc *get_default_font
     for(i=0; i<num_fonts; i++) {
 	f = fonts[i];
 	c = f->pref;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #ifdef CONFIG_FONT_PEARL_8x8
 	if (MACH_IS_AMIGA && f->idx == PEARL8x8_IDX)
 	    c = 100;
--- linux-2.6.22-rc6-mm1/include/asm-powerpc/ide.h.old	2007-06-30 01:10:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-powerpc/ide.h	2007-06-30 01:10:14.000000000 +0200
@@ -67,7 +67,7 @@ static __inline__ unsigned long ide_defa
 #define ide_init_default_irq(base)	ide_default_irq(base)
 #endif
 
-#if (defined CONFIG_APUS || defined CONFIG_BLK_DEV_MPC8xx_IDE )
+#ifdef CONFIG_BLK_DEV_MPC8xx_IDE
 #define IDE_ARCH_ACK_INTR  1
 #define ide_ack_intr(hwif) (hwif->hw.ack_intr ? hwif->hw.ack_intr(hwif) : 1)
 #endif
--- linux-2.6.22-rc6-mm1/include/asm-powerpc/reg.h.old	2007-06-30 01:10:22.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-powerpc/reg.h	2007-06-30 01:10:31.000000000 +0200
@@ -102,12 +102,8 @@
 #else /* 32-bit */
 /* Default MSR for kernel mode. */
 #ifndef MSR_KERNEL	/* reg_booke.h also defines this */
-#ifdef CONFIG_APUS_FAST_EXCEPT
-#define MSR_KERNEL	(MSR_ME|MSR_IP|MSR_RI|MSR_IR|MSR_DR)
-#else
 #define MSR_KERNEL	(MSR_ME|MSR_RI|MSR_IR|MSR_DR)
 #endif
-#endif
 
 #define MSR_USER	(MSR_KERNEL|MSR_PR|MSR_EE)
 #endif
--- linux-2.6.22-rc6-mm1/include/asm-ppc/bootinfo.h.old	2007-06-30 01:12:56.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/bootinfo.h	2007-06-30 01:13:07.000000000 +0200
@@ -11,10 +11,6 @@
 
 #include <asm/page.h>
 
-#if defined(CONFIG_APUS) && !defined(__BOOTER__)
-#include <asm-m68k/bootinfo.h>
-#else
-
 struct bi_record {
 	unsigned long tag;		/* tag ID */
 	unsigned long size;		/* size of record (in bytes) */
@@ -44,7 +40,6 @@ bootinfo_addr(unsigned long offset)
 	return (struct bi_record *)_ALIGN((offset) + (1 << 20) - 1,
 					  (1 << 20));
 }
-#endif /* CONFIG_APUS */
 
 
 #endif /* _PPC_BOOTINFO_H */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/io.h.old	2007-06-30 01:13:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/io.h	2007-06-30 02:00:34.000000000 +0200
@@ -30,7 +30,7 @@
 #include <asm/mpc8xx.h>
 #elif defined(CONFIG_8260)
 #include <asm/mpc8260.h>
-#elif defined(CONFIG_APUS) || !defined(CONFIG_PCI)
+#elif !defined(CONFIG_PCI)
 #define _IO_BASE	0
 #define _ISA_MEM_BASE	0
 #define PCI_DRAM_OFFSET 0
@@ -145,24 +145,7 @@ static inline void writeb(__u8 b, volati
 }
 #endif
 
-#if defined(CONFIG_APUS)
-static inline __u16 readw(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u16 *)(addr);
-}
-static inline __u32 readl(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u32 *)(addr);
-}
-static inline void writew(__u16 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u16 *)(addr) = b;
-}
-static inline void writel(__u32 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u32 *)(addr) = b;
-}
-#elif defined (CONFIG_8260_PCI9)
+#if defined (CONFIG_8260_PCI9)
 /* Use macros if PCI9 workaround enabled */
 #define readw(addr) in_le16((volatile u16 *)(addr))
 #define readl(addr) in_le32((volatile u32 *)(addr))
@@ -185,7 +168,7 @@ static inline void writel(__u32 b, volat
 {
 	out_le32(addr, b);
 }
-#endif /* CONFIG_APUS */
+#endif /* CONFIG_8260_PCI9 */
 
 #define readb_relaxed(addr) readb(addr)
 #define readw_relaxed(addr) readw(addr)
@@ -300,13 +283,7 @@ extern __inline__ void name(unsigned int
 }
 
 __do_out_asm(outb, "stbx")
-#ifdef CONFIG_APUS
-__do_in_asm(inb, "lbzx")
-__do_in_asm(inw, "lhz%U1%X1")
-__do_in_asm(inl, "lwz%U1%X1")
-__do_out_asm(outl,"stw%U0%X0")
-__do_out_asm(outw, "sth%U0%X0")
-#elif defined (CONFIG_8260_PCI9)
+#if defined (CONFIG_8260_PCI9)
 /* in asm cannot be defined if PCI9 workaround is used */
 #define inb(port)		in_8((port)+___IO_BASE)
 #define inw(port)		in_le16((port)+___IO_BASE)
@@ -371,7 +348,6 @@ extern void __iomem *ioremap64(unsigned 
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
 extern void iounmap(volatile void __iomem *addr);
 extern unsigned long iopa(unsigned long addr);
-extern unsigned long mm_ptov(unsigned long addr) __attribute_const__;
 extern void io_block_mapping(unsigned long virt, phys_addr_t phys,
 			     unsigned int size, int flags);
 
@@ -384,24 +360,16 @@ extern void io_block_mapping(unsigned lo
  */
 extern inline unsigned long virt_to_bus(volatile void * address)
 {
-#ifndef CONFIG_APUS
         if (address == (void *)0)
 		return 0;
         return (unsigned long)address - KERNELBASE + PCI_DRAM_OFFSET;
-#else
-	return iopa ((unsigned long) address);
-#endif
 }
 
 extern inline void * bus_to_virt(unsigned long address)
 {
-#ifndef CONFIG_APUS
         if (address == 0)
 		return NULL;
         return (void *)(address - PCI_DRAM_OFFSET + KERNELBASE);
-#else
-	return (void*) mm_ptov (address);
-#endif
 }
 
 /*
@@ -410,20 +378,12 @@ extern inline void * bus_to_virt(unsigne
  */
 extern inline unsigned long virt_to_phys(volatile void * address)
 {
-#ifndef CONFIG_APUS
 	return (unsigned long) address - KERNELBASE;
-#else
-	return iopa ((unsigned long) address);
-#endif
 }
 
 extern inline void * phys_to_virt(unsigned long address)
 {
-#ifndef CONFIG_APUS
 	return (void *) (address + KERNELBASE);
-#else
-	return (void*) mm_ptov (address);
-#endif
 }
 
 /*
--- linux-2.6.22-rc6-mm1/include/asm-ppc/machdep.h.old	2007-06-30 01:14:22.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/machdep.h	2007-06-30 01:14:31.000000000 +0200
@@ -8,10 +8,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 
-#ifdef CONFIG_APUS
-#include <asm-m68k/machdep.h>
-#endif
-
 struct pt_regs;
 struct pci_bus;	
 struct pci_dev;
--- linux-2.6.22-rc6-mm1/include/asm-ppc/page.h.old	2007-06-30 01:14:41.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/page.h	2007-06-30 01:20:35.000000000 +0200
@@ -97,62 +97,22 @@ extern void clear_user_page(void *page, 
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 			   struct page *pg);
 
-#ifndef CONFIG_APUS
 #define PPC_MEMSTART	0
-#define PPC_PGSTART	0
 #define PPC_MEMOFFSET	PAGE_OFFSET
-#else
-extern unsigned long ppc_memstart;
-extern unsigned long ppc_pgstart;
-extern unsigned long ppc_memoffset;
-#define PPC_MEMSTART	ppc_memstart
-#define PPC_PGSTART	ppc_pgstart
-#define PPC_MEMOFFSET	ppc_memoffset
-#endif
-
-#if defined(CONFIG_APUS) && !defined(MODULE)
-/* map phys->virtual and virtual->phys for RAM pages */
-static inline unsigned long ___pa(unsigned long v)
-{
-	unsigned long p;
-	asm volatile ("1: addis %0, %1, %2;"
-		      ".section \".vtop_fixup\",\"aw\";"
-		      ".align  1;"
-		      ".long   1b;"
-		      ".previous;"
-		      : "=r" (p)
-		      : "b" (v), "K" (((-PAGE_OFFSET) >> 16) & 0xffff));
 
-	return p;
-}
-static inline void* ___va(unsigned long p)
-{
-	unsigned long v;
-	asm volatile ("1: addis %0, %1, %2;"
-		      ".section \".ptov_fixup\",\"aw\";"
-		      ".align  1;"
-		      ".long   1b;"
-		      ".previous;"
-		      : "=r" (v)
-		      : "b" (p), "K" (((PAGE_OFFSET) >> 16) & 0xffff));
-
-	return (void*) v;
-}
-#else
 #define ___pa(vaddr) ((vaddr)-PPC_MEMOFFSET)
 #define ___va(paddr) ((paddr)+PPC_MEMOFFSET)
-#endif
 
 extern int page_is_ram(unsigned long pfn);
 
 #define __pa(x) ___pa((unsigned long)(x))
 #define __va(x) ((void *)(___va((unsigned long)(x))))
 
-#define ARCH_PFN_OFFSET		(PPC_PGSTART)
+#define ARCH_PFN_OFFSET		0
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_virt(page)	__va(page_to_pfn(page) << PAGE_SHIFT)
 
-#define pfn_valid(pfn)		(((pfn) - PPC_PGSTART) < max_mapnr)
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 /* Pure 2^n version of get_order */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/pgtable.h.old	2007-06-30 01:22:25.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-ppc/pgtable.h	2007-06-30 01:58:12.000000000 +0200
@@ -772,14 +772,6 @@ extern void paging_init(void);
 #define pte_to_pgoff(pte)	(pte_val(pte) >> 3)
 #define pgoff_to_pte(off)	((pte_t) { ((off) << 3) | _PAGE_FILE })
 
-/* CONFIG_APUS */
-/* For virtual address to physical address conversion */
-extern void cache_clear(__u32 addr, int length);
-extern void cache_push(__u32 addr, int length);
-extern int mm_end_of_chunk (unsigned long addr, int len);
-extern unsigned long iopa(unsigned long addr);
-extern unsigned long mm_ptov(unsigned long addr) __attribute_const__;
-
 /* Values for nocacheflag and cmode */
 /* These are not used by the APUS kernel_map, but prevents
    compilation errors. */
--- linux-2.6.22-rc6-mm1/include/asm-m68k/pgtable.h.old	2007-06-30 01:23:33.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-m68k/pgtable.h	2007-06-30 01:23:43.000000000 +0200
@@ -107,8 +107,6 @@ extern void *empty_zero_page;
 /* 64-bit machines, beware!  SRB. */
 #define SIZEOF_PTR_LOG2			       2
 
-#define mm_end_of_chunk(addr, len)	0
-
 extern void kernel_set_cachemode(void *addr, unsigned long size, int cmode);
 
 /*
--- linux-2.6.22-rc6-mm1/drivers/scsi/a2091.c.old	2007-06-30 01:23:53.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/a2091.c	2007-06-30 01:24:08.000000000 +0200
@@ -46,8 +46,7 @@ static int dma_setup(struct scsi_cmnd *c
     struct Scsi_Host *instance = cmd->device->host;
 
     /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A2091_XFER_MASK)
     {
 	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
--- linux-2.6.22-rc6-mm1/drivers/scsi/a3000.c.old	2007-06-30 01:24:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/a3000.c	2007-06-30 01:24:26.000000000 +0200
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
      * end of a physical memory chunk, then allocate a bounce
      * buffer
      */
-    if (addr & A3000_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A3000_XFER_MASK)
     {
 	HDATA(a3000_host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
--- linux-2.6.22-rc6-mm1/drivers/scsi/gvp11.c.old	2007-06-30 01:24:35.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/scsi/gvp11.c	2007-06-30 01:24:46.000000000 +0200
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *c
     static int scsi_alloc_out_of_range = 0;
 
     /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
     {
 	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
--- linux-2.6.22-rc6-mm1/sound/oss/dmasound/dmasound_paula.c.old	2007-06-30 01:26:29.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/oss/dmasound/dmasound_paula.c	2007-06-30 01:26:54.000000000 +0200
@@ -91,10 +91,6 @@ static irqreturn_t AmiInterrupt(int irq,
      *  power LED are controlled by the same line.
      */
 
-#ifdef CONFIG_APUS
-#define mach_heartbeat	ppc_md.heartbeat
-#endif
-
 static void (*saved_heartbeat)(int) = NULL;
 
 static inline void disable_heartbeat(void)
--- linux-2.6.22-rc6-mm1/arch/powerpc/kernel/setup_32.c.old	2007-06-30 01:49:26.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/powerpc/kernel/setup_32.c	2007-06-30 01:49:35.000000000 +0200
@@ -24,7 +24,6 @@
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
-#include <asm/amigappc.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
--- linux-2.6.22-rc6-mm1/arch/ppc/kernel/setup.c.old	2007-06-30 01:49:46.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/kernel/setup.c	2007-06-30 01:49:50.000000000 +0200
@@ -25,7 +25,6 @@
 #include <asm/pgtable.h>
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
-#include <asm/amigappc.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
--- linux-2.6.22-rc6-mm1/arch/ppc/kernel/ppc_ksyms.c.old	2007-06-30 01:55:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/kernel/ppc_ksyms.c	2007-06-30 01:55:10.000000000 +0200
@@ -60,8 +60,6 @@ long long __ashrdi3(long long, int);
 long long __ashldi3(long long, int);
 long long __lshrdi3(long long, int);
 
-extern unsigned long mm_ptov (unsigned long paddr);
-
 EXPORT_SYMBOL(clear_pages);
 EXPORT_SYMBOL(clear_user_page);
 EXPORT_SYMBOL(do_signal);
@@ -119,7 +117,6 @@ EXPORT_SYMBOL(_outsw_ns);
 EXPORT_SYMBOL(_insl_ns);
 EXPORT_SYMBOL(_outsl_ns);
 EXPORT_SYMBOL(iopa);
-EXPORT_SYMBOL(mm_ptov);
 EXPORT_SYMBOL(ioremap);
 #ifdef CONFIG_44x
 EXPORT_SYMBOL(ioremap64);
--- linux-2.6.22-rc6-mm1/arch/ppc/mm/pgtable.c.old	2007-06-30 01:55:21.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/ppc/mm/pgtable.c	2007-06-30 01:55:31.000000000 +0200
@@ -426,41 +426,3 @@ unsigned long iopa(unsigned long addr)
 	return(pa);
 }
 
-/* This is will find the virtual address for a physical one....
- * Swiped from APUS, could be dangerous :-).
- * This is only a placeholder until I really find a way to make this
- * work.  -- Dan
- */
-unsigned long
-mm_ptov (unsigned long paddr)
-{
-	unsigned long ret;
-#if 0
-	if (paddr < 16*1024*1024)
-		ret = ZTWO_VADDR(paddr);
-	else {
-		int i;
-
-		for (i = 0; i < kmap_chunk_count;){
-			unsigned long phys = kmap_chunks[i++];
-			unsigned long size = kmap_chunks[i++];
-			unsigned long virt = kmap_chunks[i++];
-			if (paddr >= phys
-			    && paddr < (phys + size)){
-				ret = virt + paddr - phys;
-				goto exit;
-			}
-		}
-	
-		ret = (unsigned long) __va(paddr);
-	}
-exit:
-#ifdef DEBUGPV
-	printk ("PTOV(%lx)=%lx\n", paddr, ret);
-#endif
-#else
-	ret = (unsigned long)paddr + KERNELBASE;
-#endif
-	return ret;
-}
-
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/amiga_ksyms.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/amiga_ksyms.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/chipram.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/chipram.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/Makefile	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,8 +0,0 @@
-#
-# Makefile for Linux arch/m68k/amiga source directory
-#
-
-obj-y		:= config.o amiints.o cia.o time.o bootinfo.o amisound.o \
-			chipram.o amiga_ksyms.o
-
-obj-$(CONFIG_AMIGA_PCMCIA) += pcmcia.o
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/amiints.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,322 +0,0 @@
-/*
- * Amiga Linux interrupt handling code
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- *
- * 11/07/96: rewritten interrupt handling, irq lists are exists now only for
- *           this sources where it makes sense (VERTB/PORTS/EXTER) and you must
- *           be careful that dev_id for this sources is unique since this the
- *           only possibility to distinguish between different handlers for
- *           free_irq. irq lists also have different irq flags:
- *           - IRQ_FLG_FAST: handler is inserted at top of list (after other
- *                           fast handlers)
- *           - IRQ_FLG_SLOW: handler is inserted at bottom of list and before
- *                           they're executed irq level is set to the previous
- *                           one, but handlers don't need to be reentrant, if
- *                           reentrance occurred, slow handlers will be just
- *                           called again.
- *           The whole interrupt handling for CIAs is moved to cia.c
- *           /Roman Zippel
- *
- * 07/08/99: rewamp of the interrupt handling - we now have two types of
- *           interrupts, normal and fast handlers, fast handlers being
- *           marked with SA_INTERRUPT and runs with all other interrupts
- *           disabled. Normal interrupts disable their own source but
- *           run with all other interrupt sources enabled.
- *           PORTS and EXTER interrupts are always shared even if the
- *           drivers do not explicitly mark this when calling
- *           request_irq which they really should do.
- *           This is similar to the way interrupts are handled on all
- *           other architectures and makes a ton of sense besides
- *           having the advantage of making it easier to share
- *           drivers.
- *           /Jes
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/init.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amipcmcia.h>
-
-#ifdef CONFIG_APUS
-#include <asm/amigappc.h>
-#endif
-
-extern void cia_init_IRQ(struct ciabase *base);
-
-unsigned short ami_intena_vals[AMI_STD_IRQS] = {
-	IF_VERTB, IF_COPER, IF_AUD0, IF_AUD1, IF_AUD2, IF_AUD3, IF_BLIT,
-	IF_DSKSYN, IF_DSKBLK, IF_RBF, IF_TBE, IF_SOFT, IF_PORTS, IF_EXTER
-};
-static const unsigned char ami_servers[AMI_STD_IRQS] = {
-	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1
-};
-
-static short ami_ablecount[AMI_IRQS];
-
-static void ami_badint(int irq, void *dev_id, struct pt_regs *fp)
-{
-/*	num_spurious += 1;*/
-}
-
-/*
- * void amiga_init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the amiga IRQ handling routines.
- */
-
-__init
-void amiga_init_IRQ(void)
-{
-	int i;
-
-	for (i = 0; i < AMI_IRQS; i++)
-		ami_ablecount[i] = 0;
-
-	/* turn off PCMCIA interrupts */
-	if (AMIGAHW_PRESENT(PCMCIA))
-		gayle.inten = GAYLE_IRQ_IDE;
-
-	/* turn off all interrupts... */
-	amiga_custom.intena = 0x7fff;
-	amiga_custom.intreq = 0x7fff;
-
-#ifdef CONFIG_APUS
-	/* Clear any inter-CPU interrupt requests. Circumvents bug in
-           Blizzard IPL emulation HW (or so it appears). */
-	APUS_WRITE(APUS_INT_LVL, INTLVL_SETRESET | INTLVL_MASK);
-
-	/* Init IPL emulation. */
-	APUS_WRITE(APUS_REG_INT, REGINT_INTMASTER | REGINT_ENABLEIPL);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_SETRESET | IPLEMU_IPLMASK);
-#endif
-	/* ... and enable the master interrupt bit */
-	amiga_custom.intena = IF_SETCLR | IF_INTEN;
-
-	cia_init_IRQ(&ciaa_base);
-	cia_init_IRQ(&ciab_base);
-}
-
-/*
- * Enable/disable a particular machine specific interrupt source.
- * Note that this may affect other interrupts in case of a shared interrupt.
- * This function should only be called for a _very_ short time to change some
- * internal data, that may not be changed by the interrupt at the same time.
- * ami_(enable|disable)_irq calls may also be nested.
- */
-
-void amiga_enable_irq(unsigned int irq)
-{
-	if (irq >= AMI_IRQS) {
-		printk("%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	ami_ablecount[irq]--;
-	if (ami_ablecount[irq]<0)
-		ami_ablecount[irq]=0;
-	else if (ami_ablecount[irq])
-		return;
-
-	/* No action for auto-vector interrupts */
-	if (irq >= IRQ_AMIGA_AUTO){
-		printk("%s: Trying to enable auto-vector IRQ %i\n",
-		       __FUNCTION__, irq - IRQ_AMIGA_AUTO);
-		return;
-	}
-
-	if (irq >= IRQ_AMIGA_CIAA) {
-		cia_set_irq(irq, 0);
-		cia_able_irq(irq, 1);
-		return;
-	}
-
-	/* enable the interrupt */
-	amiga_custom.intena = IF_SETCLR | ami_intena_vals[irq];
-}
-
-void amiga_disable_irq(unsigned int irq)
-{
-	if (irq >= AMI_IRQS) {
-		printk("%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (ami_ablecount[irq]++)
-		return;
-
-	/* No action for auto-vector interrupts */
-	if (irq >= IRQ_AMIGA_AUTO) {
-		printk("%s: Trying to disable auto-vector IRQ %i\n",
-		       __FUNCTION__, irq - IRQ_AMIGA_AUTO);
-		return;
-	}
-
-	if (irq >= IRQ_AMIGA_CIAA) {
-		cia_able_irq(irq, 0);
-		return;
-	}
-
-	/* disable the interrupt */
-	amiga_custom.intena = ami_intena_vals[irq];
-}
-
-inline void amiga_do_irq(int irq, struct pt_regs *fp)
-{
-	irq_desc_t *desc = irq_desc + irq;
-	struct irqaction *action = desc->action;
-
-	kstat_cpu(0).irqs[irq]++;
-	action->handler(irq, action->dev_id, fp);
-}
-
-void amiga_do_irq_list(int irq, struct pt_regs *fp)
-{
-	irq_desc_t *desc = irq_desc + irq;
-	struct irqaction *action;
-
-	kstat_cpu(0).irqs[irq]++;
-
-	amiga_custom.intreq = ami_intena_vals[irq];
-
-	for (action = desc->action; action; action = action->next)
-		action->handler(irq, action->dev_id, fp);
-}
-
-/*
- * The builtin Amiga hardware interrupt handlers.
- */
-
-static void ami_int1(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial transmit buffer empty, interrupt */
-	if (ints & IF_TBE) {
-		amiga_custom.intreq = IF_TBE;
-		amiga_do_irq(IRQ_AMIGA_TBE, fp);
-	}
-
-	/* if floppy disk transfer complete, interrupt */
-	if (ints & IF_DSKBLK) {
-		amiga_custom.intreq = IF_DSKBLK;
-		amiga_do_irq(IRQ_AMIGA_DSKBLK, fp);
-	}
-
-	/* if software interrupt set, interrupt */
-	if (ints & IF_SOFT) {
-		amiga_custom.intreq = IF_SOFT;
-		amiga_do_irq(IRQ_AMIGA_SOFT, fp);
-	}
-}
-
-static void ami_int3(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if a blitter interrupt */
-	if (ints & IF_BLIT) {
-		amiga_custom.intreq = IF_BLIT;
-		amiga_do_irq(IRQ_AMIGA_BLIT, fp);
-	}
-
-	/* if a copper interrupt */
-	if (ints & IF_COPER) {
-		amiga_custom.intreq = IF_COPER;
-		amiga_do_irq(IRQ_AMIGA_COPPER, fp);
-	}
-
-	/* if a vertical blank interrupt */
-	if (ints & IF_VERTB)
-		amiga_do_irq_list(IRQ_AMIGA_VERTB, fp);
-}
-
-static void ami_int4(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if audio 0 interrupt */
-	if (ints & IF_AUD0) {
-		amiga_custom.intreq = IF_AUD0;
-		amiga_do_irq(IRQ_AMIGA_AUD0, fp);
-	}
-
-	/* if audio 1 interrupt */
-	if (ints & IF_AUD1) {
-		amiga_custom.intreq = IF_AUD1;
-		amiga_do_irq(IRQ_AMIGA_AUD1, fp);
-	}
-
-	/* if audio 2 interrupt */
-	if (ints & IF_AUD2) {
-		amiga_custom.intreq = IF_AUD2;
-		amiga_do_irq(IRQ_AMIGA_AUD2, fp);
-	}
-
-	/* if audio 3 interrupt */
-	if (ints & IF_AUD3) {
-		amiga_custom.intreq = IF_AUD3;
-		amiga_do_irq(IRQ_AMIGA_AUD3, fp);
-	}
-}
-
-static void ami_int5(int irq, void *dev_id, struct pt_regs *fp)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial receive buffer full interrupt */
-	if (ints & IF_RBF) {
-		/* acknowledge of IF_RBF must be done by the serial interrupt */
-		amiga_do_irq(IRQ_AMIGA_RBF, fp);
-	}
-
-	/* if a disk sync interrupt */
-	if (ints & IF_DSKSYN) {
-		amiga_custom.intreq = IF_DSKSYN;
-		amiga_do_irq(IRQ_AMIGA_DSKSYN, fp);
-	}
-}
-
-static void ami_int7(int irq, void *dev_id, struct pt_regs *fp)
-{
-	panic ("level 7 interrupt received\n");
-}
-
-#ifdef CONFIG_APUS
-/* The PPC irq handling links all handlers requested on the same vector
-   and executes them in a loop. Having ami_badint at the end of the chain
-   is a bad idea. */
-struct irqaction amiga_sys_irqaction[AUTO_IRQS] = {
-	{ .handler = ami_badint, .name = "spurious int" },
-	{ .handler = ami_int1, .name = "int1 handler" },
-	{ 0, /* CIAA */ },
-	{ .handler = ami_int3, .name = "int3 handler" },
-	{ .handler = ami_int4, .name = "int4 handler" },
-	{ .handler = ami_int5, .name = "int5 handler" },
-	{ 0, /* CIAB */ },
-	{ .handler = ami_int7, .name = "int7 handler" },
-};
-#else
-void (*amiga_default_handler[SYS_IRQS])(int, void *, struct pt_regs *) = {
-	ami_badint, ami_int1, ami_badint, ami_int3,
-	ami_int4, ami_int5, ami_badint, ami_int7
-};
-#endif
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/cia.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,176 +0,0 @@
-/*
- *  Copyright (C) 1996 Roman Zippel
- *
- *  The concept of some functions bases on the original Amiga OS function
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/kernel_stat.h>
-#include <linux/init.h>
-
-#include <asm/irq.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-
-struct ciabase {
-	volatile struct CIA *cia;
-	u_char icr_mask, icr_data;
-	u_short int_mask;
-	int handler_irq, cia_irq, server_irq;
-	char *name;
-} ciaa_base = {
-	&ciaa, 0, 0, IF_PORTS,
-	IRQ_AMIGA_AUTO_2, IRQ_AMIGA_CIAA,
-	IRQ_AMIGA_PORTS,
-	"CIAA handler"
-}, ciab_base = {
-	&ciab, 0, 0, IF_EXTER,
-	IRQ_AMIGA_AUTO_6, IRQ_AMIGA_CIAB,
-	IRQ_AMIGA_EXTER,
-	"CIAB handler"
-};
-
-#define CIA_SET_BASE_ADJUST_IRQ(base, irq)	\
-do {						\
-	if (irq >= IRQ_AMIGA_CIAB) {		\
-		base = &ciab_base;		\
-		irq -= IRQ_AMIGA_CIAB;		\
-	} else {				\
-		base = &ciaa_base;		\
-		irq -= IRQ_AMIGA_CIAA;		\
-	}					\
-} while (0)
-
-/*
- *  Cause or clear CIA interrupts, return old interrupt status.
- */
-
-static unsigned char cia_set_irq_private(struct ciabase *base,
-					 unsigned char mask)
-{
-	u_char old;
-
-	old = (base->icr_data |= base->cia->icr);
-	if (mask & CIA_ICR_SETCLR)
-		base->icr_data |= mask;
-	else
-		base->icr_data &= ~mask;
-	if (base->icr_data & base->icr_mask)
-		amiga_custom.intreq = IF_SETCLR | base->int_mask;
-	return old & base->icr_mask;
-}
-
-unsigned char cia_set_irq(unsigned int irq, int set)
-{
-	struct ciabase *base;
-	unsigned char mask;
-
-	if (irq >= IRQ_AMIGA_CIAB)
-		mask = (1 << (irq - IRQ_AMIGA_CIAB));
-	else
-		mask = (1 << (irq - IRQ_AMIGA_CIAA));
-	mask |= (set) ? CIA_ICR_SETCLR : 0;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return cia_set_irq_private(base, mask);
-}
-
-unsigned char cia_get_irq_mask(unsigned int irq)
-{
-	struct ciabase *base;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return base->cia->icr;
-}
-
-/*
- *  Enable or disable CIA interrupts, return old interrupt mask.
- */
-
-static unsigned char cia_able_irq_private(struct ciabase *base,
-					  unsigned char mask)
-{
-	u_char old;
-
-	old = base->icr_mask;
-	base->icr_data |= base->cia->icr;
-	base->cia->icr = mask;
-	if (mask & CIA_ICR_SETCLR)
-		base->icr_mask |= mask;
-	else
-		base->icr_mask &= ~mask;
-	base->icr_mask &= CIA_ICR_ALL;
-
-	if (base->icr_data & base->icr_mask)
-		amiga_custom.intreq = IF_SETCLR | base->int_mask;
-	return old;
-}
-
-unsigned char cia_able_irq(unsigned int irq, int enable)
-{
-	struct ciabase *base;
-	unsigned char mask;
-
-	if (irq >= IRQ_AMIGA_CIAB)
-		mask = (1 << (irq - IRQ_AMIGA_CIAB));
-	else
-		mask = (1 << (irq - IRQ_AMIGA_CIAA));
-	mask |= (enable) ? CIA_ICR_SETCLR : 0;
-
-	CIA_SET_BASE_ADJUST_IRQ(base, irq);
-
-	return cia_able_irq_private(base, mask);
-}
-
-static void cia_handler(int irq, void *dev_id, struct pt_regs *fp)
-{
-	struct ciabase *base = (struct ciabase *)dev_id;
-	irq_desc_t *desc;
-	struct irqaction *action;
-	int i;
-	unsigned char ints;
-
-	irq = base->cia_irq;
-	desc = irq_desc + irq;
-	ints = cia_set_irq_private(base, CIA_ICR_ALL);
-	amiga_custom.intreq = base->int_mask;
-	for (i = 0; i < CIA_IRQS; i++, irq++) {
-		if (ints & 1) {
-			kstat_cpu(0).irqs[irq]++;
-			action = desc->action;
-			action->handler(irq, action->dev_id, fp);
-		}
-		ints >>= 1;
-		desc++;
-	}
-	amiga_do_irq_list(base->server_irq, fp);
-}
-
-void __init cia_init_IRQ(struct ciabase *base)
-{
-	extern struct irqaction amiga_sys_irqaction[AUTO_IRQS];
-	struct irqaction *action;
-
-	/* clear any pending interrupt and turn off all interrupts */
-	cia_set_irq_private(base, CIA_ICR_ALL);
-	cia_able_irq_private(base, CIA_ICR_ALL);
-
-	/* install CIA handler */
-	action = &amiga_sys_irqaction[base->handler_irq-IRQ_AMIGA_AUTO];
-	action->handler = cia_handler;
-	action->dev_id = base;
-	action->name = base->name;
-	setup_irq(base->handler_irq, &amiga_sys_irqaction[base->handler_irq-IRQ_AMIGA_AUTO]);
-
-	amiga_custom.intena = IF_SETCLR | base->int_mask;
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/pcmcia.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/pcmcia.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/amisound.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1 +0,0 @@
-#include "../../m68k/amiga/amisound.c"
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/config.c	2007-06-28 14:54:23.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,947 +0,0 @@
-#define m68k_debug_device debug_device
-
-/*
- *  Copyright (C) 1993 Hamish Macdonald
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-/*
- * Miscellaneous Amiga stuff
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/kd.h>
-#include <linux/tty.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#ifdef CONFIG_ZORRO
-#include <linux/zorro.h>
-#endif
-
-#include <asm/bootinfo.h>
-#include <asm/setup.h>
-#include <asm/system.h>
-#include <asm/pgtable.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/irq.h>
-#include <asm/machdep.h>
-#include <asm/io.h>
-
-unsigned long powerup_PCI_present;
-unsigned long powerup_BPPCPLUS_present;
-unsigned long amiga_model;
-unsigned long amiga_eclock;
-unsigned long amiga_masterclock;
-unsigned long amiga_colorclock;
-unsigned long amiga_chipset;
-unsigned char amiga_vblank;
-unsigned char amiga_psfreq;
-struct amiga_hw_present amiga_hw_present;
-
-static char s_a500[] __initdata = "A500";
-static char s_a500p[] __initdata = "A500+";
-static char s_a600[] __initdata = "A600";
-static char s_a1000[] __initdata = "A1000";
-static char s_a1200[] __initdata = "A1200";
-static char s_a2000[] __initdata = "A2000";
-static char s_a2500[] __initdata = "A2500";
-static char s_a3000[] __initdata = "A3000";
-static char s_a3000t[] __initdata = "A3000T";
-static char s_a3000p[] __initdata = "A3000+";
-static char s_a4000[] __initdata = "A4000";
-static char s_a4000t[] __initdata = "A4000T";
-static char s_cdtv[] __initdata = "CDTV";
-static char s_cd32[] __initdata = "CD32";
-static char s_draco[] __initdata = "Draco";
-static char *amiga_models[] __initdata = {
-    s_a500, s_a500p, s_a600, s_a1000, s_a1200, s_a2000, s_a2500, s_a3000,
-    s_a3000t, s_a3000p, s_a4000, s_a4000t, s_cdtv, s_cd32, s_draco,
-};
-
-static char amiga_model_name[13] = "Amiga ";
-
-extern char m68k_debug_device[];
-
-static void amiga_sched_init(irqreturn_t (*handler)(int, void *, struct pt_regs *));
-/* amiga specific irq functions */
-extern void amiga_init_IRQ (void);
-extern void (*amiga_default_handler[]) (int, void *, struct pt_regs *);
-extern int amiga_request_irq (unsigned int irq,
-			      void (*handler)(int, void *, struct pt_regs *),
-                              unsigned long flags, const char *devname,
-			      void *dev_id);
-extern void amiga_free_irq (unsigned int irq, void *dev_id);
-extern void amiga_enable_irq (unsigned int);
-extern void amiga_disable_irq (unsigned int);
-static void amiga_get_model(char *model);
-static int amiga_get_hardware_list(char *buffer);
-/* amiga specific timer functions */
-static unsigned long amiga_gettimeoffset (void);
-static void a3000_gettod (int *, int *, int *, int *, int *, int *);
-static void a2000_gettod (int *, int *, int *, int *, int *, int *);
-static int amiga_hwclk (int, struct hwclk_time *);
-static int amiga_set_clock_mmss (unsigned long);
-static void amiga_reset (void);
-extern void amiga_init_sound(void);
-static void amiga_savekmsg_init(void);
-static void amiga_mem_console_write(struct console *co, const char *b,
-				    unsigned int count);
-void amiga_serial_console_write(struct console *co, const char *s,
-				unsigned int count);
-static void amiga_debug_init(void);
-#ifdef CONFIG_HEARTBEAT
-static void amiga_heartbeat(int on);
-#endif
-
-static struct console amiga_console_driver = {
-	.name =		"debug",
-	.flags =	CON_PRINTBUFFER,
-	.index =	-1,
-};
-
-
-    /*
-     *  Motherboard Resources present in all Amiga models
-     */
-
-static struct {
-    struct resource _ciab, _ciaa, _custom, _kickstart;
-} mb_resources = {
-//    { "Ranger Memory", 0x00c00000, 0x00c7ffff },
-    ._ciab =	  { "CIA B", 0x00bfd000, 0x00bfdfff },
-    ._ciaa =	  { "CIA A", 0x00bfe000, 0x00bfefff },
-    ._custom =	  { "Custom I/O", 0x00dff000, 0x00dfffff },
-    ._kickstart = { "Kickstart ROM", 0x00f80000, 0x00ffffff }
-};
-
-static struct resource rtc_resource = {
-    NULL, 0x00dc0000, 0x00dcffff
-};
-
-static struct resource ram_resource[NUM_MEMINFO];
-
-
-    /*
-     *  Parse an Amiga-specific record in the bootinfo
-     */
-
-int amiga_parse_bootinfo(const struct bi_record *record)
-{
-    int unknown = 0;
-    const unsigned long *data = record->data;
-
-    switch (record->tag) {
-	case BI_AMIGA_MODEL:
-	{
-		unsigned long d = *data;
-
-		powerup_PCI_present = d & 0x100;
-		amiga_model = d & 0xff;
-	}
-	break;
-
-	case BI_AMIGA_ECLOCK:
-	    amiga_eclock = *data;
-	    break;
-
-	case BI_AMIGA_CHIPSET:
-	    amiga_chipset = *data;
-	    break;
-
-	case BI_AMIGA_CHIP_SIZE:
-	    amiga_chip_size = *(const int *)data;
-	    break;
-
-	case BI_AMIGA_VBLANK:
-	    amiga_vblank = *(const unsigned char *)data;
-	    break;
-
-	case BI_AMIGA_PSFREQ:
-	    amiga_psfreq = *(const unsigned char *)data;
-	    break;
-
-	case BI_AMIGA_AUTOCON:
-#ifdef CONFIG_ZORRO
-	    if (zorro_num_autocon < ZORRO_NUM_AUTO) {
-		const struct ConfigDev *cd = (struct ConfigDev *)data;
-		struct zorro_dev *dev = &zorro_autocon[zorro_num_autocon++];
-		dev->rom = cd->cd_Rom;
-		dev->slotaddr = cd->cd_SlotAddr;
-		dev->slotsize = cd->cd_SlotSize;
-		dev->resource.start = (unsigned long)cd->cd_BoardAddr;
-		dev->resource.end = dev->resource.start+cd->cd_BoardSize-1;
-	    } else
-		printk("amiga_parse_bootinfo: too many AutoConfig devices\n");
-#endif /* CONFIG_ZORRO */
-	    break;
-
-	case BI_AMIGA_SERPER:
-	    /* serial port period: ignored here */
-	    break;
-
-	case BI_AMIGA_PUP_BRIDGE:
-	    powerup_PCI_present = *(const unsigned short *)data;
-	    break;
-
-	case BI_AMIGA_BPPC_SCSI:
-	    powerup_BPPCPLUS_present = *(const unsigned short *)data;
-	    break;
-
-	default:
-	    unknown = 1;
-    }
-    return(unknown);
-}
-
-    /*
-     *  Identify builtin hardware
-     */
-
-static void __init amiga_identify(void)
-{
-  /* Fill in some default values, if necessary */
-  if (amiga_eclock == 0)
-    amiga_eclock = 709379;
-
-  memset(&amiga_hw_present, 0, sizeof(amiga_hw_present));
-
-  printk("Amiga hardware found: ");
-  if (amiga_model >= AMI_500 && amiga_model <= AMI_DRACO) {
-    printk("[%s] ", amiga_models[amiga_model-AMI_500]);
-    strcat(amiga_model_name, amiga_models[amiga_model-AMI_500]);
-  }
-
-  switch(amiga_model) {
-  case AMI_UNKNOWN:
-    goto Generic;
-
-  case AMI_600:
-  case AMI_1200:
-    AMIGAHW_SET(A1200_IDE);
-    AMIGAHW_SET(PCMCIA);
-  case AMI_500:
-  case AMI_500PLUS:
-  case AMI_1000:
-  case AMI_2000:
-  case AMI_2500:
-    AMIGAHW_SET(A2000_CLK);	/* Is this correct for all models? */
-    goto Generic;
-
-  case AMI_3000:
-  case AMI_3000T:
-    AMIGAHW_SET(AMBER_FF);
-    AMIGAHW_SET(MAGIC_REKICK);
-    /* fall through */
-  case AMI_3000PLUS:
-    AMIGAHW_SET(A3000_SCSI);
-    AMIGAHW_SET(A3000_CLK);
-    AMIGAHW_SET(ZORRO3);
-    goto Generic;
-
-  case AMI_4000T:
-    AMIGAHW_SET(A4000_SCSI);
-    /* fall through */
-  case AMI_4000:
-    AMIGAHW_SET(A4000_IDE);
-    AMIGAHW_SET(A3000_CLK);
-    AMIGAHW_SET(ZORRO3);
-    goto Generic;
-
-  case AMI_CDTV:
-  case AMI_CD32:
-    AMIGAHW_SET(CD_ROM);
-    AMIGAHW_SET(A2000_CLK);             /* Is this correct? */
-    goto Generic;
-
-  Generic:
-    AMIGAHW_SET(AMI_VIDEO);
-    AMIGAHW_SET(AMI_BLITTER);
-    AMIGAHW_SET(AMI_AUDIO);
-    AMIGAHW_SET(AMI_FLOPPY);
-    AMIGAHW_SET(AMI_KEYBOARD);
-    AMIGAHW_SET(AMI_MOUSE);
-    AMIGAHW_SET(AMI_SERIAL);
-    AMIGAHW_SET(AMI_PARALLEL);
-    AMIGAHW_SET(CHIP_RAM);
-    AMIGAHW_SET(PAULA);
-
-    switch(amiga_chipset) {
-    case CS_OCS:
-    case CS_ECS:
-    case CS_AGA:
-      switch (amiga_custom.deniseid & 0xf) {
-      case 0x0c:
-	AMIGAHW_SET(DENISE_HR);
-	break;
-      case 0x08:
-	AMIGAHW_SET(LISA);
-	break;
-      }
-      break;
-    default:
-      AMIGAHW_SET(DENISE);
-      break;
-    }
-    switch ((amiga_custom.vposr>>8) & 0x7f) {
-    case 0x00:
-      AMIGAHW_SET(AGNUS_PAL);
-      break;
-    case 0x10:
-      AMIGAHW_SET(AGNUS_NTSC);
-      break;
-    case 0x20:
-    case 0x21:
-      AMIGAHW_SET(AGNUS_HR_PAL);
-      break;
-    case 0x30:
-    case 0x31:
-      AMIGAHW_SET(AGNUS_HR_NTSC);
-      break;
-    case 0x22:
-    case 0x23:
-      AMIGAHW_SET(ALICE_PAL);
-      break;
-    case 0x32:
-    case 0x33:
-      AMIGAHW_SET(ALICE_NTSC);
-      break;
-    }
-    AMIGAHW_SET(ZORRO);
-    break;
-
-  case AMI_DRACO:
-    panic("No support for Draco yet");
-
-  default:
-    panic("Unknown Amiga Model");
-  }
-
-#define AMIGAHW_ANNOUNCE(name, str)			\
-  if (AMIGAHW_PRESENT(name))				\
-    printk(str)
-
-  AMIGAHW_ANNOUNCE(AMI_VIDEO, "VIDEO ");
-  AMIGAHW_ANNOUNCE(AMI_BLITTER, "BLITTER ");
-  AMIGAHW_ANNOUNCE(AMBER_FF, "AMBER_FF ");
-  AMIGAHW_ANNOUNCE(AMI_AUDIO, "AUDIO ");
-  AMIGAHW_ANNOUNCE(AMI_FLOPPY, "FLOPPY ");
-  AMIGAHW_ANNOUNCE(A3000_SCSI, "A3000_SCSI ");
-  AMIGAHW_ANNOUNCE(A4000_SCSI, "A4000_SCSI ");
-  AMIGAHW_ANNOUNCE(A1200_IDE, "A1200_IDE ");
-  AMIGAHW_ANNOUNCE(A4000_IDE, "A4000_IDE ");
-  AMIGAHW_ANNOUNCE(CD_ROM, "CD_ROM ");
-  AMIGAHW_ANNOUNCE(AMI_KEYBOARD, "KEYBOARD ");
-  AMIGAHW_ANNOUNCE(AMI_MOUSE, "MOUSE ");
-  AMIGAHW_ANNOUNCE(AMI_SERIAL, "SERIAL ");
-  AMIGAHW_ANNOUNCE(AMI_PARALLEL, "PARALLEL ");
-  AMIGAHW_ANNOUNCE(A2000_CLK, "A2000_CLK ");
-  AMIGAHW_ANNOUNCE(A3000_CLK, "A3000_CLK ");
-  AMIGAHW_ANNOUNCE(CHIP_RAM, "CHIP_RAM ");
-  AMIGAHW_ANNOUNCE(PAULA, "PAULA ");
-  AMIGAHW_ANNOUNCE(DENISE, "DENISE ");
-  AMIGAHW_ANNOUNCE(DENISE_HR, "DENISE_HR ");
-  AMIGAHW_ANNOUNCE(LISA, "LISA ");
-  AMIGAHW_ANNOUNCE(AGNUS_PAL, "AGNUS_PAL ");
-  AMIGAHW_ANNOUNCE(AGNUS_NTSC, "AGNUS_NTSC ");
-  AMIGAHW_ANNOUNCE(AGNUS_HR_PAL, "AGNUS_HR_PAL ");
-  AMIGAHW_ANNOUNCE(AGNUS_HR_NTSC, "AGNUS_HR_NTSC ");
-  AMIGAHW_ANNOUNCE(ALICE_PAL, "ALICE_PAL ");
-  AMIGAHW_ANNOUNCE(ALICE_NTSC, "ALICE_NTSC ");
-  AMIGAHW_ANNOUNCE(MAGIC_REKICK, "MAGIC_REKICK ");
-  AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA ");
-  if (AMIGAHW_PRESENT(ZORRO))
-    printk("ZORRO%s ", AMIGAHW_PRESENT(ZORRO3) ? "3" : "");
-  printk("\n");
-
-#undef AMIGAHW_ANNOUNCE
-}
-
-    /*
-     *  Setup the Amiga configuration info
-     */
-
-void __init config_amiga(void)
-{
-  int i;
-
-  amiga_debug_init();
-  amiga_identify();
-
-  /* Some APUS boxes may have PCI memory, but ... */
-  iomem_resource.name = "Memory";
-  for (i = 0; i < 4; i++)
-    request_resource(&iomem_resource, &((struct resource *)&mb_resources)[i]);
-
-  mach_sched_init      = amiga_sched_init;
-  mach_init_IRQ        = amiga_init_IRQ;
-#ifndef CONFIG_APUS
-  mach_default_handler = &amiga_default_handler;
-  mach_request_irq     = amiga_request_irq;
-  mach_free_irq        = amiga_free_irq;
-  enable_irq           = amiga_enable_irq;
-  disable_irq          = amiga_disable_irq;
-#endif
-  mach_get_model       = amiga_get_model;
-  mach_get_hardware_list = amiga_get_hardware_list;
-  mach_gettimeoffset   = amiga_gettimeoffset;
-  if (AMIGAHW_PRESENT(A3000_CLK)){
-    mach_gettod  = a3000_gettod;
-    rtc_resource.name = "A3000 RTC";
-    request_resource(&iomem_resource, &rtc_resource);
-  }
-  else{ /* if (AMIGAHW_PRESENT(A2000_CLK)) */
-    mach_gettod  = a2000_gettod;
-    rtc_resource.name = "A2000 RTC";
-    request_resource(&iomem_resource, &rtc_resource);
-  }
-
-  mach_max_dma_address = 0xffffffff; /*
-				      * default MAX_DMA=0xffffffff
-				      * on all machines. If we don't
-				      * do so, the SCSI code will not
-				      * be able to allocate any mem
-				      * for transfers, unless we are
-				      * dealing with a Z2 mem only
-				      * system.                  /Jes
-				      */
-
-  mach_hwclk           = amiga_hwclk;
-  mach_set_clock_mmss  = amiga_set_clock_mmss;
-  mach_reset           = amiga_reset;
-#ifdef CONFIG_HEARTBEAT
-  mach_heartbeat = amiga_heartbeat;
-#endif
-
-  /* Fill in the clock values (based on the 700 kHz E-Clock) */
-  amiga_masterclock = 40*amiga_eclock;	/* 28 MHz */
-  amiga_colorclock = 5*amiga_eclock;	/* 3.5 MHz */
-
-  /* clear all DMA bits */
-  amiga_custom.dmacon = DMAF_ALL;
-  /* ensure that the DMA master bit is set */
-  amiga_custom.dmacon = DMAF_SETCLR | DMAF_MASTER;
-
-  /* request all RAM */
-  for (i = 0; i < m68k_num_memory; i++) {
-    ram_resource[i].name =
-      (m68k_memory[i].addr >= 0x01000000) ? "32-bit Fast RAM" :
-      (m68k_memory[i].addr < 0x00c00000) ? "16-bit Fast RAM" :
-      "16-bit Slow RAM";
-    ram_resource[i].start = m68k_memory[i].addr;
-    ram_resource[i].end = m68k_memory[i].addr+m68k_memory[i].size-1;
-    request_resource(&iomem_resource, &ram_resource[i]);
-  }
-
-  /* initialize chipram allocator */
-  amiga_chip_init ();
-
-  /* debugging using chipram */
-  if (!strcmp( m68k_debug_device, "mem" )){
-	  if (!AMIGAHW_PRESENT(CHIP_RAM))
-		  printk("Warning: no chipram present for debugging\n");
-	  else {
-		  amiga_savekmsg_init();
-		  amiga_console_driver.write = amiga_mem_console_write;
-		  register_console(&amiga_console_driver);
-	  }
-  }
-
-  /* our beloved beeper */
-  if (AMIGAHW_PRESENT(AMI_AUDIO))
-	  amiga_init_sound();
-
-  /*
-   * if it is an A3000, set the magic bit that forces
-   * a hard rekick
-   */
-  if (AMIGAHW_PRESENT(MAGIC_REKICK))
-	  *(unsigned char *)ZTWO_VADDR(0xde0002) |= 0x80;
-}
-
-static unsigned short jiffy_ticks;
-
-static void __init amiga_sched_init(irqreturn_t (*timer_routine)(int, void *,
-						struct pt_regs *))
-{
-	static struct resource sched_res = {
-	    "timer", 0x00bfd400, 0x00bfd5ff,
-	};
-	jiffy_ticks = (amiga_eclock+HZ/2)/HZ;
-
-	if (request_resource(&mb_resources._ciab, &sched_res))
-	    printk("Cannot allocate ciab.ta{lo,hi}\n");
-	ciab.cra &= 0xC0;   /* turn off timer A, continuous mode, from Eclk */
-	ciab.talo = jiffy_ticks % 256;
-	ciab.tahi = jiffy_ticks / 256;
-
-	/* install interrupt service routine for CIAB Timer A
-	 *
-	 * Please don't change this to use ciaa, as it interferes with the
-	 * SCSI code. We'll have to take a look at this later
-	 */
-	request_irq(IRQ_AMIGA_CIAB_TA, timer_routine, 0, "timer", NULL);
-	/* start timer */
-	ciab.cra |= 0x11;
-}
-
-#define TICK_SIZE 10000
-
-extern unsigned char cia_get_irq_mask(unsigned int irq);
-
-/* This is always executed with interrupts disabled.  */
-static unsigned long amiga_gettimeoffset (void)
-{
-	unsigned short hi, lo, hi2;
-	unsigned long ticks, offset = 0;
-
-	/* read CIA B timer A current value */
-	hi  = ciab.tahi;
-	lo  = ciab.talo;
-	hi2 = ciab.tahi;
-
-	if (hi != hi2) {
-		lo = ciab.talo;
-		hi = hi2;
-	}
-
-	ticks = hi << 8 | lo;
-
-	if (ticks > jiffy_ticks / 2)
-		/* check for pending interrupt */
-		if (cia_get_irq_mask(IRQ_AMIGA_CIAB) & CIA_ICR_TA)
-			offset = 10000;
-
-	ticks = jiffy_ticks - ticks;
-	ticks = (10000 * ticks) / jiffy_ticks;
-
-	return ticks + offset;
-}
-
-static void a3000_gettod (int *yearp, int *monp, int *dayp,
-			  int *hourp, int *minp, int *secp)
-{
-	volatile struct tod3000 *tod = TOD_3000;
-
-	tod->cntrl1 = TOD3000_CNTRL1_HOLD;
-
-	*secp  = tod->second1 * 10 + tod->second2;
-	*minp  = tod->minute1 * 10 + tod->minute2;
-	*hourp = tod->hour1   * 10 + tod->hour2;
-	*dayp  = tod->day1    * 10 + tod->day2;
-	*monp  = tod->month1  * 10 + tod->month2;
-	*yearp = tod->year1   * 10 + tod->year2;
-
-	tod->cntrl1 = TOD3000_CNTRL1_FREE;
-}
-
-static void a2000_gettod (int *yearp, int *monp, int *dayp,
-			  int *hourp, int *minp, int *secp)
-{
-	volatile struct tod2000 *tod = TOD_2000;
-
-	tod->cntrl1 = TOD2000_CNTRL1_HOLD;
-
-	while (tod->cntrl1 & TOD2000_CNTRL1_BUSY)
-		;
-
-	*secp  = tod->second1     * 10 + tod->second2;
-	*minp  = tod->minute1     * 10 + tod->minute2;
-	*hourp = (tod->hour1 & 3) * 10 + tod->hour2;
-	*dayp  = tod->day1        * 10 + tod->day2;
-	*monp  = tod->month1      * 10 + tod->month2;
-	*yearp = tod->year1       * 10 + tod->year2;
-
-	if (!(tod->cntrl3 & TOD2000_CNTRL3_24HMODE)){
-		if (!(tod->hour1 & TOD2000_HOUR1_PM) && *hourp == 12)
-			*hourp = 0;
-		else if ((tod->hour1 & TOD2000_HOUR1_PM) && *hourp != 12)
-			*hourp += 12;
-	}
-
-	tod->cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-}
-
-static int amiga_hwclk(int op, struct hwclk_time *t)
-{
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		volatile struct tod3000 *tod = TOD_3000;
-
-		tod->cntrl1 = TOD3000_CNTRL1_HOLD;
-
-		if (!op) { /* read */
-			t->sec  = tod->second1 * 10 + tod->second2;
-			t->min  = tod->minute1 * 10 + tod->minute2;
-			t->hour = tod->hour1   * 10 + tod->hour2;
-			t->day  = tod->day1    * 10 + tod->day2;
-			t->wday = tod->weekday;
-			t->mon  = tod->month1  * 10 + tod->month2 - 1;
-			t->year = tod->year1   * 10 + tod->year2;
-			if (t->year <= 69)
-				t->year += 100;
-		} else {
-			tod->second1 = t->sec / 10;
-			tod->second2 = t->sec % 10;
-			tod->minute1 = t->min / 10;
-			tod->minute2 = t->min % 10;
-			tod->hour1   = t->hour / 10;
-			tod->hour2   = t->hour % 10;
-			tod->day1    = t->day / 10;
-			tod->day2    = t->day % 10;
-			if (t->wday != -1)
-				tod->weekday = t->wday;
-			tod->month1  = (t->mon + 1) / 10;
-			tod->month2  = (t->mon + 1) % 10;
-			if (t->year >= 100)
-				t->year -= 100;
-			tod->year1   = t->year / 10;
-			tod->year2   = t->year % 10;
-		}
-
-		tod->cntrl1 = TOD3000_CNTRL1_FREE;
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		volatile struct tod2000 *tod = TOD_2000;
-
-		tod->cntrl1 = TOD2000_CNTRL1_HOLD;
-	
-		while (tod->cntrl1 & TOD2000_CNTRL1_BUSY)
-			;
-
-		if (!op) { /* read */
-			t->sec  = tod->second1     * 10 + tod->second2;
-			t->min  = tod->minute1     * 10 + tod->minute2;
-			t->hour = (tod->hour1 & 3) * 10 + tod->hour2;
-			t->day  = tod->day1        * 10 + tod->day2;
-			t->wday = tod->weekday;
-			t->mon  = tod->month1      * 10 + tod->month2 - 1;
-			t->year = tod->year1       * 10 + tod->year2;
-			if (t->year <= 69)
-				t->year += 100;
-
-			if (!(tod->cntrl3 & TOD2000_CNTRL3_24HMODE)){
-				if (!(tod->hour1 & TOD2000_HOUR1_PM) && t->hour == 12)
-					t->hour = 0;
-				else if ((tod->hour1 & TOD2000_HOUR1_PM) && t->hour != 12)
-					t->hour += 12;
-			}
-		} else {
-			tod->second1 = t->sec / 10;
-			tod->second2 = t->sec % 10;
-			tod->minute1 = t->min / 10;
-			tod->minute2 = t->min % 10;
-			if (tod->cntrl3 & TOD2000_CNTRL3_24HMODE)
-				tod->hour1 = t->hour / 10;
-			else if (t->hour >= 12)
-				tod->hour1 = TOD2000_HOUR1_PM +
-					(t->hour - 12) / 10;
-			else
-				tod->hour1 = t->hour / 10;
-			tod->hour2   = t->hour % 10;
-			tod->day1    = t->day / 10;
-			tod->day2    = t->day % 10;
-			if (t->wday != -1)
-				tod->weekday = t->wday;
-			tod->month1  = (t->mon + 1) / 10;
-			tod->month2  = (t->mon + 1) % 10;
-			if (t->year >= 100)
-				t->year -= 100;
-			tod->year1   = t->year / 10;
-			tod->year2   = t->year % 10;
-		}
-
-		tod->cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-	}
-
-	return 0;
-}
-
-static int amiga_set_clock_mmss (unsigned long nowtime)
-{
-	short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;
-
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		volatile struct tod3000 *tod = TOD_3000;
-
-		tod->cntrl1 = TOD3000_CNTRL1_HOLD;
-
-		tod->second1 = real_seconds / 10;
-		tod->second2 = real_seconds % 10;
-		tod->minute1 = real_minutes / 10;
-		tod->minute2 = real_minutes % 10;
-
-		tod->cntrl1 = TOD3000_CNTRL1_FREE;
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		volatile struct tod2000 *tod = TOD_2000;
-
-		tod->cntrl1 = TOD2000_CNTRL1_HOLD;
-	
-		while (tod->cntrl1 & TOD2000_CNTRL1_BUSY)
-			;
-
-		tod->second1 = real_seconds / 10;
-		tod->second2 = real_seconds % 10;
-		tod->minute1 = real_minutes / 10;
-		tod->minute2 = real_minutes % 10;
-
-		tod->cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-	}
-
-	return 0;
-}
-
-static NORET_TYPE void amiga_reset( void )
-    ATTRIB_NORET;
-
-static void amiga_reset (void)
-{
-  for (;;);
-}
-
-
-    /*
-     *  Debugging
-     */
-
-#define SAVEKMSG_MAXMEM		128*1024
-
-#define SAVEKMSG_MAGIC1		0x53415645	/* 'SAVE' */
-#define SAVEKMSG_MAGIC2		0x4B4D5347	/* 'KMSG' */
-
-struct savekmsg {
-    unsigned long magic1;		/* SAVEKMSG_MAGIC1 */
-    unsigned long magic2;		/* SAVEKMSG_MAGIC2 */
-    unsigned long magicptr;		/* address of magic1 */
-    unsigned long size;
-    char data[0];
-};
-
-static struct savekmsg *savekmsg = NULL;
-
-static void amiga_mem_console_write(struct console *co, const char *s,
-				    unsigned int count)
-{
-    if (savekmsg->size+count <= SAVEKMSG_MAXMEM-sizeof(struct savekmsg)) {
-        memcpy(savekmsg->data+savekmsg->size, s, count);
-        savekmsg->size += count;
-    }
-}
-
-static void amiga_savekmsg_init(void)
-{
-    static struct resource debug_res = { "Debug" };
-
-    savekmsg = amiga_chip_alloc_res(SAVEKMSG_MAXMEM, &debug_res);
-    savekmsg->magic1 = SAVEKMSG_MAGIC1;
-    savekmsg->magic2 = SAVEKMSG_MAGIC2;
-    savekmsg->magicptr = virt_to_phys(savekmsg);
-    savekmsg->size = 0;
-}
-
-static void amiga_serial_putc(char c)
-{
-    amiga_custom.serdat = (unsigned char)c | 0x100;
-    mb();
-    while (!(amiga_custom.serdatr & 0x2000))
-       ;
-}
-
-void amiga_serial_console_write(struct console *co, const char *s,
-				       unsigned int count)
-{
-	while (count--) {
-		if (*s == '\n')
-			amiga_serial_putc('\r');
-		amiga_serial_putc(*s++);
-	}
-}
-
-#ifdef CONFIG_SERIAL_CONSOLE
-void amiga_serial_puts(const char *s)
-{
-    amiga_serial_console_write(NULL, s, strlen(s));
-}
-
-int amiga_serial_console_wait_key(struct console *co)
-{
-    int ch;
-
-    while (!(amiga_custom.intreqr & IF_RBF))
-	barrier();
-    ch = amiga_custom.serdatr & 0xff;
-    /* clear the interrupt, so that another character can be read */
-    amiga_custom.intreq = IF_RBF;
-    return ch;
-}
-
-void amiga_serial_gets(struct console *co, char *s, int len)
-{
-    int ch, cnt = 0;
-
-    while (1) {
-	ch = amiga_serial_console_wait_key(co);
-
-	/* Check for backspace. */
-	if (ch == 8 || ch == 127) {
-	    if (cnt == 0) {
-		amiga_serial_putc('\007');
-		continue;
-	    }
-	    cnt--;
-	    amiga_serial_puts("\010 \010");
-	    continue;
-	}
-
-	/* Check for enter. */
-	if (ch == 10 || ch == 13)
-	    break;
-
-	/* See if line is too long. */
-	if (cnt >= len + 1) {
-	    amiga_serial_putc(7);
-	    cnt--;
-	    continue;
-	}
-
-	/* Store and echo character. */
-	s[cnt++] = ch;
-	amiga_serial_putc(ch);
-    }
-    /* Print enter. */
-    amiga_serial_puts("\r\n");
-    s[cnt] = 0;
-}
-#endif
-
-static void __init amiga_debug_init(void)
-{
-	if (!strcmp( m68k_debug_device, "ser" )) {
-		/* no initialization required (?) */
-		amiga_console_driver.write = amiga_serial_console_write;
-		register_console(&amiga_console_driver);
-	}
-}
-
-#ifdef CONFIG_HEARTBEAT
-static void amiga_heartbeat(int on)
-{
-    if (on)
-	ciaa.pra &= ~2;
-    else
-	ciaa.pra |= 2;
-}
-#endif
-
-    /*
-     *  Amiga specific parts of /proc
-     */
-
-static void amiga_get_model(char *model)
-{
-    strcpy(model, amiga_model_name);
-}
-
-
-static int amiga_get_hardware_list(char *buffer)
-{
-    int len = 0;
-
-    if (AMIGAHW_PRESENT(CHIP_RAM))
-	len += sprintf(buffer+len, "Chip RAM:\t%ldK\n", amiga_chip_size>>10);
-    len += sprintf(buffer+len, "PS Freq:\t%dHz\nEClock Freq:\t%ldHz\n",
-		   amiga_psfreq, amiga_eclock);
-    if (AMIGAHW_PRESENT(AMI_VIDEO)) {
-	char *type;
-	switch(amiga_chipset) {
-	    case CS_OCS:
-		type = "OCS";
-		break;
-	    case CS_ECS:
-		type = "ECS";
-		break;
-	    case CS_AGA:
-		type = "AGA";
-		break;
-	    default:
-		type = "Old or Unknown";
-		break;
-	}
-	len += sprintf(buffer+len, "Graphics:\t%s\n", type);
-    }
-
-#define AMIGAHW_ANNOUNCE(name, str)			\
-    if (AMIGAHW_PRESENT(name))				\
-	len += sprintf (buffer+len, "\t%s\n", str)
-
-    len += sprintf (buffer + len, "Detected hardware:\n");
-
-    AMIGAHW_ANNOUNCE(AMI_VIDEO, "Amiga Video");
-    AMIGAHW_ANNOUNCE(AMI_BLITTER, "Blitter");
-    AMIGAHW_ANNOUNCE(AMBER_FF, "Amber Flicker Fixer");
-    AMIGAHW_ANNOUNCE(AMI_AUDIO, "Amiga Audio");
-    AMIGAHW_ANNOUNCE(AMI_FLOPPY, "Floppy Controller");
-    AMIGAHW_ANNOUNCE(A3000_SCSI, "SCSI Controller WD33C93 (A3000 style)");
-    AMIGAHW_ANNOUNCE(A4000_SCSI, "SCSI Controller NCR53C710 (A4000T style)");
-    AMIGAHW_ANNOUNCE(A1200_IDE, "IDE Interface (A1200 style)");
-    AMIGAHW_ANNOUNCE(A4000_IDE, "IDE Interface (A4000 style)");
-    AMIGAHW_ANNOUNCE(CD_ROM, "Internal CD ROM drive");
-    AMIGAHW_ANNOUNCE(AMI_KEYBOARD, "Keyboard");
-    AMIGAHW_ANNOUNCE(AMI_MOUSE, "Mouse Port");
-    AMIGAHW_ANNOUNCE(AMI_SERIAL, "Serial Port");
-    AMIGAHW_ANNOUNCE(AMI_PARALLEL, "Parallel Port");
-    AMIGAHW_ANNOUNCE(A2000_CLK, "Hardware Clock (A2000 style)");
-    AMIGAHW_ANNOUNCE(A3000_CLK, "Hardware Clock (A3000 style)");
-    AMIGAHW_ANNOUNCE(CHIP_RAM, "Chip RAM");
-    AMIGAHW_ANNOUNCE(PAULA, "Paula 8364");
-    AMIGAHW_ANNOUNCE(DENISE, "Denise 8362");
-    AMIGAHW_ANNOUNCE(DENISE_HR, "Denise 8373");
-    AMIGAHW_ANNOUNCE(LISA, "Lisa 8375");
-    AMIGAHW_ANNOUNCE(AGNUS_PAL, "Normal/Fat PAL Agnus 8367/8371");
-    AMIGAHW_ANNOUNCE(AGNUS_NTSC, "Normal/Fat NTSC Agnus 8361/8370");
-    AMIGAHW_ANNOUNCE(AGNUS_HR_PAL, "Fat Hires PAL Agnus 8372");
-    AMIGAHW_ANNOUNCE(AGNUS_HR_NTSC, "Fat Hires NTSC Agnus 8372");
-    AMIGAHW_ANNOUNCE(ALICE_PAL, "PAL Alice 8374");
-    AMIGAHW_ANNOUNCE(ALICE_NTSC, "NTSC Alice 8374");
-    AMIGAHW_ANNOUNCE(MAGIC_REKICK, "Magic Hard Rekick");
-    AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA Slot");
-    if (AMIGAHW_PRESENT(ZORRO))
-	len += sprintf(buffer+len, "\tZorro II%s AutoConfig: %d Expansion "
-				   "Device%s\n",
-		       AMIGAHW_PRESENT(ZORRO3) ? "I" : "",
-		       zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
-
-#undef AMIGAHW_ANNOUNCE
-
-    return(len);
-}
-
-#ifdef CONFIG_APUS
-int get_hardware_list(char *buffer)
-{
-	extern int get_cpuinfo(char *buffer);
-	int len = 0;
-	char model[80];
-	u_long mem;
-	int i;
-
-	if (mach_get_model)
-		mach_get_model(model);
-	else
-		strcpy(model, "Unknown PowerPC");
-
-	len += sprintf(buffer+len, "Model:\t\t%s\n", model);
-	len += get_cpuinfo(buffer+len);
-	for (mem = 0, i = 0; i < m68k_realnum_memory; i++)
-		mem += m68k_memory[i].size;
-	len += sprintf(buffer+len, "System Memory:\t%ldK\n", mem>>10);
-
-	if (mach_get_hardware_list)
-		len += mach_get_hardware_list(buffer+len);
-
-	return(len);
-}
-#endif
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/time.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,57 +0,0 @@
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-
-#include <asm/machdep.h>
-#include <asm/io.h>
-
-#include <linux/timex.h>
-
-unsigned long m68k_get_rtc_time(void)
-{
-	unsigned int year, mon, day, hour, min, sec;
-
-	extern void arch_gettod(int *year, int *mon, int *day, int *hour,
-				int *min, int *sec);
-
-	arch_gettod (&year, &mon, &day, &hour, &min, &sec);
-
-	if ((year += 1900) < 1970)
-		year += 100;
-
-	return mktime(year, mon, day, hour, min, sec);
-}
-
-int m68k_set_rtc_time(unsigned long nowtime)
-{
-  if (mach_set_clock_mmss)
-    return mach_set_clock_mmss (nowtime);
-  return -1;
-}
-
-void apus_heartbeat (void)
-{
-#ifdef CONFIG_HEARTBEAT
-	static unsigned cnt = 0, period = 0, dist = 0;
-
-	if (cnt == 0 || cnt == dist)
-                mach_heartbeat( 1 );
-	else if (cnt == 7 || cnt == dist+7)
-                mach_heartbeat( 0 );
-
-	if (++cnt > period) {
-                cnt = 0;
-                /* The hyperbolic function below modifies the heartbeat period
-                 * length in dependency of the current (5min) load. It goes
-                 * through the points f(0)=126, f(1)=86, f(5)=51,
-                 * f(inf)->30. */
-                period = ((672<<FSHIFT)/(5*avenrun[0]+(7<<FSHIFT))) + 30;
-                dist = period / 4;
-	}
-#endif
-	/* should be made smarter */
-	ppc_md.heartbeat_count = 1;
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/bootinfo.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,78 +0,0 @@
-/*
- *  Extracted from arch/m68k/kernel/setup.c.
- *  Should be properly generalized and put somewhere else.
- *                              Jesper
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/init.h>
-
-#include <asm/setup.h>
-#include <asm/bootinfo.h>
-
-extern char cmd_line[CL_SIZE];
-
-extern int num_memory;
-extern int m68k_realnum_memory;
-extern struct mem_info memory[NUM_MEMINFO];
-extern struct mem_info m68k_memory[NUM_MEMINFO];
-extern struct mem_info ramdisk;
-
-extern int amiga_parse_bootinfo(const struct bi_record *);
-extern int atari_parse_bootinfo(const struct bi_record *);
-extern int mac_parse_bootinfo(const struct bi_record *);
-
-void __init parse_bootinfo(const struct bi_record *record)
-{
-    while (record->tag != BI_LAST) {
-	int unknown = 0;
-	const u_long *data = record->data;
-	switch (record->tag) {
-	    case BI_MACHTYPE:
-	    case BI_CPUTYPE:
-	    case BI_FPUTYPE:
-	    case BI_MMUTYPE:
-		/* Already set up by head.S */
-		break;
-
-	    case BI_MEMCHUNK:
-		if (num_memory < NUM_MEMINFO) {
-		    memory[num_memory].addr = data[0];
-		    memory[num_memory].size = data[1];
-		    num_memory++;
-
-		    /* FIXME: duplicate for m68k drivers. */
-		    m68k_memory[m68k_realnum_memory].addr = data[0];
-		    m68k_memory[m68k_realnum_memory].size = data[1];
-		    m68k_realnum_memory++;
-		} else
-		    printk("parse_bootinfo: too many memory chunks\n");
-		break;
-
-	    case BI_RAMDISK:
-		ramdisk.addr = data[0];
-		ramdisk.size = data[1];
-		break;
-
-	    case BI_COMMAND_LINE:
-		strlcpy(cmd_line, (const char *)data, sizeof(cmd_line));
-		break;
-
-	    default:
-		if (MACH_IS_AMIGA)
-		    unknown = amiga_parse_bootinfo(record);
-		else if (MACH_IS_ATARI)
-		    unknown = atari_parse_bootinfo(record);
-		else if (MACH_IS_MAC)
-		    unknown = mac_parse_bootinfo(record);
-		else
-		    unknown = 1;
-	}
-	if (unknown)
-	    printk("parse_bootinfo: unknown tag 0x%04x ignored\n",
-		   record->tag);
-	record = (struct bi_record *)((u_long)record+record->size);
-    }
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/amiga/ints.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,158 +0,0 @@
-/*
- *  Linux/m68k general interrupt handling code from arch/m68k/kernel/ints.c
- *  Needed to drive the m68k emulating IRQ hardware on the PowerUp boards.
- */
-
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/seq_file.h>
-
-#include <asm/setup.h>
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/page.h>
-#include <asm/machdep.h>
-
-/* table for system interrupt handlers */
-static irq_handler_t irq_list[SYS_IRQS];
-
-static const char *default_names[SYS_IRQS] = {
-	"spurious int", "int1 handler", "int2 handler", "int3 handler",
-	"int4 handler", "int5 handler", "int6 handler", "int7 handler"
-};
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-#define NUM_IRQ_NODES 100
-static irq_node_t nodes[NUM_IRQ_NODES];
-
-
-/*
- * void init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the IRQ handling routines.
- */
-
-__init
-void m68k_init_IRQ(void)
-{
-	int i;
-
-	for (i = 0; i < SYS_IRQS; i++) {
-		if (mach_default_handler)
-			irq_list[i].handler = (*mach_default_handler)[i];
-		irq_list[i].flags   = 0;
-		irq_list[i].dev_id  = NULL;
-		irq_list[i].devname = default_names[i];
-	}
-
-	for (i = 0; i < NUM_IRQ_NODES; i++)
-		nodes[i].handler = NULL;
-
-	mach_init_IRQ ();
-}
-
-irq_node_t *new_irq_node(void)
-{
-	irq_node_t *node;
-	short i;
-
-	for (node = nodes, i = NUM_IRQ_NODES-1; i >= 0; node++, i--)
-		if (!node->handler)
-			return node;
-
-	printk ("new_irq_node: out of nodes\n");
-	return NULL;
-}
-
-int sys_request_irq(unsigned int irq,
-                    void (*handler)(int, void *, struct pt_regs *),
-                    unsigned long flags, const char *devname, void *dev_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, devname);
-		return -ENXIO;
-	}
-
-#if 0
-	if (!(irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk("%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (!(flags & IRQ_FLG_REPLACE)) {
-			printk("%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-#endif
-
-	irq_list[irq].handler = handler;
-	irq_list[irq].flags   = flags;
-	irq_list[irq].dev_id  = dev_id;
-	irq_list[irq].devname = devname;
-	return 0;
-}
-
-void sys_free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (irq_list[irq].dev_id != dev_id)
-		printk("%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq].devname);
-
-	irq_list[irq].handler = (*mach_default_handler)[irq];
-	irq_list[irq].flags   = 0;
-	irq_list[irq].dev_id  = NULL;
-	irq_list[irq].devname = default_names[irq];
-}
-
-asmlinkage void process_int(unsigned long vec, struct pt_regs *fp)
-{
-	if (vec >= VEC_INT1 && vec <= VEC_INT7 && !MACH_IS_BVME6000) {
-		vec -= VEC_SPUR;
-		kstat_cpu(0).irqs[vec]++;
-		irq_list[vec].handler(vec, irq_list[vec].dev_id, fp);
-	} else {
-		if (mach_process_int)
-			mach_process_int(vec, fp);
-		else
-			panic("Can't process interrupt vector %ld\n", vec);
-		return;
-	}
-}
-
-int m68k_get_irq_list(struct seq_file *p, void *v)
-{
-	int i;
-
-	/* autovector interrupts */
-	if (mach_default_handler) {
-		for (i = 0; i < SYS_IRQS; i++) {
-			seq_printf(p, "auto %2d: %10u ", i,
-			               i ? kstat_cpu(0).irqs[i] : num_spurious);
-			seq_puts(p, "  ");
-			seq_printf(p, "%s\n", irq_list[i].devname);
-		}
-	}
-
-	mach_get_irq_list(p, v);
-	return 0;
-}
--- linux-2.6.22-rc6-mm1/arch/ppc/configs/apus_defconfig	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,920 +0,0 @@
-#
-# Automatically generated make config: don't edit
-#
-CONFIG_MMU=y
-CONFIG_RWSEM_XCHGADD_ALGORITHM=y
-CONFIG_HAVE_DEC_LOCK=y
-
-#
-# Code maturity level options
-#
-CONFIG_EXPERIMENTAL=y
-
-#
-# General setup
-#
-CONFIG_SWAP=y
-CONFIG_SYSVIPC=y
-# CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_EMBEDDED is not set
-CONFIG_FUTEX=y
-CONFIG_EPOLL=y
-
-#
-# Loadable module support
-#
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-CONFIG_MODULE_FORCE_UNLOAD=y
-CONFIG_OBSOLETE_MODPARM=y
-# CONFIG_MODVERSIONS is not set
-CONFIG_KMOD=y
-
-#
-# Platform support
-#
-CONFIG_PPC=y
-CONFIG_PPC32=y
-CONFIG_6xx=y
-# CONFIG_40x is not set
-# CONFIG_POWER3 is not set
-# CONFIG_8xx is not set
-
-#
-# IBM 4xx options
-#
-# CONFIG_8260 is not set
-CONFIG_GENERIC_ISA_DMA=y
-CONFIG_PPC_STD_MMU=y
-CONFIG_SERIAL_CONSOLE=y
-# CONFIG_PPC_MULTIPLATFORM is not set
-CONFIG_APUS=y
-# CONFIG_WILLOW_2 is not set
-# CONFIG_PCORE is not set
-# CONFIG_POWERPMC250 is not set
-# CONFIG_EV64260 is not set
-# CONFIG_SPRUCE is not set
-# CONFIG_LOPEC is not set
-# CONFIG_MCPN765 is not set
-# CONFIG_MVME5100 is not set
-# CONFIG_PPLUS is not set
-# CONFIG_PRPMC750 is not set
-# CONFIG_PRPMC800 is not set
-# CONFIG_SANDPOINT is not set
-# CONFIG_ADIR is not set
-# CONFIG_K2 is not set
-# CONFIG_PAL4 is not set
-# CONFIG_GEMINI is not set
-# CONFIG_SMP is not set
-# CONFIG_PREEMPT is not set
-# CONFIG_ALTIVEC is not set
-# CONFIG_TAU is not set
-# CONFIG_CPU_FREQ is not set
-
-#
-# General setup
-#
-# CONFIG_HIGHMEM is not set
-CONFIG_PCI=y
-CONFIG_PCI_DOMAINS=y
-CONFIG_PCI_PERMEDIA=y
-CONFIG_KCORE_ELF=y
-CONFIG_BINFMT_ELF=y
-CONFIG_KERNEL_ELF=y
-CONFIG_BINFMT_MISC=m
-CONFIG_PCI_LEGACY_PROC=y
-CONFIG_PCI_NAMES=y
-# CONFIG_HOTPLUG is not set
-
-#
-# Parallel port support
-#
-CONFIG_PARPORT=m
-# CONFIG_PARPORT_PC is not set
-CONFIG_PARPORT_AMIGA=m
-# CONFIG_PARPORT_MFC3 is not set
-# CONFIG_PARPORT_OTHER is not set
-# CONFIG_PARPORT_1284 is not set
-CONFIG_PPC601_SYNC_FIX=y
-# CONFIG_CMDLINE_BOOL is not set
-CONFIG_AMIGA=y
-CONFIG_ZORRO=y
-CONFIG_ABSTRACT_CONSOLE=y
-CONFIG_APUS_FAST_EXCEPT=y
-CONFIG_AMIGA_PCMCIA=y
-CONFIG_AMIGA_BUILTIN_SERIAL=y
-CONFIG_GVPIOEXT=y
-CONFIG_GVPIOEXT_LP=m
-CONFIG_GVPIOEXT_PLIP=m
-CONFIG_MULTIFACE_III_TTY=y
-CONFIG_A2232=y
-CONFIG_WHIPPET_SERIAL=y
-CONFIG_APNE=y
-CONFIG_HEARTBEAT=y
-CONFIG_PROC_HARDWARE=y
-CONFIG_ZORRO_NAMES=y
-
-#
-# Advanced setup
-#
-# CONFIG_ADVANCED_OPTIONS is not set
-
-#
-# Default settings for advanced configuration options are used
-#
-CONFIG_HIGHMEM_START=0xfe000000
-CONFIG_LOWMEM_SIZE=0x30000000
-CONFIG_KERNEL_START=0xc0000000
-CONFIG_TASK_SIZE=0x80000000
-CONFIG_BOOT_LOAD=0x00800000
-
-#
-# Memory Technology Devices (MTD)
-#
-# CONFIG_MTD is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNP is not set
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_FD is not set
-CONFIG_AMIGA_FLOPPY=y
-CONFIG_AMIGA_Z2RAM=m
-# CONFIG_PARIDE is not set
-# CONFIG_BLK_CPQ_DA is not set
-# CONFIG_BLK_CPQ_CISS_DA is not set
-# CONFIG_BLK_DEV_DAC960 is not set
-# CONFIG_BLK_DEV_UMEM is not set
-CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_NBD=m
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_INITRD=y
-
-#
-# Multi-device support (RAID and LVM)
-#
-CONFIG_MD=y
-CONFIG_BLK_DEV_MD=m
-CONFIG_MD_LINEAR=m
-CONFIG_MD_RAID0=m
-CONFIG_MD_RAID1=m
-CONFIG_MD_RAID5=m
-# CONFIG_MD_MULTIPATH is not set
-CONFIG_BLK_DEV_DM=m
-
-#
-# ATA/IDE/MFM/RLL support
-#
-CONFIG_IDE=y
-
-#
-# IDE, ATA and ATAPI Block devices
-#
-CONFIG_BLK_DEV_IDE=y
-
-#
-# Please see Documentation/ide.txt for help/info on IDE drives
-#
-# CONFIG_BLK_DEV_HD is not set
-CONFIG_BLK_DEV_IDEDISK=y
-# CONFIG_IDEDISK_MULTI_MODE is not set
-# CONFIG_IDEDISK_STROKE is not set
-CONFIG_BLK_DEV_IDECD=y
-CONFIG_BLK_DEV_IDEFLOPPY=y
-CONFIG_BLK_DEV_IDESCSI=m
-# CONFIG_IDE_TASK_IOCTL is not set
-
-#
-# IDE chipset support/bugfixes
-#
-# CONFIG_BLK_DEV_IDEPCI is not set
-CONFIG_BLK_DEV_GAYLE=y
-CONFIG_BLK_DEV_IDEDOUBLER=y
-CONFIG_BLK_DEV_BUDDHA=y
-
-#
-# SCSI support
-#
-CONFIG_SCSI=y
-
-#
-# SCSI support type (disk, tape, CD-ROM)
-#
-CONFIG_BLK_DEV_SD=y
-CONFIG_CHR_DEV_ST=m
-CONFIG_CHR_DEV_OSST=m
-CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
-CONFIG_CHR_DEV_SG=m
-
-#
-# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
-#
-# CONFIG_SCSI_MULTI_LUN is not set
-# CONFIG_SCSI_REPORT_LUNS is not set
-CONFIG_SCSI_CONSTANTS=y
-CONFIG_SCSI_LOGGING=y
-
-#
-# SCSI low-level drivers
-#
-# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
-# CONFIG_SCSI_ACARD is not set
-# CONFIG_SCSI_AACRAID is not set
-# CONFIG_SCSI_AIC7XXX is not set
-# CONFIG_SCSI_AIC7XXX_OLD is not set
-# CONFIG_SCSI_AIC79XX is not set
-# CONFIG_SCSI_DPT_I2O is not set
-# CONFIG_SCSI_ADVANSYS is not set
-# CONFIG_SCSI_IN2000 is not set
-# CONFIG_SCSI_AM53C974 is not set
-# CONFIG_SCSI_MEGARAID is not set
-# CONFIG_SCSI_BUSLOGIC is not set
-# CONFIG_SCSI_CPQFCTS is not set
-# CONFIG_SCSI_DMX3191D is not set
-# CONFIG_SCSI_EATA is not set
-# CONFIG_SCSI_EATA_PIO is not set
-# CONFIG_SCSI_FUTURE_DOMAIN is not set
-# CONFIG_SCSI_GDTH is not set
-# CONFIG_SCSI_GENERIC_NCR5380 is not set
-# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
-# CONFIG_SCSI_INITIO is not set
-# CONFIG_SCSI_INIA100 is not set
-# CONFIG_SCSI_PPA is not set
-# CONFIG_SCSI_IMM is not set
-# CONFIG_SCSI_NCR53C7xx is not set
-# CONFIG_SCSI_SYM53C8XX_2 is not set
-# CONFIG_SCSI_NCR53C8XX is not set
-# CONFIG_SCSI_SYM53C8XX is not set
-# CONFIG_SCSI_PCI2000 is not set
-# CONFIG_SCSI_PCI2220I is not set
-# CONFIG_SCSI_QLOGIC_ISP is not set
-# CONFIG_SCSI_QLOGIC_FC is not set
-# CONFIG_SCSI_QLOGIC_1280 is not set
-# CONFIG_SCSI_DC395x is not set
-# CONFIG_SCSI_DC390T is not set
-# CONFIG_SCSI_U14_34F is not set
-# CONFIG_SCSI_NSP32 is not set
-# CONFIG_SCSI_DEBUG is not set
-CONFIG_A3000_SCSI=y
-CONFIG_A4000T_SCSI=y
-CONFIG_A2091_SCSI=y
-CONFIG_GVP11_SCSI=y
-CONFIG_CYBERSTORM_SCSI=y
-CONFIG_CYBERSTORMII_SCSI=y
-CONFIG_BLZ2060_SCSI=y
-CONFIG_BLZ1230_SCSI=y
-CONFIG_FASTLANE_SCSI=y
-CONFIG_A4091_SCSI=y
-CONFIG_WARPENGINE_SCSI=y
-CONFIG_BLZ603EPLUS_SCSI=y
-CONFIG_OKTAGON_SCSI=y
-
-#
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support (EXPERIMENTAL)
-#
-# CONFIG_IEEE1394 is not set
-
-#
-# I2O device support
-#
-# CONFIG_I2O is not set
-
-#
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=m
-CONFIG_PACKET_MMAP=y
-CONFIG_NETLINK_DEV=m
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_INET_ECN is not set
-CONFIG_SYN_COOKIES=y
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-
-#
-# IP: Netfilter Configuration
-#
-CONFIG_IP_NF_CONNTRACK=m
-CONFIG_IP_NF_FTP=m
-CONFIG_IP_NF_IRC=m
-CONFIG_IP_NF_TFTP=m
-CONFIG_IP_NF_AMANDA=m
-CONFIG_IP_NF_QUEUE=m
-CONFIG_IP_NF_IPTABLES=m
-CONFIG_IP_NF_MATCH_LIMIT=m
-CONFIG_IP_NF_MATCH_MAC=m
-# CONFIG_IP_NF_MATCH_PKTTYPE is not set
-CONFIG_IP_NF_MATCH_MARK=m
-CONFIG_IP_NF_MATCH_MULTIPORT=m
-CONFIG_IP_NF_MATCH_TOS=m
-# CONFIG_IP_NF_MATCH_ECN is not set
-# CONFIG_IP_NF_MATCH_DSCP is not set
-# CONFIG_IP_NF_MATCH_AH_ESP is not set
-CONFIG_IP_NF_MATCH_LENGTH=m
-CONFIG_IP_NF_MATCH_TTL=m
-CONFIG_IP_NF_MATCH_TCPMSS=m
-CONFIG_IP_NF_MATCH_HELPER=m
-CONFIG_IP_NF_MATCH_STATE=m
-CONFIG_IP_NF_MATCH_CONNTRACK=m
-CONFIG_IP_NF_MATCH_UNCLEAN=m
-CONFIG_IP_NF_MATCH_OWNER=m
-CONFIG_IP_NF_FILTER=m
-CONFIG_IP_NF_TARGET_REJECT=m
-CONFIG_IP_NF_TARGET_MIRROR=m
-CONFIG_IP_NF_NAT=m
-CONFIG_IP_NF_NAT_NEEDED=y
-CONFIG_IP_NF_TARGET_MASQUERADE=m
-CONFIG_IP_NF_TARGET_REDIRECT=m
-CONFIG_IP_NF_NAT_SNMP_BASIC=m
-CONFIG_IP_NF_NAT_IRC=m
-CONFIG_IP_NF_NAT_FTP=m
-CONFIG_IP_NF_NAT_TFTP=m
-CONFIG_IP_NF_NAT_AMANDA=m
-CONFIG_IP_NF_MANGLE=m
-CONFIG_IP_NF_TARGET_TOS=m
-CONFIG_IP_NF_TARGET_ECN=m
-CONFIG_IP_NF_TARGET_DSCP=m
-CONFIG_IP_NF_TARGET_MARK=m
-CONFIG_IP_NF_TARGET_LOG=m
-CONFIG_IP_NF_TARGET_ULOG=m
-CONFIG_IP_NF_TARGET_TCPMSS=m
-CONFIG_IP_NF_ARPTABLES=m
-CONFIG_IP_NF_ARPFILTER=m
-CONFIG_IP_NF_COMPAT_IPCHAINS=m
-# CONFIG_IP_NF_COMPAT_IPFWADM is not set
-# CONFIG_IPV6 is not set
-# CONFIG_XFRM_USER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-CONFIG_IPV6_SCTP__=y
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_LLC is not set
-# CONFIG_DECNET is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_HW_FLOWCONTROL is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-CONFIG_NETDEVICES=y
-
-#
-# ARCnet devices
-#
-# CONFIG_ARCNET is not set
-CONFIG_DUMMY=m
-# CONFIG_BONDING is not set
-# CONFIG_EQUALIZER is not set
-CONFIG_TUN=m
-# CONFIG_ETHERTAP is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
-CONFIG_NET_ETHERNET=y
-# CONFIG_MII is not set
-# CONFIG_OAKNET is not set
-CONFIG_ARIADNE=y
-# CONFIG_ZORRO8390 is not set
-CONFIG_A2065=y
-CONFIG_HYDRA=y
-# CONFIG_HAPPYMEAL is not set
-# CONFIG_SUNGEM is not set
-# CONFIG_NET_VENDOR_3COM is not set
-
-#
-# Tulip family network device support
-#
-# CONFIG_NET_TULIP is not set
-# CONFIG_HP100 is not set
-# CONFIG_NET_PCI is not set
-
-#
-# Ethernet (1000 Mbit)
-#
-# CONFIG_ACENIC is not set
-# CONFIG_DL2K is not set
-# CONFIG_E1000 is not set
-# CONFIG_NS83820 is not set
-# CONFIG_HAMACHI is not set
-# CONFIG_YELLOWFIN is not set
-# CONFIG_R8169 is not set
-# CONFIG_SK98LIN is not set
-# CONFIG_TIGON3 is not set
-
-#
-# Ethernet (10000 Mbit)
-#
-# CONFIG_IXGB is not set
-# CONFIG_FDDI is not set
-# CONFIG_HIPPI is not set
-CONFIG_PLIP=m
-CONFIG_PPP=y
-CONFIG_PPP_MULTILINK=y
-CONFIG_PPP_FILTER=y
-CONFIG_PPP_ASYNC=y
-CONFIG_PPP_SYNC_TTY=y
-CONFIG_PPP_DEFLATE=y
-CONFIG_PPP_BSDCOMP=y
-CONFIG_PPPOE=y
-CONFIG_SLIP=y
-CONFIG_SLIP_COMPRESSED=y
-CONFIG_SLIP_SMART=y
-CONFIG_SLIP_MODE_SLIP6=y
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Token Ring devices (depends on LLC=y)
-#
-# CONFIG_NET_FC is not set
-# CONFIG_RCPCI is not set
-# CONFIG_SHAPER is not set
-
-#
-# Wan interfaces
-#
-# CONFIG_WAN is not set
-
-#
-# Amateur Radio support
-#
-# CONFIG_HAMRADIO is not set
-
-#
-# IrDA (infrared) support
-#
-# CONFIG_IRDA is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN_BOOL is not set
-
-#
-# Graphics support
-#
-CONFIG_FB=y
-# CONFIG_FB_CIRRUS is not set
-CONFIG_FB_PM2=y
-# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
-# CONFIG_FB_PM2_PCI is not set
-CONFIG_FB_PM2_CVPPC=y
-CONFIG_FB_CYBER2000=y
-CONFIG_FB_AMIGA=y
-CONFIG_FB_AMIGA_OCS=y
-CONFIG_FB_AMIGA_ECS=y
-CONFIG_FB_AMIGA_AGA=y
-CONFIG_FB_CYBER=y
-CONFIG_FB_VIRGE=y
-CONFIG_FB_RETINAZ3=y
-CONFIG_FB_FM2=y
-# CONFIG_FB_CT65550 is not set
-# CONFIG_FB_IMSTT is not set
-# CONFIG_FB_S3TRIO is not set
-# CONFIG_FB_VGA16 is not set
-# CONFIG_FB_RIVA is not set
-# CONFIG_FB_MATROX is not set
-# CONFIG_FB_RADEON is not set
-# CONFIG_FB_ATY128 is not set
-# CONFIG_FB_ATY is not set
-# CONFIG_FB_SIS is not set
-# CONFIG_FB_NEOMAGIC is not set
-# CONFIG_FB_3DFX is not set
-# CONFIG_FB_VOODOO1 is not set
-# CONFIG_FB_TRIDENT is not set
-# CONFIG_FB_PM3 is not set
-# CONFIG_FB_VIRTUAL is not set
-
-#
-# Logo configuration
-#
-CONFIG_LOGO=y
-CONFIG_LOGO_LINUX_MONO=y
-CONFIG_LOGO_LINUX_VGA16=y
-CONFIG_LOGO_LINUX_CLUT224=y
-
-#
-# Old CD-ROM drivers (not SCSI, not IDE)
-#
-# CONFIG_CD_NO_IDESCSI is not set
-
-#
-# Input device support
-#
-CONFIG_INPUT=m
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=m
-CONFIG_INPUT_MOUSEDEV_PSAUX=y
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
-CONFIG_INPUT_JOYDEV=m
-# CONFIG_INPUT_TSDEV is not set
-CONFIG_INPUT_EVDEV=m
-CONFIG_INPUT_EVBUG=m
-
-#
-# Input I/O drivers
-#
-# CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
-CONFIG_SERIO=y
-# CONFIG_SERIO_I8042 is not set
-CONFIG_SERIO_SERPORT=y
-# CONFIG_SERIO_CT82C710 is not set
-# CONFIG_SERIO_PARKBD is not set
-
-#
-# Input Device Drivers
-#
-CONFIG_INPUT_KEYBOARD=y
-CONFIG_KEYBOARD_ATKBD=m
-# CONFIG_KEYBOARD_SUNKBD is not set
-# CONFIG_KEYBOARD_XTKBD is not set
-# CONFIG_KEYBOARD_NEWTON is not set
-CONFIG_KEYBOARD_AMIGA=m
-CONFIG_INPUT_MOUSE=y
-CONFIG_MOUSE_PS2=m
-CONFIG_MOUSE_SERIAL=m
-CONFIG_MOUSE_AMIGA=m
-# CONFIG_INPUT_JOYSTICK is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
-CONFIG_INPUT_MISC=y
-# CONFIG_INPUT_PCSPKR is not set
-CONFIG_INPUT_UINPUT=m
-
-#
-# Macintosh device drivers
-#
-
-#
-# Character devices
-#
-# CONFIG_SERIAL_NONSTANDARD is not set
-
-#
-# Serial drivers
-#
-# CONFIG_SERIAL_8250 is not set
-
-#
-# Non-8250 serial port support
-#
-CONFIG_UNIX98_PTYS=y
-CONFIG_UNIX98_PTY_COUNT=256
-CONFIG_PRINTER=m
-# CONFIG_LP_CONSOLE is not set
-# CONFIG_PPDEV is not set
-# CONFIG_TIPAR is not set
-
-#
-# I2C support
-#
-# CONFIG_I2C is not set
-
-#
-# I2C Hardware Sensors Mainboard support
-#
-
-#
-# I2C Hardware Sensors Chip support
-#
-# CONFIG_I2C_SENSOR is not set
-
-#
-# Mice
-#
-CONFIG_BUSMOUSE=y
-# CONFIG_QIC02_TAPE is not set
-
-#
-# IPMI
-#
-# CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
-# CONFIG_WATCHDOG is not set
-# CONFIG_NVRAM is not set
-CONFIG_GEN_RTC=y
-# CONFIG_GEN_RTC_X is not set
-# CONFIG_DTLK is not set
-# CONFIG_R3964 is not set
-# CONFIG_APPLICOM is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_FTAPE is not set
-# CONFIG_AGP is not set
-# CONFIG_DRM is not set
-# CONFIG_RAW_DRIVER is not set
-# CONFIG_HANGCHECK_TIMER is not set
-
-#
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
-
-#
-# File systems
-#
-CONFIG_EXT2_FS=y
-# CONFIG_EXT2_FS_XATTR is not set
-CONFIG_EXT3_FS=y
-CONFIG_EXT3_FS_XATTR=y
-# CONFIG_EXT3_FS_POSIX_ACL is not set
-# CONFIG_EXT3_FS_SECURITY is not set
-CONFIG_JBD=y
-# CONFIG_JBD_DEBUG is not set
-CONFIG_FS_MBCACHE=y
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_XFS_FS is not set
-CONFIG_MINIX_FS=y
-CONFIG_ROMFS_FS=y
-# CONFIG_QUOTA is not set
-CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
-
-#
-# CD-ROM/DVD Filesystems
-#
-CONFIG_ISO9660_FS=y
-CONFIG_JOLIET=y
-# CONFIG_ZISOFS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-CONFIG_FAT_FS=y
-CONFIG_MSDOS_FS=y
-CONFIG_VFAT_FS=y
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=y
-# CONFIG_DEVFS_FS is not set
-CONFIG_DEVPTS_FS=y
-# CONFIG_DEVPTS_FS_XATTR is not set
-CONFIG_TMPFS=y
-CONFIG_RAMFS=y
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-CONFIG_AFFS_FS=y
-CONFIG_HFS_FS=y
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_CRAMFS=y
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V4 is not set
-CONFIG_NFSD=m
-CONFIG_NFSD_V3=y
-# CONFIG_NFSD_V4 is not set
-# CONFIG_NFSD_TCP is not set
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_EXPORTFS=m
-CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_GSS is not set
-CONFIG_SMB_FS=m
-# CONFIG_SMB_NLS_DEFAULT is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-CONFIG_CODA_FS=m
-# CONFIG_INTERMEZZO_FS is not set
-# CONFIG_AFS_FS is not set
-
-#
-# Partition Types
-#
-CONFIG_PARTITION_ADVANCED=y
-# CONFIG_ACORN_PARTITION is not set
-# CONFIG_OSF_PARTITION is not set
-CONFIG_AMIGA_PARTITION=y
-CONFIG_ATARI_PARTITION=y
-# CONFIG_MAC_PARTITION is not set
-CONFIG_MSDOS_PARTITION=y
-CONFIG_BSD_DISKLABEL=y
-# CONFIG_MINIX_SUBPARTITION is not set
-CONFIG_SOLARIS_X86_PARTITION=y
-CONFIG_UNIXWARE_DISKLABEL=y
-# CONFIG_LDM_PARTITION is not set
-# CONFIG_NEC98_PARTITION is not set
-# CONFIG_SGI_PARTITION is not set
-# CONFIG_ULTRIX_PARTITION is not set
-# CONFIG_SUN_PARTITION is not set
-# CONFIG_EFI_PARTITION is not set
-CONFIG_SMB_NLS=y
-CONFIG_NLS=y
-
-#
-# Native Language Support
-#
-CONFIG_NLS_DEFAULT="iso8859-1"
-CONFIG_NLS_CODEPAGE_437=m
-CONFIG_NLS_CODEPAGE_737=m
-CONFIG_NLS_CODEPAGE_775=m
-CONFIG_NLS_CODEPAGE_850=m
-CONFIG_NLS_CODEPAGE_852=m
-CONFIG_NLS_CODEPAGE_855=m
-CONFIG_NLS_CODEPAGE_857=m
-CONFIG_NLS_CODEPAGE_860=m
-CONFIG_NLS_CODEPAGE_861=m
-CONFIG_NLS_CODEPAGE_862=m
-CONFIG_NLS_CODEPAGE_863=m
-CONFIG_NLS_CODEPAGE_864=m
-CONFIG_NLS_CODEPAGE_865=m
-CONFIG_NLS_CODEPAGE_866=m
-CONFIG_NLS_CODEPAGE_869=m
-CONFIG_NLS_CODEPAGE_936=m
-CONFIG_NLS_CODEPAGE_950=m
-CONFIG_NLS_CODEPAGE_932=m
-CONFIG_NLS_CODEPAGE_949=m
-CONFIG_NLS_CODEPAGE_874=m
-CONFIG_NLS_ISO8859_8=m
-# CONFIG_NLS_CODEPAGE_1250 is not set
-CONFIG_NLS_CODEPAGE_1251=m
-CONFIG_NLS_ISO8859_1=m
-CONFIG_NLS_ISO8859_2=m
-CONFIG_NLS_ISO8859_3=m
-CONFIG_NLS_ISO8859_4=m
-CONFIG_NLS_ISO8859_5=m
-CONFIG_NLS_ISO8859_6=m
-CONFIG_NLS_ISO8859_7=m
-CONFIG_NLS_ISO8859_9=m
-CONFIG_NLS_ISO8859_13=m
-CONFIG_NLS_ISO8859_14=m
-CONFIG_NLS_ISO8859_15=m
-CONFIG_NLS_KOI8_R=m
-CONFIG_NLS_KOI8_U=m
-CONFIG_NLS_UTF8=m
-
-#
-# Sound
-#
-CONFIG_SOUND=y
-CONFIG_DMASOUND_PAULA=m
-CONFIG_DMASOUND=m
-
-#
-# Advanced Linux Sound Architecture
-#
-# CONFIG_SND is not set
-
-#
-# Open Sound System
-#
-CONFIG_SOUND_PRIME=m
-# CONFIG_SOUND_BT878 is not set
-# CONFIG_SOUND_CMPCI is not set
-# CONFIG_SOUND_EMU10K1 is not set
-# CONFIG_SOUND_FUSION is not set
-# CONFIG_SOUND_CS4281 is not set
-# CONFIG_SOUND_ES1370 is not set
-# CONFIG_SOUND_ES1371 is not set
-# CONFIG_SOUND_ESSSOLO1 is not set
-# CONFIG_SOUND_MAESTRO is not set
-# CONFIG_SOUND_MAESTRO3 is not set
-# CONFIG_SOUND_ICH is not set
-# CONFIG_SOUND_RME96XX is not set
-# CONFIG_SOUND_SONICVIBES is not set
-# CONFIG_SOUND_TRIDENT is not set
-# CONFIG_SOUND_MSNDCLAS is not set
-# CONFIG_SOUND_MSNDPIN is not set
-# CONFIG_SOUND_VIA82CXXX is not set
-CONFIG_SOUND_OSS=m
-CONFIG_SOUND_TRACEINIT=y
-CONFIG_SOUND_DMAP=y
-# CONFIG_SOUND_AD1816 is not set
-# CONFIG_SOUND_SGALAXY is not set
-# CONFIG_SOUND_ADLIB is not set
-# CONFIG_SOUND_ACI_MIXER is not set
-# CONFIG_SOUND_CS4232 is not set
-# CONFIG_SOUND_SSCAPE is not set
-# CONFIG_SOUND_GUS is not set
-CONFIG_SOUND_VMIDI=m
-# CONFIG_SOUND_TRIX is not set
-# CONFIG_SOUND_MSS is not set
-# CONFIG_SOUND_MPU401 is not set
-# CONFIG_SOUND_NM256 is not set
-# CONFIG_SOUND_MAD16 is not set
-# CONFIG_SOUND_PAS is not set
-# CONFIG_SOUND_PSS is not set
-# CONFIG_SOUND_SB is not set
-# CONFIG_SOUND_AWE32_SYNTH is not set
-# CONFIG_SOUND_WAVEFRONT is not set
-# CONFIG_SOUND_MAUI is not set
-# CONFIG_SOUND_YM3812 is not set
-# CONFIG_SOUND_OPL3SA1 is not set
-# CONFIG_SOUND_OPL3SA2 is not set
-# CONFIG_SOUND_YMFPCI is not set
-# CONFIG_SOUND_UART6850 is not set
-# CONFIG_SOUND_AEDSP16 is not set
-
-#
-# USB support
-#
-# CONFIG_USB is not set
-# CONFIG_USB_GADGET is not set
-
-#
-# Bluetooth support
-#
-# CONFIG_BT is not set
-
-#
-# Library routines
-#
-# CONFIG_CRC32 is not set
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-
-#
-# Kernel hacking
-#
-# CONFIG_DEBUG_KERNEL is not set
-# CONFIG_KALLSYMS is not set
-
-#
-# Security options
-#
-# CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
-# CONFIG_CRYPTO is not set
--- linux-2.6.22-rc6-mm1/arch/ppc/platforms/apus_pci.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,34 +0,0 @@
-/*
- * Phase5 CybervisionPPC (TVP4020) definitions for the Permedia2 framebuffer
- * driver.
- *
- * Copyright (c) 1998-1999 Ilario Nardinocchi (nardinoc@CS.UniBO.IT)
- * --------------------------------------------------------------------------
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file README.legal in the main directory of this archive
- * for more details.
- */
-
-#ifndef APUS_PCI_H
-#define APUS_PCI_H
-
-
-#define CSPPC_PCI_BRIDGE		0xfffe0000
-#define CSPPC_BRIDGE_ENDIAN		0x0000
-#define CSPPC_BRIDGE_INT		0x0010
-
-#define	CVPPC_PCI_CONFIG		0xfffc0000
-#define CVPPC_ROM_ADDRESS		0xe2000001
-#define CVPPC_REGS_REGION		0xef000000
-#define CVPPC_FB_APERTURE_ONE		0xe0000000
-#define CVPPC_FB_APERTURE_TWO		0xe1000000
-#define CVPPC_FB_SIZE			0x00800000
-
-/* CVPPC_BRIDGE_ENDIAN */
-#define CSPPCF_BRIDGE_BIG_ENDIAN	0x02
-
-/* CVPPC_BRIDGE_INT */
-#define CSPPCF_BRIDGE_ACTIVE_INT2	0x01
-
-
-#endif	/* APUS_PCI_H */
--- linux-2.6.22-rc6-mm1/arch/ppc/platforms/apus_pci.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,207 +0,0 @@
-/*
- * Copyright (C) Michel D�nzer <michdaen@iiic.ethz.ch>
- *
- * APUS PCI routines.
- *
- * Currently, only B/CVisionPPC cards (Permedia2) are supported.
- *
- * Thanks to Geert Uytterhoeven for the idea:
- * Read values from given config space(s) for the first devices, -1 otherwise
- *
- */
-
-#ifdef CONFIG_AMIGA
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-#include <asm/pci-bridge.h>
-#include <asm/machdep.h>
-
-#include "apus_pci.h"
-
-
-/* These definitions are mostly adapted from pm2fb.c */
-
-#undef APUS_PCI_MASTER_DEBUG
-#ifdef APUS_PCI_MASTER_DEBUG
-#define DPRINTK(a,b...)	printk(KERN_DEBUG "apus_pci: %s: " a, __FUNCTION__ , ## b)
-#else
-#define DPRINTK(a,b...)
-#endif
-
-/*
- * The _DEFINITIVE_ memory mapping/unmapping functions.
- * This is due to the fact that they're changing soooo often...
- */
-#define DEFW()		wmb()
-#define DEFR()		rmb()
-#define DEFRW()		mb()
-
-#define DEVNO(d)	((d)>>3)
-#define FNNO(d)		((d)&7)
-
-
-extern unsigned long powerup_PCI_present;
-
-static struct pci_controller *apus_hose;
-
-
-void *pci_io_base(unsigned int bus)
-{
-	return 0;
-}
-
-
-int
-apus_pcibios_read_config(struct pci_bus *bus, int devfn, int offset,
-			 int len, u32 *val)
-{
-	int fnno = FNNO(devfn);
-	int devno = DEVNO(devfn);
-	volatile unsigned char *cfg_data;
-
-	if (bus->number > 0 || devno != 1) {
-		*val = ~0;
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-	/* base address + function offset + offset ^ endianness conversion */
-	/* XXX the fnno<<5 bit seems wacky  -- paulus */
-	cfg_data = apus_hose->cfg_data + (fnno<<5) + (offset ^ (len - 1));
-	switch (len) {
-	case 1:
-		*val = readb(cfg_data);
-		break;
-	case 2:
-		*val = readw(cfg_data);
-		break;
-	default:
-		*val = readl(cfg_data);
-		break;
-	}
-
-	DPRINTK("read b: 0x%x, d: 0x%x, f: 0x%x, o: 0x%x, l: %d, v: 0x%x\n",
-		bus->number, devfn>>3, devfn&7, offset, len, *val);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-int
-apus_pcibios_write_config(struct pci_bus *bus, int devfn, int offset,
-			  int len, u32 *val)
-{
-	int fnno = FNNO(devfn);
-	int devno = DEVNO(devfn);
-	volatile unsigned char *cfg_data;
-
-	if (bus->number > 0 || devno != 1) {
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-	/* base address + function offset + offset ^ endianness conversion */
-	/* XXX the fnno<<5 bit seems wacky  -- paulus */
-	cfg_data = apus_hose->cfg_data + (fnno<<5) + (offset ^ (len - 1));
-	switch (len) {
-	case 1:
-		writeb(val, cfg_data); DEFW();
-		break;
-	case 2:
-		writew(val, cfg_data); DEFW();
-		break;
-	default:
-		writel(val, cfg_data); DEFW();
-		break;
-	}
-
-	DPRINTK("write b: 0x%x, d: 0x%x, f: 0x%x, o: 0x%x, l: %d, v: 0x%x\n",
-		bus->number, devfn>>3, devfn&7, offset, len, val);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static struct pci_ops apus_pci_ops = {
-	apus_pcibios_read_config,
-	apus_pcibios_write_config
-};
-
-static struct resource pci_mem = { "B/CVisionPPC PCI mem", CVPPC_FB_APERTURE_ONE, CVPPC_PCI_CONFIG, IORESOURCE_MEM };
-
-void __init
-apus_pcibios_fixup(void)
-{
-/*	struct pci_dev *dev = pci_find_slot(0, 1<<3);
-	unsigned int reg, val, offset;*/
-
-	/* FIXME: interrupt? */
-	/*dev->interrupt = xxx;*/
-
-        request_resource(&iomem_resource, &pci_mem);
-    	printk("%s: PCI mem resource requested\n", __FUNCTION__);
-}
-
-static void __init apus_pcibios_fixup_bus(struct pci_bus *bus)
-{
-        bus->resource[1] = &pci_mem;
-}
-
-
-/*
- * This is from pm2fb.c again
- *
- * Check if PCI (B/CVisionPPC) is available, initialize it and set up
- * the pcibios_* pointers
- */
-
-
-void __init
-apus_setup_pci_ptrs(void)
-{
-	if (!powerup_PCI_present) {
-		DPRINTK("no PCI bridge detected\n");
-		return;
-	}
-	DPRINTK("Phase5 B/CVisionPPC PCI bridge detected.\n");
-
-	apus_hose = pcibios_alloc_controller();
-	if (!apus_hose) {
-		printk("apus_pci: Can't allocate PCI controller structure\n");
-		return;
-	}
-
-	if (!(apus_hose->cfg_data = ioremap(CVPPC_PCI_CONFIG, 256))) {
-		printk("apus_pci: unable to map PCI config region\n");
-		return;
-	}
-
-	if (!(apus_hose->cfg_addr = ioremap(CSPPC_PCI_BRIDGE, 256))) {
-		printk("apus_pci: unable to map PCI bridge\n");
-		return;
-	}
-
-	writel(CSPPCF_BRIDGE_BIG_ENDIAN, apus_hose->cfg_addr + CSPPC_BRIDGE_ENDIAN);
-	DEFW();
-
-	writel(CVPPC_REGS_REGION,  apus_hose->cfg_data+ PCI_BASE_ADDRESS_0);
-	DEFW();
-	writel(CVPPC_FB_APERTURE_ONE, apus_hose->cfg_data + PCI_BASE_ADDRESS_1);
-	DEFW();
-	writel(CVPPC_FB_APERTURE_TWO, apus_hose->cfg_data + PCI_BASE_ADDRESS_2);
-	DEFW();
-	writel(CVPPC_ROM_ADDRESS, apus_hose->cfg_data + PCI_ROM_ADDRESS);
-	DEFW();
-
-	writel(0xef000000 | PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-		PCI_COMMAND_MASTER, apus_hose->cfg_data + PCI_COMMAND);
-	DEFW();
-
-	apus_hose->first_busno = 0;
-	apus_hose->last_busno = 0;
-	apus_hose->ops = &apus_pci_ops;
-	ppc_md.pcibios_fixup = apus_pcibios_fixup;
-	ppc_md.pcibios_fixup_bus = apus_pcibios_fixup_bus;
-
-	return;
-}
-
-#endif /* CONFIG_AMIGA */
--- linux-2.6.22-rc6-mm1/arch/ppc/platforms/apus_setup.c	2007-06-28 14:54:24.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,792 +0,0 @@
-/*
- *  Copyright (C) 1998, 1999  Jesper Skov
- *
- *  Basically what is needed to replace functionality found in
- *  arch/m68k allowing Amiga drivers to work under APUS.
- *  Bits of code and/or ideas from arch/m68k and arch/ppc files.
- *
- * TODO:
- *  This file needs a *really* good cleanup. Restructure and optimize.
- *  Make sure it can be compiled for non-APUS configs. Begin to move
- *  Amiga specific stuff into mach/amiga.
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/initrd.h>
-#include <linux/seq_file.h>
-
-/* Needs INITSERIAL call in head.S! */
-#undef APUS_DEBUG
-
-#include <asm/bootinfo.h>
-#include <asm/setup.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amigappc.h>
-#include <asm/pgtable.h>
-#include <asm/dma.h>
-#include <asm/machdep.h>
-#include <asm/time.h>
-
-unsigned long m68k_machtype;
-char debug_device[6] = "";
-
-extern void amiga_init_IRQ(void);
-
-extern void apus_setup_pci_ptrs(void);
-
-void (*mach_sched_init) (void (*handler)(int, void *, struct pt_regs *)) __initdata = NULL;
-/* machine dependent irq functions */
-void (*mach_init_IRQ) (void) __initdata = NULL;
-void (*(*mach_default_handler)[]) (int, void *, struct pt_regs *) = NULL;
-void (*mach_get_model) (char *model) = NULL;
-int (*mach_get_hardware_list) (char *buffer) = NULL;
-int (*mach_get_irq_list) (struct seq_file *, void *) = NULL;
-void (*mach_process_int) (int, struct pt_regs *) = NULL;
-/* machine dependent timer functions */
-unsigned long (*mach_gettimeoffset) (void);
-void (*mach_gettod) (int*, int*, int*, int*, int*, int*);
-int (*mach_hwclk) (int, struct hwclk_time*) = NULL;
-int (*mach_set_clock_mmss) (unsigned long) = NULL;
-void (*mach_reset)( void );
-long mach_max_dma_address = 0x00ffffff; /* default set to the lower 16MB */
-#ifdef CONFIG_HEARTBEAT
-void (*mach_heartbeat) (int) = NULL;
-extern void apus_heartbeat (void);
-#endif
-
-extern unsigned long amiga_model;
-extern unsigned decrementer_count;/* count value for 1e6/HZ microseconds */
-extern unsigned count_period_num; /* 1 decrementer count equals */
-extern unsigned count_period_den; /* count_period_num / count_period_den us */
-
-int num_memory = 0;
-struct mem_info memory[NUM_MEMINFO];/* memory description */
-/* FIXME: Duplicate memory data to avoid conflicts with m68k shared code. */
-int m68k_realnum_memory = 0;
-struct mem_info m68k_memory[NUM_MEMINFO];/* memory description */
-
-struct mem_info ramdisk;
-
-extern void config_amiga(void);
-
-static int __60nsram = 0;
-
-/* for cpuinfo */
-static int __bus_speed = 0;
-static int __speed_test_failed = 0;
-
-/********************************************** COMPILE PROTECTION */
-/* Provide some stubs that links to Amiga specific functions.
- * This allows CONFIG_APUS to be removed from generic PPC files while
- * preventing link errors for other PPC targets.
- */
-unsigned long apus_get_rtc_time(void)
-{
-#ifdef CONFIG_APUS
-	extern unsigned long m68k_get_rtc_time(void);
-
-	return m68k_get_rtc_time ();
-#else
-	return 0;
-#endif
-}
-
-int apus_set_rtc_time(unsigned long nowtime)
-{
-#ifdef CONFIG_APUS
-	extern int m68k_set_rtc_time(unsigned long nowtime);
-
-	return m68k_set_rtc_time (nowtime);
-#else
-	return 0;
-#endif
-}
-
-/*********************************************************** SETUP */
-/* From arch/m68k/kernel/setup.c. */
-void __init apus_setup_arch(void)
-{
-#ifdef CONFIG_APUS
-	extern char cmd_line[];
-	int i;
-	char *p, *q;
-
-	/* Let m68k-shared code know it should do the Amiga thing. */
-	m68k_machtype = MACH_AMIGA;
-
-	/* Parse the command line for arch-specific options.
-	 * For the m68k, this is currently only "debug=xxx" to enable printing
-	 * certain kernel messages to some machine-specific device.  */
-	for( p = cmd_line; p && *p; ) {
-	    i = 0;
-	    if (!strncmp( p, "debug=", 6 )) {
-		    strlcpy( debug_device, p+6, sizeof(debug_device) );
-		    if ((q = strchr( debug_device, ' ' ))) *q = 0;
-		    i = 1;
-	    } else if (!strncmp( p, "60nsram", 7 )) {
-		    APUS_WRITE (APUS_REG_WAITSTATE,
-				REGWAITSTATE_SETRESET
-				|REGWAITSTATE_PPCR
-				|REGWAITSTATE_PPCW);
-		    __60nsram = 1;
-		    i = 1;
-	    }
-
-	    if (i) {
-		/* option processed, delete it */
-		if ((q = strchr( p, ' ' )))
-		    strcpy( p, q+1 );
-		else
-		    *p = 0;
-	    } else {
-		if ((p = strchr( p, ' ' ))) ++p;
-	    }
-	}
-
-	config_amiga();
-
-#if 0 /* Enable for logging - also include logging.o in Makefile rule */
-	{
-#define LOG_SIZE 4096
-		void* base;
-
-		/* Throw away some memory - the P5 firmare stomps on top
-		 * of CHIP memory during bootup.
-		 */
-		amiga_chip_alloc(0x1000);
-
-		base = amiga_chip_alloc(LOG_SIZE+sizeof(klog_data_t));
-		LOG_INIT(base, base+sizeof(klog_data_t), LOG_SIZE);
-	}
-#endif
-#endif
-}
-
-int
-apus_show_cpuinfo(struct seq_file *m)
-{
-	extern int __map_without_bats;
-	extern unsigned long powerup_PCI_present;
-
-	seq_printf(m, "machine\t\t: Amiga\n");
-	seq_printf(m, "bus speed\t: %d%s", __bus_speed,
-		   (__speed_test_failed) ? " [failed]\n" : "\n");
-	seq_printf(m, "using BATs\t: %s\n",
-		   (__map_without_bats) ? "No" : "Yes");
-	seq_printf(m, "ram speed\t: %dns\n", (__60nsram) ? 60 : 70);
-	seq_printf(m, "PCI bridge\t: %s\n",
-		   (powerup_PCI_present) ? "Yes" : "No");
-	return 0;
-}
-
-static void get_current_tb(unsigned long long *time)
-{
-	__asm __volatile ("1:mftbu 4      \n\t"
-			  "  mftb  5      \n\t"
-			  "  mftbu 6      \n\t"
-			  "  cmpw  4,6    \n\t"
-			  "  bne   1b     \n\t"
-			  "  stw   4,0(%0)\n\t"
-			  "  stw   5,4(%0)\n\t"
-			  :
-			  : "r" (time)
-			  : "r4", "r5", "r6");
-}
-
-
-void apus_calibrate_decr(void)
-{
-#ifdef CONFIG_APUS
-	unsigned long freq;
-
-	/* This algorithm for determining the bus speed was
-           contributed by Ralph Schmidt. */
-	unsigned long long start, stop;
-	int bus_speed;
-	int speed_test_failed = 0;
-
-	{
-		unsigned long loop = amiga_eclock / 10;
-
-		get_current_tb (&start);
-		while (loop--) {
-			unsigned char tmp;
-
-			tmp = ciaa.pra;
-		}
-		get_current_tb (&stop);
-	}
-
-	bus_speed = (((unsigned long)(stop-start))*10*4) / 1000000;
-	if (AMI_1200 == amiga_model)
-		bus_speed /= 2;
-
-	if ((bus_speed >= 47) && (bus_speed < 53)) {
-		bus_speed = 50;
-		freq = 12500000;
-	} else if ((bus_speed >= 57) && (bus_speed < 63)) {
-		bus_speed = 60;
-		freq = 15000000;
-	} else if ((bus_speed >= 63) && (bus_speed < 69)) {
-		bus_speed = 67;
-		freq = 16666667;
-	} else {
-		printk ("APUS: Unable to determine bus speed (%d). "
-			"Defaulting to 50MHz", bus_speed);
-		bus_speed = 50;
-		freq = 12500000;
-		speed_test_failed = 1;
-	}
-
-	/* Ease diagnostics... */
-	{
-		extern int __map_without_bats;
-		extern unsigned long powerup_PCI_present;
-
-		printk ("APUS: BATs=%d, BUS=%dMHz",
-			(__map_without_bats) ? 0 : 1,
-			bus_speed);
-		if (speed_test_failed)
-			printk ("[FAILED - please report]");
-
-		printk (", RAM=%dns, PCI bridge=%d\n",
-			(__60nsram) ? 60 : 70,
-			(powerup_PCI_present) ? 1 : 0);
-
-		/* print a bit more if asked politely... */
-		if (!(ciaa.pra & 0x40)){
-			extern unsigned int bat_addrs[4][3];
-			int b;
-			for (b = 0; b < 4; ++b) {
-				printk ("APUS: BAT%d ", b);
-				printk ("%08x-%08x -> %08x\n",
-					bat_addrs[b][0],
-					bat_addrs[b][1],
-					bat_addrs[b][2]);
-			}
-		}
-
-	}
-
-        printk("time_init: decrementer frequency = %lu.%.6lu MHz\n",
-	       freq/1000000, freq%1000000);
-	tb_ticks_per_jiffy = freq / HZ;
-	tb_to_us = mulhwu_scale_factor(freq, 1000000);
-
-	__bus_speed = bus_speed;
-	__speed_test_failed = speed_test_failed;
-#endif
-}
-
-void arch_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-#ifdef CONFIG_APUS
-	if (mach_gettod)
-		mach_gettod(year, mon, day, hour, min, sec);
-	else
-		*year = *mon = *day = *hour = *min = *sec = 0;
-#endif
-}
-
-/* for "kbd-reset" cmdline param */
-__init
-void kbd_reset_setup(char *str, int *ints)
-{
-}
-
-/*********************************************************** MEMORY */
-#define KMAP_MAX 32
-unsigned long kmap_chunks[KMAP_MAX*3];
-int kmap_chunk_count = 0;
-
-/* From pgtable.h */
-static __inline__ pte_t *my_find_pte(struct mm_struct *mm,unsigned long va)
-{
-	pgd_t *dir = 0;
-	pmd_t *pmd = 0;
-	pte_t *pte = 0;
-
-	va &= PAGE_MASK;
-
-	dir = pgd_offset( mm, va );
-	if (dir)
-	{
-		pmd = pmd_offset(dir, va & PAGE_MASK);
-		if (pmd && pmd_present(*pmd))
-		{
-			pte = pte_offset(pmd, va);
-		}
-	}
-	return pte;
-}
-
-
-/* Again simulating an m68k/mm/kmap.c function. */
-void kernel_set_cachemode( unsigned long address, unsigned long size,
-			   unsigned int cmode )
-{
-	unsigned long mask, flags;
-
-	switch (cmode)
-	{
-	case IOMAP_FULL_CACHING:
-		mask = ~(_PAGE_NO_CACHE | _PAGE_GUARDED);
-		flags = 0;
-		break;
-	case IOMAP_NOCACHE_SER:
-		mask = ~0;
-		flags = (_PAGE_NO_CACHE | _PAGE_GUARDED);
-		break;
-	default:
-		panic ("kernel_set_cachemode() doesn't support mode %d\n",
-		       cmode);
-		break;
-	}
-
-	size /= PAGE_SIZE;
-	address &= PAGE_MASK;
-	while (size--)
-	{
-		pte_t *pte;
-
-		pte = my_find_pte(&init_mm, address);
-		if ( !pte )
-		{
-			printk("pte NULL in kernel_set_cachemode()\n");
-			return;
-		}
-
-                pte_val (*pte) &= mask;
-                pte_val (*pte) |= flags;
-                flush_tlb_page(find_vma(&init_mm,address),address);
-
-		address += PAGE_SIZE;
-	}
-}
-
-unsigned long mm_ptov (unsigned long paddr)
-{
-	unsigned long ret;
-	if (paddr < 16*1024*1024)
-		ret = ZTWO_VADDR(paddr);
-	else {
-		int i;
-
-		for (i = 0; i < kmap_chunk_count;){
-			unsigned long phys = kmap_chunks[i++];
-			unsigned long size = kmap_chunks[i++];
-			unsigned long virt = kmap_chunks[i++];
-			if (paddr >= phys
-			    && paddr < (phys + size)){
-				ret = virt + paddr - phys;
-				goto exit;
-			}
-		}
-
-		ret = (unsigned long) __va(paddr);
-	}
-exit:
-#ifdef DEBUGPV
-	printk ("PTOV(%lx)=%lx\n", paddr, ret);
-#endif
-	return ret;
-}
-
-int mm_end_of_chunk (unsigned long addr, int len)
-{
-	if (memory[0].addr + memory[0].size == addr + len)
-		return 1;
-	return 0;
-}
-
-/*********************************************************** CACHE */
-
-#define L1_CACHE_BYTES 32
-#define MAX_CACHE_SIZE 8192
-void cache_push(__u32 addr, int length)
-{
-	addr = mm_ptov(addr);
-
-	if (MAX_CACHE_SIZE < length)
-		length = MAX_CACHE_SIZE;
-
-	while(length > 0){
-		__asm ("dcbf 0,%0\n\t"
-		       : : "r" (addr));
-		addr += L1_CACHE_BYTES;
-		length -= L1_CACHE_BYTES;
-	}
-	/* Also flush trailing block */
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       : : "r" (addr));
-}
-
-void cache_clear(__u32 addr, int length)
-{
-	if (MAX_CACHE_SIZE < length)
-		length = MAX_CACHE_SIZE;
-
-	addr = mm_ptov(addr);
-
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       "icbi 0,%0 \n\t"
-	       "isync \n\t"
-	       : : "r" (addr));
-
-	addr += L1_CACHE_BYTES;
-	length -= L1_CACHE_BYTES;
-
-	while(length > 0){
-		__asm ("dcbf 0,%0\n\t"
-		       "sync \n\t"
-		       "icbi 0,%0 \n\t"
-		       "isync \n\t"
-		       : : "r" (addr));
-		addr += L1_CACHE_BYTES;
-		length -= L1_CACHE_BYTES;
-	}
-
-	__asm ("dcbf 0,%0\n\t"
-	       "sync \n\t"
-	       "icbi 0,%0 \n\t"
-	       "isync \n\t"
-	       : : "r" (addr));
-}
-
-/****************************************************** from setup.c */
-void
-apus_restart(char *cmd)
-{
-	local_irq_disable();
-
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK1|REGLOCK_BLACKMAGICK2);
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK1|REGLOCK_BLACKMAGICK3);
-	APUS_WRITE(APUS_REG_LOCK,
-		   REGLOCK_BLACKMAGICK2|REGLOCK_BLACKMAGICK3);
-	APUS_WRITE(APUS_REG_SHADOW, REGSHADOW_SELFRESET);
-	APUS_WRITE(APUS_REG_RESET, REGRESET_AMIGARESET);
-	for(;;);
-}
-
-void
-apus_power_off(void)
-{
-	for (;;);
-}
-
-void
-apus_halt(void)
-{
-   apus_restart(NULL);
-}
-
-/****************************************************** IRQ stuff */
-
-static unsigned char last_ipl[8];
-
-int apus_get_irq(void)
-{
-	unsigned char ipl_emu, mask;
-	unsigned int level;
-
-	APUS_READ(APUS_IPL_EMU, ipl_emu);
-	level = (ipl_emu >> 3) & IPLEMU_IPLMASK;
-	mask = IPLEMU_SETRESET|IPLEMU_DISABLEINT|level;
-	level ^= 7;
-
-	/* Save previous IPL value */
-	if (last_ipl[level])
-		return -2;
-	last_ipl[level] = ipl_emu;
-
-	/* Set to current IPL value */
-	APUS_WRITE(APUS_IPL_EMU, mask);
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT|level);
-
-
-#ifdef __INTERRUPT_DEBUG
-	printk("<%d:%d>", level, ~ipl_emu & IPLEMU_IPLMASK);
-#endif
-	return level + IRQ_AMIGA_AUTO;
-}
-
-void apus_end_irq(unsigned int irq)
-{
-	unsigned char ipl_emu;
-	unsigned int level = irq - IRQ_AMIGA_AUTO;
-#ifdef __INTERRUPT_DEBUG
-	printk("{%d}", ~last_ipl[level] & IPLEMU_IPLMASK);
-#endif
-	/* Restore IPL to the previous value */
-	ipl_emu = last_ipl[level] & IPLEMU_IPLMASK;
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_SETRESET|IPLEMU_DISABLEINT|ipl_emu);
-	last_ipl[level] = 0;
-	ipl_emu ^= 7;
-	APUS_WRITE(APUS_IPL_EMU, IPLEMU_DISABLEINT|ipl_emu);
-}
-
-/****************************************************** debugging */
-
-/* some serial hardware definitions */
-#define SDR_OVRUN   (1<<15)
-#define SDR_RBF     (1<<14)
-#define SDR_TBE     (1<<13)
-#define SDR_TSRE    (1<<12)
-
-#define AC_SETCLR   (1<<15)
-#define AC_UARTBRK  (1<<11)
-
-#define SER_DTR     (1<<7)
-#define SER_RTS     (1<<6)
-#define SER_DCD     (1<<5)
-#define SER_CTS     (1<<4)
-#define SER_DSR     (1<<3)
-
-static __inline__ void ser_RTSon(void)
-{
-    ciab.pra &= ~SER_RTS; /* active low */
-}
-
-int __debug_ser_out( unsigned char c )
-{
-	amiga_custom.serdat = c | 0x100;
-	mb();
-	while (!(amiga_custom.serdatr & 0x2000))
-		barrier();
-	return 1;
-}
-
-unsigned char __debug_ser_in( void )
-{
-	unsigned char c;
-
-	/* XXX: is that ok?? derived from amiga_ser.c... */
-	while( !(amiga_custom.intreqr & IF_RBF) )
-		barrier();
-	c = amiga_custom.serdatr;
-	/* clear the interrupt, so that another character can be read */
-	amiga_custom.intreq = IF_RBF;
-	return c;
-}
-
-int __debug_serinit( void )
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	/* turn off Rx and Tx interrupts */
-	amiga_custom.intena = IF_RBF | IF_TBE;
-
-	/* clear any pending interrupt */
-	amiga_custom.intreq = IF_RBF | IF_TBE;
-
-	local_irq_restore(flags);
-
-	/*
-	 * set the appropriate directions for the modem control flags,
-	 * and clear RTS and DTR
-	 */
-	ciab.ddra |= (SER_DTR | SER_RTS);   /* outputs */
-	ciab.ddra &= ~(SER_DCD | SER_CTS | SER_DSR);  /* inputs */
-
-	return 0;
-}
-
-void __debug_print_hex(unsigned long x)
-{
-	int i;
-	char hexchars[] = "0123456789ABCDEF";
-
-	for (i = 0; i < 8; i++) {
-		__debug_ser_out(hexchars[(x >> 28) & 15]);
-		x <<= 4;
-	}
-	__debug_ser_out('\n');
-	__debug_ser_out('\r');
-}
-
-void __debug_print_string(char* s)
-{
-	unsigned char c;
-	while((c = *s++))
-		__debug_ser_out(c);
-	__debug_ser_out('\n');
-	__debug_ser_out('\r');
-}
-
-static void apus_progress(char *s, unsigned short value)
-{
-	__debug_print_string(s);
-}
-
-/****************************************************** init */
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-extern struct irqaction amiga_sys_irqaction[AUTO_IRQS];
-
-
-extern void amiga_enable_irq(unsigned int irq);
-extern void amiga_disable_irq(unsigned int irq);
-
-struct hw_interrupt_type amiga_sys_irqctrl = {
-	.typename = "Amiga IPL",
-	.end = apus_end_irq,
-};
-
-struct hw_interrupt_type amiga_irqctrl = {
-	.typename = "Amiga    ",
-	.enable = amiga_enable_irq,
-	.disable = amiga_disable_irq,
-};
-
-#define HARDWARE_MAPPED_SIZE (512*1024)
-unsigned long __init apus_find_end_of_memory(void)
-{
-	int shadow = 0;
-	unsigned long total;
-
-	/* The memory size reported by ADOS excludes the 512KB
-	   reserved for PPC exception registers and possibly 512KB
-	   containing a shadow of the ADOS ROM. */
-	{
-		unsigned long size = memory[0].size;
-
-		/* If 2MB aligned, size was probably user
-                   specified. We can't tell anything about shadowing
-                   in this case so skip shadow assignment. */
-		if (0 != (size & 0x1fffff)){
-			/* Align to 512KB to ensure correct handling
-			   of both memfile and system specified
-			   sizes. */
-			size = ((size+0x0007ffff) & 0xfff80000);
-			/* If memory is 1MB aligned, assume
-                           shadowing. */
-			shadow = !(size & 0x80000);
-		}
-
-		/* Add the chunk that ADOS does not see. by aligning
-                   the size to the nearest 2MB limit upwards.  */
-		memory[0].size = ((size+0x001fffff) & 0xffe00000);
-	}
-
-	ppc_memstart = memory[0].addr;
-	ppc_memoffset = PAGE_OFFSET - PPC_MEMSTART;
-	total = memory[0].size;
-
-	/* Remove the memory chunks that are controlled by special
-           Phase5 hardware. */
-
-	/* Remove the upper 512KB if it contains a shadow of
-	   the ADOS ROM. FIXME: It might be possible to
-	   disable this shadow HW. Check the booter
-	   (ppc_boot.c) */
-	if (shadow)
-		total -= HARDWARE_MAPPED_SIZE;
-
-	/* Remove the upper 512KB where the PPC exception
-	   vectors are mapped. */
-	total -= HARDWARE_MAPPED_SIZE;
-
-	/* Linux/APUS only handles one block of memory -- the one on
-	   the PowerUP board. Other system memory is horrible slow in
-	   comparison. The user can use other memory for swapping
-	   using the z2ram device. */
-	return total;
-}
-
-static void __init
-apus_map_io(void)
-{
-	/* Map PPC exception vectors. */
-	io_block_mapping(0xfff00000, 0xfff00000, 0x00020000, _PAGE_KERNEL);
-	/* Map chip and ZorroII memory */
-	io_block_mapping(zTwoBase,   0x00000000, 0x01000000, _PAGE_IO);
-}
-
-__init
-void apus_init_IRQ(void)
-{
-	struct irqaction *action;
-	int i;
-
-#ifdef CONFIG_PCI
-        apus_setup_pci_ptrs();
-#endif
-
-	for ( i = 0 ; i < AMI_IRQS; i++ ) {
-		irq_desc[i].status = IRQ_LEVEL;
-		if (i < IRQ_AMIGA_AUTO) {
-			irq_desc[i].chip = &amiga_irqctrl;
-		} else {
-			irq_desc[i].chip = &amiga_sys_irqctrl;
-			action = &amiga_sys_irqaction[i-IRQ_AMIGA_AUTO];
-			if (action->name)
-				setup_irq(i, action);
-		}
-	}
-
-	amiga_init_IRQ();
-
-}
-
-__init
-void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
-		   unsigned long r6, unsigned long r7)
-{
-	extern int parse_bootinfo(const struct bi_record *);
-	extern char _end[];
-
-	/* Parse bootinfo. The bootinfo is located right after
-           the kernel bss */
-	parse_bootinfo((const struct bi_record *)&_end);
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Take care of initrd if we have one. Use data from
-	   bootinfo to avoid the need to initialize PPC
-	   registers when kernel is booted via a PPC reset. */
-	if ( ramdisk.addr ) {
-		initrd_start = (unsigned long) __va(ramdisk.addr);
-		initrd_end = (unsigned long)
-			__va(ramdisk.size + ramdisk.addr);
-	}
-#endif /* CONFIG_BLK_DEV_INITRD */
-
-	ISA_DMA_THRESHOLD = 0x00ffffff;
-
-	ppc_md.setup_arch     = apus_setup_arch;
-	ppc_md.show_cpuinfo   = apus_show_cpuinfo;
-	ppc_md.init_IRQ       = apus_init_IRQ;
-	ppc_md.get_irq        = apus_get_irq;
-
-#ifdef CONFIG_HEARTBEAT
-	ppc_md.heartbeat      = apus_heartbeat;
-	ppc_md.heartbeat_count = 1;
-#endif
-#ifdef APUS_DEBUG
-	__debug_serinit();
-	ppc_md.progress       = apus_progress;
-#endif
-	ppc_md.init           = NULL;
-
-	ppc_md.restart        = apus_restart;
-	ppc_md.power_off      = apus_power_off;
-	ppc_md.halt           = apus_halt;
-
-	ppc_md.time_init      = NULL;
-	ppc_md.set_rtc_time   = apus_set_rtc_time;
-	ppc_md.get_rtc_time   = apus_get_rtc_time;
-	ppc_md.calibrate_decr = apus_calibrate_decr;
-
-	ppc_md.find_end_of_memory = apus_find_end_of_memory;
-	ppc_md.setup_io_mappings = apus_map_io;
-}
--- linux-2.6.22-rc6-mm1/include/asm-ppc/amigahw.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,16 +0,0 @@
-#ifdef __KERNEL__
-#ifndef __ASMPPC_AMIGAHW_H
-#define __ASMPPC_AMIGAHW_H
-
-#include <asm-m68k/amigahw.h>
-
-#undef CHIP_PHYSADDR
-#ifdef CONFIG_APUS_FAST_EXCEPT
-#define CHIP_PHYSADDR      (0x000000)
-#else
-#define CHIP_PHYSADDR      (0x004000)
-#endif
-
-
-#endif /* __ASMPPC_AMIGAHW_H */
-#endif /* __KERNEL__ */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/amigaints.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,133 +0,0 @@
-/*
-** amigaints.h -- Amiga Linux interrupt handling structs and prototypes
-**
-** Copyright 1992 by Greg Harp
-**
-** This file is subject to the terms and conditions of the GNU General Public
-** License.  See the file COPYING in the main directory of this archive
-** for more details.
-**
-** Created 10/2/92 by Greg Harp
-*/
-
-#ifdef __KERNEL__
-#ifndef _ASMm68k_AMIGAINTS_H_
-#define _ASMm68k_AMIGAINTS_H_
-
-/*
-** Amiga Interrupt sources.
-**
-*/
-
-#define AUTO_IRQS           (8)
-#define AMI_STD_IRQS        (14)
-#define CIA_IRQS            (5)
-#define AMI_IRQS            (32) /* AUTO_IRQS+AMI_STD_IRQS+2*CIA_IRQS */
-
-/* vertical blanking interrupt */
-#define IRQ_AMIGA_VERTB     0
-
-/* copper interrupt */
-#define IRQ_AMIGA_COPPER    1
-
-/* Audio interrupts */
-#define IRQ_AMIGA_AUD0	    2
-#define IRQ_AMIGA_AUD1	    3
-#define IRQ_AMIGA_AUD2	    4
-#define IRQ_AMIGA_AUD3	    5
-
-/* Blitter done interrupt */
-#define IRQ_AMIGA_BLIT	    6
-
-/* floppy disk interrupts */
-#define IRQ_AMIGA_DSKSYN    7
-#define IRQ_AMIGA_DSKBLK    8
-
-/* builtin serial port interrupts */
-#define IRQ_AMIGA_RBF	    9
-#define IRQ_AMIGA_TBE	    10
-
-/* software interrupts */
-#define IRQ_AMIGA_SOFT      11
-
-/* interrupts from external hardware */
-#define IRQ_AMIGA_PORTS	    12
-#define IRQ_AMIGA_EXTER	    13
-
-/* CIA interrupt sources */
-#define IRQ_AMIGA_CIAA      14
-#define IRQ_AMIGA_CIAA_TA   14
-#define IRQ_AMIGA_CIAA_TB   15
-#define IRQ_AMIGA_CIAA_ALRM 16
-#define IRQ_AMIGA_CIAA_SP   17
-#define IRQ_AMIGA_CIAA_FLG  18
-#define IRQ_AMIGA_CIAB      19
-#define IRQ_AMIGA_CIAB_TA   19
-#define IRQ_AMIGA_CIAB_TB   20
-#define IRQ_AMIGA_CIAB_ALRM 21
-#define IRQ_AMIGA_CIAB_SP   22
-#define IRQ_AMIGA_CIAB_FLG  23
-
-/* auto-vector interrupts */
-#define IRQ_AMIGA_AUTO      24
-#define IRQ_AMIGA_AUTO_0    24 /* This is just a dummy */
-#define IRQ_AMIGA_AUTO_1    25
-#define IRQ_AMIGA_AUTO_2    26
-#define IRQ_AMIGA_AUTO_3    27
-#define IRQ_AMIGA_AUTO_4    28
-#define IRQ_AMIGA_AUTO_5    29
-#define IRQ_AMIGA_AUTO_6    30
-#define IRQ_AMIGA_AUTO_7    31
-
-#define IRQ_FLOPPY	    IRQ_AMIGA_DSKBLK
-
-/* INTREQR masks */
-#define IRQ1_MASK   0x0007	/* INTREQR mask for IRQ 1 */
-#define IRQ2_MASK   0x0008	/* INTREQR mask for IRQ 2 */
-#define IRQ3_MASK   0x0070	/* INTREQR mask for IRQ 3 */
-#define IRQ4_MASK   0x0780	/* INTREQR mask for IRQ 4 */
-#define IRQ5_MASK   0x1800	/* INTREQR mask for IRQ 5 */
-#define IRQ6_MASK   0x2000	/* INTREQR mask for IRQ 6 */
-#define IRQ7_MASK   0x4000	/* INTREQR mask for IRQ 7 */
-
-#define IF_SETCLR   0x8000      /* set/clr bit */
-#define IF_INTEN    0x4000	/* master interrupt bit in INT* registers */
-#define IF_EXTER    0x2000	/* external level 6 and CIA B interrupt */
-#define IF_DSKSYN   0x1000	/* disk sync interrupt */
-#define IF_RBF	    0x0800	/* serial receive buffer full interrupt */
-#define IF_AUD3     0x0400	/* audio channel 3 done interrupt */
-#define IF_AUD2     0x0200	/* audio channel 2 done interrupt */
-#define IF_AUD1     0x0100	/* audio channel 1 done interrupt */
-#define IF_AUD0     0x0080	/* audio channel 0 done interrupt */
-#define IF_BLIT     0x0040	/* blitter done interrupt */
-#define IF_VERTB    0x0020	/* vertical blanking interrupt */
-#define IF_COPER    0x0010	/* copper interrupt */
-#define IF_PORTS    0x0008	/* external level 2 and CIA A interrupt */
-#define IF_SOFT     0x0004	/* software initiated interrupt */
-#define IF_DSKBLK   0x0002	/* diskblock DMA finished */
-#define IF_TBE	    0x0001	/* serial transmit buffer empty interrupt */
-
-extern void amiga_do_irq(int irq, struct pt_regs *fp);
-extern void amiga_do_irq_list(int irq, struct pt_regs *fp);
-
-/* CIA interrupt control register bits */
-
-#define CIA_ICR_TA	0x01
-#define CIA_ICR_TB	0x02
-#define CIA_ICR_ALRM	0x04
-#define CIA_ICR_SP	0x08
-#define CIA_ICR_FLG	0x10
-#define CIA_ICR_ALL	0x1f
-#define CIA_ICR_SETCLR	0x80
-
-/* to access the interrupt control registers of CIA's use only
-** these functions, they behave exactly like the amiga os routines
-*/
-
-extern struct ciabase ciaa_base, ciab_base;
-
-extern unsigned char cia_set_irq(unsigned int irq, int set);
-extern unsigned char cia_able_irq(unsigned int irq, int enable);
-
-#endif /* asm-m68k/amigaints.h */
-#endif /* __KERNEL__ */
--- linux-2.6.22-rc6-mm1/include/asm-ppc/amigappc.h	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,85 +0,0 @@
-/*
-** asm-ppc/amigappc.h -- This header defines some values and pointers for
-**                        the Phase 5 PowerUp card.
-**
-** Copyright 1997, 1998 by Phase5, Germany.
-**
-** This file is subject to the terms and conditions of the GNU General Public
-** License.  See the file COPYING in the main directory of this archive
-** for more details.
-**
-** Created: 7/22/97 by Jesper Skov
-*/
-
-#ifdef __KERNEL__
-#ifndef _M68K_AMIGAPPC_H
-#define _M68K_AMIGAPPC_H
-
-#ifndef __ASSEMBLY__
-
-/* #include <asm/system.h> */
-#define mb()  __asm__ __volatile__ ("sync" : : : "memory")
-
-#define APUS_WRITE(_a_, _v_)				\
-do {							\
-	(*((volatile unsigned char *)(_a_)) = (_v_));	\
-	mb();						\
-} while (0)
-
-#define APUS_READ(_a_, _v_)				\
-do {							\
-	(_v_) = (*((volatile unsigned char *)(_a_)));	\
-	mb();						\
-} while (0)
-#endif /* ndef __ASSEMBLY__ */
-
-/* Maybe add a [#ifdef WANT_ZTWOBASE] condition to amigahw.h? */
-#define zTwoBase (0x80000000)
-
-#define APUS_IPL_BASE   	(zTwoBase + 0x00f60000)
-#define APUS_REG_RESET    	(APUS_IPL_BASE + 0x00)
-#define APUS_REG_WAITSTATE    	(APUS_IPL_BASE + 0x10)
-#define APUS_REG_SHADOW    	(APUS_IPL_BASE + 0x18)
-#define APUS_REG_LOCK		(APUS_IPL_BASE + 0x20)
-#define APUS_REG_INT    	(APUS_IPL_BASE + 0x28)
-#define APUS_IPL_EMU		(APUS_IPL_BASE + 0x30)
-#define APUS_INT_LVL		(APUS_IPL_BASE + 0x38)
-
-#define REGSHADOW_SETRESET	(0x80)
-#define REGSHADOW_SELFRESET	(0x40)
-
-#define REGLOCK_SETRESET	(0x80)
-#define REGLOCK_BLACKMAGICK1	(0x40)
-#define REGLOCK_BLACKMAGICK2	(0x20)
-#define REGLOCK_BLACKMAGICK3	(0x10)
-
-#define REGWAITSTATE_SETRESET	(0x80)
-#define REGWAITSTATE_PPCW	(0x08)
-#define REGWAITSTATE_PPCR	(0x04)
-
-#define REGRESET_SETRESET	(0x80)
-#define REGRESET_PPCRESET	(0x10)
-#define REGRESET_M68KRESET	(0x08)
-#define REGRESET_AMIGARESET	(0x04)
-#define REGRESET_AUXRESET	(0x02)
-#define REGRESET_SCSIRESET	(0x01)
-
-#define REGINT_SETRESET		(0x80)
-#define REGINT_ENABLEIPL	(0x02)
-#define REGINT_INTMASTER	(0x01)
-
-#define IPLEMU_SETRESET		(0x80)
-#define IPLEMU_DISABLEINT	(0x40)
-#define IPLEMU_IPL2		(0x20)
-#define IPLEMU_IPL1		(0x10)
-#define IPLEMU_IPL0		(0x08)
-#define IPLEMU_PPCIPL2		(0x04)
-#define IPLEMU_PPCIPL1		(0x02)
-#define IPLEMU_PPCIPL0		(0x01)
-#define IPLEMU_IPLMASK		(IPLEMU_PPCIPL2|IPLEMU_PPCIPL1|IPLEMU_PPCIPL0)
-
-#define INTLVL_SETRESET         (0x80)
-#define INTLVL_MASK             (0x7f)
-
-#endif /* _M68k_AMIGAPPC_H */
-#endif /* __KERNEL__ */

