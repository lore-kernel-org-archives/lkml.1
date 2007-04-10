Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXDJVoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXDJVoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXDJVnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:43:45 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:3836 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbXDJVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=hhKfuqzn/4YS0qZl2eBhONBmsmTdL6LjFkIq20d8ZjVoO8h5h3vruspJKw7PnzPzsCaZuB8Usc3Hoj2sQa80u4h/Of+Wufex/Zsyih/VY3Ym9p2gCR2bFSKKcwOsSo7cTAKWhjK3w/Gp+MYXhyzbieUIfhMiS2bW+0eVd1+NRsM=
Date: Wed, 11 Apr 2007 00:43:50 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1529351083.20070411004350@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
CC: David Brownell <david-b@pacbell.net>
Subject: [RFC, PATCH 3/3] gpiodev - ASIC3 SoC implementation (informal)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-arm-kernel,

GPIODEV API: Support for ASIC3 SoC, found in several PDAs from HP and
HTC.
Note: ASIC3 driver is not yet in mainline (GPIODEV is one thing on
critical path to have it submitted), and itself is pretty packaged
System-on-Chip with many controllers, and thus big drivers. Patch
below shows snippets relevant to its GPIO controller, as a sample what
changes should be made to a generic driver for a GPIO-providing
device to make it GPIODEV-compliant. Full driver can be found at
http://handhelds.org/cgi-bin/cvsweb.cgi/~checkout~/linux/kernel26/drivers/soc/asic3_base.c?content-type=text/plain&f=h

Signed-off-by: Paul Sokolovsky <pmiscml@gmail.com>


