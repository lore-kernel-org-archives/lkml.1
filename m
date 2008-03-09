Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYCIP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYCIP7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYCIP7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:59:36 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49027 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYCIP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:59:35 -0400
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <47D40567.7070409@msgid.tls.msk.ru>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>
	 <20080309212916T.tomof@acm.org>
	 <1205075315.3792.12.camel@localhost.localdomain>
	 <47D402C6.3070505@msgid.tls.msk.ru>  <47D40567.7070409@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 10:59:30 -0500
Message-Id: <1205078371.3792.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-09 at 18:42 +0300, Michael Tokarev wrote:
> Michael Tokarev wrote:
> > James Bottomley wrote:
> >> On Sun, 2008-03-09 at 21:29 +0900, FUJITA Tomonori wrote:
> >>> On Sun, 09 Mar 2008 14:23:13 +0300
> >>> Michael Tokarev <mjt@tls.msk.ru> wrote:
> >>>
> >>>> Just got quite.. bad situation on a production server
> >>>> here.  The machine locked up hard several times in a
> >>>> row (required hard reboot).  So I finally enabled watchdog
> >>>> subsystem which helped.
> >>>>
> >>>> Now I see the following (over netconsole):
> >>>>
> >>>> DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
> >>>> ------------[ cut here ]------------
> >>>> kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
> >>> Seems that you was out of swiommu space (and aic79xx can't handle it
> >>> though it should). This happened because:
> >>>
> >>> a) you produced more I/Os than swiommu can handle.
> >>>
> >>> b) swiommu space leaks due to bugs.
> >>>
> >>> If you hit this problem due to a), the following boot option might
> >>> help:
> >>>
> >>> swiotlb=65536
> > 
> > Running with this parameter now - no lockups so far.
> > 
> >> Actually, it's worse than this.  The aic79xx is a fully 64 bit capable
> >> PCI card, it shouldn't be using the iommu at all.  However, it has three
> >> DMA modes:  64 bit, 39 bit and 32 bit; with a corresponding resource
> >> cost increasing with the number of bits.  It employs special APIs to
> >> size the masks according to the memory, in aic79xx_osm_pci.c:
> > []
> >> Could you firstly tell me how much memory you have, and secondly
> >> instrument this code with the patch below to see if we can work out what
> >> it's doing?
> > 
> > The memory map is below (6Gb total).  The patch - kernel is being compiled
> > right now.
> 
> And here's the result (without swiotlb=65536):
> 
> DEBUG: RETURNED REQUIRED MASK ffffffff
> DEBUG: SET 32 BIT ADDRESSING
> 
> (which doesn't look like a good thing, provided this
> machine has 6Gb of memory...)

That's the root cause then.

There's a bug in the generic implementation of dma_get_required_mask(),
a fix for which is below, if you could try it (still with the debugging
patches to make sure it's working).

James

---

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index efaf282..911ec60 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -648,7 +648,7 @@ u64 dma_get_required_mask(struct device *dev)
 		high_totalram += high_totalram - 1;
 		mask = (((u64)high_totalram) << 32) + 0xffffffff;
 	}
-	return mask & *dev->dma_mask;
+	return mask;
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif




