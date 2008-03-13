Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYCMWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYCMWxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbYCMWxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:53:10 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:43295 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755886AbYCMWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:53:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iyn08C1wGcnrizcMtjNkHStjSbbupT17PNAYSwvPX/XfhuKZA7kiEVxwesAKx5kI0TsKmd9Innx/Kh/JJurhrYRIgg1QFrPLBgAVcPJ3t5Fc93Wcw89T4UrMt07HJCC+sAfXMxy+vWiDwOVZvX6kQuJaA/TNsYB/4TepAI1Gk6U=  ;
X-YMail-OSG: xQkQaFAVM1kY9hPzT7i.PqtIneyl97p59d.4ua_jXKmIooUVlJxZz2aRpz1qhIsVNzPTAUeERg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Date: Thu, 13 Mar 2008 14:49:53 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131549.54632.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>

If gpio_chip->base is negative during registration, gpiolib performs
dynamic base allocation. This is useful for devices that aren't always
present, such as GPIOs on hotplugged devices rather than mainboards.
(This behavior was previously specified but not implemented.)

To avoid using any numbers that may have been explicitly assigned but
not yet registered, this dynamic allocation assigns GPIO numbers from
the biggest number on down, instead of from the smallest on up.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |   52 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 7 deletions(-)

--- g26.orig/drivers/gpio/gpiolib.c	2008-03-13 14:41:52.000000000 -0700
+++ g26/drivers/gpio/gpiolib.c	2008-03-13 14:51:50.000000000 -0700
@@ -80,6 +80,33 @@ static inline struct gpio_chip *gpio_to_
 	return gpio_desc[gpio].chip;
 }
 
+/* dynamic allocation of GPIOs, e.g. on a hotplugged device */
+static int gpiochip_find_base(int ngpio)
+{
+	int i;
+	int spare = 0;
+	int base = -ENOSPC;
+
+	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
+		struct gpio_chip *chip = gpio_desc[i].chip;
+
+		if (!chip) {
+			spare++;
+			if (spare == ngpio) {
+				base = i;
+				break;
+			}
+		} else {
+			spare = 0;
+			i -= chip->ngpio - 1;
+		}
+	}
+
+	if (gpio_is_valid(base))
+		pr_debug("%s: found new base at %d\n", __func__, base);
+	return base;
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -88,38 +115,49 @@ static inline struct gpio_chip *gpio_to_
  * Returns a negative errno if the chip can't be registered, such as
  * because the chip->base is invalid or already associated with a
  * different chip.  Otherwise it returns zero as a success code.
+ *
+ * If chip->base is negative, this requests dynamic assignment of
+ * a range of valid GPIOs.
  */
 int gpiochip_add(struct gpio_chip *chip)
 {
 	unsigned long	flags;
 	int		status = 0;
 	unsigned	id;
+	int		base = chip->base;
 
-	/* NOTE chip->base negative is reserved to mean a request for
-	 * dynamic allocation.  We don't currently support that.
-	 */
-
-	if (chip->base < 0 || !gpio_is_valid(chip->base  + chip->ngpio)) {
+	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio))
+			&& base >= 0) {
 		status = -EINVAL;
 		goto fail;
 	}
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	if (base < 0) {
+		base = gpiochip_find_base(chip->ngpio);
+		if (base < 0) {
+			status = base;
+			goto fail_unlock;
+		}
+		chip->base = base;
+	}
+
 	/* these GPIO numbers must not be managed by another gpio_chip */
-	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+	for (id = base; id < base + chip->ngpio; id++) {
 		if (gpio_desc[id].chip != NULL) {
 			status = -EBUSY;
 			break;
 		}
 	}
 	if (status == 0) {
-		for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+		for (id = base; id < base + chip->ngpio; id++) {
 			gpio_desc[id].chip = chip;
 			gpio_desc[id].flags = 0;
 		}
 	}
 
+fail_unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
 	/* failures here can mean systems won't boot... */
