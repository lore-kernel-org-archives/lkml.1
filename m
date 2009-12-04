Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZLDSJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZLDSJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbZLDSJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:09:20 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59859 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbZLDSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=xYHtz3xfwCOY24MbMcs2qp4GzsHAAqI/3h6+igft4bBIbzwTXXbhwitsM5qSr9Fxsj
         PAuvYe9QPNobWl+xoSmjqYmRLsV1aZVnfjdonJc5rf7oNKxDw56lrTefm7ydGq5Y9W1O
         SW4YZvyAQlq9Ln36jS6QlSYBNKQqGDBrrp0Rg=
Message-ID: <4B19504A.9060600@gmail.com>
Date: Fri, 04 Dec 2009 23:09:14 +0500
From: "Andrey A. Porodko" <andrey.porodko@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Chaithrika U S <chaithrika@ti.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrey Porodko <panda@chelcom.ru>, Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Balaji Rao <balajirrao@openmoko.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Vipin Bhandari <vipin.bhandari@ti.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Davinci MSP430 mfd driver refactoring patch
X-Enigmail-Version: 0.96.0
OpenPGP: id=9E6A5CCE
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please, see this patch. I made an attempt to re-factor davinci msp430
mfd driver in order
to make ir more generic.
All your remarks and suggestions are welcome.
---------------------------------------------------------------------
>From 2b358f91edc8291ebb63cd7a4a6167f6331e3564 Mon Sep 17 00:00:00 2001
From: Andrey Porodko <panda@chelcom.ru>
Date: Fri, 4 Dec 2009 22:28:22 +0500
Subject: [PATCH] Attempt of refactoring of Davinci MFD MSP430 support
driver. Driver has been split into
 core part and board specific information and code. Board specific info
consists of features
 presented. Code specific part contains three routines to be defined for
every board.

Signed-off-by: Andrey Porodko <panda@chelcom.ru>
---
 arch/arm/mach-davinci/board-dm355-evm.c |    2 +-
 drivers/input/misc/dm355evm_keys.c      |    6 +-
 drivers/mfd/Kconfig                     |    8 +
 drivers/mfd/Makefile                    |    3 +-
 drivers/mfd/davinci_msp_core.c          |  184 +++++++++++++++++++
 drivers/mfd/dm355evm_msp.c              |  300
