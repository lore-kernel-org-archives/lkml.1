Return-Path: <linux-kernel-owner+w=401wt.eu-S1764418AbXHCRkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764418AbXHCRkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764236AbXHCRir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:38:47 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37455 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762549AbXHCRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:38:43 -0400
Date: Fri, 3 Aug 2007 19:37:16 +0200 (MEST)
Message-Id: <200708031737.TAA00882@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 13/13] dev->priv to netdev_priv(dev), for drivers/net/wireless
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing accesses to dev->priv to netdev_priv(dev). The replacment
is safe when netdev_priv is used to access a private structure that is
right next to the net_device structure in memory. Cf
http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
This is the case when the net_device structure was allocated with
a call to alloc_netdev or one of its derivative.

Here is an excerpt of the semantic patch that performs the transformation

@ rule1 @
type T;
struct net_device *dev;
@@

 dev = 
(
        alloc_netdev
|         
        alloc_etherdev
|
        alloc_trdev
)
   (sizeof(T), ...)

@ rule1bis @
struct net_device *dev;
expression E;
@@
 dev->priv = E

@ rule2 depends on rule1 && !rule1bis  @
struct net_device *dev;
type rule1.T;
@@

- (T*) dev->priv
+ netdev_priv(dev)

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Cc: akpm@linux-foundation.org
---

 drivers/net/wireless/arlan-proc.c          |   14 +++---
 drivers/net/wireless/hostap/hostap_cs.c    |    2 
 drivers/net/wireless/hostap/hostap_hw.c    |    2 
 drivers/net/wireless/hostap/hostap_ioctl.c |   14 +++---
 drivers/net/wireless/orinoco_tmd.c         |    2 
 drivers/net/wireless/prism54/isl_ioctl.c   |    6 +-
 drivers/net/wireless/ray_cs.c              |   66 ++++++++++++++---------------
 drivers/net/wireless/strip.c               |    2 
 drivers/net/wireless/wl3501_cs.c           |   66 ++++++++++++++---------------
 9 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/arlan-proc.c b/drivers/net/wireless/arlan-proc.c
index 015abd9..c6e70db 100644
--- a/drivers/net/wireless/arlan-proc.c
+++ b/drivers/net/wireless/arlan-proc.c
@@ -435,7 +435,7 @@ static int arlan_sysctl_info(ctl_table *
 		goto final;
 	}
 	else
