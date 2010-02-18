Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab0BRDLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 22:11:17 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:38658 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab0BRDLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 22:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jMFovyXlV4TAxSL0hLJ+qF8LAghfPKDfJAYR1R3HAJ+4c1FEWEYwGco+K3yXri07YJ
         kg0TIXbCyzkGCrDOx+0jjtawJUG84uNuxUcMAuzniGZ9gkhsoezi1x2GHCM+eGCVg8ns
         nlMoZ7W1LErc8dkuR/dWF8o/IzraXLY9dFoaA=
Message-ID: <4B7CAF95.6020306@gmail.com>
Date: Wed, 17 Feb 2010 21:10:13 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>,
       Linux USB <linux-usb-devel@lists.sourceforge.net>
Subject: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a module parameter to allow the user to enable 64-bit DMA support in EHCI,
which has been forcibly disabled since 2003 - see:

http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg17230.html

At that time the comment was "it'd only matter on a few big Intel boxes anyway",
however the situation is much different today when many new machines have 4GB
or more of RAM and IOMMU/SWIOTLB are thus needlessly required for USB transfers.
For now, the support remains disabled by default and is controlled by an
allow_64bit module parameter.

Note that some USB device drivers may require updates to pass the DMA
capabilities up to their higher layers to avoid unnecessary IOMMU or bounce-
buffer use (i.e. networking layer NETIF_F_HIGHDMA). Some of these checks were
disabled by the patch listed above, and more may be required again today.
However, those previous checks were done incorrectly using dma_supported,
which checks to see whether a device's DMA mask can be validly set to a given
mask, not whether its previously set mask will accomodate the mask passed in.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 1ec3857..f527e15 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -101,6 +101,10 @@ static int ignore_oc = 0;
 module_param (ignore_oc, bool, S_IRUGO);
 MODULE_PARM_DESC (ignore_oc, "ignore bogus hardware overcurrent indications");
 
+static int allow_64bit;
+module_param(allow_64bit, bool, S_IRUGO);
+MODULE_PARM_DESC(allow_64bit, "allow 64-bit DMA");
+
 #define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
 
 /*-------------------------------------------------------------------------*/
@@ -644,11 +648,9 @@ static int ehci_run (struct usb_hcd *hcd)
 	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
 	if (HCC_64BIT_ADDR(hcc_params)) {
 		ehci_writel(ehci, 0, &ehci->regs->segment);
-#if 0
-// this is deeply broken on almost all architectures
-		if (!dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
+		if (allow_64bit &&
+		    !dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
 			ehci_info(ehci, "enabled 64bit DMA\n");
-#endif
 	}
 
 
