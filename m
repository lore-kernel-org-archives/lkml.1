Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbYF3N0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbYF3N0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbYF3NZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:25:57 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:13610 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYF3NZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:25:56 -0400
X-BigFish: VPS-39(zz1432R98dR7efV1805M179dR873fnzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3A2MV-03-HTU-01
Date: Mon, 30 Jun 2008 15:25:45 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 26/34] AMD IOMMU: add mapping functions for scatter gather lists
Message-ID: <20080630132545.GP1303@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-27-git-send-email-joerg.roedel@amd.com> <20080630000023F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080630000023F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 30 Jun 2008 13:25:45.0390 (UTC) FILETIME=[CD5494E0:01C8DAB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 12:07:16AM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Jun 2008 21:28:02 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the dma_ops functions for mapping and unmapping scatter gather
> > lists.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |   98 +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 98 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index b4079f6..f4747fe 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -700,3 +700,101 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
> >  	spin_unlock_irqrestore(&domain->lock, flags);
> >  }
> >  
> > +static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
> > +			   int nelems, int dir)
> > +{
> > +	struct scatterlist *s;
> > +	int i;
> > +
> > +	for_each_sg(sglist, s, nelems, i) {
> > +		s->dma_address = (dma_addr_t)sg_phys(s);
> > +		s->dma_length  = s->length;
> > +	}
> > +
> > +	return nelems;
> > +}
> > +
> > +static int map_sg(struct device *dev, struct scatterlist *sglist,
> > +		  int nelems, int dir)
> > +{
> > +	unsigned long flags;
> > +	struct amd_iommu *iommu;
> > +	struct protection_domain *domain;
> > +	u16 devid;
> > +	int i;
> > +	struct scatterlist *s;
> > +	phys_addr_t paddr;
> > +	int mapped_elems = 0;
> > +
> > +	get_device_resources(dev, &iommu, &domain, &devid);
> > +
> > +	if (!iommu || !domain)
> > +		return map_sg_no_iommu(dev, sglist, nelems, dir);
> 
> VT-d put a pointer in struct dev_archdata to store IOMMU info per
> device. Is is useful for you too?

Hmm yes. Thank you for that hint. I can save at least one of my arrays
with that method.

Joerg


-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

