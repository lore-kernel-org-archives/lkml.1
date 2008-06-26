Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYFZGgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYFZGgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYFZGgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:36:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3338 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYFZGgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:36:01 -0400
Date: Thu, 26 Jun 2008 08:35:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stern@rowland.harvard.edu, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, antonio.lin@alcormicro.com,
       david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
Message-ID: <20080626063559.GJ20851@kernel.dk>
References: <20080625091813Z.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.44L0.0806251017320.2578-100000@iolanthe.rowland.org> <20080626110615U.fujita.tomonori@lab.ntt.co.jp> <20080626143928P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626143928P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26 2008, FUJITA Tomonori wrote:
> On Thu, 26 Jun 2008 11:06:03 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Wed, 25 Jun 2008 10:23:00 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > On Wed, 25 Jun 2008, FUJITA Tomonori wrote:
> > > 
> > > > > For example, suppose an I/O request starts out with two S-G elements
> > > > > of 1536 bytes and 2048 bytes respectively, and the DMA requirement is
> > > > > that all elements except the last must have length divisible by 1024.  
> > > > > Then the request could be broken up into three requests of 1024, 512,
> > > > > and 2048 bytes.
> > > > 
> > > > I can't say that it's easy to implement a clean mechanism to break up
> > > > a request into multiple requests until I see a patch.
> > > 
> > > And I can't write a patch without learning a lot more about how the
> > > block core works.
> > > 
> > > > What I said is that you think that this is about extending something
> > > > in the block layer but it's about adding a new concept to the block
> > > > layer.
> > > 
> > > Is it?  What does the block layer do when it receives an I/O request
> > > that don't satisfy the other constraints (max_sectors or
> > > dma_alignment_mask, for example)?
> > 
> > As I explained, you need something new.
> > 
> > I don't think that max_sectors works as you expect.
> 
> The block layer looks at max_sectors when merging two things (or add
> one to another). So the test fails, it doesn't merge them.
> 
> 
> > dma_alignment_mask is not used in the FS path. And I think that
> > dma_alignment_mask doens't solve your problems.
> 
> If dma_alignment_mask test fails, the block layer allocates temporary
> buffers and does memory copies.

I don't think adding anything in the general IO path makes a lot of
sense, this is a really screwy case. I don't mind adding work-arounds to
the block layer to cater for hardware weirdness, but this is getting a
little silly. We could provide a helper function for 'bouncing' this
request and thus reuse the block bounce buffer for this, but I'm not
even sure how to simply express this generically. As it is likely of no
use outside of this specific case, putting it in the driver (or usb
layer, if you expect more of these similar cases) is the best option.

-- 
Jens Axboe

