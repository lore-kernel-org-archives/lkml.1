Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZJVMX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZJVMX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZJVMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:23:58 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16245 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZJVMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:23:58 -0400
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
From: Alex Williamson <alex.williamson@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1256192928.2990.10.camel@macbook.infradead.org>
References: <1256182910.2842.36.camel@2710p.home>
	 <1256192928.2990.10.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Oct 2009 06:24:01 -0600
Message-ID: <1256214241.2842.50.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 15:28 +0900, David Woodhouse wrote:
> On Wed, 2009-10-21 at 21:41 -0600, Alex Williamson wrote:
> > After 19943b0e (intel-iommu: Unify hardware and software passthrough
> > support) hardware pass-through mode devices make use of intel_dma_ops
> > rather than swiotlb_dma_ops.  The problem is that intel_alloc_coherent
> > ignores the device coherent_dma_mask when allocating the page since it
> > expects to remap the page and provide the device with an iova within the
> > coherent mask.  This breaks when we use pass-through.
> > 
> > The patch below crudely works around the problem, but I hope we can come
> > up with something better without reintroducing the dependency on
> > swiotlb.  The device hitting this problem is an HP smart array
> > controller on a Proliant G6 system.  It uses a default 32bit coherent
> > DMA mask, and stalls, presumably waiting on control data to change in
> > the wrong address space, when it gets a coherent buffer above 4G.  This
> > device also doesn't exactly play nice when using VT-d in anything other
> > than pass-through mode, so switching it into mapped mode is not really
> > an option.
> 
> I don't understand. If your device can't cope with 64-bit addresses,
> then surely iommu_no_mapping() should return _false_ for it. And we'll
> actually use the IOMMU even though we're generally in passthrough mode.

The coherent_dma_mask is independent of the dma_mask and can be set
separately by the device.  The default for any device that doesn't
specify one is 32bits.  iommu_should_identity_map() only checks the
dma_mask, not the coherent_dma_mask.  We never see "32bit %s uses
non-identity mapping" for this device, and I suspect if we did it also
wouldn't work because of the mentioned unfriendliness in mapped mode.
Since coherent mappings are generally a slow path, I think we should be
making more effort to get a usable buffer before dumping the device out
of passthrough mode.  BTW, we skip RMRR setup when doing hardware
pass-through, but I can't find where they get reloaded if we then end up
removing the device from the si_domain.  Is this another issue?  Thanks,

Alex


