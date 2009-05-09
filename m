Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbZEIDcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbZEIDcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbZEIDaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:30:09 -0400
Received: from kroah.org ([198.145.64.141]:41402 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbZEIDaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:30:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] Staging: rtl8187se: Fix compilation warnings and procfs directory leak
Date: Fri,  8 May 2009 20:26:52 -0700
Message-Id: <1241839613-9243-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032443.GC9000@kroah.com>
References: <20090509032443.GC9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

Fix some warnings during compilation and correct a programming error
that was leaking a directory in /proc.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Bernhard Schiffner <bernhard@schiffner-limbach.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8187se/r8180.h      |    2 +-
 drivers/staging/rtl8187se/r8180_core.c |   46 +++++--------------------------
 2 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 12215fc..db446b7 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -19,7 +19,7 @@
 #define R8180H
 
 
-#define RTL8180_MODULE_NAME "rtl8180"
+#define RTL8180_MODULE_NAME "r8180"
 #define DMESG(x,a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
 #define DMESGW(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": WW:" x "\n", ## a)
 #define DMESGE(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": EE:" x "\n", ## a)
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 6ecd12d..e10413c 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -640,11 +640,9 @@ void rtl8180_proc_init_one(struct net_device *dev)
 {
 	struct proc_dir_entry *e;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	priv->dir_dev = create_proc_entry(dev->name,
-					  S_IFDIR | S_IRUGO | S_IXUGO,
-					  rtl8180_proc);
+	priv->dir_dev = rtl8180_proc;
 	if (!priv->dir_dev) {
-		DMESGE("Unable to initialize /proc/net/rtl8180/%s\n",
+		DMESGE("Unable to initialize /proc/net/r8180/%s\n",
 		      dev->name);
 		return;
 	}
@@ -654,7 +652,7 @@ void rtl8180_proc_init_one(struct net_device *dev)
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/stats-hw\n",
+		      "/proc/net/r8180/%s/stats-hw\n",
 		      dev->name);
 	}
 
@@ -663,7 +661,7 @@ void rtl8180_proc_init_one(struct net_device *dev)
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/stats-rx\n",
+		      "/proc/net/r8180/%s/stats-rx\n",
 		      dev->name);
 	}
 
@@ -673,7 +671,7 @@ void rtl8180_proc_init_one(struct net_device *dev)
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/stats-tx\n",
+		      "/proc/net/r8180/%s/stats-tx\n",
 		      dev->name);
 	}
 	#if 0
@@ -702,7 +700,7 @@ void rtl8180_proc_init_one(struct net_device *dev)
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/registers\n",
+		      "/proc/net/r8180/%s/registers\n",
 		      dev->name);
 	}
 }
@@ -977,13 +975,6 @@ void check_tx_ring(struct net_device *dev, int pri)
 			      *tmp & (1<<15)? "ok": "err", *(tmp+4));
 	}
 
-	DMESG("nic at %d",
-		(nic-nicbegin) / 8 /4);
-	DMESG("tail at %d", ((int)tail - (int)begin) /8 /4);
-	DMESG("head at %d", ((int)head - (int)begin) /8 /4);
-	DMESG("check free desc returns %d", check_nic_enought_desc(dev,pri));
-	DMESG("free desc is %d\n", get_curr_tx_free_desc(dev,pri));
-	//rtl8180_reset(dev);
 	return;
 }
 
@@ -1736,17 +1727,7 @@ short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
 		 * descriptor's buffer must be 256 byte aligned
 		 * we shouldn't be here, since we set DMA mask !
 		 */
-		DMESGW("Fixing TX alignment");
-		desc = (u32*)((u8*)desc + 256);
-#if (defined(CONFIG_HIGHMEM64G) || defined(CONFIG_64BIT_PHYS_ADDR))
-		desc = (u32*)((u64)desc &~ 0xff);
-		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
-		dma_desc = (dma_addr_t)((u64)dma_desc &~ 0xff);
-#else
-		desc = (u32*)((u32)desc &~ 0xff);
-		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
-		dma_desc = (dma_addr_t)((u32)dma_desc &~ 0xff);
-#endif
+		WARN(1, "DMA buffer is not aligned\n");
 	}
 	tmp=desc;
 	for (i=0;i<count;i++)
@@ -1984,18 +1965,7 @@ short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 		 * descriptor's buffer must be 256 byte aligned
 		 * should never happen since we specify the DMA mask
 		 */
-
-		DMESGW("Fixing RX alignment");
-		desc = (u32*)((u8*)desc + 256);
-#if (defined(CONFIG_HIGHMEM64G) || defined(CONFIG_64BIT_PHYS_ADDR))
-		desc = (u32*)((u64)desc &~ 0xff);
-		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
-		dma_desc = (dma_addr_t)((u64)dma_desc &~ 0xff);
-#else
-		desc = (u32*)((u32)desc &~ 0xff);
-		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
-		dma_desc = (dma_addr_t)((u32)dma_desc &~ 0xff);
-#endif
+		WARN(1, "DMA buffer is not aligned\n");
 	}
 
 	priv->rxring=desc;
-- 
1.6.3

