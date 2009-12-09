Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZLILqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZLILqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZLILqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:46:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38188 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZLILqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:46:09 -0500
Date: Wed, 9 Dec 2009 12:46:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091209114607.GE22752@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
 <20091208214658.GC4164@elf.ucw.cz>
 <1260309812.27677.117.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260309812.27677.117.camel@Joe-Laptop.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-08 14:03:32, Joe Perches wrote:
> On Tue, 2009-12-08 at 22:46 +0100, Pavel Machek wrote:
> > Add GPIO support for HTC Dream.
> 
> Hi Pavel.  Thanks for this.
> 
> Maybe it'd be nicer to use pr_<level> and add
> #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
> ?

It included names of functions, anyway, so agreed. Incremental patch:

(I'll fold them all and resubmit).

diff --git a/arch/arm/mach-msm/board-dream-gpio.c b/arch/arm/mach-msm/board-dream-gpio.c
index d9201f9..221c3bd 100644
--- a/arch/arm/mach-msm/board-dream-gpio.c
+++ b/arch/arm/mach-msm/board-dream-gpio.c
@@ -30,6 +30,8 @@
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "board_trout."
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 static uint cpld_usb_h2w_sw;
 module_param_named(usb_h2w_sw, cpld_usb_h2w_sw, uint, 0);
 
@@ -83,7 +85,7 @@ static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
 	uint8_t reg_val;
 
 	if ((reg >> 1) >= ARRAY_SIZE(dream_cpld_shadow)) {
-		printk(KERN_ERR "dream_gpio_write called on input %d\n", n);
+		pr_err("called on input %d\n", n);
 		return -ENOTSUPP;
 	}
 
@@ -186,7 +188,7 @@ static void dream_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 		if (v & int_mask) {
 			writeb(v & int_mask, DREAM_CPLD_BASE + stat_reg);
-			printk(KERN_ERR "dream_gpio_irq_handler: got masked "
+			pr_err("got masked "
 			       "interrupt: %d:%02x\n", bank, v & int_mask);
 		}
 
diff --git a/arch/arm/mach-msm/generic_gpio.c b/arch/arm/mach-msm/generic_gpio.c
index 5164c77..1175ffd 100644
--- a/arch/arm/mach-msm/generic_gpio.c
+++ b/arch/arm/mach-msm/generic_gpio.c
@@ -22,6 +22,8 @@
 
 #include "gpio_chip.h"
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)
 
 struct gpio_state {
@@ -47,7 +49,7 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 
 	new_gpio_chip->state = kzalloc(size, GFP_KERNEL);
 	if (new_gpio_chip->state == NULL) {
-		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
+		pr_err("failed to allocate state\n");
 		return -ENOMEM;
 	}
 
@@ -63,7 +65,7 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 
 		new_array = kmalloc(array_size * sizeof(new_array[0]), GFP_ATOMIC);
 		if (!new_array) {
-			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
+			pr_err("failed to allocate array\n");
 			err = -ENOMEM;
 			goto failed;
 		}
@@ -81,7 +83,7 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 			goto added;
 		}
 		if (gpio_chip->end >= new_gpio_chip->start) {
-			printk(KERN_ERR "register_gpio_source %u-%u overlaps with %u-%u\n",
+			pr_err("%u-%u overlaps with %u-%u\n",
 			       new_gpio_chip->start, new_gpio_chip->end,
 			       gpio_chip->start, gpio_chip->end);
 			err = -EBUSY;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
