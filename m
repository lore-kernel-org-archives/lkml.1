Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYJHXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYJHXDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYJHXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:03:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:33201 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYJHXDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=vA7bbRQctNVaCDMbeAFpOh7wnmmPJb8CT9mnlIbxeizZ+4bVKJ407NWjBN4wHX35EM
         NdJKjVQdxxr/n/h6a1V1CrN9ZlHKC4OKo5XTEtRLBnfhMqPErIYKE8q9MnZJKsxls5sR
         fvAniNRWCMlLDlusLX7w3K13yFsimCJG/Z/j8=
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] pci: print out DMA mask info
Date: Wed,  8 Oct 2008 16:02:23 -0700
Message-Id: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so can find out what is DMA mask is used for pci devices in addition to
default setting.

got:
ehci_hcd 0000:00:02.1: using 31bit consistent DMA mask
e1000 0000:0b:01.0: using 64bit DMA mask
e1000 0000:0b:01.0: using 64bit consistent DMA mask
e1000e 0000:04:00.0: using 64bit DMA mask
e1000e 0000:04:00.0: using 64bit consistent DMA mask
ixgb 0000:0c:01.0: using 64bit DMA mask
ixgb 0000:0c:01.0: using 64bit consistent DMA mask
aacraid 0000:86:00.0: using 32bit DMA mask
aacraid 0000:86:00.0: using 32bit consistent DMA mask
aacraid 0000:86:00.0: using 64bit DMA mask
aacraid 0000:86:00.0: using 64bit consistent DMA mask
qla2xxx 0000:0c:02.0: using 64bit consistent DMA mask
qla2xxx 0000:0c:02.1: using 64bit consistent DMA mask
lpfc 0000:06:00.0: using 64bit DMA mask
lpfc 0000:06:00.1: using 64bit DMA mask
pata_amd 0000:00:06.0: using 32bit DMA mask
pata_amd 0000:00:06.0: using 32bit consistent DMA mask
mptsas 0000:0c:04.0: using 64bit DMA mask
mptsas 0000:0c:04.0: using 64bit consistent DMA mask

forcedeth 0000:00:08.0: using 39bit DMA mask
forcedeth 0000:00:08.0: using 39bit consistent DMA mask
niu 0000:02:00.0: using 44bit DMA mask
niu 0000:02:00.0: using 44bit consistent DMA mask
sata_nv 0000:00:05.0: using 32bit DMA mask
sata_nv 0000:00:05.0: using 32bit consistent DMA mask
ib_mthca 0000:03:00.0: using 64bit DMA mask
ib_mthca 0000:03:00.0: using 64bit consistent DMA mask

wondering why: qlogic qla2xxx only set consistent to 64bit,
	       emulex lpfc not set consistent to 64bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1660,6 +1660,8 @@ pci_set_dma_mask(struct pci_dev *dev, u6
 		return -EIO;
 
 	dev->dma_mask = mask;
+	dev_printk(KERN_DEBUG, &dev->dev, "using %dbit DMA mask\n",
+		 fls64(mask));
 
 	return 0;
 }
@@ -1671,6 +1673,8 @@ pci_set_consistent_dma_mask(struct pci_d
 		return -EIO;
 
 	dev->dev.coherent_dma_mask = mask;
+	dev_printk(KERN_DEBUG, &dev->dev, "using %dbit consistent DMA mask\n",
+		 fls64(mask));
 
 	return 0;
 }
