Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZFRWU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZFRWU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZFRWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:20:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbZFRWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:20:17 -0400
Date: Thu, 18 Jun 2009 15:19:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk,
       baruch@tkos.co.il
Subject: Re: [PATCH v6] gpio: driver for PrimeCell PL061 GPIO controller
Message-Id: <20090618151916.32d55e6e.akpm@linux-foundation.org>
In-Reply-To: <1245220477-6904-1-git-send-email-baruch@tkos.co.il>
References: <1245220477-6904-1-git-send-email-baruch@tkos.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 09:34:37 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> is implemented using the gpiolib framework.
> 
> This driver also includes support for the use of the PL061 as an interrupt
> controller (secondary).
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Changes in v6:
> 	- Address the comments of David Brownell:
> 	  * remove gpio_request() from the IRQ code
> 	  * remove irq_to_gpio() from the IRQ code
> 	- Use a bitmap to track initialized trigger IRQ
> 
> Changes in v5:
> 	- Use resource_size() as suggested by Linus Walleij
> 	- Add a comment about the list member of pl061_gpio
> 
> Changes in v4:
> 	- Depend on CONFIG_ARM_AMBA
> 	- Do not request the gpio for IRQ automatically, just warn if it's not 
> 	  requested
> 	- Remove SZ_4K
> 	- Iterate through a linked list find the source of interrupt when 
> 	  multiple PL061s are connected to the same IRQ trigger
> 	- Move hardware register defines into the .c file
> 
> Changes in v3:
> 	- amba driver instead of a platform driver
> 	- Move include/linux/gpio/pl061.h => include/linux/amba/pl061.h
> 
> Changes in v2:
> 	- Address Andrew Morton's comments
> 	- Pass checkpatch.pl
> 	- Add changelog comment
> 

Wholesale replacement patches are particularly unfriendly to people who
have reviewed the earlier versions.  otoh, delta patches are unfriendly
to those who have not done so.

I'll append the delta here.

> ...
>
> +static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
> +{
> +	struct pl061_platform_data *pdata;
> +	struct pl061_gpio *chip;
> +	struct list_head *chip_list;
> +	int ret, irq, i;
> +	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];

We could perhaps use DECLARE_BITMAP() here.  Which implies that the
whole use of this bitmap should use the bitmap API rather than
open-coded bitops.

I don't know whether that would actually improve anything - it's just a
thought..

> +	pdata = dev->dev.platform_data;
> +	if (pdata == NULL)
> +		return -ENODEV;
> +
> +	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> +	if (chip == NULL)
> +		return -ENOMEM;
> +
> +	if (!request_mem_region(dev->res.start,
> +				resource_size(&dev->res), "pl061")) {
> +		ret = -EBUSY;
> +		goto free_mem;
> +	}
> +
> +	chip->base = ioremap(dev->res.start, resource_size(&dev->res));
> +	if (chip->base == NULL) {
> +		ret = -ENOMEM;
> +		goto release_region;
> +	}
> +
> +	spin_lock_init(&chip->lock);
> +	spin_lock_init(&chip->irq_lock);
> +	INIT_LIST_HEAD(&chip->list);
> +
> +	chip->gc.direction_input = pl061_direction_input;
> +	chip->gc.direction_output = pl061_direction_output;
> +	chip->gc.get = pl061_get_value;
> +	chip->gc.set = pl061_set_value;
> +	chip->gc.base = pdata->gpio_base;
> +	chip->gc.ngpio = PL061_GPIO_NR;
> +	chip->gc.label = dev_name(&dev->dev);
> +	chip->gc.dev = &dev->dev;
> +	chip->gc.owner = THIS_MODULE;
> +
> +	chip->irq_base = pdata->irq_base;
> +
> +	ret = gpiochip_add(&chip->gc);
> +	if (ret)
> +		goto iounmap;
> +
> +	/*
> +	 * irq_chip support
> +	 */
> +
> +	if (chip->irq_base == (unsigned) -1)
> +		return 0;
> +
> +	writeb(0, chip->base + GPIOIE); /* disable irqs */
> +	irq = dev->irq[0];
> +	if (irq < 0) {
> +		ret = -ENODEV;
> +		goto iounmap;
> +	}
> +	set_irq_chained_handler(irq, pl061_irq_handler);
> +	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
> +		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
> +		if (chip_list == NULL) {

We should do a clear_bit() here.

> +			ret = -ENOMEM;
> +			goto iounmap;
> +		}
> +		INIT_LIST_HEAD(chip_list);
> +		set_irq_chip_data(irq, chip_list);
> +	} else
> +		chip_list = get_irq_chip_data(irq);
> +	list_add(&chip->list, chip_list);
> +
> +	for (i = 0; i < PL061_GPIO_NR; i++) {
> +		if (pdata->directions & (1 << i))
> +			pl061_direction_output(&chip->gc, i,
> +					pdata->values & (1 << i));
> +		else
> +			pl061_direction_input(&chip->gc, i);
> +
> +		set_irq_chip(i+chip->irq_base, &pl061_irqchip);
> +		set_irq_handler(i+chip->irq_base, handle_simple_irq);
> +		set_irq_flags(i+chip->irq_base, IRQF_VALID);
> +		set_irq_chip_data(i+chip->irq_base, chip);
> +	}
> +
> +	return 0;
> +
> +iounmap:
> +	iounmap(chip->base);
> +release_region:
> +	release_mem_region(dev->res.start, resource_size(&dev->res));
> +free_mem:
> +	kfree(chip);
> +
> +	return ret;
> +}

 drivers/gpio/pl061.c       |   39 +++++++++++++++--------------------
 include/linux/amba/pl061.h |   14 +++++-------
 2 files changed, 23 insertions(+), 30 deletions(-)

