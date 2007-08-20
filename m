Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXHTWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXHTWwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXHTWwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:53929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbXHTWw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:29 -0400
Message-Id: <20070820225053.885236000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:08 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, kay.sievers@vrfy.org
Subject: [patch 02/14] Convert from class_device to device for block/pktcdvd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=block.patch

Convert from class_device to device for block/pktcdvd.  

---
 drivers/block/pktcdvd.c |   16 +++++++---------
 include/linux/pktcdvd.h |    2 +-
 2 files changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -299,18 +299,16 @@ static struct kobj_type kobj_pkt_type_wq
 static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
 {
 	if (class_pktcdvd) {
-		pd->clsdev = class_device_create(class_pktcdvd,
-					NULL, pd->pkt_dev,
-					NULL, "%s", pd->name);
-		if (IS_ERR(pd->clsdev))
-			pd->clsdev = NULL;
+		pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, "%s", pd->name);
+		if (IS_ERR(pd->dev))
+			pd->dev = NULL;
 	}
-	if (pd->clsdev) {
+	if (pd->dev) {
 		pd->kobj_stat = pkt_kobj_create(pd, "stat",
-					&pd->clsdev->kobj,
+					&pd->dev->kobj,
 					&kobj_pkt_type_stat);
 		pd->kobj_wqueue = pkt_kobj_create(pd, "write_queue",
-					&pd->clsdev->kobj,
+					&pd->dev->kobj,
 					&kobj_pkt_type_wqueue);
 	}
 }
@@ -320,7 +318,7 @@ static void pkt_sysfs_dev_remove(struct 
 	pkt_kobj_remove(pd->kobj_stat);
 	pkt_kobj_remove(pd->kobj_wqueue);
 	if (class_pktcdvd)
-		class_device_destroy(class_pktcdvd, pd->pkt_dev);
+		device_destroy(class_pktcdvd, pd->pkt_dev);
 }
 
 
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -290,7 +290,7 @@ struct pktcdvd_device
 	int			write_congestion_off;
 	int			write_congestion_on;
 
-	struct class_device	*clsdev;	/* sysfs pktcdvd[0-7] class dev */
+	struct device		*dev;		/* sysfs pktcdvd[0-7] dev */
 	struct pktcdvd_kobj	*kobj_stat;	/* sysfs pktcdvd[0-7]/stat/     */
 	struct pktcdvd_kobj	*kobj_wqueue;	/* sysfs pktcdvd[0-7]/write_queue/ */
 

-- 
