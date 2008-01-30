Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYA3N4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYA3N4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYA3N4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:56:33 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25584 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYA3N4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:56:32 -0500
Date: Wed, 30 Jan 2008 14:56:29 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [RFC] block/elevator: change nr_requests handling
Message-ID: <20080130135629.GS15220@kernel.dk>
References: <1201627774.14644.5.camel@nikanth-laptop.blr.novell.com> <20080129181915.GD15220@kernel.dk> <1201701224.4197.31.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201701224.4197.31.camel@nikanth-laptop.blr.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008, Nikanth Karthikesan wrote:
> On Tue, 2008-01-29 at 19:19 +0100, Jens Axboe wrote: 
> > On Tue, Jan 29 2008, Nikanth Karthikesan wrote:
> > > The /sys/block/whateverdisk/queue/nr_requests is used to limit the
> > > number of requests allocated per queue. There can be atmost nr_requests
> > > read requests and nr_requests write requests allocated.
> > > 
> > > But this can lead to starvation when there are many tasks doing heavy
> > > IO. And the ioc_batching code lets those who had failed to allocate a
> > > request once, to allocate upto 150% of nr_requests in next round. This
> > > just makes the limit a little higher, when there are too many tasks
> > > doing heavy IO. IO schedulers have no control over this to choose which
> > > task should get the requests. During such situations, even ionice cannot
> > > help as CFQ cannot serve a task which cannot allocate any requests.
> > > Setting nr_requests to a higher value is like disabling this queue depth
> > > check at all.
> > > 
> > > This patch defers the nr_requests check till dispatching the requests
> > > instead of limiting while creating them. There can be more than
> > > nr_requests allocated, but only upto nr_requests chosen by the io
> > > scheduler will be dispatched at a time. This lets the io scheduler to
> > > guarantee some sort of interactivity even when there are many batchers,
> > > if it wants to.
> > > 
> > > This patch removes the ioc_batching code. Also the schedulers stop
> > > dispatching when it chooses a Read request and Read queue is full and
> > > vice versa. On top of this patch, the individual schedulers can be
> > > changed to take advantage of knowing the no of read and write requests
> > > that can be dispatched. Or atleast dispatch until both read and write
> > > queues are full.
> > 
> > This is all a bit backwards, I think. The io schedulers CAN choose which
> > processes get to allocate requests, through the ->may_queue() hook.
> > 
> 
> Sorry If I am re-inventing the wheel.
> 
> At first this looked like under-utilization. Letting only batchers and
> ELV_MQUEUE_MUST tasks to allocate upto 150% of nr_requests, which is in
> someway equivalent of setting nr_requests at 150% and keeping 1/3 of it
> reserved for batchers. But we are actually jamming the queue only when
> required and allowing it to be just full otherwise! But this patch will
> never over-fill the queue.

The logic used to be more complex and elaborate, but it's actually quite
tricky to make sure it works well and doesn't either starve or deadlock.

> > I definitely think the batching logic could do with some improvements,
> > so I'd encourage you to try and fix that instead. It'd be nice if it did
> > honor the max number of requests limit. The current batching works well
> > for allowing a process to queue some IO when it gets the allocation
> > 'token', that should be retained.
> > 
> 
> Another way to honor the nr_requests limit strictly would be to set it
> at 66.6% of the real value, so that we never exceed the limit ;-)
> 
> But even with the token, if we reach 150% the task goes to
> uninteruptible sleep. But with the patch, the task will not sleep in
> get_request, unless memory allocation fails. Will this skew the
> performance or atleast the performance numbers? 

That will never work, you cannot allow unlimited allocations until they
start failing. We need to throttle dirty memory flushing or things will
go bonanza very quickly. There's a reason we have that 128 limit now,
it's more meant for throttling queuers than limiting depth at the hw
side (that tends to be normally throttled since devices do not have
unlimited queue depths). So we don't care very much about how deep the
queue is at the device side.

> > Did you do any performance numbers with your patch, btw?
> > 
> 
> hmm.. The patch is not completely finished yet. Just posted early to
> know if this was considered already. Also I do not have good
> test-cases. 
> 
> A system was getting sporadic delays when copying huge files. And I
> doubted the ioc_batching code, and started working on this patch. I have
> made noop & cfq to fill both the read and write queues only now, the
> patch I sent yesterday will stop dispatching if it cannot dispatch the
> request it chooses, leading to under-utilization. Also I guess, the
> schedulers are tweaked/optimized for the ioc_batching logic, which has
> to be tweaked for this, to make a real comparison.
> 
> Do you still think that, this option is not worth trying? If so I will
> try to find ways to improve the ioc_batching logic

I don't think your approach is feasible, sorry. But there's the option
of returning ELV_QUEUE_MUST for a task that doesn't have any requests
allocated, you could build on that a bit. Right now we allow 128
requests allocated, 50% for ioc batching. We could allow up to 2*128 in
total by allowing tasks that don't have anything queue to allocate at
least one request.

You mention sporadic delays - did you actually trace them to request
allocation, or were the just waiting on IO? You should gather some data
with blktrace, that will tell you what they are waiting for.

-- 
Jens Axboe

