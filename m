Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbXLTTL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbXLTTL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXLTTLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:11:49 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:48175 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbXLTTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:11:48 -0500
Message-ID: <476ABE60.9030805@opengridcomputing.com>
Date: Thu, 20 Dec 2007 13:11:28 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Benjamin Herrenschmidt <bherren@au1.ibm.com>, linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Wen Xiong <wenxiong@us.ibm.com>
Subject: Re: [ofa-general] iommu dma mapping alignment requirements
References: <476AA2E2.5010007@opengridcomputing.com> <adalk7pz1ck.fsf@cisco.com>
In-Reply-To: <adalk7pz1ck.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > It appears that my problem boils down to a single host page of memory
>  > that is mapped for dma, and the dma address returned by dma_map_sg()
>  > is _not_ 64KB aligned.  Here is an example:
> 
>  > My first question is: Is there an assumption or requirement in linux
>  > that dma_addressess should have the same alignment as the host address
>  > they are mapped to?  IE the rdma core is mapping the entire 64KB page,
>  > but the mapping doesn't begin on a 64KB page boundary.
> 
> I don't think this is explicitly documented anywhere, but it certainly
> seems that we want the bus address to be page-aligned in this case.
> For mthca/mlx4 at least, we tell the adapter what the host page size
> is (so that it knows how to align doorbell pages etc) and I think this
> sort of thing would confuse the HW.
> 
>  - R.


In arch/powerpc/kernel/iommu.c:iommu_map_sg() I see that it calls 
iommu_range_alloc() with a alignment_order of 0:

>                 vaddr = (unsigned long)page_address(s->page) + s->offset;
>                 npages = iommu_num_pages(vaddr, slen);
>                 entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);

But perhaps the alignment order needs to be based on the host page size?


Steve.
