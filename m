Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbXHCRi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbXHCRi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764247AbXHCRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:38:25 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37431 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763978AbXHCRiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:38:24 -0400
Date: Fri, 3 Aug 2007 19:36:53 +0200 (MEST)
Message-Id: <200708031736.TAA00865@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 11/13] dev->priv to netdev_priv(dev), for drivers/net/usb
Cc: greg@kroah.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
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
Cc: greg@kroah.com
Cc: akpm@linux-foundation.org
---

 drivers/net/usb/mcs7830.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 6240b97..37ad14b 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -341,14 +341,14 @@ out:
 static int mcs7830_mdio_read(struct net_device *netdev, int phy_id,
 			     int location)
 {
-	struct usbnet *dev = netdev->priv;
+	struct usbnet *dev = netdev_priv(netdev);
 	return mcs7830_read_phy(dev, location);
 }
 
 static void mcs7830_mdio_write(struct net_device *netdev, int phy_id,
 				int location, int val)
 {
-	struct usbnet *dev = netdev->priv;
+	struct usbnet *dev = netdev_priv(netdev);
 	mcs7830_write_phy(dev, location, val);
 }
 

