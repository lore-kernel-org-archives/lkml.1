Return-Path: <linux-kernel-owner+w=401wt.eu-S932128Ab0AML6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0AML6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932116Ab0AML6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:58:52 -0500
Received: from smtp.nokia.com ([192.100.122.230]:27438 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0AML6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:58:51 -0500
Message-ID: <4B4DB562.2080601@nokia.com>
Date: Wed, 13 Jan 2010 13:58:26 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Roger Quadros <ext-roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: Add 'start-up time' to fixed voltage regulators
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2010 11:58:25.0785 (UTC) FILETIME=[B66FCE90:01CA9447]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bd97e65b280be528239e3932da8be512ce7785ed Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 12 Jan 2010 12:25:13 +0200
Subject: [PATCH] regulator: Add 'start-up time' to fixed voltage regulators

Add a field to specify a delay for the start-up time of
a fixed voltage regulator.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/regulator/fixed.c       |    5 +++++
 include/linux/regulator/fixed.h |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index f9f516a..40d4080 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -24,12 +24,14 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/fixed.h>
 #include <linux/gpio.h>
+#include <linux/delay.h>
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
 	struct regulator_dev *dev;
 	int microvolts;
 	int gpio;
+	unsigned delay;
 	unsigned enable_high:1;
 	unsigned is_enabled:1;
 };
@@ -48,6 +50,8 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
 	if (gpio_is_valid(data->gpio)) {
 		gpio_set_value_cansleep(data->gpio, data->enable_high);
 		data->is_enabled = 1;
+		if (data->delay)
+			udelay(data->delay);
 	}
 
 	return 0;
@@ -117,6 +121,7 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->microvolts = config->microvolts;
 	drvdata->gpio = config->gpio;
+	drvdata->delay = config->delay;
 
 	if (gpio_is_valid(config->gpio)) {
 		drvdata->enable_high = config->enable_high;
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index e94a4a1..02edef1 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -25,6 +25,7 @@ struct regulator_init_data;
  * @microvolts:		Output voltage of regulator
  * @gpio:		GPIO to use for enable control
  * 			set to -EINVAL if not used
+ * @delay:		Start-up time in microseconds
  * @enable_high:	Polarity of enable GPIO
  *			1 = Active high, 0 = Active low
  * @enabled_at_boot:	Whether regulator has been enabled at
@@ -41,6 +42,7 @@ struct fixed_voltage_config {
 	const char *supply_name;
 	int microvolts;
 	int gpio;
+	unsigned delay;
 	unsigned enable_high:1;
 	unsigned enabled_at_boot:1;
 	struct regulator_init_data *init_data;
-- 
1.6.0.4

