Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0BKQqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:46:00 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:50486
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753336Ab0BKQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:45:59 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzab9bh1432R98dN148cMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXORWA-01-8H8-02
X-M-MSG: 
Date: Thu, 11 Feb 2010 17:45:35 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Don Dutile <ddutile@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] x86/amd-iommu: Add flush_info to protection domains
Message-ID: <20100211164535.GE22141@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
 <1265898797-32183-2-git-send-email-joerg.roedel@amd.com>
 <4B7432E2.9090902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B7432E2.9090902@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2010 16:45:36.0682 (UTC) FILETIME=[A2D4C8A0:01CAAB39]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 11:40:02AM -0500, Don Dutile wrote:
> Joerg Roedel wrote:
> > This patch adds a new sub-struct to protection domains which
> > is used to keep information about what parts of the domain
> > needs to be flushed on the hardware side.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/include/asm/amd_iommu_types.h |   11 +++++++++++
> >  arch/x86/kernel/amd_iommu.c            |   23 +++++++++++++++++++++++
> >  2 files changed, 34 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
> > index ba19ad4..30c4410 100644
> > --- a/arch/x86/include/asm/amd_iommu_types.h
> > +++ b/arch/x86/include/asm/amd_iommu_types.h
> > @@ -230,6 +230,16 @@ extern bool amd_iommu_np_cache;
> >  #define APERTURE_PAGE_INDEX(a)	(((a) >> 21) & 0x3fULL)
> >  
> >  /*
> > + * This struct holds information about the parts of a protection domain that
> > + * needs to be flushed on the IOMMU hardware.
> > + */
> > +struct flush_info {
> > +	bool tlb;
> > +	u64 start;
> > +	u64 end;
> > +};
> > +
> > +/*
> >   * This structure contains generic data for  IOMMU protection domains
> >   * independent of their use.
> >   */
> > @@ -244,6 +254,7 @@ struct protection_domain {
> >  	bool updated;		/* complete domain flush required */
> >  	unsigned dev_cnt;	/* devices assigned to this domain */
> >  	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
> > +	struct flush_info flush;
> >  	void *priv;		/* private data */
> >  
> >  };
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index adb0ba0..fcb85e8 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -78,6 +78,19 @@ static struct iommu_dev_data *get_dev_data(struct device *dev)
> >  	return dev->archdata.iommu;
> >  }
> >  
> > +static void update_flush_info_tlb(struct protection_domain *domain,
> > +				  u64 start, u64 end)
> > +{
> > +	if (!domain->flush.tlb) {
> > +		domain->flush.tlb   = true;
> > +		domain->flush.start = start;
> > +		domain->flush.end   = end;
> > +	} else {
> > +		domain->flush.start = min(start, domain->flush.start);
> > +		domain->flush.end   = max(end  , domain->flush.end);
> > +	}
> > +}
> > +
> 
> the code has start/end here.... but callers below.... 
> 
> >  /*
> >   * In this function the list of preallocated protection domains is traversed to
> >   * find the domain for a specific device
> > @@ -1849,6 +1862,9 @@ retry:
> >  
> >  	ADD_STATS_COUNTER(alloced_io_mem, size);
> >  
> > +	if (unlikely(amd_iommu_np_cache))
> > +		update_flush_info_tlb(&dma_dom->domain, start, size);
> > +
> 
> use start/size .... 
> >  	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
> >  		iommu_flush_tlb(&dma_dom->domain);
> >  		dma_dom->need_flush = false;
> > @@ -1895,6 +1911,8 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
> >  		start += PAGE_SIZE;
> >  	}
> >  
> > +	update_flush_info_tlb(&dma_dom->domain, dma_addr, size);
> > +
> use start/size .... 
> 
> so is end a size in update_flush_info_tlb() , or should size be dma_addr+size 
> in the callers of update_flush_info_tlb() ?

Right, this is a bug. Thanks for pointing that out.

	Joerg

