Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZGaSpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZGaSpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZGaSpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:45:44 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:10731 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZGaSpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:45:43 -0400
Subject: Re: [PATCH] pcnet32: VLB support fixes
From: Don Fry <pcnet32@verizon.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
In-reply-to: <200907302317.52648.bzolnier@gmail.com>
References: <200907302317.52648.bzolnier@gmail.com>
Content-type: text/plain
Date: Fri, 31 Jul 2009 11:45:29 -0700
Message-id: <1249065929.4229.3.camel@localhost.localdomain>
MIME-version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10)
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by:  Don Fry <pcnet32@verizon.net>
---
I do not have any VLB hardware to test this, which is why I probably
introduced the error in 2004/5.

-----Original Message-----
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Don Fry <pcnet32@verizon.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter
<error27@gmail.com>, corbet@lwn.net, eteo@redhat.com, Julia Lawall
<julia@diku.dk>
Subject: [PATCH] pcnet32: VLB support fixes
Date: Thu, 30 Jul 2009 23:17:52 +0200

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
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

