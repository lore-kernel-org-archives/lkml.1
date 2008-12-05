Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYLENoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYLENoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYLENoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:44:22 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34725 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYLENoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:44:20 -0500
From: Nicolas Palix <npalix@diku.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH linux-next] hwmon/ams: Add missing of_node_put in ams-core.c
Date: Fri, 5 Dec 2008 14:44:18 +0100
User-Agent: KMail/1.9.10
Cc: Jean Delvare <khali@linux-fr.org>, Paul Mackerras <paulus@samba.org>,
       Stelian Pop <stelian@popies.net>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
References: <200812021448.13543.npalix@diku.dk> <20081203103051.f2f59c9f.sfr@canb.auug.org.au>
In-Reply-To: <20081203103051.f2f59c9f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812051444.18611.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008 00:30:51 Stephen Rothwell wrote:
> On Tue, 2 Dec 2008 14:48:13 +0100 Nicolas Palix <npalix@diku.dk> wrote:
> This is wrong because if CONFIG_SENSORS_AMS_PMU is set, np is used again
> below.
> 
np is indeed reused in the second #ifdef, but there it is immediately 
assigned a new value.  So of_node_put is needed in the first #ifdef to 
decrement the reference count on the value it has there.

> Also, I don't like this code since each of ams_i2c_init and ams_pmu_init
> keep a reference to np, so they should be doing an of_node_get(np) and
> this code above should be unconditionally doing an of_node_put(np).  This
> is not your problem, though.
> 
Following your remarks, I changed the patch. ams_i2c_init and ams_pmu_init
still keep a reference but they're now doing a call to of_node_get in their
init functions. The reference is then released in the corresponding exit
function or in error handling code.

Finally, ams_init releases the np reference for each of the two
of_find_node_by_name calls.

Regards,

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 ams-core.c |   17 +++++++++++++----
 ams-i2c.c  |    7 ++++++-
 ams-pmu.c  |   13 ++++++++++---
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/ams/ams-core.c b/drivers/hwmon/ams/ams-core.c
index 6c9ace1..9856c3f 100644
--- a/drivers/hwmon/ams/ams-core.c
+++ b/drivers/hwmon/ams/ams-core.c
@@ -192,6 +192,7 @@ release_freefall:
 int __init ams_init(void)
 {
 	struct device_node *np;
+	int ret;
 
 	spin_lock_init(&ams_info.irq_lock);
 	mutex_init(&ams_info.lock);
@@ -199,16 +200,24 @@ int __init ams_init(void)
 
 #ifdef CONFIG_SENSORS_AMS_I2C
 	np = of_find_node_by_name(NULL, "accelerometer");
-	if (np && of_device_is_compatible(np, "AAPL,accelerometer_1"))
+	if (np && of_device_is_compatible(np, "AAPL,accelerometer_1")) {
 		/* Found I2C motion sensor */
-		return ams_i2c_init(np);
+		ret = ams_i2c_init(np);
+		of_node_put(np);
+		return ret;
+	}
+	of_node_put(np);
 #endif
 
 #ifdef CONFIG_SENSORS_AMS_PMU
 	np = of_find_node_by_name(NULL, "sms");
-	if (np && of_device_is_compatible(np, "sms"))
+	if (np && of_device_is_compatible(np, "sms")) {
 		/* Found PMU motion sensor */
-		return ams_pmu_init(np);
+		ret = ams_pmu_init(np);
+		of_node_put(np);
+		return ret;
+	}
+	of_node_put(np);
 #endif
 	return -ENODEV;
 }
diff --git a/drivers/hwmon/ams/ams-i2c.c b/drivers/hwmon/ams/ams-i2c.c
index 2cbf8a6..636db87 100644
--- a/drivers/hwmon/ams/ams-i2c.c
+++ b/drivers/hwmon/ams/ams-i2c.c
@@ -255,6 +255,9 @@ static int ams_i2c_remove(struct i2c_client *client)
 static void ams_i2c_exit(void)
 {
 	i2c_del_driver(&ams_i2c_driver);
+
+	/* Release device node */
+	of_node_put(ams_info.of_node);
 }
 
 int __init ams_i2c_init(struct device_node *np)
@@ -262,7 +265,7 @@ int __init ams_i2c_init(struct device_node *np)
 	int result;
 
 	/* Set implementation stuff */
-	ams_info.of_node = np;
+	ams_info.of_node = of_node_get(np);
 	ams_info.exit = ams_i2c_exit;
 	ams_info.get_vendor = ams_i2c_get_vendor;
 	ams_info.get_xyz = ams_i2c_get_xyz;
@@ -270,6 +273,8 @@ int __init ams_i2c_init(struct device_node *np)
 	ams_info.bustype = BUS_I2C;
 
 	result = i2c_add_driver(&ams_i2c_driver);
+	if (result < 0)
+		of_node_put(ams_info.of_node);
 
 	return result;
 }
diff --git a/drivers/hwmon/ams/ams-pmu.c b/drivers/hwmon/ams/ams-pmu.c
index fb18b3d..babf3d5 100644
--- a/drivers/hwmon/ams/ams-pmu.c
+++ b/drivers/hwmon/ams/ams-pmu.c
@@ -141,6 +141,9 @@ static void ams_pmu_exit(void)
 
 	ams_info.has_device = 0;
 
+	/* Release device node */
+	of_node_put(ams_info.of_node);
+
 	printk(KERN_INFO "ams: Unloading\n");
 }
 
@@ -150,7 +153,7 @@ int __init ams_pmu_init(struct device_node *np)
 	int result;
 
 	/* Set implementation stuff */
-	ams_info.of_node = np;
+	ams_info.of_node = of_node_get(np);
 	ams_info.exit = ams_pmu_exit;
 	ams_info.get_vendor = ams_pmu_get_vendor;
 	ams_info.get_xyz = ams_pmu_get_xyz;
@@ -159,8 +162,10 @@ int __init ams_pmu_init(struct device_node *np)
 
 	/* Get PMU command, should be 0x4e, but we can never know */
 	prop = of_get_property(ams_info.of_node, "reg", NULL);
-	if (!prop)
+	if (!prop) {
+		of_node_put(ams_info.of_node);
 		return -ENODEV;
+	}
 
 	ams_pmu_cmd = ((*prop) >> 8) & 0xff;
 
@@ -171,8 +176,10 @@ int __init ams_pmu_init(struct device_node *np)
 	ams_pmu_clear_irq(AMS_IRQ_ALL);
 
 	result = ams_sensor_attach();
-	if (result < 0)
+	if (result < 0) {
+		of_node_put(ams_info.of_node);
 		return result;
+	}
 
 	/* Set default values */
 	ams_pmu_set_register(AMS_FF_LOW_LIMIT, 0x15);
