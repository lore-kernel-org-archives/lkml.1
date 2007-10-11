Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbXJKIZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbXJKIZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXJKIZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:25:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15092 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbXJKIZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:25:35 -0400
Date: Thu, 11 Oct 2007 10:26:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Message-ID: <20071011082604.GB5142@kernel.dk>
References: <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com> <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com> <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com> <20071003163804.GR19691@waste.org> <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com> <20071004170536.GY19691@waste.org> <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com> <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com> <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com> <470D97BD.4020300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470D97BD.4020300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11 2007, Tejun Heo wrote:
> Torsten Kaiser wrote:
> > Looking closer at
> > http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=ec6fdded4d76aa54aa57341e5dfdd61c507b1dcd
> > the change to libata.h seems bogus :
> > 
> > in ata_qc_first_sg:
> > old                                new
> > return qc->__sg                    return qc->__sg
> > qc->__sg - qc->__sg == 0           qc->n_iter=0
> > -> sg - qc->__sg corresponds to qc->n_iter
> > 
> > in ata_qc_next_sg:
> > sg++;                              sg_next(sg); qc->n_iter++;
> > sg - qc->__sg < qc->n_elem         qc->n_iter < qc->nelem
> > -> sg - qc->__sg corresponds to qc->n_iter
> > 
> > but in ata_sg_is_last:
> > (sg - qc->__sg) +1 == qc->n_elem   qc->n_iter == qc->n_elem
> > if sg - qc->__sg corresponds to qc->n_iter then shoudn't it be
> > qc->n_iter+1 == qc->n_elem?
> > 
> > That missing +1 would explain, why the SGE_TRM never gets set.
> 
> Thanks a lot for tracking this down.  Does changing the above code fix
> your problem?
> 
> Jens, Torsten's analysis looks correct && depending on qc state (n_iter)
> during iteration doesn't look like a good idea.  Those iterators are not
> supposed to have side effects.  Would it be difficult to implement
> sg_last() test?

This is the old ata_sg_is_last:

static inline int
ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
{
        if (sg == &qc->pad_sgent)
                return 1;
        if (qc->pad_len)
                return 0;
        if (((sg - qc->__sg) + 1) == qc->n_elem)
                return 1;
        return 0;
}

and the new one:

static inline int
ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
{
        if (sg == &qc->pad_sgent)
                return 1;
        if (qc->pad_len)
                return 0;
        if (qc->n_iter == qc->n_elem)
                return 1; 
        return 0;
}

->n_iter is how ata_qc_next_sg() walks over the sglist, I don't
understand your reference to why depending on that during iteration
would be bad?

So we could add a test for sg_last() there, but that would turn sg table
iteration into an O(N^2) operation for those drivers that use
ata_sg_is_last() with chained sg tables. I'd much rather just get rid of
ata_sg_is_last(), it's only used to mark end-of-table entries for
hardware. That logic can be performed cheaper.

Torsten, your analysis does look correct. Does it work with this simple
patch?

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2784163..0152bf4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -947,7 +947,7 @@ ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
 		return 1;
 	if (qc->pad_len)
 		return 0;
-	if (qc->n_iter == qc->n_elem)
+	if ((qc->n_iter + 1) == qc->n_elem)
 		return 1;
 	return 0;
 }

-- 
Jens Axboe

