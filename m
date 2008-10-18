Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbYJRCQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbYJRCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 22:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJRCQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 22:16:17 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:30821 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753457AbYJRCQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 22:16:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=EIxYKFGBve2mlRG9rkESi1rGzXoV7neAgsADIpPtvA5/TeuLsLcTc8ao82F5XbRXgA/7cZWlADMyVqTaP2pUnt5ShymHu/NaSPHALvKsl8RJ6E6sBFpFsTLfylvWCNX33hiTmXxg74VZT8lx5+aATB/ljRUNu8Wo8TOkOoUmmlI=  ;
X-YMail-OSG: 4JmmHEsVM1nWO_DvLBjCwwtc5lNYuyWSo37L0wE1eSGqBNhsqQ9Oh5ehm9V.YzFc3oNWxXwtmCRd6DVUH6IfkJTHgs.fjsnGknl0_fMe5YBtbeBdrZMj551lW5brQIJ_qdZUxuUOIDJNrwE8GUZ8ZzBjQYMzlN1CGniYfFbtNukoqNO9YNFvT7F.5JAGIBtKVffPZdz6aAhDKwmHMMt58qz9Wy6d6dgMLQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: [patch 1/3] twl4030 irq updates
Date: Fri, 17 Oct 2008 19:14:45 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810171914.45287.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

This updates the IRQ handling support for the twl4030 driver:

 - Move it into a separate file; clean and streamline it
 - Restructure the init code for reuse during secondary dispatch
 - Support both levels (primary, secondary) of IRQ dispatch
 - Use a workqueue for irq mask/unmask and trigger configuration

Code for two subchips currently share that secondary handler code.
One is the power subchip; its IRQs are now handled by this core,
courtesy of this patch.  The other is the GPIO module, which will
be supported through a later patch.

There are also minor changes to the header file, mostly related
to GPIO support; nothing yet in mainline cares about those.  A
few references to OMAP-specific symbols are disabled; when they
can all be removed, the TWL4030 support ceases being OMAP-specific.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
This should go on top of the current MFD queue; it brings the
relevant files in sync with what's in the linux-omap tree.

 drivers/mfd/Makefile        |    2 
 drivers/mfd/twl4030-core.c  |  485 ---------------------------
 drivers/mfd/twl4030-irq.c   |  743 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h |   28 -
 4 files changed, 777 insertions(+), 481 deletions(-)

--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -17,7 +17,7 @@ wm8350-objs			:= wm8350-core.o wm8350-re
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 
-obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o
+obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -27,15 +27,11 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include <linux/kernel_stat.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/random.h>
-#include <linux/kthread.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
@@ -93,26 +89,6 @@
 #define twl_has_usb()	false
 #endif
 
-static inline void activate_irq(int irq)
-{
-#ifdef CONFIG_ARM
-	/* ARM requires an extra step to clear IRQ_NOREQUEST, which it
-	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
-	 */
-	set_irq_flags(irq, IRQF_VALID);
-#else
-	/* same effect on other architectures */
-	set_irq_noprobe(irq);
-#endif
-}
-
-/* Primary Interrupt Handler on TWL4030 Registers */
-
-/* Register Definitions */
-
-#define REG_PIH_ISR_P1			(0x1)
-#define REG_PIH_ISR_P2			(0x2)
-#define REG_PIH_SIR			(0x3)
 
 /* Triton Core internal information (BEGIN) */
 
@@ -175,138 +151,6 @@ static inline void activate_irq(int irq)
 
 /*----------------------------------------------------------------------*/
 