++++++++-----------------------
 drivers/mfd/neuros_osd2_msp.c           |   52 ++++++
 drivers/rtc/rtc-dm355evm.c              |   16 +-
 include/linux/i2c/davinci_msp.h         |   39 ++++
 include/linux/i2c/dm355evm_msp.h        |   26 +++-
 include/linux/i2c/neuros_osd2_msp.h     |   63 +++++++
 11 files changed, 454 insertions(+), 245 deletions(-)
 create mode 100644 drivers/mfd/davinci_msp_core.c
 create mode 100644 drivers/mfd/neuros_osd2_msp.c
 create mode 100644 include/linux/i2c/davinci_msp.h
 create mode 100644 include/linux/i2c/neuros_osd2_msp.h

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c
b/arch/arm/mach-davinci/board-dm355-evm.c
index a9b650d..e8b1e0f 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -132,7 +132,7 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
 }
 
 static struct i2c_board_info dm355evm_i2c_info[] = {
-    {    I2C_BOARD_INFO("dm355evm_msp", 0x25),
+    {    I2C_BOARD_INFO("davinci_msp", 0x25),
         .platform_data = dm355evm_mmcsd_gpios,
     },
     /* { plus irq  }, */
diff --git a/drivers/input/misc/dm355evm_keys.c
b/drivers/input/misc/dm355evm_keys.c
index f2b67dc..31a0389 100644
--- a/drivers/input/misc/dm355evm_keys.c
+++ b/drivers/input/misc/dm355evm_keys.c
@@ -118,7 +118,7 @@ static irqreturn_t dm355evm_keys_irq(int irq, void
*_keys)
         int        keycode;
         int        i;
 
-        status = dm355evm_msp_read(DM355EVM_MSP_INPUT_HIGH);
+        status = davinci_msp_read(DM355EVM_MSP_INPUT_HIGH);
         if (status < 0) {
             dev_dbg(keys->dev, "input high err %d\n",
                     status);
@@ -126,7 +126,7 @@ static irqreturn_t dm355evm_keys_irq(int irq, void
*_keys)
         }
         event = status << 8;
 
-        status = dm355evm_msp_read(DM355EVM_MSP_INPUT_LOW);
+        status = davinci_msp_read(DM355EVM_MSP_INPUT_LOW);
         if (status < 0) {
             dev_dbg(keys->dev, "input low err %d\n",
                     status);
@@ -240,7 +240,7 @@ static int __devinit dm355evm_keys_probe(struct
platform_device *pdev)
 
     input->id.bustype = BUS_I2C;
     input->id.product = 0x0355;
-    input->id.version = dm355evm_msp_read(DM355EVM_MSP_FIRMREV);
+    input->id.version = davinci_msp_read(DM355EVM_MSP_FIRMREV);
 
     input->evbit[0] = BIT(EV_KEY);
     for (i = 0; i < ARRAY_SIZE(dm355evm_keys); i++)
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 570be13..d087eac 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -43,6 +43,14 @@ config MFD_DM355EVM_MSP
       boards.  MSP430 firmware manages resets and power sequencing,
       inputs from buttons and the IR remote, LEDs, an RTC, and more.
 
+config MFD_NEUROS_OSD2_MSP
+    bool "Neuros OSD2 open set top box microcontroller"
+    depends on I2C && MACH_NEUROS_OSD2
+    help
+      This driver supports the MSP430 microcontroller used on these
+      boards. MSP430 firmware manages inputs/outputs from IR remote,
+      an RTC and more.
+
 config HTC_EGPIO
     bool "HTC EGPIO support"
     depends on GENERIC_HARDIRQS && GPIOLIB && ARM
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f3b277b..1a6a276 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,7 +8,8 @@ obj-$(CONFIG_MFD_ASIC3)        += asic3.o
 obj-$(CONFIG_HTC_EGPIO)        += htc-egpio.o
 obj-$(CONFIG_HTC_PASIC3)    += htc-pasic3.o
 
-obj-$(CONFIG_MFD_DM355EVM_MSP)    += dm355evm_msp.o
+obj-$(CONFIG_MFD_DM355EVM_MSP)    += dm355evm_msp.o davinci_msp_core.o
+obj-$(CONFIG_MFD_NEUROS_OSD2_MSP) += neuros_osd2_msp.o davinci_msp_core.o
 
 obj-$(CONFIG_MFD_T7L66XB)    += t7l66xb.o
 obj-$(CONFIG_MFD_TC6387XB)    += tc6387xb.o
diff --git a/drivers/mfd/davinci_msp_core.c b/drivers/mfd/davinci_msp_core.c
new file mode 100644
index 0000000..96e2220
--- /dev/null
+++ b/drivers/mfd/davinci_msp_core.c
@@ -0,0 +1,184 @@
+/*
+ * davinci_msp_core.c - driver for MSP430 firmware on some Davinci boards
+ *
+ * 2008 (c) David Brownell
+ * 2009 (c) 2009 Andrey A. Porodko <Andrey.Porodko@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/i2c/davinci_msp.h>
+
+/* REVISIT for paranoia's sake, retry reads/writes on error */
+
+static struct davinci_msp_features *msp_features;
+
+/**
+ * davinci_msp_write - Writes a register in msp
+ * @value: the value to be written
+ * @reg: register address
+ *
+ * Returns result of operation - 0 is success, else negative errno
+ */
+int davinci_msp_write(u8 value, u8 reg)
+{
+    return i2c_smbus_write_byte_data(msp_features->msp430, reg, value);
+}
+EXPORT_SYMBOL(davinci_msp_write);
+
+/**
+ * davinci_msp_read - Reads a register from msp
+ * @reg: register address
+ *
+ * Returns result of operation - value, or negative errno
+ */
+int davinci_msp_read(u8 reg)
+{
+    return i2c_smbus_read_byte_data(msp_features->msp430, reg);
+}
+EXPORT_SYMBOL(davinci_msp_read);
+
+/*
+ * Add single resource into the chain of platfrom specific MFD resources.
+ */
+static struct device *add_child(struct i2c_client *client, const char
*name,
+            void *pdata, unsigned pdata_len,
+            bool can_wakeup, int irq)
+{
+    struct platform_device    *pdev;
+    int            status;
+
+    pdev = platform_device_alloc(name, -1);
+    if (!pdev) {
+        dev_dbg(&client->dev, "can't alloc dev\n");
+        status = -ENOMEM;
+        goto err;
+    }
+    device_init_wakeup(&pdev->dev, can_wakeup);
+    pdev->dev.parent = &client->dev;
+
+    if (pdata) {
+        status = platform_device_add_data(pdev, pdata, pdata_len);
+        if (status < 0) {
+            dev_dbg(&pdev->dev, "can't add platform_data\n");
+            goto err;
+        }
+    }
+    if (irq) {
+        struct resource r = {
+            .start = irq,
+            .flags = IORESOURCE_IRQ,
+        };
+        status = platform_device_add_resources(pdev, &r, 1);
+        if (status < 0) {
+            dev_dbg(&pdev->dev, "can't add irq\n");
+            goto err;
+        }
+    }
+    status = platform_device_add(pdev);
+err:
+    if (status < 0) {
+        platform_device_put(pdev);
+        dev_err(&client->dev, "can't add %s dev\n", name);
+        return ERR_PTR(status);
+    }
+    return &pdev->dev;
+}
+
+/*
+ Add all registered features into the chain of platfrom specific MFD
resources.
+*/
+static int add_children(struct i2c_client *client,
+            struct     davinci_msp_feature *pf, int num)
+{
+    struct device    *child;
+    int        i;
+
+    /* if there are no features defined we shall interrupt driver
loading */
+    if (!pf || num <= 0)
+        return -EINVAL;
+
+    for (i = 0; i < num; i++) {
+        child = add_child(client, pf[i].name, pf[i].pdata,
+        pf[i].pdata_len, pf[i].can_wakeup,
+        pf[i].irq < 0 ? client->irq : pf[i].irq);
+    if (IS_ERR(child))
+        return PTR_ERR(child);
+    }
+    return 0;
+}
+
+/*----------------------------------------------------------------------*/
+/*
+ * Driver initialization/de-initialization code
+*/
+static int davinci_msp_remove(struct i2c_client *client)
+{
+    pm_power_off = NULL;
+    msp_features = NULL;
+    return 0;
+}
+
+static int davinci_msp_probe(struct i2c_client *client,
+            const struct i2c_device_id *id)
+{
+    int        status;
+
+    if (msp_features)
+        return -EBUSY;
+
+    msp_features = davinci_msp_get_features();
+    msp_features->msp430 = client;
+
+    status = davinci_msp_preinit(client, id);
+    if (status < 0)
+        goto fail;
+    /* export capabilities we support */
+    status = add_children(client, msp_features->pf, msp_features->num);
+    if (status < 0)
+        goto fail1;
+
+    status = davinci_msp_postinit(client, id);
+    if (status < 0)
+        goto fail1;
+    return 0;
+fail1:
+    /* FIXME remove children. List of them is in msp_features... */
+fail:
+    davinci_msp_remove(client);
+    return status;
+}
+
+
+static const struct i2c_device_id davinci_msp_ids[] = {
+    { "davinci_msp", 0  },
+    { /* end of list */ },
+};
+MODULE_DEVICE_TABLE(i2c, davinci_msp_ids);
+
+static struct i2c_driver davinci_msp_driver = {
+    .driver.name    = "davinci_msp",
+    .id_table    = davinci_msp_ids,
+    .probe        = davinci_msp_probe,
+    .remove        = davinci_msp_remove,
+};
+
+static int __init davinci_msp_init(void)
+{
+    return i2c_add_driver(&davinci_msp_driver);
+}
+subsys_initcall(davinci_msp_init);
+
+static void __exit davinci_msp_exit(void)
+{
+    i2c_del_driver(&davinci_msp_driver);
+}
+module_exit(davinci_msp_exit);
+
+MODULE_DESCRIPTION("Interface to MSP430 firmware on Davinci");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 3d4a861..4254a7f 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -1,25 +1,21 @@
 /*
- * dm355evm_msp.c - driver for MSP430 firmware on DM355EVM board
+ * dm355evm_msp.c - board specific code for MSP430 firmware.
  *
- * Copyright (C) 2008 David Brownell
+ * 2008 (c) David Brownell
+ * 2009 (c) 2009 Andrey A. Porodko <Andrey.Porodko@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-
-#include <linux/init.h>
-#include <linux/mutex.h>
 #include <linux/platform_device.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/i2c.h>
 #include <linux/i2c/dm355evm_msp.h>
 
-
 /*
  * The DM355 is a DaVinci chip with video support but no C64+ DSP.  Its
  * EVM board has an MSP430 programmed with firmware for various board
@@ -32,69 +28,72 @@
  * This driver was tested with firmware revision A4.
  */
 
-#if defined(CONFIG_INPUT_DM355EVM) || defined(CONFIG_INPUT_DM355EVM_MODULE)
-#define msp_has_keyboard()    true
+#if msp_has_leds()
+#define GPIO_LED(l)    .name = l, .active_low = true
+static struct gpio_led evm_leds[] = {
+    { GPIO_LED("dm355evm::ds14"),
+    .default_trigger = "heartbeat", },
+    { GPIO_LED("dm355evm::ds15"),
+    .default_trigger = "mmc0", },
+    { GPIO_LED("dm355evm::ds16"),
+    /* could also be a CE-ATA drive */
+    .default_trigger = "mmc1", },
+    { GPIO_LED("dm355evm::ds17"),
+    .default_trigger = "nand-disk", },
+    { GPIO_LED("dm355evm::ds18"), },
+    { GPIO_LED("dm355evm::ds19"), },
+    { GPIO_LED("dm355evm::ds20"), },
+    { GPIO_LED("dm355evm::ds21"), },
+    };
+#undef GPIO_LED
+struct gpio_led_platform_data evm_led_data = {
+    .num_leds    = ARRAY_SIZE(evm_leds),
+    .leds        = evm_leds,
+    };
 #else
-#define msp_has_keyboard()    false
+struct gpio_led_platform_data evm_led_data = {
+    .num_leds    = 0,
+    .leds        = NULL,
+    };
 #endif
 
-#if defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)
-#define msp_has_leds()        true
-#else
-#define msp_has_leds()        false
+static    struct    davinci_msp_feature dm355evm_msp_feature[] = {
+#if msp_has_rtc()
+    { "rtc-dm355evm", NULL, 0, false, 0 },
 #endif
-
-#if defined(CONFIG_RTC_DRV_DM355EVM) ||
defined(CONFIG_RTC_DRV_DM355EVM_MODULE)
-#define msp_has_rtc()        true
-#else
-#define msp_has_rtc()        false
+#if msp_has_keyboard()
+    { "dm355evm_keys", NULL, 0, true, -1 },
 #endif
-
-#if defined(CONFIG_VIDEO_TVP514X) || defined(CONFIG_VIDEO_TVP514X_MODULE)
-#define msp_has_tvp()        true
-#else
-#define msp_has_tvp()        false
+#if msp_has_leds()
+    { "leds-gpio", &evm_led_data, sizeof(evm_led_data), false, 0 },
 #endif
+};
 
+static struct    davinci_msp_features dm355evm_msp_features = {
+    ARRAY_SIZE(dm355evm_msp_feature), dm355evm_msp_feature, NULL,
+};
 
-/*----------------------------------------------------------------------*/
-
-/* REVISIT for paranoia's sake, retry reads/writes on error */
-
-static struct i2c_client *msp430;
-
-/**
- * dm355evm_msp_write - Writes a register in dm355evm_msp
- * @value: the value to be written
- * @reg: register address
- *
- * Returns result of operation - 0 is success, else negative errno
- */
-int dm355evm_msp_write(u8 value, u8 reg)
+static void dm355evm_command(unsigned command)
 {
-    return i2c_smbus_write_byte_data(msp430, reg, value);
+    int status;
+
+    status = davinci_msp_write(command, DM355EVM_MSP_COMMAND);
+    if (status < 0)
+        dev_err(&dm355evm_msp_features.msp430->dev,
+            "command %d failure %d\n", command, status);
 }
-EXPORT_SYMBOL(dm355evm_msp_write);
 
-/**
- * dm355evm_msp_read - Reads a register from dm355evm_msp
- * @reg: register address
- *
- * Returns result of operation - value, or negative errno
- */
-int dm355evm_msp_read(u8 reg)
+static void dm355evm_power_off(void)
 {
-    return i2c_smbus_read_byte_data(msp430, reg);
+    dm355evm_command(MSP_COMMAND_POWEROFF);
 }
-EXPORT_SYMBOL(dm355evm_msp_read);
 
 /*----------------------------------------------------------------------*/
-
 /*
  * Many of the msp430 pins are just used as fixed-direction GPIOs.
  * We could export a few more of them this way, if we wanted.
  */
-#define MSP_GPIO(bit,reg)    ((DM355EVM_MSP_ ## reg) << 3 | (bit))
+#define MSP_GPIO(bit, reg)    ((DM355EVM_MSP_ ## reg) << 3 | (bit))
 
 static const u8 msp_gpios[] = {
     /* eight leds */
@@ -118,6 +117,7 @@ static const u8 msp_gpios[] = {
     MSP_GPIO(2, SDMMC), MSP_GPIO(1, SDMMC),    /* mmc0 WP, nCD */
     MSP_GPIO(4, SDMMC), MSP_GPIO(3, SDMMC),    /* mmc1 WP, nCD */
 };
+static u8 msp_led_cache;
 
 #define MSP_GPIO_REG(offset)    (msp_gpios[(offset)] >> 3)
 #define MSP_GPIO_MASK(offset)    BIT(msp_gpios[(offset)] & 0x07)
@@ -134,14 +134,12 @@ static int msp_gpio_in(struct gpio_chip *chip,
unsigned offset)
     }
 }
 
-static u8 msp_led_cache;
-
 static int msp_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
     int reg, status;
 
     reg = MSP_GPIO_REG(offset);
-    status = dm355evm_msp_read(reg);
+    status = davinci_msp_read(reg);
     if (status < 0)
         return status;
     if (reg == DM355EVM_MSP_LED)
@@ -168,7 +166,7 @@ static int msp_gpio_out(struct gpio_chip *chip,
unsigned offset, int value)
         bits |= mask;
     msp_led_cache = bits;
 
-    return dm355evm_msp_write(bits, DM355EVM_MSP_LED);
+    return davinci_msp_write(bits, DM355EVM_MSP_LED);
 }
 
 static void msp_gpio_set(struct gpio_chip *chip, unsigned offset, int
value)
@@ -177,70 +175,24 @@ static void msp_gpio_set(struct gpio_chip *chip,
unsigned offset, int value)
 }
 
 static struct gpio_chip dm355evm_msp_gpio = {
-    .label            = "dm355evm_msp",
+    .label            = "davinci_msp",
     .owner            = THIS_MODULE,
     .direction_input    = msp_gpio_in,
     .get            = msp_gpio_get,
     .direction_output    = msp_gpio_out,
     .set            = msp_gpio_set,
-    .base            = -EINVAL,        /* dynamic assignment */
+    .base            = -EINVAL,    /* dynamic assignment     */
     .ngpio            = ARRAY_SIZE(msp_gpios),
     .can_sleep        = true,
 };
 
 /*----------------------------------------------------------------------*/
 
