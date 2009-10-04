Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZJDVAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZJDVAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZJDVAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:00:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52904 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbZJDVAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:00:32 -0400
Date: Sun, 4 Oct 2009 22:59:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bug in elevator/cfq regarding start_time?
Message-ID: <20091004205955.GM26573@kernel.dk>
References: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Corrado Zoccolo wrote:
> Hi Jens,
> I found that the start_time is not monotonic in the cfqq fifo_list.
> The problem seems to be that:
> * attempt_merge overrides one of the start_time:
>         if (time_after(req->start_time, next->start_time))
>                 req->start_time = next->start_time;
> * then it calls elv_merge_requests, that in turn invokes cfq's
> elevator_merge_req_fn, i.e. cfq_merged_requests
> * cfq_merged_requests checks start_times to decide whether requests
> need to be repositioned
>         if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
>             time_before(next->start_time, rq->start_time))
>                 list_move(&rq->queuelist, &next->queuelist);
> 
> Other I/O schedulers are not affected, since none of them uses
> start_time explicitly, but they have a copy in one of the private
> fields.

Good spotting! So we can either add the same copy in cfq, or we can just
move the ->start_time check and assignment in attempt_merge() to post
the elv_merge_requests() call. I think the latter would work fine, but
I'll check and fix tomorrow.

-- 
Jens Axboe

