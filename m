Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYHAQov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYHAQov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYHAQob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:44:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:50618 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbYHAQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:44:28 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] powerpc: Remove use of CONFIG_PPC_MERGE
Date: Fri,  1 Aug 2008 11:44:11 -0500
Message-Id: <1217609060-6381-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore remove
the dead code associated with !CONFIG_PPC_MERGE out of arch/powerpc
and include/asm-powerpc.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/Kconfig.debug               |    2 +-
 arch/powerpc/kernel/Makefile             |   14 --
 arch/powerpc/kernel/cpu_setup_44x.S      |    6 -
 arch/powerpc/kernel/irq.c                |   25 +---
 arch/powerpc/kernel/process.c            |    2 -
 arch/powerpc/kernel/vdso.c               |    2 -
 arch/powerpc/lib/Makefile                |    2 -
 arch/powerpc/platforms/52xx/Makefile     |    4 +-
 arch/powerpc/platforms/Makefile          |    6 -
 arch/powerpc/platforms/powermac/Makefile |    3 +-
 arch/powerpc/sysdev/Makefile             |    2 -
 include/asm-powerpc/dcr.h                |    6 +-
 include/asm-powerpc/i8259.h              |    5 -
 include/asm-powerpc/ipic.h               |    7 -
 include/asm-powerpc/irq.h                |  288 ------------------------------
 15 files changed, 6 insertions(+), 368 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 8c8aadb..4ebc52a 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -97,7 +97,7 @@ config IRQSTACKS
 
 config VIRQ_DEBUG
 	bool "Expose hardware/virtual IRQ mapping via debugfs"
-	depends on DEBUG_FS && PPC_MERGE
+	depends on DEBUG_FS
 	help
 	  This option will show the mapping relationship between hardware irq
 	  numbers and virtual irq numbers. The mapping is exposed via debugfs
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 1a40947..64f5948 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -59,8 +59,6 @@ obj64-$(CONFIG_HIBERNATION)	+= swsusp_asm64.o
 obj-$(CONFIG_MODULES)		+= module.o module_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_44x)		+= cpu_setup_44x.o
 
-ifeq ($(CONFIG_PPC_MERGE),y)
-
 extra-$(CONFIG_PPC_STD_MMU)	:= head_32.o
 extra-$(CONFIG_PPC64)		:= head_64.o
 extra-$(CONFIG_40x)		:= head_40x.o
@@ -100,12 +98,6 @@ ifneq ($(CONFIG_PPC_INDIRECT_IO),y)
 obj-y				+= iomap.o
 endif
 
-else
-# stuff used from here for ARCH=ppc
-smpobj-$(CONFIG_SMP)		+= smp.o
-
-endif
-
 obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
@@ -121,9 +113,6 @@ PHONY += systbl_chk
 systbl_chk: $(src)/systbl_chk.sh $(obj)/systbl_chk.i
 	$(call cmd,systbl_chk)
 
-
-ifeq ($(CONFIG_PPC_MERGE),y)
-
 $(obj)/built-in.o:		prom_init_check
 
 quiet_cmd_prom_init_check = CALL    $<
@@ -133,7 +122,4 @@ PHONY += prom_init_check
 prom_init_check: $(src)/prom_init_check.sh $(obj)/prom_init.o
 	$(call cmd,prom_init_check)
 
-endif
-
-
 clean-files := vmlinux.lds
diff --git a/arch/powerpc/kernel/cpu_setup_44x.S b/arch/powerpc/kernel/cpu_setup_44x.S
index 5465e8d..80cac98 100644
--- a/arch/powerpc/kernel/cpu_setup_44x.S
+++ b/arch/powerpc/kernel/cpu_setup_44x.S
@@ -39,12 +39,6 @@ _GLOBAL(__setup_cpu_440gx)
 _GLOBAL(__setup_cpu_440spe)
 	b	__fixup_440A_mcheck
 
