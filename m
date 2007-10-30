Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbXJ3B4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbXJ3B4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXJ3BzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:55:23 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39859 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752744AbXJ3BzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:55:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=k1QaixVgxtm4AdXf7Pj0MB+e/kr9HDhr72LW/oD0e8+anfGQPJwUjs9obEslBV+BbPs9DogRSIt1bDxxyUVVcnk8lKd3B+n+0KsEcSVpIa3viC0xpYSeiMGsCsML8pUGwMd12TMbX0WSrFVa1sMSKQe01E/YLwFsmbFbIO24COk=  ;
X-YMail-OSG: OvlIv5QVM1nnyErS5tHg3WB4KxMSpPYeCfo3SnzSPxruWPOn
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 4/4] DaVinci EVM uses pcf857x GPIO driver
Date: Mon, 29 Oct 2007 18:54:24 -0700
User-Agent: KMail/1.9.6
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       Jean Delvare <khali@linux-fr.org>, "eric miao" <eric.y.miao@gmail.com>,
       Kevin Hilman <khilman@mvista.com>, Paul Mundt <lethal@linux-sh.org>,
       Ben Dooks <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net>
In-Reply-To: <200710291809.29936.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710291854.25032.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Declare two of the I2C GPIO expanders to the EVM board init logic, and
use them.  One hooks up to the LEDs using the leds-gpio driver; the other
exposes a switch to sysfs, and initializes the audio clocks.

Oh, and get rid of bogus warning about IDE conflicting with NOR unless
both are actually configured.

---
This is against the DaVinci tree, but this patch will apply to mainline.

 arch/arm/mach-davinci/board-evm.c |  192 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 192 insertions(+)

--- a/arch/arm/mach-davinci/board-evm.c	2007-10-28 21:03:55.000000000 -0700
+++ b/arch/arm/mach-davinci/board-evm.c	2007-10-29 13:05:40.000000000 -0700
@@ -13,6 +13,10 @@
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/pcf857x.h>
+#include <linux/leds.h>
+
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
@@ -21,6 +25,7 @@
 #include <asm/io.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
+#include <asm/gpio.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -167,6 +172,189 @@ static struct platform_device rtc_dev = 
 	.id             = -1,
 };
 
