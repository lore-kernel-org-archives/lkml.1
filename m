Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXGRUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXGRUJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXGRUJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:09:01 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16834 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbXGRUI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:08:59 -0400
Date: Wed, 18 Jul 2007 22:08:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Message-ID: <20070718200835.GK11657@kernel.dk>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com> <alpine.LFD.0.999.0707181238500.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707181238500.27353@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, Linus Torvalds wrote:
> 
> 
> On Tue, 17 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > On Tuesday 17 July 2007, Giacomo Catenazzi wrote:
> > > 
> > > last git changes to git give me the following error (repead very quickly):
> > > 
> > > sector 14657019, nr/cmr 0/0
> > > bio f7b59280, biotail f7b59280, buffer 0000000, date 0000000, len 36
> > > ide_do_rw_disk-bad command: dev hda: type 2, flags 104c8
> > 
> > ide-disk driver and type 2 (REQ_TYPE_BLOCK_PC) requests don't mix well
> 
> Hmm. I started wondering about this. 
> 
> Sure, ide-disk doesn't like non-fs requests, but I'm wondering why the 
> error apparently keeps repeating? We should error out once, and that 
> should be it.
> 
> So I'm wondering whether the
> 
> 	ide_end_request(drive, 0, 0);
> 	return ide_stopped;
> 
> is the real bug.
> 
> The thing is, non-fs requests won't have nr_sectors set, so the 0 will 
> stay as a zero (the IDE layer has some "turn zero into current sector 
> number", but that doesn't work for commands that aren't sector-based!), 
> and as a result, we'll "complete" zero bytes, and the bio will stay 
> active!
> 
> So the code should probably at the _least_ say that it's finished one 
> whole sector, and it would probably be much better to make it be based on 
> "rq->data_len", which should be reliable.
> 
> Of course, since the "ide_end_request()" takes the data in sectors, but 
> the request layer does it in bytes, we have to round the thing up and the 
> ide_end_request() thing will turn it into too many bytes, but that's ok - 
> "end_that_request_first()" doesn't care if we complete "too many" bytes.
> 
> So a diff something like this is, I think, the right thing to do, and 
> should make the IDE disk driver handle non-fs requests gracefully (it will 
> *fail* them, of course, but that's another issue).
> 
> Bartlomiej? Am I missing soemthing?

I think your analysis is pretty good, however you'd probably want to
incorporate that direct in ide_end_request(). Passing in 0 means end the
first chunk of the request, for pc type requests that should just be the
full thing as we cannot just move forward like in a read/write request.

Better still would be to make __ide_end_request() take a byte count
instead and use end_that_request_chunk(). Then you can get rid of the
rounding as well.

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c5b5011..71b317a 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -114,8 +114,12 @@ int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 	spin_lock_irqsave(&ide_lock, flags);
 	rq = HWGROUP(drive)->rq;
 
-	if (!nr_sectors)
-		nr_sectors = rq->hard_cur_sectors;
+	if (!nr_sectors) {
+		if (!blk_fs_request(rq))
+			nr_sectors = (rq->data_len + 511) >> 9;
+		else
+			nr_sectors = rq->hard_cur_sectors;
+	}
 
 	ret = __ide_end_request(drive, rq, uptodate, nr_sectors);
 

-- 
Jens Axboe

