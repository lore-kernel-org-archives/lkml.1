Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZJVG2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZJVG2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZJVG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:28:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:57392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZJVG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:28:53 -0400
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1256182910.2842.36.camel@2710p.home>
References: <1256182910.2842.36.camel@2710p.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Oct 2009 15:28:48 +0900
Message-Id: <1256192928.2990.10.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 21:41 -0600, Alex Williamson wrote:
> After 19943b0e (intel-iommu: Unify hardware and software passthrough
> support) hardware pass-through mode devices make use of intel_dma_ops
> rather than swiotlb_dma_ops.  The problem is that intel_alloc_coherent
> ignores the device coherent_dma_mask when allocating the page since it
> expects to remap the page and provide the device with an iova within the
> coherent mask.  This breaks when we use pass-through.
> 
> The patch below crudely works around the problem, but I hope we can come
> up with something better without reintroducing the dependency on
> swiotlb.  The device hitting this problem is an HP smart array
> controller on a Proliant G6 system.  It uses a default 32bit coherent
> DMA mask, and stalls, presumably waiting on control data to change in
> the wrong address space, when it gets a coherent buffer above 4G.  This
> device also doesn't exactly play nice when using VT-d in anything other
> than pass-through mode, so switching it into mapped mode is not really
> an option.

I don't understand. If your device can't cope with 64-bit addresses,
then surely iommu_no_mapping() should return _false_ for it. And we'll
actually use the IOMMU even though we're generally in passthrough mode.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

