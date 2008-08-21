Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbYHURjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbYHURjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760609AbYHURik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:38:40 -0400
Received: from mx1.suse.de ([195.135.220.2]:47911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760608AbYHURij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:38:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 08/15] driver core: add init_name to struct device
Date: Thu, 21 Aug 2008 10:32:56 -0700
Message-Id: <1219339983-9634-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives us a way to handle both the bus_id and init_name values being
used for a while during the transition period.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   20 +++++++++++++-------
 include/linux/device.h |    1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4004131..d021c98 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -844,13 +844,19 @@ int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
-	int error;
+	int error = -EINVAL;
 
 	dev = get_device(dev);
-	if (!dev || !strlen(dev->bus_id)) {
-		error = -EINVAL;
-		goto Done;
-	}
+	if (!dev)
+		goto done;
+
+	/* Temporarily support init_name if it is set.
+	 * It will override bus_id for now */
+	if (dev->init_name)
+		dev_set_name(dev, "%s", dev->init_name);
+
+	if (!strlen(dev->bus_id))
+		goto done;
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 
@@ -919,7 +925,7 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		mutex_unlock(&dev->class->p->class_mutex);
 	}
- Done:
+done:
 	put_device(dev);
 	return error;
  DPMError:
@@ -946,7 +952,7 @@ int device_add(struct device *dev)
 	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
-	goto Done;
+	goto done;
 }
 
 /**
diff --git a/include/linux/device.h b/include/linux/device.h
index a701c1b..4d8372d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -358,6 +358,7 @@ struct device {
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
+	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
 	unsigned		uevent_suppress:1;
 
-- 
1.5.6.5

