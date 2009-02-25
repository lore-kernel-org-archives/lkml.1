Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbZBYLOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbZBYLOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762080AbZBYLOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:14:32 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:13526
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758132AbZBYLOb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:14:31 -0500
X-BigFish: VPS-21(zz1432R98dR1805M936fK873fnzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KFMCJT-02-6L2-01
Date: Wed, 25 Feb 2009 12:14:19 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 15/16] dma-debug: x86 architecture bindings
Message-ID: <20090225111419.GL8751@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com> <1232376423-11067-16-git-send-email-joerg.roedel@amd.com> <20090222155050W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090222155050W.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Feb 2009 11:14:19.0321 (UTC) FILETIME=[3401F290:01C9973A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 03:50:46PM +0900, FUJITA Tomonori wrote:
> On Mon, 19 Jan 2009 15:47:02 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Impact: make use of DMA-API debugging code in x86
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/Kconfig                   |    1 +
> >  arch/x86/include/asm/dma-mapping.h |   45 +++++++++++++++++++++++++++++++----
> >  arch/x86/kernel/pci-dma.c          |    6 ++++
> >  3 files changed, 46 insertions(+), 6 deletions(-)
> 
> (snip)
> 
> >  static inline int
> > @@ -79,9 +86,13 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
> >  	   int nents, enum dma_data_direction dir)
> >  {
> >  	struct dma_map_ops *ops = get_dma_ops(hwdev);
> > +	int ents;
> >  
> >  	BUG_ON(!valid_dma_direction(dir));
> > -	return ops->map_sg(hwdev, sg, nents, dir, NULL);
> > +	ents = ops->map_sg(hwdev, sg, nents, dir, NULL);
> > +	debug_dma_map_sg(hwdev, sg, ents, dir);
> 
> The way to handle dma_map_sg and dma_unmap_sg looks wrong.
> 
> ents could be smaller than nents here with IOMMU implementations that
> merge several sg entries into one.
> 
> 
> > +	return ents;
> >  }
> >  
> >  static inline void
> > @@ -91,6 +102,7 @@ dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
> >  	struct dma_map_ops *ops = get_dma_ops(hwdev);
> >  
> >  	BUG_ON(!valid_dma_direction(dir));
> > +	debug_dma_unmap_sg(hwdev, sg, nents, dir);
> 
> Here the nents is the same one you passed into dma_map_sg call. It is
> not the value returned from dma_map_sg (see DMA-mapping.txt).
> 
> So we call check_unmap for entries that we didn't call add_dma_entry
> for on dma_map_sg. These entries are not initialized so we could get any
> kinds of warnings from check_unmap.

Ah, you are right. I mis-read the documentation. I will fix this in the
next release.

Joerg


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

