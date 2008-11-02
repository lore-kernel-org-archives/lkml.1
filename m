Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYKBC6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYKBC6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYKBC61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:58:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:9529 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYKBC60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:58:26 -0400
Subject: rapidio: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Matt Porter <mporter@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 03:58:26 +0100
Message-Id: <1225594706.2142.22.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I did not compile or test it, please let me know, or help fixing
 it, if something is wrong with the conversion)

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
Subject: rapidio: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index a926c89..ec08acb 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -365,15 +365,15 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		rdev->rswitch = rswitch;
-		sprintf(rio_name(rdev), "%02x:s:%04x", rdev->net->id,
-			rdev->rswitch->switchid);
+		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
+			     rdev->rswitch->switchid);
 		rio_route_set_ops(rdev);
 
 		list_add_tail(&rswitch->node, &rio_switches);
 
 	} else
-		sprintf(rio_name(rdev), "%02x:e:%04x", rdev->net->id,
-			rdev->destid);
+		dev_set_name(&rdev->dev, "%02x:e:%04x", rdev->net->id,
+			     rdev->destid);
 
 	rdev->dev.bus = &rio_bus_type;
 
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index 90987b7..32c0547 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -427,9 +427,9 @@ void rio_dev_put(struct rio_dev *);
  * Get the unique RIO device identifier. Returns the device
  * identifier string.
  */
-static inline char *rio_name(struct rio_dev *rdev)
+static inline const char *rio_name(struct rio_dev *rdev)
 {
-	return rdev->dev.bus_id;
+	return dev_name(&rdev->dev);
 }
 
 /**


