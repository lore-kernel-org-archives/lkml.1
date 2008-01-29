Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbYA2SU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbYA2SU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765439AbYA2STV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:19:21 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8247 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866AbYA2STT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:19:19 -0500
Date: Tue, 29 Jan 2008 19:19:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [RFC] block/elevator: change nr_requests handling
Message-ID: <20080129181915.GD15220@kernel.dk>
References: <1201627774.14644.5.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201627774.14644.5.camel@nikanth-laptop.blr.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Nikanth Karthikesan wrote:
> The /sys/block/whateverdisk/queue/nr_requests is used to limit the
> number of requests allocated per queue. There can be atmost nr_requests
> read requests and nr_requests write requests allocated.
> 
> But this can lead to starvation when there are many tasks doing heavy
> IO. And the ioc_batching code lets those who had failed to allocate a
> request once, to allocate upto 150% of nr_requests in next round. This
> just makes the limit a little higher, when there are too many tasks
> doing heavy IO. IO schedulers have no control over this to choose which
> task should get the requests. During such situations, even ionice cannot
> help as CFQ cannot serve a task which cannot allocate any requests.
> Setting nr_requests to a higher value is like disabling this queue depth
> check at all.
> 
> This patch defers the nr_requests check till dispatching the requests
> instead of limiting while creating them. There can be more than
> nr_requests allocated, but only upto nr_requests chosen by the io
> scheduler will be dispatched at a time. This lets the io scheduler to
> guarantee some sort of interactivity even when there are many batchers,
> if it wants to.
> 
> This patch removes the ioc_batching code. Also the schedulers stop
> dispatching when it chooses a Read request and Read queue is full and
> vice versa. On top of this patch, the individual schedulers can be
> changed to take advantage of knowing the no of read and write requests
> that can be dispatched. Or atleast dispatch until both read and write
> queues are full.

This is all a bit backwards, I think. The io schedulers CAN choose which
processes get to allocate requests, through the ->may_queue() hook.

I definitely think the batching logic could do with some improvements,
so I'd encourage you to try and fix that instead. It'd be nice if it did
honor the max number of requests limit. The current batching works well
for allowing a process to queue some IO when it gets the allocation
'token', that should be retained.

Did you do any performance numbers with your patch, btw?

-- 
Jens Axboe