-		priva = arlan_device[devnum]->priv;
+		priva = netdev_priv(arlan_device[devnum]);
 
 	if (priva == NULL)
 	{
@@ -654,7 +654,7 @@ static int arlan_sysctl_info161719(ctl_t
 		goto final;
 	}
 	else
-		priva = arlan_device[devnum]->priv;
+		priva = netdev_priv(arlan_device[devnum]);
 	if (priva == NULL)
 	{
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
@@ -688,7 +688,7 @@ static int arlan_sysctl_infotxRing(ctl_t
 		  goto final;
 	}
 	else
-		priva = arlan_device[devnum]->priv;
+		priva = netdev_priv(arlan_device[devnum]);
 	if (priva == NULL)
 	{
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
@@ -716,7 +716,7 @@ static int arlan_sysctl_inforxRing(ctl_t
 		  pos += sprintf(arlan_drive_info + pos, "No device found here \n");
 		  goto final;
 	} else
-		priva = arlan_device[devnum]->priv;
+		priva = netdev_priv(arlan_device[devnum]);
 	if (priva == NULL)
 	{
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
@@ -745,7 +745,7 @@ static int arlan_sysctl_info18(ctl_table
 		goto final;
 	}
 	else
-		priva = arlan_device[devnum]->priv;
+		priva = netdev_priv(arlan_device[devnum]);
 	if (priva == NULL)
 	{
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
@@ -780,7 +780,7 @@ static int arlan_configure(ctl_table * c
 	}
 	else if (arlan_device[devnum] != NULL)
 	{
-		  priv = arlan_device[devnum]->priv;
+		  priv = netdev_priv(arlan_device[devnum]);
 
 		  arlan_command(arlan_device[devnum], ARLAN_COMMAND_CLEAN_AND_CONF);
 	}
@@ -805,7 +805,7 @@ static int arlan_sysctl_reset(ctl_table 
 	}
 	else if (arlan_device[devnum] != NULL)
 	{
-		priv = arlan_device[devnum]->priv;
+		priv = netdev_priv(arlan_device[devnum]);
 		arlan_command(arlan_device[devnum], ARLAN_COMMAND_CLEAN_AND_RESET);
 
 	} else
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 30e723f..f9cf22b 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -272,7 +272,7 @@ static int sandisk_enable_wireless(struc
 {
 	int res, ret = 0;
 	conf_reg_t reg;
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	tuple_t tuple;
 	cisparse_t *parse = NULL;
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 959887b..18023b5 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3424,7 +3424,7 @@ static void prism2_suspend(struct net_de
 	struct local_info *local;
 	union iwreq_data wrqu;
 
-	iface = dev->priv;
+	iface = netdev_priv(dev);
 	local = iface->local;
 
 	/* Send disconnect event, e.g., to trigger reassociation after resume
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 8c71077..d58ac84 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3088,7 +3088,7 @@ #endif /* PRISM2_DOWNLOAD_SUPPORT */
 static int prism2_set_genericelement(struct net_device *dev, u8 *elem,
 				     size_t len)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	u8 *buf;
 
@@ -3116,7 +3116,7 @@ static int prism2_ioctl_siwauth(struct n
 				struct iw_request_info *info,
 				struct iw_param *data, char *extra)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 
 	switch (data->flags & IW_AUTH_INDEX) {
@@ -3182,7 +3182,7 @@ static int prism2_ioctl_giwauth(struct n
 				struct iw_request_info *info,
 				struct iw_param *data, char *extra)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 
 	switch (data->flags & IW_AUTH_INDEX) {
@@ -3221,7 +3221,7 @@ static int prism2_ioctl_siwencodeext(str
 				     struct iw_request_info *info,
 				     struct iw_point *erq, char *extra)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
 	int i, ret = 0;
@@ -3395,7 +3395,7 @@ static int prism2_ioctl_giwencodeext(str
 				     struct iw_request_info *info,
 				     struct iw_point *erq, char *extra)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	struct ieee80211_crypt_data **crypt;
 	void *sta_ptr;
@@ -3716,7 +3716,7 @@ static int prism2_ioctl_giwgenie(struct 
 				 struct iw_request_info *info,
 				 struct iw_point *data, char *extra)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	int len = local->generic_elem_len - 2;
 
@@ -3755,7 +3755,7 @@ static int prism2_ioctl_siwmlme(struct n
 				struct iw_request_info *info,
 				struct iw_point *data, char *extra)
 {
-	struct hostap_interface *iface = dev->priv;
+	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 	u16 reason;
diff --git a/drivers/net/wireless/orinoco_tmd.c b/drivers/net/wireless/orinoco_tmd.c
index 7c7b960..b9c54d8 100644
--- a/drivers/net/wireless/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco_tmd.c
@@ -190,7 +190,7 @@ static int orinoco_tmd_init_one(struct p
 static void __devexit orinoco_tmd_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
-	struct orinoco_private *priv = dev->priv;
+	struct orinoco_private *priv = netdev_priv(dev);
 	struct orinoco_pci_card *card = priv->card;
 
 	unregister_netdev(dev);
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 585f599..f106661 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1753,7 +1753,7 @@ prism54_get_oid(struct net_device *ndev,
 	int rvalue;
 	enum oid_num_t n = dwrq->flags;
 
-	rvalue = mgt_get_request((islpci_private *) ndev->priv, n, 0, NULL, &r);
+	rvalue = mgt_get_request(netdev_priv(ndev), n, 0, NULL, &r);
 	dwrq->length = mgt_response_to_str(n, &r, extra);
 	if ((isl_oid[n].flags & OID_FLAG_TYPE) != OID_TYPE_U32)
 		kfree(r.ptr);
@@ -1766,7 +1766,7 @@ prism54_set_u32(struct net_device *ndev,
 {
 	u32 oid = uwrq[0], u = uwrq[1];
 
-	return mgt_set_request((islpci_private *) ndev->priv, oid, 0, &u);
+	return mgt_set_request(netdev_priv(ndev), oid, 0, &u);
 }
 
 static int
@@ -1775,7 +1775,7 @@ prism54_set_raw(struct net_device *ndev,
 {
 	u32 oid = dwrq->flags;
 
-	return mgt_set_request((islpci_private *) ndev->priv, oid, 0, extra);
+	return mgt_set_request(netdev_priv(ndev), oid, 0, extra);
 }
 
 void
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 3be6242..1d9dbf8 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -314,7 +314,7 @@ static int ray_probe(struct pcmcia_devic
     if (!dev)
 	    goto fail_alloc_dev;
 
-    local = dev->priv;
+    local = netdev_priv(dev);
     local->finder = p_dev;
 
     /* The io structure describes IO port mapping. None used here */
@@ -388,7 +388,7 @@ static void ray_detach(struct pcmcia_dev
 
     ray_release(link);
 
-    local = (ray_dev_t *)dev->priv;
+    local = netdev_priv(dev);
     del_timer(&local->timer);
 
     if (link->priv) {
@@ -412,7 +412,7 @@ static int ray_config(struct pcmcia_devi
     win_req_t req;
     memreq_t mem;
     struct net_device *dev = (struct net_device *)link->priv;
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
 
     DEBUG(1, "ray_config(0x%p)\n", link);
 
@@ -520,7 +520,7 @@ static int ray_init(struct net_device *d
     int i;
     UCHAR *p;
     struct ccs __iomem *pccs;
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
     DEBUG(1, "ray_init(0x%p)\n", dev);
     if (!(pcmcia_dev_present(link))) {
@@ -581,7 +581,7 @@ static int ray_init(struct net_device *d
 static int dl_startup_params(struct net_device *dev)
 {
     int ccsindex;
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct ccs __iomem *pccs;
     struct pcmcia_device *link = local->finder;
 
@@ -786,7 +786,7 @@ static void join_net(u_long data)
 static void ray_release(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv; 
-    ray_dev_t *local = dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     int i;
     
     DEBUG(1, "ray_release(0x%p)\n", link);
@@ -834,7 +834,7 @@ int ray_dev_init(struct net_device *dev)
 #ifdef RAY_IMMEDIATE_INIT
     int i;
 #endif	/* RAY_IMMEDIATE_INIT */
-    ray_dev_t *local = dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
 
     DEBUG(1,"ray_dev_init(dev=%p)\n",dev);
@@ -868,7 +868,7 @@ #endif	/* RAY_IMMEDIATE_INIT */
 /*===========================================================================*/
 static int ray_dev_config(struct net_device *dev, struct ifmap *map)
 {
-    ray_dev_t *local = dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
     /* Dummy routine to satisfy device structure */
     DEBUG(1,"ray_dev_config(dev=%p,ifmap=%p)\n",dev,map);
@@ -882,7 +882,7 @@ static int ray_dev_config(struct net_dev
 /*===========================================================================*/
 static int ray_dev_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-    ray_dev_t *local = dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
     short length = skb->len;
 
@@ -925,7 +925,7 @@ static int ray_dev_start_xmit(struct sk_
 static int ray_hw_xmit(unsigned char* data, int len, struct net_device* dev, 
                 UCHAR msg_type)
 {
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct ccs __iomem *pccs;
     int ccsindex;
     int offset;
@@ -1099,7 +1099,7 @@ static int ray_set_freq(struct net_devic
 			struct iw_freq *fwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 
 	/* Reject if card is already initialised */
@@ -1124,7 +1124,7 @@ static int ray_get_freq(struct net_devic
 			struct iw_freq *fwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	fwrq->m = local->sparm.b5.a_hop_pattern;
 	fwrq->e = 0;
@@ -1140,7 +1140,7 @@ static int ray_set_essid(struct net_devi
 			 struct iw_point *dwrq,
 			 char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	/* Reject if card is already initialised */
 	if(local->card_status != CARD_AWAITING_PARAM)
@@ -1173,7 +1173,7 @@ static int ray_get_essid(struct net_devi
 			 struct iw_point *dwrq,
 			 char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	/* Get the essid that was set */
 	memcpy(extra, local->sparm.b5.a_current_ess_id, IW_ESSID_MAX_SIZE);
@@ -1194,7 +1194,7 @@ static int ray_get_wap(struct net_device
 			struct sockaddr *awrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	memcpy(awrq->sa_data, local->bss_id, ETH_ALEN);
 	awrq->sa_family = ARPHRD_ETHER;
@@ -1211,7 +1211,7 @@ static int ray_set_rate(struct net_devic
 			struct iw_param *vwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	/* Reject if card is already initialised */
 	if(local->card_status != CARD_AWAITING_PARAM)
@@ -1240,7 +1240,7 @@ static int ray_get_rate(struct net_devic
 			struct iw_param *vwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	if(local->net_default_tx_rate == 3)
 		vwrq->value = 2000000;		/* Hum... */
@@ -1260,7 +1260,7 @@ static int ray_set_rts(struct net_device
 		       struct iw_param *vwrq,
 		       char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 	int rthr = vwrq->value;
 
 	/* Reject if card is already initialised */
@@ -1290,7 +1290,7 @@ static int ray_get_rts(struct net_device
 		       struct iw_param *vwrq,
 		       char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	vwrq->value = (local->sparm.b5.a_rts_threshold[0] << 8)
 		+ local->sparm.b5.a_rts_threshold[1];
@@ -1309,7 +1309,7 @@ static int ray_set_frag(struct net_devic
 			struct iw_param *vwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 	int fthr = vwrq->value;
 
 	/* Reject if card is already initialised */
@@ -1338,7 +1338,7 @@ static int ray_get_frag(struct net_devic
 			struct iw_param *vwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	vwrq->value = (local->sparm.b5.a_frag_threshold[0] << 8)
 		+ local->sparm.b5.a_frag_threshold[1];
@@ -1357,7 +1357,7 @@ static int ray_set_mode(struct net_devic
 			__u32 *uwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	char card_mode = 1;
 
@@ -1389,7 +1389,7 @@ static int ray_get_mode(struct net_devic
 			__u32 *uwrq,
 			char *extra)
 {
-	ray_dev_t *local = (ray_dev_t *)dev->priv;
+	ray_dev_t *local = netdev_priv(dev);
 
 	if(local->sparm.b5.a_network_type)
 		*uwrq = IW_MODE_INFRA;
@@ -1492,7 +1492,7 @@ static int ray_commit(struct net_device 
  */
 static iw_stats * ray_get_wireless_stats(struct net_device *	dev)
 {
-  ray_dev_t *	local = (ray_dev_t *) dev->priv;
+  ray_dev_t *	local = netdev_priv(dev);
   struct pcmcia_device *link = local->finder;
   struct status __iomem *p = local->sram + STATUS_BASE;
 
@@ -1580,7 +1580,7 @@ static const struct iw_handler_def	ray_h
 /*===========================================================================*/
 static int ray_open(struct net_device *dev)
 {
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link;
     link = local->finder;
     
@@ -1614,7 +1614,7 @@ static int ray_open(struct net_device *d
 /*===========================================================================*/
 static int ray_dev_close(struct net_device *dev)
 {
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link;
     link = local->finder;
 
@@ -1773,7 +1773,7 @@ static int parse_addr(char *in_str, UCHA
 /*===========================================================================*/
 static struct net_device_stats *ray_get_stats(struct net_device *dev)
 {
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
     struct status __iomem *p = local->sram + STATUS_BASE;
     if (!(pcmcia_dev_present(link))) {
@@ -1803,7 +1803,7 @@ static struct net_device_stats *ray_get_
 /*===========================================================================*/
 static void ray_update_parm(struct net_device *dev, UCHAR objid, UCHAR *value, int len)
 {
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
     int ccsindex;
     int i;
@@ -1840,7 +1840,7 @@ static void ray_update_multi_list(struct
     int ccsindex;
     struct ccs __iomem *pccs;
     int i = 0;
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     struct pcmcia_device *link = local->finder;
     void __iomem *p = local->sram + HOST_TO_ECF_BASE;
 
@@ -1884,7 +1884,7 @@ static void ray_update_multi_list(struct
 /*===========================================================================*/
 static void set_multicast_list(struct net_device *dev)
 {
-    ray_dev_t *local = (ray_dev_t *)dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     UCHAR promisc;
 
     DEBUG(2,"ray_cs set_multicast_list(%p)\n",dev);
@@ -1935,7 +1935,7 @@ static irqreturn_t ray_interrupt(int irq
 
     DEBUG(4,"ray_cs: interrupt for *dev=%p\n",dev);
 
-    local = (ray_dev_t *)dev->priv;
+    local = netdev_priv(dev);
     link = (struct pcmcia_device *)local->finder;
     if (!pcmcia_dev_present(link)) {
         DEBUG(2,"ray_cs interrupt from device not present or suspended.\n");
@@ -2165,7 +2165,7 @@ static void rx_data(struct net_device *d
 {
     struct sk_buff *skb = NULL;
     struct rcs __iomem *prcslink = prcs;
-    ray_dev_t *local = dev->priv;
+    ray_dev_t *local = netdev_priv(dev);
     UCHAR *rx_ptr;
     int total_len;
     int tmp;
@@ -2618,7 +2618,7 @@ static int ray_cs_proc_read(char *buf, c
     dev = (struct net_device *)link->priv;
     if (!dev)
     	return 0;
-    local = (ray_dev_t *)dev->priv;
+    local = netdev_priv(dev);
     if (!local)
     	return 0;
 
diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index ef32a5c..ed146ae 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -2571,7 +2571,7 @@ static struct strip *strip_alloc(void)
 		return NULL;	/* If no more memory, return */
 
 
-	strip_info = dev->priv;
+	strip_info = netdev_priv(dev);
 	strip_info->dev = dev;
 
 	strip_info->magic = STRIP_MAGIC;
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index c8b5c22..72f3d97 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -859,7 +859,7 @@ static int wl3501_esbq_confirm(struct wl
 
 static void wl3501_online(struct net_device *dev)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	printk(KERN_INFO "%s: Wireless LAN online. BSSID: "
 	       "%02X %02X %02X %02X %02X %02X\n", dev->name,
@@ -907,7 +907,7 @@ static int wl3501_mgmt_association(struc
 
 static void wl3501_mgmt_join_confirm(struct net_device *dev, u16 addr)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	struct wl3501_join_confirm sig;
 
 	dprintk(3, "entry");
@@ -1046,7 +1046,7 @@ static inline void wl3501_start_confirm_
 static inline void wl3501_assoc_confirm_interrupt(struct net_device *dev,
 						  u16 addr)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	struct wl3501_assoc_confirm sig;
 
 	dprintk(3, "entry");
@@ -1075,7 +1075,7 @@ static inline void wl3501_rx_interrupt(s
 	int morepkts;
 	u16 addr;
 	u8 sig_id;
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	dprintk(3, "entry");
 loop:
@@ -1257,7 +1257,7 @@ fail:
 
 static int wl3501_close(struct net_device *dev)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = -ENODEV;
 	unsigned long flags;
 	struct pcmcia_device *link;
@@ -1289,7 +1289,7 @@ static int wl3501_close(struct net_devic
  */
 static int wl3501_reset(struct net_device *dev)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = -ENODEV;
 
 	wl3501_block_interrupt(this);
@@ -1318,7 +1318,7 @@ out:
 
 static void wl3501_tx_timeout(struct net_device *dev)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	struct net_device_stats *stats = &this->stats;
 	unsigned long flags;
 	int rc;
@@ -1344,7 +1344,7 @@ static void wl3501_tx_timeout(struct net
 static int wl3501_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int enabled, rc;
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&this->lock, flags);
@@ -1371,7 +1371,7 @@ static int wl3501_hard_start_xmit(struct
 static int wl3501_open(struct net_device *dev)
 {
 	int rc = -ENODEV;
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	unsigned long flags;
 	struct pcmcia_device *link;
 	link = this->p_dev;
@@ -1410,14 +1410,14 @@ fail:
 
 static struct net_device_stats *wl3501_get_stats(struct net_device *dev)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	return &this->stats;
 }
 
 static struct iw_statistics *wl3501_get_wireless_stats(struct net_device *dev)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	struct iw_statistics *wstats = &this->wstats;
 	u32 value; /* size checked: it is u32 */
 
@@ -1497,7 +1497,7 @@ static int wl3501_get_name(struct net_de
 static int wl3501_set_freq(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int channel = wrqu->freq.m;
 	int rc = -EINVAL;
 
@@ -1511,7 +1511,7 @@ static int wl3501_set_freq(struct net_de
 static int wl3501_get_freq(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	wrqu->freq.m = wl3501_chan2freq[this->chan - 1] * 100000;
 	wrqu->freq.e = 1;
@@ -1526,7 +1526,7 @@ static int wl3501_set_mode(struct net_de
 	if (wrqu->mode == IW_MODE_INFRA ||
 	    wrqu->mode == IW_MODE_ADHOC ||
 	    wrqu->mode == IW_MODE_AUTO) {
-		struct wl3501_card *this = dev->priv;
+		struct wl3501_card *this = netdev_priv(dev);
 
 		this->net_type = wrqu->mode;
 		rc = wl3501_reset(dev);
@@ -1537,7 +1537,7 @@ static int wl3501_set_mode(struct net_de
 static int wl3501_get_mode(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	wrqu->mode = this->net_type;
 	return 0;
@@ -1546,7 +1546,7 @@ static int wl3501_get_mode(struct net_de
 static int wl3501_get_sens(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	wrqu->sens.value = this->rssi;
 	wrqu->sens.disabled = !wrqu->sens.value;
@@ -1577,7 +1577,7 @@ static int wl3501_get_range(struct net_d
 static int wl3501_set_wap(struct net_device *dev, struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	static const u8 bcast[ETH_ALEN] = { 255, 255, 255, 255, 255, 255 };
 	int rc = -EINVAL;
 
@@ -1597,7 +1597,7 @@ out:
 static int wl3501_get_wap(struct net_device *dev, struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	wrqu->ap_addr.sa_family = ARPHRD_ETHER;
 	memcpy(wrqu->ap_addr.sa_data, this->bssid, ETH_ALEN);
@@ -1616,7 +1616,7 @@ static int wl3501_set_scan(struct net_de
 static int wl3501_get_scan(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int i;
 	char *current_ev = extra;
 	struct iw_event iwe;
@@ -1666,7 +1666,7 @@ static int wl3501_set_essid(struct net_d
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	if (wrqu->data.flags) {
 		iw_set_mgmt_info_element(IW_MGMT_INFO_ELEMENT_SSID,
@@ -1683,7 +1683,7 @@ static int wl3501_get_essid(struct net_d
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&this->lock, flags);
@@ -1697,7 +1697,7 @@ static int wl3501_get_essid(struct net_d
 static int wl3501_set_nick(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	if (wrqu->data.length > sizeof(this->nick))
 		return -E2BIG;
@@ -1708,7 +1708,7 @@ static int wl3501_set_nick(struct net_de
 static int wl3501_get_nick(struct net_device *dev, struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 
 	strlcpy(extra, this->nick, 32);
 	wrqu->data.length = strlen(extra);
@@ -1733,7 +1733,7 @@ static int wl3501_get_rts_threshold(stru
 				    union iwreq_data *wrqu, char *extra)
 {
 	u16 threshold; /* size checked: it is u16 */
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = wl3501_get_mib_value(this, WL3501_MIB_ATTR_RTS_THRESHOLD,
 				      &threshold, sizeof(threshold));
 	if (!rc) {
@@ -1749,7 +1749,7 @@ static int wl3501_get_frag_threshold(str
 				     union iwreq_data *wrqu, char *extra)
 {
 	u16 threshold; /* size checked: it is u16 */
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = wl3501_get_mib_value(this, WL3501_MIB_ATTR_FRAG_THRESHOLD,
 				      &threshold, sizeof(threshold));
 	if (!rc) {
@@ -1765,7 +1765,7 @@ static int wl3501_get_txpow(struct net_d
 			    union iwreq_data *wrqu, char *extra)
 {
 	u16 txpow;
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = wl3501_get_mib_value(this,
 				      WL3501_MIB_ATTR_CURRENT_TX_PWR_LEVEL,
 				      &txpow, sizeof(txpow));
@@ -1787,7 +1787,7 @@ static int wl3501_get_retry(struct net_d
 			    union iwreq_data *wrqu, char *extra)
 {
 	u8 retry; /* size checked: it is u8 */
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = wl3501_get_mib_value(this,
 				      WL3501_MIB_ATTR_LONG_RETRY_LIMIT,
 				      &retry, sizeof(retry));
@@ -1814,7 +1814,7 @@ static int wl3501_get_encode(struct net_
 			     union iwreq_data *wrqu, char *extra)
 {
 	u8 implemented, restricted, keys[100], len_keys, tocopy;
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = wl3501_get_mib_value(this,
 				      WL3501_MIB_ATTR_PRIV_OPT_IMPLEMENTED,
 				      &implemented, sizeof(implemented));
@@ -1852,7 +1852,7 @@ static int wl3501_get_power(struct net_d
 			    union iwreq_data *wrqu, char *extra)
 {
 	u8 pwr_state;
-	struct wl3501_card *this = dev->priv;
+	struct wl3501_card *this = netdev_priv(dev);
 	int rc = wl3501_get_mib_value(this,
 				      WL3501_MIB_ATTR_CURRENT_PWR_STATE,
 				      &pwr_state, sizeof(pwr_state));
@@ -1937,7 +1937,7 @@ static int wl3501_probe(struct pcmcia_de
 	dev->tx_timeout		= wl3501_tx_timeout;
 	dev->watchdog_timeo	= 5 * HZ;
 	dev->get_stats		= wl3501_get_stats;
-	this = dev->priv;
+	this = netdev_priv(dev);
 	this->wireless_data.spy_data = &this->spy_data;
 	this->p_dev = p_dev;
 	dev->wireless_data	= &this->wireless_data;
@@ -2006,7 +2006,7 @@ static int wl3501_config(struct pcmcia_d
 
 	SET_MODULE_OWNER(dev);
 
-	this = dev->priv;
+	this = netdev_priv(dev);
 	/*
 	 * At this point, the dev_node_t structure(s) should be initialized and
 	 * arranged in a linked list at link->dev_node.
@@ -2079,7 +2079,7 @@ static int wl3501_suspend(struct pcmcia_
 {
 	struct net_device *dev = link->priv;
 
-	wl3501_pwr_mgmt(dev->priv, WL3501_SUSPEND);
+	wl3501_pwr_mgmt(netdev_priv(dev), WL3501_SUSPEND);
 	if (link->open)
 		netif_device_detach(dev);
 
@@ -2090,7 +2090,7 @@ static int wl3501_resume(struct pcmcia_d
 {
 	struct net_device *dev = link->priv;
 
-	wl3501_pwr_mgmt(dev->priv, WL3501_RESUME);
+	wl3501_pwr_mgmt(netdev_priv(dev), WL3501_RESUME);
 	if (link->open) {
 		wl3501_reset(dev);
 		netif_device_attach(dev);

