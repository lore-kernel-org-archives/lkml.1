Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYGNCUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYGNCUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYGNCU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:20:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:41411 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbYGNCUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:20:25 -0400
Date: Mon, 14 Jul 2008 11:19:02 +0900
To: davem@davemloft.net
Cc: andi@firstfloor.org, mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080713.174119.71992292.davem@davemloft.net>
References: <20080713.124610.193703496.davem@davemloft.net>
	<487A61DD.6090304@firstfloor.org>
	<20080713.174119.71992292.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080714111917S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 17:41:19 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Date: Sun, 13 Jul 2008 22:13:17 +0200
> 
> > David Miller wrote:
> > > From: Andi Kleen <andi@firstfloor.org>
> > > Date: Sun, 13 Jul 2008 15:50:55 +0200
> > > 
> > >> Still I would expect that modern IO controllers are typically fast
> > >> enough at processing SG lists that it shouldn't matter much.
> > > 
> > > I know it matters a lot on sparc64 ESP scsi controllers.
> > > 
> > > You can only have one address/len pair DMA'ing at a time and you have
> > > to service an interrupt to load in the the next DMA sg elements into
> > > the chips registers.
> > > 
> > > Merging is essentially a must for performance on those cards.
> > 
> > Well right now your setup breaks all controllers with "weird requirements"
> > like 64k DMA or similar. You'll need to find some way to turn off BIO
> > merge for those at least.
> > 
> > Perhaps this needs to be really a block queue attribute instead of a global?
> 
> Like I said, that code was written at a time when none of the block
> segment check stuff existed, and therefore worked perfectly fine in
> the environment in which it was created.
> 
> Someone added the segmenting code, but didn't bother to add proper
> checking to the merging bits.
> 
> Usually we revert code that breaks things like that, right?
> 
> So I find it unusual for people to talk about turning off the
> code that was working perfectly fine previously in situations
> like this.

Seems that there are some confusion.

It's not likely that the DMA boundary restriction causes this issue
because we set it to 4G by default.

As Mikulas pointed out, before my IOMMU work, this problem existed in
SPARC64 (and other architectures that set BIO_VMERGE_BOUNDARY to non
zero) because IOMMUs can't guarantee that they merge sg segments.

I think that now we hit this problems due to the max_segment_size.

In the past, IOMMUs aggressively merged sg entries. IOMMUs ignored the
block layer's max_segment_size (64K by default), merge sg segments,
and create a large segment. But most of LLDs can handle a segment size
larger than 64K. So everything was fine.

Now IOMMUs don't ignore the max_segment_size. We hit this problem.

It's the right thing that IOMMUs don't ignore the max_segment_size. I
guess that if the A100u2w driver sets a max_segment_size to a larger
value, the problem will be fixed. However, as we discussed, IOMMUs
can't guarantee that they merge sg segments. It's possible that we
still hit this problem.

We tell SCSI driver developers that the drivers don't get the larger
number of segments than they tell the SCSI subsystem. If we keep the
virtual merge concept, we need to fix this first.


Sorry about this problem. As I said, this problem existed before my
IOMMU work, but I should have taken care about this.
