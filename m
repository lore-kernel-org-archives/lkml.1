Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYGYNmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYGYNmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYGYNmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:42:13 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:49950 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYGYNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:42:11 -0400
X-BigFish: VPS-29(zz1503M1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K4KE20-03-K6X-01
Date: Fri, 25 Jul 2008 15:41:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080725134159.GA7493@amd.com>
References: <1216990680-1227-2-git-send-email-joerg.roedel@amd.com> <20080725221553Q.fujita.tomonori@lab.ntt.co.jp> <20080725132121.GZ7493@amd.com> <20080725223533A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080725223533A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Jul 2008 13:41:59.0371 (UTC) FILETIME=[363209B0:01C8EE5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 10:34:57PM +0900, FUJITA Tomonori wrote:
> On Fri, 25 Jul 2008 15:21:21 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Fri, Jul 25, 2008 at 10:15:06PM +0900, FUJITA Tomonori wrote:
> > > On Fri, 25 Jul 2008 14:57:58 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > Calculating the number of pages from given address and length numbers is a task
> > > > required in multiple IOMMU implementations. So implement this as a generic
> > > > function into the IOMMU helper code.
> > > > 
> > > > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > ---
> > > >  include/linux/iommu-helper.h |    1 +
> > > >  lib/iommu-helper.c           |    8 ++++++++
> > > >  2 files changed, 9 insertions(+), 0 deletions(-)
> > > 
> > > Thanks. I planed to work on this after rc1. You beat me. :)
> > > 
> > >  
> > > > diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
> > > > index c975caf..f8598f5 100644
> > > > --- a/include/linux/iommu-helper.h
> > > > +++ b/include/linux/iommu-helper.h
> > > > @@ -8,3 +8,4 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
> > > >  				      unsigned long align_mask);
> > > >  extern void iommu_area_free(unsigned long *map, unsigned long start,
> > > >  			    unsigned int nr);
> > > > +extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
> > > > diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
> > > > index a3b8d4c..889ddce 100644
> > > > --- a/lib/iommu-helper.c
> > > > +++ b/lib/iommu-helper.c
> > > > @@ -80,3 +80,11 @@ void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
> > > >  	}
> > > >  }
> > > >  EXPORT_SYMBOL(iommu_area_free);
> > > > +
> > > > +unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
> > > > +{
> > > > +	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
> > > > +
> > > > +	return size >> PAGE_SHIFT;
> > > > +}
> > > > +EXPORT_SYMBOL(iommu_num_pages);
> > > 
> > > This doesn't work since PAGE_SIZE != IOMMU_PAGE_SIZE on the majority
> > > of architectures.
> > 
> > A quick grep in include/ tells me that only powerpc is declaring
> > IOMMU_PAGE_SIZE by now.
> 
> Ah, I just meant the I/O size of IOMMUs.
> 
> This macro doesn't work for IA64, POWER, and SPARC.

Is there any other architecture independent way to find out the page
size the IOMMU is using? If yes I can rework that patchset. If not, I
suggest that we (you?) introduce one in a follow-on patch series and fix
the iommu_num_pages function then.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

