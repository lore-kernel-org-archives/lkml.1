Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZHRIc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZHRIc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZHRIc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:32:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:22155 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZHRIc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=crU0/LC1SwqkujkMqv5E2zVNGCu8k70RKbD9KuB3rJcsnay5Vbj25hG5NDSq0qGV67
         Z1xYQJGpghSarNdshPWDNGHvBET4i2P5uPHxn/oqhog0QZBkYuCJWP+wyPmuJ1yfgPYM
         bxXJMOE+on5dCYsCmqE0BrPti0gvsFgLxHIRk=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090818004325.2c44e3ee@mycelium.queued.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	 <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
	 <20090611172850.6c418b1d@mycelium.queued.net>
	 <200907011532.34677.david-b@pacbell.net>
	 <17be05570908150359t2cfafac3if43a2dc55a1a7195@mail.gmail.com>
	 <20090818004325.2c44e3ee@mycelium.queued.net>
Date: Tue, 18 Aug 2009 10:32:27 +0200
X-Google-Sender-Auth: ad1003798eb69cef
Message-ID: <17be05570908180132t49952fa3q3a3bf332133e26f@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: David Brownell <david-b@pacbell.net>, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>, deepak@laptop.org,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       linux-geode@lists.infradead.org, jordan@cosmicpenguin.net,
       cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/18 Andres Salomon <dilinger@collabora.co.uk>:
> Hi Tobias,
>
> At this point, I've lost track of all the changes that need to be
> made.  Would you mind submitting your current patch w/ all of the
> updates we talked about, and we can go from there?  If possible, it'd
> be nice to get the cs5535-gpio stuff into the next merge window (but
> we'd need to get moving on this now in order to do that).

cs5535: request function, mask & names added

Changed number of gpio pins to 32 (according to datasheet)
Added mask to disable some pins
Added gpio_request for checking mask and disabling special pin functions
Added pin names

Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>

---
 drivers/gpio/cs5535-gpio.c |   86 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 5613889..d50a0bf 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -19,6 +19,29 @@
 #define DRV_NAME "cs5535-gpio"
 #define GPIO_BAR 1

+/*
+ * Some GPIO pins
+ *  31-29,23 : reserved (always mask out)
+ *  28       : Power Button
+ *  26       : PME#
+ *  22-16    : LPC
+ *  14,15    : SMBus
+ *  9,8      : UART1
+ *  7        : PCI INTB
+ *  3,4      : UART2/DDC
+ *  2        : IDE_IRQ0
+ *  1        : AC_BEEP
+ *  0        : PCI INTA
+ *
+ * If a mask was not specified, allow all except
+ * reserved and Power Button
+ */
+#define GPIO_DEFAULT_MASK 0x0F7FFFFF
+
+static ulong mask = GPIO_DEFAULT_MASK;
+module_param_named(mask, mask, ulong, 0444);
+MODULE_PARM_DESC(mask, "GPIO channel mask.");
+
 static struct cs5535_gpio_chip {
 	struct gpio_chip chip;
 	resource_size_t base;
@@ -102,6 +125,39 @@ EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
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
+		spin_unlock_irqrestore(&chip->lock, flags);
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
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
@@ -145,19 +201,34 @@ static int chip_direction_output(struct
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

@@ -165,6 +236,7 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 		const struct pci_device_id *pci_id)
 {
 	int err;
+	ulong mask_orig = mask;

 	/* There are two ways to get the GPIO base address; one is by
 	 * fetching it from MSR_LBAR_GPIO, the other is by reading the
@@ -193,6 +265,18 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
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
-- 
1.6.4
