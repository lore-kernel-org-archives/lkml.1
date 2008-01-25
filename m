Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbYAYIDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbYAYIDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbYAYH7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:59323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764042AbYAYH7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 154/196] Driver core: fix race in __device_release_driver
Date: Thu, 24 Jan 2008 23:33:03 -0800
Message-Id: <1201246425-5058-75-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1013) was suggested by David Woodhouse; it fixes a race
in the driver core.  If a device is unregistered at the same time as
its driver is unloaded, the driver's code pages may be unmapped while
the remove method is still running.  The calls to get_driver() and
put_driver() were intended to prevent this, but they don't work if the
driver's module count has already dropped to 0.

Instead, the patch keeps the device on the driver's list until after
the remove method has returned.  This forces the necessary
synchronization to occur.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 5492264..b0726eb 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -289,11 +289,10 @@ static void __device_release_driver(struct device * dev)
 {
 	struct device_driver * drv;
 
-	drv = get_driver(dev->driver);
+	drv = dev->driver;
 	if (drv) {
 		driver_sysfs_remove(dev);
 		sysfs_remove_link(&dev->kobj, "driver");
-		klist_remove(&dev->knode_driver);
 
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -306,7 +305,7 @@ static void __device_release_driver(struct device * dev)
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
-		put_driver(drv);
+		klist_remove(&dev->knode_driver);
 	}
 }
 
-- 
1.5.3.8

