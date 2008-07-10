Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYGJNVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYGJNVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYGJNU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:20:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40256 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbYGJNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:20:57 -0400
X-BigFish: VPS-29(zz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j)
X-WSS-ID: 0K3SL2F-04-FO2-01
Date: Thu, 10 Jul 2008 15:20:09 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 25/34] AMD IOMMU: add dma_ops mapping functions for single mappings
Message-ID: <20080710132009.GP14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-26-git-send-email-joerg.roedel@amd.com> <20080709192606.c4f0c2cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709192606.c4f0c2cf.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 13:20:09.0181 (UTC) FILETIME=[AD10A8D0:01C8E28F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 07:26:06PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:28:01 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the dma_ops specific mapping functions for single mappings.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |   59 +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 59 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index e00a3e7..b4079f6 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -40,6 +40,11 @@ struct command {
> >  static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
> >  			     struct unity_map_entry *e);
> >  
> > +static int iommu_has_npcache(struct amd_iommu *iommu)
> > +{
> > +	return iommu->cap & IOMMU_CAP_NPCACHE;
> > +}
> > +
> >  static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
> >  {
> >  	u32 tail, head;
> > @@ -641,3 +646,57 @@ static void __unmap_single(struct amd_iommu *iommu,
> >  	dma_ops_free_addresses(dma_dom, dma_addr, pages);
> >  }
> >  
> > +static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
> > +			     size_t size, int dir)
> > +{
> > +	unsigned long flags;
> > +	struct amd_iommu *iommu;
> > +	struct protection_domain *domain;
> > +	u16 devid;
> > +	dma_addr_t addr;
> > +
> > +	get_device_resources(dev, &iommu, &domain, &devid);
> > +
> > +	if (iommu == NULL || domain == NULL)
> > +		return (dma_addr_t)paddr;
> 
> OK, a test case.  A reader of your code (ie: me) wants to find out what
> this code is doing.  What is the *meaning* of iommu == NULL || domain ==
> NULL here?
> 
> I go look at the (undocumented) get_device_resources() and I see that this:
> 
>        if (_bdf >= amd_iommu_last_bdf) {
> 
> happened.  I don't know what that semantically means and I gave up.
> 
> I'm not saying that the code is unmaintainable, but I would assert that it
> is a heck of a lot harder to maintain than it could be, and than it should
> be.
> 
> get_device_resources() has an open-coded copy of your DEVID() macro, btw.

Ok, thats a bit weird. If the check above fails it means that we have a
device the IOMMU is not translating. In this case the code just returns
the physical address of the buffer. I will add a comment for that too.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

