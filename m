Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936495Ab0CMBao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:30:44 -0500
Received: from kroah.org ([198.145.64.141]:60662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934816Ab0CMATz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001507.966110131@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: [patch 032/123] macintosh/hwmon/ams: Fix device removal sequence
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jean Delvare <khali@linux-fr.org>

commit 98ceb75c7c14eada76b0aa9f03a635a735cee3cb upstream.

Some code that is in ams_exit() (the module exit code) should instead
be called when the device (not module) is removed. It probably doesn't
make much of a difference in the PMU case, but in the I2C case it does
matter.

I make no guarantee that my fix isn't racy, I'm not familiar enough
with the ams driver code to tell for sure.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/ams/ams-core.c |   11 +++++++----
 drivers/hwmon/ams/ams-i2c.c  |    2 ++
 drivers/hwmon/ams/ams-pmu.c  |    2 ++
 drivers/hwmon/ams/ams.h      |    1 +
 4 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/ams/ams-core.c
+++ b/drivers/hwmon/ams/ams-core.c
@@ -213,7 +213,7 @@ int __init ams_init(void)
 	return -ENODEV;
 }
 
-void ams_exit(void)
+void ams_sensor_detach(void)
 {
 	/* Remove input device */
 	ams_input_exit();
@@ -221,9 +221,6 @@ void ams_exit(void)
 	/* Remove attributes */
 	device_remove_file(&ams_info.of_dev->dev, &dev_attr_current);
 
-	/* Shut down implementation */
-	ams_info.exit();
-
 	/* Flush interrupt worker
 	 *
 	 * We do this after ams_info.exit(), because an interrupt might
@@ -239,6 +236,12 @@ void ams_exit(void)
 	pmf_unregister_irq_client(&ams_freefall_client);
 }
 
+static void __exit ams_exit(void)
+{
+	/* Shut down implementation */
+	ams_info.exit();
+}
+
 MODULE_AUTHOR("Stelian Pop, Michael Hanselmann");
 MODULE_DESCRIPTION("Apple Motion Sensor driver");
 MODULE_LICENSE("GPL");
--- a/drivers/hwmon/ams/ams-i2c.c
+++ b/drivers/hwmon/ams/ams-i2c.c
@@ -238,6 +238,8 @@ static int ams_i2c_probe(struct i2c_clie
 static int ams_i2c_remove(struct i2c_client *client)
 {
 	if (ams_info.has_device) {
+		ams_sensor_detach();
+
 		/* Disable interrupts */
 		ams_i2c_set_irq(AMS_IRQ_ALL, 0);
 
--- a/drivers/hwmon/ams/ams-pmu.c
+++ b/drivers/hwmon/ams/ams-pmu.c
@@ -133,6 +133,8 @@ static void ams_pmu_get_xyz(s8 *x, s8 *y
 
 static void ams_pmu_exit(void)
 {
+	ams_sensor_detach();
+
 	/* Disable interrupts */
 	ams_pmu_set_irq(AMS_IRQ_ALL, 0);
 
--- a/drivers/hwmon/ams/ams.h
+++ b/drivers/hwmon/ams/ams.h
@@ -61,6 +61,7 @@ extern struct ams ams_info;
 
 extern void ams_sensors(s8 *x, s8 *y, s8 *z);
 extern int ams_sensor_attach(void);
+extern void ams_sensor_detach(void);
 
 extern int ams_pmu_init(struct device_node *np);
 extern int ams_i2c_init(struct device_node *np);


