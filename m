Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZJVPBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZJVPBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZJVPBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:01:42 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:45854 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZJVPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:01:42 -0400
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
From: Alex Williamson <alex.williamson@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1256222867.2990.47.camel@macbook.infradead.org>
References: <1256182910.2842.36.camel@2710p.home>
	 <1256192928.2990.10.camel@macbook.infradead.org>
	 <1256214241.2842.50.camel@2710p.home>
	 <1256222867.2990.47.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: HP OSLO R&D
Date: Thu, 22 Oct 2009 09:01:16 -0600
Message-Id: <1256223676.3615.68.camel@8530w.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 23:47 +0900, David Woodhouse wrote:
> On Thu, 2009-10-22 at 06:24 -0600, Alex Williamson wrote:
> > The coherent_dma_mask is independent of the dma_mask and can be set
> > separately by the device.  The default for any device that doesn't
> > specify one is 32bits.  iommu_should_identity_map() only checks the
> > dma_mask, not the coherent_dma_mask. 
> 
> Are you telling me that this particular device supports only a 32-bit
> coherent DMA mask, but that it _does_ support a 64-bit DMA mask for
> non-coherent DMA? On x86?

Yes, yes.  AFAIK, this is not that exceptional.

> >  BTW, we skip RMRR setup when doing hardware pass-through, but I can't
> > find where they get reloaded if we then end up removing the device
> > from the si_domain.  Is this another issue?
> 
> Maybe, theoretically. In practice, the whole RMRR thing is just broken
> by design anyway. We have to quiesce the offending devices before we
> turn on the IOMMU, because BIOSes tend to leave things out of the RMRR
> table... and then crash in SMM mode when their DMA goes AWOL. 

Hmm, we've had a lot of trouble getting our RMRRs to reflect shared
memory regions correctly, so I'm reluctant to just drop them like that.

Another issue, iommu_should_identity_map() only dumps devices if their
dma_mask is 32bit or less, but being greater than 32bits does not imply
64bit DMA support.  If the device exports a DMA mask that's less than
the physical address width of the processor, you might be in trouble
(for example, a 40bit dma_mask on a platform that supports 44bits for
physical memory).  Maybe dropping swiotlb out of the picture isn't such
a clean solution?  Thanks,

Alex


