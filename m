Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZFHOgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZFHOgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZFHOfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:35:03 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42114 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbZFHOfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:35:01 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KKXCHZ-01-S5K-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] dma-debug: simplify logic in driver_filter()
Date: Mon, 8 Jun 2009 16:34:10 +0200
Message-ID: <1244471650-4632-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Jun 2009 14:34:14.0835 (UTC) FILETIME=[32706030:01C9E846]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the driver_filter function more readable by
reorganizing the code. The removal of a code code block to an upper
indentation level makes hard-to-read line-wraps unnecessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 27b369d..ad65fc0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -147,6 +147,10 @@ static inline void dump_entry_trace(struct dma_debug_entry *entry)
 
 static bool driver_filter(struct device *dev)
 {
+	struct device_driver *drv;
+	unsigned long flags;
+	bool ret;
+
 	/* driver filter off */
 	if (likely(!current_driver_name[0]))
 		return true;
@@ -155,32 +159,28 @@ static bool driver_filter(struct device *dev)
 	if (current_driver && dev->driver == current_driver)
 		return true;
 
-	/* driver filter on but not yet initialized */
-	if (!current_driver && current_driver_name[0]) {
-		struct device_driver *drv = get_driver(dev->driver);
-		unsigned long flags;
-		bool ret = false;
-
-		if (!drv)
-			return false;
-
-		/* lock to protect against change of current_driver_name */
-		read_lock_irqsave(&driver_name_lock, flags);
+	if (current_driver || !current_driver_name[0])
+		return false;
 
-		if (drv->name &&
-		    strncmp(current_driver_name, drv->name,
-			    NAME_MAX_LEN-1) == 0) {
-			current_driver = drv;
-			ret = true;
-		}
+	/* driver filter on but not yet initialized */
+	drv = get_driver(dev->driver);
+	if (!drv)
+		return false;
 
-		read_unlock_irqrestore(&driver_name_lock, flags);
-		put_driver(drv);
+	/* lock to protect against change of current_driver_name */
+	read_lock_irqsave(&driver_name_lock, flags);
 
-		return ret;
+	ret = false;
+	if (drv->name &&
+	    strncmp(current_driver_name, drv->name, NAME_MAX_LEN - 1) == 0) {
+		current_driver = drv;
+		ret = true;
 	}
 
-	return false;
+	read_unlock_irqrestore(&driver_name_lock, flags);
+	put_driver(drv);
+
+	return ret;
 }
 
 #define err_printk(dev, entry, format, arg...) do {		\
-- 
1.6.3.1


