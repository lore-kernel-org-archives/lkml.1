Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYIYSiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYIYSiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYIYShx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:37:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:40425 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982AbYIYShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:37:52 -0400
Date: Thu, 25 Sep 2008 22:37:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linuxppc-dev@ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc/QE: implement QE Pin Multiplexing API
Message-ID: <20080925183750.GB25627@oksana.dev.rtsoft.ru>
References: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today the API is still based on a fact that QE gpio controllers
are registered. If they aren't, the API won't work (gracefully
though).

There is one caveat though: if anybody occupied the node->data
before us, or overwrote it, then bad things will happen. Luckily
this is all in the platform code that we fully control, so this
should never happen.

I could implement more checks (for example we could create a list
of successfully registered QE controllers, and compare the node->data
in the qe_pin_get()), but this is unneeded if nobody is going to do
silly things behind our back.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

p.s. I should probably change qe_pin_get() to allocate and return
struct qe_pin instead of accepting already allocated one.

 arch/powerpc/include/asm/qe.h     |   20 +++++
 arch/powerpc/sysdev/qe_lib/gpio.c |  167 +++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/qe.h b/arch/powerpc/include/asm/qe.h
index edee15d..3f15b2f 100644
--- a/arch/powerpc/include/asm/qe.h
+++ b/arch/powerpc/include/asm/qe.h
@@ -112,6 +112,26 @@ extern int par_io_config_pin(u8 port, u8 pin, int dir, int open_drain,
 			     int assignment, int has_irq);
 extern int par_io_data_set(u8 port, u8 pin, u8 val);
 
+/*
+ * Pin multiplexing functions.
+ */
+struct qe_gpio_chip;
+
+struct qe_pin {
+	/*
+	 * The qe_gpio_chip name is unfortunate, we should change that to
+	 * something like qe_pio_controller. Someday.
+	 */
+	struct qe_gpio_chip *controller;
+	int num;
+};
+
+extern int qe_pin_get(struct device_node *np, int index,
+		      struct qe_pin *qe_pin);
+extern void qe_pin_put(struct qe_pin *qe_pin);
+extern void qe_pin_set_gpio(struct qe_pin *qe_pin);
+extern void qe_pin_set_dedicated(struct qe_pin *pin);
+
 /* QE internal API */
 int qe_issue_cmd(u32 cmd, u32 device, u8 mcn_protocol, u32 cmd_input);
 enum qe_clock qe_clock_source(const char *source);
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index 8e5a0bc..f0d504b 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -24,8 +24,14 @@ struct qe_gpio_chip {
 	struct of_mm_gpio_chip mm_gc;
 	spinlock_t lock;
 
+#define QE_PIN_REQUESTED 0
+	unsigned long pin_flags[QE_PIO_PINS];
+
 	/* shadowed data register to clear/set bits safely */
 	u32 cpdata;
+
+	/* saved_regs used to restore dedicated functions */
+	struct qe_pio_regs saved_regs;
 };
 
 static inline struct qe_gpio_chip *
@@ -40,6 +46,12 @@ static void qe_gpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 	struct qe_pio_regs __iomem *regs = mm_gc->regs;
 
 	qe_gc->cpdata = in_be32(&regs->cpdata);
+	qe_gc->saved_regs.cpdata = qe_gc->cpdata;
+	qe_gc->saved_regs.cpdir1 = in_be32(&regs->cpdir1);
+	qe_gc->saved_regs.cpdir2 = in_be32(&regs->cpdir2);
+	qe_gc->saved_regs.cppar1 = in_be32(&regs->cppar1);
+	qe_gc->saved_regs.cppar2 = in_be32(&regs->cppar2);
+	qe_gc->saved_regs.cpodr = in_be32(&regs->cpodr);
 }
 
 static int qe_gpio_get(struct gpio_chip *gc, unsigned int gpio)
