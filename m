Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbXJQTt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbXJQTt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbXJQTtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:49:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18239 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbXJQTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:49:49 -0400
Date: Wed, 17 Oct 2007 21:49:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017194944.GB15552@kernel.dk>
References: <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017193542.GA15552@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Jens Axboe wrote:
> On Wed, Oct 17 2007, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 17 Oct 2007, Ingo Molnar wrote:
> > > 
> > > nope, this did not help. First bootup went fine, second bootup crashed 
> > > again (see below), without hitting the BUG_ON().
> > 
> > I think you'll always hit it if you have a scatter-gather list that is 
> > exactly filled up.
> > 
> > Why? Because those things do "sg_next()" on the last entry, and as 
> > mentioned, that ends up actually accessing one past the end - even if the 
> > end result is not actually ever *used* (because we just effectively 
> > incremented it to past the last entry when the code was done with the SG 
> > list).

Well, hang on - where does it end up doing sg_next() on the LAST sg
entry? I'd argue that this is a bug, like it was in ll_rw_blk.c. I still
agree that I should make the interface more robust, I just don't see
where libata ends up doing the sg_next() on the last entry.

I'm assuming that Ingo is using the previous patches, so that
blk_rq_map_sg() is using this construct:

new_segment:
       if (!sg)
               sg = sglist;
       else
               sg = sg_next(sg);

and the memset() in scsi_alloc_sgtable(), which I'm pretty sure he is.
I'm assuming we're not hitting pio paths, so there are no manual
sg_next() calls. Ingo, if you care, can you test this one as well?

No rush, as mentioned I'll be back tomorrow morning...

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbaa545..0246b61 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4664,7 +4664,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
+	struct scatterlist *lsg = &qc->__sg[qc->n_elem - 1];
 	int n_elem, pre_n_elem, dir, trim_sg = 0;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);

-- 
Jens Axboe

