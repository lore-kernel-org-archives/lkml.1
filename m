Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZG2RFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZG2RFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZG2RFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:05:21 -0400
Received: from ru.mvista.com ([213.79.90.228]:28684 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755959AbZG2RFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:05:13 -0400
Date: Wed, 29 Jul 2009 21:05:12 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 5/7] spi: Merge probe and probe_id callbacks
Message-ID: <20090729170512.GE4803@oksana.dev.rtsoft.ru>
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe_id callback was introduced for the transition period
as a "new-style" probe hook. This patch makes probe() look exactly
as probe_id(), converts drivers and removes probe_id().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/max7301.c                 |    3 ++-
 drivers/gpio/mcp23s08.c                |    3 ++-
 drivers/hwmon/adcxx.c                  |   12 ++++++++----
 drivers/hwmon/lis3lv02d_spi.c          |    3 ++-
 drivers/hwmon/lm70.c                   |    6 ++++--
 drivers/hwmon/max1111.c                |    3 ++-
 drivers/input/touchscreen/ad7877.c     |    3 ++-
 drivers/input/touchscreen/ad7879.c     |    3 ++-
 drivers/input/touchscreen/ads7846.c    |    3 ++-
 drivers/leds/leds-dac124s085.c         |    3 ++-
 drivers/mfd/ezx-pcap.c                 |    3 ++-
 drivers/misc/eeprom/at25.c             |    2 +-
 drivers/mmc/host/mmc_spi.c             |    3 ++-
 drivers/mtd/devices/m25p80.c           |    2 +-
 drivers/mtd/devices/mtd_dataflash.c    |    3 ++-
 drivers/net/enc28j60.c                 |    3 ++-
 drivers/net/ks8851.c                   |    3 ++-
 drivers/net/wireless/libertas/if_spi.c |    3 ++-
 drivers/net/wireless/p54/p54spi.c      |    3 ++-
 drivers/net/wireless/wl12xx/main.c     |    3 ++-
 drivers/rtc/rtc-ds1305.c               |    3 ++-
 drivers/rtc/rtc-ds1390.c               |    3 ++-
 drivers/rtc/rtc-ds3234.c               |    3 ++-
 drivers/rtc/rtc-m41t94.c               |    3 ++-
 drivers/rtc/rtc-max6902.c              |    3 ++-
 drivers/rtc/rtc-r9701.c                |    3 ++-
 drivers/rtc/rtc-rs5c348.c              |    3 ++-
 drivers/serial/max3100.c               |    3 ++-
 drivers/spi/spi.c                      |   15 +++------------
 drivers/spi/spidev.c                   |    2 +-
 drivers/spi/tle62x0.c                  |    3 ++-
 drivers/staging/stlc45xx/stlc45xx.c    |    3 ++-
 drivers/video/backlight/corgi_lcd.c    |    3 ++-
 drivers/video/backlight/ltv350qv.c     |    3 ++-
 drivers/video/backlight/tdo24m.c       |    3 ++-
 drivers/video/backlight/tosa_lcd.c     |    3 ++-
 drivers/video/backlight/vgg2432a4.c    |    3 ++-
 include/linux/spi/spi.h                |    6 ++----
 38 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/gpio/max7301.c b/drivers/gpio/max7301.c
index 480956f..c92cff6 100644
--- a/drivers/gpio/max7301.c
+++ b/drivers/gpio/max7301.c
@@ -210,7 +210,8 @@ static void max7301_set(struct gpio_chip *chip, unsigned offset, int value)
 	mutex_unlock(&ts->lock);
 }
 
-static int __devinit max7301_probe(struct spi_device *spi)
+static int __devinit max7301_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct max7301 *ts;
 	struct max7301_platform_data *pdata;
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index c6c7aa1..2a99eea 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -300,7 +300,8 @@ fail:
 	return status;
 }
 
