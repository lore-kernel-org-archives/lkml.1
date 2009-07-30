Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZG3VWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZG3VWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG3VWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:22:52 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58328 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZG3VWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=as0nYJR1FjQqk0ALITYUK/ibg2n5MVzNJ211HmQwKiRnLNABRMr7MajIuNlpASmYev
         ShH/R/mZ6yF6NWO/71vRLX8oW4nLtgvs3FTZkqzigB2pqLC9VqP9HR7M97vAX3qHWqNR
         BhQP8sXVqof7dkpBY+StfVvCBNdBqv3dI3fiw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Don Fry <pcnet32@verizon.net>
Subject: [PATCH] pcnet32: VLB support fixes
Date: Thu, 30 Jul 2009 23:17:52 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907302317.52648.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pcnet32: VLB support fixes

VLB support has been broken since at least 2004-2005 period as some
changes introduced back then assumed that ->pci_dev is always valid,
lets try to fix it:

- remove duplicated SET_NETDEV_DEV() call

- call SET_NETDEV_DEV() only for PCI devices

- check for ->pci_dev validity in pcnet32_open()

[ Alternatively we may consider removing VLB support but there would not
  be much gain in it since an extra driver code needed for VLB support is
  minimal and quite simple. ]

This takes care of the following entry from Dan's list:

drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
PS I still keep the original cc: list from the smatch thread -- please let
me know if you don't want to be spammed.. ;-)

 drivers/net/pcnet32.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: b/drivers/net/pcnet32.c
===================================================================
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -1719,7 +1719,9 @@ pcnet32_probe1(unsigned long ioaddr, int
 		ret = -ENOMEM;
 		goto err_release_region;
 	}
-	SET_NETDEV_DEV(dev, &pdev->dev);
+
+	if (pdev)
+		SET_NETDEV_DEV(dev, &pdev->dev);
 
 	if (pcnet32_debug & NETIF_MSG_PROBE)
 		printk(KERN_INFO PFX "%s at %#3lx,", chipname, ioaddr);
@@ -1818,7 +1820,6 @@ pcnet32_probe1(unsigned long ioaddr, int
 
 	spin_lock_init(&lp->lock);
 
-	SET_NETDEV_DEV(dev, &pdev->dev);
 	lp->name = chipname;
 	lp->shared_irq = shared;
 	lp->tx_ring_size = TX_RING_SIZE;	/* default tx ring size */
@@ -2089,6 +2090,7 @@ static void pcnet32_free_ring(struct net
 static int pcnet32_open(struct net_device *dev)
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
+	struct pci_dev *pdev = lp->pci_dev;
 	unsigned long ioaddr = dev->base_addr;
 	u16 val;
 	int i;
@@ -2149,9 +2151,9 @@ static int pcnet32_open(struct net_devic
 	lp->a.write_csr(ioaddr, 124, val);
 
 	/* Allied Telesyn AT 2700/2701 FX are 100Mbit only and do not negotiate */
-	if (lp->pci_dev->subsystem_vendor == PCI_VENDOR_ID_AT &&
-	    (lp->pci_dev->subsystem_device == PCI_SUBDEVICE_ID_AT_2700FX ||
-	     lp->pci_dev->subsystem_device == PCI_SUBDEVICE_ID_AT_2701FX)) {
+	if (pdev && pdev->subsystem_vendor == PCI_VENDOR_ID_AT &&
+	    (pdev->subsystem_device == PCI_SUBDEVICE_ID_AT_2700FX ||
+	     pdev->subsystem_device == PCI_SUBDEVICE_ID_AT_2701FX)) {
 		if (lp->options & PCNET32_PORT_ASEL) {
 			lp->options = PCNET32_PORT_FD | PCNET32_PORT_100;
 			if (netif_msg_link(lp))
