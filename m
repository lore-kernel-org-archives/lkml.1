Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbYACFxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYACFxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYACFxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:53:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:44341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYACFxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:53:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=w7bppz5wTHXi21abIA6uDkhLPNFDMCtwMghJ1sRlNS4JOXCwhdla8tlJU4ObOpx4iILoDPJF3X4YQngnXAXtZRwic3/Blv2nkOfgY0SyfkXCi2YdZt9XF+tZ7pDxVMMJafM8jcK4u98Z+LGuOUTPcwaEUF95RBefhDX4Y3fUcxI=
Date: Thu, 3 Jan 2008 13:56:38 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: krh@redhat.com, stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] ieee1394 :convert semaphore to mutex in struct class
Message-ID: <20080103055638.GD4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
---
drivers/ieee1394/nodemgr.c |   40 ++++++++++++++++++++--------------------
1 file changed, 20 insertions(+), 20 deletions(-)

diff -upr linux/drivers/ieee1394/nodemgr.c linux.new/drivers/ieee1394/nodemgr.c
--- linux/drivers/ieee1394/nodemgr.c	2007-12-28 10:11:14.000000000 +0800
+++ linux.new/drivers/ieee1394/nodemgr.c	2008-01-03 09:37:23.000000000 +0800
@@ -733,16 +733,16 @@ static void nodemgr_remove_uds(struct no
 	struct unit_directory *tmp, *ud;
 
 	/* Iteration over nodemgr_ud_class.devices has to be protected by
-	 * nodemgr_ud_class.sem, but device_unregister() will eventually
-	 * take nodemgr_ud_class.sem too. Therefore pick out one ud at a time,
-	 * release the semaphore, and then unregister the ud. Since this code
+	 * nodemgr_ud_class.mutex, but device_unregister() will eventually
+	 * take nodemgr_ud_class.mutex too. Therefore pick out one ud at a time,
+	 * unlock the mutex, and then unregister the ud. Since this code
 	 * may be called from other contexts besides the knodemgrds, protect the
-	 * gap after release of the semaphore by nodemgr_serialize_remove_uds.
+	 * gap after unlock of the mutex by nodemgr_serialize_remove_uds.
 	 */
 	mutex_lock(&nodemgr_serialize_remove_uds);
 	for (;;) {
 		ud = NULL;
-		down(&nodemgr_ud_class.sem);
+		mutex_lock(&nodemgr_ud_class.mutex);
 		list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 			tmp = container_of(dev, struct unit_directory,
 					   unit_dev);
@@ -751,7 +751,7 @@ static void nodemgr_remove_uds(struct no
 				break;
 			}
 		}
-		up(&nodemgr_ud_class.sem);
+		mutex_unlock(&nodemgr_ud_class.mutex);
 		if (ud == NULL)
 			break;
 		device_unregister(&ud->unit_dev);
@@ -888,7 +888,7 @@ static struct node_entry *find_entry_by_
 	struct device *dev;
 	struct node_entry *ne, *ret_ne = NULL;
 
-	down(&nodemgr_ne_class.sem);
+	mutex_lock(&nodemgr_ne_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
 		ne = container_of(dev, struct node_entry, node_dev);
 
@@ -897,7 +897,7 @@ static struct node_entry *find_entry_by_
 			break;
 		}
 	}
-	up(&nodemgr_ne_class.sem);
+	mutex_unlock(&nodemgr_ne_class.mutex);
 
 	return ret_ne;
 }
@@ -909,7 +909,7 @@ static struct node_entry *find_entry_by_
 	struct device *dev;
 	struct node_entry *ne, *ret_ne = NULL;
 
-	down(&nodemgr_ne_class.sem);
+	mutex_lock(&nodemgr_ne_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
 		ne = container_of(dev, struct node_entry, node_dev);
 
@@ -918,7 +918,7 @@ static struct node_entry *find_entry_by_
 			break;
 		}
 	}
-	up(&nodemgr_ne_class.sem);
+	mutex_unlock(&nodemgr_ne_class.mutex);
 
 	return ret_ne;
 }
@@ -1384,7 +1384,7 @@ static void nodemgr_suspend_ne(struct no
 	ne->in_limbo = 1;
 	WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
 
-	down(&nodemgr_ud_class.sem);
+	mutex_lock(&nodemgr_ud_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 		ud = container_of(dev, struct unit_directory, unit_dev);
 		if (ud->ne != ne)
@@ -1404,7 +1404,7 @@ static void nodemgr_suspend_ne(struct no
 			device_release_driver(&ud->device);
 		put_driver(drv);
 	}
-	up(&nodemgr_ud_class.sem);
+	mutex_unlock(&nodemgr_ud_class.mutex);
 }
 
 
@@ -1417,7 +1417,7 @@ static void nodemgr_resume_ne(struct nod
 	ne->in_limbo = 0;
 	device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
 
-	down(&nodemgr_ud_class.sem);
+	mutex_lock(&nodemgr_ud_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 		ud = container_of(dev, struct unit_directory, unit_dev);
 		if (ud->ne != ne)
@@ -1434,7 +1434,7 @@ static void nodemgr_resume_ne(struct nod
 		}
 		put_driver(drv);
 	}
-	up(&nodemgr_ud_class.sem);
+	mutex_unlock(&nodemgr_ud_class.mutex);
 
 	HPSB_DEBUG("Node resumed: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
 		   NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
@@ -1449,7 +1449,7 @@ static void nodemgr_update_pdrv(struct n
 	struct hpsb_protocol_driver *pdrv;
 	int error;
 
-	down(&nodemgr_ud_class.sem);
+	mutex_lock(&nodemgr_ud_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
 		ud = container_of(dev, struct unit_directory, unit_dev);
 		if (ud->ne != ne)
@@ -1470,7 +1470,7 @@ static void nodemgr_update_pdrv(struct n
 			device_release_driver(&ud->device);
 		put_driver(drv);
 	}
-	up(&nodemgr_ud_class.sem);
+	mutex_unlock(&nodemgr_ud_class.mutex);
 }
 
 
@@ -1545,7 +1545,7 @@ static void nodemgr_node_probe(struct ho
 	 * while probes are time-consuming. (Well, those probes need some
 	 * improvement...) */
 
-	down(&nodemgr_ne_class.sem);
+	mutex_lock(&nodemgr_ne_class.mutex);
 	list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
 		ne = container_of(dev, struct node_entry, node_dev);
 		if (!ne->needs_probe)
@@ -1556,7 +1556,7 @@ static void nodemgr_node_probe(struct ho
 		if (ne->needs_probe)
 			nodemgr_probe_ne(hi, ne, generation);
 	}
-	up(&nodemgr_ne_class.sem);
+	mutex_unlock(&nodemgr_ne_class.mutex);
 
 
 	/* If we had a bus reset while we were scanning the bus, it is
@@ -1775,14 +1775,14 @@ int nodemgr_for_each_host(void *data, in
 	struct hpsb_host *host;
 	int error = 0;
 
-	down(&hpsb_host_class.sem);
+	mutex_lock(&hpsb_host_class.mutex);
 	list_for_each_entry(dev, &hpsb_host_class.devices, node) {
 		host = container_of(dev, struct hpsb_host, host_dev);
 
 		if ((error = cb(host, data)))
 			break;
 	}
-	up(&hpsb_host_class.sem);
+	mutex_unlock(&hpsb_host_class.mutex);
 
 	return error;
 }