diff -puN drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v6 drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v6
+++ a/drivers/gpio/pl061.c
@@ -53,6 +53,7 @@ struct pl061_gpio {
 	spinlock_t		irq_lock;	/* IRQ registers */
 
 	void __iomem		*base;
+	unsigned		irq_base;
 	struct gpio_chip	gc;
 };
 
@@ -114,7 +115,7 @@ static void pl061_set_value(struct gpio_
 static void pl061_irq_disable(unsigned irq)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
+	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -128,7 +129,7 @@ static void pl061_irq_disable(unsigned i
 static void pl061_irq_enable(unsigned irq)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
+	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -139,25 +140,14 @@ static void pl061_irq_enable(unsigned ir
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static unsigned int pl061_irq_startup(unsigned irq)
-{
-	if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
-		pr_warning("%s: warning: GPIO%d has not been requested\n",
-				__func__, irq_to_gpio(irq));
-
-	pl061_irq_enable(irq);
-
-	return 0;
-}
-
 static int pl061_irq_type(unsigned irq, unsigned trigger)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
+	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
-	if (irq_to_gpio(irq) < 0)
+	if (offset < 0 || offset > PL061_GPIO_NR)
 		return -EINVAL;
 
 	spin_lock_irqsave(&chip->irq_lock, flags);
@@ -196,7 +186,6 @@ static int pl061_irq_type(unsigned irq, 
 
 static struct irq_chip pl061_irqchip = {
 	.name		= "GPIO",
-	.startup	= pl061_irq_startup,
 	.enable		= pl061_irq_enable,
 	.disable	= pl061_irq_disable,
 	.set_type	= pl061_irq_type,
@@ -232,6 +221,7 @@ static int __init pl061_probe(struct amb
 	struct pl061_gpio *chip;
 	struct list_head *chip_list;
 	int ret, irq, i;
+	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];
 
 	pdata = dev->dev.platform_data;
 	if (pdata == NULL)
@@ -267,6 +257,8 @@ static int __init pl061_probe(struct amb
 	chip->gc.dev = &dev->dev;
 	chip->gc.owner = THIS_MODULE;
 
+	chip->irq_base = pdata->irq_base;
+
 	ret = gpiochip_add(&chip->gc);
 	if (ret)
 		goto iounmap;
@@ -274,6 +266,10 @@ static int __init pl061_probe(struct amb
 	/*
 	 * irq_chip support
 	 */
+
+	if (chip->irq_base == (unsigned) -1)
+		return 0;
+
 	writeb(0, chip->base + GPIOIE); /* disable irqs */
 	irq = dev->irq[0];
 	if (irq < 0) {
@@ -281,7 +277,7 @@ static int __init pl061_probe(struct amb
 		goto iounmap;
 	}
 	set_irq_chained_handler(irq, pl061_irq_handler);
-	if (!pdata->is_irq_initialized || !pdata->is_irq_initialized(irq)) {
+	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
 		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
 		if (chip_list == NULL) {
 			ret = -ENOMEM;
@@ -300,11 +296,10 @@ static int __init pl061_probe(struct amb
 		else
 			pl061_direction_input(&chip->gc, i);
 
-		set_irq_chip(gpio_to_irq(i+pdata->gpio_base), &pl061_irqchip);
-		set_irq_handler(gpio_to_irq(i+pdata->gpio_base),
-				handle_simple_irq);
-		set_irq_flags(gpio_to_irq(i+pdata->gpio_base), IRQF_VALID);
-		set_irq_chip_data(gpio_to_irq(i+pdata->gpio_base), chip);
+		set_irq_chip(i+chip->irq_base, &pl061_irqchip);
+		set_irq_handler(i+chip->irq_base, handle_simple_irq);
+		set_irq_flags(i+chip->irq_base, IRQF_VALID);
+		set_irq_chip_data(i+chip->irq_base, chip);
 	}
 
 	return 0;
diff -puN include/linux/amba/pl061.h~gpio-driver-for-primecell-pl061-gpio-controller-v6 include/linux/amba/pl061.h
--- a/include/linux/amba/pl061.h~gpio-driver-for-primecell-pl061-gpio-controller-v6
+++ a/include/linux/amba/pl061.h
@@ -4,14 +4,12 @@ struct pl061_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
 
+	/* number of the first IRQ.
+	 * If the IRQ functionality in not desired this must be set to
+	 * (unsigned) -1.
+	 */
+	unsigned	irq_base;
+
 	u8		directions;	/* startup directions, 1: out, 0: in */
 	u8		values;		/* startup values */
-
-	/* This callback may be used when you have more than one PL061
-	 * connected to the same IRQ trigger. This callback must return 0 on
-	 * the first time it is called for each irq, and 1 on any other call.
-	 * In case you are not unfortunate enough to have this setup, this
-	 * pointer must be set to NULL.
-	 */
-	int		(*is_irq_initialized)(int irq);
 };
_

