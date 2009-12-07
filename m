Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZLGOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZLGOvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbZLGOvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:51:22 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54658 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbZLGOvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:51:21 -0500
Date: Mon, 07 Dec 2009 23:51:23 +0900 (JST)
Message-Id: <20091207.235123.186008685.mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       paulus@samba.org, tzanussi@gmail.com, srostedt@redhat.com
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
 analyzing lock statistics
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091207044125.GB5262@nowhere>
References: <20091115022135.GA5427@nowhere>
	<1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091207044125.GB5262@nowhere>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for analyzing lock statistics
Date: Mon, 7 Dec 2009 05:41:26 +0100

Frederic, thanks for your comment!

> > 
> > And I found some important problem, so I'd like to ask your opinion.
> > For another issue, this patch depends on the previous one.
> > The previous one is very dirty and temporary, I cannot sign on it, so I cannot sign on this too...
> 
> 
> 
> The previous one looks rather good actually.

Thanks for your review in previous mail.
I'm new to perf, so I didn't have confidence.
Your advice is encouraging!

> 
> 
> 
> > First, it seems that current locks (spinlock, rwlock, mutex) has no numeric ID.
> > So we can't treat rq->lock on CPU 0 and rq->lock on CPU 1 as different things.
> > Symbol name of locks cannot be complete ID.
> > This is the result of current ugly data structure for lock_stat
> > (data structure for stat per lock in builtin-lock.c).
> > Hash table will solve the problem of speed,
> > but it is not a radical solution.
> > I understand it is hard to implement numeric IDs for locks,
> > but it is required seriously, do you have some ideas?
> 
> 
> Indeed. I think every lock instance has its own lockdep_map.
> And this lockdep_map is passed in every lock event but is
> only used to retrieve the name of the lock.
> 
> Why not adding the address of the lockdep_map in the event?

It's good idea. Address cannot be used as index of array directly,
but dealing with it is far easier than string and low cost.

> 
> 
> > Second, there's a lot of lack of information from trace events.
> > For example, current lock event subsystem cannot provide the time between
> > lock_acquired and lock_release.
> > But this time is already measured in lockdep, and we can obtain it
> > from /proc/lock_stat.
> > But /proc/lock_stat provides information from boot time only.
> > So I have to modify wide area of kernel including lockdep, may I do this?
> 
> 
> 
> I think this is more something to compute in a state machine:
> lock_release - lock_acquired event.
> 
> This is what we do with sched events in perf sched latency

Yeah, tracing state of the lock is smart way. I'll try it.

> 
> Also I think we should remove the field that gives the time waited
> between lock_acquire and lock_acquired. This is more something that
> should be done in userspace instead of calculating in from the kernel.
> This brings overhead in the wrong place.

I agree. I think we can exploit more information from timestamps.

> 
> 
> > 
> > Third, siginificant overhead :-(
> > 
> > % perf bench sched messaging                      # Without perf lock rec
> > 
> >      Total time: 0.436 [sec]
> > 
> > % sudo ./perf lock rec perf bench sched messaging # With perf lock rec
> > 
> >      Total time: 4.677 [sec]
> > [ perf record: Woken up 0 times to write data ]
> > [ perf record: Captured and wrote 106.065 MB perf.data (~4634063 samples) ]
> > 
> > Over 10 times! No one can ignore this...
> 
> 
> I think that the lock events are much more sensible than the sched events,
> and that by nature: these are very high frequency events class, probably the
> highest among every event classes we have (the worst beeing function tracing :)
> 
> But still, you're right, there are certainly various things we need to
> optimize in this area.
> 
> More than 8 times slower is high.

It seems that lockdep contains some O(n) codes.
Of course lockdep is important, but analyzing statistics of lock usage
is another problem.
I think separating lockdep and lock event for stats can be solution.

> 
> 
> > 
> > This is example of using perf lock prof:
> > % sudo ./perf lock prof          # Outputs in pager
> >  ------------------------------------------------------------------------------------------
> >   Lock                           |   Acquired   | Max wait ns | Min wait ns | Total wait ns |
> >  --------------------------------------------------------------------------------------------
> >                         &q->lock            30             0             0               0
> >                       &ctx->lock          3912             0             0               0
> >                      event_mutex             2             0             0               0
> >                 &newf->file_lock          1008             0             0               0
> >                      dcache_lock           444             0             0               0
> >                  &dentry->d_lock          1164             0             0               0
> >                      &ctx->mutex             2             0             0               0
> >         &child->perf_event_mutex             2             0             0               0
> >              &event->child_mutex            18             0             0               0
> >                       &f->f_lock             2             0             0               0
> >               &event->mmap_mutex             2             0             0               0
> >         &sb->s_type->i_mutex_key           259             0             0               0
> >                  &sem->wait_lock         27205             0             0               0
> >        &(&ip->i_iolock)->mr_lock           130             0             0               0
> >          &(&ip->i_lock)->mr_lock          6376             0             0               0
> >               &parent->list_lock          9149          7367           146          527013
> >         &inode->i_data.tree_lock         12175             0             0               0
> >      &inode->i_data.private_lock          6097             0             0               0
> 
> 
> 
> Very nice and promising!
> 
> I can't wait to try it.
> 
>

Thanks! I'll do my best :)
