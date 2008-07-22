Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYGVFX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYGVFX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYGVFVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:21:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:53687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbYGVFVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:21:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/79] device create: block: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:29 -0700
Message-Id: <1216703983-21448-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/bsg.c                |    3 ++-
 drivers/block/aoe/aoechr.c |    5 +++--
 drivers/block/paride/pg.c  |    5 +++--
 drivers/block/paride/pt.c  |   10 ++++++----
 drivers/block/pktcdvd.c    |    4 +++-
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 5fb9b0b..5a68b09 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1044,7 +1044,8 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	bcd->release = release;
 	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = device_create(bsg_class, parent, dev, "%s", devname);
+	class_dev = device_create_drvdata(bsg_class, parent, dev, NULL,
+					  "%s", devname);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
 		goto put_dev;
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index d1de68a..c04440c 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -277,8 +277,9 @@ aoechr_init(void)
 		return PTR_ERR(aoe_class);
 	}
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
-		device_create(aoe_class, NULL,
-			      MKDEV(AOE_MAJOR, chardevs[i].minor), chardevs[i].name);
+		device_create_drvdata(aoe_class, NULL,
+				      MKDEV(AOE_MAJOR, chardevs[i].minor),
+				      NULL, chardevs[i].name);
 
 	return 0;
 }
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 9d92636..d731ca4 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -686,8 +686,9 @@ static int __init pg_init(void)
 	for (unit = 0; unit < PG_UNITS; unit++) {
 		struct pg *dev = &devices[unit];
 		if (dev->present)
-			device_create(pg_class, NULL, MKDEV(major, unit),
-				      "pg%u", unit);
+			device_create_drvdata(pg_class, NULL,
+					      MKDEV(major, unit), NULL,
+					      "pg%u", unit);
 	}
 	err = 0;
 	goto out;
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 5c74c35..673b8b2 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -979,10 +979,12 @@ static int __init pt_init(void)
 
 	for (unit = 0; unit < PT_UNITS; unit++)
 		if (pt[unit].present) {
-			device_create(pt_class, NULL, MKDEV(major, unit),
-				      "pt%d", unit);
-			device_create(pt_class, NULL, MKDEV(major, unit + 128),
-				      "pt%dn", unit);
+			device_create_drvdata(pt_class, NULL,
+					      MKDEV(major, unit), NULL,
+					      "pt%d", unit);
+			device_create_drvdata(pt_class, NULL,
+					      MKDEV(major, unit + 128), NULL,
+					      "pt%dn", unit);
 		}
 	goto out;
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 45bee91..158eed4 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -303,7 +303,9 @@ static struct kobj_type kobj_pkt_type_wqueue = {
 static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
 {
 	if (class_pktcdvd) {
-		pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, "%s", pd->name);
+		pd->dev = device_create_drvdata(class_pktcdvd, NULL,
+						pd->pkt_dev, NULL,
+						"%s", pd->name);
 		if (IS_ERR(pd->dev))
 			pd->dev = NULL;
 	}
-- 
1.5.6.3