-/**
- * struct twl4030_mod_iregs - TWL module IMR/ISR regs to mask/clear at init
- * @mod_no: TWL4030 module number (e.g., TWL4030_MODULE_GPIO)
- * @sih_ctrl: address of module SIH_CTRL register
- * @reg_cnt: number of IMR/ISR regs
- * @imrs: pointer to array of TWL module interrupt mask register indices
- * @isrs: pointer to array of TWL module interrupt status register indices
- *
- * Ties together TWL4030 modules and lists of IMR/ISR registers to mask/clear
- * during twl_init_irq().
- */
-struct twl4030_mod_iregs {
-	const u8 mod_no;
-	const u8 sih_ctrl;
-	const u8 reg_cnt;
-	const u8 *imrs;
-	const u8 *isrs;
-};
-
-/* TWL4030 INT module interrupt mask registers */
-static const u8 __initconst twl4030_int_imr_regs[] = {
-	TWL4030_INT_PWR_IMR1,
-	TWL4030_INT_PWR_IMR2,
-};
-
-/* TWL4030 INT module interrupt status registers */
-static const u8 __initconst twl4030_int_isr_regs[] = {
-	TWL4030_INT_PWR_ISR1,
-	TWL4030_INT_PWR_ISR2,
-};
-
-/* TWL4030 INTERRUPTS module interrupt mask registers */
-static const u8 __initconst twl4030_interrupts_imr_regs[] = {
-	TWL4030_INTERRUPTS_BCIIMR1A,
-	TWL4030_INTERRUPTS_BCIIMR1B,
-	TWL4030_INTERRUPTS_BCIIMR2A,
-	TWL4030_INTERRUPTS_BCIIMR2B,
-};
-
-/* TWL4030 INTERRUPTS module interrupt status registers */
-static const u8 __initconst twl4030_interrupts_isr_regs[] = {
-	TWL4030_INTERRUPTS_BCIISR1A,
-	TWL4030_INTERRUPTS_BCIISR1B,
-	TWL4030_INTERRUPTS_BCIISR2A,
-	TWL4030_INTERRUPTS_BCIISR2B,
-};
-
-/* TWL4030 MADC module interrupt mask registers */
-static const u8 __initconst twl4030_madc_imr_regs[] = {
-	TWL4030_MADC_IMR1,
-	TWL4030_MADC_IMR2,
-};
-
-/* TWL4030 MADC module interrupt status registers */
-static const u8 __initconst twl4030_madc_isr_regs[] = {
-	TWL4030_MADC_ISR1,
-	TWL4030_MADC_ISR2,
-};
-
-/* TWL4030 keypad module interrupt mask registers */
-static const u8 __initconst twl4030_keypad_imr_regs[] = {
-	TWL4030_KEYPAD_KEYP_IMR1,
-	TWL4030_KEYPAD_KEYP_IMR2,
-};
-
-/* TWL4030 keypad module interrupt status registers */
-static const u8 __initconst twl4030_keypad_isr_regs[] = {
-	TWL4030_KEYPAD_KEYP_ISR1,
-	TWL4030_KEYPAD_KEYP_ISR2,
-};
-
-/* TWL4030 GPIO module interrupt mask registers */
-static const u8 __initconst twl4030_gpio_imr_regs[] = {
-	REG_GPIO_IMR1A,
-	REG_GPIO_IMR1B,
-	REG_GPIO_IMR2A,
-	REG_GPIO_IMR2B,
-	REG_GPIO_IMR3A,
-	REG_GPIO_IMR3B,
-};
-
-/* TWL4030 GPIO module interrupt status registers */
-static const u8 __initconst twl4030_gpio_isr_regs[] = {
-	REG_GPIO_ISR1A,
-	REG_GPIO_ISR1B,
-	REG_GPIO_ISR2A,
-	REG_GPIO_ISR2B,
-	REG_GPIO_ISR3A,
-	REG_GPIO_ISR3B,
-};
-
-/* TWL4030 modules that have IMR/ISR registers that must be masked/cleared */
-static const struct twl4030_mod_iregs __initconst twl4030_mod_regs[] = {
-	{
-		.mod_no	  = TWL4030_MODULE_INT,
-		.sih_ctrl = TWL4030_INT_PWR_SIH_CTRL,
-		.reg_cnt  = ARRAY_SIZE(twl4030_int_imr_regs),
-		.imrs	  = twl4030_int_imr_regs,
-		.isrs	  = twl4030_int_isr_regs,
-	},
-	{
-		.mod_no	  = TWL4030_MODULE_INTERRUPTS,
-		.sih_ctrl = TWL4030_INTERRUPTS_BCISIHCTRL,
-		.reg_cnt  = ARRAY_SIZE(twl4030_interrupts_imr_regs),
-		.imrs	  = twl4030_interrupts_imr_regs,
-		.isrs	  = twl4030_interrupts_isr_regs,
-	},
-	{
-		.mod_no	  = TWL4030_MODULE_MADC,
-		.sih_ctrl = TWL4030_MADC_SIH_CTRL,
-		.reg_cnt  = ARRAY_SIZE(twl4030_madc_imr_regs),
-		.imrs	  = twl4030_madc_imr_regs,
-		.isrs	  = twl4030_madc_isr_regs,
-	},
-	{
-		.mod_no	  = TWL4030_MODULE_KEYPAD,
-		.sih_ctrl = TWL4030_KEYPAD_KEYP_SIH_CTRL,
-		.reg_cnt  = ARRAY_SIZE(twl4030_keypad_imr_regs),
-		.imrs	  = twl4030_keypad_imr_regs,
-		.isrs	  = twl4030_keypad_isr_regs,
-	},
-	{
-		.mod_no	  = TWL4030_MODULE_GPIO,
-		.sih_ctrl = REG_GPIO_SIH_CTRL,
-		.reg_cnt  = ARRAY_SIZE(twl4030_gpio_imr_regs),
-		.imrs	  = twl4030_gpio_imr_regs,
-		.isrs	  = twl4030_gpio_isr_regs,
-	},
-};
-
-/*----------------------------------------------------------------*/
-
 /* is driver active, bound to a chip? */
 static bool inuse;
 
@@ -367,33 +211,6 @@ static struct twl4030mapping twl4030_map
 
 /*----------------------------------------------------------------------*/
 
-/*
- * TWL4030 doesn't have PIH mask, hence dummy function for mask
- * and unmask of the (eight) interrupts reported at that level ...
- * masking is only available from SIH (secondary) modules.
- */
-
-static void twl4030_i2c_ackirq(unsigned int irq)
-{
-}
-
-static void twl4030_i2c_disableint(unsigned int irq)
-{
-}
-
-static void twl4030_i2c_enableint(unsigned int irq)
-{
-}
-
-static struct irq_chip twl4030_irq_chip = {
-	.name	= "twl4030",
-	.ack	= twl4030_i2c_ackirq,
-	.mask	= twl4030_i2c_disableint,
-	.unmask	= twl4030_i2c_enableint,
-};
-
-/*----------------------------------------------------------------------*/
-
 /* Exported Functions */
 
 /**
@@ -536,171 +353,10 @@ EXPORT_SYMBOL(twl4030_i2c_read_u8);
 /*----------------------------------------------------------------------*/
 
 /*
- * do_twl4030_module_irq() is the desc->handle method for each of the twl4030
- * module interrupts that doesn't chain to another irq_chip (GPIO, power, etc).
- * It executes in kernel thread context.  On entry, cpu interrupts are disabled.
- */
-static void do_twl4030_module_irq(unsigned int irq, irq_desc_t *desc)
-{
-	struct irqaction *action;
-	const unsigned int cpu = smp_processor_id();
-
-	/*
-	 * Earlier this was desc->triggered = 1;
-	 */
-	desc->status |= IRQ_LEVEL;
-
-	/*
-	 * The desc->handle method would normally call the desc->chip->ack
-	 * method here, but we won't bother since our ack method is NULL.
-	 */
-
-	if (!desc->depth) {
-		kstat_cpu(cpu).irqs[irq]++;
-
-		action = desc->action;
-		if (action) {
-			int ret;
-			int status = 0;
-			int retval = 0;
-
-			local_irq_enable();
-
-			do {
-				/* Call the ISR with cpu interrupts enabled */
-				ret = action->handler(irq, action->dev_id);
-				if (ret == IRQ_HANDLED)
-					status |= action->flags;
-				retval |= ret;
-				action = action->next;
-			} while (action);
-
-			if (status & IRQF_SAMPLE_RANDOM)
-				add_interrupt_randomness(irq);
-
-			local_irq_disable();
-
-			if (retval != IRQ_HANDLED)
-				printk(KERN_ERR "ISR for TWL4030 module"
-					" irq %d can't handle interrupt\n",
-					irq);
-
-			/*
-			 * Here is where we should call the unmask method, but
-			 * again we won't bother since it is NULL.
-			 */
-		} else
-			printk(KERN_CRIT "TWL4030 module irq %d has no ISR"
-					" but can't be masked!\n", irq);
-	} else
-		printk(KERN_CRIT "TWL4030 module irq %d is disabled but can't"
-				" be masked!\n", irq);
-}
-
-static unsigned twl4030_irq_base;
-
-static struct completion irq_event;
-
-/*
- * This thread processes interrupts reported by the Primary Interrupt Handler.
- */
-static int twl4030_irq_thread(void *data)
-{
-	long irq = (long)data;
-	irq_desc_t *desc = irq_desc + irq;
-	static unsigned i2c_errors;
-	const static unsigned max_i2c_errors = 100;
-
-	daemonize("twl4030-irq");
-	current->flags |= PF_NOFREEZE;
-
-	while (!kthread_should_stop()) {
-		int ret;
-		int module_irq;
-		u8 pih_isr;
-
-		/* Wait for IRQ, then read PIH irq status (also blocking) */
-		wait_for_completion_interruptible(&irq_event);
-
-		ret = twl4030_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
-					  REG_PIH_ISR_P1);
-		if (ret) {
-			pr_warning("%s: I2C error %d reading PIH ISR\n",
-					DRIVER_NAME, ret);
-			if (++i2c_errors >= max_i2c_errors) {
-				printk(KERN_ERR "Maximum I2C error count"
-						" exceeded.  Terminating %s.\n",
-						__func__);
-				break;
-			}
-			complete(&irq_event);
-			continue;
-		}
-
-		/* these handlers deal with the relevant SIH irq status */
-		local_irq_disable();
-		for (module_irq = twl4030_irq_base;
-				pih_isr;
-				pih_isr >>= 1, module_irq++) {
-			if (pih_isr & 0x1) {
-				irq_desc_t *d = irq_desc + module_irq;
-
-				d->handle_irq(module_irq, d);
-			}
-		}
-		local_irq_enable();
-
-		desc->chip->unmask(irq);
-	}
-
-	return 0;
-}
-
-/*
- * do_twl4030_irq() is the desc->handle method for the twl4030 interrupt.
- * This is a chained interrupt, so there is no desc->action method for it.
- * Now we need to query the interrupt controller in the twl4030 to determine
- * which module is generating the interrupt request.  However, we can't do i2c
- * transactions in interrupt context, so we must defer that work to a kernel
- * thread.  All we do here is acknowledge and mask the interrupt and wakeup
- * the kernel thread.
+ * NOTE:  We know the first 8 IRQs after pdata->base_irq are
+ * for the PIH, and the next are for the PWR_INT SIH, since
+ * that's how twl_init_irq() sets things up.
  */
