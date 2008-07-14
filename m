Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYGNRqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYGNRqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYGNRqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:46:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:36221 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYGNRqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:46:45 -0400
Date: Tue, 15 Jul 2008 02:45:03 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org, mpatocka@redhat.com,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080713.202035.172246136.davem@davemloft.net>
References: <20080713.174119.71992292.davem@davemloft.net>
	<20080714111917S.fujita.tomonori@lab.ntt.co.jp>
	<20080713.202035.172246136.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080715024424R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 20:20:35 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Mon, 14 Jul 2008 11:19:02 +0900
> 
> > Now IOMMUs don't ignore the max_segment_size. We hit this problem.
> 
> It seems simply that max_segment_size needs to propagate
> down into the block layer VMERGE code so that it can
> act accordingly.

Yeah, I think so. I'll take care of that.

But I think that even with the fix, SPARC64 IOMMU still hits the
problem.

With the VMERGE accounting enabled,

- an IOMMU must merge segments that the block layer expects the IOMMU
to merge.

- an IOMMU must return an error if it can't merge such segments.

But the current SPARC64 IOMMU code doesn't return an error if it can't
merge such segments (as POWER's IOMMU does, as you know).

dma_4u_map_sg() has:

if (segstart != s) {
	/* We cannot merge if:
	 * - allocated dma_addr isn't contiguous to previous allocation
	 */
	if ((dma_addr != dma_next) ||
	    (outs->dma_length + s->length > max_seg_size) ||
	    (is_span_boundary(out_entry, base_shift,
		/* Can't merge: create a new segment */
		segstart = s;
		outcount++;
		outs = sg_next(outs);

So if the IOMMU allocated dma_addr isn't contiguous to previous
allocation, it might not merge segments that the block layer expected
the IOMMU to merge.

We need kinda two phase merging code such as the old SPARC64 IOMMU
code and PARISC IOMMUs though I like the new simple SPARC64 IOMMU
code.
