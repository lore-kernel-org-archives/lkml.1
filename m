Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZFLMcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZFLMcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZFLMcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:32:01 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56693 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZFLMb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:31:59 -0400
Date: Fri, 12 Jun 2009 14:31:56 +0200
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3: add click function
Message-ID: <20090612123156.GE29236@buzzloop.caiaq.de>
References: <20090612101805.GC18682@elf.ucw.cz> <1244803042-2913-1-git-send-email-daniel@caiaq.de> <4A323FB4.1090404@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A323FB4.1090404@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Fri, Jun 12, 2009 at 01:44:52PM +0200, Éric Piel wrote:
> Op 12-06-09 12:37, Daniel Mack schreef:
> > The LIS3 accelerometer chip has a 'click' feature which can be used to
> > detect sudden motion on any of the three axis. Configuration data is
> > passed via spi platform_data and no action is taken if that's not
> > specified, so it won't harm any existing platform.
> > 
> > To make the configuration effective, the IRQ lines need to be set up
> > appropriately. This patch also adds a way to do that from board support
> > code.
> > 
> > The DD_* definitions were removed because I couldn't find any reference
> > of them in the datasheet and the overlapped with the CLICK_ register
> > space.
> Hello,
> It's not so simple. The driver supports both LIS302xx and LIS3LV02xx.
> The LIS302xx (whoami == 0x3A) has CLICK_* registers, and the LIS3LV02xx
> (whoami == 0x3B) has DD_* registers. So first of all, you should not
> remove the references to DD_*, just add the CLICK_* definitions after
> them. Moreover, the usage of those registers should therefore be
> conditioned to whoami == 0x3A.

Ok, I can split the register definitions.

> Also, I did not follow all the black magic happening with platform_data.
> Could you explain how much would be needed to have the same feature in
> the ACPI side?

It's not so much black magic but follows the standard procedure for
passing device specific data to probed SPI devices. What you find in
board support code for embedded devices is a defintion of an
spi_board_info struct. On my platform, it looks like this for the lis3
device:

static struct lis3lv02d_platform_data lis3_pdata = {
        .click_flags    = LIS3_CLICK_SINGLE_X |
                          LIS3_CLICK_SINGLE_Y |
                          LIS3_CLICK_SINGLE_Z,
        .click_thresh_x = 10,
        .click_thresh_y = 10,
        .click_thresh_z = 10,
        .irq_cfg        = LIS3_IRQ1_CLICK,
                          LIS3_IRQ_ACTIVE_HIGH,
};

