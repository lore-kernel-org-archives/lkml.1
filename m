Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbXLCPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbXLCPtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXLCPtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:49:35 -0500
Received: from homer.mvista.com ([63.81.120.158]:4593 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750806AbXLCPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:49:35 -0500
Message-Id: <20071203153834.972501159@mvista.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Dec 2007 07:38:34 -0800
Message-Id: <20071203153743.119714913@mvista.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Dec 2007 07:37:43 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Cc: linux@bohmer.net
Cc: jonathan@jonmasters.org
Subject: [PATCH] isapnp driver semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the isapnp semaphore to a mutex.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 drivers/pnp/interface.c |   11 ++++++-----
 drivers/pnp/manager.c   |   19 ++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

Index: linux-2.6.23/drivers/pnp/interface.c
===================================================================
--- linux-2.6.23.orig/drivers/pnp/interface.c
+++ linux-2.6.23/drivers/pnp/interface.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #include "base.h"
@@ -315,7 +316,7 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
-extern struct semaphore pnp_res_mutex;
+extern struct mutex pnp_res_mutex;
 
 static ssize_t
 pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
@@ -361,10 +362,10 @@ pnp_set_current_resources(struct device 
 		goto done;
 	}
 	if (!strnicmp(buf, "get", 3)) {
-		down(&pnp_res_mutex);
+		mutex_lock(&pnp_res_mutex);
 		if (pnp_can_read(dev))
 			dev->protocol->get(dev, &dev->res);
-		up(&pnp_res_mutex);
+		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
@@ -373,7 +374,7 @@ pnp_set_current_resources(struct device 
 			goto done;
 		buf += 3;
 		pnp_init_resource_table(&dev->res);
-		down(&pnp_res_mutex);
+		mutex_lock(&pnp_res_mutex);
 		while (1) {
 			while (isspace(*buf))
 				++buf;
@@ -455,7 +456,7 @@ pnp_set_current_resources(struct device 
 			}
 			break;
 		}
-		up(&pnp_res_mutex);
+		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
 
Index: linux-2.6.23/drivers/pnp/manager.c
===================================================================
--- linux-2.6.23.orig/drivers/pnp/manager.c
+++ linux-2.6.23/drivers/pnp/manager.c
@@ -12,9 +12,10 @@
 #include <linux/pnp.h>
 #include <linux/slab.h>
 #include <linux/bitmap.h>
+#include <linux/mutex.h>
 #include "base.h"
 
-DECLARE_MUTEX(pnp_res_mutex);
+DEFINE_MUTEX(pnp_res_mutex);
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
@@ -297,7 +298,7 @@ static int pnp_assign_resources(struct p
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
 
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
 	if (dev->independent) {
 		port = dev->independent->port;
@@ -366,12 +367,12 @@ static int pnp_assign_resources(struct p
 	} else if (dev->dependent)
 		goto fail;
 
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	return 1;
 
 fail:
 	pnp_clean_resource_table(&dev->res);
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	return 0;
 }
 
@@ -396,7 +397,7 @@ int pnp_manual_config_dev(struct pnp_dev
 		return -ENOMEM;
 	*bak = dev->res;
 
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	dev->res = *res;
 	if (!(mode & PNP_CONFIG_FORCE)) {
 		for (i = 0; i < PNP_MAX_PORT; i++) {
@@ -416,14 +417,14 @@ int pnp_manual_config_dev(struct pnp_dev
 				goto fail;
 		}
 	}
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 
 	kfree(bak);
 	return 0;
 
 fail:
 	dev->res = *bak;
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	kfree(bak);
 	return -EINVAL;
 }
@@ -547,9 +548,9 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	dev->active = 0;
 
 	/* release the resources so that other devices can use them */
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 
 	return 1;
 }
-- 

-- 
