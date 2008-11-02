Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYKBCzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYKBCzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYKBCzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:55:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:9108 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYKBCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:55:09 -0400
Subject: regulator: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: lrg@slimlogic.co.uk
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 03:55:10 +0100
Message-Id: <1225594510.2142.20.camel@nga.site>
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
Subject: regulator: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/regulator/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1779,8 +1779,8 @@ struct regulator_dev *regulator_register
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = dev;
-	snprintf(rdev->dev.bus_id, sizeof(rdev->dev.bus_id),
-		 "regulator.%d", atomic_inc_return(&regulator_no) - 1);
+	dev_set_name(&rdev->dev, "regulator.%d",
+		     atomic_inc_return(&regulator_no) - 1);
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
 		kfree(rdev);


