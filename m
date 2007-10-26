Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbXJZLOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbXJZLOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXJZLO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:14:27 -0400
Received: from narury.org ([84.16.240.217]:34952 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbXJZLO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:14:26 -0400
Date: Fri, 26 Oct 2007 14:14:23 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071026111423.GA16559@kos.to>
References: <20071017195439.GD3778@stusta.de> <20071017204508.GA32110@kos.to> <20071018133744.GC3526@jupiter.solarsys.private> <20071019143754.0aa4483b@hyperion.delvare> <20071024115034.GA5797@kos.to> <20071025022529.GF30546@jupiter.solarsys.private> <20071025114814.GA2452@kos.to> <20071026103647.78f44826@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20071026103647.78f44826@hyperion.delvare>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 26, 2007 at 10:36:47AM +0200, Jean Delvare wrote:
> Patch looks correct, however it doesn't apply on top of Mark's tree. I
> was able to get it to apply by reverting "(f75375s) fix pwm mode
> setting" first, but then the build fails. Presumably the other f75375s
> patches interact badly. Can you please respin this patch on top of
> Mark's tree (i.e. on top the the 4 other f75375s patches you sent since
> the -rc1 merge)? Thanks.

The surrounding code had wandered to another function, so it's suprising
it applied at all. Here's respin.

-- 
"rm -rf" only sounds scary if you don't have backups

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hwmon-f75375s-fix-buggy-if-properly.patch"

>From 4de69e3ab5b5833cddb503f0dcb2a3ccc2d5b328 Mon Sep 17 00:00:00 2001
From: Riku Voipio <riku.voipio@movial.fi>
Date: Fri, 26 Oct 2007 13:53:50 +0300
Subject: [PATCH] hwmon (f75375s) fix buggy if() properly

 Fix value check in set_pwm_mode(). Instead of checking for
 chip variant there, make pwmX_mode sysfs nodes only writable
 on f75375 variant.

Signed-off-by: Riku Voipio <riku.voipio@movial.fi>
---
 drivers/hwmon/f75375s.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 472b052..6892f76 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -343,7 +343,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
 	int val = simple_strtoul(buf, NULL, 10);
 	u8 conf = 0;
 
-	if (!(val == 0 || val == 1) || data->kind == f75373)
+	if (!(val == 0 || val == 1))
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -549,13 +549,13 @@ static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO|S_IWUSR,
 	show_pwm, set_pwm, 0);
 static SENSOR_DEVICE_ATTR(pwm1_enable, S_IRUGO|S_IWUSR,
 	show_pwm_enable, set_pwm_enable, 0);
-static SENSOR_DEVICE_ATTR(pwm1_mode, S_IRUGO|S_IWUSR,
+static SENSOR_DEVICE_ATTR(pwm1_mode, S_IRUGO,
 	show_pwm_mode, set_pwm_mode, 0);
 static SENSOR_DEVICE_ATTR(pwm2, S_IRUGO | S_IWUSR,
 	show_pwm, set_pwm, 1);
 static SENSOR_DEVICE_ATTR(pwm2_enable, S_IRUGO|S_IWUSR,
 	show_pwm_enable, set_pwm_enable, 1);
-static SENSOR_DEVICE_ATTR(pwm2_mode, S_IRUGO|S_IWUSR,
+static SENSOR_DEVICE_ATTR(pwm2_mode, S_IRUGO,
 	show_pwm_mode, set_pwm_mode, 1);
 
 static struct attribute *f75375_attributes[] = {
@@ -656,6 +656,19 @@ static int f75375_probe(struct i2c_client *client)
 	if ((err = sysfs_create_group(&client->dev.kobj, &f75375_group)))
 		goto exit_free;
 
+	if (data->kind == f75375) {
+		err = sysfs_chmod_file(&client->dev.kobj,
+			&sensor_dev_attr_pwm1_mode.dev_attr.attr,
+			S_IRUGO | S_IWUSR);
+		if (err)
+			goto exit_remove;
+		err = sysfs_chmod_file(&client->dev.kobj,
+			&sensor_dev_attr_pwm2_mode.dev_attr.attr,
+			S_IRUGO | S_IWUSR);
+		if (err)
+			goto exit_remove;
+	}
+
 	data->hwmon_dev = hwmon_device_register(&client->dev);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
-- 
1.5.3.1


--UlVJffcvxoiEqYs2--
