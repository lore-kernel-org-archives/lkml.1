Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbZJPND7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbZJPND7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbZJPND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:03:58 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34381 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbZJPND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:03:57 -0400
Date: Fri, 16 Oct 2009 15:03:15 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       Constantin Baranov <const@mimas.ru>
Subject: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091016130315.GT28832@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for a project I was working on, we used the J15 connector of the ALIX.2D
board (which is connected to a GPIO of the CS5536 Geode companion chip)
for an external button switch.

I thought it might be worth sharing this piece of code, so others can do
the same.

There is, however, a small hardware modification is necessary as the pin
is also shared as buzzer output. I noted that in the Kconfig entry.

The patch should go thru Richard's led-2.6.git as it depends on another
one that has been queued there already.

Thanks,
Daniel

>From fd5915cf86c659eac67a8c0ea4379a78efbe2231 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Tue, 13 Oct 2009 12:42:52 +0800
Subject: [PATCH] leds-alix2: add support for button connected to J15

The ALIX2 boards have one GPIO pin which is reachable at connector J15.
One possible application for this feature is to connect a button which
closes the two pins.

This patch adds support to query these button and export its state via
an input device.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-input@vger.kernel.org
Cc: Constantin Baranov <const@mimas.ru>
---
 drivers/leds/Kconfig      |   14 ++++++++++++
 drivers/leds/leds-alix2.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e4f599f..7e57bba 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -77,6 +77,20 @@ config LEDS_ALIX2
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
 	  You have to set leds-alix2.force=1 for boards with Award BIOS.
 
+config LEDS_ALIX2_BUTTON
+	bool "Input device support for button on ALIX boards"
+	depends on LEDS_ALIX2 && INPUT
+	select INPUT_POLLDEV
+	help
+	  This option enables support for a button connected to J15 of ALIX
+	  boards.
+	  
+	  Note that for this feature to work, there is need for a minor
+	  modification to the hardware. R1 needs to be removed, and R4 needs
+	  to be places as 100KOhms pull-up.
+	  
+	  Only select that option if you modified your ALIX board like this.
+
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
 	depends on LEDS_CLASS && ARCH_H1940
diff --git a/drivers/leds/leds-alix2.c b/drivers/leds/leds-alix2.c
index f59ffad..e41b252 100644
--- a/drivers/leds/leds-alix2.c
+++ b/drivers/leds/leds-alix2.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/string.h>
 #include <linux/pci.h>
+#include <linux/input-polldev.h>
 
 static int force = 0;
 module_param(force, bool, 0444);
@@ -29,6 +30,12 @@ static struct pci_device_id divil_pci[] = {
 };
 MODULE_DEVICE_TABLE(pci, divil_pci);
 
+#ifdef CONFIG_LEDS_ALIX2_BUTTON
+static struct input_polled_dev *ipdev;
+static int alix_button_last;
+#define POLL_INTERVAL_DEFAULT 250
+#endif
+
 struct alix_led {
 	struct led_classdev cdev;
 	unsigned short port;
@@ -78,6 +85,20 @@ static struct alix_led alix_leds[] = {
 	},
 };
 
+#ifdef CONFIG_LEDS_ALIX2_BUTTON
+static void alix_button_poll(struct input_polled_dev *ipdev)
+{
+	unsigned int val = !(inl(gpio_base + 0x30) & (1 << 1));
+
+	if (val == alix_button_last)
+		return;
+
+	input_report_key(ipdev->input, BTN_MISC, val);
+	input_sync(ipdev->input);
+	alix_button_last = val;
+}
+#endif
+
 static int __init alix_led_probe(struct platform_device *pdev)
 {
 	int i;
@@ -89,6 +110,35 @@ static int __init alix_led_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto fail;
 	}
+
+#ifdef CONFIG_LEDS_ALIX2_BUTTON
+	/* enable button input */
+	outl(1 << 1, gpio_base + 0x20);
+
+	/* enable pullup on input pin */
+	outl(1 << 1, gpio_base + 0x18);
+
+	alix_button_last = 0;
+	ipdev = input_allocate_polled_device();
+	if (!ipdev)
+		goto fail;
+
+	ipdev->poll = alix_button_poll;
+	ipdev->poll_interval = POLL_INTERVAL_DEFAULT;
+	ipdev->input->name = "ALIX2 button";
+	ipdev->input->phys = "alix2/input0";
+	ipdev->input->id.bustype = BUS_HOST;
+
+	set_bit(EV_KEY, ipdev->input->evbit);
+        ipdev->input->keybit[BIT_WORD(BTN_MISC)] = BIT_MASK(BTN_MISC);
+
+	ret = input_register_polled_device(ipdev);
+	if (ret) {
+		input_free_polled_device(ipdev);
+		goto fail;
+	}
+#endif
+
 	return 0;
 
 fail:
-- 
1.6.0.4

