Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYCMWxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYCMWxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbYCMWxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:53:11 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:43298 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756089AbYCMWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:53:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RcVTBW+YRlB+8F2DEyCJelxt3QIzNzbu6QO5m+BO76EngSdYXhVPYZ6XO/2wqpBEdaLqZfPv6SgSECMiwOXTKlcruIotp/uDXNJRUn5DrBABvDI0q2Qj0YeuP+U1QvvKdPeOcfGiYafzM4m1A0CDP4K6td58ByXdPhEaT2xPQiE=  ;
X-YMail-OSG: gSmNBdcVM1kQ0yvXBqX8QiA21XhVJOH5Umli4c5Y2ucpvGk.IINDs._P7iKz7VV7HKrJn2p4Xw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc5 2/2] gpiochip_reserve()
Date: Thu, 13 Mar 2008 14:52:21 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131552.22122.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>

Add a new function gpiochip_reserve() to reserve ranges of gpios that
platform code has pre-allocated.  That is, this marks gpio numbers which
will be claimed by drivers that haven't yet been loaded, and thus are
not available for dynamic gpio number allocation.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c     |   51 ++++++++++++++++++++++++++++++++++++++++++---
 include/asm-generic/gpio.h |    1 
 2 files changed, 49 insertions(+), 3 deletions(-)

--- g26.orig/drivers/gpio/gpiolib.c	2008-03-13 14:51:50.000000000 -0700
+++ g26/drivers/gpio/gpiolib.c	2008-03-13 14:56:16.000000000 -0700
@@ -43,6 +43,7 @@ struct gpio_desc {
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
+#define FLAG_RESERVED	2
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -88,9 +89,10 @@ static int gpiochip_find_base(int ngpio)
 	int base = -ENOSPC;
 
 	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
-		struct gpio_chip *chip = gpio_desc[i].chip;
+		struct gpio_desc *desc = &gpio_desc[i];
+		struct gpio_chip *chip = desc->chip;
 
-		if (!chip) {
+		if (!chip && !test_bit(FLAG_RESERVED, &desc->flags)) {
 			spare++;
 			if (spare == ngpio) {
 				base = i;
@@ -98,7 +100,8 @@ static int gpiochip_find_base(int ngpio)
 			}
 		} else {
 			spare = 0;
-			i -= chip->ngpio - 1;
+			if (chip)
+				i -= chip->ngpio - 1;
 		}
 	}
 
@@ -108,6 +111,48 @@ static int gpiochip_find_base(int ngpio)
 }
 
 /**
+ * gpiochip_reserve() - reserve range of gpios to use with platform code only
+ * @start: starting gpio number
+ * @ngpio: number of gpios to reserve
+ * Context: platform init, potentially before irqs or kmalloc will work
+ *
+ * Returns a negative errno if any gpio within the range is already reserved
+ * or registered, else returns zero as a success code.  Use this function
+ * to mark a range of gpios as unavailable for dynamic gpio number allocation,
+ * for example because its driver support is not yet loaded.
+ */
+int __init __must_check gpiochip_reserve(int start, int ngpio)
+{
+	int ret = 0;
+	unsigned long flags;
+	int i;
+
+	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio))
+		return -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	for (i = start; i < start + ngpio; i++) {
+		struct gpio_desc *desc = &gpio_desc[i];
+
+		if (desc->chip || test_bit(FLAG_RESERVED, &desc->flags)) {
+			ret = -EBUSY;
+			goto err;
+		}
+
+		set_bit(FLAG_RESERVED, &desc->flags);
+	}
+
+	pr_debug("%s: reserved gpios from %d to %d\n",
+		 __func__, start, start + ngpio - 1);
+err:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gpiochip_reserve);
+
+/**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
  * Context: potentially before irqs or kmalloc will work
--- g26.orig/include/asm-generic/gpio.h	2008-03-13 14:41:52.000000000 -0700
+++ g26/include/asm-generic/gpio.h	2008-03-13 14:55:10.000000000 -0700
@@ -74,6 +74,7 @@ struct gpio_chip {
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
+extern int __init __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
