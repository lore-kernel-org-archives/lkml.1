Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZG3VWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZG3VWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZG3VWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:22:35 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:58911 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZG3VWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=vaxRx9eTOD4HvB8KFRULT9xdFrsc98k0rPTganU2cuecD5KQKnbd5g5sJibHsDydu6
         XOnTqJky0YNE1GlWnEAsTL3mw0sZlHEq7thKxOZc9ojLzBcP19Gj6Se6TaJ7p1HZcAIR
         NY1UUWGvNC0t+YDo76Xq+k4fnzedCZWblDDtI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Don Fry <pcnet32@verizon.net>
Subject: [PATCH] pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()
Date: Thu, 30 Jul 2009 23:19:17 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907302319.18150.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