- /* Temporary fixup for arch/ppc until we kill the whole thing */
-#ifndef CONFIG_PPC_MERGE
-_GLOBAL(__fixup_440A_mcheck)
-	blr
-#endif
-
 /* enable APU between CPU and FPU */
 _GLOBAL(__init_fpu_44x)
 	mfspr	r3,SPRN_CCR0
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 6ac8612..d972dec 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -77,22 +77,12 @@ static int ppc_spurious_interrupts;
 EXPORT_SYMBOL(__irq_offset_value);
 atomic_t ppc_n_lost_interrupts;
 
-#ifndef CONFIG_PPC_MERGE
-#define NR_MASK_WORDS	((NR_IRQS + 31) / 32)
-unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
-#endif
-
 #ifdef CONFIG_TAU_INT
 extern int tau_initialized;
 extern int tau_interrupts(int);
 #endif
 #endif /* CONFIG_PPC32 */
 
-#if defined(CONFIG_SMP) && !defined(CONFIG_PPC_MERGE)
-extern atomic_t ipi_recv;
-extern atomic_t ipi_sent;
-#endif
-
 #ifdef CONFIG_PPC64
 EXPORT_SYMBOL(irq_desc);
 
@@ -216,21 +206,14 @@ int show_interrupts(struct seq_file *p, void *v)
 skip:
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
-#ifdef CONFIG_PPC32
-#ifdef CONFIG_TAU_INT
+#if defined(CONFIG_PPC32) && defined(CONFIG_TAU_INT)
 		if (tau_initialized){
 			seq_puts(p, "TAU: ");
 			for_each_online_cpu(j)
 				seq_printf(p, "%10u ", tau_interrupts(j));
 			seq_puts(p, "  PowerPC             Thermal Assist (cpu temp)\n");
 		}
-#endif
-#if defined(CONFIG_SMP) && !defined(CONFIG_PPC_MERGE)
-		/* should this be per processor send/receive? */
-		seq_printf(p, "IPI (recv/sent): %10u/%u\n",
-				atomic_read(&ipi_recv), atomic_read(&ipi_sent));
-#endif
-#endif /* CONFIG_PPC32 */
+#endif /* CONFIG_PPC32 && CONFIG_TAU_INT*/
 		seq_printf(p, "BAD: %10u\n", ppc_spurious_interrupts);
 	}
 	return 0;
@@ -454,8 +437,6 @@ void do_softirq(void)
  * IRQ controller and virtual interrupts
  */
 
-#ifdef CONFIG_PPC_MERGE
-
 static LIST_HEAD(irq_hosts);
 static DEFINE_SPINLOCK(irq_big_lock);
 static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
@@ -1114,8 +1095,6 @@ static int __init irq_debugfs_init(void)
 __initcall(irq_debugfs_init);
 #endif /* CONFIG_VIRQ_DEBUG */
 
