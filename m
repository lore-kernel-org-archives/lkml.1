Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760412AbYLQH4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbYLQH4n (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYLQH42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:56:28 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:43077 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123AbYLQH41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:56:27 -0500
Message-ID: <4948B099.1080008@compulab.co.il>
Date: Wed, 17 Dec 2008 09:56:09 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: sameo@openedhand.com, eric miao <eric.miao@marvell.com>, cbou@mail.ru,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 1/2] Add Dialog DA9030 battery charger driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch amends DA903x MFD driver with definitions and methods needed for
battery charger driver.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 drivers/mfd/da903x.c       |   16 +++++++++++++++-
 include/linux/mfd/da903x.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 0b5bd85..2e04b44 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -151,12 +151,24 @@ int da903x_write(struct device *dev, int reg, uint8_t val)
 }
 EXPORT_SYMBOL_GPL(da903x_write);

+int da903x_writes(struct device *dev, int reg, int len, uint8_t *val)
+{
+	return __da903x_writes(to_i2c_client(dev), reg, len, val);
+}
+EXPORT_SYMBOL_GPL(da903x_writes);
+
 int da903x_read(struct device *dev, int reg, uint8_t *val)
 {
 	return __da903x_read(to_i2c_client(dev), reg, val);
 }
 EXPORT_SYMBOL_GPL(da903x_read);

+int da903x_reads(struct device *dev, int reg, int len, uint8_t *val)
+{
+	return __da903x_reads(to_i2c_client(dev), reg, len, val);
+}
+EXPORT_SYMBOL_GPL(da903x_reads);
+
 int da903x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
 {
 	struct da903x_chip *chip = dev_get_drvdata(dev);
@@ -254,7 +266,7 @@ static int da9030_unmask_events(struct da903x_chip *chip, unsigned int events)
 {
 	uint8_t v[3];

-	chip->events_mask &= ~events;
+	chip->events_mask |= events;

 	v[0] = (chip->events_mask & 0xff);
 	v[1] = (chip->events_mask >> 8) & 0xff;
@@ -391,6 +403,8 @@ static void da903x_irq_work(struct work_struct *work)
 		if (chip->ops->read_events(chip, &events))
 			break;

+/* 		pr_info("%s: events=%x events_mask=%x\n", */
+/* 			__func__, events, chip->events_mask); */
 		events &= ~chip->events_mask;
 		if (events == 0)
 			break;
diff --git a/include/linux/mfd/da903x.h b/include/linux/mfd/da903x.h
index cad314c..115dbe9 100644
--- a/include/linux/mfd/da903x.h
+++ b/include/linux/mfd/da903x.h
@@ -32,6 +32,7 @@ enum {
 	DA9030_ID_LDO18,
 	DA9030_ID_LDO19,
 	DA9030_ID_LDO_INT,	/* LDO Internal */
+	DA9030_ID_BAT,		/* battery charger */

 	DA9034_ID_LED_1,
 	DA9034_ID_LED_2,
@@ -93,6 +94,43 @@ struct da9034_touch_pdata {
 	int	y_inverted;
 };

+/* DA9030 battery charger data */
+struct power_supply_info;
+
+struct da9030_battery_info {
+	/* battery parameters */
+	struct power_supply_info *battery_info;
+
+	/* current and voltage to use for battery charging */
+	unsigned int charge_milliamp;
+	unsigned int charge_millivolt;
+
+	/* voltage thresholds (in millivolts) */
+	int vbat_low;
+	int vbat_crit;
+	int vbat_charge_start;
+	int vbat_charge_stop;
+	int vbat_charge_restart;
+
+	/* battery nominal minimal and maximal voltages in millivolts */
+	int vcharge_min;
+	int vcharge_max;
+
+	/* Temperature thresholds. These are DA9030 register values
+	   "as is" and should be measured for each battery type */
+	int tbat_low;
+	int tbat_high;
+	int tbat_restart;
+
+
+	/* battery monitor interval (seconds) */
+	unsigned int batmon_interval;
+
+	/* platform callbacks for battery low and critical events */
+	void (*battery_low)(void);
+	void (*battery_critical)(void);
+};
+
 struct da903x_subdev_info {
 	int		id;
 	const char	*name;
@@ -190,11 +228,13 @@ extern int da903x_unregister_notifier(struct device *dev,
 extern int da903x_query_status(struct device *dev, unsigned int status);


-/* NOTE: the two functions below are not intended for use outside
- * of the DA9034 sub-device drivers
+/* NOTE: the functions below are not intended for use outside
+ * of the DA903x sub-device drivers
  */
 extern int da903x_write(struct device *dev, int reg, uint8_t val);
+extern int da903x_writes(struct device *dev, int reg, int len, uint8_t *val);
 extern int da903x_read(struct device *dev, int reg, uint8_t *val);
+extern int da903x_reads(struct device *dev, int reg, int len, uint8_t *val);
 extern int da903x_update(struct device *dev, int reg, uint8_t val, uint8_t mask);
 extern int da903x_set_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int da903x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);


-- 
Sincerely yours,
Mike.


