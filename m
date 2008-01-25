Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbYAYHWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbYAYHWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYAYHPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758401AbYAYHPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:32 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Peter Osterlund <petero2@telia.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 026/196] pktcdvd: Convert from class_device to device for block/pktcdvd
Date: Thu, 24 Jan 2008 23:09:24 -0800
Message-Id: <1201245134-4876-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

struct class_device is going away, this converts the code to use struct
device instead.

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/pktcdvd.c |   16 +++++++---------
 include/linux/pktcdvd.h |    2 +-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3535ef8..17da699 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -301,18 +301,16 @@ static struct kobj_type kobj_pkt_type_wqueue = {
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
@@ -322,7 +320,7 @@ static void pkt_sysfs_dev_remove(struct pktcdvd_device *pd)
 	pkt_kobj_remove(pd->kobj_stat);
 	pkt_kobj_remove(pd->kobj_wqueue);
 	if (class_pktcdvd)
-		class_device_destroy(class_pktcdvd, pd->pkt_dev);
+		device_destroy(class_pktcdvd, pd->pkt_dev);
 }
 
 
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 5ea4f05..04b4d73 100644
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
1.5.3.8