static struct spi_board_info my_spi_devices[] __initdata = {
        {
                .modalias       = "lis3lv02d_spi",
                .max_speed_hz   = 1000000,
                .bus_num        = 0,
                .chip_select    = 0,
                .controller_data = (void *) mfp_to_gpio(GPIO_ACCEL_CS),
                .platform_data  = &lis3_pdata,
                .irq            = gpio_to_irq(mfp_to_gpio(GPIO_ACCEL_IRQ)),
        },

I don't know ACPI, so I can't say how a similiar abstraction could be
achieved.

> Also, it seems to only set up the "click" feature, without ever using
> it. How do you access this information from userspace? Is it specific to
> SPI? Maybe it could also generate button events in the joystick interface?

We're using the IRQ outputs of that chips directly as source to other
circuity, so there is no userspace logic in the game. If anyone needs
that, a simple callback function would be easy to add at some later
point.

See the updated patch below.

Thanks,
Daniel


>From 17d749d1f7b9c1287cc5b8109921e7a6f149b8bc Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Thu, 11 Jun 2009 21:47:10 +0200
Subject: [PATCH] lis3: add click function

The LIS302DL accelerometer chip has a 'click' feature which can be used
to detect sudden motion on any of the three axis. Configuration data is
passed via spi platform_data and no action is taken if that's not
specified, so it won't harm any existing platform.

To make the configuration effective, the IRQ lines need to be set up
appropriately. This patch also adds a way to do that from board support
code.

The DD_* definitions were factored out to an own enum because they are
specific to LIS3LV02D devices.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/hwmon/lis3lv02d.c     |   20 ++++++++++++++++++++
 drivers/hwmon/lis3lv02d.h     |   19 ++++++++++++++++++-
 drivers/hwmon/lis3lv02d_spi.c |    1 +
 include/linux/lis3lv02d.h     |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/lis3lv02d.h

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 778eb77..d4857b5 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -495,6 +495,26 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	printk("lis3_init_device: irq %d\n", dev->irq);
 
+	/* passing in platform specific data is purely optional and only
+	 * used by the SPI transport layer at the moment */
+	if (dev->pdata) {
+		struct lis3lv02d_platform_data *p = dev->pdata;
+
+		if (p->click_flags && (dev->whoami == LIS_SINGLE_ID)) {
+			dev->write(dev, CLICK_CFG, p->click_flags);
+			dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
+			dev->write(dev, CLICK_LATENCY, p->click_latency);
+			dev->write(dev, CLICK_WINDOW, p->click_window);
+			dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
+			dev->write(dev, CLICK_THSY_X,
+					(p->click_thresh_x & 0xf) |
+					(p->click_thresh_y << 4));
+		}
+
+		if (p->irq_cfg)
+			dev->write(dev, CTRL_REG3, p->irq_cfg);
+	}
+
 	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 745ec96..1c06350 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -27,12 +27,14 @@
  * They can also be connected via I²C.
  */
 
+#include <linux/lis3lv02d.h>
+
 /* 2-byte registers */
 #define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
 /* 1-byte registers */
 #define LIS_SINGLE_ID	0x3B /* LIS[32]02DL and others */
 
-enum lis3lv02d_reg {
+enum lis3_reg {
 	WHO_AM_I	= 0x0F,
 	OFFSET_X	= 0x16,
 	OFFSET_Y	= 0x17,
@@ -60,6 +62,19 @@ enum lis3lv02d_reg {
 	FF_WU_THS_L	= 0x34,
 	FF_WU_THS_H	= 0x35,
 	FF_WU_DURATION	= 0x36,
+};
+
+enum lis302d_reg {
+	CLICK_CFG	= 0x38,
+	CLICK_SRC	= 0x39,
+	CLICK_THSY_X	= 0x3B,
+	CLICK_THSZ	= 0x3C,
+	CLICK_TIMELIMIT	= 0x3D,
+	CLICK_LATENCY	= 0x3E,
+	CLICK_WINDOW	= 0x3F,
+};
+
+enum lis3lv02d_reg {
 	DD_CFG		= 0x38,
 	DD_SRC		= 0x39,
 	DD_ACK		= 0x3A,
@@ -185,6 +200,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
+
+	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
 };
 
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index 07ae74b..3827ff0 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -72,6 +72,7 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 	lis3_dev.write = lis3_spi_write;
 	lis3_dev.irq = spi->irq;
 	lis3_dev.ac = lis3lv02d_axis_normal;
+	lis3_dev.pdata = spi->dev.platform_data;
 	spi_set_drvdata(spi, &lis3_dev);
 
 	ret = lis3lv02d_init_device(&lis3_dev);
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
new file mode 100644
index 0000000..ad651f4
--- /dev/null
+++ b/include/linux/lis3lv02d.h
@@ -0,0 +1,39 @@
+#ifndef __LIS3LV02D_H_
+#define __LIS3LV02D_H_
+
+struct lis3lv02d_platform_data {
+	/* please note: the 'click' feature is only supported for
+	 * LIS[32]02DL variants of the chip and will be ignored for
+	 * others */
+#define LIS3_CLICK_SINGLE_X	(1 << 0)
+#define LIS3_CLICK_DOUBLE_X	(1 << 1)
+#define LIS3_CLICK_SINGLE_Y	(1 << 2)
+#define LIS3_CLICK_DOUBLE_Y	(1 << 3)
+#define LIS3_CLICK_SINGLE_Z	(1 << 4)
+#define LIS3_CLICK_DOUBLE_Z	(1 << 5)
+	unsigned char click_flags;
+	unsigned char click_thresh_x;
+	unsigned char click_thresh_y;
+	unsigned char click_thresh_z;
+	unsigned char click_time_limit;
+	unsigned char click_latency;
+	unsigned char click_window;
+
+#define LIS3_IRQ1_DISABLE	(0 << 0)
+#define LIS3_IRQ1_FF_WU_1	(1 << 0)
+#define LIS3_IRQ1_FF_WU_2	(2 << 0)
+#define LIS3_IRQ1_FF_WU_12	(3 << 0)
+#define LIS3_IRQ1_DATA_READY	(4 << 0)
+#define LIS3_IRQ1_CLICK		(7 << 0)
+#define LIS3_IRQ2_DISABLE	(0 << 3)
+#define LIS3_IRQ2_FF_WU_1	(1 << 3)
+#define LIS3_IRQ2_FF_WU_2	(2 << 3)
+#define LIS3_IRQ2_FF_WU_12	(3 << 3)
+#define LIS3_IRQ2_DATA_READY	(4 << 3)
+#define LIS3_IRQ2_CLICK		(7 << 3)
+#define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
+#define LIS3_IRQ_ACTIVE_HIGH	(1 << 7)
+	unsigned char irq_cfg;
+};
+
+#endif /* __LIS3LV02D_H_ */
-- 
1.6.3.1

