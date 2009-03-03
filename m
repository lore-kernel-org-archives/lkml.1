Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbZCCHfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbZCCHfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZCCHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:34:53 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:10394 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZCCHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:34:52 -0500
Date: Tue, 3 Mar 2009 08:34:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, David Howells <dhowells@redhat.com>
Subject: [PATCH] Add to_delayed_work macro
Message-ID: <20090303083440.57df68c3@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a fairly common operation to have a pointer to a work and to
need a pointer to the delayed work it is contained in. In particular,
all delayed works which want to rearm themselves will have to do that.
So it would seem fair to offer a helper macro for this operation.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 arch/powerpc/kernel/vio.c                               |    2 +-
 drivers/crypto/hifn_795x.c                              |    2 +-
 drivers/input/mouse/hgpk.c                              |    2 +-
 drivers/net/dm9000.c                                    |    2 +-
 drivers/net/mlx4/en_netdev.c                            |    2 +-
 drivers/net/mlx4/en_rx.c                                |    2 +-
 drivers/s390/scsi/zfcp_fc.c                             |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    8 ++++----
 drivers/staging/rtl8187se/r8180_core.c                  |    8 ++++----
 drivers/staging/rtl8187se/r8180_dm.c                    |    6 +++---
 drivers/usb/wusbcore/devconnect.c                       |    2 +-
 include/linux/workqueue.h                               |    2 ++
 mm/slab.c                                               |    3 +--
 13 files changed, 22 insertions(+), 21 deletions(-)

--- linux-2.6.29-rc6.orig/arch/powerpc/kernel/vio.c	2009-01-29 08:27:18.000000000 +0100
+++ linux-2.6.29-rc6/arch/powerpc/kernel/vio.c	2009-03-03 07:41:23.000000000 +0100
@@ -482,7 +482,7 @@ static void vio_cmo_balance(struct work_
 	cmo->excess.size = cmo->entitled - cmo->reserve.size;
 	cmo->excess.free = cmo->excess.size - need;
 
-	cancel_delayed_work(container_of(work, struct delayed_work, work));
+	cancel_delayed_work(to_delayed_work(work));
 	spin_unlock_irqrestore(&vio_cmo.lock, flags);
 }
 
