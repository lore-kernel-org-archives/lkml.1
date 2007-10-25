Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbXJYLs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbXJYLs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbXJYLsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:48:18 -0400
Received: from narury.org ([84.16.240.217]:42809 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbXJYLsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:48:17 -0400
Date: Thu, 25 Oct 2007 14:48:14 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071025114814.GA2452@kos.to>
References: <20071017195439.GD3778@stusta.de> <20071017204508.GA32110@kos.to> <20071018133744.GC3526@jupiter.solarsys.private> <20071019143754.0aa4483b@hyperion.delvare> <20071024115034.GA5797@kos.to> <20071025022529.GF30546@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20071025022529.GF30546@jupiter.solarsys.private>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 24, 2007 at 10:25:29PM -0400, Mark M. Hoffman wrote:
> * Riku Voipio <riku.voipio@iki.fi> [2007-10-24 14:50:34 +0300]:
> > On Fri, Oct 19, 2007 at 02:37:54PM +0200, Jean Delvare wrote:
> > > Riku, can you please submit a patch fixing this? The attribute should
> > > be declared read-only, and then you can use sysfs_chmod_file() to
> > > change it to read-write where supported. 

> > Thanks, this was good suggestion. Patch attached.

> No patch?

Let's try again..

-- 
"rm -rf" only sounds scary if you don't have backups

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-Fix-hwmon-f75375s.c-buggy-if.patch"

>From 90a98836377541819012dfea8bd1bf748cd39723 Mon Sep 17 00:00:00 2001
From: Riku Voipio <riku.voipio@movial.fi>
Date: Mon, 22 Oct 2007 17:42:35 +0300
Subject: [PATCH] Fix hwmon/f75375s.c: buggy if()

Fix value check in set_pwm_mode(). Instead of checking for
chip variant there, make pwmX_mode sysfs nodes only writable
on f75375 variant.

Signed-off-by: Riku Voipio <riku.voipio@movial.fi>
---
 drivers/hwmon/f75375s.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 13a0413..d3b7932 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -323,7 +323,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
 	int val = simple_strtoul(buf, NULL, 10);
 	u8 conf = 0;
 
-	if (val != 0 || val != 1 || data->kind == f75373)
+	if (!(val == 0 || val == 1))
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -529,13 +529,13 @@ static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO|S_IWUSR,
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
@@ -655,6 +655,19 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
 	if ((err = sysfs_create_group(&client->dev.kobj, &f75375_group)))
 		goto exit_detach;
 
+	if (kind == f75375) {
+		err = sysfs_chmod_file(&client->dev.kobj,
+			&sensor_dev_attr_pwm1_mode.dev_attr.attr,
+			S_IRUGO | S_IWUSR);
+		if (err)
+			goto exit_detach;
+		err = sysfs_chmod_file(&client->dev.kobj,
+			&sensor_dev_attr_pwm2_mode.dev_attr.attr,
+			S_IRUGO | S_IWUSR);
+		if (err)
+			goto exit_detach;
+	}
+
 	data->hwmon_dev = hwmon_device_register(&client->dev);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
-- 
1.5.3.1


--pWyiEgJYm5f9v55/--
