Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbXD0THA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbXD0THA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbXD0TFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:05:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:50788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbXD0S6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/46] Driver core: use mutex instead of semaphore in DMA pool handler
Date: Fri, 27 Apr 2007 11:53:51 -0700
Message-Id: <11777001773804-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700172258-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

the DMA pool handler uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dmapool.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

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
1.5.1.2

