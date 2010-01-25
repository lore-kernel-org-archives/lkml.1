Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725Ab0AYSL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0AYSL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613Ab0AYSLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:11:09 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:51290 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754593Ab0AYSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:11:07 -0500
Date: Mon, 25 Jan 2010 21:11:03 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] of/gpio: Add support for two-stage registration for
 the of_gpio_chips
Message-ID: <20100125181103.GB13805@oksana.dev.rtsoft.ru>
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch there are two ways to register OF GPIO controllers:

1. Allocating the of_gpio_chip structure and passing the
   &of_gc->gc pointer to the gpiochip_add. (Can use container_of
   to convert the gpio_chip to the of_gpio_chip.)

2. Allocating and registering the gpio_chip structure separately
   from the of_gpio_chip. (Since two allocations are separate,
   container_of won't work.)

As time goes by we'll kill the first option.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |    1 +
 drivers/of/gpio.c                              |   23 +++++++++++++++++++++--
 include/linux/of_gpio.h                        |    3 ++-
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index 82a9bcb..73c7e6b 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -93,6 +93,7 @@ static int mcu_gpiochip_add(struct mcu *mcu)
 	gc->base = -1;
 	gc->set = mcu_gpio_set;
 	gc->direction_output = mcu_gpio_dir_out;
+	of_gc->chip = gc;
 	of_gc->gpio_cells = 2;
 	of_gc->xlate = of_gpio_simple_xlate;
 
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index 6eea601..12c4af0 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -70,7 +70,7 @@ int of_get_gpio_flags(struct device_node *np, int index,
 	if (ret < 0)
 		goto err1;
 
-	ret += of_gc->gc.base;
+	ret += of_gc->chip->base;
 err1:
 	of_node_put(gc);
 err0:
@@ -140,7 +140,7 @@ int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
 		return -EINVAL;
 	}
 
-	if (*gpio > of_gc->gc.ngpio)
+	if (*gpio > of_gc->chip->ngpio)
 		return -EINVAL;
 
 	if (flags)
@@ -178,6 +178,25 @@ int of_mm_gpiochip_add(struct device_node *np,
 	struct of_gpio_chip *of_gc = &mm_gc->of_gc;
 	struct gpio_chip *gc = &of_gc->gc;
 
+	/*
+	 * Currently there are two ways to register OF GPIO controllers:
+	 *
+	 * 1. Allocating the of_gpio_chip structure and passing the
+	 *    &of_gc->gc pointer to the gpiochip_add. (Can use container_of
+	 *    to convert the gpio_chip to the of_gpio_chip.)
+	 *
+	 * 2. Allocating and registering the gpio_chip structure separately
+	 *    from the of_gpio_chip. (Since two allocations are separate,
+	 *    container_of won't work.)
+	 *
+	 * As time goes by we'll kill the first option. For now just check
+	 * if it's the new-style registration or the old-style.
+	 */
+	if (!of_gc->chip)
+		of_gc->chip = gc;
+	else
+		gc = of_gc->chip;
+
 	gc->label = kstrdup(np->full_name, GFP_KERNEL);
 	if (!gc->label)
 		goto err0;
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index fc2472c..c74cb37 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -36,7 +36,8 @@ enum of_gpio_flags {
  * Generic OF GPIO chip
  */
 struct of_gpio_chip {
-	struct gpio_chip gc;
+	struct gpio_chip gc; /* legacy, don't use for a new code */
+	struct gpio_chip *chip;
 	int gpio_cells;
 	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
 		     const void *gpio_spec, enum of_gpio_flags *flags);
-- 
1.6.5.7

