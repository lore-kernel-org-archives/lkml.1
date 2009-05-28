Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZE1XxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZE1XxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZE1Xwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:52:40 -0400
Received: from kroah.org ([198.145.64.141]:59044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZE1Xwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:52:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] Driver Core: do not oops when driver_unregister() is called for unregistered drivers
Date: Thu, 28 May 2009 16:49:03 -0700
Message-Id: <1243554543-11117-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090528234155.GA10930@kroah.com>
References: <20090528234155.GA10930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

We also fix a problem with cleaning up properly when initializing
drivers and devices, so checks like this will work successfully.

Portions of the patch by Linus and Greg and Ingo.

Reported-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c    |    4 +++-
 drivers/base/core.c   |    5 ++++-
 drivers/base/driver.c |    4 ++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index dc030f1..c659961 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -700,8 +700,10 @@ int bus_add_driver(struct device_driver *drv)
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
-	return error;
+	return 0;
 out_unregister:
+	kfree(drv->p);
+	drv->p = NULL;
 	kobject_put(&priv->kobj);
 out_put_bus:
 	bus_put(bus);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4aa527b..1977d4b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -879,7 +879,7 @@ int device_add(struct device *dev)
 	}
 
 	if (!dev_name(dev))
-		goto done;
+		goto name_error;
 
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
@@ -978,6 +978,9 @@ done:
 	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
+name_error:
+	kfree(dev->p);
+	dev->p = NULL;
 	goto done;
 }
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index c51f11b..8ae0f63 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -257,6 +257,10 @@ EXPORT_SYMBOL_GPL(driver_register);
  */
 void driver_unregister(struct device_driver *drv)
 {
+	if (!drv || !drv->p) {
+		WARN(1, "Unexpected driver unregister!\n");
+		return;
+	}
 	driver_remove_groups(drv, drv->groups);
 	bus_remove_driver(drv);
 }
-- 
1.6.3

