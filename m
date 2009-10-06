Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZJGVXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZJGVXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZJGVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:23:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56111 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZJGVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:23:49 -0400
Date: Tue, 6 Oct 2009 22:09:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>, Andrew Morton <akpm@osdl.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Stanislav Brabec <utx@penguin.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: spitz: add gpio button support (fixes regression)
Message-ID: <20091006200933.GA1606@ucw.cz>
References: <20091006074635.GA2775@ucw.cz> <1254829732.3546.35.camel@utx.utx.cz> <20091007085806.GB28807@elf.ucw.cz> <1254914991.4213.80.camel@hammer.suse.cz> <20091007120643.GA17069@rakim.wolfsonmicro.main> <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So what's the conclusion of the patch? Any ACK/NAK or patch needs updating?

Please take this updated version.

---

Spitz switched to generic matrix-gpio keyboard driver in 2.6.32-rc0,
but that means that support for power button and lid switches was
lost. This restores it, using button-gpio code.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/arch/arm.ofic/mach-pxa/spitz.c	2009-10-06 13:48:07.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/spitz.c	2009-10-06 21:17:19.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <linux/gpio_keys.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/mtd/physmap.h>
@@ -375,6 +377,51 @@
 };
 
 
+static struct gpio_keys_button spitz_gpio_keys[] = {
+	{
+		.type	= EV_KEY,
+		.code	= KEY_SUSPEND,
+		.gpio	= SPITZ_GPIO_ON_KEY,
+		.desc	= "Power button",
+		.wakeup	= 1,
+	},
+	/* Two buttons detecting the LID state */
+	{
+		.type	= EV_SW,
+		.code	= 0,
+		.gpio	= SPITZ_GPIO_SWA,
+		.desc	= "Lid SWA",
+	},
+	{
+		.type	= EV_SW,
+		.code	= 1,
+		.gpio	= SPITZ_GPIO_SWB,
+		.desc	= "Lid SWB",
+	},
+	/* This is for remote control support. Zaurus supports wired
+	   remote on headphones. */
+	{
+		.type	= EV_SW,
+		.code	= 2,
+		.gpio	= SPITZ_GPIO_AK_INT,
+		.desc	= "Wired remote (AK_INT)",
+	},
+};
+
+static struct gpio_keys_platform_data spitz_gpio_keys_platform_data = {
+	.buttons	= spitz_gpio_keys,
+	.nbuttons	= ARRAY_SIZE(spitz_gpio_keys),
+};
+
+static struct platform_device spitz_gpio_keys_device = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &spitz_gpio_keys_platform_data,
+	},
+};
+
+
 /*
  * Spitz LEDs
  */
@@ -689,6 +736,7 @@
 static struct platform_device *devices[] __initdata = {
 	&spitzscoop_device,
 	&spitzkbd_device,
+	&spitz_gpio_keys_device,
 	&spitzled_device,
 	&sharpsl_nand_device,
 	&sharpsl_rom_device,


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
