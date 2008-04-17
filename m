Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbYDQHNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbYDQHNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYDQHNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:13:39 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14209 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYDQHNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:13:38 -0400
Date: Thu, 17 Apr 2008 09:13:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Block: Prevent busy looping
Message-ID: <20080417071335.GR12774@kernel.dk>
References: <20080416151305.8788.63912.stgit@denkblock.local> <20080416163152.GK12774@kernel.dk> <87r6d5l9pb.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6d5l9pb.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Elias Oltmanns wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Wed, Apr 16 2008, Elias Oltmanns wrote:
> >> blk_run_queue() as well as blk_start_queue() plug the device on reentry
> >> and schedule blk_unplug_work() right afterwards. However,
> >> blk_plug_device() takes care of that already and makes sure that there is
> >> a short delay before blk_unplug_work() is scheduled. This is important
> >> to prevent busy looping and possibly system lockups as observed here:
> >> <http://permalink.gmane.org/gmane.linux.ide/28351>.
> >
> > If you call blk_start_queue() and blk_run_queue(), you better mean it.
> > There should be no delay. The only reason it does blk_plug_device() is
> > so that the work queue function will actually do some work.
> 
> Well, I'm mainly concerned with blk_run_queue(). In a comment it says
> that it should recurse only once so as not to overrun the stack. On my
> machine, however, immediate rescheduling may have exactly as disastrous
> consequences as an overrunning stack would have since the system locks
> up completely.
> 
> Just to get this straight: Are low level drivers allowed to rely on
> blk_run_queue() that there will be no loops or do they have to make sure
> that this function is not called from the request_fn() of the same
> queue?

It's not really designed for being called recursively. Which isn't the
problem imo, the problem is SCSI apparently being dumb and calling
blk_run_queue() all the time. blk_run_queue() must run the queue NOW. If
SCSI wants something like 'run the queue in a bit', it should use
blk_plug_device() instead.

> > In the newer kernels we just do:
> >
> >         set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
> >         kblockd_schedule_work(q, &q->unplug_work);
> >
> > instead, which is much better.
> 
> Only as long as it doesn't get called from the request_fn() of the same
> queue. Otherwise, there may be no chance for other threads to clear the
> condition that caused blk_run_queue() to be called in the first place.

Broken usage.

-- 
Jens Axboe

