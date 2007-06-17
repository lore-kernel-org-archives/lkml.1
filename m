Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbXFQVsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbXFQVsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXFQVr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:47:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50491 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106AbXFQVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:47:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Jun 2007 23:47:45 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: nodemgr: parallelize between several hosts
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <tkrat.c05ce30eae2bd79e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global nodemgr_serialize mutex which enclosed most of the
host thread event loop.  This allows for parallelism between several
host adapter cards.

Properly serialize the driver hooks .update(), .suspend(), .resume(),
and .remove() by means of device->sem.  These hooks can be called from
outside the host threads' contexts.

Get() and put() the device.driver when calling its hooks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This is more or less a follow-up to some nodemgr locking changes way
back in the past and to Greg KH's "IEEE1394: remove rwsem use from
ieee1394 core", http://lkml.org/lkml/2007/4/27/419


 drivers/ieee1394/nodemgr.c |   69 +++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 26 deletions(-)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 #include <asm/atomic.h>
+#include <asm/semaphore.h>
 
 #include "csr.h"
 #include "highlevel.h"
@@ -145,8 +146,6 @@ static struct csr1212_bus_ops nodemgr_cs
  * but now we are much simpler because of the LDM.
  */
 
-static DEFINE_MUTEX(nodemgr_serialize);
-
 struct host_info {
 	struct hpsb_host *host;
 	struct list_head list;
@@ -1382,6 +1381,8 @@ static void nodemgr_suspend_ne(struct no
 {
 	struct device *dev;
 	struct unit_directory *ud;
+	struct device_driver *drv;
+	int error;
 
 	HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
 		   NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
@@ -1395,10 +1396,19 @@ static void nodemgr_suspend_ne(struct no
 		if (ud->ne != ne)
 			continue;
 
-		if (ud->device.driver &&
-		    (!ud->device.driver->suspend ||
-		      ud->device.driver->suspend(&ud->device, PMSG_SUSPEND)))
+		drv = get_driver(ud->device.driver);
+		if (!drv)
+			continue;
+
+		error = 1; /* release if suspend is not implemented */
+		if (drv->suspend) {
+			down(&ud->device.sem);
+			error = drv->suspend(&ud->device, PMSG_SUSPEND);
+			up(&ud->device.sem);
+		}
+		if (error)
 			device_release_driver(&ud->device);
+		put_driver(drv);
 	}
 	up(&nodemgr_ud_class.sem);
 }
@@ -1408,6 +1418,7 @@ static void nodemgr_resume_ne(struct nod
 {
 	struct device *dev;
 	struct unit_directory *ud;
+	struct device_driver *drv;
 
 	ne->in_limbo = 0;
 	device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
@@ -1418,8 +1429,16 @@ static void nodemgr_resume_ne(struct nod
 		if (ud->ne != ne)
 			continue;
 
-		if (ud->device.driver && ud->device.driver->resume)
-			ud->device.driver->resume(&ud->device);
+		drv = get_driver(ud->device.driver);
+		if (!drv)
+			continue;
+
+		if (drv->resume) {
+			down(&ud->device.sem);
+			drv->resume(&ud->device);
+			up(&ud->device.sem);
+		}
+		put_driver(drv);
 	}
 	up(&nodemgr_ud_class.sem);
 
@@ -1430,9 +1449,11 @@ static void nodemgr_resume_ne(struct nod
 
 static void nodemgr_update_pdrv(struct node_entry *ne)
 {
+	struct device *dev;
 	struct unit_directory *ud;
+	struct device_driver *drv;
 	struct hpsb_protocol_driver *pdrv;
-	struct device *dev;
+	int error;
 
 	down(&nodemgr_ud_class.sem);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
@@ -1440,13 +1461,20 @@ static void nodemgr_update_pdrv(struct n
 		if (ud->ne != ne)
 			continue;
 
-		if (ud->device.driver) {
-			pdrv = container_of(ud->device.driver,
-					    struct hpsb_protocol_driver,
-					    driver);
-			if (pdrv->update && pdrv->update(ud))
-				device_release_driver(&ud->device);
+		drv = get_driver(ud->device.driver);
+		if (!drv)
+			continue;
+
+		error = 0;
+		pdrv = container_of(drv, struct hpsb_protocol_driver, driver);
+		if (pdrv->update) {
+			down(&ud->device.sem);
+			error = pdrv->update(ud);
+			up(&ud->device.sem);
 		}
+		if (error)
+			device_release_driver(&ud->device);
+		put_driver(drv);
 	}
 	up(&nodemgr_ud_class.sem);
 }
@@ -1688,18 +1716,12 @@ static int nodemgr_host_thread(void *__h
 		if (kthread_should_stop())
 			goto exit;
 
-		if (mutex_lock_interruptible(&nodemgr_serialize)) {
-			if (try_to_freeze())
-				continue;
-			goto exit;
-		}
-
 		/* Pause for 1/4 second in 1/16 second intervals,
 		 * to make sure things settle down. */
 		g = get_hpsb_generation(host);
 		for (i = 0; i < 4 ; i++) {
 			if (msleep_interruptible(63) || kthread_should_stop())
-				goto unlock_exit;
+				goto exit;
 
 			/* Now get the generation in which the node ID's we collect
 			 * are valid.  During the bus scan we will use this generation
@@ -1717,7 +1739,6 @@ static int nodemgr_host_thread(void *__h
 		if (!nodemgr_check_irm_capability(host, reset_cycles) ||
 		    !nodemgr_do_irm_duties(host, reset_cycles)) {
 			reset_cycles++;
-			mutex_unlock(&nodemgr_serialize);
 			continue;
 		}
 		reset_cycles = 0;
@@ -1734,11 +1755,7 @@ static int nodemgr_host_thread(void *__h
 
 		/* Update some of our sysfs symlinks */
 		nodemgr_update_host_dev_links(host);
-
-		mutex_unlock(&nodemgr_serialize);
 	}
-unlock_exit:
-	mutex_unlock(&nodemgr_serialize);
 exit:
 	HPSB_VERBOSE("NodeMgr: Exiting thread");
 	return 0;

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/

