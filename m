Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbYBSAvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbYBSAvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbYBSAvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:51:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:15407 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813AbYBSAu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:50:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tjbcuttgVpWTvZ8B+oXYjjaiGeGdQspz68EP/FFFXGImO1BTSUBBkUa5YiMf04IKe9JFXambNcp1NyvPx4B1XMNF2AVGp7v5rOhrs2ELUWGFZNaPRQXAbwqbIpwsdJTLiQZNQ3n3maFIePfUQtJ0IZjg+O4hssl24OkbIc8cQX8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] next-20080218 build failure at pmac_ide_macio_attach ()
Date: Tue, 19 Feb 2008 01:04:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au, apw@shadowen.org
References: <20080218140159.GA31310@linux.vnet.ibm.com>
In-Reply-To: <20080218140159.GA31310@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802190104.47058.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008, Kamalesh Babulal wrote:
> Hi,
> 
> The next-20080218 kernel build fails on the powerpc(s)
> 
> drivers/ide/ppc/pmac.c: In function ‘pmac_ide_macio_attach’:
> drivers/ide/ppc/pmac.c:1094: error: conversion to non-scalar type requested
> drivers/ide/ppc/pmac.c: In function ‘pmac_ide_pci_attach’:
> drivers/ide/ppc/pmac.c:1232: error: conversion to non-scalar type requested
> make[3]: *** [drivers/ide/ppc/pmac.o] Error 1
> make[2]: *** [drivers/ide/ppc] Error 2
> make[1]: *** [drivers/ide] Error 2
> make: *** [drivers] Error 2
> 
> I Have tested this patch for build failure only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> --- linux-2.6.25-rc1/drivers/ide/ppc/pmac.c	2008-02-18 18:41:48.000000000 +0530
> +++ linux-2.6.25-rc1/drivers/ide/ppc/~pmac.c	2008-02-18 19:20:37.000000000 +0530
> @@ -1091,7 +1091,7 @@ pmac_ide_macio_attach(struct macio_dev *
>  	int irq, rc;
>  	hw_regs_t hw;
>  
> -	pmif = (struct pmac_ide_hwif)kzalloc(sizeof(*pmif), GFP_KERNEL);
> +	pmif = (struct pmac_ide_hwif*)kzalloc(sizeof(*pmif), GFP_KERNEL);
>  	if (pmif == NULL)
>  		return -ENOMEM;
>  
> @@ -1229,7 +1229,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev
>  		return -ENODEV;
>  	}
>  
> -	pmif = (struct pmac_ide_hwif)kzalloc(sizeof(*pmif), GFP_KERNEL);
> +	pmif = (struct pmac_ide_hwif*)kzalloc(sizeof(*pmif), GFP_KERNEL);
>  	if (pmif == NULL)
>  		return -ENOMEM;
>  

Thanks, I integrated it with the "guilty" patch to preserve bisectability.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pmac: dynamically allocate struct pmac_ide_hwif instances (take 2)

* Dynamically allocate struct pmac_ide_hwif instances in pmac_ide_macio_attach()
  and pmac_ide_pci_attach(), then remove no longer needed pmac_ide[].

v2:
* Build fix from Kamalesh Babulal.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -79,8 +79,6 @@ typedef struct pmac_ide_hwif {
 	
 } pmac_ide_hwif_t;
 
-static pmac_ide_hwif_t pmac_ide[MAX_HWIFS];
-
 enum {
 	controller_ohare,	/* OHare based */
 	controller_heathrow,	/* Heathrow/Paddington */
@@ -1094,29 +1092,34 @@ pmac_ide_macio_attach(struct macio_dev *
 	int i, rc;
 	hw_regs_t hw;
 
+	pmif = kzalloc(sizeof(*pmif), GFP_KERNEL);
+	if (pmif == NULL)
+		return -ENOMEM;
+
 	i = 0;
-	while (i < MAX_HWIFS && (ide_hwifs[i].io_ports[IDE_DATA_OFFSET] != 0
-	    || pmac_ide[i].node != NULL))
+	while (i < MAX_HWIFS && (ide_hwifs[i].io_ports[IDE_DATA_OFFSET] != 0))
 		++i;
 	if (i >= MAX_HWIFS) {
 		printk(KERN_ERR "ide-pmac: MacIO interface attach with no slot\n");
 		printk(KERN_ERR "          %s\n", mdev->ofdev.node->full_name);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto out_free_pmif;
 	}
 
-	pmif = &pmac_ide[i];
 	hwif = &ide_hwifs[i];
 
 	if (macio_resource_count(mdev) == 0) {
 		printk(KERN_WARNING "ide%d: no address for %s\n",
 		       i, mdev->ofdev.node->full_name);
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_free_pmif;
 	}
 
 	/* Request memory resource for IO ports */
 	if (macio_request_resource(mdev, 0, "ide-pmac (ports)")) {
 		printk(KERN_ERR "ide%d: can't request mmio resource !\n", i);
-		return -EBUSY;
+		rc = -EBUSY;
+		goto out_free_pmif;
 	}
 			
 	/* XXX This is bogus. Should be fixed in the registry by checking
@@ -1166,11 +1169,15 @@ pmac_ide_macio_attach(struct macio_dev *
 			iounmap(pmif->dma_regs);
 			macio_release_resource(mdev, 1);
 		}
-		memset(pmif, 0, sizeof(*pmif));
 		macio_release_resource(mdev, 0);
+		kfree(pmif);
 	}
 
 	return rc;
+
+out_free_pmif:
+	kfree(pmif);
+	return rc;
 }
 
 static int
@@ -1223,30 +1230,36 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 		printk(KERN_ERR "ide-pmac: cannot find MacIO node for Kauai ATA interface\n");
 		return -ENODEV;
 	}
+
+	pmif = kzalloc(sizeof(*pmif), GFP_KERNEL);
+	if (pmif == NULL)
+		return -ENOMEM;
+
 	i = 0;
-	while (i < MAX_HWIFS && (ide_hwifs[i].io_ports[IDE_DATA_OFFSET] != 0
-	    || pmac_ide[i].node != NULL))
+	while (i < MAX_HWIFS && (ide_hwifs[i].io_ports[IDE_DATA_OFFSET] != 0))
 		++i;
 	if (i >= MAX_HWIFS) {
 		printk(KERN_ERR "ide-pmac: PCI interface attach with no slot\n");
 		printk(KERN_ERR "          %s\n", np->full_name);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto out_free_pmif;
 	}
 
-	pmif = &pmac_ide[i];
 	hwif = &ide_hwifs[i];
 
 	if (pci_enable_device(pdev)) {
 		printk(KERN_WARNING "ide%i: Can't enable PCI device for %s\n",
 			i, np->full_name);
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_free_pmif;
 	}
 	pci_set_master(pdev);
 			
 	if (pci_request_regions(pdev, "Kauai ATA")) {
 		printk(KERN_ERR "ide%d: Cannot obtain PCI resources for %s\n",
 			i, np->full_name);
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_free_pmif;
 	}
 
 	hwif->dev = &pdev->dev;
@@ -1276,11 +1289,15 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 		/* The inteface is released to the common IDE layer */
 		pci_set_drvdata(pdev, NULL);
 		iounmap(base);
-		memset(pmif, 0, sizeof(*pmif));
 		pci_release_regions(pdev);
+		kfree(pmif);
 	}
 
 	return rc;
+
+out_free_pmif:
+	kfree(pmif);
+	return rc;
 }
 
 static int