-#endif /* CONFIG_PPC_MERGE */
-
 #ifdef CONFIG_PPC64
 static int __init setup_noirqdistrib(char *str)
 {
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index e030f3b..957bded 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -276,10 +276,8 @@ int set_dabr(unsigned long dabr)
 {
 	__get_cpu_var(current_dabr) = dabr;
 
-#ifdef CONFIG_PPC_MERGE		/* XXX for now */
 	if (ppc_md.set_dabr)
 		return ppc_md.set_dabr(dabr);
-#endif
 
 	/* XXX should we have a CPU_FTR_HAS_DABR ? */
 #if defined(CONFIG_PPC64) || defined(CONFIG_6xx)
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index f177c60..65639a4 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -788,9 +788,7 @@ static int __init vdso_init(void)
 
 	return 0;
 }
-#ifdef CONFIG_PPC_MERGE
 arch_initcall(vdso_init);
-#endif
 
 int in_gate_area_no_task(unsigned long addr)
 {
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 2a88e8b..d69912c 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -6,12 +6,10 @@ ifeq ($(CONFIG_PPC64),y)
 EXTRA_CFLAGS		+= -mno-minimal-toc
 endif
 
-ifeq ($(CONFIG_PPC_MERGE),y)
 obj-y			:= string.o alloc.o \
 			   checksum_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o
 obj-$(CONFIG_HAS_IOMEM)	+= devres.o
-endif
 
 obj-$(CONFIG_PPC64)	+= copypage_64.o copyuser_64.o \
 			   memcpy_64.o usercopy_64.o mem_64.o string.o
diff --git a/arch/powerpc/platforms/52xx/Makefile b/arch/powerpc/platforms/52xx/Makefile
index daf0e15..b8a5206 100644
--- a/arch/powerpc/platforms/52xx/Makefile
+++ b/arch/powerpc/platforms/52xx/Makefile
@@ -1,10 +1,8 @@
 #
 # Makefile for 52xx based boards
 #
-ifeq ($(CONFIG_PPC_MERGE),y)
 obj-y				+= mpc52xx_pic.o mpc52xx_common.o
 obj-$(CONFIG_PCI)		+= mpc52xx_pci.o
-endif
 
 obj-$(CONFIG_PPC_MPC5200_SIMPLE) += mpc5200_simple.o
 obj-$(CONFIG_PPC_EFIKA)		+= efika.o
@@ -15,4 +13,4 @@ ifeq ($(CONFIG_PPC_LITE5200),y)
 	obj-$(CONFIG_PM)	+= lite5200_sleep.o lite5200_pm.o
 endif
 
-obj-$(CONFIG_PPC_MPC5200_GPIO)	+= mpc52xx_gpio.o
\ No newline at end of file
+obj-$(CONFIG_PPC_MPC5200_GPIO)	+= mpc52xx_gpio.o
diff --git a/arch/powerpc/platforms/Makefile b/arch/powerpc/platforms/Makefile
index 423a023..8079e0b 100644
--- a/arch/powerpc/platforms/Makefile
+++ b/arch/powerpc/platforms/Makefile
@@ -1,13 +1,7 @@
 
 obj-$(CONFIG_FSL_ULI1575)	+= fsl_uli1575.o
 
-ifeq ($(CONFIG_PPC_MERGE),y)
 obj-$(CONFIG_PPC_PMAC)		+= powermac/
-else
-ifeq ($(CONFIG_PPC64),y)
-obj-$(CONFIG_PPC_PMAC)		+= powermac/
-endif
-endif
 obj-$(CONFIG_PPC_CHRP)		+= chrp/
 obj-$(CONFIG_40x)		+= 40x/
 obj-$(CONFIG_44x)		+= 44x/
diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
index 8977417..58ecdd7 100644
--- a/arch/powerpc/platforms/powermac/Makefile
+++ b/arch/powerpc/platforms/powermac/Makefile
@@ -7,7 +7,7 @@ endif
 
 obj-y				+= pic.o setup.o time.o feature.o pci.o \
 				   sleep.o low_i2c.o cache.o pfunc_core.o \
-				   pfunc_base.o
+				   pfunc_base.o udbg_scc.o udbg_adb.o
 obj-$(CONFIG_PMAC_BACKLIGHT)	+= backlight.o
 obj-$(CONFIG_CPU_FREQ_PMAC)	+= cpufreq_32.o
 obj-$(CONFIG_CPU_FREQ_PMAC64)	+= cpufreq_64.o
@@ -19,4 +19,3 @@ obj-$(CONFIG_NVRAM:m=y)		+= nvram.o
 obj-$(CONFIG_PPC64)		+= nvram.o
 obj-$(CONFIG_PPC32)		+= bootx_init.o
 obj-$(CONFIG_SMP)		+= smp.o
-obj-$(CONFIG_PPC_MERGE)		+= udbg_scc.o udbg_adb.o
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 16a0ed2..a90054b 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_MV64X60)		+= $(mv64x60-y) mv64x60_pic.o mv64x60_dev.o \
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc_cmos_setup.o
 obj-$(CONFIG_AXON_RAM)		+= axonram.o
 
-ifeq ($(CONFIG_PPC_MERGE),y)
 obj-$(CONFIG_PPC_INDIRECT_PCI)	+= indirect_pci.o
 obj-$(CONFIG_PPC_I8259)		+= i8259.o
 obj-$(CONFIG_IPIC)		+= ipic.o
@@ -36,7 +35,6 @@ obj-$(CONFIG_OF_RTC)		+= of_rtc.o
 ifeq ($(CONFIG_PCI),y)
 obj-$(CONFIG_4xx)		+= ppc4xx_pci.o
 endif
-endif
 
 # Temporary hack until we have migrated to asm-powerpc
 ifeq ($(ARCH),powerpc)
diff --git a/include/asm-powerpc/dcr.h b/include/asm-powerpc/dcr.h
index 53b2830..d13fb68 100644
--- a/include/asm-powerpc/dcr.h
+++ b/include/asm-powerpc/dcr.h
@@ -65,17 +65,13 @@ typedef dcr_host_mmio_t dcr_host_t;
 #endif /* defined(CONFIG_PPC_DCR_NATIVE) && defined(CONFIG_PPC_DCR_MMIO) */
 
 /*
- * On CONFIG_PPC_MERGE, we have additional helpers to read the DCR
- * base from the device-tree
+ * additional helpers to read the DCR * base from the device-tree
  */
-#ifdef CONFIG_PPC_MERGE
 struct device_node;
 extern unsigned int dcr_resource_start(struct device_node *np,
 				       unsigned int index);
 extern unsigned int dcr_resource_len(struct device_node *np,
 				     unsigned int index);
-#endif /* CONFIG_PPC_MERGE */
-
 #endif /* CONFIG_PPC_DCR */
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
diff --git a/include/asm-powerpc/i8259.h b/include/asm-powerpc/i8259.h
index db1362f..105ade2 100644
--- a/include/asm-powerpc/i8259.h
+++ b/include/asm-powerpc/i8259.h
@@ -4,14 +4,9 @@
 
 #include <linux/irq.h>
 
-#ifdef CONFIG_PPC_MERGE
 extern void i8259_init(struct device_node *node, unsigned long intack_addr);
 extern unsigned int i8259_irq(void);
 extern struct irq_host *i8259_get_host(void);
-#else
-extern void i8259_init(unsigned long intack_addr, int offset);
-extern int i8259_irq(void);
-#endif
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_I8259_H */
diff --git a/include/asm-powerpc/ipic.h b/include/asm-powerpc/ipic.h
index 8ff08be..a90242c 100644
--- a/include/asm-powerpc/ipic.h
+++ b/include/asm-powerpc/ipic.h
@@ -79,15 +79,8 @@ extern void ipic_disable_mcp(enum ipic_mcp_irq mcp_irq);
 extern u32 ipic_get_mcp_status(void);
 extern void ipic_clear_mcp_status(u32 mask);
 
-#ifdef CONFIG_PPC_MERGE
 extern struct ipic * ipic_init(struct device_node *node, unsigned int flags);
 extern unsigned int ipic_get_irq(void);
-#else
-extern void ipic_init(phys_addr_t phys_addr, unsigned int flags,
-		unsigned int irq_offset,
-		unsigned char *senses, unsigned int senses_count);
-extern int ipic_get_irq(void);
-#endif
 
 #endif /* __ASM_IPIC_H__ */
 #endif /* __KERNEL__ */
diff --git a/include/asm-powerpc/irq.h b/include/asm-powerpc/irq.h
index 1ef8e30..a372f76 100644
--- a/include/asm-powerpc/irq.h
+++ b/include/asm-powerpc/irq.h
@@ -25,8 +25,6 @@
 
 extern atomic_t ppc_n_lost_interrupts;
 
-#ifdef CONFIG_PPC_MERGE
-
 /* This number is used when no interrupt has been assigned */
 #define NO_IRQ			(0)
 
@@ -326,292 +324,6 @@ static __inline__ int irq_canonicalize(int irq)
 	return irq;
 }
 
