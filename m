Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYGPDLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYGPDLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYGPDKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:10:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33502
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758105AbYGPDKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:10:43 -0400
Date: Tue, 15 Jul 2008 20:10:42 -0700 (PDT)
Message-Id: <20080715.201042.193704915.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: andi@firstfloor.org, mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080715024424R.fujita.tomonori@lab.ntt.co.jp>
References: <20080714111917S.fujita.tomonori@lab.ntt.co.jp>
	<20080713.202035.172246136.davem@davemloft.net>
	<20080715024424R.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 15 Jul 2008 02:45:03 +0900

> dma_4u_map_sg() has:
> 
> if (segstart != s) {
> 	/* We cannot merge if:
> 	 * - allocated dma_addr isn't contiguous to previous allocation
> 	 */
> 	if ((dma_addr != dma_next) ||
> 	    (outs->dma_length + s->length > max_seg_size) ||
> 	    (is_span_boundary(out_entry, base_shift,
> 		/* Can't merge: create a new segment */
> 		segstart = s;
> 		outcount++;
> 		outs = sg_next(outs);
> 
> So if the IOMMU allocated dma_addr isn't contiguous to previous
> allocation, it might not merge segments that the block layer expected
> the IOMMU to merge.
> 
> We need kinda two phase merging code such as the old SPARC64 IOMMU
> code and PARISC IOMMUs though I like the new simple SPARC64 IOMMU
> code.

I see.

I wonder if all that complexity is really worth it.  Also, all of this
IOMMU allocation and mapping code runs under a spinlock with hw IRQs
disabled.

More and more I'm seeing that it's likely better to remove the VMERGE
code.  I can't see what it really buys us anymore, and to make it work
requires quite a large amount of complexity in the IOMMU layer.
