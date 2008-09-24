Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbYIXVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbYIXVsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYIXVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:48:14 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:37403 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751619AbYIXVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:48:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IXkIKoK1THcy0bAVH96CGaE9GFaZMZ5bEHwMYoT7XATk1A6eUk19YAOG6QPrnTY1paRxELXtEuRl9FNecvQsUSAv98BD76AHnJoRlmB/ULaSdhEwM7LrXniSUQqLqsl/Qbvw45ApyhwG9Ibi+l9y6ZrtyZjVSTFerSvvMkJWtuI=  ;
X-YMail-OSG: Rbuv7O4VM1k0rsHIMC90RXCCet88rAP8xhjPIsfl35ZNklNTCn9xfSEibKfxYetrGRquzLuhxRAht3NtlbqRf0wFz4rd8X2ISLmqHLdJGQsdup3eVslnjtnu1GoBHOKKq1u1Gu0IaE8c0R1H468e1Npt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27-rc7] gpiolib:  gpio_to_irq() hooks
Date: Wed, 24 Sep 2008 14:48:11 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241448.11313.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add a new gpiolib mechanism:  gpio_chip instances can provide
mappings between their (input) GPIOs and any associated IRQs.
This makes it easier for platforms to support IRQs that are
provided by board-specific external chips instead of as part
of their core (such as SOC-integrated GPIOs). 

Also update the irq_to_gpio() description, saying to avoid it
becuase it's not always supported.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
For 2.6.28-rc0 merge window.  I forget who was asking for
this; a few folk, who didn't provide patches.  I ended up
needing it myself, so here we are...

 Documentation/gpio.txt     |    5 +++--
 drivers/gpio/gpiolib.c     |   18 ++++++++++++++++++
 include/asm-generic/gpio.h |    7 +++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -264,7 +264,7 @@ map between them using calls like:
 	/* map GPIO numbers to IRQ numbers */
 	int gpio_to_irq(unsigned gpio);
 
-	/* map IRQ numbers to GPIO numbers */
+	/* map IRQ numbers to GPIO numbers (avoid using this) */
 	int irq_to_gpio(unsigned irq);
 
 Those return either the corresponding number in the other namespace, or
@@ -284,7 +284,8 @@ system wakeup capabilities.
 
 Non-error values returned from irq_to_gpio() would most commonly be used
 with gpio_get_value(), for example to initialize or update driver state
-when the IRQ is edge-triggered.
+when the IRQ is edge-triggered.  Note that some platforms don't support
+this reverse mapping, so you should avoid using it.
 
 
 Emulating Open Drain Signals
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1026,6 +1026,24 @@ int __gpio_cansleep(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_cansleep);
 
+/**
+ * __gpio_to_irq() - return the IRQ corresponding to a GPIO
+ * @gpio: gpio whose IRQ will be returned (already requested)
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_to_irq().
+ * It returns the number of the IRQ signaled by this (input) GPIO,
+ * or a negative errno.
+ */
+int __gpio_to_irq(unsigned gpio)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+	return chip->to_irq ? chip->to_irq(chip, gpio - chip->base) : -ENXIO;
+}
+EXPORT_SYMBOL_GPL(__gpio_to_irq);
+
 
 
 /* There's no value in making it easy to inline GPIO calls that may sleep.
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -44,6 +44,8 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
+ *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
  *	will be used when this is omitted, but custom code can show extra
  *	state (such as pullup/pulldown configuration).
@@ -82,6 +84,10 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+
+	int			(*to_irq)(struct gpio_chip *chip,
+						unsigned offset);
+
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
 	int			base;
@@ -121,6 +127,7 @@ extern void __gpio_set_value(unsigned gp
 
 extern int __gpio_cansleep(unsigned gpio);
 
+extern int __gpio_to_irq(unsigned gpio);
 
 #ifdef CONFIG_GPIO_SYSFS
 