-static int mcp23s08_probe(struct spi_device *spi)
+static int mcp23s08_probe(struct spi_device *spi,
+			  const struct spi_device_id *id)
 {
 	struct mcp23s08_platform_data	*pdata;
 	unsigned			addr;
diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index 7a89fba..b01c0d5 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -204,22 +204,26 @@ out_err:
 	return status;
 }
 
-static int __devinit adcxx1s_probe(struct spi_device *spi)
+static int __devinit adcxx1s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 1);
 }
 
-static int __devinit adcxx2s_probe(struct spi_device *spi)
+static int __devinit adcxx2s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 2);
 }
 
-static int __devinit adcxx4s_probe(struct spi_device *spi)
+static int __devinit adcxx4s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 4);
 }
 
-static int __devinit adcxx8s_probe(struct spi_device *spi)
+static int __devinit adcxx8s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 8);
 }
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index b7aed07..478b1d4 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -56,7 +56,8 @@ static int lis3_spi_init(struct lis3lv02d *lis3)
 
 static struct axis_conversion lis3lv02d_axis_normal = { 1, 2, 3 };
 
-static int __devinit lis302dl_spi_probe(struct spi_device *spi)
+static int __devinit lis302dl_spi_probe(struct spi_device *spi,
+					const struct spi_device_id *id)
 {
 	int ret;
 
diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index d55cc7c..3953c22 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -170,7 +170,8 @@ out_dev_reg_failed:
 	return status;
 }
 
-static int __devinit lm70_probe(struct spi_device *spi)
+static int __devinit lm70_probe(struct spi_device *spi,
+				const struct spi_device_id *id)
 {
 	/* signaling is SPI_MODE_0 on a 3-wire link (shared SI/SO) */
 	if ((spi->mode & (SPI_CPOL | SPI_CPHA)) || !(spi->mode & SPI_3WIRE))
@@ -179,7 +180,8 @@ static int __devinit lm70_probe(struct spi_device *spi)
 	return common_probe(spi, LM70_CHIP_LM70);
 }
 
-static int __devinit tmp121_probe(struct spi_device *spi)
+static int __devinit tmp121_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	/* signaling is SPI_MODE_0 with only MISO connected */
 	if (spi->mode & (SPI_CPOL | SPI_CPHA))
diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index 9ac4972..df0ce3b 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -154,7 +154,8 @@ static int setup_transfer(struct max1111_data *data)
 	return 0;
 }
 
-static int __devinit max1111_probe(struct spi_device *spi)
+static int __devinit max1111_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct max1111_data *data;
 	int err;
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index eb83939..8b44d87 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -646,7 +646,8 @@ static void ad7877_setup_ts_def_msg(struct spi_device *spi, struct ad7877 *ts)
 	}
 }
 
-static int __devinit ad7877_probe(struct spi_device *spi)
+static int __devinit ad7877_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct ad7877			*ts;
 	struct input_dev		*input_dev;
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index 19b4db7..aee8a94 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -618,7 +618,8 @@ static void ad7879_setup_ts_def_msg(struct ad7879 *ts)
 	}
 }
 
-static int __devinit ad7879_probe(struct spi_device *spi)
+static int __devinit ad7879_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct ad7879 *ts;
 	int error;
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 09c8109..eb12b09 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -872,7 +872,8 @@ static int __devinit setup_pendown(struct spi_device *spi, struct ads7846 *ts)
 	return 0;
 }
 
-static int __devinit ads7846_probe(struct spi_device *spi)
+static int __devinit ads7846_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct ads7846			*ts;
 	struct ads7846_packet		*packet;
diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
index 2913d76..d6430d9 100644
--- a/drivers/leds/leds-dac124s085.c
+++ b/drivers/leds/leds-dac124s085.c
@@ -64,7 +64,8 @@ static void dac124s085_set_brightness(struct led_classdev *ldev,
 	spin_unlock(&led->lock);
 }
 
