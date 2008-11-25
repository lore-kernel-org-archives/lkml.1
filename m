Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYKYWxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYKYWxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYKYWwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:52:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:10588 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYKYWwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FOlGLlwRD1m1OpkdQR139xYdHUzV3oKnaAS2kUD/OEHqaAsQYhCCcQHmU3+Pm6Mx81
         BsK8lk0iu4nJj2Qg49OTP7fiGvF6dqn/2hjfYuum8XKkZto0N5hxJmhfB9L0CuAKMtBa
         R73QXeZPASCTjvUjYiOEjGYhgt4D2PpeKrO3s=
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: jayakumar.lkml@gmail.com
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Brownell <david-b@pacbell.net>, Sam Ravnborg <sam@ravnborg.org>,
       Jean Delvare <khali@linux-fr.org>, Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Wed, 26 Nov 2008 06:52:43 +0800
Message-Id: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
X-Mailer: git-send-email 1.5.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beloved friends,

I would like to request your feedback on the following idea. I hope I have
made sure to CC all the right people and the right lists! If not, PLEASE
let me know! I couldn't find a MAINTAINERS entry for gpiolib so I just
used what I saw in the git log and have also added people and lists that
I think may be interested.

This is just an RFC. If you all feel it is looking like the right approach
then I'll clean it up and make it a patch.

Thanks,
jaya

am300epd was doing 800*600*16*gpio_set_value for each framebuffer transfer
(it uses 16-pins of gpio as its data bus). I found this caused a wee
performance limitation. This patch adds an API for gpio_set_value_bus
which allows users to set batches of consecutive gpio together in a single
call. I have done a test implementation on gumstix (pxa255) with am300epd
and it provides a nice improvement in performance.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ben Gardner <bgardner@wabtec.com>
CC: Greg KH <greg@kroah.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org

---
 arch/arm/mach-pxa/am300epd.c          |    9 ++++++
 arch/arm/mach-pxa/gpio.c              |   28 +++++++++++++++++++++
 arch/arm/mach-pxa/include/mach/gpio.h |   24 ++++++++++++++++++
 drivers/gpio/gpiolib.c                |   44 +++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h            |    6 ++++
 5 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index bb81564..f741a98 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -222,8 +222,17 @@ static void am300_set_hdb(struct broadsheetfb_par *par, u16 data)
 {
 	int i;
 
+#if 1
+	gpio_set_value_bus(DB0_GPIO_PIN, data, 16);
+#endif
+#if 0
+	gpio_set_value_bus(DB0_GPIO_PIN, data, 6);
+	gpio_set_value_bus(DB0_GPIO_PIN + 6, data >> 6, 10);
+#endif
+#if 0 /* simple set */
 	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
 		gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
+#endif
 }
 
 
diff --git a/arch/arm/mach-pxa/gpio.c b/arch/arm/mach-pxa/gpio.c
index 14930cf..80b0aa1 100644
--- a/arch/arm/mach-pxa/gpio.c
+++ b/arch/arm/mach-pxa/gpio.c
@@ -132,6 +132,33 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 		__raw_writel(mask, pxa->regbase + GPCR_OFFSET);
 }
 
+/*
+ * Set output GPIO level in batches
+ */
+static void pxa_gpio_set_bus(struct gpio_chip *chip, unsigned offset,
+				int values, int bitwidth)
+{
+	struct pxa_gpio_chip *pxa;
+	int mask;
+
+	/* we're guaranteed by the caller that offset + bitwidth remains
+	 * in this chip.
+	 */
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	mask = ((1 << bitwidth) - 1) << offset;
+	values <<= offset;
+
+	values &= mask;
+	if (values)
+		__raw_writel(values, pxa->regbase + GPSR_OFFSET);
+
+	values = ~values;
+	values &= mask;
+	if (values)
+		__raw_writel(values, pxa->regbase + GPCR_OFFSET);
+}
+
 #define GPIO_CHIP(_n)							\
 	[_n] = {							\
 		.regbase = GPIO##_n##_BASE,				\
@@ -141,6 +168,7 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 			.direction_output = pxa_gpio_direction_output,	\
 			.get		  = pxa_gpio_get,		\
 			.set		  = pxa_gpio_set,		\
+			.set_bus	  = pxa_gpio_set_bus,		\
 			.base		  = (_n) * 32,			\
 			.ngpio		  = 32,				\
 		},							\
