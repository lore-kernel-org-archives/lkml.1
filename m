Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXJWH17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXJWH17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXJWH1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:27:52 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11116 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbXJWH1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:27:51 -0400
Date: Tue, 23 Oct 2007 09:26:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 08/10] [SG] Update arch/ to use sg helpers
Message-ID: <20071023072626.GI25962@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-9-git-send-email-jens.axboe@oracle.com> <471D11DC.20007@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D11DC.20007@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007, Benny Halevy wrote:
> It looks like it could be nice to define and use a helper for
> page_address(sg_page(sg)) (although 11 call sites could use it
> after this patch)
> 
> #define sg_pgaddr(sg) page_address(sg_page(sg))
> 
> Note that mips sg_{un,}map_sg checked for page_address(sg->page) != 0
> before calling __dma_sync(addr + sg->offset, sg->length, direction)
> and you changed it to addr = (unsigned long) sg_virt(sg) which
> takes sg->offset into account.  That said I'm not sure if the original
> code was correct for the (page_address(sg->page) == 0 && sg->offset != 0)
> case...

I initially thought that may have been a bug, but most of the other arch
iommu code handle it in the same way. I don't think it's a bug, since
they want to clear full page ranges anyway. I should not have changed
this code to take the offset into account - I don't think it's an issue,
but it should have been left as-is. Will do that.

> > diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> > index 5098f58..1a20fe3 100644
> > --- a/arch/x86/kernel/pci-calgary_64.c
> > +++ b/arch/x86/kernel/pci-calgary_64.c
> > @@ -411,8 +411,10 @@ static int calgary_nontranslate_map_sg(struct device* dev,
> >  	int i;
> >  
> >  	for_each_sg(sg, s, nelems, i) {
> > -		BUG_ON(!s->page);
> > -		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
> > +		struct page *p = sg_page(s);
> > +
> > +		BUG_ON(!p);
> 
> why not just BUG_ON(!sg_page(s))?
> 
> > +		s->dma_address = virt_to_bus(sg_virt(s));
> >  		s->dma_length = s->length;
> >  	}
> >  	return nelems;

I think because of a two stage conversion, the page variable addition
predates the sg_virt() helper.

-- 
Jens Axboe

