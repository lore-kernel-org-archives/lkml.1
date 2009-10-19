Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZJSHha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZJSHha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZJSHh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:37:29 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35565 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZJSHh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:37:28 -0400
Date: Mon, 19 Oct 2009 09:37:28 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091019073728.GC28832@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
 <20091018072738.GF3935@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018072738.GF3935@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 12:27:39AM -0700, Dmitry Torokhov wrote:
> On Fri, Oct 16, 2009 at 03:03:15PM +0200, Daniel Mack wrote:
> >  
> > +#ifdef CONFIG_LEDS_ALIX2_BUTTON
> > +static void alix_button_poll(struct input_polled_dev *ipdev)
> > +{
> > +	unsigned int val = !(inl(gpio_base + 0x30) & (1 << 1));
> > +
> > +	if (val == alix_button_last)
> > +		return;
> 
> You can probably let input core filter out duplicate events...
> > +
> > +	input_report_key(ipdev->input, BTN_MISC, val);
> 
> BTN_MISC is expected to be used by joysticks or poniting devices, I'd
> recomment KEY_PROG1 for a key.
> 
> > +	input_sync(ipdev->input);
> > +	alix_button_last = val;
> > +}
> > +#endif
> > +
> >  static int __init alix_led_probe(struct platform_device *pdev)
> >  {
> >  	int i;
> > @@ -89,6 +110,35 @@ static int __init alix_led_probe(struct platform_device *pdev)
> >  		if (ret < 0)
> >  			goto fail;
> >  	}
> > +
> > +#ifdef CONFIG_LEDS_ALIX2_BUTTON
> > +	/* enable button input */
> > +	outl(1 << 1, gpio_base + 0x20);
> > +
> > +	/* enable pullup on input pin */
> > +	outl(1 << 1, gpio_base + 0x18);
> > +
> > +	alix_button_last = 0;
> > +	ipdev = input_allocate_polled_device();
> > +	if (!ipdev)
> > +		goto fail;
> > +
> > +	ipdev->poll = alix_button_poll;
> > +	ipdev->poll_interval = POLL_INTERVAL_DEFAULT;
> > +	ipdev->input->name = "ALIX2 button";
> > +	ipdev->input->phys = "alix2/input0";
> > +	ipdev->input->id.bustype = BUS_HOST;
> > +
> > +	set_bit(EV_KEY, ipdev->input->evbit);
> > +        ipdev->input->keybit[BIT_WORD(BTN_MISC)] = BIT_MASK(BTN_MISC);
> > +
> > +	ret = input_register_polled_device(ipdev);
> > +	if (ret) {
> > +		input_free_polled_device(ipdev);
> > +		goto fail;
> > +	}
> > +#endif
> 
> Fells like you want to make it a function (and a stub if not
> configured)...

Agreed in all points - new version below.

Thanks,
Daniel


>From 3095491476facc28f4cc639e7e44227c38ec0f8f Mon Sep 17 00:00:00 2001
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
 drivers/leds/Kconfig      |   14 ++++++++++
 drivers/leds/leds-alix2.c |   59 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e4f599f..2faba0a 100644
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
+	  modification to the hardware: R1 needs to be removed, and R4 needs
+	  to be placed as 100 KOhms pull-up.
+	  
+	  Only select that option if you modified your ALIX board like this.
+
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
 	depends on LEDS_CLASS && ARCH_H1940
diff --git a/drivers/leds/leds-alix2.c b/drivers/leds/leds-alix2.c
index f59ffad..5788767 100644
--- a/drivers/leds/leds-alix2.c
+++ b/drivers/leds/leds-alix2.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/string.h>
 #include <linux/pci.h>
+#include <linux/input-polldev.h>
 
 static int force = 0;
 module_param(force, bool, 0444);
@@ -78,6 +79,55 @@ static struct alix_led alix_leds[] = {
 	},
 };
 
+#ifdef CONFIG_LEDS_ALIX2_BUTTON
+
+#define POLL_INTERVAL_DEFAULT 250
+static struct input_polled_dev *ipdev;
+
+static void alix_button_poll(struct input_polled_dev *ipdev)
+{
+	unsigned int val = !(inl(gpio_base + 0x30) & (1 << 1));
+
+	input_report_key(ipdev->input, KEY_PROG1, val);
+	input_sync(ipdev->input);
+}
+
+static int alix_button_register(void)
+{
+	int ret;
+
+	/* enable button input */
+	outl(1 << 1, gpio_base + 0x20);
+
+	/* enable pullup on input pin */
+	outl(1 << 1, gpio_base + 0x18);
+
+	ipdev = input_allocate_polled_device();
+	if (!ipdev)
+		return -ENOMEM;
+
+	ipdev->poll = alix_button_poll;
+	ipdev->poll_interval = POLL_INTERVAL_DEFAULT;
+	ipdev->input->name = "ALIX2 button";
+	ipdev->input->phys = "alix2/input0";
+	ipdev->input->id.bustype = BUS_HOST;
+
+	set_bit(EV_KEY, ipdev->input->evbit);
+	ipdev->input->keybit[BIT_WORD(KEY_PROG1)] = BIT_MASK(KEY_PROG1);
+
+	ret = input_register_polled_device(ipdev);
+	
+	if (ret) {
+		input_free_polled_device(ipdev);
+		ipdev = NULL;
+	}
+
+	return ret;
+}
+#else
+#define alix_button_register() (0)
+#endif
+
 static int __init alix_led_probe(struct platform_device *pdev)
 {
 	int i;
@@ -89,6 +139,11 @@ static int __init alix_led_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto fail;
 	}
+
+	ret = alix_button_register();
+	if (ret) 
+		goto fail;
+
 	return 0;
 
 fail:
@@ -103,6 +158,10 @@ static int alix_led_remove(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_unregister(&alix_leds[i].cdev);
+	
+	if (ipdev)
+		input_unregister_polled_device(ipdev);
+	
 	return 0;
 }
 
-- 
1.6.0.4

