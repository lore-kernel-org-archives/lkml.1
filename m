Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYGRKGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYGRKGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYGRKFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:05:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:11107 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752567AbYGRKFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:05:52 -0400
Date: Fri, 18 Jul 2008 14:05:49 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080718100549.GA28741@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca> <20080717152006.GA26120@polina.dev.rtsoft.ru> <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp> <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 02:20:42AM -0700, Trent Piepho wrote:
> On Fri, 18 Jul 2008, Anton Vorontsov wrote:
> > On Thu, Jul 17, 2008 at 01:18:18PM -0700, Trent Piepho wrote:
> >> Basically what I did then in my patch then, refactor leds-gpio so most of
> >> it is shared and there is a block of code that does platform binding and
> >> another block that does of_platform binding.
> >
> > Ok. I must admit I'm quite burned out with OF gpio-leds. I was posting the
> > bindings since April, probably four or five times. Last time a week ago,
> > IIRC.
> >
> > During the months I received just a few replies, one from Grant ("Looks
> > good to me."), few from Segher (with a lot of criticism, that I much
> > appreciated and tried to fix all spotted issues), and one from Laurent
> > (about active-low LEDs).
> 
> I'm sorry, I never saw those emails.  Were they all to linuxppc-dev?  I hate
> reading that list, gmane, marc, and lkml.org don't archive it and
> mail-archive.com isn't nearly as nice.

Usually I use this archive: http://ozlabs.org/pipermail/linuxppc-dev/

> Is this the last version?
> http://www.mail-archive.com/linuxppc-dev@ozlabs.org/msg18355.html

No, this is v2 or something. The last version is the same as the current
one:

http://ozlabs.org/pipermail/linuxppc-dev/2008-July/059156.html

> Why did you get rid of "linux,default-trigger" 

Nobody liked it, even I myself. ;-)

http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056943.html

Later I tried to use aliases for default-trigger.

http://ozlabs.org/pipermail/linuxppc-dev/2008-June/057244.html

But after "i2c vs. cell-index vs. aliases" discussion I decided to
remove this stuff completely until I find something better (or
somebody will purpose).

As for linux,default-brightness... we don't need this since now we
have default-on trigger.

> and the active-low property?

Active-low can be coded inside the gpios = <>, via flags cell. And GPIO
controller can transparently support active-low GPIO states (i.e. just
like IRQ controllers automatically setting up IRQ trigger types based
on information from the device tree).

I implemented active-low flags for pixis gpio controller, but it is easy
to do this for any controller, when needed. Here is example:

diff --git a/arch/powerpc/platforms/86xx/pixis_gpio.c b/arch/powerpc/platforms/86xx/pixis_gpio.c
new file mode 100644
index 0000000..85254f9
--- /dev/null
+++ b/arch/powerpc/platforms/86xx/pixis_gpio.c
@@ -0,0 +1,141 @@
+/*
+ * PIXIS GPIOs
+ *
+ * Copyright (c) MontaVista Software, Inc. 2008.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/gpio.h>
+
+#define PIXIS_GPIO_PINS 8
+
+struct px_gpio_chip {
+	struct of_mm_gpio_chip mm_gc;
+	spinlock_t lock;
+
+	/* mask for active-low pins */
+	u8 active_low;
+};
+
+static inline struct px_gpio_chip *
+to_px_gpio_chip(struct of_mm_gpio_chip *mm_gc)
+{
+	return container_of(mm_gc, struct px_gpio_chip, mm_gc);
+}
+
+static inline u8 pin2mask(unsigned int pin)
+{
+	return 1 << (PIXIS_GPIO_PINS - 1 - pin);
+}
+
+static int px_gpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct px_gpio_chip *px_gc = to_px_gpio_chip(mm_gc);
+	u8 __iomem *regs = mm_gc->regs;
+
+	return (in_8(regs) ^ px_gc->active_low) & pin2mask(gpio);
+}
+
+static void px_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct px_gpio_chip *px_gc = to_px_gpio_chip(mm_gc);
+	u8 __iomem *regs = mm_gc->regs;
+	unsigned long flags;
+	u8 val_mask = val ? pin2mask(gpio) : 0;
+
+	spin_lock_irqsave(&px_gc->lock, flags);
+
+	if ((val_mask ^ px_gc->active_low) & pin2mask(gpio))
+		setbits8(regs, pin2mask(gpio));
+	else
+		clrbits8(regs, pin2mask(gpio));
+
+	spin_unlock_irqrestore(&px_gc->lock, flags);
+}
+
+static int px_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	return 0;
+}
+
+static int px_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	px_gpio_set(gc, gpio, val);
+	return 0;
+}
+
+#define PX_GPIO_FLAG_ACTIVE_LOW	(1 << 0)
+
+int px_gpio_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
+		  const void *gpio_spec)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(&of_gc->gc);
+	struct px_gpio_chip *px_gc = to_px_gpio_chip(mm_gc);
+	const u32 *gpio = gpio_spec;
+
+	if (*gpio > of_gc->gc.ngpio)
+		return -EINVAL;
+
+	if (gpio[1] & PX_GPIO_FLAG_ACTIVE_LOW)
+		px_gc->active_low |= pin2mask(*gpio);
+
+	return *gpio;
+}
+
+static int __init pixis_gpio_init(void)
+{
+	struct device_node *np;
+
+	for_each_compatible_node(np, NULL, "fsl,fpga-pixis-gpio-bank") {
+		int ret;
+		struct px_gpio_chip *px_gc;
+		struct of_mm_gpio_chip *mm_gc;
+		struct of_gpio_chip *of_gc;
+		struct gpio_chip *gc;
+
+		px_gc = kzalloc(sizeof(*px_gc), GFP_KERNEL);
+		if (!px_gc) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		spin_lock_init(&px_gc->lock);
+
+		mm_gc = &px_gc->mm_gc;
+		of_gc = &mm_gc->of_gc;
+		gc = &of_gc->gc;
+
+		of_gc->gpio_cells = 2;
+		of_gc->xlate = px_gpio_xlate;
+		gc->ngpio = PIXIS_GPIO_PINS;
+		gc->direction_input = px_gpio_dir_in;
+		gc->direction_output = px_gpio_dir_out;
+		gc->get = px_gpio_get;
+		gc->set = px_gpio_set;
+
+		ret = of_mm_gpiochip_add(np, mm_gc);
+		if (ret)
+			goto err;
+		continue;
+err:
+		pr_err("%s: registration failed with status %d\n",
+		       np->full_name, ret);
+		kfree(px_gc);
+		/* try others anyway */
+	}
+	return 0;
+}
+arch_initcall(pixis_gpio_init);
