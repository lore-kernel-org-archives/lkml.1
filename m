Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbYCZRqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbYCZRqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbYCZRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:46:30 -0400
Received: from mail0.scram.de ([78.47.204.202]:47939 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbYCZRq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:46:29 -0400
X-Spam-Score: -4.07
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <47EA8C1C.4090604@scram.de>
Date: Wed, 26 Mar 2008 18:47:08 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] CPM1: implement GPIO LIB API
References: <47E92EC8.7010700@scram.de> <47E93350.6090806@freescale.com>
In-Reply-To: <47E93350.6090806@freescale.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

>> diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
>> index 7fd224c..e12cbf0 100644
>> --- a/arch/powerpc/platforms/8xx/Kconfig
>> +++ b/arch/powerpc/platforms/8xx/Kconfig
>> @@ -4,6 +4,8 @@ config FADS
>>  config CPM1
>>  	bool
>>  	select CPM
>> +	select GENERIC_GPIO
>> +	select GPIO_LIB
> 
> Shouldn't this depend on the user enabling GPIO support?  Some 8xx 
> boards are very memory-constrained, so we don't want to be making the 
> kernel even bigger than it already is unless it's actually needed.

Are you more comfortable with this?

Implement GPIO LIB API on CPM1 Freescale SoC.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/platforms/8xx/Kconfig |   10 ++
 arch/powerpc/sysdev/cpm1.c         |  246 +++++++++++++++++++++++++++++++++++-
 2 files changed, 255 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index 7fd224c..9d17425 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -109,6 +109,16 @@ config 8xx_COPYBACK
 
 	  If in doubt, say Y here.
 
+config 8xx_GPIO
+	bool "GPIO API Support"
+	select GENERIC_GPIO
+	select HAVE_GPIO_LIB
+	help
+	  Saying Y here will cause the ports on an MPC8xx processor to be used
+	  with the GPIO API.  If you say N here, the kernel needs less memory.
+
+	  If in doubt, say Y here.
+
 config 8xx_CPU6
 	bool "CPU6 Silicon Errata (860 Pre Rev. C)"
 	help
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index df8bd2b..6c97f3f 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/spinlock.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/8xx_immap.h>
@@ -42,6 +43,11 @@
 
 #include <asm/fs_pd.h>
 
+#ifdef CONFIG_8xx_GPIO
+#include <linux/of_gpio.h>
+#include <asm/gpio.h>
+#endif
+
 #define CPM_MAP_SIZE    (0x4000)
 
 #ifndef CONFIG_PPC_CPM_NEW_BINDING
@@ -403,7 +409,7 @@ struct cpm_ioport16 {
 };
 
 struct cpm_ioport32 {
-	__be32 dir, par, sor;
+	__be32 dir, par, sor, dat;
 };
 
 static void cpm1_set_pin32(int port, int pin, int flags)
@@ -610,3 +616,241 @@ int cpm1_clk_setup(enum cpm_clk_target target, int clock, int mode)
 
 	return 0;
 }
