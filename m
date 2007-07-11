Return-Path: <linux-kernel-owner+w=401wt.eu-S935153AbXGKXeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153AbXGKXeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934952AbXGKXdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:08 -0400
Received: from ns.suse.de ([195.135.220.2]:33565 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934946AbXGKXdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/61] sysdev: use mutex instead of semaphore
Date: Wed, 11 Jul 2007 16:31:24 -0700
Message-Id: <11841967633087-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196759393-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The sysdev code use a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 29f1291..18febe2 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -21,7 +21,7 @@
 #include <linux/string.h>
 #include <linux/pm.h>
 #include <linux/device.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 
@@ -155,7 +155,7 @@ EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
 
 static LIST_HEAD(sysdev_drivers);
-static DECLARE_MUTEX(sysdev_drivers_lock);
+static DEFINE_MUTEX(sysdev_drivers_lock);
 
 /**
  *	sysdev_driver_register - Register auxillary driver
@@ -172,7 +172,7 @@ static DECLARE_MUTEX(sysdev_drivers_lock);
 int sysdev_driver_register(struct sysdev_class * cls,
 			   struct sysdev_driver * drv)
 {
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
 
@@ -184,7 +184,7 @@ int sysdev_driver_register(struct sysdev_class * cls,
 		}
 	} else
 		list_add_tail(&drv->entry, &sysdev_drivers);
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 	return 0;
 }
 
@@ -197,7 +197,7 @@ int sysdev_driver_register(struct sysdev_class * cls,
 void sysdev_driver_unregister(struct sysdev_class * cls,
 			      struct sysdev_driver * drv)
 {
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_del_init(&drv->entry);
 	if (cls) {
 		if (drv->remove) {
@@ -207,7 +207,7 @@ void sysdev_driver_unregister(struct sysdev_class * cls,
 		}
 		kset_put(&cls->kset);
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 }
 
 EXPORT_SYMBOL_GPL(sysdev_driver_register);
@@ -246,7 +246,7 @@ int sysdev_register(struct sys_device * sysdev)
 	if (!error) {
 		struct sysdev_driver * drv;
 
-		down(&sysdev_drivers_lock);
+		mutex_lock(&sysdev_drivers_lock);
 		/* Generic notification is implicit, because it's that
 		 * code that should have called us.
 		 */
@@ -262,7 +262,7 @@ int sysdev_register(struct sys_device * sysdev)
 			if (drv->add)
 				drv->add(sysdev);
 		}
-		up(&sysdev_drivers_lock);
+		mutex_unlock(&sysdev_drivers_lock);
 	}
 	return error;
 }
@@ -271,7 +271,7 @@ void sysdev_unregister(struct sys_device * sysdev)
 {
 	struct sysdev_driver * drv;
 
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry(drv, &sysdev_drivers, entry) {
 		if (drv->remove)
 			drv->remove(sysdev);
@@ -281,7 +281,7 @@ void sysdev_unregister(struct sys_device * sysdev)
 		if (drv->remove)
 			drv->remove(sysdev);
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 
 	kobject_unregister(&sysdev->kobj);
 }
@@ -308,7 +308,7 @@ void sysdev_shutdown(void)
 
 	pr_debug("Shutting Down System Devices\n");
 
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry_reverse(cls, &system_subsys.list,
 				    kset.kobj.entry) {
 		struct sys_device * sysdev;
@@ -337,7 +337,7 @@ void sysdev_shutdown(void)
 				cls->shutdown(sysdev);
 		}
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 }
 
 static void __sysdev_resume(struct sys_device *dev)
-- 
1.5.2.2

