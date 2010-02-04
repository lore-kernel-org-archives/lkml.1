Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0BDSXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:23:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112Ab0BDSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:23:04 -0500
Date: Thu, 4 Feb 2010 10:22:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven King <sfking@fdwdc.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: driver for TI tmp102 temperature sensor
Message-Id: <20100204102203.ecf4bbb5.akpm@linux-foundation.org>
In-Reply-To: <201002031723.49976.sfking@fdwdc.com>
References: <201002031723.49976.sfking@fdwdc.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 17:23:49 -0800
Steven King <sfking@fdwdc.com> wrote:

> The TI TMP102 is similar to the lm75.  It differs from the lm75 by having a 16 bit conf register
> and the temp registers have a minimum resolution of 12bits; the extended conf register
> can select 13 bit resolution (which this driver does) and also change the update rate (which this
> driver currently doesn't use).
> 

A neat little driver.

checkpatch spits this warning:

    WARNING: struct dev_pm_ops should normally be const
    #387: FILE: drivers/hwmon/tmp102.c:300:
    +static struct dev_pm_ops tmp102_dev_pm_ops = {

which seems truthful enough.

--- a/drivers/hwmon/tmp102.c~hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes
+++ a/drivers/hwmon/tmp102.c
@@ -297,7 +297,7 @@ static int tmp102_resume(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops tmp102_dev_pm_ops = {
+static const struct dev_pm_ops tmp102_dev_pm_ops = {
 	.suspend	= tmp102_suspend,
 	.resume		= tmp102_resume,
 };
_



And doing this will hurt readers' brains less:



Use conventional array-walk loop.

--- a/drivers/hwmon/tmp102.c~hwmon-driver-for-ti-tmp102-temperature-sensor-fix
+++ a/drivers/hwmon/tmp102.c
@@ -91,13 +91,14 @@ static struct tmp102 *tmp102_update_devi
 
 	mutex_lock(&tmp102->lock);
 	if (time_after(jiffies, tmp102->last_update + HZ / 4)) {
-		int i = 0;
-		do {
+		int i;
+		
+		for (i = 0; i < ARRAY_SIZE(tmp102->temp); i++) {
 			int status = tmp102_read_reg(client, tmp102_reg[i]);
 			if (status > -1)
 				tmp102->temp[i] = tmp102_reg_to_mC(status);
 
-		} while (++i < ARRAY_SIZE(tmp102->temp));
+		}
 		tmp102->last_update = jiffies;
 	}
 	mutex_unlock(&tmp102->lock);
_