+
+/*
+ * GPIO LIB API implementation
+ */
+#ifdef CONFIG_8xx_GPIO
+
+struct cpm1_gpio16_chip {
+	struct of_mm_gpio_chip mm_gc;
+	spinlock_t lock;
+
+	/* shadowed data register to clear/set bits safely */
+	u16 cpdata;
+};
+
+static inline struct cpm1_gpio16_chip *
+to_cpm1_gpio16_chip(struct of_mm_gpio_chip *mm_gc)
+{
+	return container_of(mm_gc, struct cpm1_gpio16_chip, mm_gc);
+}
+
+static void cpm1_gpio16_save_regs(struct of_mm_gpio_chip *mm_gc)
+{
+	struct cpm1_gpio16_chip *cpm1_gc = to_cpm1_gpio16_chip(mm_gc);
+	struct cpm_ioport16 __iomem *iop = mm_gc->regs;
+
+	cpm1_gc->cpdata = in_be16(&iop->dat);
+}
+
+static int cpm1_gpio16_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm_ioport16 __iomem *iop = mm_gc->regs;
+	u16 pin_mask;
+
+	pin_mask = 1 << (15 - gpio);
+
+	return !!(in_be16(&iop->dat) & pin_mask);
+}
+
+static void cpm1_gpio16_set(struct gpio_chip *gc, unsigned int gpio, int value)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm1_gpio16_chip *cpm1_gc = to_cpm1_gpio16_chip(mm_gc);
+	struct cpm_ioport16 __iomem *iop = mm_gc->regs;
+	unsigned long flags;
+	u16 pin_mask = 1 << (15 - gpio);
+
+	spin_lock_irqsave(&cpm1_gc->lock, flags);
+
+	if (value)
+		cpm1_gc->cpdata |= pin_mask;
+	else
+		cpm1_gc->cpdata &= ~pin_mask;
+
+	out_be16(&iop->dat, cpm1_gc->cpdata);
+
+	spin_unlock_irqrestore(&cpm1_gc->lock, flags);
+}
+
+static int cpm1_gpio16_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm_ioport16 __iomem *iop = mm_gc->regs;
+	u16 pin_mask;
+
+	pin_mask = 1 << (15 - gpio);
+
+	setbits16(&iop->dir, pin_mask);
+
+	cpm1_gpio16_set(gc, gpio, val);
+
+	return 0;
+}
+
+static int cpm1_gpio16_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm_ioport16 __iomem *iop = mm_gc->regs;
+	u16 pin_mask;
+
+	pin_mask = 1 << (15 - gpio);
+
+	clrbits16(&iop->dir, pin_mask);
+
+	return 0;
+}
+
+int cpm1_gpiochip_add16(struct device_node *np)
+{
+	struct cpm1_gpio16_chip *cpm1_gc;
+	struct of_mm_gpio_chip *mm_gc;
+	struct of_gpio_chip *of_gc;
+	struct gpio_chip *gc;
+
+	cpm1_gc = kzalloc(sizeof(*cpm1_gc), GFP_KERNEL);
+	if (!cpm1_gc)
+		return -ENOMEM;
+
+	spin_lock_init(&cpm1_gc->lock);
+
+	mm_gc = &cpm1_gc->mm_gc;
+	of_gc = &mm_gc->of_gc;
+	gc = &of_gc->gc;
+
+	mm_gc->save_regs = cpm1_gpio16_save_regs;
+	of_gc->gpio_cells = 1;
+	gc->ngpio = 16;
+	gc->direction_input = cpm1_gpio16_dir_in;
+	gc->direction_output = cpm1_gpio16_dir_out;
+	gc->get = cpm1_gpio16_get;
+	gc->set = cpm1_gpio16_set;
+
+	return of_mm_gpiochip_add(np, mm_gc);
+}
+
+struct cpm1_gpio32_chip {
+	struct of_mm_gpio_chip mm_gc;
+	spinlock_t lock;
+
+	/* shadowed data register to clear/set bits safely */
+	u32 cpdata;
+};
+
+static inline struct cpm1_gpio32_chip *
+to_cpm1_gpio32_chip(struct of_mm_gpio_chip *mm_gc)
+{
+	return container_of(mm_gc, struct cpm1_gpio32_chip, mm_gc);
+}
+
+static void cpm1_gpio32_save_regs(struct of_mm_gpio_chip *mm_gc)
+{
+	struct cpm1_gpio32_chip *cpm1_gc = to_cpm1_gpio32_chip(mm_gc);
+	struct cpm_ioport32 __iomem *iop = mm_gc->regs;
+
+	cpm1_gc->cpdata = in_be32(&iop->dat);
+}
+
+static int cpm1_gpio32_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm_ioport32 __iomem *iop = mm_gc->regs;
+	u32 pin_mask;
+
+	pin_mask = 1 << (31 - gpio);
+
+	return !!(in_be32(&iop->dat) & pin_mask);
+}
+
+static void cpm1_gpio32_set(struct gpio_chip *gc, unsigned int gpio, int value)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm1_gpio32_chip *cpm1_gc = to_cpm1_gpio32_chip(mm_gc);
+	struct cpm_ioport32 __iomem *iop = mm_gc->regs;
+	unsigned long flags;
+	u32 pin_mask = 1 << (31 - gpio);
+
+	spin_lock_irqsave(&cpm1_gc->lock, flags);
+
+	if (value)
+		cpm1_gc->cpdata |= pin_mask;
+	else
+		cpm1_gc->cpdata &= ~pin_mask;
+
+	out_be32(&iop->dat, cpm1_gc->cpdata);
+
+	spin_unlock_irqrestore(&cpm1_gc->lock, flags);
+}
+
+static int cpm1_gpio32_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm_ioport32 __iomem *iop = mm_gc->regs;
+	u32 pin_mask;
+
+	pin_mask = 1 << (31 - gpio);
+
+	setbits32(&iop->dir, pin_mask);
+
+	cpm1_gpio32_set(gc, gpio, val);
+
+	return 0;
+}
+
+static int cpm1_gpio32_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct cpm_ioport32 __iomem *iop = mm_gc->regs;
+	u32 pin_mask;
+
+	pin_mask = 1 << (31 - gpio);
+
+	clrbits32(&iop->dir, pin_mask);
+
+	return 0;
+}
+
+int cpm1_gpiochip_add32(struct device_node *np)
+{
+	struct cpm1_gpio32_chip *cpm1_gc;
+	struct of_mm_gpio_chip *mm_gc;
+	struct of_gpio_chip *of_gc;
+	struct gpio_chip *gc;
+
+	cpm1_gc = kzalloc(sizeof(*cpm1_gc), GFP_KERNEL);
+	if (!cpm1_gc)
+		return -ENOMEM;
+
+	spin_lock_init(&cpm1_gc->lock);
+
+	mm_gc = &cpm1_gc->mm_gc;
+	of_gc = &mm_gc->of_gc;
+	gc = &of_gc->gc;
+
+	mm_gc->save_regs = cpm1_gpio32_save_regs;
+	of_gc->gpio_cells = 1;
+	gc->ngpio = 32;
+	gc->direction_input = cpm1_gpio32_dir_in;
+	gc->direction_output = cpm1_gpio32_dir_out;
+	gc->get = cpm1_gpio32_get;
+	gc->set = cpm1_gpio32_set;
+
+	return of_mm_gpiochip_add(np, mm_gc);
+}
+
+static int cpm_init_par_io(void)
+{
+	struct device_node *np;
+
+	for_each_compatible_node(np, NULL, "fsl,cpm1-pario-bank16")
+		cpm1_gpiochip_add16(np);
+
+	for_each_compatible_node(np, NULL, "fsl,cpm1-pario-bank32")
+		cpm1_gpiochip_add32(np);
+	return 0;
+}
+arch_initcall(cpm_init_par_io);
+
+#endif /* CONFIG_8xx_GPIO */
-- 
1.5.4.4