+/*----------------------------------------------------------------------*/
+
+/*
+ * I2C GPIO expanders
+ */
+
+#define PCF_Uxx_BASE(x)	((3 + (x)) * ARCH_GPIOS_PER_CHIP)
+
+
+/* U2 -- LEDs */
+
+static struct gpio_led evm_leds[] = {
+	{ .name = "DS8", .active_low = 1,
+		.default_trigger = "heartbeat", },
+	{ .name = "DS7", .active_low = 1, },
+	{ .name = "DS6", .active_low = 1, },
+	{ .name = "DS5", .active_low = 1, },
+	{ .name = "DS4", .active_low = 1, },
+	{ .name = "DS3", .active_low = 1, },
+	{ .name = "DS2", .active_low = 1,
+		.default_trigger = "mmc0", },
+	{ .name = "DS1", .active_low = 1,
+		.default_trigger = "ide-disk", },
+};
+
+static const struct gpio_led_platform_data evm_led_data = {
+	.num_leds	= ARRAY_SIZE(evm_leds),
+	.leds		= evm_leds,
+};
+
+static struct platform_device *evm_led_dev;
+
+static int
+evm_led_setup(struct i2c_client *client, int gpio, unsigned ngpio, void *c)
+{
+	struct gpio_led *leds = evm_leds;
+	int status;
+
+	while (ngpio--) {
+		leds->gpio = gpio++;
+		leds++;
+	}
+
+	/* what an extremely annoying way to be forced to handle
+	 * device unregistration ...
+	 */
+	evm_led_dev = platform_device_alloc("leds-gpio", 0);
+	platform_device_add_data(evm_led_dev,
+			&evm_led_data, sizeof evm_led_data);
+
+	evm_led_dev->dev.parent = &client->dev;
+	status = platform_device_add(evm_led_dev);
+	if (status < 0) {
+		platform_device_put(evm_led_dev);
+		evm_led_dev = NULL;
+	}
+	return status;
+}
+
+static int
+evm_led_teardown(struct i2c_client *client, int gpio, unsigned ngpio, void *c)
+{
+	if (evm_led_dev) {
+		platform_device_unregister(evm_led_dev);
+		evm_led_dev = NULL;
+	}
+	return 0;
+}
+
+static struct pcf857x_platform_data pcf_data_u2 = {
+	.gpio_base	= PCF_Uxx_BASE(0),
+	.setup		= evm_led_setup,
+	.teardown	= evm_led_teardown,
+};
+
+
+/* U18 - A/V clock generator and user switch */
+
+static int sw_gpio;
+
+static ssize_t
+sw_show(struct device *d, struct device_attribute *a, char *buf)
+{
+	char *s = gpio_get_value_cansleep(sw_gpio) ? "on\n" : "off\n";
+
+	strcpy(buf, s);
+	return strlen(s);
+}
+
+static DEVICE_ATTR(user_sw, S_IRUGO, sw_show, NULL);
+
+static int
+evm_u18_setup(struct i2c_client *client, int gpio, unsigned ngpio, void *c)
+{
+	int	status;
+
+	/* export dip switch option */
+	sw_gpio = gpio + 7;
+	status = gpio_request(sw_gpio, "user_sw");
+	if (status == 0)
+		status = gpio_direction_input(sw_gpio);
+	if (status == 0)
+		status = device_create_file(&client->dev, &dev_attr_user_sw);
+	else
+		gpio_free(sw_gpio);
+	if (status != 0)
+		sw_gpio = -EINVAL;
+
+	/* audio PLL:  48 kHz (vs 44.1 or 32), single rate (vs double) */
+	gpio_request(gpio + 3, "pll_fs2");
+	gpio_direction_output(gpio + 3, 0);
+
+	gpio_request(gpio + 2, "pll_fs1");
+	gpio_direction_output(gpio + 2, 0);
+
+	gpio_request(gpio + 1, "pll_sr");
+	gpio_direction_output(gpio + 1, 0);
+
+	return 0;
+}
+
+static int
+evm_u18_teardown(struct i2c_client *client, int gpio, unsigned ngpio, void *c)
+{
+	gpio_free(gpio + 1);
+	gpio_free(gpio + 2);
+	gpio_free(gpio + 3);
+
+	if (sw_gpio > 0) {
+		device_remove_file(&client->dev, &dev_attr_user_sw);
+		gpio_free(sw_gpio);
+	}
+	return 0;
+}
+
+static struct pcf857x_platform_data pcf_data_u18 = {
+	.gpio_base	= PCF_Uxx_BASE(1),
+	.n_latch	= (1 << 3) | (1 << 2) | (1 << 1),
+	.setup		= evm_u18_setup,
+	.teardown	= evm_u18_teardown,
+};
+
+
+/* U35 - various I/O signals used to manage USB, CF, ATA, etc */
+
+#if 0
+static struct pcf857x_platform_data pcf_data_u35 = {
+	.gpio_base = PCF_Uxx_BASE(2),
+};
+#endif
+
+/*----------------------------------------------------------------------*/
+
+static struct i2c_board_info __initdata i2c_info[] =  {
+	{
+		I2C_BOARD_INFO("pcf857x", 0x38),
+		.type		= "pcf8574a",
+		.platform_data	= &pcf_data_u2,
+	},
+	{
+		I2C_BOARD_INFO("pcf857x", 0x39),
+		.type		= "pcf8574a",
+		.platform_data	= &pcf_data_u18,
+	},
+#if 0
+/* don't clash with mach-davinci/i2c-client.c
+ * or drivers/i2c/chips/gpio_expander_davinci.c
+ * ... eventually both should vanish
+ */
+	{
+		I2C_BOARD_INFO("pcf857x", 0x3a),
+		.type		= "pcf8574a",
+		.platform_data	= &pcf_data_u35,
+	},
+#endif
+	/* ALSO:
+	 * - tvl320aic33 audio codec (0x1b)
+	 * - msp430 microcontroller (0x23)
+	 * - 24wc256 eeprom (0x50)
+	 * - tvp5146 video decoder (0x5d)
+	 */
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
 	&davinci_evm_flash_device,
 #if defined(CONFIG_FB_DAVINCI) || defined(CONFIG_FB_DAVINCI_MODULE)
@@ -189,9 +377,13 @@ static __init void davinci_evm_init(void
 	davinci_psc_init();
 
 #if defined(CONFIG_BLK_DEV_DAVINCI) || defined(CONFIG_BLK_DEV_DAVINCI_MODULE)
+#if defined(CONFIG_MTD_CFI) || defined(CONFIG_MTD_CFI_MODULE)
 	printk(KERN_WARNING "WARNING: both IDE and NOR flash are enabled, "
 	       "but share pins.\n\t Disable IDE for NOR support.\n");
 #endif
+#endif
+
+	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
 
 	platform_add_devices(davinci_evm_devices,
 			     ARRAY_SIZE(davinci_evm_devices));
