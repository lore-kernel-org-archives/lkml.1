Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYIYNzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYIYNzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYIYNzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:55:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45100 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYIYNze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:55:34 -0400
Date: Thu, 25 Sep 2008 15:55:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] BUG: ll_merge_requests_fn() updates req->nr_phys_segments wrongly
Message-ID: <20080925135526.GO2677@kernel.dk>
References: <200809232358.02810.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809232358.02810.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23 2008, Nikanth Karthikesan wrote:
> 
> From: Nikanth Karthikesan <knikanth@suse.de>
> 
> ll_merge_requests_fn() decreases the req->nr_phys_segments if 
> blk_phys_contig_segment() returns true, but it is perfectly possible that 
> blk_hw_contig_segment() is false. A new hw_segment implies a new phys_segment. 
> So decrementing nr_phys_segments wrongly here triggers the BUG_ON() in 
> scsi_init_sgtable(), as blk_rq_map_sg() would map 1 phys_segment more than  
> req->nr_phys_segment. This is easily reproducible. Other callers of 
> blk_rq_map_sg() should also be affected by this bug.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> ---
> 
>  block/blk-merge.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 5efc9e7..6e6d04b 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -392,11 +392,6 @@ static int ll_merge_requests_fn(struct request_queue *q, 
> struct request *req,
>  		return 0;
>  
>  	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
> -	if (blk_phys_contig_segment(q, req->biotail, next->bio))
> -		total_phys_segments--;

This is totally broken, I gather you are thinking the bug is fixed since
the counts always match up. Well that's mainly because you know don't do
ANY merging.

> -	if (total_phys_segments > q->max_phys_segments)
> -		return 0;

Hmm?

I think you should try and describe the problem you are seeing instead,
then we can perhaps find the real issue.

-- 
Jens Axboe