Index: include/linux/soc/asic3_base.h
===================================================================
RCS file: include/linux/soc/asic3_base.h
diff -N include/linux/soc/asic3_base.h
--- /dev/null   1 Jan 1970 00:00:00 -0000
+++ include/linux/soc/asic3_base.h      10 Apr 2007 15:35:33 -0000      1.12
@@ -0,0 +1,98 @@
+#include <linux/gpiodev.h>
+
+/* Private defines - for internal use only */
+#define HDR_IPAQ_ASIC3_ACTION(ACTION,action,fn,FN)                  \
+u32  asic3_get_gpio_ ## action ## _ ## fn (struct device *dev);      \
+void asic3_set_gpio_ ## action ## _ ## fn (struct device *dev, u32 bits, u32 val);
+
+#define HDR_IPAQ_ASIC3_FN(fn,FN)                       \
+       HDR_IPAQ_ASIC3_ACTION ( MASK,mask,fn,FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( DIR, dir, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( OUT, out, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( LEVELTRI, trigtype, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( RISING, rising, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( LEVEL, triglevel, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( SLEEP_MASK, sleepmask, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( SLEEP_OUT, sleepout, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( BATT_FAULT_OUT, battfaultout, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( INT_STATUS, intstatus, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( ALT_FUNCTION, alt_fn, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( SLEEP_CONF, sleepconf, fn, FN)               \
+       HDR_IPAQ_ASIC3_ACTION ( STATUS, status, fn, FN) 
+
+#define ASIC3_GPIOA_IRQ_BASE   0
+#define ASIC3_GPIOB_IRQ_BASE   16
+#define ASIC3_GPIOC_IRQ_BASE   32
+#define ASIC3_GPIOD_IRQ_BASE   48
+#define ASIC3_LED0_IRQ         64
+#define ASIC3_LED1_IRQ         65
+#define ASIC3_LED2_IRQ         66
+#define ASIC3_SPI_IRQ          67
+#define ASIC3_SMBUS_IRQ                68
+#define ASIC3_OWM_IRQ          69
+
+#define ASIC3_NR_GPIO_IRQS     64       /* 16 bits each GPIO A...D banks */
+#define ASIC3_NR_IRQS          (ASIC3_OWM_IRQ + 1)
+
+/* Public API */
+
+extern int asic3_irq_base (struct device *dev);
+
+void asic3_write_register (struct device *dev, unsigned int reg, unsigned long value);
+unsigned long asic3_read_register (struct device *dev, unsigned int reg);
+
+/* old clock api */
+extern void asic3_set_clock_sel (struct device *dev, unsigned long bits, unsigned long val);
+extern u32  asic3_get_clock_cdex (struct device *dev);
+extern void asic3_set_clock_cdex (struct device *dev, unsigned long bits, unsigned long val);
+
+extern void asic3_set_extcf_select (struct device *dev, unsigned long bits, unsigned long val);
+extern void asic3_set_extcf_reset (struct device *dev, unsigned long bits, unsigned long val);
+extern void asic3_set_sdhwctrl (struct device *dev, unsigned long bits, unsigned long val);
+
+void asic3_set_led( struct device *dev, int led_num, int duty_time, int cycle_time);
+
+extern int asic3_register_mmc (struct device *dev);
+extern int asic3_unregister_mmc (struct device *dev);
+
+/* Accessors for GPIO banks */
+HDR_IPAQ_ASIC3_FN(a, A)
+HDR_IPAQ_ASIC3_FN(b, B)
+HDR_IPAQ_ASIC3_FN(c, C)
+HDR_IPAQ_ASIC3_FN(d, D)
+
+#define _IPAQ_ASIC3_GPIO_BANK_A      0
+#define _IPAQ_ASIC3_GPIO_BANK_B      1
+#define _IPAQ_ASIC3_GPIO_BANK_C      2
+#define _IPAQ_ASIC3_GPIO_BANK_D      3
+
+#define ASIC3_GPIO_bit(gpio) (1 << (gpio & 0xf))
+
+extern int asic3_get_gpio_bit(struct device *dev, int gpio);
+extern void asic3_set_gpio_bit(struct device *dev, int gpio, int val);
+
+
+struct tmio_mmc_hwconfig;
+
+struct asic3_platform_data
+{
+       // Must be first member
+       struct gpiodev_ops gpiodev_ops;
+
+       struct {
+               u32 dir;
+               u32 init;
+               u32 sleep_mask;
+               u32 sleep_out;
+               u32 batt_fault_out;
+               u32 sleep_conf;
+               u32 alt_function;
+       } gpio_a, gpio_b, gpio_c, gpio_d;
+
+       unsigned long bus_shift;
+
+       struct platform_device **child_platform_devs;
+       int num_child_platform_devs;
+
+       struct tmio_mmc_hwconfig *tmio_mmc_hwconfig;
+};
Index: drivers/soc/asic3_base.c
===================================================================
RCS file: /cvs/linux/kernel26/drivers/soc/asic3_base.c,v
retrieving revision 1.40
retrieving revision 1.42
diff -u -p -r1.40 -r1.42
--- drivers/soc/asic3_base.c    14 Feb 2007 13:54:49 -0000      1.40
+++ drivers/soc/asic3_base.c    10 Apr 2007 15:35:33 -0000      1.42
@@ -145,6 +145,7 @@ ASIC3_GPIO_FUNCTIONS(d, D)
 int asic3_get_gpio_bit(struct device *dev, int gpio)
 {
        u32 mask = ASIC3_GPIO_bit(gpio);
+       printk("%s(%d)\n", __FUNCTION__, gpio);
        switch (gpio >> 4) {
                case _IPAQ_ASIC3_GPIO_BANK_A:
                        return asic3_get_gpio_status_a(dev) & mask;
@@ -166,6 +167,7 @@ void asic3_set_gpio_bit(struct device *d
        u32 mask = ASIC3_GPIO_bit(gpio);
        u32 bitval = 0;
        if (val)  bitval = mask;
+       printk("%s(%d, %d)\n", __FUNCTION__, gpio, val);
 
        switch (gpio >> 4) {
                case _IPAQ_ASIC3_GPIO_BANK_A:
@@ -196,6 +198,14 @@ asic3_irq_base (struct device *dev)
 
 EXPORT_SYMBOL(asic3_irq_base);
 
+int asic3_gpio_to_irq(struct device *dev, int gpio)
+{
+       struct asic3_data *asic = dev->driver_data;
+       printk("%s(%d)\n", __FUNCTION__, gpio);
+
+       return asic->irq_base + gpio;
+}
+
 void 
 asic3_set_led (struct device *dev, int led_num, int duty_time, int cycle_time)
 {
@@ -1027,6 +1037,10 @@ asic3_probe(struct platform_device *pdev
        ds1wm_pd.bus_shift = asic->bus_shift;
 #endif
 
+       pdata->gpiodev_ops.get = asic3_get_gpio_bit;
+       pdata->gpiodev_ops.set = asic3_set_gpio_bit;
+       pdata->gpiodev_ops.to_irq = asic3_gpio_to_irq;
+       
        soc_add_devices(pdev, asic3_blocks, ARRAY_SIZE(asic3_blocks),
                        &pdev->resource[0], asic->bus_shift - ASIC3_DEFAULT_ADDR_SHIFT, asic->irq_base);
 


-- 
Best regards,
 Paul                          mailto:pmiscml@gmail.com

