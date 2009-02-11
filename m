Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZBKKS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZBKKS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZBKKSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:18:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:28728 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZBKKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=KiAkJnMQP+iFvD6/ODBI3+GyQVPQnUpGUqmZ9xYlbuZPZMMIPNW5MrlrkQgRvY6yp4
         7rWCF/TwS6I4MWMqKkuCr3/NBKsxYtHvReE0rFsDkOJdrQQrRsgeHoatiJnVj+NvF4zT
         aGkEKddhT2LB5qEMFeo2pVTqg0VWQ3CDDPAv8=
Message-ID: <4992A5ED.5050800@gmail.com>
Date: Wed, 11 Feb 2009 12:18:21 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: gregkh@suse.de
CC: Christopher Harrer <charrer@alacritech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH]  SLICOSS - free resources on entry_probe error path
Content-Type: multipart/mixed;
 boundary="------------090400090901080902010605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090400090901080902010605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Call pci_disable_device() and free_netdev() if slic_entry_probe fails.

Signed_off-by: Lior Dotan <liodot@gmail.com>

--------------090400090901080902010605
Content-Type: text/plain;
 name="slicoss-clean-slic_entry_probe.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-clean-slic_entry_probe.patch"

diff -X /usr/src/linux/Documentation/dontdiff -purN a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
--- a/drivers/staging/slicoss/slicoss.c	2009-02-11 11:15:32.000000000 +0200
+++ b/drivers/staging/slicoss/slicoss.c	2009-02-11 12:03:42.000000000 +0200
@@ -335,7 +335,7 @@ static int __devinit slic_entry_probe(st
 {
 	static int cards_found;
 	static int did_version;
-	int err;
+	int err = -ENODEV;
 	struct net_device *netdev;
 	struct adapter *adapter;
 	void __iomem *memmapped_ioaddr = NULL;
@@ -369,7 +369,7 @@ static int __devinit slic_entry_probe(st
 			DBG_MSG
 			    ("No usable DMA configuration, aborting  err[%x]\n",
 			     err);
-			return err;
+			goto err_out_disable_pci;
 		}
 		DBG_MSG("pci_set_dma_mask(DMA_32BIT_MASK) successful\n");
 	}
@@ -379,7 +379,7 @@ static int __devinit slic_entry_probe(st
 	err = pci_request_regions(pcidev, DRV_NAME);
 	if (err) {
 		DBG_MSG("pci_request_regions FAILED err[%x]\n", err);
-		return err;
+		goto err_out_disable_pci;
 	}
 
 	DBG_MSG("call pci_set_master\n");
@@ -413,7 +413,7 @@ static int __devinit slic_entry_probe(st
 	if (!memmapped_ioaddr) {
 		DBG_ERROR("%s cannot remap MMIO region %lx @ %lx\n",
 			  __func__, mmio_len, mmio_start);
-		goto err_out_free_mmio_region;
+		goto err_out_free_netdev;
 	}
 
 	DBG_MSG
@@ -497,16 +497,17 @@ static int __devinit slic_entry_probe(st
 
 err_out_unmap:
 	iounmap(memmapped_ioaddr);
-
 err_out_free_mmio_region:
 	release_mem_region(mmio_start, mmio_len);
-
+err_out_free_netdev:
+	free_netdev(netdev);
 err_out_exit_slic_probe:
 	pci_release_regions(pcidev);
 	DBG_ERROR("%s EXIT jiffies[%lx] cpu %d\n", __func__, jiffies,
 		  smp_processor_id());
-
-	return -ENODEV;
+err_out_disable_pci:
+	pci_disable_device(pcidev);
+	return err;
 }
 
 static int slic_entry_open(struct net_device *dev)

--------------090400090901080902010605--
