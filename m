Return-Path: <linux-kernel-owner+w=401wt.eu-S1764695AbXHFWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764695AbXHFWFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXHFWFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:05:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:46204 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbXHFWFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:05:36 -0400
Subject: [PATCH] powerpc: Fix initialization and usage of dma_mask
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olaf Hering <olh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1186436597.938.71.camel@localhost.localdomain>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
	 <1186272926.938.8.camel@localhost.localdomain>
	 <46B5824B.1000103@s5r6.in-berlin.de>  <20070806115804.GA1734@suse.de>
	 <1186436597.938.71.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 08:05:10 +1000
Message-Id: <1186437910.938.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc has a couple of bugs in the usage of dma_masks that tend to
break when drivers explicitely try to set a 32 bits mask for example.

First the code that generates the pci devices from the OF device-tree
doesn't initialize the mask properly, then our implementation of
set_dma_mask() was trying to validate the -previous- mask value, not the
one passed in as an argument.

This patch should fix these.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Does this fix the problem you've noticed ?

(I do still think that sbp2 isn't the right place for that call btw :-)

Index: linux-work/include/asm-powerpc/dma-mapping.h
===================================================================
--- linux-work.orig/include/asm-powerpc/dma-mapping.h	2007-08-07 07:59:05.000000000 +1000
+++ linux-work/include/asm-powerpc/dma-mapping.h	2007-08-07 07:59:09.000000000 +1000
@@ -96,7 +96,7 @@
 		return -EIO;
 	if (dma_ops->set_dma_mask != NULL)
 		return dma_ops->set_dma_mask(dev, dma_mask);
-	if (!dev->dma_mask || !dma_supported(dev, *dev->dma_mask))
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
 		return -EIO;
 	*dev->dma_mask = dma_mask;
 	return 0;
Index: linux-work/arch/powerpc/kernel/pci_64.c
===================================================================
--- linux-work.orig/arch/powerpc/kernel/pci_64.c	2007-08-07 08:00:20.000000000 +1000
+++ linux-work/arch/powerpc/kernel/pci_64.c	2007-08-07 08:00:47.000000000 +1000
@@ -372,6 +372,7 @@
 
 	dev->current_state = 4;		/* unknown power state */
 	dev->error_state = pci_channel_io_normal;
+	dev->dma_mask = 0xffffffff;
 
 	if (!strcmp(type, "pci") || !strcmp(type, "pciex")) {
 		/* a PCI-PCI bridge */


