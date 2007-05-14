Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbXENJIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbXENJIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXENJIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:08:25 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:56419
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755301AbXENJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:08:24 -0400
Date: Mon, 14 May 2007 11:11:00 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Markus.Lidel@shadowconnect.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/5] Use mutexes instead of semaphores in I2O driver
Message-ID: <20070514091100.GG29206@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Markus.Lidel@shadowconnect.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070514090256.GF29206@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514090256.GF29206@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The I2O driver uses two semaphores as mutexes. Use the mutex API
instead of the (binary) semaphores.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index b9df143..80e35e8 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -62,7 +62,7 @@ int i2o_device_claim(struct i2o_device *dev)
 {
 	int rc = 0;
 
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 
 	rc = i2o_device_issue_claim(dev, I2O_CMD_UTIL_CLAIM, I2O_CLAIM_PRIMARY);
 	if (!rc)
@@ -72,7 +72,7 @@ int i2o_device_claim(struct i2o_device *dev)
 		pr_debug("i2o: claim of device %d failed %d\n",
 			 dev->lct_data.tid, rc);
 
-	up(&dev->lock);
+	mutex_unlock(&dev->lock);
 
 	return rc;
 }
@@ -96,7 +96,7 @@ int i2o_device_claim_release(struct i2o_device *dev)
 	int tries;
 	int rc = 0;
 
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 
 	/*
 	 *      If the controller takes a nonblocking approach to
@@ -118,7 +118,7 @@ int i2o_device_claim_release(struct i2o_device *dev)
 		pr_debug("i2o: claim release of device %d failed %d\n",
 			 dev->lct_data.tid, rc);
 
-	up(&dev->lock);
+	mutex_unlock(&dev->lock);
 
 	return rc;
 }
@@ -198,7 +198,7 @@ static struct i2o_device *i2o_device_alloc(void)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&dev->list);
-	init_MUTEX(&dev->lock);
+	mutex_init(&dev->lock);
 
 	dev->device.bus = &i2o_bus_type;
 	dev->device.release = &i2o_device_release;
@@ -326,7 +326,7 @@ int i2o_device_parse_lct(struct i2o_controller *c)
 	u16 table_size;
 	u32 buf;
 
-	down(&c->lct_lock);
+	mutex_lock(&c->lct_lock);
 
 	kfree(c->lct);
 
@@ -335,7 +335,7 @@ int i2o_device_parse_lct(struct i2o_controller *c)
 
 	lct = c->lct = kmalloc(table_size * 4, GFP_KERNEL);
 	if (!lct) {
-		up(&c->lct_lock);
+		mutex_unlock(&c->lct_lock);
 		return -ENOMEM;
 	}
 
@@ -408,7 +408,7 @@ int i2o_device_parse_lct(struct i2o_controller *c)
 			i2o_device_remove(dev);
 	}
 
-	up(&c->lct_lock);
+	mutex_unlock(&c->lct_lock);
 
 	return 0;
 }
diff --git a/drivers/message/i2o/exec-osm.c b/drivers/message/i2o/exec-osm.c
index 5278aad..c13b932 100644
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -537,7 +537,7 @@ static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
 	struct device *dev;
 	struct i2o_message *msg;
 
-	down(&c->lct_lock);
+	mutex_lock(&c->lct_lock);
 
 	dev = &c->pdev->dev;
 
@@ -561,7 +561,7 @@ static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
 
 	i2o_msg_post(c, msg);
 
-	up(&c->lct_lock);
+	mutex_unlock(&c->lct_lock);
 
 	return 0;
 };
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 3305c12..a1ec16a 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -1067,7 +1067,7 @@ struct i2o_controller *i2o_iop_alloc(void)
 
 	INIT_LIST_HEAD(&c->devices);
 	spin_lock_init(&c->lock);
-	init_MUTEX(&c->lct_lock);
+	mutex_init(&c->lct_lock);
 
 	device_initialize(&c->device);
 
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 52f53e2..333a370 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>	/* work_struct */
 #include <linux/mempool.h>
+#include <linux/mutex.h>
 
 #include <asm/io.h>
 #include <asm/semaphore.h>	/* Needed for MUTEX init macros */
@@ -425,7 +426,7 @@ struct i2o_device {
 
 	struct device device;
 
-	struct semaphore lock;	/* device lock */
+	struct mutex lock;	/* device lock */
 };
 
 /*
@@ -544,7 +545,7 @@ struct i2o_controller {
 	struct i2o_dma hrt;	/* HW Resource Table */
 	i2o_lct *lct;		/* Logical Config Table */
 	struct i2o_dma dlct;	/* Temp LCT */
-	struct semaphore lct_lock;	/* Lock for LCT updates */
+	struct mutex lct_lock;	/* Lock for LCT updates */
 	struct i2o_dma status_block;	/* IOP status block */
 
 	struct i2o_io base;	/* controller messaging unit */

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

          Dreams and reality are opposites. Action synthesizes them
                             (Assata Shakur)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
