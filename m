Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZHTMld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZHTMld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZHTMld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:41:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57504 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbZHTMlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:41:32 -0400
Date: Thu, 20 Aug 2009 14:41:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/6] Lazy workqueues
Message-ID: <20090820124133.GL12579@kernel.dk>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <20090820122212.GC6069@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820122212.GC6069@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20 2009, Frederic Weisbecker wrote:
> On Thu, Aug 20, 2009 at 12:19:58PM +0200, Jens Axboe wrote:
> > (sorry for the resend, but apparently the directory had some patches
> >  in it already. plus, stupid git send-email doesn't default to
> >  no chain replies, really annoying)
> > 
> > Hi,
> > 
> > After yesterdays rant on having too many kernel threads and checking
> > how many I actually have running on this system (531!), I decided to 
> > try and do something about it.
> > 
> > My goal was to retain the workqueue interface instead of coming up with
> > a new scheme that required conversion (or converting to slow_work which,
> > btw, is an awful name :-). I also wanted to retain the affinity
> > guarantees of workqueues as much as possible.
> > 
> > So this is a first step in that direction, it's probably full of races
> > and holes, but should get the idea across. It adds a
> > create_lazy_workqueue() helper, similar to the other variants that we
> > currently have. A lazy workqueue works like a normal workqueue, except
> > that it only (by default) starts a core thread instead of threads for
> > all online CPUs. When work is queued on a lazy workqueue for a CPU
> > that doesn't have a thread running, it will be placed on the core CPUs
> > list and that will then create and move the work to the right target.
> > Should task creation fail, the queued work will be executed on the
> > core CPU instead. Once a lazy workqueue thread has been idle for a
> > certain amount of time, it will again exit.
> > 
> > The patch boots here and I exercised the rpciod workqueue and
> > verified that it gets created, runs on the right CPU, and exits a while
> > later. So core functionality should be there, even if it has holes.
> > 
> > With this patchset, I am now down to 280 kernel threads on one of my test
> > boxes. Still too many, but it's a start and a net reduction of 251
> > threads here, or 47%!
> > 
> > The code can also be pulled from:
> > 
> >   git://git.kernel.dk/linux-2.6-block.git workqueue
> > 
> > -- 
> > Jens Axboe
> 
> 
> That looks like a nice idea that may indeed solve the problem of
> thread proliferation with per cpu workqueue.
> 
> Now I think there is another problem that taint the workqueues from
> the beginning which is the deadlocks induced by one work that waits
> another one in the same workqueue. And since the workqueues are
> executing the jobs by serializing, the effect is deadlocks.
> 
> Often, drivers need to move from the central events/%d to a dedicated
> workqueue because of that.
> 
> A idea to solve this:
> 
> We could have one thread per struct work_struct.  Similarly to this
> patchset, this thread waits for queuing requests, but only for this
> work struct.  If the target cpu has no thread for this work, then
> create one, like you do, etc...
> 
> Then the idea is to have one workqueue per struct work_struct, which
> handles per cpu task creation, etc... And this workqueue only handles
> the given work.
> 
> That may solve the deadlocks scenario that are often reported and lead
> to dedicated workqueue creation.
> 
> That also makes disappearing the work execution serialization between
> different worklets. We just keep the serialization between same work,
> which seems a pretty natural thing and is less haphazard than multiple
> works of different natures randomly serialized between them.
> 
> Note the effect would not only be a reducing of deadlocks but also
> probably an increasing of throughput because works of different
> natures won't need anymore to wait for the previous one completion.
> 
> Also a reducing of latency (a high prio work that waits for a lower
> prio work).
> 
> There are good chances that we won't need any more per driver/subsys
> workqueue creation after that, because everything would be per
> worklet.  We could use a single schedule_work() for all of them and
> not bother choosing a specific workqueue or the central events/%d
> 
> Hmm?

I pretty much agree with you, my initial plan for a thread pool would be
very similar. I'll gradually work towards that goal.

-- 
Jens Axboe