--- linux-2.6.29-rc6.orig/drivers/crypto/hifn_795x.c	2009-01-11 10:57:16.000000000 +0100
+++ linux-2.6.29-rc6/drivers/crypto/hifn_795x.c	2009-03-03 07:41:23.000000000 +0100
@@ -1882,7 +1882,7 @@ static void hifn_clear_rings(struct hifn
 
 static void hifn_work(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(work);
 	struct hifn_device *dev = container_of(dw, struct hifn_device, work);
 	unsigned long flags;
 	int reset = 0;
--- linux-2.6.29-rc6.orig/drivers/input/mouse/hgpk.c	2009-01-11 10:57:21.000000000 +0100
+++ linux-2.6.29-rc6/drivers/input/mouse/hgpk.c	2009-03-03 07:41:23.000000000 +0100
@@ -381,7 +381,7 @@ static void hgpk_disconnect(struct psmou
 
 static void hgpk_recalib_work(struct work_struct *work)
 {
-	struct delayed_work *w = container_of(work, struct delayed_work, work);
+	struct delayed_work *w = to_delayed_work(work);
 	struct hgpk_data *priv = container_of(w, struct hgpk_data, recalib_wq);
 	struct psmouse *psmouse = priv->psmouse;
 
--- linux-2.6.29-rc6.orig/drivers/net/dm9000.c	2009-01-11 10:57:25.000000000 +0100
+++ linux-2.6.29-rc6/drivers/net/dm9000.c	2009-03-03 07:41:23.000000000 +0100
@@ -559,7 +559,7 @@ static void dm9000_show_carrier(board_in
 static void
 dm9000_poll_work(struct work_struct *w)
 {
-	struct delayed_work *dw = container_of(w, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(w);
 	board_info_t *db = container_of(dw, board_info_t, phy_poll);
 	struct net_device *ndev = db->ndev;
 
--- linux-2.6.29-rc6.orig/drivers/net/mlx4/en_netdev.c	2009-01-17 09:06:20.000000000 +0100
+++ linux-2.6.29-rc6/drivers/net/mlx4/en_netdev.c	2009-03-03 07:41:23.000000000 +0100
@@ -505,7 +505,7 @@ out:
 
 static void mlx4_en_do_get_stats(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
+	struct delayed_work *delay = to_delayed_work(work);
 	struct mlx4_en_priv *priv = container_of(delay, struct mlx4_en_priv,
 						 stats_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
--- linux-2.6.29-rc6.orig/drivers/net/mlx4/en_rx.c	2009-01-11 10:57:26.000000000 +0100
+++ linux-2.6.29-rc6/drivers/net/mlx4/en_rx.c	2009-03-03 07:41:23.000000000 +0100
@@ -298,7 +298,7 @@ static void mlx4_en_free_rx_buf(struct m
 
 void mlx4_en_rx_refill(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
+	struct delayed_work *delay = to_delayed_work(work);
 	struct mlx4_en_priv *priv = container_of(delay, struct mlx4_en_priv,
 						 refill_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
--- linux-2.6.29-rc6.orig/drivers/s390/scsi/zfcp_fc.c	2009-01-11 10:57:32.000000000 +0100
+++ linux-2.6.29-rc6/drivers/s390/scsi/zfcp_fc.c	2009-03-03 07:41:23.000000000 +0100
@@ -94,7 +94,7 @@ static int zfcp_wka_port_get(struct zfcp
 
 static void zfcp_wka_port_offline(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(work);
 	struct zfcp_wka_port *wka_port =
 			container_of(dw, struct zfcp_wka_port, work);
 
--- linux-2.6.29-rc6.orig/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c	2009-01-11 10:57:37.000000000 +0100
+++ linux-2.6.29-rc6/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c	2009-03-03 07:41:23.000000000 +0100
@@ -719,7 +719,7 @@ void ieee80211_softmac_scan(struct ieee8
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
 #else
 void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
@@ -777,7 +777,7 @@ out:
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
-        struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, softmac_scan_wq);
 #else
 void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
@@ -2980,7 +2980,7 @@ void ieee80211_start_monitor_mode(struct
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_start_ibss_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, start_ibss_wq);
 #else
 void ieee80211_start_ibss_wq(struct ieee80211_device *ieee)
@@ -3162,7 +3162,7 @@ void ieee80211_disassociate(struct ieee8
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_retry_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
 #else
 void ieee80211_associate_retry_wq(struct ieee80211_device *ieee)
--- linux-2.6.29-rc6.orig/drivers/staging/rtl8187se/r8180_core.c	2009-03-02 08:44:13.000000000 +0100
+++ linux-2.6.29-rc6/drivers/staging/rtl8187se/r8180_core.c	2009-03-03 07:41:23.000000000 +0100
@@ -5438,7 +5438,7 @@ void rtl8180_hw_wakeup_wq (struct work_s
 //	struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //	struct ieee80211_device * ieee = (struct ieee80211_device*)
 //	                                       container_of(work, struct ieee80211_device, watch_dog_wq);
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_wakeup_wq);
 	struct net_device *dev = ieee->dev;
 #else
@@ -5459,7 +5459,7 @@ void rtl8180_hw_sleep_wq (struct work_st
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_sleep_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -6407,7 +6407,7 @@ priv->txnpring)/8);
 void rtl8180_tx_irq_wq(struct work_struct *work)
 {
 	//struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+        struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device * ieee = (struct ieee80211_device*)
 	                                       container_of(dwork, struct ieee80211_device, watch_dog_wq);
 	struct net_device *dev = ieee->dev;
@@ -6691,7 +6691,7 @@ lizhaoming--------------------------- RF
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 {
-	//struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	//struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, GPIOChangeRFWorkItem.work);
 	struct net_device *dev = ieee->dev;
 	struct r8180_priv *priv = ieee80211_priv(dev);
--- linux-2.6.29-rc6.orig/drivers/staging/rtl8187se/r8180_dm.c	2009-01-11 10:57:38.000000000 +0100
+++ linux-2.6.29-rc6/drivers/staging/rtl8187se/r8180_dm.c	2009-03-03 07:41:23.000000000 +0100
@@ -132,7 +132,7 @@ void rtl8180_tx_pw_wq (struct work_struc
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,tx_pw_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -314,7 +314,7 @@ void rtl8180_hw_dig_wq (struct work_stru
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_dig_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -1250,7 +1250,7 @@ SetInitialGain:
 #if LINUX_VERSION_CODE >=KERNEL_VERSION(2,6,20)
 void rtl8180_rate_adapter(struct work_struct * work)
 {
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,rate_adapter_wq);
         struct net_device *dev = ieee->dev;
 #else
--- linux-2.6.29-rc6.orig/drivers/usb/wusbcore/devconnect.c	2009-02-09 09:44:25.000000000 +0100
+++ linux-2.6.29-rc6/drivers/usb/wusbcore/devconnect.c	2009-03-03 07:41:23.000000000 +0100
@@ -471,7 +471,7 @@ static void __wusbhc_keep_alive(struct w
  */
 static void wusbhc_keep_alive_run(struct work_struct *ws)
 {
-	struct delayed_work *dw = container_of(ws, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(ws);
 	struct wusbhc *wusbhc =	container_of(dw, struct wusbhc, keep_alive_timer);
 
 	mutex_lock(&wusbhc->mutex);
--- linux-2.6.29-rc6.orig/include/linux/workqueue.h	2009-01-29 08:27:20.000000000 +0100
+++ linux-2.6.29-rc6/include/linux/workqueue.h	2009-03-02 22:25:29.000000000 +0100
@@ -41,6 +41,8 @@ struct delayed_work {
 	struct timer_list timer;
 };
 
+#define to_delayed_work(_work)	container_of(_work, struct delayed_work, work)
+
 struct execute_work {
 	struct work_struct work;
 };
--- linux-2.6.29-rc6.orig/mm/slab.c	2009-02-14 10:49:51.000000000 +0100
+++ linux-2.6.29-rc6/mm/slab.c	2009-03-03 07:41:23.000000000 +0100
@@ -3988,8 +3988,7 @@ static void cache_reap(struct work_struc
 	struct kmem_cache *searchp;
 	struct kmem_list3 *l3;
 	int node = numa_node_id();
-	struct delayed_work *work =
-		container_of(w, struct delayed_work, work);
+	struct delayed_work *work = to_delayed_work(w);
 
 	if (!mutex_trylock(&cache_chain_mutex))
 		/* Give up. Setup the next iteration. */


-- 
Jean Delvare
