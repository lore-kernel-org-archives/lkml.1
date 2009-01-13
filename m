Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZAMIn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZAMIn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZAMIns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:43:48 -0500
Received: from brick.kernel.dk ([93.163.65.50]:28237 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbZAMInr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:43:47 -0500
Date: Tue, 13 Jan 2009 09:42:29 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: new barrier warnings in 2.6.29-rc1
Message-ID: <20090113084229.GL30821@kernel.dk>
References: <20090112154634.GA15730@lst.de> <496C0915.6000107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496C0915.6000107@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13 2009, Tejun Heo wrote:
> (cc'ing Jens)
> Hello,
> 
> Christoph Hellwig wrote:
> > Whever a filesystem submits a bio with the barrier flag set but
> > the underlying hardware doesn't support it we now get errors in
> > the form of:
> > 
> > [ 3046.442629] end_request: I/O error, dev vdb, sector 0
> > 
> > since commit a7384677b2f4cd40948fd7ce024ba5e1821444ba which removed
> > the early check on the queue capabilities in __make_request.  I
> > think this message is pretty annoying and confusing for the user
> > as the filesystems already have more descriptive warnings, e.g. for
> > XFS:
> > 
> > [ 3046.455478] Filesystem "vdb": Disabling barriers, trial barrier write failed
> 
> I think the right thing to do is setting REQ_QUIET on the trial
> barrier request.

It would surely work, but XFS doesn't really have a way to do that. Then
we would have to add a bio quiet flag and inherit that.

I kind of liked the old behaviour. What about something like the below?

diff --git a/block/blk-core.c b/block/blk-core.c
index a824e49..eddba4a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1448,6 +1448,11 @@ static inline void __generic_make_request(struct bio *bio)
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
+		if (bio_barrier(bio) && bio_has_data(bio) &&
+		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+			err = -EOPNOTSUPP;
+			goto end_io;
+		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);

-- 
Jens Axboe

