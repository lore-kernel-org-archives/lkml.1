Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYCLMX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYCLMX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYCLMXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:23:19 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:26068 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750765AbYCLMXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:23:18 -0400
Date: Wed, 12 Mar 2008 15:23:15 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] gpiolib: implement gpiochip_reserve
Message-ID: <20080312122315.GA500@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <20080311174118.GB12397@localhost.localdomain> <200803111411.38287.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200803111411.38287.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 01:11:37PM -0800, David Brownell wrote:
> On Tuesday 11 March 2008, Anton Vorontsov wrote:
> > Function gpiochip_reserve() reserves range of gpios to use with
> > platform code only, that is, this function used to mark specified
> > range of gpios unavailable for the dynamic gpio base allocator.
> 
> Since this is for platform code only, it doesn't need to stick
> around after initcalls have run.  So please mark it as __init so
> that we minimize the footprint cost.

Good idea, thanks.

[...]
> >  	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
> > -		struct gpio_chip *chip = gpio_desc[i].chip;
> > +		struct gpio_desc *desc = &gpio_desc[i];
> > +		struct gpio_chip *chip = desc->chip;
> >  
> > -		if (!chip) {
> > +		if (!chip && !test_bit(FLAG_RESERVED, &desc->flags)) {
> >  			spare++;
> >  			if (spare == ngpio) {
> >  				base = i;
> > @@ -97,7 +141,8 @@ static int gpiochip_find_base(int ngpio)
> >  			}
> >  		} else {
> >  			spare = 0;
> > -			i -= chip->ngpio - 1;
> > +			if (chip)
> > +				i -= chip->ngpio - 1;
> 
> Isn't this little optimization a bit error prone?

So far I don't see how exactly it could be error prone.

> It
> presumes the reserved bits and gpio chips are in fairly
> close synch.

Probably I don't understand the synch part here. The thing is that
I'm replacing if (!chip) with if (!chip && !test_bit(FLAG_RESERVED,
&desc->flags)), so now "else" code might be executed when gpio is
either reserved or the range of gpios is already managed by the chip.
In later case we can skip whole range, because we know its size.
In case of reserved or spare gpio we can't do that, so we simply
try the next one. Anything wrong with this scheme?..


Below the patch with __init attribute added.

- - - -
From: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: gpiolib: implement gpiochip_reserve

Function gpiochip_reserve() reserves range of gpios to use with
platform code only, that is, this function used to mark specified
range of gpios unavailable for the dynamic gpio base allocator.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c     |   51 +++++++++++++++++++++++++++++++++++++++++--
 include/asm-generic/gpio.h |    1 +
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 81d81c9..372bcc5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -43,6 +43,7 @@ struct gpio_desc {
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
+#define FLAG_RESERVED	2
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -80,6 +81,48 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 	return gpio_desc[gpio].chip;
 }
 
+/**
+ * gpiochip_reserve() - reserve range of gpios to use with platform code only
+ * @start: starting gpio number
+ * @ngpio: number of gpios to reserve
+ * Context: potentially before irqs or kmalloc will work
+ *
+ * Returns a negative errno if any gpio within the range already reserved
+ * or registered. Otherwise it returns zero as a success code.
+ * Use this function to mark specified range of gpios unavailable for the
+ * dynamic gpio base allocator.
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
 static int gpiochip_find_base(int ngpio)
 {
 	int i;
@@ -87,9 +130,10 @@ static int gpiochip_find_base(int ngpio)
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
@@ -97,7 +141,8 @@ static int gpiochip_find_base(int ngpio)
 			}
 		} else {
 			spare = 0;
-			i -= chip->ngpio - 1;
+			if (chip)
+				i -= chip->ngpio - 1;
 		}
 	}
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 464c5b3..ecf675a 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -74,6 +74,7 @@ struct gpio_chip {
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
+extern int __init __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
-- 
1.5.2.2

