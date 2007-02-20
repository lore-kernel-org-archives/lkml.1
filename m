Return-Path: <linux-kernel-owner+w=401wt.eu-S965273AbXBTI2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273AbXBTI2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXBTI2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:28:43 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:55248 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965273AbXBTI2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CpShrzNH8MpA6TG2Oe0P2C1w0MPeXBGVYHghVA9jTR8Udio3rtDcoFTVG8bRqx/aKxU1fuNgDSj8MoXlCgR4eHCtw/2ennivHrZgWqjnOlR61Rpiyx1nnOogUHv2OULrNMsRb16NMR4/87eNG9MoQ4IJ5gyHvNzyn4GmzFF5Cok=
Date: Tue, 20 Feb 2007 17:28:39 +0900
From: Tejun Heo <htejun@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ian McDonald <ian.mcdonald@jandi.co.nz>, gregkh@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] pci: allow multiple calls to pcim_pin_device()
Message-ID: <20070220082839.GN1625@htj.dyndns.org>
References: <5640c7e00702181153q44678861q9963e7e2de00be8@mail.gmail.com> <200702182158.13429.bzolnier@gmail.com> <5640c7e00702182000p26f1ca8n15c1edcd8b3134a1@mail.gmail.com> <200702191247.03274.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702191247.03274.bzolnier@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sanity check in pcim_pin_device() was too restrictive in that it
didn't allow multiple calls to the function, which is against the
devres philosohpy of fire-and-forget.  Track pinned status separately
and allow pinning multiple times.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
It was an actual bug in pcim_pin_device() implementation.  Thanks for
spotting this.  :-)

Ian McDonald, please verify your warning goes away with this patch.

Greg, please forward this patch upstream once Ian acks it.

Thanks.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8b44cff..a1927ea 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -751,7 +751,8 @@ int pci_enable_device(struct pci_dev *dev)
  * when a device is enabled using managed PCI device enable interface.
  */
 struct pci_devres {
-	unsigned int disable:1;
+	unsigned int enabled:1;
+	unsigned int pinned:1;
 	unsigned int orig_intx:1;
 	unsigned int restore_intx:1;
 	u32 region_mask;
@@ -775,7 +776,7 @@ static void pcim_release(struct device *gendev, void *res)
 	if (this->restore_intx)
 		pci_intx(dev, this->orig_intx);
 
-	if (this->disable)
+	if (this->enabled && !this->pinned)
 		pci_disable_device(dev);
 }
 
@@ -814,12 +815,12 @@ int pcim_enable_device(struct pci_dev *pdev)
 	dr = get_pci_dr(pdev);
 	if (unlikely(!dr))
 		return -ENOMEM;
-	WARN_ON(!!dr->disable);
+	WARN_ON(!!dr->enabled);
 
 	rc = pci_enable_device(pdev);
 	if (!rc) {
 		pdev->is_managed = 1;
-		dr->disable = 1;
+		dr->enabled = 1;
 	}
 	return rc;
 }
@@ -837,9 +838,9 @@ void pcim_pin_device(struct pci_dev *pdev)
 	struct pci_devres *dr;
 
 	dr = find_pci_dr(pdev);
-	WARN_ON(!dr || !dr->disable);
+	WARN_ON(!dr || !dr->enabled);
 	if (dr)
-		dr->disable = 0;
+		dr->pinned = 1;
 }
 
 /**
@@ -870,7 +871,7 @@ pci_disable_device(struct pci_dev *dev)
 
 	dr = find_pci_dr(dev);
 	if (dr)
-		dr->disable = 0;
+		dr->enabled = 0;
 
 	if (atomic_sub_return(1, &dev->enable_cnt) != 0)
 		return;
