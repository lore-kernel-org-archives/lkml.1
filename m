Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXHAX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXHAX53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXHAX5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:57:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:45481 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXHAX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dRF800jXS17YZWxT8+Vt/BpcJWCz92ifG49O4rD4BpY2X6bdVsoTNawJzOUranZ2BgUgXA/54Bh70/ccWfyWIRXzU6p9ndNA3+CJx7fxR6D3ZNF4PMNhpfU/2sJMaxaYHP1a519bQ0F+vFMpjAp5D39KGxcXuqQGeN5nswAWk30=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Eric Moore <Eric.Moore@lsi.com>
Subject: [PATCH] Fix two potential mem leaks in MPT Fusion (mpt_attach())
Date: Thu, 2 Aug 2007 01:55:33 +0200
User-Agent: KMail/1.9.7
Cc: DL-MPTFusionLinux@lsi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, support@lsi.com,
       mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708020155.33690.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings & Salutations,

The Coverity checker spotted two potential memory leaks in 
drivers/message/fusion/mptbase.c::mpt_attach().

There are two returns that may leak the storage allocated for 
'ioc' (sizeof(MPT_ADAPTER) bytes).
A simple fix would be to simply add two kfree() calls before 
the return statements, but a better fix (that this patch 
implements) is to reorder the code so that if we hit the first 
return condition we don't have to do the allocation at all and 
then just add a kfree() call for the second case.

Please consider applying.  Patch has been compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/message/fusion/mptbase.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e866dac..f9bb705 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1393,18 +1393,18 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct proc_dir_entry *dent, *ent;
 #endif
 
+	if (mpt_debug_level)
+		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
+
+	if (pci_enable_device(pdev))
+		return r;
+
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-
 	ioc->debug_level = mpt_debug_level;
-	if (mpt_debug_level)
-		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
-
-	if (pci_enable_device(pdev))
-		return r;
 
 	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
@@ -1413,6 +1413,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		kfree(ioc);
 		return r;
 	}
 



