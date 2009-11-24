Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbZKXXxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbZKXXxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934407AbZKXXxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:53:46 -0500
Received: from sh.osrg.net ([192.16.179.4]:37957 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934386AbZKXXxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:53:45 -0500
Date: Wed, 25 Nov 2009 08:48:41 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B0C2A80.5090609@kernel.org>
References: <4B0BB892.9080401@kernel.org>
	<20091124225000H.fujita.tomonori@lab.ntt.co.jp>
	<4B0C2A80.5090609@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091125084827L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Nov 2009 08:48:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 10:48:32 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> >  	if (aper_alloc) {
> >  		/* Got the aperture from the AGP bridge */
> > -	} else if (!valid_agp) {
> > +	} else if (swiotlb && !valid_agp) {
> >  		/* Do nothing */
> 
> still have some problem here.
> because you set swiotlb to 0 before. it will break
> iommu=soft

Oops, thanks. However, it's not GART specific issue.

'iommu=soft' is already broken on all the configurations. It should be
fixed separately. I've just sent a fix.


> >  void *dma_generic_alloc_coherent(struct device *dev, size_t size,
> > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > index e6a0d40..2358409 100644
> > --- a/arch/x86/kernel/pci-gart_64.c
> > +++ b/arch/x86/kernel/pci-gart_64.c
> > @@ -847,7 +847,6 @@ int __init gart_iommu_init(void)
> >  	flush_gart();
> >  	dma_ops = &gart_dma_ops;
> >  	x86_platform.iommu_shutdown = gart_iommu_shutdown;
> > -	swiotlb = 0;
> >  
> >  	return 0;
> >  }
> > diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> > index e36e71d..6971ba5 100644
> > --- a/arch/x86/kernel/pci-swiotlb.c
> > +++ b/arch/x86/kernel/pci-swiotlb.c
> > @@ -43,12 +43,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
> >  };
> >  
> >  /*
> > - * pci_swiotlb_init - initialize swiotlb if necessary
> > + * pci_swiotlb_init - set swiotlb to 1 if necessary
> 
> pci_swiotlb_detect ?

I'll fix in the next version.
