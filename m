Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbYKDREO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbYKDREO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbYKDRD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:03:58 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:38731 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637AbYKDRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:03:57 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 12:03:57 EST
Date: Tue, 4 Nov 2008 17:57:25 +0100
From: Marc Zyngier <maz@misterjones.org>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Allow a set of GPIOs to be requested and configured at
 once
Message-ID: <20081104175725.1872b4ed@not-of-this-earth.wild-wind.fr.eu.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.53.103.82
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch extends the gpiolib API with two new functions:
- gpio_request_set() allow a set of GPIOs to be requested, and possibly
configured (direction, level) at the same time, using a simple table.
In case of failure, the configuration is rolled back, and the offending
GPIO is returned to the user.
- gpio_free_set() frees this same set of GPIOs.

The main goal of this patch is to save gpiolib users the burden of
requesting and configuring each GPIO, and dealing with complicated error
handling.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
---
 drivers/gpio/gpiolib.c     |   54 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   14 +++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index faa1cc6..4a8f29c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -813,6 +813,51 @@ done:
 }
 EXPORT_SYMBOL_GPL(gpio_request);
 
+int gpio_request_set(struct gpio_config *gpio_set, int nr,
+		     struct gpio_config **err)
+{
+	int i;
+	int stat = 0;
+	int cur = 0;
+	struct gpio_config *conf = NULL;
+
+	for (i = 0; i < nr; i++) {
+		cur = i;
+		conf = gpio_set + i;
+		stat = gpio_request(conf->gpio, conf->label);
+		if (stat)
+			goto rollback;
+
+		switch (conf->direction) {
+			case GPIO_CONFIG_DIRECTION_INPUT:
+				stat = gpio_direction_input(conf->gpio);
+				break;
+
+			case GPIO_CONFIG_DIRECTION_OUTPUT:
+				stat = gpio_direction_output(conf->gpio,
+							     !!conf->value);
+				break;
+		}
+
+		if (stat) {
+			gpio_free(conf->gpio);
+			goto rollback;
+		}
+	}
+
+	return stat;
+
+rollback:
+	for (i = cur - 1; i >= 0; i--)
+		gpio_free(gpio_set[i].gpio);
+
+	if (err)
+		*err = conf;
+
+	return stat;
+}
+EXPORT_SYMBOL_GPL(gpio_request_set);
+
 void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
@@ -849,6 +894,15 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
+void gpio_free_set(struct gpio_config *gpio_set, int nr)
+{
+	int i;
+
+	for (i = 0; i < nr; i++)
+		gpio_free(gpio_set[i].gpio);
+}
+EXPORT_SYMBOL_GPL(gpio_free_set);
+
 
 /**
  * gpiochip_is_requested - return string iff signal was requested
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 81797ec..723159f 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -111,6 +111,20 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
+#define GPIO_CONFIG_DIRECTION_INPUT	1
+#define GPIO_CONFIG_DIRECTION_OUTPUT	2
+
+struct gpio_config {
+	unsigned		gpio;
+	const char		*label;
+	u16			direction;
+	u16			value;
+};
+
+extern int gpio_request_set(struct gpio_config *gpio_set, int nr,
+			    struct gpio_config **err);
+extern void gpio_free_set(struct gpio_config *gpio_set, int nr);
+
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 
-- 
1.5.4.3



-- 
A rat a day keeps the plague away.