-
-#else /* CONFIG_PPC_MERGE */
-
-/* This number is used when no interrupt has been assigned */
-#define NO_IRQ			(-1)
-#define NO_IRQ_IGNORE		(-2)
-
-
-/*
- * These constants are used for passing information about interrupt
- * signal polarity and level/edge sensing to the low-level PIC chip
- * drivers.
- */
-#define IRQ_SENSE_MASK		0x1
-#define IRQ_SENSE_LEVEL		0x1	/* interrupt on active level */
-#define IRQ_SENSE_EDGE		0x0	/* interrupt triggered by edge */
-
-#define IRQ_POLARITY_MASK	0x2
-#define IRQ_POLARITY_POSITIVE	0x2	/* high level or low->high edge */
-#define IRQ_POLARITY_NEGATIVE	0x0	/* low level or high->low edge */
-
-
-#if defined(CONFIG_40x)
-#include <asm/ibm4xx.h>
-
-#ifndef NR_BOARD_IRQS
-#define NR_BOARD_IRQS 0
-#endif
-
-#ifndef UIC_WIDTH /* Number of interrupts per device */
-#define UIC_WIDTH 32
-#endif
-
-#ifndef NR_UICS /* number  of UIC devices */
-#define NR_UICS 1
-#endif
-
-#if defined (CONFIG_403)
-/*
- * The PowerPC 403 cores' Asynchronous Interrupt Controller (AIC) has
- * 32 possible interrupts, a majority of which are not implemented on
- * all cores. There are six configurable, external interrupt pins and
- * there are eight internal interrupts for the on-chip serial port
- * (SPU), DMA controller, and JTAG controller.
- *
- */
-
-#define	NR_AIC_IRQS 32
-#define	NR_IRQS	 (NR_AIC_IRQS + NR_BOARD_IRQS)
-
-#elif !defined (CONFIG_403)
-
-/*
- *  The PowerPC 405 cores' Universal Interrupt Controller (UIC) has 32
- * possible interrupts as well. There are seven, configurable external
- * interrupt pins and there are 17 internal interrupts for the on-chip
- * serial port, DMA controller, on-chip Ethernet controller, PCI, etc.
- *
- */
-
-
-#define NR_UIC_IRQS UIC_WIDTH
-#define NR_IRQS		((NR_UIC_IRQS * NR_UICS) + NR_BOARD_IRQS)
-#endif
-
-#elif defined(CONFIG_44x)
-#include <asm/ibm44x.h>
-
-#define	NR_UIC_IRQS	32
-#define	NR_IRQS		((NR_UIC_IRQS * NR_UICS) + NR_BOARD_IRQS)
-
-#elif defined(CONFIG_8xx)
-
-/* Now include the board configuration specific associations.
-*/
-#include <asm/mpc8xx.h>
-
-/* The MPC8xx cores have 16 possible interrupts.  There are eight
- * possible level sensitive interrupts assigned and generated internally
- * from such devices as CPM, PCMCIA, RTC, PIT, TimeBase and Decrementer.
- * There are eight external interrupts (IRQs) that can be configured
- * as either level or edge sensitive.
- *
- * On some implementations, there is also the possibility of an 8259
- * through the PCI and PCI-ISA bridges.
- *
- * We are "flattening" the interrupt vectors of the cascaded CPM
- * and 8259 interrupt controllers so that we can uniquely identify
- * any interrupt source with a single integer.
- */
-#define NR_SIU_INTS	16
-#define NR_CPM_INTS	32
-#ifndef NR_8259_INTS
-#define NR_8259_INTS 0
-#endif
-
-#define SIU_IRQ_OFFSET		0
-#define CPM_IRQ_OFFSET		(SIU_IRQ_OFFSET + NR_SIU_INTS)
-#define I8259_IRQ_OFFSET	(CPM_IRQ_OFFSET + NR_CPM_INTS)
-
-#define NR_IRQS	(NR_SIU_INTS + NR_CPM_INTS + NR_8259_INTS)
-
-/* These values must be zero-based and map 1:1 with the SIU configuration.
- * They are used throughout the 8xx I/O subsystem to generate
- * interrupt masks, flags, and other control patterns.  This is why the
- * current kernel assumption of the 8259 as the base controller is such
- * a pain in the butt.
- */
-#define	SIU_IRQ0	(0)	/* Highest priority */
-#define	SIU_LEVEL0	(1)
-#define	SIU_IRQ1	(2)
-#define	SIU_LEVEL1	(3)
-#define	SIU_IRQ2	(4)
-#define	SIU_LEVEL2	(5)
-#define	SIU_IRQ3	(6)
-#define	SIU_LEVEL3	(7)
-#define	SIU_IRQ4	(8)
-#define	SIU_LEVEL4	(9)
-#define	SIU_IRQ5	(10)
-#define	SIU_LEVEL5	(11)
-#define	SIU_IRQ6	(12)
-#define	SIU_LEVEL6	(13)
-#define	SIU_IRQ7	(14)
-#define	SIU_LEVEL7	(15)
-
-#define MPC8xx_INT_FEC1		SIU_LEVEL1
-#define MPC8xx_INT_FEC2		SIU_LEVEL3
-
-#define MPC8xx_INT_SCC1		(CPM_IRQ_OFFSET + CPMVEC_SCC1)
-#define MPC8xx_INT_SCC2		(CPM_IRQ_OFFSET + CPMVEC_SCC2)
-#define MPC8xx_INT_SCC3		(CPM_IRQ_OFFSET + CPMVEC_SCC3)
-#define MPC8xx_INT_SCC4		(CPM_IRQ_OFFSET + CPMVEC_SCC4)
-#define MPC8xx_INT_SMC1		(CPM_IRQ_OFFSET + CPMVEC_SMC1)
-#define MPC8xx_INT_SMC2		(CPM_IRQ_OFFSET + CPMVEC_SMC2)
-
-/* The internal interrupts we can configure as we see fit.
- * My personal preference is CPM at level 2, which puts it above the
- * MBX PCI/ISA/IDE interrupts.
- */
-#ifndef PIT_INTERRUPT
-#define PIT_INTERRUPT		SIU_LEVEL0
-#endif
-#ifndef	CPM_INTERRUPT
-#define CPM_INTERRUPT		SIU_LEVEL2
-#endif
-#ifndef	PCMCIA_INTERRUPT
-#define PCMCIA_INTERRUPT	SIU_LEVEL6
-#endif
-#ifndef	DEC_INTERRUPT
-#define DEC_INTERRUPT		SIU_LEVEL7
-#endif
-
-/* Some internal interrupt registers use an 8-bit mask for the interrupt
- * level instead of a number.
- */
-#define	mk_int_int_mask(IL) (1 << (7 - (IL/2)))
-
-#else /* CONFIG_40x + CONFIG_8xx */
-/*
- * this is the # irq's for all ppc arch's (pmac/chrp/prep)
- * so it is the max of them all
- */
-#define NR_IRQS			256
-#define __DO_IRQ_CANON	1
-
-#ifndef CONFIG_8260
-
-#define NUM_8259_INTERRUPTS	16
-
-#else /* CONFIG_8260 */
-
-/* The 8260 has an internal interrupt controller with a maximum of
- * 64 IRQs.  We will use NR_IRQs from above since it is large enough.
- * Don't be confused by the 8260 documentation where they list an
- * "interrupt number" and "interrupt vector".  We are only interested
- * in the interrupt vector.  There are "reserved" holes where the
- * vector number increases, but the interrupt number in the table does not.
- * (Document errata updates have fixed this...make sure you have up to
- * date processor documentation -- Dan).
- */
-
-#ifndef CPM_IRQ_OFFSET
-#define CPM_IRQ_OFFSET	0
-#endif
-
-#define NR_CPM_INTS	64
-
-#define	SIU_INT_ERROR		((uint)0x00 + CPM_IRQ_OFFSET)
-#define	SIU_INT_I2C		((uint)0x01 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SPI		((uint)0x02 + CPM_IRQ_OFFSET)
-#define	SIU_INT_RISC		((uint)0x03 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SMC1		((uint)0x04 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SMC2		((uint)0x05 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IDMA1		((uint)0x06 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IDMA2		((uint)0x07 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IDMA3		((uint)0x08 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IDMA4		((uint)0x09 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SDMA		((uint)0x0a + CPM_IRQ_OFFSET)
-#define	SIU_INT_USB		((uint)0x0b + CPM_IRQ_OFFSET)
-#define	SIU_INT_TIMER1		((uint)0x0c + CPM_IRQ_OFFSET)
-#define	SIU_INT_TIMER2		((uint)0x0d + CPM_IRQ_OFFSET)
-#define	SIU_INT_TIMER3		((uint)0x0e + CPM_IRQ_OFFSET)
-#define	SIU_INT_TIMER4		((uint)0x0f + CPM_IRQ_OFFSET)
-#define	SIU_INT_TMCNT		((uint)0x10 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PIT		((uint)0x11 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PCI		((uint)0x12 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ1		((uint)0x13 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ2		((uint)0x14 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ3		((uint)0x15 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ4		((uint)0x16 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ5		((uint)0x17 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ6		((uint)0x18 + CPM_IRQ_OFFSET)
-#define	SIU_INT_IRQ7		((uint)0x19 + CPM_IRQ_OFFSET)
-#define	SIU_INT_FCC1		((uint)0x20 + CPM_IRQ_OFFSET)
-#define	SIU_INT_FCC2		((uint)0x21 + CPM_IRQ_OFFSET)
-#define	SIU_INT_FCC3		((uint)0x22 + CPM_IRQ_OFFSET)
-#define	SIU_INT_MCC1		((uint)0x24 + CPM_IRQ_OFFSET)
-#define	SIU_INT_MCC2		((uint)0x25 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SCC1		((uint)0x28 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SCC2		((uint)0x29 + CPM_IRQ_OFFSET)
-#define	SIU_INT_SCC3		((uint)0x2a + CPM_IRQ_OFFSET)
-#define	SIU_INT_SCC4		((uint)0x2b + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC15		((uint)0x30 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC14		((uint)0x31 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC13		((uint)0x32 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC12		((uint)0x33 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC11		((uint)0x34 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC10		((uint)0x35 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC9		((uint)0x36 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC8		((uint)0x37 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC7		((uint)0x38 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC6		((uint)0x39 + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC5		((uint)0x3a + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC4		((uint)0x3b + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC3		((uint)0x3c + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC2		((uint)0x3d + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC1		((uint)0x3e + CPM_IRQ_OFFSET)
-#define	SIU_INT_PC0		((uint)0x3f + CPM_IRQ_OFFSET)
-
-#endif /* CONFIG_8260 */
-
-#endif /* Whatever way too big #ifdef */
-
-#define NR_MASK_WORDS	((NR_IRQS + 31) / 32)
-/* pedantic: these are long because they are used with set_bit --RR */
-extern unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
-
-/*
- * Because many systems have two overlapping names spaces for
- * interrupts (ISA and XICS for example), and the ISA interrupts
- * have historically not been easy to renumber, we allow ISA
- * interrupts to take values 0 - 15, and shift up the remaining
- * interrupts by 0x10.
- */
-#define NUM_ISA_INTERRUPTS	0x10
-extern int __irq_offset_value;
-
-static inline int irq_offset_up(int irq)
-{
-	return(irq + __irq_offset_value);
-}
-
-static inline int irq_offset_down(int irq)
-{
-	return(irq - __irq_offset_value);
-}
-
-static inline int irq_offset_value(void)
-{
-	return __irq_offset_value;
-}
-
-#ifdef __DO_IRQ_CANON
-extern int ppc_do_canonicalize_irqs;
-#else
-#define ppc_do_canonicalize_irqs	0
-#endif
-
-static __inline__ int irq_canonicalize(int irq)
-{
-	if (ppc_do_canonicalize_irqs && irq == 2)
-		irq = 9;
-	return irq;
-}
-#endif /* CONFIG_PPC_MERGE */
-
 extern int distribute_irqs;
 
 struct irqaction;
-- 
1.5.5.1

