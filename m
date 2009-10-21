Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZJUTdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZJUTdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZJUTdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:33:49 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39596 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZJUTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:33:47 -0400
Date: Wed, 21 Oct 2009 21:33:47 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091021193347.GL14091@buzzloop.caiaq.de>
References: <20091016130315.GT28832@buzzloop.caiaq.de>
 <20091018072738.GF3935@core.coreip.homeip.net>
 <20091019073728.GC28832@buzzloop.caiaq.de>
 <20091020013852.GC24370@core.coreip.homeip.net>
 <20091020101357.GR28832@buzzloop.caiaq.de>
 <20091021043553.GA378@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021043553.GA378@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Oct 20, 2009 at 09:35:53PM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 20, 2009 at 12:13:57PM +0200, Daniel Mack wrote:
> > +
> > +	ret = input_register_polled_device(ipdev);
> > +	
> > +	if (ret) {
> > +		input_free_polled_device(ipdev);
> > +		ipdev = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> Ah, don't be lazy ;)

Ok ok, you're right, let's do it the clean way. Agreed :)

See the one below.

Thanks!

Daniel


>From 66953e5dda7bbbc22b92541ed3a6020773c62140 Mon Sep 17 00:00:00 2001
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
 drivers/leds/Kconfig      |   14 +++++++++
 drivers/leds/leds-alix2.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

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
index f59ffad..c981edf 100644
--- a/drivers/leds/leds-alix2.c
+++ b/drivers/leds/leds-alix2.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/string.h>
 #include <linux/pci.h>
+#include <linux/input-polldev.h>
 
 static int force = 0;
 module_param(force, bool, 0444);
@@ -78,6 +79,68 @@ static struct alix_led alix_leds[] = {
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
+
+static void alix_button_unregister(void)
+{
+	if (!ipdev)
+		return;
+
+	input_unregister_polled_device(ipdev);
+	/* Yes, polled devices need to be freed */
+	input_free_polled_device(ipdev);
+	ipdev = NULL;
+}
+
+#else
+static inline int alix_button_register(void) { return 0; }
+static inline void alix_button_unregister(void) { }
+#endif
+
 static int __init alix_led_probe(struct platform_device *pdev)
 {
 	int i;
@@ -89,6 +152,11 @@ static int __init alix_led_probe(struct platform_device *pdev)
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
@@ -103,6 +171,9 @@ static int alix_led_remove(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_unregister(&alix_leds[i].cdev);
+
+	alix_button_unregister();
+
 	return 0;
 }
 
-- 
1.6.0.4

