Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbXKNBET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbXKNBET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761263AbXKNBEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:04:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:40960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbXKNBEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cCs6PzbGpPtyGRixMIDlk5b9bX8UTf+6qOtc35HUqgRNgKGbnmlFB/g6i63+Etjo3CJ3gNoBe3cfbkIL5kCN+lazOuc69As7Hy1bzBKivSKxcK5bFGaJXB+bqOQf22Jo/oYrShBS7n3sqD0ivhwvqYW4DOdJN76RGhACtdUxJ00=
Message-ID: <f17812d70711131704r4de82efat757dbb5479273ce2@mail.gmail.com>
Date: Wed, 14 Nov 2007 09:04:03 +0800
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
In-Reply-To: <f17812d70711131703g2e37d68aub8cacc61ccbae49f@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] move per GPIO "is_out" to "struct gpio_desc"

---
 include/asm-generic/gpio.h |    4 +---
 lib/gpiolib.c              |   18 +++++++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 783adcf..da67038 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -27,6 +27,7 @@ struct gpio_chip;

 struct gpio_desc {
 	struct gpio_chip *chip;
+	unsigned is_out:1;
 };

 /**
@@ -47,8 +48,6 @@ struct gpio_desc {
  *	(base + ngpio - 1).
  * @can_sleep: flag must be set iff get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
- * @is_out: bit array where bit N is true iff GPIO with offset N has been
- *	 called successfully to configure this as an output
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
@@ -78,7 +77,6 @@ struct gpio_chip {
 	unsigned		can_sleep:1;

 	/* other fields are modified by the gpio library only */
-	DECLARE_BITMAP(is_out, ARCH_GPIOS_PER_CHIP);
 	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);

 #ifdef CONFIG_DEBUG_FS
diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index 57e0d10..a089597 100644
--- a/lib/gpiolib.c
+++ b/lib/gpiolib.c
@@ -217,11 +217,14 @@ int gpio_direction_input(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 	int			status = -EINVAL;

 	spin_lock_irqsave(&gpio_lock, flags);

-	chip = gpio_to_chip(gpio);
+	desc = &gpio_desc[gpio];
+	chip = desc->chip;
+
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;

@@ -238,8 +241,7 @@ int gpio_direction_input(unsigned gpio)
 	might_sleep_if(extra_checks && chip->can_sleep);

 	status = chip->direction_input(chip, gpio);
-	if (status == 0)
-		clear_bit(gpio, chip->is_out);
+	desc->is_out = 0;
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -251,11 +253,14 @@ int gpio_direction_output(unsigned gpio, int value)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 	int			status = -EINVAL;

 	spin_lock_irqsave(&gpio_lock, flags);

-	chip = gpio_to_chip(gpio);
+	desc = &gpio_desc[gpio];
+	chip = desc->chip;
+
 	if (!chip || !chip->get || !chip->direction_output)
 		goto fail;
 	
@@ -272,8 +277,7 @@ int gpio_direction_output(unsigned gpio, int value)
 	might_sleep_if(extra_checks && chip->can_sleep);

 	status = chip->direction_output(chip, gpio, value);
-	if (status == 0)
-		set_bit(gpio, chip->is_out);
+	desc->is_out = 1;
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -402,7 +406,7 @@ static void gpiolib_dbg_show(struct seq_file *s,
struct gpio_chip *chip)
 			continue;

 		gpio = chip->base + i;
-		is_out = test_bit(i, chip->is_out);
+		is_out = gpio_desc[gpio].is_out;

 		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
 			gpio, chip->requested_str[i],
-- 
1.5.2.5.GIT
