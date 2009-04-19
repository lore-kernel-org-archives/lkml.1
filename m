Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbZDSCJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbZDSCJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZDSCJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:09:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZDSCJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:09:30 -0400
Date: Sat, 18 Apr 2009 21:09:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, John W Linville <linville@tuxdriver.com>,
       bernhard@schiffner-limbach.de
Subject: [PATCH] rtl8187se staging: Fix compilation warnings and procfs
 directory leak
Message-ID: <49ea87c4.jfXxKzrtSmTK5/lF%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some warnings during compilation and correct a programming error
that was leaking a directory in /proc.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Bernhard Schiffner <bernhard@schiffner-limbach.de>
---

Greg,

Please incorporate this patch in wireless/staging as soon as is possible.
I'm not sure what the rules are concerning such changes.

I have a number of patches that clean up the vendor code; however, I think
I will hold them for the moment as they do not change the function of this
driver and only improve the readability.

I am now working on porting this driver to use mac80211 so that it may be
included in mainline.

Larry
---

Index: linux-2.6/drivers/staging/rtl8187se/r8180.h
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180.h
+++ linux-2.6/drivers/staging/rtl8187se/r8180.h
@@ -19,7 +19,7 @@
 #define R8180H
 
 
-#define RTL8180_MODULE_NAME "rtl8180"
+#define RTL8180_MODULE_NAME "r8180"
 #define DMESG(x,a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
 #define DMESGW(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": WW:" x "\n", ## a)
 #define DMESGE(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": EE:" x "\n", ## a)
Index: linux-2.6/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
+++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
@@ -640,11 +640,9 @@ void rtl8180_proc_init_one(struct net_de
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
@@ -654,7 +652,7 @@ void rtl8180_proc_init_one(struct net_de
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/stats-hw\n",
+		      "/proc/net/r8180/%s/stats-hw\n",
 		      dev->name);
 	}
 
@@ -663,7 +661,7 @@ void rtl8180_proc_init_one(struct net_de
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/stats-rx\n",
+		      "/proc/net/r8180/%s/stats-rx\n",
 		      dev->name);
 	}
 
@@ -673,7 +671,7 @@ void rtl8180_proc_init_one(struct net_de
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/stats-tx\n",
+		      "/proc/net/r8180/%s/stats-tx\n",
 		      dev->name);
 	}
 	#if 0
@@ -702,7 +700,7 @@ void rtl8180_proc_init_one(struct net_de
 
 	if (!e) {
 		DMESGE("Unable to initialize "
-		      "/proc/net/rtl8180/%s/registers\n",
+		      "/proc/net/r8180/%s/registers\n",
 		      dev->name);
 	}
 }
@@ -977,13 +975,6 @@ void check_tx_ring(struct net_device *de
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
 
@@ -1736,17 +1727,7 @@ short alloc_tx_desc_ring(struct net_devi
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
@@ -1984,18 +1965,7 @@ short alloc_rx_desc_ring(struct net_devi
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
