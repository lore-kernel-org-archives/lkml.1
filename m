Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYJ3RJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYJ3RJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYJ3RIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:08:50 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:40720 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbYJ3RIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:08:49 -0400
Subject: power-supply: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 18:03:04 +0100
Message-Id: <1225386184.21973.28.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: power-supply: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 308ddb2..1d76892 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -354,7 +354,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	di->dev		= &pdev->dev;
 	di->w1_dev	     = pdev->dev.parent;
-	di->bat.name	   = pdev->dev.bus_id;
+	di->bat.name	   = dev_name(&pdev->dev);
 	di->bat.type	   = POWER_SUPPLY_TYPE_BATTERY;
 	di->bat.properties     = ds2760_battery_props;
 	di->bat.num_properties = ARRAY_SIZE(ds2760_battery_props);
@@ -371,7 +371,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	}
 
 	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
-	di->monitor_wqueue = create_singlethread_workqueue(pdev->dev.bus_id);
+	di->monitor_wqueue = create_singlethread_workqueue(dev_name(&pdev->dev));
 	if (!di->monitor_wqueue) {
 		retval = -ESRCH;
 		goto workqueue_failed;


