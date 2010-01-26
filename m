Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577Ab0AZR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0AZR21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703Ab0AZR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:28:27 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:50363 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754161Ab0AZR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:28:26 -0500
Date: Tue, 26 Jan 2010 20:28:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] gpiolib: Introduce chip addition/removal notifier
Message-ID: <20100126172824.GA20319@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
 <20100125181100.GA13805@oksana.dev.rtsoft.ru>
 <201001252234.30169.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001252234.30169.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:34:29PM -0800, David Brownell wrote:
> On Monday 25 January 2010, Anton Vorontsov wrote:
> > 
> > +config GPIOLIB_NOTIFIER
> > +       bool
> > +       help
> > +         This symbol is selected by subsystems that need to handle GPIO
> > +         chips addition and removal. E.g., this is used for the
> > +         OpenFirmware bindings.
> > +
> 
> I'm no huge fan of notifiers, but I suppose they have their place.
> 
> However ... I don't see a lot of win to making this optional.

OK, will remove it.

> Just
> inline the little two blocking_notifier_call_chain() calls directly,
> making this a *LOT* simpler.

I'd rather stay with gpio_call_chain() helper, it makes the code
a little bit prettier, IMO. Compare this:

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1103,6 +1107,9 @@ fail:
 		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
 			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
+	else
+		blocking_notifier_call_chain(&gpio_notifier,
+					     GPIO_NOTIFY_CHIP_ADDED, chip);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
@@ -1119,6 +1126,13 @@ int gpiochip_remove(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
+	/* Ask external subsystems to release the chip. */
+	status = blocking_notifier_call_chain(&gpio_notifier,
+					      GPIO_NOTIFY_CHIP_REMOVE, chip);
+	status = notifier_to_errno(status);
+	if (status)
+		return status;
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {

--- 

With the call_chain helper:

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1029,6 +1030,16 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+static int gpio_call_chain(struct gpio_chip *chip, enum gpio_notify_msg msg)
+{
+	int ret = blocking_notifier_call_chain(&gpio_notifier, msg, chip);
+
+	return notifier_to_errno(ret);
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -1103,6 +1114,9 @@ fail:
 		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
 			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
+	else
+		gpio_call_chain(chip, GPIO_NOTIFY_CHIP_ADDED);
+
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
@@ -1119,6 +1133,11 @@ int gpiochip_remove(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
+	/* Ask external subsystems to release the chip. */
+	status = gpio_call_chain(chip, GPIO_NOTIFY_CHIP_REMOVE);
+	if (status)
+		return status;
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
--- 

Thanks!
