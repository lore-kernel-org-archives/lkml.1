Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbXJKK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbXJKK2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbXJKK2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:28:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10712 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXJKK2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:28:13 -0400
Date: Thu, 11 Oct 2007 12:28:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Message-ID: <20071011102840.GG5142@kernel.dk>
References: <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com> <20071003163804.GR19691@waste.org> <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com> <20071004170536.GY19691@waste.org> <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com> <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com> <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com> <470D97BD.4020300@gmail.com> <20071011082604.GB5142@kernel.dk> <470DE09D.7080508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470DE09D.7080508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11 2007, Tejun Heo wrote:
> Jens Axboe wrote:
> > This is the old ata_sg_is_last:
> > 
> > static inline int
> > ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
> > {
> >         if (sg == &qc->pad_sgent)
> >                 return 1;
> >         if (qc->pad_len)
> >                 return 0;
> >         if (((sg - qc->__sg) + 1) == qc->n_elem)
> >                 return 1;
> >         return 0;
> > }
> > 
> > and the new one:
> > 
> > static inline int
> > ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
> > {
> >         if (sg == &qc->pad_sgent)
> >                 return 1;
> >         if (qc->pad_len)
> >                 return 0;
> >         if (qc->n_iter == qc->n_elem)
> >                 return 1; 
> >         return 0;
> > }
> > 
> > ->n_iter is how ata_qc_next_sg() walks over the sglist, I don't
> > understand your reference to why depending on that during iteration
> > would be bad?
> 
> Because that makes ata_sg iterator macros have hidden side effects
> (nothing in the interface suggests it can't be nested and when somebody
> actually nests it, finding what went wrong can be pretty difficult).  I
> think it would be better to have explicit ata_sg_iter passed around if
> sg itself isn't enough to walk the sg list.

I think it's implicit in the interface, since you don't pass an sgtable
in. But it's not a big deal to me, if you want it changed, go ahead :-)

> > So we could add a test for sg_last() there, but that would turn sg table
> > iteration into an O(N^2) operation for those drivers that use
> > ata_sg_is_last() with chained sg tables. I'd much rather just get rid of
> > ata_sg_is_last(), it's only used to mark end-of-table entries for
> > hardware. That logic can be performed cheaper.
> 
> Yeap, it can be removed but having "is this the last one?" test is just
> nicer to low level drivers.  With ata_sg_iter, I think we can do it in
> O(N) by looking up and caching the next entry.

Sure, of you could just lookup sg_last() in the beginning of the loop.
Still seems a bit silly to me just to keep the ata_sg_is_last()
interface, since it can be done for free basically by maintaining an
sglast element in the loop that you then use when the loop is done to
set your SG_END marker (or whatever the driver needs).

-- 
Jens Axboe