-static struct device *add_child(struct i2c_client *client, const char
*name,
-        void *pdata, unsigned pdata_len,
-        bool can_wakeup, int irq)
-{
-    struct platform_device    *pdev;
-    int            status;
-
-    pdev = platform_device_alloc(name, -1);
-    if (!pdev) {
-        dev_dbg(&client->dev, "can't alloc dev\n");
-        status = -ENOMEM;
-        goto err;
-    }
-
-    device_init_wakeup(&pdev->dev, can_wakeup);
-    pdev->dev.parent = &client->dev;
-
-    if (pdata) {
-        status = platform_device_add_data(pdev, pdata, pdata_len);
-        if (status < 0) {
-            dev_dbg(&pdev->dev, "can't add platform_data\n");
-            goto err;
-        }
-    }
-
-    if (irq) {
-        struct resource r = {
-            .start = irq,
-            .flags = IORESOURCE_IRQ,
-        };
-
-        status = platform_device_add_resources(pdev, &r, 1);
-        if (status < 0) {
-            dev_dbg(&pdev->dev, "can't add irq\n");
-            goto err;
-        }
-    }
-
-    status = platform_device_add(pdev);
-
-err:
-    if (status < 0) {
-        platform_device_put(pdev);
-        dev_err(&client->dev, "can't add %s dev\n", name);
-        return ERR_PTR(status);
-    }
-    return &pdev->dev;
-}
-
-static int add_children(struct i2c_client *client)
+int davinci_msp_preinit(struct i2c_client *client,
+            const struct i2c_device_id *id)
 {
+    int    i;
+    int    status;
     static const struct {
         int offset;
         char *label;
@@ -253,10 +205,6 @@ static int add_children(struct i2c_client *client)
         { 8 + 4, "NTSC/nPAL", },
     };
 
-    struct device    *child;
-    int        status;
-    int        i;
-
     /* GPIO-ish stuff */
     dm355evm_msp_gpio.dev = &client->dev;
     status = gpiochip_add(&dm355evm_msp_gpio);
@@ -265,51 +213,20 @@ static int add_children(struct i2c_client *client)
 
     /* LED output */
     if (msp_has_leds()) {
-#define GPIO_LED(l)    .name = l, .active_low = true
-        static struct gpio_led evm_leds[] = {
-            { GPIO_LED("dm355evm::ds14"),
-                .default_trigger = "heartbeat", },
-            { GPIO_LED("dm355evm::ds15"),
-                .default_trigger = "mmc0", },
-            { GPIO_LED("dm355evm::ds16"),
-                /* could also be a CE-ATA drive */
-                .default_trigger = "mmc1", },
-            { GPIO_LED("dm355evm::ds17"),
-                .default_trigger = "nand-disk", },
-            { GPIO_LED("dm355evm::ds18"), },
-            { GPIO_LED("dm355evm::ds19"), },
-            { GPIO_LED("dm355evm::ds20"), },
-            { GPIO_LED("dm355evm::ds21"), },
-        };
-#undef GPIO_LED
-
-        struct gpio_led_platform_data evm_led_data = {
-            .num_leds    = ARRAY_SIZE(evm_leds),
-            .leds        = evm_leds,
-        };
-
         for (i = 0; i < ARRAY_SIZE(evm_leds); i++)
             evm_leds[i].gpio = i + dm355evm_msp_gpio.base;
-
         /* NOTE:  these are the only fully programmable LEDs
          * on the board, since GPIO-61/ds22 (and many signals
          * going to DC7) must be used for AEMIF address lines
          * unless the top 1 GB of NAND is unused...
          */
-        child = add_child(client, "leds-gpio",
-                &evm_led_data, sizeof(evm_led_data),
-                false, 0);
-        if (IS_ERR(child))
-            return PTR_ERR(child);
     }
 
     /* configuration inputs */
     for (i = 0; i < ARRAY_SIZE(config_inputs); i++) {
         int gpio = dm355evm_msp_gpio.base + config_inputs[i].offset;
-
         gpio_request(gpio, config_inputs[i].label);
         gpio_direction_input(gpio);
-
         /* make it easy for userspace to see these */
         gpio_export(gpio, false);
     }
@@ -320,69 +237,25 @@ static int add_children(struct i2c_client *client)
 
         mmcsd_setup(dm355evm_msp_gpio.base + 8 + 5);
     }
