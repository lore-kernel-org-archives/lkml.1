Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753639AbYLRMvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYLRMvY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYLRMvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:51:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:56280 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753827AbYLRMu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:50:59 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18/GxpXz7w/xxtcIpRbUR9cvqWPoAZ9iT7UqlXVOB
	01hEggq0DzOWOd
Date: Thu, 18 Dec 2008 13:51:06 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Ben Dooks <ben-linux@fluff.org>
cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: [PATCH v2] leds: add a dac124s085 SPI LED driver
In-Reply-To: <20081218120619.GJ12431@fluff.org.uk>
Message-ID: <Pine.LNX.4.64.0812181346440.5510@axis700.grange>
References: <Pine.LNX.4.64.0812181213540.5510@axis700.grange>
 <20081218120619.GJ12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple LED driver using the DAC124S085 DAC from NatSemi

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

Changes since v1: implemented corrections by Ben Dooks: macro instead of a 
magic constant, endianness conversion, ARRAY_SIZE instead of a hard-coded 
constant.

Still needs a previous patch making maximum brightness configurable:

http://marc.info/?l=linux-kernel&m=122771446123369&w=2

 drivers/leds/Kconfig           |    7 ++
 drivers/leds/Makefile          |    3 +
 drivers/leds/leds-dac124s085.c |  147 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-dac124s085.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index a4a1ae2..a28635f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -178,6 +178,13 @@ config LEDS_DA903X
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
+config LEDS_DAC124S085
+	tristate "LED Support for DAC124S085 SPI DAC"
+	depends on LEDS_CLASS && SPI
+	help
+	  This option enables support for DAC124S085 SPI DAC from NatSemi,
+	  which can be used to control up to four LEDs.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index bc247cb..8780152 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -26,6 +26,9 @@ obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 
+# LED SPI Drivers
+obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
+
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
new file mode 100644
index 0000000..9bd25c1
--- /dev/null
+++ b/drivers/leds/leds-dac124s085.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * LED driver for the DAC124S085 SPI DAC
+ */
+
+#include <linux/leds.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/spi/spi.h>
+
+struct dac124s085_led {
+	struct led_classdev	ldev;
+	struct spi_device	*spi;
+	int			id;
+	int			brightness;
+	char			name[sizeof("dac124s085-3")];
+
+	struct mutex		mutex;
+	struct work_struct	work;
+	spinlock_t		lock;
+};
+
+struct dac124s085 {
+	struct dac124s085_led leds[4];
+};
+
+#define REG_WRITE		(0 << 12)
+#define REG_WRITE_UPDATE	(1 << 12)
+#define ALL_WRITE_UPDATE	(2 << 12)
+#define POWER_DOWN_OUTPUT	(3 << 12)
+
+static void dac124s085_led_work(struct work_struct *work)
+{
+	struct dac124s085_led *led = container_of(work, struct dac124s085_led,
+						  work);
+	u16 word;
+
+	mutex_lock(&led->mutex);
+	word = cpu_to_le16(((led->id) << 14) | REG_WRITE_UPDATE |
+			   (led->brightness & 0xfff));
+	spi_write(led->spi, (const u8 *)&word, sizeof(word));
+	mutex_unlock(&led->mutex);
+}
+
+static void dac124s085_set_brightness(struct led_classdev *ldev,
+				      enum led_brightness brightness)
+{
+	struct dac124s085_led *led = container_of(ldev, struct dac124s085_led,
+						  ldev);
+
+	spin_lock(&led->lock);
+	led->brightness = brightness;
+	schedule_work(&led->work);
+	spin_unlock(&led->lock);
+}
+
+static int dac124s085_probe(struct spi_device *spi)
+{
+	struct dac124s085	*dac;
+	struct dac124s085_led	*led;
+	int i, ret;
+
+	dac = kzalloc(sizeof(*dac), GFP_KERNEL);
+	if (!dac)
+		return -ENOMEM;
+
+	spi->bits_per_word = 16;
+
+	for (i = 0; i < ARRAY_SIZE(dac->leds); i++) {
+		led		= dac->leds + i;
+		led->id		= i;
+		led->brightness	= LED_OFF;
+		led->spi	= spi;
+		snprintf(led->name, sizeof(led->name), "dac124s085-%d", i);
+		spin_lock_init(&led->lock);
+		INIT_WORK(&led->work, dac124s085_led_work);
+		mutex_init(&led->mutex);
+		led->ldev.name = led->name;
+		led->ldev.brightness = LED_OFF;
+		led->ldev.max_brightness = 0xfff;
+		led->ldev.brightness_set = dac124s085_set_brightness;
+		ret = led_classdev_register(&spi->dev, &led->ldev);
+		if (ret < 0)
+			goto eledcr;
+	}
+
+	spi_set_drvdata(spi, dac);
+
+	return 0;
+
+eledcr:
+	while (i--)
+		led_classdev_unregister(&dac->leds[i].ldev);
+
+	spi_set_drvdata(spi, NULL);
+	kfree(dac);
+	return ret;
+}
+
+static int dac124s085_remove(struct spi_device *spi)
+{
+	struct dac124s085	*dac = spi_get_drvdata(spi);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dac->leds); i++) {
+		led_classdev_unregister(&dac->leds[i].ldev);
+		cancel_work_sync(&dac->leds[i].work);
+	}
+
+	spi_set_drvdata(spi, NULL);
+	kfree(dac);
+
+	return 0;
+}
+
+static struct spi_driver dac124s085_driver = {
+	.probe		= dac124s085_probe,
+	.remove		= dac124s085_remove,
+	.driver = {
+		.name	= "dac124s085",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init dac124s085_leds_init(void)
+{
+	return spi_register_driver(&dac124s085_driver);
+}
+
+static void __exit dac124s085_leds_exit(void)
+{
+	spi_unregister_driver(&dac124s085_driver);
+}
+
+module_init(dac124s085_leds_init);
+module_exit(dac124s085_leds_exit);
+
+MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
+MODULE_DESCRIPTION("DAC124S085 LED driver");
+MODULE_LICENSE("GPL v2");
-- 
1.5.4

