Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYGPEjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYGPEjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYGPEj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:39:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:56053 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYGPEj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:39:26 -0400
Date: Wed, 16 Jul 2008 13:38:50 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org, mpatocka@redhat.com,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080715.201042.193704915.davem@davemloft.net>
References: <20080713.202035.172246136.davem@davemloft.net>
	<20080715024424R.fujita.tomonori@lab.ntt.co.jp>
	<20080715.201042.193704915.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080716133902W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 20:10:42 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Tue, 15 Jul 2008 02:45:03 +0900
> 
> > dma_4u_map_sg() has:
> > 
> > if (segstart != s) {
> > 	/* We cannot merge if:
> > 	 * - allocated dma_addr isn't contiguous to previous allocation
> > 	 */
> > 	if ((dma_addr != dma_next) ||
> > 	    (outs->dma_length + s->length > max_seg_size) ||
> > 	    (is_span_boundary(out_entry, base_shift,
> > 		/* Can't merge: create a new segment */
> > 		segstart = s;
> > 		outcount++;
> > 		outs = sg_next(outs);
> > 
> > So if the IOMMU allocated dma_addr isn't contiguous to previous
> > allocation, it might not merge segments that the block layer expected
> > the IOMMU to merge.
> > 
> > We need kinda two phase merging code such as the old SPARC64 IOMMU
> > code and PARISC IOMMUs though I like the new simple SPARC64 IOMMU
> > code.
> 
> I see.
> 
> I wonder if all that complexity is really worth it.  Also, all of this
> IOMMU allocation and mapping code runs under a spinlock with hw IRQs
> disabled.
> 
> More and more I'm seeing that it's likely better to remove the VMERGE
> code.  I can't see what it really buys us anymore, and to make it work
> requires quite a large amount of complexity in the IOMMU layer.

Agreed, especially with modern HBAs, the VMERGE accounting isn't
useful, I think. The recent IOMMU implementations, Intel VT-d and AMD
virtualization one, don't do even virtual merging.

I'm fine with removing the VMERGE accounting in the block layer if
Jens and the users are happy about it.
