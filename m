Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbXJQJYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbXJQJYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXJQJY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:24:28 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:35252 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbXJQJY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:24:26 -0400
To: jens.axboe@oracle.com
Cc: davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071017091629.GK5043@kernel.dk>
References: <20071017084528.GI5043@kernel.dk>
	<20071017.021305.74746838.davem@davemloft.net>
	<20071017091629.GK5043@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017182401X.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 17 Oct 2007 18:24:01 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 11:16:29 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Oct 17 2007, David Miller wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Wed, 17 Oct 2007 10:45:28 +0200
> > 
> > > Righto, it's invalid to call sg_next() on the last entry!
> > 
> > Unfortunately, that's what the sparc64 code wanted to do, this
> > transformation in the sparc64 sg chaining patch is not equilavent:
> > 
> > -	struct scatterlist *sg_end = sg + nelems;
> > +	struct scatterlist *sg_end = sg_last(sg, nelems);
> >  ...
> > -			while (sg < sg_end &&
> > +			while (sg != sg_end &&
> 
> Auch indeed. That'd probably be better as a
> 
>         do {
>                 ...
>         } while (sg != sg_end);
> 
> > No, that's not what the code was doing.  The while loop
> > has to process the last entry in the list,
> > 
> > We really needed "sg_end" to be "one past the last element",
> > rather than "the last element".
> > 
> > Since you say that sg_next() on the last entry is illegal,
> > and that's what this code would have done to try and reach
> > loop termination (it doesn't actually derefrence that
> > "end plus one" scatterlist entry) I'll try to code this up
> > some other way.
> > 
> > Besides, sg_last() is so absurdly expensive, it has to walk the entire
> > chain in the chaining case.  So better to implement this without it.
> 
> It is, sg_last() should really not be used a lot since it'll leaf
> through the entire sg list. People should either keep count of the
> number of entries so that they know when they are dealing with the last
> valid entry. Or use the for_each_sg() loop helper, if possible.
> 
> Drivers are usually very simple, the iommu code does more sg tricks and
> thus is more complex to audit.

Can we just remove sg_last?


> > I would suggest that other sg_last() uses be audited for the same bug.
> 
> Agree.

Only libata, I think.
