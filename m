Return-Path: <linux-kernel-owner+w=401wt.eu-S1764067AbXKNBEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764067AbXKNBEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbXKNBEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:04:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:41357 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071AbXKNBEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m4z4mTlnJTbA0FSzp/8lISUleq1W3bWwtpTJMGUUBKfY3anRh+WBHoNNd6Oa0eGvjRTH86fN7cd8p7QzWNzRkHsL+/xTjLPporAwP8ssCo29Bj21nsOhlmZL5pKn8zRUjCqcc7XeSL1o5xZ4Aw9vBRcewWAFecuBSDJZ8xhXTWs=
Message-ID: <f17812d70711131704l6b0562ffmec6e7e1981130898@mail.gmail.com>
Date: Wed, 14 Nov 2007 09:04:41 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <f17812d70711131704r4de82efat757dbb5479273ce2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711051305.13980.david-b@pacbell.net>
	 <f17812d70711121828k49fe25b4ycf538061d0fb33b4@mail.gmail.com>
	 <200711131106.11277.david-b@pacbell.net>
	 <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
	 <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
	 <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com>
	 <f17812d70711131703g2e37d68aub8cacc61ccbae49f@mail.gmail.com>
	 <f17812d70711131704r4de82efat757dbb5479273ce2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 5/5] move per GPIO "requested" to "struct gpio_desc"

---
 include/asm-generic/gpio.h |   17 +++---------
 lib/gpiolib.c              |   62 ++++++++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index da67038..7e70c67 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -28,6 +28,10 @@ struct gpio_chip;
 struct gpio_desc {
 	struct gpio_chip *chip;
 	unsigned is_out:1;
+	unsigned requested:1;
+#ifdef CONFIG_DEBUG_FS
+	const char *requested_str;
+#endif
 };

 /**
@@ -76,24 +80,11 @@ struct gpio_chip {
 	u16			ngpio;
 	unsigned		can_sleep:1;

-	/* other fields are modified by the gpio library only */
-	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);
-
 #ifdef CONFIG_DEBUG_FS
 	struct list_head	node;
-	const char		*requested_str[ARCH_GPIOS_PER_CHIP];
 #endif
 };

-/* returns true iff a given gpio signal has been requested;
- * primarily for code dumping gpio_chip state.
- */
-static inline int
-gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
-{
-	return test_bit(offset, chip->requested);
-}
-
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index a089597..f9e1c88 100644
--- a/lib/gpiolib.c
+++ b/lib/gpiolib.c
@@ -43,20 +43,19 @@ static inline int gpio_is_onchip(unsigned gpio,
struct gpio_chip *chip)
 /* Warn when drivers omit gpio_request() calls -- legal but
  * ill-advised when setting direction, and otherwise illegal.
  */
-static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
+static void gpio_ensure_requested(unsigned gpio)
 {
-	int		requested;
+	int requested;

-	requested = test_and_set_bit(offset, chip->requested);
+	requested = gpio_desc[gpio].requested;

 #ifdef CONFIG_DEBUG_FS
 	if (!requested)
-		chip->requested_str[offset] = "(auto)";
+		gpio_desc[gpio].requested_str = "(auto)";
 #endif

 	if (!requested)
-		printk(KERN_DEBUG "GPIO-%d autorequested\n",
-				chip->base + offset);
+		pr_debug("GPIO-%d autorequested\n", gpio);
 }

 /* caller holds gpio_lock */
