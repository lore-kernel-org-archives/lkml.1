Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYCCOCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYCCOCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYCCOCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:02:09 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47805 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYCCOCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:02:08 -0500
Date: Mon, 3 Mar 2008 23:01:18 +0900
To: htejun@gmail.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] block: fix residual byte count handling
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47CC036C.2060902@gmail.com>
References: <47CBFF6F.4060301@gmail.com>
	<20080303225024J.tomof@acm.org>
	<47CC036C.2060902@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080303230121M.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 22:55:56 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >>>> FUJITA Tomonori wrote:
> >>>>>>> I can't see what changing the meaning of rq->data_len (and
> >>>>>>> investigating all the block drivers) gives us.
> >>>>>> No matter which way you go, you change the meaning of rq->data_len and
> >>>>>> you MUST inspect rq->data_len usage whichever way you go.
> >>>>> The patch doens't change that rq->data_len means the true data
> >>>>> length. But yeah, it breaks rq->data_len == sum(sg). So it might break
> >>>>> some drivers.
> >>>> Yeah, that's what I was saying.  You end up breaking one of the two
> >>>> assumptions.  As sglist is getting modified for any driver if it has DMA
> >>>> alignment set, whether rq->data_len is adjusted together or not, sglist
> >>>> and data_len usages have to be audited.
> >>> My patch (well, James' original approach) doesn't affect drivers that
> >>> don't use drain buffer. rq->data_len still means the true data length
> >>> and rq->data_len is equal to sum(sg) for them. So right now we need to
> >>> audit only libata.
> >> Your patch does change sglist for any driver which sets DMA alignment.
> > 
> > I overlook it. Where does it changes sglist?
> 
> At the end of blk_rq_map_user() together with data_len / extra_len
> mangling or were you talking about James' original patch?

With my patch, at the end of blk_rq_map_user, we have:

	if (len & queue_dma_alignment(q)) {
		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;

		rq->extra_len += pad_len;
	}


So no change as compared with 2.6.24?
