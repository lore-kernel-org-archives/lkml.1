Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZCWSEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZCWSEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbZCWSE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:26 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35001
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757482AbZCWSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/11] xen: remove suspend_cancel hook
Date: Mon, 23 Mar 2009 10:55:09 -0700
Message-Id: <1237830911-6249-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Remove suspend_cancel hook from xenbus_driver, in preparation for using
the device model for suspending.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/xenbus/xenbus_probe.c |   23 -----------------------
 include/xen/xenbus.h              |    1 -
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 773d1cf..bd20361 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -689,27 +689,6 @@ static int suspend_dev(struct device *dev, void *data)
 	return 0;
 }
 
-static int suspend_cancel_dev(struct device *dev, void *data)
-{
-	int err = 0;
-	struct xenbus_driver *drv;
-	struct xenbus_device *xdev;
-
-	DPRINTK("");
-
-	if (dev->driver == NULL)
-		return 0;
-	drv = to_xenbus_driver(dev->driver);
-	xdev = container_of(dev, struct xenbus_device, dev);
-	if (drv->suspend_cancel)
-		err = drv->suspend_cancel(xdev);
-	if (err)
-		printk(KERN_WARNING
-		       "xenbus: suspend_cancel %s failed: %i\n",
-		       dev_name(dev), err);
-	return 0;
-}
-
 static int resume_dev(struct device *dev, void *data)
 {
 	int err;
@@ -777,8 +756,6 @@ EXPORT_SYMBOL_GPL(xenbus_resume);
 void xenbus_suspend_cancel(void)
 {
 	xs_suspend_cancel();
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, suspend_cancel_dev);
-	xenbus_backend_resume(suspend_cancel_dev);
 }
 EXPORT_SYMBOL_GPL(xenbus_suspend_cancel);
 
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index f87f961..0836772 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -92,7 +92,6 @@ struct xenbus_driver {
 				 enum xenbus_state backend_state);
 	int (*remove)(struct xenbus_device *dev);
 	int (*suspend)(struct xenbus_device *dev);
-	int (*suspend_cancel)(struct xenbus_device *dev);
 	int (*resume)(struct xenbus_device *dev);
 	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
 	struct device_driver driver;
-- 
1.6.0.6

