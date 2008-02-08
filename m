Return-Path: <linux-kernel-owner+w=401wt.eu-S964900AbYBHLKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900AbYBHLKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbYBHLKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:10:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:38099 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753043AbYBHLKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:10:12 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18fIGVrZKIf7HzZCWLJyfws6f/6zuX21KTeQiaB6K
	cIUv1KLEO+w2gu
Date: Fri, 8 Feb 2008 12:10:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] prevent gpio chip drivers from unloading while used
Message-ID: <Pine.LNX.4.64.0802081159580.5301@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as one or more GPIOs on a gpio chip are used its driver should not 
be unloaded.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Note, that existing drivers do not have to be modified, for example those, 
that are always statically linked in the kernel, as long as the respective 
struct gpio_chip is nullified before calling gpiochip_add().

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d8db2f8..dd535e1 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -177,6 +177,9 @@ int gpio_request(unsigned gpio, const char *label)
 	if (desc->chip == NULL)
 		goto done;
 
+	if (!try_module_get(desc->chip->owner))
+		goto done;
+
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled.
 	 */
@@ -184,8 +187,10 @@ int gpio_request(unsigned gpio, const char *label)
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		desc_set_label(desc, label ? : "?");
 		status = 0;
-	} else
+	} else {
 		status = -EBUSY;
+		module_put(desc->chip->owner);
+	}
 
 done:
 	if (status)
@@ -209,9 +214,10 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags))
+	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
 		desc_set_label(desc, NULL);
-	else
+		module_put(desc->chip->owner);
+	} else
 		WARN_ON(extra_checks);
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 806b86c..f6d389a 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_HAVE_GPIO_LIB
 
+#include <linux/module.h>
+
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
  * extra memory (for code and for per-GPIO table entries).
@@ -52,6 +54,7 @@ struct seq_file;
  */
 struct gpio_chip {
 	char			*label;
+	struct module		*owner;
 
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
