Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXHCRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXHCRjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764132AbXHCRi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:38:28 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37437 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764249AbXHCRi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:38:26 -0400
Date: Fri, 3 Aug 2007 19:34:30 +0200 (MEST)
Message-Id: <200708031734.TAA00783@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 08/13] dev->priv to netdev_priv(dev), for drivers/net/netxen
Cc: amitkale@netxen.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
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
Cc: amitkale@netxen.com
Cc: akpm@linux-foundation.org
---

 drivers/net/netxen/netxen_nic_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 08a62ac..c14c178 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -329,7 +329,7 @@ netxen_nic_probe(struct pci_dev *pdev, c
 	SET_MODULE_OWNER(netdev);
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
-	adapter = netdev->priv;
+	adapter = netdev_priv(netdev);
 	memset(adapter, 0 , sizeof(struct netxen_adapter));
 
 	adapter->ahw.pdev = pdev;
@@ -850,7 +850,7 @@ static void __devexit netxen_nic_remove(
  */
 static int netxen_nic_open(struct net_device *netdev)
 {
-	struct netxen_adapter *adapter = (struct netxen_adapter *)netdev->priv;
+	struct netxen_adapter *adapter = netdev_priv(netdev);
 	int err = 0;
 	int ctx, ring;
 

