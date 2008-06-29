Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYF2Pk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYF2Pk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYF2Pks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:40:48 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.114]:53631 "EHLO
	mail168-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752454AbYF2Pkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:40:47 -0400
X-Greylist: delayed 1399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2008 11:40:47 EDT
X-BigFish: VPS-29(zz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j)
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K38D4O-04-698-01
Date: Sun, 29 Jun 2008 17:17:15 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 21/34] AMD IOMMU: add address allocation and deallocation functions
Message-ID: <20080629151715.GB6692@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-22-git-send-email-joerg.roedel@amd.com> <20080629234830P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629234830P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Jun 2008 15:17:15.0239 (UTC) FILETIME=[3660C770:01C8D9FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 12:07:10AM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Jun 2008 21:27:57 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the address allocator to the AMD IOMMU code.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |   48 +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 48 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index 1d70f5e..69d8d02 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -266,3 +266,51 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
> >  	return 0;
> >  }
> >  
> > +static unsigned long dma_mask_to_pages(unsigned long mask)
> > +{
> > +	return (mask >> PAGE_SHIFT) +
> > +		(PAGE_ALIGN(mask & ~PAGE_MASK) >> PAGE_SHIFT);
> > +}
> > +
> > +static unsigned long dma_ops_alloc_addresses(struct device *dev,
> > +					     struct dma_ops_domain *dom,
> > +					     unsigned int pages)
> > +{
> > +	unsigned long limit = dma_mask_to_pages(*dev->dma_mask);
> > +	unsigned long address;
> > +	unsigned long size = dom->aperture_size >> PAGE_SHIFT;
> > +	unsigned long boundary_size;
> > +
> > +	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
> > +			PAGE_SIZE) >> PAGE_SHIFT;
> > +	limit = limit < size ? limit : size;
> > +
> > +	if (dom->next_bit >= limit)
> > +		dom->next_bit = 0;
> > +
> > +	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
> > +			0 , boundary_size, 0);
> > +	if (address == -1)
> > +		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
> > +				0, boundary_size, 0);
> > +
> > +	if (likely(address != -1)) {
> > +		set_bit_string(dom->bitmap, address, pages);
> 
> Is set_bit_string() necessary here? iommu_area_alloc calls it internally.
> 

Probably not. I added it during debugging because the GART driver has it
in that code path too. I will remove it with an follow-up patch.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

