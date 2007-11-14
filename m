Return-Path: <linux-kernel-owner+w=401wt.eu-S1763871AbXKNBDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763871AbXKNBDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761263AbXKNBDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:03:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:11468 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761225AbXKNBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:03:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eQWhu1ZV47bk9F64Dvm/vGnEshHtmNYPJClp9tfJv+dhtWpOF9ISCMlVS/y7FPdLYX11DvWEuy81js0l4dkA+UGDMCqYqDxY1ftRMJK95ZkW6tvSqFO9mkc709cwsJAyh5bWv2HUMrQbWXcGQ4wT7LAOe+cVn7PuKyYQV1WKZmc=
Message-ID: <f17812d70711131703g2e37d68aub8cacc61ccbae49f@mail.gmail.com>
Date: Wed, 14 Nov 2007 09:03:29 +0800
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
In-Reply-To: <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes the point of "struct gpio_desc"

Subject: [PATCH 3/5] use a per GPIO "struct gpio_desc" and chain
"gpio_chip" to a list

---
 include/asm-generic/gpio.h |    7 +++++
 lib/gpiolib.c              |   64 ++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ba3e336..783adcf 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -23,6 +23,12 @@

 struct seq_file;

+struct gpio_chip;
+
+struct gpio_desc {
+	struct gpio_chip *chip;
+};
+
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
@@ -76,6 +82,7 @@ struct gpio_chip {
 	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);

 #ifdef CONFIG_DEBUG_FS
+	struct list_head	node;
 	const char		*requested_str[ARCH_GPIOS_PER_CHIP];
 #endif
 };
diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index d52c7f1..57e0d10 100644
--- a/lib/gpiolib.c
+++ b/lib/gpiolib.c
@@ -25,13 +25,12 @@
 #define	extra_checks	0
 #endif

-/* gpio_lock protects modification to the table of chips and to
- * gpio_chip->requested.  If a gpio is requested, its gpio_chip
- * is not removable.
- */
 static DEFINE_SPINLOCK(gpio_lock);
-static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
-					ARCH_GPIOS_PER_CHIP)];
+struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
+
+#ifdef CONFIG_DEBUG_FS
+static LIST_HEAD(gpio_chip_list);
+#endif

 static inline int gpio_is_onchip(unsigned gpio, struct gpio_chip *chip)
 {
@@ -63,7 +62,7 @@ static void gpio_ensure_requested(struct gpio_chip
*chip, unsigned offset)
 /* caller holds gpio_lock */
 static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
-	return chips[gpio / ARCH_GPIOS_PER_CHIP];
+	return gpio_desc[gpio].chip;
 }

 /**
@@ -78,7 +77,6 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 int gpiochip_add(struct gpio_chip *chip)
 {
 	unsigned long	flags;
-	int		status = 0;
 	unsigned	id;

 	if (chip->base < 0 || (chip->base % ARCH_GPIOS_PER_CHIP) != 0)
@@ -89,13 +87,21 @@ int gpiochip_add(struct gpio_chip *chip)
 		return -EINVAL;

 	spin_lock_irqsave(&gpio_lock, flags);
-	id = chip->base / ARCH_GPIOS_PER_CHIP;
-	if (chips[id] == NULL)
-		chips[id] = chip;
-	else
-		status = -EBUSY;
+
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		if (gpio_desc[id].chip) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			return -EBUSY;
+		}
+
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		gpio_desc[id].chip = chip;
+
+#ifdef CONFIG_DEBUG_FS
+	list_add(&chip->node, &gpio_chip_list);
+#endif
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	return status;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);

@@ -108,28 +114,26 @@ EXPORT_SYMBOL_GPL(gpiochip_add);
 int gpiochip_remove(struct gpio_chip *chip)
 {
 	unsigned long	flags;
-	int		status = 0;
 	int		offset;
-	unsigned	id = chip->base / ARCH_GPIOS_PER_CHIP;
+	unsigned	id;

 	spin_lock_irqsave(&gpio_lock, flags);

-	for (offset = 0; offset < chip->ngpio; offset++) {
+	for (offset = 0; offset < chip->ngpio; offset++)
 		if (gpiochip_is_requested(chip, offset)) {
-			status = -EBUSY;
-			break;
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			return -EBUSY;
 		}
-	}

-	if (status == 0) {
-		if (chips[id] == chip)
-			chips[id] = NULL;
-		else
-			status = -EINVAL;
-	}
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		gpio_desc[id].chip = NULL;
+
+#ifdef CONFIG_DEBUG_FS
+	list_del(&chip->node);
+#endif

 	spin_unlock_irqrestore(&gpio_lock, flags);
-	return status;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);

@@ -463,11 +467,7 @@ static int gpiolib_show(struct seq_file *s, void *unused)

 	/* REVISIT this isn't locked against gpio_chip removal ... */

-	for (id = 0; id < ARRAY_SIZE(chips); id++) {
-		chip = chips[id];
-		if (!chip)
-			continue;
-
+	list_for_each_entry(chip, &gpio_chip_list, node) {
 		seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
 				started ? "\n" : "",
 				chip->base, chip->base + chip->ngpio - 1,
-- 
1.5.2.5.GIT
