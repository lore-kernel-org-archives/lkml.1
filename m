Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907Ab0CMBaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:30:52 -0500
Received: from kroah.org ([198.145.64.141]:60654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934820Ab0CMATy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:54 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.881380174@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Colin Leroy <colin@colino.net>
Subject: [patch 031/123] macintosh/therm_adt746x: Fix sysfs attributes lifetime
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jean Delvare <khali@linux-fr.org>

commit 33a470f6d5e1879c26f16f6b34dc09f82d44f6e9 upstream.

Looking at drivers/macintosh/therm_adt746x.c, the sysfs files are
created in thermostat_init() and removed in thermostat_exit(), which
are the driver's init and exit functions. These files are backed-up by
a per-device structure, so it looks like the wrong thing to do: the
sysfs files have a lifetime longer than the data structure that is
backing it up.

I think that sysfs files creation should be moved to the end of
probe_thermostat() and sysfs files removal should be moved to the
beginning of remove_thermostat().

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Colin Leroy <colin@colino.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/macintosh/therm_adt746x.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -90,6 +90,8 @@ static struct task_struct *thread_therm
 
 static void write_both_fan_speed(struct thermostat *th, int speed);
 static void write_fan_speed(struct thermostat *th, int speed, int fan);
+static void thermostat_create_files(void);
+static void thermostat_remove_files(void);
 
 static int
 write_reg(struct thermostat* th, int reg, u8 data)
@@ -161,6 +163,8 @@ remove_thermostat(struct i2c_client *cli
 	struct thermostat *th = i2c_get_clientdata(client);
 	int i;
 	
+	thermostat_remove_files();
+
 	if (thread_therm != NULL) {
 		kthread_stop(thread_therm);
 	}
@@ -449,6 +453,8 @@ static int probe_thermostat(struct i2c_c
 		return -ENOMEM;
 	}
 
+	thermostat_create_files();
+
 	return 0;
 }
 
@@ -566,7 +572,6 @@ thermostat_init(void)
 	struct device_node* np;
 	const u32 *prop;
 	int i = 0, offset = 0;
-	int err;
 
 	np = of_find_node_by_name(NULL, "fan");
 	if (!np)
@@ -633,6 +638,17 @@ thermostat_init(void)
 		return -ENODEV;
 	}
 
+#ifndef CONFIG_I2C_POWERMAC
+	request_module("i2c-powermac");
+#endif
+
+	return i2c_add_driver(&thermostat_driver);
+}
+
+static void thermostat_create_files(void)
+{
+	int err;
+
 	err = device_create_file(&of_dev->dev, &dev_attr_sensor1_temperature);
 	err |= device_create_file(&of_dev->dev, &dev_attr_sensor2_temperature);
 	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_limit);
@@ -647,16 +663,9 @@ thermostat_init(void)
 	if (err)
 		printk(KERN_WARNING
 			"Failed to create tempertaure attribute file(s).\n");
-
-#ifndef CONFIG_I2C_POWERMAC
-	request_module("i2c-powermac");
-#endif
-
-	return i2c_add_driver(&thermostat_driver);
 }
 
-static void __exit
-thermostat_exit(void)
+static void thermostat_remove_files(void)
 {
 	if (of_dev) {
 		device_remove_file(&of_dev->dev, &dev_attr_sensor1_temperature);
@@ -673,9 +682,14 @@ thermostat_exit(void)
 			device_remove_file(&of_dev->dev,
 					   &dev_attr_sensor2_fan_speed);
 
-		of_device_unregister(of_dev);
 	}
+}
+
+static void __exit
+thermostat_exit(void)
+{
 	i2c_del_driver(&thermostat_driver);
+	of_device_unregister(of_dev);
 }
 
 module_init(thermostat_init);