@@ -103,6 +115,161 @@ static int qe_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
+/**
+ * qe_pin_get - Get a QE pin from the device tree
+ * @np:		device node to get a pin from
+ * @index:	index of a pin in the device tree
+ * @qe_pin:	pointer to the allocated qe_pin structure
+ *
+ * This function finds a pin from the device in the device tree and fills
+ * the qe_pin structure so that you could use it with the rest of QE Pin
+ * Multiplexing API.
+ */
+int qe_pin_get(struct device_node *np, int index, struct qe_pin *qe_pin)
+{
+	struct device_node *gc;
+	struct of_gpio_chip *of_gc = NULL;
+	struct of_mm_gpio_chip *mm_gc;
+	struct qe_gpio_chip *qe_gc;
+	int ret;
+	int size;
+	const void *gpio_spec;
+	const u32 *gpio_cells;
+	unsigned long flags;
+
+	ret = of_parse_phandles_with_args(np, "gpios", "#gpio-cells", index,
+					  &gc, &gpio_spec);
+	if (ret) {
+		pr_debug("%s: can't parse gpios property\n", __func__);
+		return ret;
+	}
+
+	if (!of_device_is_compatible(gc, "fsl,mpc8323-qe-pario-bank")) {
+		pr_debug("%s: tried to get a non-qe pin\n", __func__);
+		ret = -EINVAL;
+		goto err1;
+	}
+
+	of_gc = gc->data;
+	if (!of_gc) {
+		pr_debug("%s: gpio controller %s isn't registered\n",
+			 np->full_name, gc->full_name);
+		goto err1;
+	}
+
+	gpio_cells = of_get_property(gc, "#gpio-cells", &size);
+	if (!gpio_cells || size != sizeof(*gpio_cells) ||
+			*gpio_cells != of_gc->gpio_cells) {
+		pr_debug("%s: wrong #gpio-cells for %s\n",
+			 np->full_name, gc->full_name);
+		goto err1;
+	}
+
+	ret = of_gc->xlate(of_gc, np, gpio_spec);
+	if (ret < 0)
+		goto err1;
+
+	mm_gc = to_of_mm_gpio_chip(&of_gc->gc);
+	qe_gc = to_qe_gpio_chip(mm_gc);
+
+	spin_lock_irqsave(&qe_gc->lock, flags);
+
+	if (test_and_set_bit(QE_PIN_REQUESTED, &qe_gc->pin_flags[ret]) == 0) {
+		qe_pin->controller = qe_gc;
+		qe_pin->num = ret;
+		ret = 0;
+	} else {
+		ret = -EBUSY;
+	}
+
+	spin_unlock_irqrestore(&qe_gc->lock, flags);
+err1:
+	of_node_put(gc);
+	pr_debug("%s exited with status %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL(qe_pin_get);
+
+void qe_pin_put(struct qe_pin *qe_pin)
+{
+	struct qe_gpio_chip *qe_gc = qe_pin->controller;
+	unsigned long flags;
+	int pin = qe_pin->num;
+
+	spin_lock_irqsave(&qe_gc->lock, flags);
+
+	if (test_and_clear_bit(QE_PIN_REQUESTED, &qe_gc->pin_flags[pin])) {
+		qe_pin->controller = NULL;
+		qe_pin->num = -1;
+	} else {
+		WARN_ON(1);
+	}
+
+	spin_unlock_irqrestore(&qe_gc->lock, flags);
+}
+EXPORT_SYMBOL(qe_pin_put);
+
+/**
+ * qe_pin_set_dedicated - Revert a pin to a dedicated peripheral function mode
+ * @qe_pin:	pointer to the qe_pin structure
+ *
+ * This function resets a pin to a dedicated peripheral function that
+ * has been set up by the firmware.
+ */
+void qe_pin_set_dedicated(struct qe_pin *qe_pin)
+{
+	struct qe_gpio_chip *qe_gc = qe_pin->controller;
+	struct qe_pio_regs __iomem *regs = qe_gc->mm_gc.regs;
+	struct qe_pio_regs *sregs = &qe_gc->saved_regs;
+	int pin = qe_pin->num;
+	u32 mask1 = 1 << (QE_PIO_PINS - (pin + 1));
+	u32 mask2 = 0x3 << (QE_PIO_PINS - (pin % (QE_PIO_PINS / 2) + 1) * 2);
+	bool second_reg = pin > (QE_PIO_PINS / 2) - 1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qe_gc->lock, flags);
+
+	if (second_reg) {
+		clrsetbits_be32(&regs->cpdir2, mask2, sregs->cpdir2 & mask2);
+		clrsetbits_be32(&regs->cppar2, mask2, sregs->cppar2 & mask2);
+	} else {
+		clrsetbits_be32(&regs->cpdir1, mask2, sregs->cpdir1 & mask2);
+		clrsetbits_be32(&regs->cppar1, mask2, sregs->cppar1 & mask2);
+	}
+
+	if (sregs->cpdata & mask1)
+		qe_gc->cpdata |= mask1;
+	else
+		qe_gc->cpdata &= ~mask1;
+
+	out_be32(&regs->cpdata, qe_gc->cpdata);
+	clrsetbits_be32(&regs->cpodr, mask1, sregs->cpodr & mask1);
+
+	spin_unlock_irqrestore(&qe_gc->lock, flags);
+}
+EXPORT_SYMBOL(qe_pin_set_dedicated);
+
+/**
+ * qe_pin_set_gpio - Set a pin to the GPIO mode
+ * @qe_pin:	pointer to the qe_pin structure
+ *
+ * This function sets a pin to the GPIO mode.
+ */
+void qe_pin_set_gpio(struct qe_pin *qe_pin)
+{
+	struct qe_gpio_chip *qe_gc = qe_pin->controller;
+	struct qe_pio_regs __iomem *regs = qe_gc->mm_gc.regs;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qe_gc->lock, flags);
+
+	/* Let's make it input by default, GPIO API is able to change that. */
+	__par_io_config_pin(regs, qe_pin->num, QE_PIO_DIR_IN, 0, 0, 0);
+
+	spin_unlock_irqrestore(&qe_gc->lock, flags);
+}
+EXPORT_SYMBOL(qe_pin_set_gpio);
+
 static int __init qe_add_gpiochips(void)
 {
 	struct device_node *np;
-- 
1.5.6.3