-static void do_twl4030_irq(unsigned int irq, irq_desc_t *desc)
-{
-	const unsigned int cpu = smp_processor_id();
-
-	/*
-	 * Earlier this was desc->triggered = 1;
-	 */
-	desc->status |= IRQ_LEVEL;
-
-	/*
-	 * Acknowledge, clear _AND_ disable the interrupt.
-	 */
-	desc->chip->ack(irq);
-
-	if (!desc->depth) {
-		kstat_cpu(cpu).irqs[irq]++;
-
-		complete(&irq_event);
-	}
-}
-
-static struct task_struct * __init start_twl4030_irq_thread(long irq)
-{
-	struct task_struct *thread;
-
-	init_completion(&irq_event);
-	thread = kthread_run(twl4030_irq_thread, (void *)irq,
-			     "twl4030 irq %ld", irq);
-	if (!thread)
-		pr_err("%s: could not create twl4030 irq %ld thread!\n",
-		       DRIVER_NAME, irq);
-
-	return thread;
-}
-
-/*----------------------------------------------------------------------*/
 
 static int add_children(struct twl4030_platform_data *pdata)
 {
@@ -732,7 +388,7 @@ static int add_children(struct twl4030_p
 
 		if (status == 0) {
 			struct resource r = {
-				.start = TWL4030_PWRIRQ_CHG_PRES,
+				.start = pdata->irq_base + 8 + 1,
 				.flags = IORESOURCE_IRQ,
 			};
 
@@ -881,8 +537,7 @@ static int add_children(struct twl4030_p
 		/* RTC module IRQ */
 		if (status == 0) {
 			struct resource	r = {
-				/* REVISIT don't hard-wire this stuff */
-				.start = TWL4030_PWRIRQ_RTC,
+				.start = pdata->irq_base + 8 + 3,
 				.flags = IORESOURCE_IRQ,
 			};
 
@@ -927,7 +582,7 @@ static int add_children(struct twl4030_p
 
 		if (status == 0) {
 			struct resource r = {
-				.start = TWL4030_PWRIRQ_USB_PRES,
+				.start = pdata->irq_base + 8 + 2,
 				.flags = IORESOURCE_IRQ,
 			};
 
@@ -1029,123 +684,17 @@ static void __init clocks_init(void)
 
 /*----------------------------------------------------------------------*/
 
-/**
- * twl4030_i2c_clear_isr - clear TWL4030 SIH ISR regs via read + write
- * @mod_no: TWL4030 module number
- * @reg: register index to clear
- * @cor: value of the <module>_SIH_CTRL.COR bit (1 or 0)
- *
- * Either reads (cor == 1) or writes (cor == 0) to a TWL4030 interrupt
- * status register to ensure that any prior interrupts are cleared.
- * Returns the status from the I2C read operation.
- */
-static int __init twl4030_i2c_clear_isr(u8 mod_no, u8 reg, u8 cor)
-{
-	u8 tmp;
-
-	return (cor) ? twl4030_i2c_read_u8(mod_no, &tmp, reg) :
-		twl4030_i2c_write_u8(mod_no, 0xff, reg);
-}
-
-/**
- * twl4030_read_cor_bit - are TWL module ISRs cleared by reads or writes?
- * @mod_no: TWL4030 module number
- * @reg: register index to clear
- *
- * Returns 1 if the TWL4030 SIH interrupt status registers (ISRs) for
- * the specified TWL module are cleared by reads, or 0 if cleared by
- * writes.
- */
-static int twl4030_read_cor_bit(u8 mod_no, u8 reg)
-{
-	u8 tmp = 0;
-
-	WARN_ON(twl4030_i2c_read_u8(mod_no, &tmp, reg) < 0);
-
-	tmp &= TWL4030_SIH_CTRL_COR_MASK;
-	tmp >>= __ffs(TWL4030_SIH_CTRL_COR_MASK);
-
-	return tmp;
-}
-
-/**
- * twl4030_mask_clear_intrs - mask and clear all TWL4030 interrupts
- * @t: pointer to twl4030_mod_iregs array
- * @t_sz: ARRAY_SIZE(t) (starting at 1)
- *
- * Mask all TWL4030 interrupt mask registers (IMRs) and clear all
- * interrupt status registers (ISRs).  No return value, but will WARN if
- * any I2C operations fail.
- */
-static void __init twl4030_mask_clear_intrs(const struct twl4030_mod_iregs *t,
-					    const u8 t_sz)
-{
-	int i, j;
-
-	/*
-	 * N.B. - further efficiency is possible here.  Eight I2C
-	 * operations on BCI and GPIO modules are avoidable if I2C
-	 * burst read/write transactions were implemented.  Would
-	 * probably save about 1ms of boot time and a small amount of
-	 * power.
-	 */
-	for (i = 0; i < t_sz; i++) {
-		const struct twl4030_mod_iregs tmr = t[i];
-		int cor;
-
-		/* Are ISRs cleared by reads or writes? */
-		cor = twl4030_read_cor_bit(tmr.mod_no, tmr.sih_ctrl);
-
-		for (j = 0; j < tmr.reg_cnt; j++) {
-
-			/* Mask interrupts at the TWL4030 */
-			WARN_ON(twl4030_i2c_write_u8(tmr.mod_no, 0xff,
-						     tmr.imrs[j]) < 0);
-
-			/* Clear TWL4030 ISRs */
-			WARN_ON(twl4030_i2c_clear_isr(tmr.mod_no,
-						      tmr.isrs[j], cor) < 0);
-		}
-	}
-}
-
-
-static void twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
-{
-	int	i;
-
-	/*
-	 * Mask and clear all TWL4030 interrupts since initially we do
-	 * not have any TWL4030 module interrupt handlers present
-	 */
-	twl4030_mask_clear_intrs(twl4030_mod_regs,
-				 ARRAY_SIZE(twl4030_mod_regs));
-
-	twl4030_irq_base = irq_base;
-
-	/* install an irq handler for each of the PIH modules */
-	for (i = irq_base; i < irq_end; i++) {
-		set_irq_chip_and_handler(i, &twl4030_irq_chip,
-				do_twl4030_module_irq);
-		activate_irq(i);
-	}
-
-	/* install an irq handler to demultiplex the TWL4030 interrupt */
-	set_irq_data(irq_num, start_twl4030_irq_thread(irq_num));
-	set_irq_chained_handler(irq_num, do_twl4030_irq);
-}
-
-/*----------------------------------------------------------------------*/
+int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
+int twl_exit_irq(void);
 
 static int twl4030_remove(struct i2c_client *client)
 {
 	unsigned i;
+	int status;
 
-	/* FIXME undo twl_init_irq() */
-	if (twl4030_irq_base) {
-		dev_err(&client->dev, "can't yet clean up IRQs?\n");
-		return -ENOSYS;
-	}
+	status = twl_exit_irq();
+	if (status < 0)
+		return status;
 
 	for (i = 0; i < TWL4030_NUM_SLAVES; i++) {
 		struct twl4030_client	*twl = &twl4030_modules[i];
@@ -1176,7 +725,7 @@ twl4030_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	if (inuse || twl4030_irq_base) {
+	if (inuse) {
 		dev_dbg(&client->dev, "driver is already in use\n");
 		return -EBUSY;
 	}
@@ -1210,9 +759,9 @@ twl4030_probe(struct i2c_client *client,
 	if (client->irq
 			&& pdata->irq_base
 			&& pdata->irq_end > pdata->irq_base) {
-		twl_init_irq(client->irq, pdata->irq_base, pdata->irq_end);
-		dev_info(&client->dev, "IRQ %d chains IRQs %d..%d\n",
-				client->irq, pdata->irq_base, pdata->irq_end - 1);
+		status = twl_init_irq(client->irq, pdata->irq_base, pdata->irq_end);
+		if (status < 0)
+			goto fail;
 	}
 
 	status = add_children(pdata);
--- /dev/null
+++ b/drivers/mfd/twl4030-irq.c
@@ -0,0 +1,743 @@
+/*
+ * twl4030-irq.c - TWL4030/TPS659x0 irq support
+ *
+ * Copyright (C) 2005-2006 Texas Instruments, Inc.
+ *
+ * Modifications to defer interrupt handling to a kernel thread:
+ * Copyright (C) 2006 MontaVista Software, Inc.
+ *
+ * Based on tlv320aic23.c:
+ * Copyright (c) by Kai Svahn <kai.svahn@nokia.com>
+ *
+ * Code cleanup and modifications to IRQ handler.
+ * by syed khasim <x0khasim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kthread.h>
+
+#include <linux/i2c/twl4030.h>
+
+
+/*
+ * TWL4030 IRQ handling has two stages in hardware, and thus in software.
+ * The Primary Interrupt Handler (PIH) stage exposes status bits saying
+ * which Secondary Interrupt Handler (SIH) stage is raising an interrupt.
+ * SIH modules are more traditional IRQ components, which support per-IRQ
+ * enable/disable and trigger controls; they do most of the work.
+ *
+ * These chips are designed to support IRQ handling from two different
+ * I2C masters.  Each has a dedicated IRQ line, and dedicated IRQ status
+ * and mask registers in the PIH and SIH modules.
+ *
+ * We set up IRQs starting at a platform-specified base, always starting
+ * with PIH and the SIH for PWR_INT and then usually adding GPIO:
+ *	base + 0  .. base + 7	PIH
+ *	base + 8  .. base + 15	SIH for PWR_INT
+ *	base + 16 .. base + 33	SIH for GPIO
+ */
+
+/* PIH register offsets */
+#define REG_PIH_ISR_P1			0x01
+#define REG_PIH_ISR_P2			0x02
+#define REG_PIH_SIR			0x03	/* for testing */
+
+
+/* Linux could (eventually) use either IRQ line */
+static int irq_line;
+
+struct sih {
+	char	name[8];
+	u8	module;			/* module id */
+	u8	control_offset;		/* for SIH_CTRL */
+	bool	set_cor;
+
+	u8	bits;			/* valid in isr/imr */
+	u8	bytes_ixr;		/* bytelen of ISR/IMR/SIR */
+
+	u8	edr_offset;
+	u8	bytes_edr;		/* bytelen of EDR */
+
+	/* SIR ignored -- set interrupt, for testing only */
+	struct irq_data {
+		u8	isr_offset;
+		u8	imr_offset;
+	} mask[2];
+	/* + 2 bytes padding */
+};
+
+#define SIH_INITIALIZER(modname, nbits) \
+	.module		= TWL4030_MODULE_ ## modname, \
+	.control_offset = TWL4030_ ## modname ## _SIH_CTRL, \
+	.bits		= nbits, \
+	.bytes_ixr	= DIV_ROUND_UP(nbits, 8), \
+	.edr_offset	= TWL4030_ ## modname ## _EDR, \
+	.bytes_edr	= DIV_ROUND_UP((2*(nbits)), 8), \
+	.mask = { { \
+		.isr_offset	= TWL4030_ ## modname ## _ISR1, \
+		.imr_offset	= TWL4030_ ## modname ## _IMR1, \
+	}, \
+	{ \
+		.isr_offset	= TWL4030_ ## modname ## _ISR2, \
+		.imr_offset	= TWL4030_ ## modname ## _IMR2, \
+	}, },
+
+/* register naming policies are inconsistent ... */
+#define TWL4030_INT_PWR_EDR		TWL4030_INT_PWR_EDR1
+#define TWL4030_MODULE_KEYPAD_KEYP	TWL4030_MODULE_KEYPAD
+#define TWL4030_MODULE_INT_PWR		TWL4030_MODULE_INT
+
+
+/* Order in this table matches order in PIH_ISR.  That is,
+ * BIT(n) in PIH_ISR is sih_modules[n].
+ */
+static const struct sih sih_modules[6] = {
+	[0] = {
+		.name		= "gpio",
+		.module		= TWL4030_MODULE_GPIO,
+		.control_offset	= REG_GPIO_SIH_CTRL,
+		.set_cor	= true,
+		.bits		= TWL4030_GPIO_MAX,
+		.bytes_ixr	= 3,
+		/* Note: *all* of these IRQs default to no-trigger */
+		.edr_offset	= REG_GPIO_EDR1,
+		.bytes_edr	= 5,
+		.mask = { {
+			.isr_offset	= REG_GPIO_ISR1A,
+			.imr_offset	= REG_GPIO_IMR1A,
+		}, {
+			.isr_offset	= REG_GPIO_ISR1B,
+			.imr_offset	= REG_GPIO_IMR1B,
+		}, },
+	},
+	[1] = {
+		.name		= "keypad",
+		.set_cor	= true,
+		SIH_INITIALIZER(KEYPAD_KEYP, 4)
+	},
+	[2] = {
+		.name		= "bci",
+		.module		= TWL4030_MODULE_INTERRUPTS,
+		.control_offset	= TWL4030_INTERRUPTS_BCISIHCTRL,
+		.bits		= 12,
+		.bytes_ixr	= 2,
+		.edr_offset	= TWL4030_INTERRUPTS_BCIEDR1,
+		/* Note: most of these IRQs default to no-trigger */
+		.bytes_edr	= 3,
+		.mask = { {
+			.isr_offset	= TWL4030_INTERRUPTS_BCIISR1A,
+			.imr_offset	= TWL4030_INTERRUPTS_BCIIMR1A,
+		}, {
+			.isr_offset	= TWL4030_INTERRUPTS_BCIISR1B,
+			.imr_offset	= TWL4030_INTERRUPTS_BCIIMR1B,
+		}, },
+	},
+	[3] = {
+		.name		= "madc",
+		SIH_INITIALIZER(MADC, 4)
+	},
+	[4] = {
+		/* USB doesn't use the same SIH organization */
+		.name		= "usb",
+	},
+	[5] = {
+		.name		= "power",
+		.set_cor	= true,
+		SIH_INITIALIZER(INT_PWR, 8)
+	},
+		/* there are no SIH modules #6 or #7 ... */
+};
+
+#undef TWL4030_MODULE_KEYPAD_KEYP
+#undef TWL4030_MODULE_INT_PWR
+#undef TWL4030_INT_PWR_EDR
+
+/*----------------------------------------------------------------------*/
+
+static unsigned twl4030_irq_base;
+
+static struct completion irq_event;
+
+/*
+ * This thread processes interrupts reported by the Primary Interrupt Handler.
+ */
+static int twl4030_irq_thread(void *data)
+{
+	long irq = (long)data;
+	irq_desc_t *desc = irq_desc + irq;
+	static unsigned i2c_errors;
+	const static unsigned max_i2c_errors = 100;
+
+	current->flags |= PF_NOFREEZE;
+
+	while (!kthread_should_stop()) {
+		int ret;
+		int module_irq;
+		u8 pih_isr;
+
+		/* Wait for IRQ, then read PIH irq status (also blocking) */
+		wait_for_completion_interruptible(&irq_event);
+
+		ret = twl4030_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
+					  REG_PIH_ISR_P1);
+		if (ret) {
+			pr_warning("twl4030: I2C error %d reading PIH ISR\n",
+					ret);
+			if (++i2c_errors >= max_i2c_errors) {
+				printk(KERN_ERR "Maximum I2C error count"
+						" exceeded.  Terminating %s.\n",
+						__func__);
+				break;
+			}
+			complete(&irq_event);
+			continue;
+		}
+
+		/* these handlers deal with the relevant SIH irq status */
+		local_irq_disable();
+		for (module_irq = twl4030_irq_base;
+				pih_isr;
+				pih_isr >>= 1, module_irq++) {
+			if (pih_isr & 0x1) {
+				irq_desc_t *d = irq_desc + module_irq;
+
+				/* These can't be masked ... always warn
+				 * if we get any surprises.
+				 */
+				if (d->status & IRQ_DISABLED)
+					note_interrupt(module_irq, d,
+							IRQ_NONE);
+				else
+					d->handle_irq(module_irq, d);
+			}
+		}
+		local_irq_enable();
+
+		desc->chip->unmask(irq);
+	}
+
+	return 0;
+}
+
+/*
+ * handle_twl4030_pih() is the desc->handle method for the twl4030 interrupt.
+ * This is a chained interrupt, so there is no desc->action method for it.
+ * Now we need to query the interrupt controller in the twl4030 to determine
+ * which module is generating the interrupt request.  However, we can't do i2c
+ * transactions in interrupt context, so we must defer that work to a kernel
+ * thread.  All we do here is acknowledge and mask the interrupt and wakeup
+ * the kernel thread.
+ */
+static void handle_twl4030_pih(unsigned int irq, irq_desc_t *desc)
+{
+	/* Acknowledge, clear *AND* mask the interrupt... */
+	desc->chip->ack(irq);
+	complete(&irq_event);
+}
+
+static struct task_struct *start_twl4030_irq_thread(long irq)
+{
+	struct task_struct *thread;
+
+	init_completion(&irq_event);
+	thread = kthread_run(twl4030_irq_thread, (void *)irq, "twl4030-irq");
+	if (!thread)
+		pr_err("twl4030: could not create irq %ld thread!\n", irq);
+
+	return thread;
+}
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * twl4030_init_sih_modules() ... start from a known state where no
+ * IRQs will be coming in, and where we can quickly enable them then
+ * handle them as they arrive.  Mask all IRQs: maybe init SIH_CTRL.
+ *
+ * NOTE:  we don't touch EDR registers here; they stay with hardware
+ * defaults or whatever the last value was.  Note that when both EDR
+ * bits for an IRQ are clear, that's as if its IMR bit is set...
+ */
+static int twl4030_init_sih_modules(unsigned line)
+{
+	const struct sih *sih;
+	u8 buf[4];
+	int i;
+	int status;
+
+	/* line 0 == int1_n signal; line 1 == int2_n signal */
+	if (line > 1)
+		return -EINVAL;
+
+	irq_line = line;
+
+	/* disable all interrupts on our line */
+	memset(buf, 0xff, sizeof buf);
+	sih = sih_modules;
+	for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
+
+		/* skip USB -- it's funky */
+		if (!sih->bytes_ixr)
+			continue;
+
+		status = twl4030_i2c_write(sih->module, buf,
+				sih->mask[line].imr_offset, sih->bytes_ixr);
+		if (status < 0)
+			pr_err("twl4030: err %d initializing %s %s\n",
+					status, sih->name, "IMR");
+
+		/* Maybe disable "exclusive" mode; buffer second pending irq;
+		 * set Clear-On-Read (COR) bit.
+		 *
+		 * NOTE that sometimes COR polarity is documented as being
+		 * inverted:  for MADC and BCI, COR=1 means "clear on write".
+		 * And for PWR_INT it's not documented...
+		 */
+		if (sih->set_cor) {
+			status = twl4030_i2c_write_u8(sih->module,
+					TWL4030_SIH_CTRL_COR_MASK,
+					sih->control_offset);
+			if (status < 0)
+				pr_err("twl4030: err %d initializing %s %s\n",
+						status, sih->name, "SIH_CTRL");
+		}
+	}
+
+	sih = sih_modules;
+	for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
+		u8 rxbuf[4];
+		int j;
+
+		/* skip USB */
+		if (!sih->bytes_ixr)
+			continue;
+
+		/* Clear pending interrupt status.  Either the read was
+		 * enough, or we need to write those bits.  Repeat, in
+		 * case an IRQ is pending (PENDDIS=0) ... that's not
+		 * uncommon with PWR_INT.PWRON.
+		 */
+		for (j = 0; j < 2; j++) {
+			status = twl4030_i2c_read(sih->module, rxbuf,
+				sih->mask[line].isr_offset, sih->bytes_ixr);
+			if (status < 0)
+				pr_err("twl4030: err %d initializing %s %s\n",
+					status, sih->name, "ISR");
+
+			if (!sih->set_cor)
+				status = twl4030_i2c_write(sih->module, buf,
+					sih->mask[line].isr_offset,
+					sih->bytes_ixr);
+			/* else COR=1 means read sufficed.
+			 * (for most SIH modules...)
+			 */
+		}
+	}
+
+	return 0;
+}
+
+static inline void activate_irq(int irq)
+{
+#ifdef CONFIG_ARM
+	/* ARM requires an extra step to clear IRQ_NOREQUEST, which it
+	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
+	 */
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	/* same effect on other architectures */
+	set_irq_noprobe(irq);
+#endif
+}
+
+/*----------------------------------------------------------------------*/
+
+static DEFINE_SPINLOCK(sih_agent_lock);
+
+static struct workqueue_struct *wq;
+
+struct sih_agent {
+	int			irq_base;
+	const struct sih	*sih;
+
+	u32			imr;
+	bool			imr_change_pending;
+	struct work_struct	mask_work;
+
+	u32			edge_change;
+	struct work_struct	edge_work;
+};
+
+static void twl4030_sih_do_mask(struct work_struct *work)
+{
+	struct sih_agent	*agent;
+	const struct sih	*sih;
+	union {
+		u8	bytes[4];
+		u32	word;
+	}			imr;
+	int			status;
+
+	agent = container_of(work, struct sih_agent, mask_work);
+
+	/* see what work we have */
+	spin_lock_irq(&sih_agent_lock);
+	if (agent->imr_change_pending) {
+		sih = agent->sih;
+		/* byte[0] gets overwritten as we write ... */
+		imr.word = cpu_to_le32(agent->imr << 8);
+		agent->imr_change_pending = false;
+	} else
+		sih = NULL;
+	spin_unlock_irq(&sih_agent_lock);
+	if (!sih)
+		return;
+
+	/* write the whole mask ... simpler than subsetting it */
+	status = twl4030_i2c_write(sih->module, imr.bytes,
+			sih->mask[irq_line].imr_offset, sih->bytes_ixr);
+	if (status)
+		pr_err("twl4030: %s, %s --> %d\n", __func__,
+				"write", status);
+}
+
+static void twl4030_sih_do_edge(struct work_struct *work)
+{
+	struct sih_agent	*agent;
+	const struct sih	*sih;
+	u8			bytes[6];
+	u32			edge_change;
+	int			status;
+
+	agent = container_of(work, struct sih_agent, edge_work);
+
+	/* see what work we have */
+	spin_lock_irq(&sih_agent_lock);
+	edge_change = agent->edge_change;
+	agent->edge_change = 0;;
+	sih = edge_change ? agent->sih : NULL;
+	spin_unlock_irq(&sih_agent_lock);
+	if (!sih)
+		return;
+
+	/* Read, reserving first byte for write scratch.  Yes, this
+	 * could be cached for some speedup ... but be careful about
+	 * any processor on the other IRQ line, EDR registers are
+	 * shared.
+	 */
+	status = twl4030_i2c_read(sih->module, bytes + 1,
+			sih->edr_offset, sih->bytes_edr);
+	if (status) {
+		pr_err("twl4030: %s, %s --> %d\n", __func__,
+				"read", status);
+		return;
+	}
+
+	/* Modify only the bits we know must change */
+	while (edge_change) {
+		int		i = fls(edge_change) - 1;
+		struct irq_desc	*d = irq_desc + i + agent->irq_base;
+		int		byte = 1 + (i >> 2);
+		int		off = (i & 0x3) * 2;
+
+		bytes[byte] &= ~(0x03 << off);
+
+		spin_lock_irq(&d->lock);
+		if (d->status & IRQ_TYPE_EDGE_RISING)
+			bytes[byte] |= BIT(off + 1);
+		if (d->status & IRQ_TYPE_EDGE_FALLING)
+			bytes[byte] |= BIT(off + 0);
+		spin_unlock_irq(&d->lock);
+
+		edge_change &= ~BIT(i);
+	}
+
+	/* Write */
+	status = twl4030_i2c_write(sih->module, bytes,
+			sih->edr_offset, sih->bytes_edr);
+	if (status)
+		pr_err("twl4030: %s, %s --> %d\n", __func__,
+				"write", status);
+}
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * All irq_chip methods get issued from code holding irq_desc[irq].lock,
+ * which can't perform the underlying I2C operations (because they sleep).
+ * So we must hand them off to a thread (workqueue) and cope with asynch
+ * completion, potentially including some re-ordering, of these requests.
+ */
+
+static void twl4030_sih_mask(unsigned irq)
+{
+	struct sih_agent *sih = get_irq_chip_data(irq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sih_agent_lock, flags);
+	sih->imr |= BIT(irq - sih->irq_base);
+	sih->imr_change_pending = true;
+	queue_work(wq, &sih->mask_work);
+	spin_unlock_irqrestore(&sih_agent_lock, flags);
+}
+
+static void twl4030_sih_unmask(unsigned irq)
+{
+	struct sih_agent *sih = get_irq_chip_data(irq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sih_agent_lock, flags);
+	sih->imr &= ~BIT(irq - sih->irq_base);
+	sih->imr_change_pending = true;
+	queue_work(wq, &sih->mask_work);
+	spin_unlock_irqrestore(&sih_agent_lock, flags);
+}
+
+static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+{
+	struct sih_agent *sih = get_irq_chip_data(irq);
+	struct irq_desc *desc = irq_desc + irq;
+	unsigned long flags;
+
+	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
+		return -EINVAL;
+
+	spin_lock_irqsave(&sih_agent_lock, flags);
+	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
+		desc->status &= ~IRQ_TYPE_SENSE_MASK;
+		desc->status |= trigger;
+		sih->edge_change |= BIT(irq - sih->irq_base);
+		queue_work(wq, &sih->edge_work);
+	}
+	spin_unlock_irqrestore(&sih_agent_lock, flags);
+	return 0;
+}
+
+static struct irq_chip twl4030_sih_irq_chip = {
+	.name		= "twl4030",
+	.mask		= twl4030_sih_mask,
+	.unmask		= twl4030_sih_unmask,
+	.set_type	= twl4030_sih_set_type,
+};
+
+/*----------------------------------------------------------------------*/
+
+static inline int sih_read_isr(const struct sih *sih)
+{
+	int status;
+	union {
+		u8 bytes[4];
+		u32 word;
+	} isr;
+
+	/* FIXME need retry-on-error ... */
+
+	isr.word = 0;
+	status = twl4030_i2c_read(sih->module, isr.bytes,
+			sih->mask[irq_line].isr_offset, sih->bytes_ixr);
+
+	return (status < 0) ? status : le32_to_cpu(isr.word);
+}
+
+/*
+ * Generic handler for SIH interrupts ... we "know" this is called
+ * in task context, with IRQs enabled.
+ */
+static void handle_twl4030_sih(unsigned irq, struct irq_desc *desc)
+{
+	struct sih_agent *agent = get_irq_data(irq);
+	const struct sih *sih = agent->sih;
+	int isr;
+
+	/* reading ISR acks the IRQs, using clear-on-read mode */
+	local_irq_enable();
+	isr = sih_read_isr(sih);
+	local_irq_disable();
+
+	if (isr < 0) {
+		pr_err("twl4030: %s SIH, read ISR error %d\n",
+			sih->name, isr);
+		/* REVISIT:  recover; eventually mask it all, etc */
+		return;
+	}
+
+	while (isr) {
+		irq = fls(isr);
+		irq--;
+		isr &= ~BIT(irq);
+
+		if (irq < sih->bits)
+			generic_handle_irq(agent->irq_base + irq);
+		else
+			pr_err("twl4030: %s SIH, invalid ISR bit %d\n",
+				sih->name, irq);
+	}
+}
+
+static unsigned twl4030_irq_next;
+
+/* returns the first IRQ used by this SIH bank,
+ * or negative errno
+ */
+int twl4030_sih_setup(int module)
+{
+	int			sih_mod;
+	const struct sih	*sih = NULL;
+	struct sih_agent	*agent;
+	int			i, irq;
+	int			status = -EINVAL;
+	unsigned		irq_base = twl4030_irq_next;
+
+	/* only support modules with standard clear-on-read for now */
+	for (sih_mod = 0, sih = sih_modules;
+			sih_mod < ARRAY_SIZE(sih_modules);
+			sih_mod++, sih++) {
+		if (sih->module == module && sih->set_cor) {
+			if (!WARN((irq_base + sih->bits) > NR_IRQS,
+					"irq %d for %s too big\n",
+					irq_base + sih->bits,
+					sih->name))
+				status = 0;
+			break;
+		}
+	}
+	if (status < 0)
+		return status;
+
+	agent = kzalloc(sizeof *agent, GFP_KERNEL);
+	if (!agent)
+		return -ENOMEM;
+
+	status = 0;
+
+	agent->irq_base = irq_base;
+	agent->sih = sih;
+	agent->imr = ~0;
+	INIT_WORK(&agent->mask_work, twl4030_sih_do_mask);
+	INIT_WORK(&agent->edge_work, twl4030_sih_do_edge);
+
+	for (i = 0; i < sih->bits; i++) {
+		irq = irq_base + i;
+
+		set_irq_chip_and_handler(irq, &twl4030_sih_irq_chip,
+				handle_edge_irq);
+		set_irq_chip_data(irq, agent);
+		activate_irq(irq);
+	}
+
+	status = irq_base;
+	twl4030_irq_next += i;
+
+	/* replace generic PIH handler (handle_simple_irq) */
+	irq = sih_mod + twl4030_irq_base;
+	set_irq_data(irq, agent);
+	set_irq_chained_handler(irq, handle_twl4030_sih);
+
+	pr_info("twl4030: %s (irq %d) chaining IRQs %d..%d\n", sih->name,
+			irq, irq_base, twl4030_irq_next - 1);
+
+	return status;
+}
+
+/* FIXME need a call to reverse twl4030_sih_setup() ... */
+
+
+/*----------------------------------------------------------------------*/
+
+/* FIXME pass in which interrupt line we'll use ... */
+#define twl_irq_line	0
+
+int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
+{
+	static struct irq_chip	twl4030_irq_chip;
+
+	int			status;
+	int			i;
+	struct task_struct	*task;
+
+	/*
+	 * Mask and clear all TWL4030 interrupts since initially we do
+	 * not have any TWL4030 module interrupt handlers present
+	 */
+	status = twl4030_init_sih_modules(twl_irq_line);
+	if (status < 0)
+		return status;
+
+	wq = create_singlethread_workqueue("twl4030-irqchip");
+	if (!wq) {
+		pr_err("twl4030: workqueue FAIL\n");
+		return -ESRCH;
+	}
+
+	twl4030_irq_base = irq_base;
+
+	/* install an irq handler for each of the SIH modules;
+	 * clone dummy irq_chip since PIH can't *do* anything
+	 */
+	twl4030_irq_chip = dummy_irq_chip;
+	twl4030_irq_chip.name = "twl4030";
+
+	twl4030_sih_irq_chip.ack = dummy_irq_chip.ack;
+
+	for (i = irq_base; i < irq_end; i++) {
+		set_irq_chip_and_handler(i, &twl4030_irq_chip,
+				handle_simple_irq);
+		activate_irq(i);
+	}
+	twl4030_irq_next = i;
+	pr_info("twl4030: %s (irq %d) chaining IRQs %d..%d\n", "PIH",
+			irq_num, irq_base, twl4030_irq_next - 1);
+
+	/* ... and the PWR_INT module ... */
+	status = twl4030_sih_setup(TWL4030_MODULE_INT);
+	if (status < 0) {
+		pr_err("twl4030: sih_setup PWR INT --> %d\n", status);
+		goto fail;
+	}
+
+	/* install an irq handler to demultiplex the TWL4030 interrupt */
+	task = start_twl4030_irq_thread(irq_num);
+	if (!task) {
+		pr_err("twl4030: irq thread FAIL\n");
+		status = -ESRCH;
+		goto fail;
+	}
+
+	set_irq_data(irq_num, task);
+	set_irq_chained_handler(irq_num, handle_twl4030_pih);
+
+	return status;
+
+fail:
+	for (i = irq_base; i < irq_end; i++)
+		set_irq_chip_and_handler(i, NULL, NULL);
+	destroy_workqueue(wq);
+	wq = NULL;
+	return status;
+}
+
+int twl_exit_irq(void)
+{
+	/* FIXME undo twl_init_irq() */
+	if (twl4030_irq_base) {
+		pr_err("twl4030: can't yet clean up IRQs?\n");
+		return -ENOSYS;
+	}
+	return 0;
+}
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -228,6 +228,12 @@ struct twl4030_gpio_platform_data {
 	int		gpio_base;
 	unsigned	irq_base, irq_end;
 
+	/* package the two LED signals as output-only GPIOs? */
+	bool		use_leds;
+
+	/* gpio-n should control VMMC(n+1) if BIT(n) in mmc_cd is set */
+	u8		mmc_cd;
+
 	/* For gpio-N, bit (1 << N) in "pullups" is set if that pullup
 	 * should be enabled.  Else, if that bit is set in "pulldowns",
 	 * that pulldown is enabled.  Don't waste power by letting any
@@ -277,6 +283,8 @@ struct twl4030_platform_data {
 
 /*----------------------------------------------------------------------*/
 
+int twl4030_sih_setup(int module);
+
 /*
  * FIXME completely stop using TWL4030_IRQ_BASE ... instead, pass the
  * IRQ data to subsidiary devices using platform device resources.
@@ -291,16 +299,16 @@ struct twl4030_platform_data {
 #define TWL4030_MODIRQ_BCI		(TWL4030_IRQ_BASE + 2)
 #define TWL4030_MODIRQ_MADC		(TWL4030_IRQ_BASE + 3)
 /* #define TWL4030_MODIRQ_USB		(TWL4030_IRQ_BASE + 4) */
-#define TWL4030_MODIRQ_PWR		(TWL4030_IRQ_BASE + 5)
+/* #define TWL4030_MODIRQ_PWR		(TWL4030_IRQ_BASE + 5) */
 
 #define TWL4030_PWRIRQ_PWRBTN		(TWL4030_PWR_IRQ_BASE + 0)
-#define TWL4030_PWRIRQ_CHG_PRES		(TWL4030_PWR_IRQ_BASE + 1)
-#define TWL4030_PWRIRQ_USB_PRES		(TWL4030_PWR_IRQ_BASE + 2)
-#define TWL4030_PWRIRQ_RTC		(TWL4030_PWR_IRQ_BASE + 3)
-#define TWL4030_PWRIRQ_HOT_DIE		(TWL4030_PWR_IRQ_BASE + 4)
-#define TWL4030_PWRIRQ_PWROK_TIMEOUT	(TWL4030_PWR_IRQ_BASE + 5)
-#define TWL4030_PWRIRQ_MBCHG		(TWL4030_PWR_IRQ_BASE + 6)
-#define TWL4030_PWRIRQ_SC_DETECT	(TWL4030_PWR_IRQ_BASE + 7)
+/* #define TWL4030_PWRIRQ_CHG_PRES		(TWL4030_PWR_IRQ_BASE + 1) */
+/* #define TWL4030_PWRIRQ_USB_PRES		(TWL4030_PWR_IRQ_BASE + 2) */
+/* #define TWL4030_PWRIRQ_RTC		(TWL4030_PWR_IRQ_BASE + 3) */
+/* #define TWL4030_PWRIRQ_HOT_DIE		(TWL4030_PWR_IRQ_BASE + 4) */
+/* #define TWL4030_PWRIRQ_PWROK_TIMEOUT	(TWL4030_PWR_IRQ_BASE + 5) */
+/* #define TWL4030_PWRIRQ_MBCHG		(TWL4030_PWR_IRQ_BASE + 6) */
+/* #define TWL4030_PWRIRQ_SC_DETECT	(TWL4030_PWR_IRQ_BASE + 7) */
 
 /* Rest are unsued currently*/
 
@@ -317,17 +325,13 @@ struct twl4030_platform_data {
 /* TWL4030 GPIO interrupt definitions */
 
 #define TWL4030_GPIO_IRQ_NO(n)		(TWL4030_GPIO_IRQ_BASE + (n))
-#define TWL4030_GPIO_IS_ENABLE		1
 
 /*
  * Exported TWL4030 GPIO APIs
  *
  * WARNING -- use standard GPIO and IRQ calls instead; these will vanish.
  */
-int twl4030_get_gpio_datain(int gpio);
-int twl4030_request_gpio(int gpio);
 int twl4030_set_gpio_debounce(int gpio, int enable);
-int twl4030_free_gpio(int gpio);
 
 #if defined(CONFIG_TWL4030_BCI_BATTERY) || \
 	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
