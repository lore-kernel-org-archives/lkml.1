Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZGMPTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZGMPTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbZGMPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:19:46 -0400
Received: from ru.mvista.com ([213.79.90.228]:62978 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756142AbZGMPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:19:45 -0400
Date: Mon, 13 Jul 2009 19:19:44 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc/qe: Implement set_sync() callback for QE GPIOs
Message-ID: <20090713151944.GB4486@oksana.dev.rtsoft.ru>
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to set GPIO's values synchronously.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/gpio.h   |   11 +++++++++++
 arch/powerpc/sysdev/qe_lib/gpio.c |   27 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/gpio.h b/arch/powerpc/include/asm/gpio.h
index ea04632..899f365 100644
--- a/arch/powerpc/include/asm/gpio.h
+++ b/arch/powerpc/include/asm/gpio.h
@@ -33,6 +33,17 @@ static inline void gpio_set_value(unsigned int gpio, int value)
 	__gpio_set_value(gpio, value);
 }
 
+static inline int gpio_can_set_values_sync(unsigned num, unsigned *gpios)
+{
+	return __gpio_can_set_values_sync(num, gpios);
+}
+
+static inline void gpio_set_values_sync(unsigned num, unsigned *gpios,
+					int *values)
+{
+	__gpio_set_values_sync(num, gpios, values);
+}
+
 static inline int gpio_cansleep(unsigned int gpio)
 {
 	return __gpio_cansleep(gpio);
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/arch/powerpc/sysdev/qe_lib/gpio.c
index 3485288..6cfe784 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/arch/powerpc/sysdev/qe_lib/gpio.c
@@ -84,6 +84,32 @@ static void qe_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	spin_unlock_irqrestore(&qe_gc->lock, flags);
 }
 
+static void qe_gpio_set_sync(struct gpio_chip *gc, unsigned int num,
+			     unsigned int *gpios, int *vals)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct qe_gpio_chip *qe_gc = to_qe_gpio_chip(mm_gc);
+	struct qe_pio_regs __iomem *regs = mm_gc->regs;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&qe_gc->lock, flags);
+
+	for (i = 0; i < num; i++) {
+		unsigned int gpio = gpios[i] - gc->base;
+		u32 pin_mask = 1 << (QE_PIO_PINS - 1 - gpio);
+
+		if (vals[i])
+			qe_gc->cpdata |= pin_mask;
+		else
+			qe_gc->cpdata &= ~pin_mask;
+	}
+
+	out_be32(&regs->cpdata, qe_gc->cpdata);
+
+	spin_unlock_irqrestore(&qe_gc->lock, flags);
+}
+
 static int qe_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
@@ -328,6 +354,7 @@ static int __init qe_add_gpiochips(void)
 		gc->direction_output = qe_gpio_dir_out;
 		gc->get = qe_gpio_get;
 		gc->set = qe_gpio_set;
+		gc->set_sync = qe_gpio_set_sync;
 
 		ret = of_mm_gpiochip_add(np, mm_gc);
 		if (ret)
-- 
1.6.3.3
