Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272Ab0A2UkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0A2UkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302Ab0A2UkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:40:20 -0500
Received: from www.tglx.de ([62.245.132.106]:44888 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0A2UkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:40:15 -0500
Message-Id: <20100129203613.740626458@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:39:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
       lm-sensors@lm-sensors.org
Subject: [patch 10/10] hwmon: s3c-hwmon: Convert semaphore to mutex
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=hwmon-23c-hwmon-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwmon->lock is used as a mutex. Make it a real mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org
---
 drivers/hwmon/s3c-hwmon.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/drivers/hwmon/s3c-hwmon.c
===================================================================
--- linux-2.6-tip.orig/drivers/hwmon/s3c-hwmon.c
+++ linux-2.6-tip/drivers/hwmon/s3c-hwmon.c
@@ -51,7 +51,7 @@ struct s3c_hwmon_attr {
  * @attr: The holders for the channel attributes.
 */
 struct s3c_hwmon {
-	struct semaphore	lock;
+	struct mutex		lock;
 	struct s3c_adc_client	*client;
 	struct device		*hwmon_dev;
 
@@ -73,14 +73,14 @@ static int s3c_hwmon_read_ch(struct devi
 {
 	int ret;
 
-	ret = down_interruptible(&hwmon->lock);
+	ret = mutex_lock_interruptible(&hwmon->lock);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(dev, "reading channel %d\n", channel);
 
 	ret = s3c_adc_read(hwmon->client, channel);
-	up(&hwmon->lock);
+	mutex_unlock(&hwmon->lock);
 
 	return ret;
 }
@@ -296,7 +296,7 @@ static int __devinit s3c_hwmon_probe(str
 
 	platform_set_drvdata(dev, hwmon);
 
-	init_MUTEX(&hwmon->lock);
+	mutex_init(&hwmon->lock);
 
 	/* Register with the core ADC driver. */
 


