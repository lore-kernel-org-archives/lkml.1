Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYGAMmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYGAMmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGAMmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:42:15 -0400
Received: from khc.piap.pl ([195.187.100.11]:39212 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbYGAMmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:42:14 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WAN: Remove no longer needed pvc_desc in FR code.
References: <m3d4ly4ns2.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 01 Jul 2008 14:42:07 +0200
In-Reply-To: <m3d4ly4ns2.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Mon\, 30 Jun 2008 23\:26\:53 +0200")
Message-ID: <m3bq1hvkrk.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove no longer needed struct pvc_desc in FR code.
Requires "WAN: convert drivers to use built-in netdev_stats" patch.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index cb1b415..109bab3 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -135,10 +135,6 @@ typedef struct pvc_device_struct {
 	}state;
 }pvc_device;
 
-struct pvc_desc {
-	pvc_device *pvc;
-};
-
 struct frad_state {
 	fr_proto settings;
 	pvc_device *first_pvc;
@@ -178,10 +174,6 @@ static inline struct frad_state* state(hdlc_device *hdlc)
 	return(struct frad_state *)(hdlc->state);
 }
 
-static inline struct pvc_desc* pvcdev_to_desc(struct net_device *dev)
-{
-	return dev->priv;
-}
 
 static inline pvc_device* find_pvc(hdlc_device *hdlc, u16 dlci)
 {
@@ -351,7 +343,7 @@ static int fr_hard_header(struct sk_buff **skb_p, u16 dlci)
 
 static int pvc_open(struct net_device *dev)
 {
-	pvc_device *pvc = pvcdev_to_desc(dev)->pvc;
+	pvc_device *pvc = dev->priv;
 
 	if ((pvc->frad->flags & IFF_UP) == 0)
 		return -EIO;  /* Frad must be UP in order to activate PVC */
@@ -371,7 +363,7 @@ static int pvc_open(struct net_device *dev)
 
 static int pvc_close(struct net_device *dev)
 {
-	pvc_device *pvc = pvcdev_to_desc(dev)->pvc;
+	pvc_device *pvc = dev->priv;
 
 	if (--pvc->open_count == 0) {
 		hdlc_device *hdlc = dev_to_hdlc(pvc->frad);
@@ -390,7 +382,7 @@ static int pvc_close(struct net_device *dev)
 
 static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	pvc_device *pvc = pvcdev_to_desc(dev)->pvc;
+	pvc_device *pvc = dev->priv;
 	fr_proto_pvc_info info;
 
 	if (ifr->ifr_settings.type == IF_GET_PROTO) {
@@ -418,7 +410,7 @@ static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static int pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	pvc_device *pvc = pvcdev_to_desc(dev)->pvc;
+	pvc_device *pvc = dev->priv;
 
 	if (pvc->state.active) {
 		if (dev->type == ARPHRD_ETHER) {
@@ -1079,7 +1071,7 @@ static void pvc_setup(struct net_device *dev)
 static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 {
 	hdlc_device *hdlc = dev_to_hdlc(frad);
-	pvc_device *pvc = NULL;
+	pvc_device *pvc;
 	struct net_device *dev;
 	int result, used;
 
@@ -1095,10 +1087,9 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	used = pvc_is_used(pvc);
 
 	if (type == ARPHRD_ETHER)
-		dev = alloc_netdev(sizeof(struct pvc_desc), "pvceth%d",
-				   ether_setup);
+		dev = alloc_netdev(0, "pvceth%d", ether_setup);
 	else
-		dev = alloc_netdev(sizeof(struct pvc_desc), "pvc%d", pvc_setup);
+		dev = alloc_netdev(0, "pvc%d", pvc_setup);
 
 	if (!dev) {
 		printk(KERN_WARNING "%s: Memory squeeze on fr_pvc()\n",
@@ -1120,7 +1111,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	dev->change_mtu = pvc_change_mtu;
 	dev->mtu = HDLC_MAX_MTU;
 	dev->tx_queue_len = 0;
-	pvcdev_to_desc(dev)->pvc = pvc;
+	dev->priv = pvc;
 
 	result = dev_alloc_name(dev, dev->name);
 	if (result < 0) {