-
-    /* RTC is a 32 bit counter, no alarm */
-    if (msp_has_rtc()) {
-        child = add_child(client, "rtc-dm355evm",
-                NULL, 0, false, 0);
-        if (IS_ERR(child))
-            return PTR_ERR(child);
-    }
-
-    /* input from buttons and IR remote (uses the IRQ) */
-    if (msp_has_keyboard()) {
-        child = add_child(client, "dm355evm_keys",
-                NULL, 0, true, client->irq);
-        if (IS_ERR(child))
-            return PTR_ERR(child);
-    }
-
-    return 0;
-}
-
-/*----------------------------------------------------------------------*/
-
-static void dm355evm_command(unsigned command)
-{
-    int status;
-
-    status = dm355evm_msp_write(command, DM355EVM_MSP_COMMAND);
-    if (status < 0)
-        dev_err(&msp430->dev, "command %d failure %d\n",
-                command, status);
-}
-
-static void dm355evm_power_off(void)
-{
-    dm355evm_command(MSP_COMMAND_POWEROFF);
-}
-
-static int dm355evm_msp_remove(struct i2c_client *client)
-{
-    pm_power_off = NULL;
-    msp430 = NULL;
     return 0;
 }
+EXPORT_SYMBOL(davinci_msp_preinit);
 
