Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYF3JXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYF3JXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYF3JWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:23 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62550 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbYF3JWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:20 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 8/8] avr32: Power Management support ("standby" and "mem" modes)
Date: Mon, 30 Jun 2008 11:21:16 +0200
Message-Id: <1214817676-30378-9-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-8-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-6-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-7-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-8-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:08.0211 (UTC) FILETIME=[A10CCC30:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Implement Standby support. In this mode, we'll suspend all drivers,
put the SDRAM in self-refresh mode and switch off the HSB bus
("frozen" mode.)

Implement Suspend-to-mem support. In this mode, we suspend all
drivers, put the SDRAM into self-refresh mode and switch off all
internal clocks except the 32 kHz oscillator ("stop" mode.)

The lowest-level suspend code runs from a small portion of SRAM
allocated at startup time. This gets rid of a small potential race
with the SDRAM where we might try to enter self-refresh mode in the
middle of an icache burst. We also relocate all interrupt and
exception handlers to SRAM during the small window when we enter and
exit the low-power modes.

We don't need to do any special tricks to start and stop the PLL. The
main clock is automatically gated by hardware until the PLL is stable.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/Kconfig                     |    5 +
 arch/avr32/mach-at32ap/Makefile        |    5 +
 arch/avr32/mach-at32ap/intc.c          |   54 +++++++-
 arch/avr32/mach-at32ap/pm-at32ap700x.S |  108 ++++++++++++++
 arch/avr32/mach-at32ap/pm.c            |  245 ++++++++++++++++++++++++++++++++
 arch/avr32/mach-at32ap/sdramc.h        |   76 ++++++++++
 include/asm-avr32/arch-at32ap/pm.h     |    3 +
 include/asm-avr32/thread_info.h        |    1 +
 8 files changed, 496 insertions(+), 1 deletions(-)
 create mode 100644 arch/avr32/mach-at32ap/pm.c
 create mode 100644 arch/avr32/mach-at32ap/sdramc.h

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 4ff3dea..da86525 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -202,6 +202,11 @@ endmenu
 
 menu "Power management options"
 
+source "kernel/power/Kconfig"
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+
 menu "CPU Frequency scaling"
 
 source "drivers/cpufreq/Kconfig"
diff --git a/arch/avr32/mach-at32ap/Makefile b/arch/avr32/mach-at32ap/Makefile
index cb44182..d5018e2 100644
--- a/arch/avr32/mach-at32ap/Makefile
+++ b/arch/avr32/mach-at32ap/Makefile
@@ -1,3 +1,8 @@
 obj-y				+= pdc.o clock.o intc.o extint.o pio.o hsmc.o
 obj-$(CONFIG_CPU_AT32AP700X)	+= at32ap700x.o pm-at32ap700x.o
 obj-$(CONFIG_CPU_FREQ_AT32AP)	+= cpufreq.o
+obj-$(CONFIG_PM)		+= pm.o
+
+ifeq ($(CONFIG_PM_DEBUG),y)
+CFLAGS_pm.o	+= -DDEBUG
+endif
diff --git a/arch/avr32/mach-at32ap/intc.c b/arch/avr32/mach-at32ap/intc.c
index 644a3fb..994c454 100644
--- a/arch/avr32/mach-at32ap/intc.c
+++ b/arch/avr32/mach-at32ap/intc.c
@@ -22,6 +22,10 @@ struct intc {
 	void __iomem		*regs;
 	struct irq_chip		chip;
 	struct sys_device	sysdev;
+#ifdef CONFIG_PM
+	unsigned long		suspend_ipr;
+	unsigned long		saved_ipr[64];
+#endif
 };
 
 extern struct platform_device at32_intc0_device;
@@ -138,8 +142,56 @@ fail:
 	panic("Interrupt controller initialization failed!\n");
 }
 