diff --git a/arch/arm/mach-pxa/include/mach/gpio.h b/arch/arm/mach-pxa/include/mach/gpio.h
index 2c538d8..6ee92d3 100644
--- a/arch/arm/mach-pxa/include/mach/gpio.h
+++ b/arch/arm/mach-pxa/include/mach/gpio.h
@@ -56,6 +56,30 @@ static inline void gpio_set_value(unsigned gpio, int value)
 	}
 }
 
+static inline void gpio_set_value_bus(unsigned gpio, int values, int bitwidth)
+{
+	if (__builtin_constant_p(gpio) &&
+		(gpio + bitwidth < NR_BUILTIN_GPIO) &&
+		((gpio + bitwidth) <= roundup(gpio+1, 32))) {
+		int shift, mask;
+
+		shift = gpio % 32;
+		mask = ((1 << bitwidth) - 1) << shift;
+		values <<= shift;
+
+		values &= mask;
+		if (values)
+			GPSR(gpio) = values;
+
+		values = ~values;
+		values &= mask;
+		if (values)
+			GPCR(gpio) = values;
+	} else {
+		__gpio_set_value_bus(gpio, values, bitwidth);
+	}
+}
+
 #define gpio_cansleep __gpio_cansleep
 
 #define gpio_to_irq(gpio)	IRQ_GPIO(gpio)
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9112830..fddf3af 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1057,6 +1057,50 @@ void __gpio_set_value(unsigned gpio, int value)
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
 /**
+ * __gpio_set_value_bus() - assign a batch of consecutive gpio pins together
+ * @gpio: starting gpio pin
+ * @values: values to assign, sequential in host ordering
+ * @bitwidth: total width of bits to be assigned
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_set_value().
+ * It invokes the associated gpio_chip.set() method.
+ */
+void __gpio_set_value_bus(unsigned gpio, int values, int bitwidth)
+{
+	struct gpio_chip	*chip;
+	int i = 0;
+	int value, width, remwidth;
+
+	do {
+		chip = gpio_to_chip(gpio + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		if (!chip->set_bus) {
+			while (((gpio + i) < (chip->base + chip->ngpio))
+				&& bitwidth) {
+				value = values & (1 << i);
+				chip->set(chip, gpio + i - chip->base, value);
+				i++;
+				bitwidth--;
+			}
+		} else {
+			value = values >> i; /* shift off the used stuff */
+			remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) gpio + i));
+			width = min(bitwidth, remwidth);
+
+			chip->set_bus(chip, gpio + i - chip->base, value,
+					width);
+			i += width;
+			bitwidth -= width;
+		}
+	} while (bitwidth);
+}
+EXPORT_SYMBOL_GPL(__gpio_set_value_bus);
+
+
+/**
  * __gpio_cansleep() - report whether gpio value access will sleep
  * @gpio: gpio in question
  * Context: any
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 81797ec..9747517 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -44,6 +44,8 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @set_bus: batch assigns output values for consecutive signals starting at
+ *	"offset" with width in bits "bitwidth"
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
@@ -84,6 +86,9 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	void			(*set_bus)(struct gpio_chip *chip,
+						unsigned offset, int values,
+						int bitwidth);
 
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
@@ -124,6 +129,7 @@ extern void gpio_set_value_cansleep(unsigned gpio, int value);
  */
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
+extern void __gpio_set_value_bus(unsigned gpio, int values, int bitwidth);
 
 extern int __gpio_cansleep(unsigned gpio);
 
-- 
1.5.2.3

