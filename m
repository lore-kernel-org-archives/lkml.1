Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab0BPSIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:08:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab0BPSIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:08:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B7A13C6.4060402@kernel.org>
References: <4B7A13C6.4060402@kernel.org> <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com> <27102.1266246296@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead of slow-work
Date: Tue, 16 Feb 2010 18:05:57 +0000
Message-ID: <28151.1266343557@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> That doesn't necessarily mean it would be the best solution under
> different circumstances, right?  I'm still quite unfamiliar with the
> facache code and assumptions about workload in there.

Timeouts, you mean?  What you can end up doing is accruing timeouts as you go
through ops looking for one that you can process now.  Even the yield mechanism
I've come up with isn't perfect.

>   So, you're saying...
>
> * There can be a lot of concurrent shallow dependency chains, so
>   deadlocks can't realistically avoided by allowing larger number of
>   theads in the pool.

Yes.  As long as you can queue one more op than you can have threads, you can
get deadlock between the queue and the threads.

> * Such occurrences would be common enough that the 'yield' path would
>   be essential in keeping the operation going smooth.

I've seen them a few times, usually under high pressure.  I've got some evil
test cases that try to read a few thousand sequences of files simultaneously.

> One problem I have with the slow work yield-on-queue mechanism is that
> it may fit fscache well but generally doesn't make much sense.  What
> would make more sense would be yield-under-pressure (ie. thread limit
> reached or about to be reached and new work queued).  Would that work
> for fscache?

I'm not sure what you mean.  Slow-work does do yield-under-pressure.
slow_work_sleep_till_thread_needed() adds the waiting object to a waitqueue by
which it can be interrupted by slow-work when slow-work wants its thread back.

If the object execution is busy doing something rather than waiting around,
there's no reason to yield the thread back.

> It might but I wasn't sure whether this could actually be a problem
> for what fscache is doing.  Again, I just don't know what kind of
> workload the code is expecting.  The reason why I thought it might not
> was because the default concurrency level was low.

You can end up serialising together all the I/O being done by NFS, AFS and
anything else using FS-Cache.

> Alright, so it can be very high.  This is slightly off topic but isn't
> the know a bit too low level to export?  It will adjust concurrency
> level of the whole slow-work facility which can be used by any number
> of users.

'The know'?

One thing I was trying to do was avoid the workqueue problem of having a static
pool of threads per workqueue.  As CPU counts go up, that starts eating some
serious resources.  What I was trying for was one pool that was dynamically
sized.

Tuning such a pool is tricky, however; you have a set of conflicting usage
patterns - hence the two thread priorities (slow and very slow).

> As the handlers are running asynchronously, for a lot of cases, they
> require some form of synchronization anyway and that usually seems to
> take care of the reentrance issue together.  But, yeah, it definitely
> is possible that there are undiscovered buggy cases.

What I'm trying to avoid is having several threads all trying to execute the
same object.  This is a more extreme problem in AF_RXRPC as there are more
events to deal with, and it can tie up all the threads in the pool quite
easily.

> BTW, if we solve the yielding problem (I think we can retain the
> original behavior by implementing it inside fscache) and the
> reentrance issue, do you see any other obstacles in switching to cmwq?

I don't think so.  I'm not sure how you retain the original yield behaviour by
doing it inside FS-Cache - slow-work knows about the congestion, not FS-Cache.

David
