Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYIRPSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYIRPSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYIRPRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:17:40 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9312 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756500AbYIRPRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:17:39 -0400
Date: Thu, 18 Sep 2008 19:17:35 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] powerpc/qe: new call to revert a gpio to a dedicated
	function
Message-ID: <20080918151735.GB31187@oksana.dev.rtsoft.ru>
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080918151659.GA20140@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qe_gpio_set_dedicated() is a platform specific function, which is used
to revert a pin to a dedicated function. Caller should have already
obtained the gpio via gpio_request().

This is needed to support Freescale USB Host Controller.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/qe.h     |    1 +
 arch/powerpc/sysdev/qe_lib/gpio.c |   46 +++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/qe.h b/arch/powerpc/include/asm/qe.h
index edee15d..c926147 100644
--- a/arch/powerpc/include/asm/qe.h
+++ b/arch/powerpc/include/asm/qe.h
@@ -111,6 +111,7 @@ extern void __par_io_config_pin(struct qe_pio_regs __iomem *par_io, u8 pin,
 extern int par_io_config_pin(u8 port, u8 pin, int dir, int open_drain,
 			     int assignment, int has_irq);
 extern int par_io_data_set(u8 port, u8 pin, u8 val);
+extern int qe_gpio_set_dedicated(unsigned int gpio);
 
 /* QE internal API */
 int qe_issue_cmd(u32 cmd, u32 device, u8 mcn_protocol, u32 cmd_input);
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index 8e5a0bc..bd7278f 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -26,6 +26,9 @@ struct qe_gpio_chip {
 
 	/* shadowed data register to clear/set bits safely */
 	u32 cpdata;
+
+	/* saved_regs used to restore dedicated functions */
+	struct qe_pio_regs saved_regs;
 };
 
 static inline struct qe_gpio_chip *
@@ -40,6 +43,12 @@ static void qe_gpio_save_regs(struct of_mm_gpio_chip *mm_gc)
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
@@ -103,6 +112,43 @@ static int qe_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
+int qe_gpio_set_dedicated(unsigned int gpio)
+{
+	struct gpio_chip *gc = gpio_to_chip(gpio);
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct qe_gpio_chip *qe_gc = to_qe_gpio_chip(mm_gc);
+	struct qe_pio_regs __iomem *regs = mm_gc->regs;
+	struct qe_pio_regs *sregs = &qe_gc->saved_regs;
+	u8 pin = gpio - gc->base;
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
+
+	return 0;
+}
+EXPORT_SYMBOL(qe_gpio_set_dedicated);
+
 static int __init qe_add_gpiochips(void)
 {
 	struct device_node *np;
-- 
1.5.6.3

