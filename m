Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYGYQs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYGYQs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYGYQsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:48:19 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:6203 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751021AbYGYQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:48:18 -0400
Date: Fri, 25 Jul 2008 20:48:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [RFC PATCH] of_gpio: implement of_get_gpio_flags()
Message-ID: <20080725164815.GA23228@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp> <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp> <20080718100549.GA28741@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp> <20080721175357.GA1773@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807211340460.26456@t2.domain.actdsltmp> <20080723145650.GA13792@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807231551230.26456@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807231551230.26456@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is alike to the of_get_gpio(), but accepts new argument:
flags. Now the of_get_gpio() call is a wrapper around of_get_gpio_flags().

This new function will be used by the drivers that need to retrive GPIO
information, such as active-low flag.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Wed, Jul 23, 2008 at 04:42:24PM -0700, Trent Piepho wrote:
> On Wed, 23 Jul 2008, Anton Vorontsov wrote:
> > On Mon, Jul 21, 2008 at 02:12:20PM -0700, Trent Piepho wrote:
> >> On Mon, 21 Jul 2008, Anton Vorontsov wrote:
> >>> On Sat, Jul 19, 2008 at 02:08:01PM -0700, Trent Piepho wrote:
> >>>> It doesn't look like you have any way to unset the active low flag.  What if
> >>>> I unload the leds-gpio driver (or another gpio user) and then try to use the
> >>>> gpio with something else?  The active low flag is stuck on!
> >>>
> >>> Why would you want to unset the flags? It is specified in the device
> >>> tree, and can't be changed. Specifying different flags for the same GPIO
> >>> would be an error (plus, Linux forbids shared gpios, so you simply can't
> >>> specify one gpio for several devices).
> >>
> >> You can't use the same gpio for two different things at the same time, but you
> >> can load a driver, unload it, and then load another.
> >
> > Hm.. yeah, this might happen. Now I tend to think that transparent
> > active-low handling wasn't that good idea after all. So, something like
> > of_gpio_is_active_low(device_node, gpioidx) should be implemented
> > instead. This function will parse the gpio's = <> flags. Please speak up
> > if you have any better ideas though.
> 
> The flags could be provided via of_get_gpio.  E.g., something like
> of_get_gpio(...., u32 *flags), and if flags is non-NULL the gpio flags are
> left there.  of_get_gpio already has the flags and some other of_get_*
> functions return multiple things like this.

Good idea, thanks. This patch implements of_get_gpio_flags() in addition
to of_get_gpio() (since we don't want to break existing users).

The name seems a bit unfortunate though, because one could read the
function as it gets gpio flags only (though, we might implement
this instead, but this way average driver will end up with parsing
gpios = <> twice).

of_get_gpio_wflags() would be better. Or maybe leave it as is, since
it is documented anyway. ;-)

> Or just have an active low property for the led:
>  	led.active_low = !!of_get_property(np, "active-low", NULL);
> 
> Pretty simple, just one line of code.  At least if one looks just at
> leds-gpio, that's obviously the simplest way.  Is active low a property of
> the led or a property of the gpio?  I guess one could argue either way.

As I said previously, I'm not against this as a temporary solution.
Because we can always deprecate the active-low property later, in a
backward compatible way.

See http://ozlabs.org/pipermail/linuxppc-dev/2008-April/055202.html

So, assuming that the of_get_gpio_flags() will appear only in 2.6.28,
I'm fine with explicit active-low property for now.

> It seems like putting one line of code leds-gpio driver is better than
> putting much more complex code into the gpio controller driver.  And each
> gpio controller has to have that code too.
> 
> Now you could say that each gpio user needing to support inverting gpios is
> a lot of code too,
[...]

Quite the reverse, actually. ;-) I tend to agree. With this patch
every gpio controller will able to parse flags, w/o single line
added. So this approach is obviously better.

Plus, with transparent active-low handling, most drivers will end up
with checking active-low twice, because most drivers are doing if
(active_low) already.

Thanks.

 drivers/of/gpio.c       |   35 ++++++++++++++++++++++++++++-------
 include/linux/of_gpio.h |   38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 1c9cab8..5be67dd 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -19,14 +19,16 @@
 #include <asm/prom.h>
 
 /**
- * of_get_gpio - Get a GPIO number from the device tree to use with GPIO API
+ * of_get_gpio - Get a GPIO number and flags to use with GPIO API
  * @np:		device node to get GPIO from
  * @index:	index of the GPIO
+ * @flags:	a flags pointer to fill in
  *
  * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
- * value on the error condition.
+ * value on the error condition. This function also will fill in the flags.
  */
