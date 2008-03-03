Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYCCOt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYCCOt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYCCOtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:49:49 -0500
Received: from sif.is.scarlet.be ([193.74.71.28]:60044 "EHLO sif.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbYCCOts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:49:48 -0500
Date: Mon,  3 Mar 2008 15:43:38 +0100
Message-Id: <JX5SWQ$A94FF0865B1A0288BBE6757AA17AC075@scarlet.be>
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubisher@scarlet.be>
To: "tomof" <tomof@acm.org>
Cc: "kyle" <kyle@mcmartin.ca>,
       "fujita\.tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>, "tomof" <tomof@acm.org>,
       "kyle" <kyle@parisc-linux.org>, "matthew" <matthew@wil.cx>,
       "grundler" <grundler@parisc-linux.org>,
       "akpm" <akpm@linux-foundation.org>,
       "fujita\.tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: sif; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon,  3 Mar 2008 12:04:00 +0100
> "rubisher" <rubisher@scarlet.be> wrote:
> 
> > > On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> > > > This patchset is another sequel to my patchset to fix iommu segment
> > > > boundary problems, IOMMUs allocate memory areas without considering a
> > > > low level driver's segment boundary limits:
> > > > 
> > > > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> > > > 
> > > 
> > > This looks fine. Are you able to test this? If not, we can set you up
> > > with an account on a machine with remote console and all that jazz, if
> > > you'd like to.
> > > 
> > > cheers, Kyle
> > > --
[snip]
> Thanks a lot for testing!
> 
Always welcome ;-)

> Really sorry about the bug.

Don't worry, those boxes are there for my fun...

> Can you try the following patch? It's on the top of the patchset.
> 
Good catch: now this first testing system (I mean the b2k) is up and running ;-)

I will now try the ccio_dma driver on a d380 ...

hth,
    r.

> Thanks,
> 
> diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
> index 2f3b364..d0855a1 100644
> --- a/drivers/parisc/ccio-dma.c
> +++ b/drivers/parisc/ccio-dma.c
> @@ -366,8 +366,8 @@ ccio_alloc_range(struct ioc *ioc, struct device *dev,
size_t size)
>  	** ggg sacrifices another 710 to the computer gods.
>  	*/
>  
> -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
> -	boundary_size >>= IOVP_SHIFT;
> +	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
> +			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
>  
>  	if (pages_needed <= 8) {
>  		/*
> diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
> index e834127..bdbe780 100644
> --- a/drivers/parisc/sba_iommu.c
> +++ b/drivers/parisc/sba_iommu.c
> @@ -341,8 +341,8 @@ sba_search_bitmap(struct ioc *ioc, struct device *dev,
>  	unsigned long shift;
>  	int ret;
>  
> -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
> -	boundary_size >>= IOVP_SHIFT;
> +	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
> +			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
>  
>  #if defined(ZX1_SUPPORT)
>  	BUG_ON(ioc->ibase & ~IOVP_MASK);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