+#ifdef CONFIG_PM
+void intc_set_suspend_handler(unsigned long offset)
+{
+	intc0.suspend_ipr = offset;
+}
+
+static int intc_suspend(struct sys_device *sdev, pm_message_t state)
+{
+	struct intc *intc = container_of(sdev, struct intc, sysdev);
+	int i;
+
+	if (unlikely(!irqs_disabled())) {
+		pr_err("intc_suspend: called with interrupts enabled\n");
+		return -EINVAL;
+	}
+
+	if (unlikely(!intc->suspend_ipr)) {
+		pr_err("intc_suspend: suspend_ipr not initialized\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 64; i++) {
+		intc->saved_ipr[i] = intc_readl(intc, INTPR0 + 4 * i);
+		intc_writel(intc, INTPR0 + 4 * i, intc->suspend_ipr);
+	}
+
+	return 0;
+}
+
+static int intc_resume(struct sys_device *sdev)
+{
+	struct intc *intc = container_of(sdev, struct intc, sysdev);
+	int i;
+
+	WARN_ON(!irqs_disabled());
+
+	for (i = 0; i < 64; i++)
+		intc_writel(intc, INTPR0 + 4 * i, intc->saved_ipr[i]);
+
+	return 0;
+}
+#else
+#define intc_suspend	NULL
+#define intc_resume	NULL
+#endif
+
 static struct sysdev_class intc_class = {
-	.name	= "intc",
+	.name		= "intc",
+	.suspend	= intc_suspend,
+	.resume		= intc_resume,
 };
 
 static int __init intc_init_sysdev(void)
diff --git a/arch/avr32/mach-at32ap/pm-at32ap700x.S b/arch/avr32/mach-at32ap/pm-at32ap700x.S
index 949e248..0a53ad3 100644
--- a/arch/avr32/mach-at32ap/pm-at32ap700x.S
+++ b/arch/avr32/mach-at32ap/pm-at32ap700x.S
@@ -12,6 +12,12 @@
 #include <asm/thread_info.h>
 #include <asm/arch/pm.h>
 
+#include "pm.h"
+#include "sdramc.h"
+
+/* Same as 0xfff00000 but fits in a 21 bit signed immediate */
+#define PM_BASE	-0x100000
+
 	.section .bss, "wa", @nobits
 	.global	disable_idle_sleep
 	.type	disable_idle_sleep, @object
@@ -64,3 +70,105 @@ cpu_idle_skip_sleep:
 	unmask_interrupts
 	retal	r12
 	.size	cpu_idle_skip_sleep, . - cpu_idle_skip_sleep
+
+#ifdef CONFIG_PM
+	.section .init.text, "ax", @progbits
+
+	.global	pm_exception
+	.type	pm_exception, @function
+pm_exception:
+	/*
+	 * Exceptions are masked when we switch to this handler, so
+	 * we'll only get "unrecoverable" exceptions (offset 0.)
+	 */
+	sub	r12, pc, . - .Lpanic_msg
+	lddpc	pc, .Lpanic_addr
+
+	.align	2
+.Lpanic_addr:
+	.long	panic
+.Lpanic_msg:
+	.asciz	"Unrecoverable exception during suspend\n"
+	.size	pm_exception, . - pm_exception
+
+	.global	pm_irq0
+	.type	pm_irq0, @function
+pm_irq0:
+	/* Disable interrupts and return after the sleep instruction */
+	mfsr	r9, SYSREG_RSR_INT0
+	mtsr	SYSREG_RAR_INT0, r8
+	sbr	r9, SYSREG_GM_OFFSET
+	mtsr	SYSREG_RSR_INT0, r9
+	rete
+
+	/*
+	 * void cpu_enter_standby(unsigned long sdramc_base)
+	 *
+	 * Enter PM_SUSPEND_STANDBY mode. At this point, all drivers
+	 * are suspended and interrupts are disabled. Interrupts
+	 * marked as 'wakeup' event sources may still come along and
+	 * get us out of here.
+	 *
+	 * The SDRAM will be put into self-refresh mode (which does
+	 * not require a clock from the CPU), and the CPU will be put
+	 * into "frozen" mode (HSB bus stopped). The SDRAM controller
+	 * will automatically bring the SDRAM into normal mode on the
+	 * first access, and the power manager will automatically
+	 * start the HSB and CPU clocks upon a wakeup event.
+	 *
+	 * This code uses the same "skip sleep" technique as above.
+	 * It is very important that we jump directly to
+	 * cpu_after_sleep after the sleep instruction since that's
+	 * where we'll end up if the interrupt handler decides that we
+	 * need to skip the sleep instruction.
+	 */
+	.global	pm_standby
+	.type	pm_standby, @function
+pm_standby:
+	/*
+	 * interrupts are already masked at this point, and EVBA
+	 * points to pm_exception above.
+	 */
+	ld.w	r10, r12[SDRAMC_LPR]
+	sub	r8, pc, . - 1f		/* return address for irq handler */
+	mov	r11, SDRAMC_LPR_LPCB_SELF_RFR
+	bfins	r10, r11, 0, 2		/* LPCB <- self Refresh */
+	sync	0			/* flush write buffer */
+	st.w	r12[SDRAMC_LPR], r11	/* put SDRAM in self-refresh mode */
+	ld.w	r11, r12[SDRAMC_LPR]
+	unmask_interrupts
+	sleep	CPU_SLEEP_FROZEN
+1:	mask_interrupts
+	retal	r12
+	.size	pm_standby, . - pm_standby
+
+	.global	pm_suspend_to_ram
+	.type	pm_suspend_to_ram, @function
+pm_suspend_to_ram:
+	/*
+	 * interrupts are already masked at this point, and EVBA
+	 * points to pm_exception above.
+	 */
+	mov	r11, 0
+	cache	r11[2], 8		/* clean all dcache lines */
+	sync	0			/* flush write buffer */
+	ld.w	r10, r12[SDRAMC_LPR]
+	sub	r8, pc, . - 1f		/* return address for irq handler */
+	mov	r11, SDRAMC_LPR_LPCB_SELF_RFR
+	bfins	r10, r11, 0, 2		/* LPCB <- self refresh */
+	st.w	r12[SDRAMC_LPR], r10	/* put SDRAM in self-refresh mode */
+	ld.w	r11, r12[SDRAMC_LPR]
+
+	unmask_interrupts
+	sleep	CPU_SLEEP_STOP
+1:	mask_interrupts
+
+	retal	r12
+	.size	pm_suspend_to_ram, . - pm_suspend_to_ram
+
+	.global	pm_sram_end
+	.type	pm_sram_end, @function
+pm_sram_end:
+	.size	pm_sram_end, 0
+
+#endif /* CONFIG_PM */
diff --git a/arch/avr32/mach-at32ap/pm.c b/arch/avr32/mach-at32ap/pm.c
new file mode 100644
index 0000000..0b76432
--- /dev/null
+++ b/arch/avr32/mach-at32ap/pm.c
@@ -0,0 +1,245 @@
+/*
+ * AVR32 AP Power Management
+ *
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+#include <linux/io.h>
+#include <linux/suspend.h>
+#include <linux/vmalloc.h>
+
+#include <asm/cacheflush.h>
+#include <asm/sysreg.h>
+
+#include <asm/arch/pm.h>
+#include <asm/arch/sram.h>
+
+/* FIXME: This is only valid for AP7000 */
+#define SDRAMC_BASE	0xfff03800
+
+#include "sdramc.h"
+
+#define SRAM_PAGE_FLAGS	(SYSREG_BIT(TLBELO_D) | SYSREG_BF(SZ, 1)	\
+				| SYSREG_BF(AP, 3) | SYSREG_BIT(G))
+
+
+static unsigned long	pm_sram_start;
+static size_t		pm_sram_size;
+static struct vm_struct	*pm_sram_area;
+
+static void (*avr32_pm_enter_standby)(unsigned long sdramc_base);
+static void (*avr32_pm_enter_str)(unsigned long sdramc_base);
+
+/*
+ * Must be called with interrupts disabled. Exceptions will be masked
+ * on return (i.e. all exceptions will be "unrecoverable".)
+ */
+static void *avr32_pm_map_sram(void)
+{
+	unsigned long	vaddr;
+	unsigned long	page_addr;
+	u32		tlbehi;
+	u32		mmucr;
+
+	vaddr = (unsigned long)pm_sram_area->addr;
+	page_addr = pm_sram_start & PAGE_MASK;
+
+	/*
+	 * Mask exceptions and grab the first TLB entry. We won't be
+	 * needing it while sleeping.
+	 */
+	asm volatile("ssrf	%0" : : "i"(SYSREG_EM_OFFSET) : "memory");
+
+	mmucr = sysreg_read(MMUCR);
+	tlbehi = sysreg_read(TLBEHI);
+	sysreg_write(MMUCR, SYSREG_BFINS(DRP, 0, mmucr));
+
+	tlbehi = SYSREG_BF(ASID, SYSREG_BFEXT(ASID, tlbehi));
+	tlbehi |= vaddr & PAGE_MASK;
+	tlbehi |= SYSREG_BIT(TLBEHI_V);
+
+	sysreg_write(TLBELO, page_addr | SRAM_PAGE_FLAGS);
+	sysreg_write(TLBEHI, tlbehi);
+	__builtin_tlbw();
+
+	return (void *)(vaddr + pm_sram_start - page_addr);
+}
+
+/*
+ * Must be called with interrupts disabled. Exceptions will be
+ * unmasked on return.
+ */
+static void avr32_pm_unmap_sram(void)
+{
+	u32	mmucr;
+	u32	tlbehi;
+	u32	tlbarlo;
+
+	/* Going to update TLB entry at index 0 */
+	mmucr = sysreg_read(MMUCR);
+	tlbehi = sysreg_read(TLBEHI);
+	sysreg_write(MMUCR, SYSREG_BFINS(DRP, 0, mmucr));
+
+	/* Clear the "valid" bit */
+	tlbehi = SYSREG_BF(ASID, SYSREG_BFEXT(ASID, tlbehi));
+	sysreg_write(TLBEHI, tlbehi);
+
+	/* Mark it as "not accessed" */
+	tlbarlo = sysreg_read(TLBARLO);
+	sysreg_write(TLBARLO, tlbarlo | 0x80000000U);
+
+	/* Update the TLB */
+	__builtin_tlbw();
+
+	/* Unmask exceptions */
+	asm volatile("csrf	%0" : : "i"(SYSREG_EM_OFFSET) : "memory");
+}
+
+static int avr32_pm_valid_state(suspend_state_t state)
+{
+	switch (state) {
+	case PM_SUSPEND_ON:
+	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_MEM:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+static int avr32_pm_enter(suspend_state_t state)
+{
+	u32		lpr_saved;
+	u32		evba_saved;
+	void		*sram;
+
+	switch (state) {
+	case PM_SUSPEND_STANDBY:
+		sram = avr32_pm_map_sram();
+
+		/* Switch to in-sram exception handlers */
+		evba_saved = sysreg_read(EVBA);
+		sysreg_write(EVBA, (unsigned long)sram);
+
+		/*
+		 * Save the LPR register so that we can re-enable
+		 * SDRAM Low Power mode on resume.
+		 */
+		lpr_saved = sdramc_readl(LPR);
+		pr_debug("%s: Entering standby...\n", __func__);
+		avr32_pm_enter_standby(SDRAMC_BASE);
+		sdramc_writel(LPR, lpr_saved);
+
+		/* Switch back to regular exception handlers */
+		sysreg_write(EVBA, evba_saved);
+
+		avr32_pm_unmap_sram();
+		break;
+
+	case PM_SUSPEND_MEM:
+		sram = avr32_pm_map_sram();
+
+		/* Switch to in-sram exception handlers */
+		evba_saved = sysreg_read(EVBA);
+		sysreg_write(EVBA, (unsigned long)sram);
+
+		/*
+		 * Save the LPR register so that we can re-enable
+		 * SDRAM Low Power mode on resume.
+		 */
+		lpr_saved = sdramc_readl(LPR);
+		pr_debug("%s: Entering suspend-to-ram...\n", __func__);
+		avr32_pm_enter_str(SDRAMC_BASE);
+		sdramc_writel(LPR, lpr_saved);
+
+		/* Switch back to regular exception handlers */
+		sysreg_write(EVBA, evba_saved);
+
+		avr32_pm_unmap_sram();
+		break;
+
+	case PM_SUSPEND_ON:
+		pr_debug("%s: Entering idle...\n", __func__);
+		cpu_enter_idle();
+		break;
+
+	default:
+		pr_debug("%s: Invalid suspend state %d\n", __func__, state);
+		goto out;
+	}
+
+	pr_debug("%s: wakeup\n", __func__);
+
+out:
+	return 0;
+}
+
+static struct platform_suspend_ops avr32_pm_ops = {
+	.valid	= avr32_pm_valid_state,
+	.enter	= avr32_pm_enter,
+};
+
+static unsigned long avr32_pm_offset(void *symbol)
+{
+	extern u8 pm_exception[];
+
+	return (unsigned long)symbol - (unsigned long)pm_exception;
+}
+
+static int __init avr32_pm_init(void)
+{
+	extern u8 pm_exception[];
+	extern u8 pm_irq0[];
+	extern u8 pm_standby[];
+	extern u8 pm_suspend_to_ram[];
+	extern u8 pm_sram_end[];
+	void *dst;
+
+	/*
+	 * To keep things simple, we depend on not needing more than a
+	 * single page.
+	 */
+	pm_sram_size = avr32_pm_offset(pm_sram_end);
+	if (pm_sram_size > PAGE_SIZE)
+		goto err;
+
+	pm_sram_start = sram_alloc(pm_sram_size);
+	if (!pm_sram_start)
+		goto err_alloc_sram;
+
+	/* Grab a virtual area we can use later on. */
+	pm_sram_area = get_vm_area(pm_sram_size, VM_IOREMAP);
+	if (!pm_sram_area)
+		goto err_vm_area;
+	pm_sram_area->phys_addr = pm_sram_start;
+
+	local_irq_disable();
+	dst = avr32_pm_map_sram();
+	memcpy(dst, pm_exception, pm_sram_size);
+	flush_dcache_region(dst, pm_sram_size);
+	invalidate_icache_region(dst, pm_sram_size);
+	avr32_pm_unmap_sram();
+	local_irq_enable();
+
+	avr32_pm_enter_standby = dst + avr32_pm_offset(pm_standby);
+	avr32_pm_enter_str = dst + avr32_pm_offset(pm_suspend_to_ram);
+	intc_set_suspend_handler(avr32_pm_offset(pm_irq0));
+
+	suspend_set_ops(&avr32_pm_ops);
+
+	printk("AVR32 AP Power Management enabled\n");
+
+	return 0;
+
+err_vm_area:
+	sram_free(pm_sram_start, pm_sram_size);
+err_alloc_sram:
+err:
+	pr_err("AVR32 Power Management initialization failed\n");
+	return -ENOMEM;
+}
+arch_initcall(avr32_pm_init);
diff --git a/arch/avr32/mach-at32ap/sdramc.h b/arch/avr32/mach-at32ap/sdramc.h
new file mode 100644
index 0000000..66eeaed
--- /dev/null
+++ b/arch/avr32/mach-at32ap/sdramc.h
@@ -0,0 +1,76 @@
+/*
+ * Register definitions for the AT32AP SDRAM Controller
+ *
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+/* Register offsets */
+#define SDRAMC_MR			0x0000
+#define SDRAMC_TR			0x0004
+#define SDRAMC_CR			0x0008
+#define SDRAMC_HSR			0x000c
+#define SDRAMC_LPR			0x0010
+#define SDRAMC_IER			0x0014
+#define SDRAMC_IDR			0x0018
+#define SDRAMC_IMR			0x001c
+#define SDRAMC_ISR			0x0020
+#define SDRAMC_MDR			0x0024
+
+/* MR - Mode Register */
+#define SDRAMC_MR_MODE_NORMAL		(  0 <<  0)
+#define SDRAMC_MR_MODE_NOP		(  1 <<  0)
+#define SDRAMC_MR_MODE_BANKS_PRECHARGE	(  2 <<  0)
+#define SDRAMC_MR_MODE_LOAD_MODE	(  3 <<  0)
+#define SDRAMC_MR_MODE_AUTO_REFRESH	(  4 <<  0)
+#define SDRAMC_MR_MODE_EXT_LOAD_MODE	(  5 <<  0)
+#define SDRAMC_MR_MODE_POWER_DOWN	(  6 <<  0)
+
+/* CR - Configuration Register */
+#define SDRAMC_CR_NC_8_BITS		(  0 <<  0)
+#define SDRAMC_CR_NC_9_BITS		(  1 <<  0)
+#define SDRAMC_CR_NC_10_BITS		(  2 <<  0)
+#define SDRAMC_CR_NC_11_BITS		(  3 <<  0)
+#define SDRAMC_CR_NR_11_BITS		(  0 <<  2)
+#define SDRAMC_CR_NR_12_BITS		(  1 <<  2)
+#define SDRAMC_CR_NR_13_BITS		(  2 <<  2)
+#define SDRAMC_CR_NB_2_BANKS		(  0 <<  4)
+#define SDRAMC_CR_NB_4_BANKS		(  1 <<  4)
+#define SDRAMC_CR_CAS(x)		((x) <<  5)
+#define SDRAMC_CR_DBW_32_BITS		(  0 <<  7)
+#define SDRAMC_CR_DBW_16_BITS		(  1 <<  7)
+#define SDRAMC_CR_TWR(x)		((x) <<  8)
+#define SDRAMC_CR_TRC(x)		((x) << 12)
+#define SDRAMC_CR_TRP(x)		((x) << 16)
+#define SDRAMC_CR_TRCD(x)		((x) << 20)
+#define SDRAMC_CR_TRAS(x)		((x) << 24)
+#define SDRAMC_CR_TXSR(x)		((x) << 28)
+
+/* HSR - High Speed Register */
+#define SDRAMC_HSR_DA			(  1 <<  0)
+
+/* LPR - Low Power Register */
+#define SDRAMC_LPR_LPCB_INHIBIT		(  0 <<  0)
+#define SDRAMC_LPR_LPCB_SELF_RFR	(  1 <<  0)
+#define SDRAMC_LPR_LPCB_PDOWN		(  2 <<  0)
+#define SDRAMC_LPR_LPCB_DEEP_PDOWN	(  3 <<  0)
+#define SDRAMC_LPR_PASR(x)		((x) <<  4)
+#define SDRAMC_LPR_TCSR(x)		((x) <<  8)
+#define SDRAMC_LPR_DS(x)		((x) << 10)
+#define SDRAMC_LPR_TIMEOUT(x)		((x) << 12)
+
+/* IER/IDR/IMR/ISR - Interrupt Enable/Disable/Mask/Status Register */
+#define SDRAMC_ISR_RES			(  1 <<  0)
+
+/* MDR - Memory Device Register */
+#define SDRAMC_MDR_MD_SDRAM		(  0 <<  0)
+#define SDRAMC_MDR_MD_LOW_PWR_SDRAM	(  1 <<  0)
+
+/* Register access macros */
+#define sdramc_readl(reg) \
+	__raw_readl((void __iomem __force *)SDRAMC_BASE + SDRAMC_##reg)
+#define sdramc_writel(reg, value) \
+	__raw_writel(value, (void __iomem __force *)SDRAMC_BASE + SDRAMC_##reg)
diff --git a/include/asm-avr32/arch-at32ap/pm.h b/include/asm-avr32/arch-at32ap/pm.h
index 356e430..979b355 100644
--- a/include/asm-avr32/arch-at32ap/pm.h
+++ b/include/asm-avr32/arch-at32ap/pm.h
@@ -19,6 +19,7 @@
 
 #ifndef __ASSEMBLY__
 extern void cpu_enter_idle(void);
+extern void cpu_enter_standby(unsigned long sdramc_base);
 
 extern bool disable_idle_sleep;
 
@@ -43,6 +44,8 @@ static inline void cpu_idle_sleep(void)
 	else
 		cpu_enter_idle();
 }
+
+void intc_set_suspend_handler(unsigned long offset);
 #endif
 
 #endif /* __ASM_AVR32_ARCH_PM_H */
diff --git a/include/asm-avr32/thread_info.h b/include/asm-avr32/thread_info.h
index 07049f6..df68631 100644
--- a/include/asm-avr32/thread_info.h
+++ b/include/asm-avr32/thread_info.h
@@ -88,6 +88,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
+#define TIF_FREEZE		29
 #define TIF_DEBUG		30	/* debugging enabled */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
-- 
1.5.5.4

