Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbZHRVxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbZHRVxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZHRVxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:53:38 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:35602 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZHRVxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:53:37 -0400
Date: Tue, 18 Aug 2009 17:53:32 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, cjb@laptop.org,
       deepak@laptop.org, linux-geode@lists.infradead.org,
       Jordan Crouse <jordan@cosmicpenguin.net>, Tobias_Mueller@twam.info
Subject: [PATCH 2/3] cs5535-gpio: request function, mask & names added
Message-ID: <20090818175332.254e026f@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?utf-8?q?Tobias=20M=C3=BCller?= <Tobias_Mueller@twam.info>

Changed number of gpio pins to 32 (according to datasheet)
Added mask to disable some pins
Added gpio_request for checking mask and disabling special pin functions
Added pin names

Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/gpio/cs5535-gpio.c |   78 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 5613889..ec1f0e8 100644
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
@@ -102,6 +125,33 @@ EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
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
+			": pin %u is not available (check mask)\n", offset);
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
@@ -145,13 +195,26 @@ static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
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
+		.request = chip_gpio_request,
 
 		.get = chip_gpio_get,
 		.set = chip_gpio_set,
@@ -165,6 +228,7 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
 		const struct pci_device_id *pci_id)
 {
 	int err;
+	ulong mask_orig = mask;
 
 	/* There are two ways to get the GPIO base address; one is by
 	 * fetching it from MSR_LBAR_GPIO, the other is by reading the
@@ -193,6 +257,18 @@ static int __init cs5535_gpio_probe(struct pci_dev *pdev,
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
+				": mask changed from 0x%08lX to 0x%08lX\n",
+				mask_orig, mask);
+
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs5535_gpio_chip.chip);
 	if (err) {
-- 
1.6.3.3

