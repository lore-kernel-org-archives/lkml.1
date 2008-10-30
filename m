Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYJ3TG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYJ3TG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYJ3TGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:06:17 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:52652 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYJ3TGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:06:16 -0400
Subject: uwb: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 20:06:16 +0100
Message-Id: <1225393576.21973.36.camel@nga.site>
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
Subject: uwb: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: David Vrabel <david.vrabel@csr.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/uwb/umc-dev.c b/drivers/uwb/umc-dev.c
index aa44e1c..53207e1 100644
--- a/drivers/uwb/umc-dev.c
+++ b/drivers/uwb/umc-dev.c
@@ -31,8 +31,7 @@ struct umc_dev *umc_device_create(struct device *parent, int n)
 
 	umc = kzalloc(sizeof(struct umc_dev), GFP_KERNEL);
 	if (umc) {
-		snprintf(umc->dev.bus_id, sizeof(umc->dev.bus_id), "%s-%d",
-			 parent->bus_id, n);
+		dev_set_name(&umc->dev, "%s-%d", dev_name(parent), n);
 		umc->dev.parent  = parent;
 		umc->dev.bus     = &umc_bus_type;
 		umc->dev.release = umc_device_release;
diff --git a/drivers/uwb/whci.c b/drivers/uwb/whci.c
index 3df2388..e626467 100644
--- a/drivers/uwb/whci.c
+++ b/drivers/uwb/whci.c
@@ -111,7 +111,7 @@ static int whci_add_cap(struct whci_card *card, int n)
 		+ UWBCAPDATA_TO_OFFSET(capdata);
 	umc->resource.end    = umc->resource.start
 		+ (n == 0 ? 0x20 : UWBCAPDATA_TO_SIZE(capdata)) - 1;
-	umc->resource.name   = umc->dev.bus_id;
+	umc->resource.name   = dev_name(&umc->dev);
 	umc->resource.flags  = card->pci->resource[bar].flags;
 	umc->resource.parent = &card->pci->resource[bar];
 	umc->irq             = card->pci->irq;
diff --git a/include/linux/uwb/debug.h b/include/linux/uwb/debug.h
index a86a73f..67a2405 100644
--- a/include/linux/uwb/debug.h
+++ b/include/linux/uwb/debug.h
@@ -60,7 +60,7 @@ do {									\
 				snprintf(__head, sizeof(__head),	\
 					 "%s %s: ",			\
 					 dev_driver_string(__dev),	\
-					 __dev->bus_id);		\
+					 dev_name(__dev));		\
 		}							\
 		printk(KERN_ERR "%s%s" _tag ": " f, __head,		\
 			__func__, ## a);				\