-static int
-dm355evm_msp_probe(struct i2c_client *client, const struct
i2c_device_id *id)
+int davinci_msp_postinit(struct i2c_client *client,
+            const struct i2c_device_id *id)
 {
-    int        status;
+    int    status;
     const char    *video = msp_has_tvp() ? "TVP5146" : "imager";
 
-    if (msp430)
-        return -EBUSY;
-    msp430 = client;
-
     /* display revision status; doubles as sanity check */
-    status = dm355evm_msp_read(DM355EVM_MSP_FIRMREV);
+    status = davinci_msp_read(DM355EVM_MSP_FIRMREV);
     if (status < 0)
-        goto fail;
+        return status;
     dev_info(&client->dev, "firmware v.%02X, %s as video-in\n",
             status, video);
 
     /* mux video input:  either tvp5146 or some external imager */
-    status = dm355evm_msp_write(msp_has_tvp() ? 0 : MSP_VIDEO_IMAGER,
+    status = davinci_msp_write(msp_has_tvp() ? 0 : MSP_VIDEO_IMAGER,
             DM355EVM_MSP_VIDEO_IN);
     if (status < 0)
         dev_warn(&client->dev, "error %d muxing %s as video-in\n",
@@ -390,48 +263,17 @@ dm355evm_msp_probe(struct i2c_client *client,
const struct i2c_device_id *id)
 
     /* init LED cache, and turn off the LEDs */
     msp_led_cache = 0xff;
-    dm355evm_msp_write(msp_led_cache, DM355EVM_MSP_LED);
-
-    /* export capabilities we support */
-    status = add_children(client);
-    if (status < 0)
-        goto fail;
+    davinci_msp_write(msp_led_cache, DM355EVM_MSP_LED);
 
     /* PM hookup */
     pm_power_off = dm355evm_power_off;
-
     return 0;
-
-fail:
-    /* FIXME remove children ... */
-    dm355evm_msp_remove(client);
-    return status;
 }
+EXPORT_SYMBOL(davinci_msp_postinit);
 
-static const struct i2c_device_id dm355evm_msp_ids[] = {
-    { "dm355evm_msp", 0 },
-    { /* end of list */ },
-};
-MODULE_DEVICE_TABLE(i2c, dm355evm_msp_ids);
 
-static struct i2c_driver dm355evm_msp_driver = {
-    .driver.name    = "dm355evm_msp",
-    .id_table    = dm355evm_msp_ids,
-    .probe        = dm355evm_msp_probe,
-    .remove        = dm355evm_msp_remove,
-};
-
-static int __init dm355evm_msp_init(void)
+struct    davinci_msp_features *davinci_msp_get_features(void)
 {
-    return i2c_add_driver(&dm355evm_msp_driver);
+    return &dm355evm_msp_features;
 }
-subsys_initcall(dm355evm_msp_init);
-
-static void __exit dm355evm_msp_exit(void)
-{
-    i2c_del_driver(&dm355evm_msp_driver);
-}
-module_exit(dm355evm_msp_exit);
-
-MODULE_DESCRIPTION("Interface to MSP430 firmware on DM355EVM");
-MODULE_LICENSE("GPL");
+EXPORT_SYMBOL(davinci_msp_get_features);
diff --git a/drivers/mfd/neuros_osd2_msp.c b/drivers/mfd/neuros_osd2_msp.c
new file mode 100644
index 0000000..169e9fd
--- /dev/null
+++ b/drivers/mfd/neuros_osd2_msp.c
@@ -0,0 +1,52 @@
+/*
+ * neuros_osd2_msp.c -board specific code for MSP430 firmware.
+ *
+ * 2008 (c) David Brownell
+ * 2009 (c) 2009 Andrey A. Porodko <Andrey.Porodko@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/i2c/neuros_osd2_msp.h>
+
+
+static    struct    davinci_msp_feature ntosd2_msp_feature[] = {
+#if msp_has_rtc()
+    { "rtc_neuros_osd2", NULL, 0, false, 0 },
+#endif
+#if msp_has_keys()
+    { "neuros_osd2_ir", NULL, 0, true, -1 },
+#endif
+#if msp_has_irblaster()
+    { "neuros_osd2_irblaster", NULL, 0, true, -1 },
+#endif
+};
+
+static struct    davinci_msp_features ntosd2_msp_features = {
+    ARRAY_SIZE(ntosd2_msp_feature), ntosd2_msp_feature, NULL,
+};
+
+int davinci_msp_preinit(struct i2c_client *client,
+            const struct i2c_device_id *id)
+{
+    return 0;
+}
+EXPORT_SYMBOL(davinci_msp_preinit);
+
+int davinci_msp_postinit(struct i2c_client *client,
+            const struct i2c_device_id *id)
+{
+    return 0;
+}
+EXPORT_SYMBOL(davinci_msp_postinit);
+
+struct    davinci_msp_features *davinci_msp_get_features(void)
+{
+    return &ntosd2_msp_features;
+}
+EXPORT_SYMBOL(davinci_msp_get_features);
diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index 58d4e18..f742c21 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -45,28 +45,28 @@ static int dm355evm_rtc_read_time(struct device
*dev, struct rtc_time *tm)
          * rolling over by re-reading until the value is stable,
          * and assuming the four reads take at most a few seconds.
          */
-        status = dm355evm_msp_read(DM355EVM_MSP_RTC_0);
+        status = davinci_msp_read(DM355EVM_MSP_RTC_0);
         if (status < 0)
             return status;
         if (tries && time.bytes[0] == status)
             break;
         time.bytes[0] = status;
 
-        status = dm355evm_msp_read(DM355EVM_MSP_RTC_1);
+        status = davinci_msp_read(DM355EVM_MSP_RTC_1);
         if (status < 0)
             return status;
         if (tries && time.bytes[1] == status)
             break;
         time.bytes[1] = status;
 
-        status = dm355evm_msp_read(DM355EVM_MSP_RTC_2);
+        status = davinci_msp_read(DM355EVM_MSP_RTC_2);
         if (status < 0)
             return status;
         if (tries && time.bytes[2] == status)
             break;
         time.bytes[2] = status;
 
-        status = dm355evm_msp_read(DM355EVM_MSP_RTC_3);
+        status = davinci_msp_read(DM355EVM_MSP_RTC_3);
         if (status < 0)
             return status;
         if (tries && time.bytes[3] == status)
@@ -96,19 +96,19 @@ static int dm355evm_rtc_set_time(struct device *dev,
struct rtc_time *tm)
      * REVISIT handle non-atomic writes ... maybe just retry until
      * byte[1] sticks (no rollover)?
      */
-    status = dm355evm_msp_write(time.bytes[0], DM355EVM_MSP_RTC_0);
+    status = davinci_msp_write(time.bytes[0], DM355EVM_MSP_RTC_0);
     if (status < 0)
         return status;
 
-    status = dm355evm_msp_write(time.bytes[1], DM355EVM_MSP_RTC_1);
+    status = davinci_msp_write(time.bytes[1], DM355EVM_MSP_RTC_1);
     if (status < 0)
         return status;
 
-    status = dm355evm_msp_write(time.bytes[2], DM355EVM_MSP_RTC_2);
+    status = davinci_msp_write(time.bytes[2], DM355EVM_MSP_RTC_2);
     if (status < 0)
         return status;
 
-    status = dm355evm_msp_write(time.bytes[3], DM355EVM_MSP_RTC_3);
+    status = davinci_msp_write(time.bytes[3], DM355EVM_MSP_RTC_3);
     if (status < 0)
         return status;
 
diff --git a/include/linux/i2c/davinci_msp.h
b/include/linux/i2c/davinci_msp.h
new file mode 100644
index 0000000..db5dd9b
--- /dev/null
+++ b/include/linux/i2c/davinci_msp.h
@@ -0,0 +1,39 @@
+/*
+ * davinci_msp.h - common code for support MSP430 microcontroller on
+ * Davinci platform
+ *
+ * 2009 (c) Andrey A. Porodko <Andrey.Porodko@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef __LINUX_I2C_DAVINCI_MSP
+#define __LINUX_I2C_DAVINCI_MSP
+
+/* utilities to access "registers" emulated by msp430 firmware */
+extern int davinci_msp_write(u8 value, u8 reg);
+extern int davinci_msp_read(u8 reg);
+
+struct    davinci_msp_feature {
+    const char     *name;
+    void        *pdata;
+    unsigned     pdata_len;
+    bool        can_wakeup;
+    int        irq;
+    /* 0 - no irq, > 0 real irq number, < 0 take client->irq */
+    };
+
+struct    davinci_msp_features {
+    int    num;
+    struct davinci_msp_feature *pf;
+    struct i2c_client *msp430;
+    };
+
+extern int davinci_msp_preinit(struct i2c_client *client,
+            const struct i2c_device_id *id);
+extern int davinci_msp_postinit(struct i2c_client *client,
+            const struct i2c_device_id *id);
+extern struct davinci_msp_features *davinci_msp_get_features(void);
+
+#endif /* __LINUX_I2C_DAVINCI_MSP */
diff --git a/include/linux/i2c/dm355evm_msp.h
b/include/linux/i2c/dm355evm_msp.h
index 3724703..8afe2f0 100644
--- a/include/linux/i2c/dm355evm_msp.h
+++ b/include/linux/i2c/dm355evm_msp.h
@@ -4,6 +4,7 @@
 #ifndef __LINUX_I2C_DM355EVM_MSP
 #define __LINUX_I2C_DM355EVM_MSP
 
+#include <linux/i2c/davinci_msp.h>
 /*
  * Written against Spectrum's writeup for the A4 firmware revision,
  * and tweaked to match source and rev D2 schematics by removing CPLD
@@ -13,10 +14,29 @@
  * sure a write completes, issue another read or write.
  */
 
-/* utilities to access "registers" emulated by msp430 firmware */
-extern int dm355evm_msp_write(u8 value, u8 reg);
-extern int dm355evm_msp_read(u8 reg);
+#if defined(CONFIG_INPUT_DM355EVM) || defined(CONFIG_INPUT_DM355EVM_MODULE)
+#define msp_has_keyboard()    1
+#else
+#define msp_has_keyboard()    0
+#endif
 
+#if defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)
+#define msp_has_leds()        1
+#else
+#define msp_has_leds()        0
+#endif
+
+#if defined(CONFIG_RTC_DRV_DM355EVM) ||
defined(CONFIG_RTC_DRV_DM355EVM_MODULE)
+#define msp_has_rtc()        1
+#else
+#define msp_has_rtc()        0
+#endif
+
+#if defined(CONFIG_VIDEO_TVP514X) || defined(CONFIG_VIDEO_TVP514X_MODULE)
+#define msp_has_tvp()        1
+#else
+#define msp_has_tvp()        0
+#endif
 
 /* command/control registers */
 #define DM355EVM_MSP_COMMAND        0x00
diff --git a/include/linux/i2c/neuros_osd2_msp.h
b/include/linux/i2c/neuros_osd2_msp.h
new file mode 100644
index 0000000..c7a64b4
--- /dev/null
+++ b/include/linux/i2c/neuros_osd2_msp.h
@@ -0,0 +1,63 @@
+/*
+ * neuros_osd2_msp.h - support MSP430 microcontroller on Neuros OSD2 board
+ *
+ * 2009 (c) Andrey A. Porodko <Andrey.Porodko@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef __LINUX_I2C_NEUROS_OSD2_MSP
+#define __LINUX_I2C_NEUROS_OSD2_MSP
+
+#include <linux/i2c/davinci_msp.h>
+
+#if defined(CONFIG_INPUT_NEUROS_OSD2) || \
+                defined(CONFIG_INPUT_NEUROS_OSD2_MODULE)
+#define msp_has_keys()        1
+#else
+#define msp_has_keys()        0
+#endif
+
+#if defined(CONFIG_RTC_DRV_NEUROS_OSD2) || \
+                defined(CONFIG_RTC_DRV_NEUROS_OSD2_MODULE)
+#define msp_has_rtc()        1
+#else
+#define msp_has_rtc()        0
+#endif
+
+#if defined(CONFIG_NEUROS_OSD2_IRBLASTER) || \
+                defined(CONFIG_NEUROS_OSD2_IRBLASTER_MODULE)
+#define msp_has_irblaster()    1
+#else
+#define msp_has_irblaster()    0
+#endif
+
+/* MSP commands (registers) */
+#define    NTOSD2_MSP430_GETIRCODE      0xB0
+#define    NTOSD2_MSP430_GETVER      0x36
+#define NTOSD2_MSP430_RTC_MDAY      0x19
+#define    NTOSD2_MSP430_RTC_MONTH      0x1A
+#define    NTOSD2_MSP430_RTC_YEAR      0x1B /* year since 2006, 0 =
2006    */
+#define    NTOSD2_MSP430_RTC_HOURS      0x18
+#define    NTOSD2_MSP430_RTC_MINUTES 0x17
+#define    NTOSD2_MSP430_RTC_SECONDS 0x16
+
+#define    NTOSD2_MSP430_READ_RETRIES 3
+
+#define    NTOSD2_MSP430_RESET      6    /* reset to MSP430 high -
active    */
+#define    NTOSD2_MSP430_IRR_IRQ      7    /* Raw data from IR sensor    */
+#define    NTOSD2_MSP430_PWM0      45   /* out, generates 38 kHz for IR
Blaster*/
+#define    NTOSD2_MSP430_ARM_BLSTR      47   /* Raw data to IR
Blaster    */
+
+#define    NTOSD2_MSP430_MAX_PULSES  128  /* max pulses in buffer        */
+#define    NTOSD2_MSP430_IO_TIMEOUT  75   /* default I/O timeout in
ms    */
+#define    NTOSD2_MSP430_POOLING_TIMEOUT 10000/* default sensor polling
in us */
+
+#define    NTOSD2_IR_BLASTER_IOC_MAGIC 'i'/* code for IR blaster
ioctl    */
+#define RRB_SET_IO_TIMEOUT       _IOW(NTOSD2_IR_BLASTER_IOC_MAGIC, \
+                    1, unsigned long)
+#define RRB_SET_POOLING_TIMEOUT   _IOW(NTOSD2_IR_BLASTER_IOC_MAGIC, \
+                    2, unsigned long)
+
+#endif /* __LINUX_I2C_NEUROS_OSD2_MSP */
-- 
1.5.6.5

---------------------------------------------------

-- 
Best regards
Andrey A. Porodko
 

