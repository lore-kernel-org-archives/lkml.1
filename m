Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbZFKSw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbZFKSw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbZFKSwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:52:51 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40529 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbZFKSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZEqEUxlRAfDiCgESevceN9wvkEwu45eEMBjQz0EKoteAByt+xhOQaRpdD3RRPOOGu4
         8BAQfgISQpRGJDfes8DGIs+KvxdKko3PV+IW3x3MBY53I3LBPLzJnWd4zX5j7iZaZHLW
         Vf+gH5Dttg0p7UkMhLKoKJwOY9qG+THXH1yjo=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090610001033.27b7f69f@mycelium.queued.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
Date: Thu, 11 Jun 2009 20:52:52 +0200
X-Google-Sender-Auth: dc2148b96f4d07f6
Message-ID: <17be05570906111152j3ecb0102qfd6f53221c7ae9f9@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the promised patch. :) I tried to solve all issues I had with
Andres' patch.



From: Tobias Mueller <Tobias_Mueller@twam.info>

Added mask to enable/disable some GPIO pins.
Added names for GPIO pins.
Added code on GPIO initialisation to disable output/input aux functions.

Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
---
diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 5613889..8a0b290 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -18,6 +18,11 @@

 #define DRV_NAME "cs5535-gpio"
 #define GPIO_BAR 1
+#define GPIO_DEFAULT_MASK 0x0B003C66
+
+static ulong mask = GPIO_DEFAULT_MASK;
+module_param_named(mask, mask, ulong, 0444);
+MODULE_PARM_DESC(mask, "GPIO channel mask.");

 static struct cs5535_gpio_chip {
 	struct gpio_chip chip;
@@ -102,6 +107,38 @@ EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
  * Generic gpio_chip API support.
  */

+static int chip_gpio_request(struct gpio_chip *c, unsigned offset)
+{
+	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+
+	/* check if this pin is available */
+	if ((mask & (1 << offset)) == 0) {
+		printk(KERN_INFO DRV_NAME
+		       ": pin %u is not available (check mask)\n", offset);
+		return -EINVAL;
+	}
+
+	/* disable output aux 1 & 2 on this pin */
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX1);
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX2);
+
+	/* disable input aux 1 on this pin */
+	__cs5535_gpio_clear(chip, offset, GPIO_INPUT_AUX1);
+
+	/* disable output */
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
+
+	/* enable input */
+	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
+
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
@@ -145,19 +182,34 @@ static int chip_direction_output(struct
gpio_chip *c, unsigned offset, int val)
 	return 0;
 }

+static char *cs5535_gpio_names[] = {
+	"GPIO0", "GPIO1", "GPIO2", "GPIO3",
+	"GPIO4", "GPIO5", "GPIO6", "GPIO7",
+	"GPIO8", "GPIO9", "GPIO10", "GPIO11",
+	"GPIO12", "GPIO13", "GPIO14", "GPIO15",
+	"GPIO16", "GPIO17", "GPIO18", "GPIO19",
+	"GPIO20", "GPIO21", "GPIO22", NULL,
+	"GPIO24", "GPIO25", "GPIO26", "GPIO27",
+	"GPIO28", NULL, NULL, NULL,
+};
+
 static struct cs5535_gpio_chip cs5535_gpio_chip = {
 	.chip = {
 		.owner = THIS_MODULE,
 		.label = DRV_NAME,

 		.base = 0,
-		.ngpio = 28,
+		.ngpio = 32,
+		.names = cs5535_gpio_names,
+
+		.request = chip_gpio_request,

 		.get = chip_gpio_get,
 		.set = chip_gpio_set,

 		.direction_input = chip_direction_input,
 		.direction_output = chip_direction_output,
+
 	},
 };

@@ -165,6 +217,7 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 		const struct pci_device_id *pci_id)
 {
 	int err;
+	ulong mask_orig = mask;

 	/* There are two ways to get the GPIO base address; one is by
 	 * fetching it from MSR_LBAR_GPIO, the other is by reading the
@@ -193,6 +246,18 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
 			(unsigned long long) cs5535_gpio_chip.base);

+	/* mask out reserved pins */
+	mask &= 0x1F7FFFFF;
+
+	/* do not allow pin 28, Power Button, as there's special handling
+	 * in the PMC needed. (note 12, p. 48) */
+	mask &= ~(1 << 28);
+
+	if (mask_orig != mask)
+		printk(KERN_INFO DRV_NAME
+		       ": mask changed from 0x%08lX to 0x%08lX\n",
+		       mask_orig, mask);
+
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs5535_gpio_chip.chip);
 	if (err) {