@@ -114,13 +113,12 @@ EXPORT_SYMBOL_GPL(gpiochip_add);
 int gpiochip_remove(struct gpio_chip *chip)
 {
 	unsigned long	flags;
-	int		offset;
 	unsigned	id;

 	spin_lock_irqsave(&gpio_lock, flags);

-	for (offset = 0; offset < chip->ngpio; offset++)
-		if (gpiochip_is_requested(chip, offset)) {
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		if (gpio_desc[id].requested) {
 			spin_unlock_irqrestore(&gpio_lock, flags);
 			return -EBUSY;
 		}
@@ -145,11 +143,14 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
 int gpio_request(unsigned gpio, const char *label)
 {
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 	int			status = -EINVAL;
 	unsigned long		flags;

 	spin_lock_irqsave(&gpio_lock, flags);
-	chip = gpio_to_chip(gpio);
+
+	desc = &gpio_desc[gpio];
+	chip = desc->chip;

 	if (!gpio_is_onchip(gpio, chip))
 		goto done;
@@ -162,12 +163,14 @@ int gpio_request(unsigned gpio, const char *label)

 	status = 0;

-	if (test_and_set_bit(gpio, chip->requested))
+	if (desc->requested == 0)
+		desc->requested = 1;
+	else
 		status = -EBUSY;

 #ifdef CONFIG_DEBUG_FS
 	if (status == 0)
-		chip->requested_str[gpio] = (label == NULL) ? "?" : label;
+		desc->requested_str = (label == NULL) ? "?" : label;
 #endif

 done:
@@ -180,9 +183,11 @@ void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;

 	spin_lock_irqsave(&gpio_lock, flags);

+	desc = &gpio_desc[gpio];
 	chip = gpio_to_chip(gpio);

 	if (!gpio_is_onchip(gpio, chip))
@@ -190,12 +195,13 @@ void gpio_free(unsigned gpio)

 	gpio -= chip->base;

-	if (!test_and_clear_bit(gpio, chip->requested))
+	if (desc->requested == 0)
+		desc->requested = 1;
+	else
 		chip = NULL;

 #ifdef CONFIG_DEBUG_FS
-	if (chip != NULL)
-		chip->requested_str[gpio] = NULL;
+	desc->requested_str = NULL;
 #endif
 	WARN_ON(extra_checks && chip == NULL);
 done:
@@ -231,8 +237,8 @@ int gpio_direction_input(unsigned gpio)
 	if (!gpio_is_onchip(gpio, chip))
 		goto fail;

+	gpio_ensure_requested(gpio);
 	gpio -= chip->base;
-	gpio_ensure_requested(chip, gpio);

 	/* now we know the gpio is valid and chip won't vanish */

@@ -267,8 +273,8 @@ int gpio_direction_output(unsigned gpio, int value)
 	if (!gpio_is_onchip(gpio, chip))
 		goto fail;

+	gpio_ensure_requested(gpio);
 	gpio -= chip->base;
-	gpio_ensure_requested(chip, gpio);

 	/* now we know the gpio is valid and chip won't vanish */

@@ -304,7 +310,7 @@ int __gpio_get_value(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
 	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
+		gpio_ensure_requested(gpio);
 	spin_unlock_irqrestore(&gpio_lock, flags);

 	if (unlikely(chip->can_sleep)) {
@@ -323,7 +329,7 @@ void __gpio_set_value(unsigned gpio, int value)
 	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
 	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
+		gpio_ensure_requested(gpio);
 	spin_unlock_irqrestore(&gpio_lock, flags);

 	if (unlikely(chip->can_sleep))
@@ -341,7 +347,7 @@ int __gpio_cansleep(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
 	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
+		gpio_ensure_requested(gpio);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return chip->can_sleep;
 }
@@ -363,7 +369,7 @@ int gpio_get_value_cansleep(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
 	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
+		gpio_ensure_requested(gpio);
 	spin_unlock_irqrestore(&gpio_lock, flags);

 	return chip->get(chip, gpio - chip->base);
@@ -380,7 +386,7 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
 	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
 	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
+		gpio_ensure_requested(gpio);
 	spin_unlock_irqrestore(&gpio_lock, flags);

 	chip->set(chip, gpio - chip->base, value);
@@ -401,21 +407,23 @@ static void gpiolib_dbg_show(struct seq_file *s,
struct gpio_chip *chip)
 	for (i = 0; i < chip->ngpio; i++) {
 		unsigned	gpio;
 		int		is_out;
+		struct gpio_desc *desc;

-		if (!chip->requested_str[i])
+		if (!desc->requested)
 			continue;

 		gpio = chip->base + i;
-		is_out = gpio_desc[gpio].is_out;
+		desc = &gpio_desc[gpio];
+		is_out = desc->is_out;

 		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
-			gpio, chip->requested_str[i],
-			is_out ? "out" : "in ",
+			gpio, desc->requested_str,
+			desc->is_out ? "out" : "in ",
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ");

-		if (!is_out) {
+		if (!desc->is_out) {
 			int		irq = gpio_to_irq(gpio);
 			struct irq_desc	*desc = irq_desc + irq;

-- 
1.5.2.5.GIT
