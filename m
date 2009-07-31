Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZGaSkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZGaSkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZGaSkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:40:08 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:39061 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZGaSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:40:07 -0400
Subject: Re: [PATCH] pcnet32: remove superfluous NULL pointer check in
 pcnet32_probe1()
From: Don Fry <pcnet32@verizon.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
In-reply-to: <200907302319.18150.bzolnier@gmail.com>
References: <200907302319.18150.bzolnier@gmail.com>
Content-type: text/plain
Date: Fri, 31 Jul 2009 11:40:06 -0700
Message-id: <1249065606.4229.1.camel@localhost.localdomain>
MIME-version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10)
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by:  Don Fry <pcnet32@verizon.net>

-----Original Message-----
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Don Fry <pcnet32@verizon.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter
<error27@gmail.com>, corbet@lwn.net, eteo@redhat.com, Julia Lawall
<julia@diku.dk>
Subject: [PATCH] pcnet32: remove superfluous NULL pointer check in
pcnet32_probe1()
Date: Thu, 30 Jul 2009 23:19:17 +0200

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()

Move the debug printk() into the proper place and remove superfluous
NULL pointer check in pcnet32_probe1().

This takes care of the following entry from Dan's list:

drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/pcnet32.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: b/drivers/net/pcnet32.c
===================================================================
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -1611,8 +1611,11 @@ pcnet32_probe1(unsigned long ioaddr, int
 		if (pcnet32_dwio_read_csr(ioaddr, 0) == 4
 		    && pcnet32_dwio_check(ioaddr)) {
 			a = &pcnet32_dwio;
-		} else
+		} else {
+			if (pcnet32_debug & NETIF_MSG_PROBE)
+				printk(KERN_ERR PFX "No access methods\n");
 			goto err_release_region;
+		}
 	}
 
 	chip_version =
@@ -1853,12 +1856,6 @@ pcnet32_probe1(unsigned long ioaddr, int
 	    ((cards_found >= MAX_UNITS) || full_duplex[cards_found]))
 		lp->options |= PCNET32_PORT_FD;
 
-	if (!a) {
-		if (pcnet32_debug & NETIF_MSG_PROBE)
-			printk(KERN_ERR PFX "No access methods\n");
-		ret = -ENODEV;
-		goto err_free_consistent;
-	}
 	lp->a = *a;
 
 	/* prior to register_netdev, dev->name is not yet correct */
@@ -1974,14 +1971,13 @@ pcnet32_probe1(unsigned long ioaddr, int
 
 	return 0;
 
-      err_free_ring:
+err_free_ring:
 	pcnet32_free_ring(dev);
-      err_free_consistent:
 	pci_free_consistent(lp->pci_dev, sizeof(*lp->init_block),
 			    lp->init_block, lp->init_dma_addr);
-      err_free_netdev:
+err_free_netdev:
 	free_netdev(dev);
-      err_release_region:
+err_release_region:
 	release_region(ioaddr, PCNET32_TOTAL_SIZE);
 	return ret;
 }
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

