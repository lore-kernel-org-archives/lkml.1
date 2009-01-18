Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZARSrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZARSrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZARSrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:47:22 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:33311 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZARSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:47:21 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4973793D.60803@cam.ac.uk>
Date: Sun, 18 Jan 2009 18:47:25 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, broonie@opensource.wolfsonmicro.com
Subject: [RFC] Regulator: Add a voltage changed event to notify consumers
References: <495FD46E.8040208@cam.ac.uk> <1231065078.11643.116.camel@vega.slimlogic.co.uk>
In-Reply-To: <1231065078.11643.116.camel@vega.slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>
Regulator: Add a voltage changed event to notify consumers
that care when another device changes the regulator voltage.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
If people are happy with this I'll post a follow up to update the
documentation to reflect this additional event.

This is pretty simple and very similar to the way the forced
disable event is handled. 

Worth noting is that (along with other events) the notifier
blocks are called with the regulator's lock held so any
attempt by consumers to update their voltage must be done
via a scheduled update call rather than within the callback
it self. The documentation will emphasize this.

Example of usage is the sht15 driver posted to lm-sensors where
the temperature measurement is dependent on the supply voltage
and hence needs to know if this has changed.

 drivers/regulator/core.c           |   10 ++++++----
 include/linux/regulator/consumer.h |    2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f511a40..9fec166 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1231,18 +1231,20 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	/* sanity check */
 	if (!rdev->desc->ops->set_voltage) {
 		ret = -EINVAL;
-		goto out;
+		goto out_unlock;
 	}
 
 	/* constraints check */
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
 	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV);
-
-out:
+	mutex_unlock(&rdev->mutex);
+	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
+	return 0;
+out_unlock:
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
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
 
