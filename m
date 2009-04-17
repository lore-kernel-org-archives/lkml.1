Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZDQMaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZDQMaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZDQMa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:30:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZDQMa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:30:26 -0400
Date: Fri, 17 Apr 2009 14:30:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH v2] block: simplify I/O stat accounting
Message-ID: <20090417123025.GW4593@kernel.dk>
References: <49E72F19.1030400@redhat.com> <49E8662D.5010607@redhat.com> <20090417113756.GU4593@kernel.dk> <20090417115449.GV4593@kernel.dk> <49E87502.3050806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E87502.3050806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17 2009, Jerome Marchand wrote:
> Jens Axboe wrote:
> > On Fri, Apr 17 2009, Jens Axboe wrote:
> >> On second thought, not sure why you add 'iostat' for this. It would be
> >> OK to just do
> >>
> >>         if (blk_queue_io_stat(q))
> >>                 rw_flags |= REQ_IO_STAT;
> >>
> >> since it's just used for the allocation call, and the trace call (which
> >> does & 1 on it anyway).
> >>
> OK.
> 
> >>> diff --git a/block/blk-merge.c b/block/blk-merge.c
> >>> index 63760ca..6a05270 100644
> >>> --- a/block/blk-merge.c
> >>> +++ b/block/blk-merge.c
> >>> @@ -338,9 +338,9 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
> >>>  	return 1;
> >>>  }
> >>>
> >>> -static void blk_account_io_merge(struct request *req)
> >>> +static void blk_account_io_merge(struct request *req, struct request *next)
> >>>  {
> >>> -	if (blk_do_io_stat(req)) {
> >>> +	if (req->rq_disk && blk_rq_io_stat(next)) {
> >> This at least needs a comment, it's not at all directly clear why we are
> >> checking 'next' for io stat and ->rq_disk in 'req'. Since it's just
> >> called from that one spot, it would be cleaner to do:
> >>
> >>         /*
> >>          * 'next' is going away, so update stats accordingly
> >>          */
> >>         if (blk_rq_io_stat(next))
> >>                 blk_account_io_merge(req->rq_disk, req->sector);
> >>
> >> and have blk_account_io_merge() be more ala:
> >>
> >> static void blk_account_io_merge(struct request *req)
> >> {
> >>         struct hd_struct *part;
> >>         int cpu;
> >>
> >>         cpu = part_stat_lock();
> >>         part = disk_map_sector_rcu(disk, sector);
> >>         ...
> >> }
> >
> > BTW, it seems there's a current problem with this construct. If 'req'
> > and 'next' reside on different partitions, the accounting will be wrong.
> > This wont happen with normal fs activity of course, but it's definitely
> > possible with buffered (or O_DIRECT) IO on the full device.
> >
> 
> You're right. We may end up decrease in_flight on the wrong partition.
> I think having blk_account_io_merge() unchanged but call it for next
> request would solve that:
> 
> -	blk_account_io_merge(req)
> +	blk_account_io_merge(next)
> 
> We would still have the request payload accounted to the wrong partition
> (as it always was), but I don't think that small inaccuracy really matters.

Yes, just using 'next' is clearly the better approach here. It still not
perfect, but it's probably not worth it to do anything about this. It
should be commented, though :-)

-- 
Jens Axboe

