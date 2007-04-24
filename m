Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXDXUm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXDXUm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXDXUm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:42:28 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:51182
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754529AbXDXUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:42:27 -0400
Date: Tue, 24 Apr 2007 22:45:25 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in DMA pool handler
Message-ID: <20070424204524.GI6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the DMA pool handler uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/base/dmapool.c b/drivers/base/dmapool.c
index cd467c9..9406259 100644
--- a/drivers/base/dmapool.c
+++ b/drivers/base/dmapool.c
@@ -37,7 +37,7 @@ struct dma_page {	/* cacheable header for 'allocation' bytes */
 
 #define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
 
-static DECLARE_MUTEX (pools_lock);
+static DEFINE_MUTEX (pools_lock);
 
 static ssize_t
 show_pools (struct device *dev, struct device_attribute *attr, char *buf)
@@ -55,7 +55,7 @@ show_pools (struct device *dev, struct device_attribute *attr, char *buf)
 	size -= temp;
 	next += temp;
 
-	down (&pools_lock);
+	mutex_lock(&pools_lock);
 	list_for_each_entry(pool, &dev->dma_pools, pools) {
 		unsigned pages = 0;
 		unsigned blocks = 0;
@@ -73,7 +73,7 @@ show_pools (struct device *dev, struct device_attribute *attr, char *buf)
 		size -= temp;
 		next += temp;
 	}
-	up (&pools_lock);
+	mutex_unlock(&pools_lock);
 
 	return PAGE_SIZE - size;
 }
@@ -143,7 +143,7 @@ dma_pool_create (const char *name, struct device *dev,
 	if (dev) {
 		int ret;
 
-		down (&pools_lock);
+		mutex_lock(&pools_lock);
 		if (list_empty (&dev->dma_pools))
 			ret = device_create_file (dev, &dev_attr_pools);
 		else
@@ -155,7 +155,7 @@ dma_pool_create (const char *name, struct device *dev,
 			kfree(retval);
 			retval = NULL;
 		}
-		up (&pools_lock);
+		mutex_unlock(&pools_lock);
 	} else
 		INIT_LIST_HEAD (&retval->pools);
 
@@ -231,11 +231,11 @@ pool_free_page (struct dma_pool *pool, struct dma_page *page)
 void
 dma_pool_destroy (struct dma_pool *pool)
 {
-	down (&pools_lock);
+	mutex_lock(&pools_lock);
 	list_del (&pool->pools);
 	if (pool->dev && list_empty (&pool->dev->dma_pools))
 		device_remove_file (pool->dev, &dev_attr_pools);
-	up (&pools_lock);
+	mutex_unlock(&pools_lock);
 
 	while (!list_empty (&pool->page_list)) {
 		struct dma_page		*page;

-- 

 Someone has said that it requires less mental effort to condemn than to think
                             (Emma Goldman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
                                                                  `-
