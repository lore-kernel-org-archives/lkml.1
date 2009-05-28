Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZE1PVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZE1PVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZE1PUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:20:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3214 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZE1PUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:20:40 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KKD19Y-02-Y9D-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] dma-debug: add variables and checks for driver filter
Date: Thu, 28 May 2009 17:19:28 +0200
Message-ID: <1243523971-12681-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 May 2009 15:19:34.0373 (UTC) FILETIME=[B4DDB150:01C9DFA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the state variables for the driver filter and a function
to check if the filter is enabled and matches to the current device. The
check is built into the err_printk function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index cdd205d..e953270 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -99,6 +99,15 @@ static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
 
+/* per-driver filter related state */
+
+#define NAME_MAX_LEN	64
+
+static char                  current_driver_name[NAME_MAX_LEN] __read_mostly;
+static struct device_driver *current_driver                    __read_mostly;
+
+static DEFINE_RWLOCK(driver_name_lock);
+
 static const char *type2name[4] = { "single", "page",
 				    "scather-gather", "coherent" };
 
@@ -128,9 +137,47 @@ static inline void dump_entry_trace(struct dma_debug_entry *entry)
 #endif
 }
 
+static inline bool driver_filter(struct device *dev)
+{
+	/* driver filter off */
+	if (likely(!current_driver_name[0]))
+		return true;
+
+	/* driver filter on and initialized */
+	if (current_driver && dev->driver == current_driver)
+		return true;
+
+	/* driver filter on but not yet initialized */
+	if (!current_driver && current_driver_name[0]) {
+		struct device_driver *drv = get_driver(dev->driver);
+		unsigned long flags;
+		bool ret = false;
+
+		if (!drv)
+			return false;
+
+		/* lock to protect against change of current_driver_name */
+		read_lock_irqsave(&driver_name_lock, flags);
+
+		if (drv->name &&
+		    strncmp(current_driver_name, drv->name, 63) == 0) {
+			current_driver = drv;
+			ret = true;
+		}
+
+		read_unlock_irqrestore(&driver_name_lock, flags);
+		put_driver(drv);
+
+		return ret;
+	}
+
+	return false;
+}
+
 #define err_printk(dev, entry, format, arg...) do {		\
 		error_count += 1;				\
-		if (show_all_errors || show_num_errors > 0) {	\
+		if (driver_filter(dev) &&			\
+		    (show_all_errors || show_num_errors > 0)) {	\
 			WARN(1, "%s %s: " format,		\
 			     dev_driver_string(dev),		\
 			     dev_name(dev) , ## arg);		\
-- 
1.6.3.1


