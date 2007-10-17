Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbXJQUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbXJQUHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbXJQUGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:06:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12661 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884AbXJQUGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:06:45 -0400
Date: Wed, 17 Oct 2007 22:06:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017200638.GE15552@kernel.dk>
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <alpine.LFD.0.999.0710171244330.26902@woody.linux-foundation.org> <20071017195659.GD15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017195659.GD15552@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Jens Axboe wrote:
> On Wed, Oct 17 2007, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 17 Oct 2007, Jens Axboe wrote:
> > > 
> > > OK, I think you have a very good point here. Ingo, can you verify it
> > > goes away if apply the below? I have to tend to Other Life stuff but
> > > will take this up again tomorrow morning and fix the sg_next() usage.
> > 
> > This one will only fix the ones that use the SCSI-lib routines, so it will 
> > leave everything else broken, no?
> 
> Yes, it'll still crap out if you use debug page alloc for anything else
> :/

So until that is fixed up, how about this? Should cover all block
devices, and I don't think sg_next()/for_each_sg() has spread outside of
that yet.

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3935469..8708ad0 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -631,7 +631,7 @@ void blk_queue_max_phys_segments(struct request_queue *q,
 		printk("%s: set to minimum %d\n", __FUNCTION__, max_segments);
 	}
 
-	q->max_phys_segments = max_segments;
+	q->max_phys_segments = max_segments - 1;
 }
 
 EXPORT_SYMBOL(blk_queue_max_phys_segments);

-- 
Jens Axboe

