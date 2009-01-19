Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZASSVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZASSVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZASSUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:20:54 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:37384 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbZASSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:20:53 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4974C48A.1000103@cam.ac.uk>
Date: Mon, 19 Jan 2009 18:20:58 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] Regulator: Push lock out of _notifier_call_chain + add voltage
 change event.
References: <495FD46E.8040208@cam.ac.uk> <1231065078.11643.116.camel@vega.slimlogic.co.uk> <4973793D.60803@cam.ac.uk> <20090119152921.GA23444@rakim.wolfsonmicro.main> <4974B107.6050701@gmail.com> <4974C182.1090902@cam.ac.uk>
In-Reply-To: <4974C182.1090902@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>
Regulator: Push lock out of _notifier_call_chain and into caller functions
(side effect of fixing deadlock in regulator_force_disable)
+ Add a voltage changed event.
Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

---
Follow up to Mark Brown's suggestion of moving the regulator lock out
of the notifier code.  This avoids cases where it was previously necessary
to unlock the regulator before notification occured.

Any scenarios where this will cause trouble?

I'll do a documentation patch when we've pinned down how to do this.
+ can break the patch into one for pushing the lock out and one for
adding the event.

 drivers/regulator/core.c             |   15 ++++++++++-----
 drivers/regulator/wm8350-regulator.c |    2 ++
 drivers/regulator/wm8400-regulator.c |    2 +-
 include/linux/regulator/consumer.h   |    2 ++
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f511a40..2a8a294 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1243,6 +1243,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV);
 
 out:
+	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
@@ -1543,20 +1544,23 @@ int regulator_unregister_notifier(struct regulator *regulator,
 }
 EXPORT_SYMBOL_GPL(regulator_unregister_notifier);
 
-/* notify regulator consumers and downstream regulator consumers */
+/* notify regulator consumers and downstream regulator consumers.
+ * Note mutex must be held by caller.
+ */
 static void _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
 	struct regulator_dev *_rdev;
 
 	/* call rdev chain first */
-	mutex_lock(&rdev->mutex);
 	blocking_notifier_call_chain(&rdev->notifier, event, NULL);
-	mutex_unlock(&rdev->mutex);
 
 	/* now notify regulator we supply */
-	list_for_each_entry(_rdev, &rdev->supply_list, slist)
-		_notifier_call_chain(_rdev, event, data);
+	list_for_each_entry(_rdev, &rdev->supply_list, slist) {
+	  mutex_lock(&_rdev->mutex);
+	  _notifier_call_chain(_rdev, event, data);
+	  mutex_unlock(&_rdev->mutex);
+	}
 }
 
 /**
@@ -1703,6 +1707,7 @@ EXPORT_SYMBOL_GPL(regulator_bulk_free);
  *
  * Called by regulator drivers to notify clients a regulator event has
  * occurred. We also notify regulator clients downstream.
+ * Note lock must be held by caller.
  */
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 7aa3524..c975664 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1293,6 +1293,7 @@ static void pmic_uv_handler(struct wm8350 *wm8350, int irq, void *data)
 {
 	struct regulator_dev *rdev = (struct regulator_dev *)data;
 
+	mutex_lock(&rdev->mutex);
 	if (irq == WM8350_IRQ_CS1 || irq == WM8350_IRQ_CS2)
 		regulator_notifier_call_chain(rdev,
 					      REGULATOR_EVENT_REGULATION_OUT,
@@ -1301,6 +1302,7 @@ static void pmic_uv_handler(struct wm8350 *wm8350, int irq, void *data)
 		regulator_notifier_call_chain(rdev,
 					      REGULATOR_EVENT_UNDER_VOLTAGE,
 					      wm8350);
+	mutex_unlock(&rdev->mutex);
 }
 
 static int wm8350_regulator_probe(struct platform_device *pdev)
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 801bf77..6107a70 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -88,6 +88,7 @@
  * FAIL           Regulator output has failed.
  * OVER_TEMP      Regulator over temp.
  * FORCE_DISABLE  Regulator shut down by software.
+ * VOLTAGE_CHANGE Regulator voltage changed.	
  *
  * NOTE: These events can be OR'ed together when passed into handler.
  */
@@ -98,6 +99,7 @@
 #define REGULATOR_EVENT_FAIL			0x08
 #define REGULATOR_EVENT_OVER_TEMP		0x10
 #define REGULATOR_EVENT_FORCE_DISABLE		0x20
+#define REGULATOR_EVENT_VOLTAGE_CHANGE		0x40
 
 struct regulator;

