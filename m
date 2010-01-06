Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180Ab0AFHKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0AFHKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324Ab0AFHKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:10:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0AFHKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:10:39 -0500
Date: Wed, 6 Jan 2010 08:10:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
Message-ID: <20100106071026.GD1382@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sharp-SL code uses strange, complex grouping of gpios for wakeups
toggling. Fortunately, it is unneeded in recent kernels (and actually
provokes WARN_ONs during resume). Remove it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/arch/arm/mach-pxa/mfp-pxa2xx.c	2009-09-10 00:13:59.000000000 +0200
+++ b/arch/arm/mach-pxa/mfp-pxa2xx.c	2009-12-29 03:16:40.000000000 +0100
@@ -34,7 +34,6 @@
 struct gpio_desc {
 	unsigned	valid		: 1;
 	unsigned	can_wakeup	: 1;
-	unsigned	keypad_gpio	: 1;
 	unsigned	dir_inverted	: 1;
 	unsigned int	mask; /* bit mask in PWER or PKWR */
 	unsigned int	mux_mask; /* bit mask of muxed gpio bits, 0 if no mux */
@@ -178,9 +177,6 @@
 	if (!d->valid)
 		return -EINVAL;
 
-	if (d->keypad_gpio)
-		return -EINVAL;
-
 	mux_taken = (PWER & d->mux_mask) & (~d->mask);
 	if (on && mux_taken)
 		return -EBUSY;
@@ -231,32 +227,6 @@
 #endif /* CONFIG_PXA25x */
 
 #ifdef CONFIG_PXA27x
-static int pxa27x_pkwr_gpio[] = {
-	13, 16, 17, 34, 36, 37, 38, 39, 90, 91, 93, 94,
-	95, 96, 97, 98, 99, 100, 101, 102
-};
-
-int keypad_set_wake(unsigned int on)
-{
-	unsigned int i, gpio, mask = 0;
-
-	if (!on) {
-		PKWR = 0;
-		return 0;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(pxa27x_pkwr_gpio); i++) {
-
-		gpio = pxa27x_pkwr_gpio[i];
-
-		if (gpio_desc[gpio].config & MFP_LPM_CAN_WAKEUP)
-			mask |= gpio_desc[gpio].mask;
-	}
-
-	PKWR = mask;
-	return 0;
-}
-
 #define PWER_WEMUX2_GPIO38	(1 << 16)
 #define PWER_WEMUX2_GPIO53	(2 << 16)
 #define PWER_WEMUX2_GPIO40	(3 << 16)
@@ -273,6 +243,12 @@
 	gpio_desc[(gpio)].mux_mask = PWER_ ## mux ## _MASK;	\
 } while (0)
 
+
+static int pxa27x_pkwr_gpio[] = {
+	13, 16, 17, 34, 36, 37, 38, 39, 90, 91, 93, 94,
+	95, 96, 97, 98, 99, 100, 101, 102
+};
+
 static void __init pxa27x_mfp_init(void)
 {
 	int i, gpio;
@@ -291,7 +267,6 @@
 	for (i = 0; i < ARRAY_SIZE(pxa27x_pkwr_gpio); i++) {
 		gpio = pxa27x_pkwr_gpio[i];
 		gpio_desc[gpio].can_wakeup = 1;
-		gpio_desc[gpio].keypad_gpio = 1;
 		gpio_desc[gpio].mask = 1 << i;
 	}
 
--- a/arch/arm/mach-pxa/pxa27x.c	2009-09-10 00:13:59.000000000 +0200
+++ b/arch/arm/mach-pxa/pxa27x.c	2009-12-29 03:13:00.000000000 +0100
@@ -323,9 +323,6 @@
 	if (gpio >= 0 && gpio < 128)
 		return gpio_set_wake(gpio, on);
 
-	if (irq == IRQ_KEYPAD)
-		return keypad_set_wake(on);
-
 	switch (irq) {
 	case IRQ_RTCAlrm:
 		mask = PWER_RTC;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