-int of_get_gpio(struct device_node *np, int index)
+int of_get_gpio_flags(struct device_node *np, int index,
+		      enum of_gpio_flags *flags)
 {
 	int ret = -EINVAL;
 	struct device_node *gc;
@@ -102,7 +104,11 @@ int of_get_gpio(struct device_node *np, int index)
 		goto err0;
 	}
 
-	ret = of_gc->xlate(of_gc, np, gpio_spec);
+	/* .xlate might decide to not fill in the flags, so clear it here */
+	if (flags)
+		*flags = 0;
+
+	ret = of_gc->xlate(of_gc, np, gpio_spec, flags);
 	if (ret < 0)
 		goto err1;
 
@@ -113,26 +119,41 @@ err0:
 	pr_debug("%s exited with status %d\n", __func__, ret);
 	return ret;
 }
-EXPORT_SYMBOL(of_get_gpio);
+EXPORT_SYMBOL(of_get_gpio_flags);
 
 /**
- * of_gpio_simple_xlate - translate gpio_spec to the GPIO number
+ * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @of_gc:	pointer to the of_gpio_chip structure
  * @np:		device node of the GPIO chip
  * @gpio_spec:	gpio specifier as found in the device tree
+ * @flags:	a flags pointer to fill in
  *
  * This is simple translation function, suitable for the most 1:1 mapped
  * gpio chips. This function performs only one sanity check: whether gpio
  * is less than ngpios (that is specified in the gpio_chip).
  */
 int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
-			 const void *gpio_spec)
+			 const void *gpio_spec, enum of_gpio_flags *flags)
 {
 	const u32 *gpio = gpio_spec;
 
+	/*
+	 * We're discouraging gpio_cells < 2, since this way you'll have to
+	 * write your own xlate function, which will retrive the GPIO number
+	 * and its flags from a single gpio cell. This is possible, but not
+	 * recommended.
+	 */
+	if (of_gc->gpio_cells < 2) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	if (*gpio > of_gc->gc.ngpio)
 		return -EINVAL;
 
+	if (flags)
+		*flags = gpio[1];
+
 	return *gpio;
 }
 EXPORT_SYMBOL(of_gpio_simple_xlate);
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 67db101..8dc9bcb 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -14,19 +14,32 @@
 #ifndef __LINUX_OF_GPIO_H
 #define __LINUX_OF_GPIO_H
 
+#include <linux/compiler.h>
+#include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 
+struct device_node;
+
 #ifdef CONFIG_OF_GPIO
 
 /*
+ * This is Linux-specific flags. By default controllers' and Linux' mapping
+ * match, but GPIO controllers are free to translate their own flags to
+ * Linux-specific in their .xlate callback. Though, 1:1 mapping is recommended.
+ */
+enum of_gpio_flags {
+	OF_GPIO_ACTIVE_LOW = 0x1,
+};
+
+/*
  * Generic OF GPIO chip
  */
 struct of_gpio_chip {
 	struct gpio_chip gc;
 	int gpio_cells;
 	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
-		     const void *gpio_spec);
+		     const void *gpio_spec, enum of_gpio_flags *flags);
 };
 
 static inline struct of_gpio_chip *to_of_gpio_chip(struct gpio_chip *gc)
@@ -50,20 +63,37 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 	return container_of(of_gc, struct of_mm_gpio_chip, of_gc);
 }
 
-extern int of_get_gpio(struct device_node *np, int index);
+extern int of_get_gpio_flags(struct device_node *np, int index,
+			     enum of_gpio_flags *flags);
+
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 extern int of_gpio_simple_xlate(struct of_gpio_chip *of_gc,
 				struct device_node *np,
-				const void *gpio_spec);
+				const void *gpio_spec,
+				enum of_gpio_flags *flags);
 #else
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
-static inline int of_get_gpio(struct device_node *np, int index)
+static inline int of_get_gpio_flags(struct device_node *np, int index,
+				    enum of_gpio_flags *flags)
 {
 	return -ENOSYS;
 }
 
 #endif /* CONFIG_OF_GPIO */
 
+/**
+ * of_get_gpio - Get a GPIO number to use with GPIO API
+ * @np:		device node to get GPIO from
+ * @index:	index of the GPIO
+ *
+ * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
+ * value on the error condition.
+ */
+static inline int of_get_gpio(struct device_node *np, int index)
+{
+	return of_get_gpio_flags(np, index, NULL);
+}
+
 #endif /* __LINUX_OF_GPIO_H */
-- 
1.5.5.4