-static int dac124s085_probe(struct spi_device *spi)
+static int dac124s085_probe(struct spi_device *spi,
+			    const struct spi_device_id *id)
 {
 	struct dac124s085	*dac;
 	struct dac124s085_led	*led;
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 1672f30..a658452 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -378,7 +378,8 @@ static int __devexit ezx_pcap_remove(struct spi_device *spi)
 	return 0;
 }
 
-static int __devinit ezx_pcap_probe(struct spi_device *spi)
+static int __devinit ezx_pcap_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct pcap_platform_data *pdata = spi->dev.platform_data;
 	struct pcap_chip *pcap;
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index d564de0..39a36f3 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -287,7 +287,7 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
 
 /*-------------------------------------------------------------------------*/
 
-static int at25_probe(struct spi_device *spi)
+static int at25_probe(struct spi_device *spi, const struct spi_device_id *id)
 {
 	struct at25_data	*at25 = NULL;
 	const struct spi_eeprom *chip;
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index d55fe4f..0ebc11c 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1306,7 +1306,8 @@ static int maybe_count_child(struct device *dev, void *c)
 	return 0;
 }
 
-static int mmc_spi_probe(struct spi_device *spi)
+static int mmc_spi_probe(struct spi_device *spi,
+			 const struct spi_device_id *id)
 {
 	void			*ones;
 	struct mmc_host		*mmc;
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 7c3efff..74181c7 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -782,7 +782,7 @@ static struct spi_driver m25p80_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.id_table	= m25p_ids,
-	.probe_id	= m25p_probe,
+	.probe		= m25p_probe,
 	.remove	= __devexit_p(m25p_remove),
 
 	/* REVISIT: many of these chips have deep power-down modes, which
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 211c27a..6b242a0 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -847,7 +847,8 @@ static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
  *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
  *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
  */
-static int __devinit dataflash_probe(struct spi_device *spi)
+static int __devinit dataflash_probe(struct spi_device *spi,
+				     const struct spi_device_id *id)
 {
 	int status;
 	struct flash_info	*info;
diff --git a/drivers/net/enc28j60.c b/drivers/net/enc28j60.c
index c709571..883d14f 100644
--- a/drivers/net/enc28j60.c
+++ b/drivers/net/enc28j60.c
@@ -1542,7 +1542,8 @@ static const struct net_device_ops enc28j60_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
-static int __devinit enc28j60_probe(struct spi_device *spi)
+static int __devinit enc28j60_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct net_device *dev;
 	struct enc28j60_net *priv;
diff --git a/drivers/net/ks8851.c b/drivers/net/ks8851.c
index fe7cf4f..9bbbedd 100644
--- a/drivers/net/ks8851.c
+++ b/drivers/net/ks8851.c
@@ -1176,7 +1176,8 @@ static int ks8851_read_selftest(struct ks8851_net *ks)
 
 /* driver bus management functions */
 
-static int __devinit ks8851_probe(struct spi_device *spi)
+static int __devinit ks8851_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct net_device *ndev;
 	struct ks8851_net *ks;
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index ea45765..4961b3a 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1027,7 +1027,8 @@ static int if_spi_calculate_fw_names(u16 card_id,
 	return 0;
 }
 
-static int __devinit if_spi_probe(struct spi_device *spi)
+static int __devinit if_spi_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct if_spi_card *card;
 	struct lbs_private *priv = NULL;
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 63bcdd1..e7f1ff2 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -627,7 +627,8 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
 	mutex_unlock(&priv->mutex);
 }
 
-static int __devinit p54spi_probe(struct spi_device *spi)
+static int __devinit p54spi_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct p54s_priv *priv = NULL;
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6416406..66c3a91 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1171,7 +1171,8 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 }
 
 #define WL12XX_DEFAULT_CHANNEL 1
