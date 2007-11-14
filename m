Return-Path: <linux-kernel-owner+w=401wt.eu-S1763172AbXKNBA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763172AbXKNBA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbXKNBAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:00:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:33413 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbXKNBAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KCI66vzXxkFDh9HqHJ08p4GAsZw7AJ63xQfKtVkvMtTOBFRjlGDVvECWQp6ZGpulRwG+ya3i4eUzmTibq6+54SB1NHszsHz03fxl/Eu9u4D8ifXGT4FvG7j+CdUytTw0i4wW2LkSod16Ucy8q7zH5+Uf5N+7o9op5pgdWuDshD8=
Message-ID: <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
Date: Wed, 14 Nov 2007 09:00:46 +0800
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
In-Reply-To: <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711051305.13980.david-b@pacbell.net>
	 <f17812d70711121828k49fe25b4ycf538061d0fb33b4@mail.gmail.com>
	 <200711131106.11277.david-b@pacbell.net>
	 <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes a bunch of patches to illustrate my idea, some are not related to
the point I mentioned, and they are not mature for now :-)

Subject: [PATCH 1/5] add gpio_is_onchip() for commonly used gpio range checking

---
 lib/gpiolib.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index f2ae689..c627efb 100644
--- a/lib/gpiolib.c
+++ b/lib/gpiolib.c
@@ -33,6 +33,14 @@ static DEFINE_SPINLOCK(gpio_lock);
 static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
 					ARCH_GPIOS_PER_CHIP)];

+static inline int gpio_is_onchip(unsigned gpio, struct gpio_chip *chip)
+{
+	if (chip && gpio >= chip->base && gpio < chip->base + chip->ngpio)
+		return 1;
+	else
+		return 0;
+}
+
 /* Warn when drivers omit gpio_request() calls -- legal but
  * ill-advised when setting direction, and otherwise illegal.
  */
@@ -139,11 +147,11 @@ int gpio_request(unsigned gpio, const char *label)

 	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
-	if (!chip)
+
+	if (!gpio_is_onchip(gpio, chip))
 		goto done;
+
 	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto done;

 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled.
@@ -176,11 +184,11 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);

 	chip = gpio_to_chip(gpio);
-	if (!chip)
+
+	if (!gpio_is_onchip(gpio, chip))
 		goto done;
+
 	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto done;

 #ifdef CONFIG_DEBUG_FS
 	if (chip->requested[gpio])
@@ -218,9 +226,11 @@ int gpio_direction_input(unsigned gpio)
 	chip = gpio_to_chip(gpio);
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
+
+	if (!gpio_is_onchip(gpio, chip))
 		goto fail;
+
+	gpio -= chip->base;
 	gpio_ensure_requested(chip, gpio);

 	/* now we know the gpio is valid and chip won't vanish */
@@ -250,9 +260,11 @@ int gpio_direction_output(unsigned gpio, int value)
 	chip = gpio_to_chip(gpio);
 	if (!chip || !chip->get || !chip->direction_output)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
+	
+	if (!gpio_is_onchip(gpio, chip))
 		goto fail;
+
+	gpio -= chip->base;
 	gpio_ensure_requested(chip, gpio);

 	/* now we know the gpio is valid and chip won't vanish */
-- 
1.5.2.5.GIT
