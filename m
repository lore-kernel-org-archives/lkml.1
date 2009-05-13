Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZEMKHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZEMKHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZEMKH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:07:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59413 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbZEMKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:07:25 -0400
Date: Wed, 13 May 2009 04:07:25 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: David Miller <davem@davemloft.net>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix MSI-X with NIU cards
Message-ID: <20090513100725.GE15360@parisc-linux.org>
References: <1242004911.7767.26.camel@concordia> <20090510.223645.193708481.davem@davemloft.net> <1242052211.7011.4.camel@concordia> <20090511.164017.116664605.davem@davemloft.net> <1242094886.7421.26.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242094886.7421.26.camel@concordia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 12:21:26PM +1000, Michael Ellerman wrote:
> 158 static void msix_mask_irq(struct msi_desc *desc, u32 flag)                  
> 159 {
> 160         u32 mask_bits = desc->masked;
> 161         unsigned offset = desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
> 162                                         PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> 163         mask_bits &= ~1;
> 164         mask_bits |= flag;
> 165         writel(mask_bits, desc->mask_base + offset);
> 166         desc->masked = mask_bits;
> 167 }
> 
> So I don't see how this patch works, all it's doing is moving the readl().

I think you're right.  My patch is clearly wrong.  I don't understand how
it worked for Dave.  Maybe his system is ignoring the errors on write
but can't ignore errors on read?  Or maybe his card silently ignores
writes and generates errors on read.

Here's an updated version:

----

The NIU device refuses to allow accesses to MSI-X registers before MSI-X
is enabled.  This patch fixes the problem by moving the read of the mask
register to after MSI-X is enabled.

Reported-by: David S. Miller <davem@davemloft.net>
Tested-by: David S. Miller <davem@davemloft.net>
Reviewed-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6f2e629..cd66579 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -455,9 +455,6 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
 		entry->mask_base = base;
-		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
-					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
-		msix_mask_irq(entry, 1);
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
@@ -493,6 +490,13 @@ static int msix_capability_init(struct pci_dev *dev,
 	msix_set_enable(dev, 1);
 	dev->msix_enabled = 1;
 
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		int vector = entry->msi_attrib.entry_nr;
+		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
+					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+		msix_mask_irq(entry, 1);
+	}
+
 	return 0;
 }
 

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