-static int __devinit wl12xx_probe(struct spi_device *spi)
+static int __devinit wl12xx_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 2736b11..4ce04db 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -614,7 +614,8 @@ static struct bin_attribute nvram = {
  * Interface to SPI stack
  */
 
-static int __devinit ds1305_probe(struct spi_device *spi)
+static int __devinit ds1305_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct ds1305			*ds1305;
 	struct rtc_device		*rtc;
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index cdb7050..f18df86 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -120,7 +120,8 @@ static const struct rtc_class_ops ds1390_rtc_ops = {
 	.set_time	= ds1390_set_time,
 };
 
-static int __devinit ds1390_probe(struct spi_device *spi)
+static int __devinit ds1390_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	unsigned char tmp;
 	struct ds1390 *chip;
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index a774ca3..b8107eb 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -105,7 +105,8 @@ static const struct rtc_class_ops ds3234_rtc_ops = {
 	.set_time	= ds3234_set_time,
 };
 
-static int __devinit ds3234_probe(struct spi_device *spi)
+static int __devinit ds3234_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index c8c97a4..87d6349 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -110,7 +110,8 @@ static const struct rtc_class_ops m41t94_rtc_ops = {
 
 static struct spi_driver m41t94_driver;
 
-static int __devinit m41t94_probe(struct spi_device *spi)
+static int __devinit m41t94_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	int res;
diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 657403e..95197f0 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -120,7 +120,8 @@ static const struct rtc_class_ops max6902_rtc_ops = {
 	.set_time	= max6902_set_time,
 };
 
-static int __devinit max6902_probe(struct spi_device *spi)
+static int __devinit max6902_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 9beba49..a337c71 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -119,7 +119,8 @@ static const struct rtc_class_ops r9701_rtc_ops = {
 	.set_time	= r9701_set_datetime,
 };
 
-static int __devinit r9701_probe(struct spi_device *spi)
+static int __devinit r9701_probe(struct spi_device *spi,
+				 const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index 2099037..ffd3fa4 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -147,7 +147,8 @@ static const struct rtc_class_ops rs5c348_rtc_ops = {
 
 static struct spi_driver rs5c348_driver;
 
-static int __devinit rs5c348_probe(struct spi_device *spi)
+static int __devinit rs5c348_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	int ret;
 	struct rtc_device *rtc;
diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
index 05d36e2..4b043f3 100644
--- a/drivers/serial/max3100.c
+++ b/drivers/serial/max3100.c
@@ -741,7 +741,8 @@ static struct uart_driver max3100_uart_driver = {
 };
 static int uart_driver_registered;
 
-static int __devinit max3100_probe(struct spi_device *spi)
+static int __devinit max3100_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	int i, retval;
 	struct plat_max3100 *pdata;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a3c9804..f05e272 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -137,19 +137,12 @@ struct bus_type spi_bus_type = {
 };
 EXPORT_SYMBOL_GPL(spi_bus_type);
 
-static int spi_drv_probe_id(struct device *dev)
-{
-	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
-	struct spi_device		*sdev = to_spi_device(dev);
-
-	return sdrv->probe_id(sdev, spi_match_id(sdrv->id_table, sdev));
-}
-
 static int spi_drv_probe(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*sdev = to_spi_device(dev);
 
-	return sdrv->probe(to_spi_device(dev));
+	return sdrv->probe(sdev, spi_match_id(sdrv->id_table, sdev));
 }
 
 static int spi_drv_remove(struct device *dev)
@@ -174,9 +167,7 @@ static void spi_drv_shutdown(struct device *dev)
 int spi_register_driver(struct spi_driver *sdrv)
 {
 	sdrv->driver.bus = &spi_bus_type;
-	if (sdrv->probe_id)
-		sdrv->driver.probe = spi_drv_probe_id;
-	else if (sdrv->probe)
+	if (sdrv->probe)
 		sdrv->driver.probe = spi_drv_probe;
 	if (sdrv->remove)
 		sdrv->driver.remove = spi_drv_remove;
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index f921bd1..08b900b 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -561,7 +561,7 @@ static struct class *spidev_class;
 
 /*-------------------------------------------------------------------------*/
 
-static int spidev_probe(struct spi_device *spi)
+static int spidev_probe(struct spi_device *spi, const struct spi_device_id *id)
 {
 	struct spidev_data	*spidev;
 	int			status;
diff --git a/drivers/spi/tle62x0.c b/drivers/spi/tle62x0.c
index bf9540f..a6a181a 100644
--- a/drivers/spi/tle62x0.c
+++ b/drivers/spi/tle62x0.c
@@ -238,7 +238,8 @@ static int to_gpio_num(struct device_attribute *attr)
 	return -1;
 }
 
-static int __devinit tle62x0_probe(struct spi_device *spi)
+static int __devinit tle62x0_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct tle62x0_state *st;
 	struct tle62x0_pdata *pdata;
diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index 38d0b24..22c90fa 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -2387,7 +2387,8 @@ static struct platform_device stlc45xx_device = {
 	},
 };
 
-static int __devinit stlc45xx_probe(struct spi_device *spi)
+static int __devinit stlc45xx_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct stlc45xx *stlc;
 	struct ieee80211_hw *hw;
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 2211a85..eb5dced 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -530,7 +530,8 @@ err_free_backlight_on:
 	return err;
 }
 
-static int __devinit corgi_lcd_probe(struct spi_device *spi)
+static int __devinit corgi_lcd_probe(struct spi_device *spi,
+				     const struct spi_device_id *id)
 {
 	struct corgi_lcd_platform_data *pdata = spi->dev.platform_data;
 	struct corgi_lcd *lcd;
diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 4631ca8..4970c9f 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -225,7 +225,8 @@ static struct lcd_ops ltv_ops = {
 	.set_power	= ltv350qv_set_power,
 };
 
-static int __devinit ltv350qv_probe(struct spi_device *spi)
+static int __devinit ltv350qv_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct ltv350qv *lcd;
 	struct lcd_device *ld;
diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index bbfb502..0a2ab3f 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -327,7 +327,8 @@ static struct lcd_ops tdo24m_ops = {
 	.set_mode	= tdo24m_set_mode,
 };
 
-static int __devinit tdo24m_probe(struct spi_device *spi)
+static int __devinit tdo24m_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct tdo24m *lcd;
 	struct spi_message *m;
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 50ec17d..d8d057e 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -168,7 +168,8 @@ static struct lcd_ops tosa_lcd_ops = {
 	.set_mode = tosa_lcd_set_mode,
 };
 
-static int __devinit tosa_lcd_probe(struct spi_device *spi)
+static int __devinit tosa_lcd_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	int ret;
 	struct tosa_lcd_data *data;
diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index b49063c..3e9cb99 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -227,7 +227,8 @@ static struct ili9320_client vgg2432a4_client = {
 
 /* Device probe */
 
-static int __devinit vgg2432a4_probe(struct spi_device *spi)
+static int __devinit vgg2432a4_probe(struct spi_device *spi,
+				     const struct spi_device_id *id)
 {
 	int ret;
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index c8d92a1..fa4ada9 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -147,7 +147,6 @@ struct spi_message;
 /**
  * struct spi_driver - Host side "protocol" driver
  * @id_table: List of SPI devices supported by this driver
- * @probe_id: Binds this driver to the spi device via id_table matching.
  * @probe: Binds this driver to the spi device.  Drivers can verify
  *	that the device is actually present, and may need to configure
  *	characteristics (such as bits_per_word) which weren't needed for
@@ -174,9 +173,8 @@ struct spi_message;
  */
 struct spi_driver {
 	const struct spi_device_id *id_table;
-	int			(*probe_id)(struct spi_device *spi,
-					    const struct spi_device_id *id);
-	int			(*probe)(struct spi_device *spi);
+	int			(*probe)(struct spi_device *spi,
+					 const struct spi_device_id *id);
 	int			(*remove)(struct spi_device *spi);
 	void			(*shutdown)(struct spi_device *spi);
 	int			(*suspend)(struct spi_device *spi, pm_message_t mesg);
-- 
1.6.3.3

