Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbYBSKAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbYBSKAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762436AbYBSKAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:00:38 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9393 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762170AbYBSKAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:00:37 -0500
Date: Tue, 19 Feb 2008 11:00:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
       "'Linux Filesystem Mailing List'" 
	<linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question about synchronous write on SSD
Message-ID: <20080219100034.GV23197@kernel.dk>
References: <9c9fda240802182148m6fd632pa7988530c5387245@mail.gmail.com> <20080219091608.1da174c1@crazy> <002f01c872db$69c854c0$1fa9580a@swcenter.sec.samsung.co.kr> <20080219094301.GU23197@kernel.dk> <000301c872dd$91461fd0$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301c872dd$91461fd0$1fa9580a@swcenter.sec.samsung.co.kr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, Kyungmin Park wrote:
> > >
> > > Agree, however see the following sequence.
> > >
> > > __generic_make_request call q->make_request_fn(q, bio);
> > > It was set by blk_init_queue_node with __make_request.
> > > There are two ways in __make_request.
> > > Case 1, get_rq
> > > Case 2, out or merged (otherwise you mean unplug case)
> > >
> > > In case 1, if the BIO_RW_SYNC is set, the request gets the REQ_RW_SYNC
> > > And REQ_RW_SYNC says
> > > "include/linux/blkdev.h":112: __REQ_RW_SYNC,          /* request is sync (O_DIRECT) */
> > > It means it acts as O_DIRECT flag. Is it right?
> > > And it also is same as case 2. Unplug the device.
> > > So next time it hasn't chance to merge???
> > 
> > But that still doesn't make it sync. I think you are working the wrong
> > way. For ssd we still want merging and plugging also makes sense to some
> > degree, though it probably should be minimized. It'll only cause an
> > initial latency, for busy IO workloads you wont be plugging/unplugging
> > much anyway.
> > 
> > In fact your patch makes things WORSE, since the io schedulers will now
> > treat the IO as sync and introduce idling for the disk head. And you
> > definitely don't want that.
> 
> Yes, you're right. It's for testing.
> I just want to know the worst or corner case, if all writes are synchronous.
> Of course I can measure the using tiotest "Do write synchronous" option.
> Then you think it's the worse case?

If you want to test when all writes are sync, then either mount with -o
sync, open with O_SYNC or use O_DIRECT writes. You can't force that
behaviour by changing the block layer code. Perhaps you could force
O_SYNC when a file is opened, if you want to experiment with worst case
generally. Not sure that makes a lot of sense, though.

-- 
Jens Axboe

