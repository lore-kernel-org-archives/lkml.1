Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0BIUri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:47:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:61680 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0BIUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:46:36 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM PATCH 3/7] Expunge old Atmel PWMC driver, replacing it with one that conforms to the PWM API
Date: Tue,  9 Feb 2010 14:46:30 -0600
Message-Id: <6ba8043e7749806f88b685ecd5ad7c4e1062bc91.1265748264.git.bgat@billgatliff.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <7178097a5a8af15f61656f11b6bef68b0da71498.1265748264.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
 <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
 <7178097a5a8af15f61656f11b6bef68b0da71498.1265748264.git.bgat@billgatliff.com>
In-Reply-To: <cover.1265748263.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 drivers/misc/Makefile    |    1 -
 drivers/misc/atmel_pwm.c |  409 --------------------------------
 drivers/pwm/atmel-pwm.c  |  590 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 590 insertions(+), 410 deletions(-)
 delete mode 100644 drivers/misc/atmel_pwm.c
 create mode 100644 drivers/pwm/atmel-pwm.c

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 049ff24..b94666c 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -5,7 +5,6 @@
 obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
-obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
deleted file mode 100644
index 6aa5294..0000000
--- a/drivers/misc/atmel_pwm.c
+++ /dev/null
@@ -1,409 +0,0 @@
-#include <linux/module.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/atmel_pwm.h>
-
-
-/*
- * This is a simple driver for the PWM controller found in various newer
- * Atmel SOCs, including the AVR32 series and the AT91sam9263.
- *
- * Chips with current Linux ports have only 4 PWM channels, out of max 32.
- * AT32UC3A and AT32UC3B chips have 7 channels (but currently no Linux).
- * Docs are inconsistent about the width of the channel counter registers;
- * it's at least 16 bits, but several places say 20 bits.
- */
-#define	PWM_NCHAN	4		/* max 32 */
-
-struct pwm {
-	spinlock_t		lock;
-	struct platform_device	*pdev;
-	u32			mask;
-	int			irq;
-	void __iomem		*base;
-	struct clk		*clk;
-	struct pwm_channel	*channel[PWM_NCHAN];
-	void			(*handler[PWM_NCHAN])(struct pwm_channel *);
-};
-
-
-/* global PWM controller registers */
-#define PWM_MR		0x00
-#define PWM_ENA		0x04
-#define PWM_DIS		0x08
-#define PWM_SR		0x0c
-#define PWM_IER		0x10
-#define PWM_IDR		0x14
-#define PWM_IMR		0x18
-#define PWM_ISR		0x1c
-
-static inline void pwm_writel(const struct pwm *p, unsigned offset, u32 val)
-{
-	__raw_writel(val, p->base + offset);
-}
-
-static inline u32 pwm_readl(const struct pwm *p, unsigned offset)
-{
-	return __raw_readl(p->base + offset);
-}
-
-static inline void __iomem *pwmc_regs(const struct pwm *p, int index)
-{
-	return p->base + 0x200 + index * 0x20;
-}
-
-static struct pwm *pwm;
-
-static void pwm_dumpregs(struct pwm_channel *ch, char *tag)
-{
-	struct device	*dev = &pwm->pdev->dev;
-
-	dev_dbg(dev, "%s: mr %08x, sr %08x, imr %08x\n",
-		tag,
-		pwm_readl(pwm, PWM_MR),
-		pwm_readl(pwm, PWM_SR),
-		pwm_readl(pwm, PWM_IMR));
-	dev_dbg(dev,
-		"pwm ch%d - mr %08x, dty %u, prd %u, cnt %u\n",
-		ch->index,
-		pwm_channel_readl(ch, PWM_CMR),
-		pwm_channel_readl(ch, PWM_CDTY),
-		pwm_channel_readl(ch, PWM_CPRD),
-		pwm_channel_readl(ch, PWM_CCNT));
-}
-
-
-/**
- * pwm_channel_alloc - allocate an unused PWM channel
- * @index: identifies the channel
- * @ch: structure to be initialized
- *
- * Drivers allocate PWM channels according to the board's wiring, and
- * matching board-specific setup code.  Returns zero or negative errno.
- */
-int pwm_channel_alloc(int index, struct pwm_channel *ch)
-{
-	unsigned long	flags;
-	int		status = 0;
-
-	/* insist on PWM init, with this signal pinned out */
-	if (!pwm || !(pwm->mask & 1 << index))
-		return -ENODEV;
-
-	if (index < 0 || index >= PWM_NCHAN || !ch)
-		return -EINVAL;
-	memset(ch, 0, sizeof *ch);
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	if (pwm->channel[index])
-		status = -EBUSY;
-	else {
-		clk_enable(pwm->clk);
-
-		ch->regs = pwmc_regs(pwm, index);
-		ch->index = index;
-
-		/* REVISIT: ap7000 seems to go 2x as fast as we expect!! */
-		ch->mck = clk_get_rate(pwm->clk);
-
-		pwm->channel[index] = ch;
-		pwm->handler[index] = NULL;
-
-		/* channel and irq are always disabled when we return */
-		pwm_writel(pwm, PWM_DIS, 1 << index);
-		pwm_writel(pwm, PWM_IDR, 1 << index);
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-	return status;
-}
-EXPORT_SYMBOL(pwm_channel_alloc);
-
-static int pwmcheck(struct pwm_channel *ch)
-{
-	int		index;
-
-	if (!pwm)
-		return -ENODEV;
-	if (!ch)
-		return -EINVAL;
-	index = ch->index;
-	if (index < 0 || index >= PWM_NCHAN || pwm->channel[index] != ch)
-		return -EINVAL;
-
-	return index;
-}
-
-/**
- * pwm_channel_free - release a previously allocated channel
- * @ch: the channel being released
- *
- * The channel is completely shut down (counter and IRQ disabled),
- * and made available for re-use.  Returns zero, or negative errno.
- */
-int pwm_channel_free(struct pwm_channel *ch)
-{
-	unsigned long	flags;
-	int		t;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	t = pwmcheck(ch);
-	if (t >= 0) {
-		pwm->channel[t] = NULL;
-		pwm->handler[t] = NULL;
-
-		/* channel and irq are always disabled when we return */
-		pwm_writel(pwm, PWM_DIS, 1 << t);
-		pwm_writel(pwm, PWM_IDR, 1 << t);
-
-		clk_disable(pwm->clk);
-		t = 0;
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-	return t;
-}
-EXPORT_SYMBOL(pwm_channel_free);
-
-int __pwm_channel_onoff(struct pwm_channel *ch, int enabled)
-{
-	unsigned long	flags;
-	int		t;
-
-	/* OMITTED FUNCTIONALITY:  starting several channels in synch */
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	t = pwmcheck(ch);
-	if (t >= 0) {
-		pwm_writel(pwm, enabled ? PWM_ENA : PWM_DIS, 1 << t);
-		t = 0;
-		pwm_dumpregs(ch, enabled ? "enable" : "disable");
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-
-	return t;
-}
-EXPORT_SYMBOL(__pwm_channel_onoff);
-
-/**
- * pwm_clk_alloc - allocate and configure CLKA or CLKB
- * @prescale: from 0..10, the power of two used to divide MCK
- * @div: from 1..255, the linear divisor to use
- *
- * Returns PWM_CPR_CLKA, PWM_CPR_CLKB, or negative errno.  The allocated
- * clock will run with a period of (2^prescale * div) / MCK, or twice as
- * long if center aligned PWM output is used.  The clock must later be
- * deconfigured using pwm_clk_free().
- */
-int pwm_clk_alloc(unsigned prescale, unsigned div)
-{
-	unsigned long	flags;
-	u32		mr;
-	u32		val = (prescale << 8) | div;
-	int		ret = -EBUSY;
-
-	if (prescale >= 10 || div == 0 || div > 255)
-		return -EINVAL;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	mr = pwm_readl(pwm, PWM_MR);
-	if ((mr & 0xffff) == 0) {
-		mr |= val;
-		ret = PWM_CPR_CLKA;
-	} else if ((mr & (0xffff << 16)) == 0) {
-		mr |= val << 16;
-		ret = PWM_CPR_CLKB;
-	}
-	if (ret > 0)
-		pwm_writel(pwm, PWM_MR, mr);
-	spin_unlock_irqrestore(&pwm->lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(pwm_clk_alloc);
-
-/**
- * pwm_clk_free - deconfigure and release CLKA or CLKB
- *
- * Reverses the effect of pwm_clk_alloc().
- */
-void pwm_clk_free(unsigned clk)
-{
-	unsigned long	flags;
-	u32		mr;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	mr = pwm_readl(pwm, PWM_MR);
-	if (clk == PWM_CPR_CLKA)
-		pwm_writel(pwm, PWM_MR, mr & ~(0xffff << 0));
-	if (clk == PWM_CPR_CLKB)
-		pwm_writel(pwm, PWM_MR, mr & ~(0xffff << 16));
-	spin_unlock_irqrestore(&pwm->lock, flags);
-}
-EXPORT_SYMBOL(pwm_clk_free);
-
-/**
- * pwm_channel_handler - manage channel's IRQ handler
- * @ch: the channel
- * @handler: the handler to use, possibly NULL
- *
- * If the handler is non-null, the handler will be called after every
- * period of this PWM channel.  If the handler is null, this channel
- * won't generate an IRQ.
- */
-int pwm_channel_handler(struct pwm_channel *ch,
-		void (*handler)(struct pwm_channel *ch))
-{
-	unsigned long	flags;
-	int		t;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	t = pwmcheck(ch);
-	if (t >= 0) {
-		pwm->handler[t] = handler;
-		pwm_writel(pwm, handler ? PWM_IER : PWM_IDR, 1 << t);
-		t = 0;
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-
-	return t;
-}
-EXPORT_SYMBOL(pwm_channel_handler);
-
-static irqreturn_t pwm_irq(int id, void *_pwm)
-{
-	struct pwm	*p = _pwm;
-	irqreturn_t	handled = IRQ_NONE;
-	u32		irqstat;
-	int		index;
-
-	spin_lock(&p->lock);
-
-	/* ack irqs, then handle them */
-	irqstat = pwm_readl(pwm, PWM_ISR);
-
-	while (irqstat) {
-		struct pwm_channel *ch;
-		void (*handler)(struct pwm_channel *ch);
-
-		index = ffs(irqstat) - 1;
-		irqstat &= ~(1 << index);
-		ch = pwm->channel[index];
-		handler = pwm->handler[index];
-		if (handler && ch) {
-			spin_unlock(&p->lock);
-			handler(ch);
-			spin_lock(&p->lock);
-			handled = IRQ_HANDLED;
-		}
-	}
-
-	spin_unlock(&p->lock);
-	return handled;
-}
-
-static int __init pwm_probe(struct platform_device *pdev)
-{
-	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int irq = platform_get_irq(pdev, 0);
-	u32 *mp = pdev->dev.platform_data;
-	struct pwm *p;
-	int status = -EIO;
-
-	if (pwm)
-		return -EBUSY;
-	if (!r || irq < 0 || !mp || !*mp)
-		return -ENODEV;
-	if (*mp & ~((1<<PWM_NCHAN)-1)) {
-		dev_warn(&pdev->dev, "mask 0x%x ... more than %d channels\n",
-			*mp, PWM_NCHAN);
-		return -EINVAL;
-	}
-
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	spin_lock_init(&p->lock);
-	p->pdev = pdev;
-	p->mask = *mp;
-	p->irq = irq;
-	p->base = ioremap(r->start, r->end - r->start + 1);
-	if (!p->base)
-		goto fail;
-	p->clk = clk_get(&pdev->dev, "pwm_clk");
-	if (IS_ERR(p->clk)) {
-		status = PTR_ERR(p->clk);
-		p->clk = NULL;
-		goto fail;
-	}
-
-	status = request_irq(irq, pwm_irq, 0, pdev->name, p);
-	if (status < 0)
-		goto fail;
-
-	pwm = p;
-	platform_set_drvdata(pdev, p);
-
-	return 0;
-
-fail:
-	if (p->clk)
-		clk_put(p->clk);
-	if (p->base)
-		iounmap(p->base);
-
-	kfree(p);
-	return status;
-}
-
-static int __exit pwm_remove(struct platform_device *pdev)
-{
-	struct pwm *p = platform_get_drvdata(pdev);
-
-	if (p != pwm)
-		return -EINVAL;
-
-	clk_enable(pwm->clk);
-	pwm_writel(pwm, PWM_DIS, (1 << PWM_NCHAN) - 1);
-	pwm_writel(pwm, PWM_IDR, (1 << PWM_NCHAN) - 1);
-	clk_disable(pwm->clk);
-
-	pwm = NULL;
-
-	free_irq(p->irq, p);
-	clk_put(p->clk);
-	iounmap(p->base);
-	kfree(p);
-
-	return 0;
-}
-
-static struct platform_driver atmel_pwm_driver = {
-	.driver = {
-		.name = "atmel_pwm",
-		.owner = THIS_MODULE,
-	},
-	.remove = __exit_p(pwm_remove),
-
-	/* NOTE: PWM can keep running in AVR32 "idle" and "frozen" states;
-	 * and all AT91sam9263 states, albeit at reduced clock rate if
-	 * MCK becomes the slow clock (i.e. what Linux labels STR).
-	 */
-};
-
-static int __init pwm_init(void)
-{
-	return platform_driver_probe(&atmel_pwm_driver, pwm_probe);
-}
-module_init(pwm_init);
-
-static void __exit pwm_exit(void)
-{
-	platform_driver_unregister(&atmel_pwm_driver);
-}
-module_exit(pwm_exit);
-
-MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:atmel_pwm");
diff --git a/drivers/pwm/atmel-pwm.c b/drivers/pwm/atmel-pwm.c
new file mode 100644
index 0000000..4f0ef8c
--- /dev/null
+++ b/drivers/pwm/atmel-pwm.c
@@ -0,0 +1,590 @@
+/*
+ * drivers/pwm/atmel-pwm.c
+ *
+ * Copyright (C) 2010 Bill Gatliff <bgat@billgatliff.com>
+ * Copyright (C) 2007 David Brownell
+ *
+ * This program is free software; you may redistribute and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pwm/pwm.h>
+
+enum {
+	/* registers common to the PWMC peripheral */
+	PWMC_MR = 0,
+	PWMC_ENA = 4,
+	PWMC_DIS = 8,
+	PWMC_SR = 0xc,
+	PWMC_IER = 0x10,
+	PWMC_IDR = 0x14,
+	PWMC_IMR = 0x18,
+	PWMC_ISR = 0x1c,
+
+	/* registers per each PWMC channel */
+	PWMC_CMR = 0,
+	PWMC_CDTY = 4,
+	PWMC_CPRD = 8,
+	PWMC_CCNT = 0xc,
+	PWMC_CUPD = 0x10,
+
+	/* how to find each channel */
+	PWMC_CHAN_BASE = 0x200,
+	PWMC_CHAN_STRIDE = 0x20,
+
+	/* CMR bits of interest */
+	PWMC_CMR_CPD = 10,
+	PWMC_CMR_CPOL = 9,
+	PWMC_CMR_CALG = 8,
+	PWMC_CMR_CPRE_MASK = 0xf,
+};
+
+struct atmel_pwm {
+	struct pwm_device pwm;
+	spinlock_t lock;
+	void __iomem *iobase;
+	struct clk *clk;
+	u32 *sync_mask;
+	int irq;
+	u32 ccnt_mask;
+};
+
+static inline struct atmel_pwm *to_atmel_pwm(const struct pwm_channel *p)
+{
+	return container_of(p->pwm, struct atmel_pwm, pwm);
+}
+
+static inline void
+pwmc_writel(const struct atmel_pwm *p,
+	    unsigned offset, u32 val)
+{
+	__raw_writel(val, p->iobase + offset);
+}
+
+static inline u32
+pwmc_readl(const struct atmel_pwm *p,
+	   unsigned offset)
+{
+	return __raw_readl(p->iobase + offset);
+}
+
+static inline void
+pwmc_chan_writel(const struct pwm_channel *p,
+		 u32 offset, u32 val)
+{
+	const struct atmel_pwm *ap = to_atmel_pwm(p);
+
+	if (PWMC_CMR == offset)
+		val &= ((1 << PWMC_CMR_CPD)
+			| (1 << PWMC_CMR_CPOL)
+			| (1 << PWMC_CMR_CALG)
+			| (PWMC_CMR_CPRE_MASK));
+	else
+		val &= ap->ccnt_mask;
+
+	pwmc_writel(ap, offset + PWMC_CHAN_BASE
+		    + (p->chan * PWMC_CHAN_STRIDE), val);
+}
+
+static inline u32
+pwmc_chan_readl(const struct pwm_channel *p,
+		u32 offset)
+{
+	const struct atmel_pwm *ap = to_atmel_pwm(p);
+
+	return pwmc_readl(ap, offset + PWMC_CHAN_BASE
+			  + (p->chan * PWMC_CHAN_STRIDE));
+}
+
+static inline int
+__atmel_pwm_is_on(struct pwm_channel *p)
+{
+	struct atmel_pwm *ap = to_atmel_pwm(p);
+	return (pwmc_readl(ap, PWMC_SR) & (1 << p->chan)) ? 1 : 0;
+}
+
+static inline void
+__atmel_pwm_unsynchronize(struct pwm_channel *p,
+			  struct pwm_channel *to_p)
+{
+	const struct atmel_pwm *ap = to_atmel_pwm(p);
+	int wchan;
+
+	if (to_p) {
+		ap->sync_mask[p->chan] &= ~(1 << to_p->chan);
+		ap->sync_mask[to_p->chan] &= ~(1 << p->chan);
+		goto done;
+	}
+
+	ap->sync_mask[p->chan] = 0;
+	for (wchan = 0; wchan < ap->pwm.nchan; wchan++)
+		ap->sync_mask[wchan] &= ~(1 << p->chan);
+done:
+	dev_dbg(p->pwm->dev, "sync_mask %x\n", ap->sync_mask[p->chan]);
+}
+
+static inline void
+__atmel_pwm_synchronize(struct pwm_channel *p,
+			struct pwm_channel *to_p)
+{
+	const struct atmel_pwm *ap = to_atmel_pwm(p);
+
+	if (!to_p)
+		return;
+
+	ap->sync_mask[p->chan] |= (1 << to_p->chan);
+	ap->sync_mask[to_p->chan] |= (1 << p->chan);
+
+	dev_dbg(p->pwm->dev, "sync_mask %x\n", ap->sync_mask[p->chan]);
+}
+
+static inline void
+__atmel_pwm_stop(struct pwm_channel *p)
+{
+	struct atmel_pwm *ap = to_atmel_pwm(p);
+	u32 chid = 1 << p->chan;
+
+	pwmc_writel(ap, PWMC_DIS, ap->sync_mask[p->chan] | chid);
+}
+
+static inline void
+__atmel_pwm_start(struct pwm_channel *p)
+{
+	struct atmel_pwm *ap = to_atmel_pwm(p);
+	u32 chid = 1 << p->chan;
+
+	pwmc_writel(ap, PWMC_ENA, ap->sync_mask[p->chan] | chid);
+}
+
+static int
+atmel_pwm_synchronize(struct pwm_channel *p,
+		      struct pwm_channel *to_p)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&p->lock, flags);
+	__atmel_pwm_synchronize(p, to_p);
+	spin_unlock_irqrestore(&p->lock, flags);
+	return 0;
+}
+
+static int
+atmel_pwm_unsynchronize(struct pwm_channel *p,
+			struct pwm_channel *from_p)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&p->lock, flags);
+	__atmel_pwm_unsynchronize(p, from_p);
+	spin_unlock_irqrestore(&p->lock, flags);
+	return 0;
+}
+
+static inline int
+__atmel_pwm_config_polarity(struct pwm_channel *p,
+			    struct pwm_channel_config *c)
+{
+	u32 cmr = pwmc_chan_readl(p, PWMC_CMR);
+
+	if (c->polarity)
+		cmr &= ~BIT(PWMC_CMR_CPOL);
+	else
+		cmr |= BIT(PWMC_CMR_CPOL);
+	pwmc_chan_writel(p, PWMC_CMR, cmr);
+
+	dev_dbg(p->pwm->dev, "polarity %d\n", c->polarity);
+	return 0;
+}
+
+static inline int
+__atmel_pwm_config_duty_ticks(struct pwm_channel *p,
+			      struct pwm_channel_config *c)
+{
+	u32 cmr, cprd, cpre, cdty;
+
+	cmr = pwmc_chan_readl(p, PWMC_CMR);
+	cprd = pwmc_chan_readl(p, PWMC_CPRD);
+
+	cpre = cmr & PWMC_CMR_CPRE_MASK;
+	cmr &= ~BIT(PWMC_CMR_CPD);
+
+	cdty = cprd - (c->duty_ticks >> cpre);
+
+	p->duty_ticks = c->duty_ticks;
+
+	if (__atmel_pwm_is_on(p)) {
+		pwmc_chan_writel(p, PWMC_CMR, cmr);
+		pwmc_chan_writel(p, PWMC_CUPD, cdty);
+	} else
+		pwmc_chan_writel(p, PWMC_CDTY, cdty);
+
+	dev_dbg(p->pwm->dev, "duty_ticks = %lu cprd = %x"
+		" cdty = %x cpre = %x\n", p->duty_ticks,
+		cprd, cdty, cpre);
+
+	return 0;
+}
+
+static inline int
+__atmel_pwm_config_period_ticks(struct pwm_channel *p,
+				struct pwm_channel_config *c)
+{
+	u32 cmr, cprd, cpre;
+
+	cpre = fls(c->period_ticks);
+	if (cpre < 16)
+		cpre = 0;
+	else {
+		cpre -= 15;
+		if (cpre > 10)
+			return -EINVAL;
+	}
+
+	cmr = pwmc_chan_readl(p, PWMC_CMR);
+	cmr &= ~PWMC_CMR_CPRE_MASK;
+	cmr |= cpre;
+
+	cprd = c->period_ticks >> cpre;
+
+	pwmc_chan_writel(p, PWMC_CMR, cmr);
+	pwmc_chan_writel(p, PWMC_CPRD, cprd);
+	p->period_ticks = c->period_ticks;
+
+	dev_dbg(p->pwm->dev, "period_ticks = %lu cprd = %x cpre = %x\n",
+		 p->period_ticks, cprd, cpre);
+
+	return 0;
+}
+
+static int
+atmel_pwm_config_nosleep(struct pwm_channel *p,
+			 struct pwm_channel_config *c)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	switch (c->config_mask) {
+
+	case PWM_CONFIG_DUTY_TICKS:
+		__atmel_pwm_config_duty_ticks(p, c);
+		break;
+
+	case PWM_CONFIG_STOP:
+		__atmel_pwm_stop(p);
+		break;
+
+	case PWM_CONFIG_START:
+		__atmel_pwm_start(p);
+		break;
+
+	case PWM_CONFIG_POLARITY:
+		__atmel_pwm_config_polarity(p, c);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	spin_unlock_irqrestore(&p->lock, flags);
+	return ret;
+}
+
+static int
+atmel_pwm_stop_sync(struct pwm_channel *p)
+{
+	struct atmel_pwm *ap = container_of(p->pwm, struct atmel_pwm, pwm);
+	int ret;
+	int was_on = __atmel_pwm_is_on(p);
+
+	if (was_on) {
+		do {
+			init_completion(&p->complete);
+			set_bit(FLAG_STOP, &p->flags);
+			pwmc_writel(ap, PWMC_IER, 1 << p->chan);
+
+			dev_dbg(p->pwm->dev, "waiting on stop_sync completion...\n");
+
+			ret = wait_for_completion_interruptible(&p->complete);
+
+			dev_dbg(p->pwm->dev, "stop_sync complete (%d)\n", ret);
+
+			if (ret)
+				return ret;
+		} while (p->flags & BIT(FLAG_STOP));
+	}
+
+	return was_on;
+}
+
+static int
+atmel_pwm_config(struct pwm_channel *p,
+		 struct pwm_channel_config *c)
+{
+	int was_on = 0;
+
+	if (p->pwm->config_nosleep) {
+		if (!p->pwm->config_nosleep(p, c))
+			return 0;
+	}
+
+	might_sleep();
+
+	dev_dbg(p->pwm->dev, "config_mask %x\n", c->config_mask);
+
+	was_on = atmel_pwm_stop_sync(p);
+	if (was_on < 0)
+		return was_on;
+
+	if (c->config_mask & PWM_CONFIG_PERIOD_TICKS) {
+		__atmel_pwm_config_period_ticks(p, c);
+		if (!(c->config_mask & PWM_CONFIG_DUTY_TICKS)) {
+			struct pwm_channel_config d = {
+				.config_mask = PWM_CONFIG_DUTY_TICKS,
+				.duty_ticks = p->duty_ticks,
+			};
+			__atmel_pwm_config_duty_ticks(p, &d);
+		}
+	}
+
+	if (c->config_mask & PWM_CONFIG_DUTY_TICKS)
+		__atmel_pwm_config_duty_ticks(p, c);
+
+	if (c->config_mask & PWM_CONFIG_POLARITY)
+		__atmel_pwm_config_polarity(p, c);
+
+	if ((c->config_mask & PWM_CONFIG_START)
+	    || (was_on && !(c->config_mask & PWM_CONFIG_STOP)))
+		__atmel_pwm_start(p);
+
+	return 0;
+}
+
+static void
+__atmel_pwm_set_callback(struct pwm_channel *p,
+			 pwm_callback_t callback)
+{
+	struct atmel_pwm *ap = container_of(p->pwm, struct atmel_pwm, pwm);
+
+	p->callback = callback;
+	pwmc_writel(ap, p->callback ? PWMC_IER : PWMC_IDR, 1 << p->chan);
+}
+
+static int
+atmel_pwm_set_callback(struct pwm_channel *p,
+		       pwm_callback_t callback)
+{
+	struct atmel_pwm *ap = to_atmel_pwm(p);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ap->lock, flags);
+	__atmel_pwm_set_callback(p, callback);
+	spin_unlock_irqrestore(&ap->lock, flags);
+
+	return 0;
+}
+
+static int
+atmel_pwm_request(struct pwm_channel *p)
+{
+	struct atmel_pwm *ap = to_atmel_pwm(p);
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+	clk_enable(ap->clk);
+	p->tick_hz = clk_get_rate(ap->clk);
+	__atmel_pwm_unsynchronize(p, NULL);
+	__atmel_pwm_stop(p);
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	return 0;
+}
+
+static void
+atmel_pwm_free(struct pwm_channel *p)
+{
+	struct atmel_pwm *ap = to_atmel_pwm(p);
+	clk_disable(ap->clk);
+}
+
+static irqreturn_t
+atmel_pwmc_irq(int irq, void *data)
+{
+	struct atmel_pwm *ap = data;
+	struct pwm_channel *p;
+	u32 isr;
+	int chid;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ap->lock, flags);
+
+	isr = pwmc_readl(ap, PWMC_ISR);
+	for (chid = 0; isr; chid++, isr >>= 1) {
+		p = &ap->pwm.channels[chid];
+		if (isr & 1) {
+			if (p->callback)
+				p->callback(p);
+			if (p->flags & BIT(FLAG_STOP)) {
+				__atmel_pwm_stop(p);
+				clear_bit(FLAG_STOP, &p->flags);
+			}
+			complete_all(&p->complete);
+		}
+	}
+
+	spin_unlock_irqrestore(&ap->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit
+atmel_pwmc_probe(struct platform_device *pdev)
+{
+	struct atmel_pwm *ap;
+	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int ret = 0;
+
+	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
+	if (!ap) {
+		ret = -ENOMEM;
+		goto err_atmel_pwm_alloc;
+	}
+
+	spin_lock_init(&ap->lock);
+	platform_set_drvdata(pdev, ap);
+
+	ap->pwm.dev = &pdev->dev;
+	ap->pwm.bus_id = dev_name(&pdev->dev);
+
+	ap->pwm.nchan = 4; /* TODO: true only for SAM9263 and AP7000 */
+	ap->ccnt_mask = 0xffffUL; /* TODO: true only for SAM9263 */
+
+	ap->sync_mask = kzalloc(ap->pwm.nchan * sizeof(u32), GFP_KERNEL);
+	if (!ap->sync_mask) {
+		ret = -ENOMEM;
+		goto err_alloc_sync_masks;
+	}
+
+	ap->pwm.owner = THIS_MODULE;
+	ap->pwm.request = atmel_pwm_request;
+	ap->pwm.free = atmel_pwm_free;
+	ap->pwm.config_nosleep = atmel_pwm_config_nosleep;
+	ap->pwm.config = atmel_pwm_config;
+	ap->pwm.synchronize = atmel_pwm_synchronize;
+	ap->pwm.unsynchronize = atmel_pwm_unsynchronize;
+	ap->pwm.set_callback = atmel_pwm_set_callback;
+
+	ap->clk = clk_get(&pdev->dev, "pwm_clk");
+	if (PTR_ERR(ap->clk)) {
+		ret = -ENODEV;
+		goto err_clk_get;
+	}
+
+	ap->iobase = ioremap_nocache(r->start, r->end - r->start + 1);
+	if (!ap->iobase) {
+		ret = -ENODEV;
+		goto err_ioremap;
+	}
+
+	clk_enable(ap->clk);
+	pwmc_writel(ap, PWMC_DIS, -1);
+	pwmc_writel(ap, PWMC_IDR, -1);
+	clk_disable(ap->clk);
+
+	ap->irq = platform_get_irq(pdev, 0);
+	if (ap->irq != -ENXIO) {
+		ret = request_irq(ap->irq, atmel_pwmc_irq, 0,
+				  ap->pwm.bus_id, ap);
+		if (ret)
+			goto err_request_irq;
+	}
+
+	ret = pwm_register(&ap->pwm);
+	if (ret)
+		goto err_pwm_register;
+
+	return 0;
+
+err_pwm_register:
+	if (ap->irq != -ENXIO)
+		free_irq(ap->irq, ap);
+err_request_irq:
+	iounmap(ap->iobase);
+err_ioremap:
+	clk_put(ap->clk);
+err_clk_get:
+	platform_set_drvdata(pdev, NULL);
+err_alloc_sync_masks:
+	kfree(ap);
+err_atmel_pwm_alloc:
+	return ret;
+}
+
+static int __devexit
+atmel_pwmc_remove(struct platform_device *pdev)
+{
+	struct atmel_pwm *ap = platform_get_drvdata(pdev);
+	int ret;
+
+	/* TODO: what can we do if this fails? */
+	ret = pwm_unregister(&ap->pwm);
+
+	clk_enable(ap->clk);
+	pwmc_writel(ap, PWMC_IDR, -1);
+	pwmc_writel(ap, PWMC_DIS, -1);
+	clk_disable(ap->clk);
+
+	if (ap->irq != -ENXIO)
+		free_irq(ap->irq, ap);
+
+	clk_put(ap->clk);
+	iounmap(ap->iobase);
+
+	kfree(ap);
+
+	return 0;
+}
+
+static struct platform_driver atmel_pwm_driver = {
+	.driver = {
+		.name = "atmel_pwmc",
+		.owner = THIS_MODULE,
+	},
+	.probe = atmel_pwmc_probe,
+	.remove = __devexit_p(atmel_pwmc_remove),
+};
+
+static int __init atmel_pwm_init(void)
+{
+	return platform_driver_register(&atmel_pwm_driver);
+}
+module_init(atmel_pwm_init);
+
+static void __exit atmel_pwm_exit(void)
+{
+	platform_driver_unregister(&atmel_pwm_driver);
+}
+module_exit(atmel_pwm_exit);
+
+MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
+MODULE_DESCRIPTION("Driver for Atmel PWMC peripheral");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel_pwmc");
-- 
1.6.5

