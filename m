Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbZDWMOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbZDWMOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZDWMN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:13:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43524 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZDWMN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:13:57 -0400
Date: Thu, 23 Apr 2009 14:13:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority
	requests in deadline IO scheduler
Message-ID: <20090423121355.GH4593@kernel.dk>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com> <49F05699.2070006@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F05699.2070006@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23 2009, Aaron Carroll wrote:
> Corrado Zoccolo wrote:
> > Hi,
> > deadline I/O scheduler currently classifies all I/O requests in only 2
> > classes, reads (always considered high priority) and writes (always
> > lower).
> > The attached patch, intended to reduce latencies for syncronous writes
> 
> Can be achieved by switching to sync/async rather than read/write.  No
> one has shown results where this makes an improvement.  Let us know if
> you have a good example.
> 
> > and high I/O priority requests, introduces more levels of priorities:
> > * real time reads: highest priority and shortest deadline, can starve
> > other levels
> > * syncronous operations (either best effort reads or RT/BE writes),
> > mid priority, starvation for lower level is prevented as usual
> > * asyncronous operations (async writes and all IDLE class requests),
> > lowest priority and longest deadline
> > 
> > The patch also introduces some new heuristics:
> > * for non-rotational devices, reads (within a given priority level)
> > are issued in FIFO order, to improve the latency perceived by readers
> 
> This might be a good idea.  Can you make this a separate patch?
> Is there a good reason not to do the same for writes?
> 
> > * minimum batch timespan (time quantum): partners with fifo_batch to
> > improve throughput, by sending more consecutive requests together. A
> > given number of requests will not always take the same time (due to
> > amount of seek needed), therefore fifo_batch must be tuned for worst
> > cases, while in best cases, having longer batches would give a
> > throughput boost.
> > * batch start request is chosen fifo_batch/3 requests before the
> > expired one, to improve fairness for requests with lower start sector,
> > that otherwise have higher probability to miss a deadline than
> > mid-sector requests.
> 
> I don't like the rest of it.  I use deadline because it's a simple,
> no surprises, no bullshit scheduler with reasonably good performance
> in all situations.  Is there some reason why CFQ won't work for you?

Fully agree with that, deadline is not going to be changed radically.
Doing sync/async instead of read/write would indeed likely bring the
latency results down alone, what impact the rest has is unknown.

If CFQ performs poorly for some situations, we fix that.


-- 
Jens Axboe

