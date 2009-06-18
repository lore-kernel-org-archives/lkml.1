Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZFRUDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZFRUDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZFRUDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:03:47 -0400
Received: from sous-sol.org ([216.99.217.87]:47036 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbZFRUDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:03:46 -0400
Date: Thu, 18 Jun 2009 13:02:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'Chris Wright'" <chrisw@sous-sol.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] IOMMU Identity Mapping Support: Intel IOMMU
	implementation
Message-ID: <20090618200256.GE19771@sequoia.sous-sol.org>
References: <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090520174259.GA10646@linux-os.sc.intel.com> <20090526225146.2faeeb05.akpm@linux-foundation.org> <A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com> <20090618180527.GA24078@linux-os.sc.intel.com> <20090618191536.GD19771@sequoia.sous-sol.org> <A6AD88C3F2289247BE726C37303E1EB8B0045012@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B0045012@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yu, Fenghua (fenghua.yu@intel.com) wrote:
> >> @@ -2259,6 +2394,9 @@ static dma_addr_t __intel_map_single(struct device
> >*hwdev, phys_addr_t paddr,
> >>  	int ret;
> >>  	struct intel_iommu *iommu;
> >>
> >> +	if (identity_list(pdev))
> >> +		return paddr;
> >> +
> >
> >This is same as DUMMY_DEVICE_DOMAIN_INFO.  Please consolidate to a test
> >that just says "do i need translation".
> >
> 
> The purpose of identity_list() is to have an interface for future when we need to set 1:1 mapping on some specific devices instead of all (just like Muli Ben-Yehuda suggested earlier in this thread).
> 
> Right now it's almost empty. Yeah, I can change this checking to simply:
> if (iommu_identity_mapping)
> 	return paddr;
> 

That's fine, I figured that's why you had the list check.  But my point is
there are 2 ways to test for the same thing, which is whether a translation
is needed or not.

So a simple helper to help clarify what is going on.  Like this:

static int iommu_dummy(struct pci_device *pdev)
{
	return (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO);
}

static int iommu_no_mapping(struct pci_device *pdev)
{
	if (identity_list(pdev) || iommu_dummy(pdev))
		return 1;
	return 0;
}

> >And what about DMA mask smaller than physical memory.  The PT mode drops
> >back to swiotlb iirc.

Also...this?
