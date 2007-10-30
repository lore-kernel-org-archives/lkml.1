Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXJ3Bz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXJ3Bz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXJ3BzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:55:19 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39828 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752552AbXJ3BzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:55:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=fGSMwlSzUcdMB2PZU/bB6aelq768Ywb5UKa8C3ISYZvsM5XGLAbg4Vu+v1yN+NUcOz/RJ1WSVOg0Hdb5kOWO6GA9b4XqSgjE0McK0a3pKWuyZ9A/nrDyPvY2uouCqG8BVQKNE14e5MsFlY84nKLR+1xeaLUBnV9eaDVWcqjpAi8=  ;
X-YMail-OSG: bXbROCAVM1mj.OTTA9euDX.VbgkaBiQTm_c3TvZMfAbQiaJYX7EFMQhY36kZAcUJqnh28eokJg--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Date: Mon, 29 Oct 2007 18:51:48 -0700
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
Message-Id: <200710291851.49057.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new-style I2C driver for some common 8 and 16 bit I2C based
GPIO expanders:  pcf8574 and pcf8575.  Since it's a new-style driver,
it's configured as part of board-specific init ... eliminating the
need for error-prone manual configuration of module parameters.

The driver exposes the GPIO signals using the platform-neutral GPIO
programming interface, so they are easily accessed by other kernel
code.  The lack of such a flexible kernel API is what has ensured
the proliferation of board-specific hacks for these chips... stuff
that rarely makes it upstream since it's so ugly.  This driver will
let such board-specific code use standard GPIO calls.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Note that there's currently a drivers/i2c/chips/pcf8574.c driver.

Key differences include:  this one talks to other kernel code so
it can use the GPIOs "normally", but that one talks to userspace
through sysfs.  Also, this one is a "new style" I2C driver, so it's
smaller and doesn't need all those error-prone module parameters.
Plus, this one handles both 8 and 16 bit chip versions.

 drivers/i2c/chips/Kconfig   |   18 ++
 drivers/i2c/chips/Makefile  |    1 
 drivers/i2c/chips/pcf857x.c |  309 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pcf857x.h     |   43 ++++++
 4 files changed, 371 insertions(+)

--- a/drivers/i2c/chips/Kconfig	2007-10-28 21:04:06.000000000 -0700
+++ b/drivers/i2c/chips/Kconfig	2007-10-29 14:16:01.000000000 -0700
@@ -51,6 +51,24 @@ config SENSORS_EEPROM
 	  This driver can also be built as a module.  If so, the module
 	  will be called eeprom.
 
+config GPIO_PCF857X
+	tristate "PCF875x GPIO expanders"
+	depends on GPIO_LIB
+	help
+	  Say yes here to provide access to some I2C GPIO expanders which
+	  may be used for additional digital outputs or inputs:
+
+	    - pcf8574, pcf8574a ... 8 bits, from NXP or TI
+	    - pcf8575, pcf8575c ... 16 bits, from NXP or TI
+
+	  Your board setup code will need to declare the expanders in
+	  use, and assign numbers to the GPIOs they expose.  Those GPIOs
+	  can then be used from drivers and other kernel code, just like
+	  other GPIOs, but only accessible from task contexts.
+
+	  This driver provides only an in-kernel interface to those GPIOs.
+	  Any sysfs interface to userspace would be provided separately.
+
 config SENSORS_PCF8574
 	tristate "Philips PCF8574 and PCF8574A"
 	depends on EXPERIMENTAL
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/linux/pcf857x.h	2007-10-28 21:09:49.000000000 -0700
@@ -0,0 +1,43 @@
+#ifndef __LINUX_PCF857X_H
+#define __LINUX_PCF857X_H
+
+/**
+ * struct pcf857x_platform_data - data to set up pcf857x driver
+ * @gpio_base: number of the chip's first GPIO
+ * @n_latch: optional bit-inverse of initial output state
+ * @context: optional parameter passed to setup() and teardown()
+ * @setup: optional callback issued once the GPIOs are valid
+ * @teardown: optional callback issued before the GPIOs are invvalidated
+ *
+ * In addition to the I2C_BOARD_INFO() state appropriate to each chip,
+ * the i2c_board_info used with the pcf875x driver must provide the
+ * chip "type" ("pcf8574", "pcf8574a", "pcf8575", "pcf8575c") and its
+ * platform_data (pointer to one of these structures) with at least
+ * the gpio_base value initialized.
+ *
+ * The @setup callback may be used with the kind of board-specific glue
+ * which hands the (now-valid) GPIOs to other drivers, or which puts
+ * devices in their initial states using these GPIOs.
+ *
+ * Since these GPIO chips don't have conventional registers recording
+ * whether a pin is used for input or output, or an output latch to
+ * record the values being driven, the n_latch value may be used to
+ * avoid intialization glitches.  Its inverted value initializes the
+ * value into which bits are masked before they're written to the PCF
+ * chip.  That means that if it's left at zero, the chip is treated as
+ * if it came from power-up reset.
+ */
+struct pcf857x_platform_data {
+	unsigned	gpio_base;
+	unsigned	n_latch;
+
+	void		*context;
+	int		(*setup)(struct i2c_client *client,
+					int gpio, unsigned ngpio,
+					void *context);
+	int		(*teardown)(struct i2c_client *client,
+					int gpio, unsigned ngpio,
+					void *context);
+};
+
+#endif /* __LINUX_PCF857X_H */
--- a/drivers/i2c/chips/Makefile	2007-10-28 21:04:06.000000000 -0700
+++ b/drivers/i2c/chips/Makefile	2007-10-28 21:09:49.000000000 -0700
@@ -11,6 +11,7 @@ obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
 obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
 obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
+obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_SENSORS_TLV320AIC23) += tlv320aic23.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/i2c/chips/pcf857x.c	2007-10-29 14:12:21.000000000 -0700
@@ -0,0 +1,309 @@
+/*
+ * pcf857x - driver for pcf857{4,4a,5,5c} I2C GPIO expanders
+ *
+ * Copyright (C) 2007 David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/pcf857x.h>
+
+#include <asm/gpio.h>
+
+
+/*
+ * The pcf857x chips only expose a one read register and one write register.
+ * Writing a "one" bit (to match the reset state) lets that pin be used as
+ * an input; it's not an open-drain model, but it acts a bit like that.
+ *
+ * Some other I2C GPIO expander chips (like the pca9534, pca9535, pca9555,
+ * pca9539, mcp23008, and mc23017) have a more complex register model with
+ * more conventional input circuitry, often using 0x20..0x27 addresses.
+ */
+struct pcf857x {
+	struct gpio_chip	chip;
+	struct i2c_client	*client;
+	unsigned		out;		/* software latch */
+};
+
+/*-------------------------------------------------------------------------*/
+
+/* Talk to 8-bit I/O expander */
+
+static int pcf857x_input8(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+
+	gpio->out |= (1 << offset);
+	return i2c_smbus_write_byte(gpio->client, (u8) gpio->out);
+}
+
+static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	s32		value;
+
+	value = i2c_smbus_read_byte(gpio->client);
+	return (value < 0) ? 0 : !!(value & (1 << offset));
+}
+
+static int pcf857x_output8(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	unsigned	bit = 1 << offset;
+
+	if (value)
+		gpio->out |= bit;
+	else
+		gpio->out &= ~bit;
+	return i2c_smbus_write_byte(gpio->client, (u8) gpio->out);
+}
+
+static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
+{
+	pcf857x_output8(chip, offset, value);
+}
+
+/*-------------------------------------------------------------------------*/
+
+/* Talk to 16-bit I/O expander */
+
+static int i2c_write_le16(struct i2c_client *client, u16 word)
+{
+	u8 buf[2] = { word & 0xff, word >> 8, };
+	int status;
+
+	status = i2c_master_send(client, buf, 2);
+	return (status < 0) ? status : 0;
+}
+
+static int i2c_read_le16(struct i2c_client *client)
+{
+	u8 buf[2];
+	int status;
+
+	status = i2c_master_recv(client, buf, 2);
+	if (status < 0)
+		return status;
+	return (buf[1] << 8) | buf[0];
+}
+
+static int pcf857x_input16(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+
+	gpio->out |= (1 << offset);
+	return i2c_write_le16(gpio->client, (u16) gpio->out);
+}
+
+static int pcf857x_get16(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		value;
+
+	value = i2c_read_le16(gpio->client);
+	return (value < 0) ? 0 : !!(value & (1 << offset));
+}
+
+static int pcf857x_output16(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	unsigned	bit = 1 << offset;
+
+	if (value)
+		gpio->out |= bit;
+	else
+		gpio->out &= ~bit;
+	return i2c_write_le16(gpio->client, (u16) gpio->out);
+}
+
+static void pcf857x_set16(struct gpio_chip *chip, unsigned offset, int value)
+{
+	pcf857x_output16(chip, offset, value);
+}
+
+/*-------------------------------------------------------------------------*/
+
+static int pcf857x_probe(struct i2c_client *client)
+{
+	struct pcf857x_platform_data	*pdata;
+	struct pcf857x			*gpio;
+	int				status = 0;
+
+	pdata = client->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
+	/* Allocate, initialize, and register this gpio_chip. */
+	gpio = kzalloc(sizeof *gpio, GFP_KERNEL);
+	if (!gpio)
+		return -ENOMEM;
+
+	gpio->chip.base = pdata->gpio_base;
+	gpio->chip.can_sleep = 1;
+
+	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
+	 * these parts, notably for output.  It has a low-resolution
+	 * DAC instead of pin change IRQs; and its inputs can be the
+	 * result of comparators.
+	 */
+
+	/* '74a addresses are 0x38..0x3f; '74 uses 0x20..0x27 */
+	if (strcmp(client->name, "pcf8574a") == 0
+			|| strcmp(client->name, "pcf8574") == 0) {
+		gpio->chip.ngpio = 8;
+		gpio->chip.direction_input = pcf857x_input8;
+		gpio->chip.get = pcf857x_get8;
+		gpio->chip.direction_output = pcf857x_output8;
+		gpio->chip.set = pcf857x_set8;
+
+		if (!i2c_check_functionality(client->adapter,
+				I2C_FUNC_SMBUS_BYTE))
+			status = -EIO;
+
+		/* fail if there's no chip present */
+		status = i2c_smbus_read_byte(client);
+
+	/* '75/'75c addresses are 0x20..0x27, just like the '74;
+	 * the '75c doesn't have a current source pulling high.
+	 */
+	} else if (strcmp(client->name, "pcf8575c") == 0
+			|| strcmp(client->name, "pcf8575") == 0) {
+		gpio->chip.ngpio = 16;
+		gpio->chip.direction_input = pcf857x_input16;
+		gpio->chip.get = pcf857x_get16;
+		gpio->chip.direction_output = pcf857x_output16;
+		gpio->chip.set = pcf857x_set16;
+
+		if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+			status = -EIO;
+
+		/* fail if there's no chip present */
+		status = i2c_read_le16(client);
+
+	} else
+		status = -ENODEV;
+
+	if (status < 0) {
+		dev_dbg(&client->dev, "probe error %d for '%s'\n",
+				status, client->name);
+		kfree(gpio);
+		return status;
+	}
+
+	gpio->chip.label = client->name;
+
+	gpio->client = client;
+	i2c_set_clientdata(client, gpio);
+
+	/* NOTE:  these chips have strange "pseudo-bidirectional" I/O pins.
+	 * We can't actually know whether a pin is configured (a) as output
+	 * and driving the signal low, or (b) as input and reporting a low
+	 * value ... without knowing the last value written since the chip
+	 * came out of reset (if any).  We can't read the latched output.
+	 *
+	 * In short, the only reliable solution for setting up pin direction
+	 * is to do it explicitly.  The setup() method can do that.
+	 *
+	 * We use pdata->n_latch to avoid trouble.  In the typical case it's
+	 * left initialized to zero; our software copy of the "latch" then
+	 * matches the chip's reset state.  But there may be cases where a
+	 * system must drive some pins low, without transient glitching.
+	 * Handle those cases by assigning n_latch to a nonzero value.
+	 */
+	gpio->out = ~pdata->n_latch;
+
+	status = gpiochip_add(&gpio->chip);
+	if (status < 0) {
+		kfree(gpio);
+		return status;
+	}
+
+	/* NOTE: these chips can issue "some pin-changed" IRQs, which we
+	 * don't yet even try to use.  Among other issues, the relevant
+	 * genirq state isn't available to modular drivers; and most irq
+	 * methods can't be called from sleeping contexts.
+	 */
+
+	dev_info(&client->dev, "gpios %d..%d on a %s%s\n",
+			gpio->chip.base,
+			gpio->chip.base + gpio->chip.ngpio - 1,
+			client->name,
+			client->irq ? " (irq ignored)" : "");
+
+	/* Let platform code set up the GPIOs and their users.
+	 * Now is the first time anyone can use them.
+	 */
+	if (pdata->setup) {
+		status = pdata->setup(client,
+				gpio->chip.base, gpio->chip.ngpio,
+				pdata->context);
+		if (status < 0)
+			dev_dbg(&client->dev, "setup --> %d\n", status);
+	}
+
+	return 0;
+}
+
+static int pcf857x_remove(struct i2c_client *client)
+{
+	struct pcf857x_platform_data	*pdata = client->dev.platform_data;
+	struct pcf857x			*gpio = i2c_get_clientdata(client);
+	int				status = 0;
+
+	if (pdata->teardown) {
+		status = pdata->teardown(client,
+				gpio->chip.base, gpio->chip.ngpio,
+				pdata->context);
+		if (status < 0) {
+			dev_err(&client->dev, "%s --> %d\n",
+					"teardown", status);
+			return status;
+		}
+	}
+
+	status = gpiochip_remove(&gpio->chip);
+	if (status == 0)
+		kfree(gpio);
+	else
+		dev_err(&client->dev, "%s --> %d\n", "remove", status);
+	return status;
+}
+
+static struct i2c_driver pcf857x_driver = {
+	.driver = {
+		.name	= "pcf857x",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pcf857x_probe,
+	.remove	= pcf857x_remove,
+};
+
+static int __init pcf857x_init(void)
+{
+	return i2c_add_driver(&pcf857x_driver);
+}
+/* we want GPIOs to be ready at device_initcall() time */
+subsys_initcall(pcf857x_init);
+
+static void __exit pcf857x_exit(void)
+{
+	i2c_del_driver(&pcf857x_driver);
+}
+module_exit(pcf857x_exit);
+
+MODULE_LICENSE("GPL");
