Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661Ab0ADSSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0ADSSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:18:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594Ab0ADSSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:18:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37061 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753575Ab0ADSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:17:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regulator: Allow regulators to specify the time taken to ramp on enable
Date: Mon,  4 Jan 2010 18:17:45 +0000
Message-Id: <1262629066-18398-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <20100104181634.GA18258@rakim.wolfsonmicro.main>
References: <20100104181634.GA18258@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators may sometimes take longer to enable than the control operation
used to do so, either because the regulator has ramp rate control used to
limit inrush current or because the control operation is very fast (GPIO
being the most common example of this).  In order to ensure that consumers
do not rely on the regulator before it is enabled provide an enable_time()
operation and have the core delay for that time before returning to the
caller.

This is implemented as a function since the ramp rate may be specified in
voltage per unit time and therefore the time depend on the configuration.
In future it would be desirable to allow the bulk operations to run the
delays for multiple enables in parallel but this is not currently supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   41 ++++++++++++++++++++++++++++++++-----
 include/linux/regulator/driver.h |    6 +++++
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cce76a8..5a3509b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/suspend.h>
+#include <linux/delay.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -1084,6 +1085,13 @@ overflow_err:
 	return NULL;
 }
 
+static int _regulator_get_enable_time(struct regulator_dev *rdev)
+{
+	if (!rdev->desc->ops->enable_time)
+		return 0;
+	return rdev->desc->ops->enable_time(rdev);
+}
+
 /* Internal regulator request function */
 static struct regulator *_regulator_get(struct device *dev, const char *id,
 					int exclusive)
@@ -1251,7 +1259,7 @@ static int _regulator_can_change_status(struct regulator_dev *rdev)
 /* locks held by regulator_enable() */
 static int _regulator_enable(struct regulator_dev *rdev)
 {
-	int ret;
+	int ret, delay;
 
 	/* do we need to enable the supply regulator first */
 	if (rdev->supply) {
@@ -1275,13 +1283,34 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (!_regulator_can_change_status(rdev))
 				return -EPERM;
 
-			if (rdev->desc->ops->enable) {
-				ret = rdev->desc->ops->enable(rdev);
-				if (ret < 0)
-					return ret;
-			} else {
+			if (!rdev->desc->ops->enable)
 				return -EINVAL;
+
+			/* Query before enabling in case configuration
+			 * dependant.  */
+			ret = _regulator_get_enable_time(rdev);
+			if (ret >= 0) {
+				delay = ret;
+			} else {
+				printk(KERN_WARNING
+					"%s: enable_time() failed for %s: %d\n",
+					__func__, rdev_get_name(rdev),
+					ret);
+				delay = 0;
 			}
+
+			/* Allow the regulator to ramp; it would be useful
+			 * to extend this for bulk operations so that the
+			 * regulators can ramp together.  */
+			ret = rdev->desc->ops->enable(rdev);
+			if (ret < 0)
+				return ret;
+
+			if (delay >= 1000)
+				mdelay(delay / 1000);
+			else if (delay)
+				udelay(delay);
+
 		} else if (ret < 0) {
 			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
 			       __func__, rdev_get_name(rdev), ret);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 31f2055..592cd7c 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -58,6 +58,9 @@ enum regulator_status {
  * @get_optimum_mode: Get the most efficient operating mode for the regulator
  *                    when running with the specified parameters.
  *
+ * @enable_time: Time taken for the regulator voltage output voltage to
+ *               stabalise after being enabled, in microseconds.
+ *
  * @set_suspend_voltage: Set the voltage for the regulator when the system
  *                       is suspended.
  * @set_suspend_enable: Mark the regulator as enabled when the system is
@@ -93,6 +96,9 @@ struct regulator_ops {
 	int (*set_mode) (struct regulator_dev *, unsigned int mode);
 	unsigned int (*get_mode) (struct regulator_dev *);
 
+	/* Time taken to enable the regulator */
+	int (*enable_time) (struct regulator_dev *);
+
 	/* report regulator status ... most other accessors report
 	 * control inputs, this reports results of combining inputs
 	 * from Linux (and other sources) with the actual load.
-- 
1.6.5.7

