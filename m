Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab0BPXoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:44:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:36636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab0BPXoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:44:32 -0500
Message-ID: <4B7B2F4E.5090803@kernel.org>
Date: Wed, 17 Feb 2010 08:50:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead
 of slow-work
References: <4B7A13C6.4060402@kernel.org> <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com> <27102.1266246296@redhat.com> <28151.1266343557@redhat.com>
In-Reply-To: <28151.1266343557@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 23:42:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/17/2010 03:05 AM, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
>>   So, you're saying...
>>
>> * There can be a lot of concurrent shallow dependency chains, so
>>   deadlocks can't realistically avoided by allowing larger number of
>>   theads in the pool.
> 
> Yes.  As long as you can queue one more op than you can have threads, you can
> get deadlock between the queue and the threads.
> 
>> * Such occurrences would be common enough that the 'yield' path would
>>   be essential in keeping the operation going smooth.
> 
> I've seen them a few times, usually under high pressure.  I've got some evil
> test cases that try to read a few thousand sequences of files simultaneously.

Alright, thanks for clarifying.  Yield it is then.

>> One problem I have with the slow work yield-on-queue mechanism is that
>> it may fit fscache well but generally doesn't make much sense.  What
>> would make more sense would be yield-under-pressure (ie. thread limit
>> reached or about to be reached and new work queued).  Would that work
>> for fscache?
> 
> I'm not sure what you mean.  Slow-work does do yield-under-pressure.
> slow_work_sleep_till_thread_needed() adds the waiting object to a waitqueue by
> which it can be interrupted by slow-work when slow-work wants its thread back.
> 
> If the object execution is busy doing something rather than waiting around,
> there's no reason to yield the thread back.

The waiting workers are woken up in slow_work_enqueue() when a new
work is enqueued regardless of how many workers are currently in use,
right?  So, it ends up yielding on any queue activity rather than only
under resource pressure.

>> It might but I wasn't sure whether this could actually be a problem
>> for what fscache is doing.  Again, I just don't know what kind of
>> workload the code is expecting.  The reason why I thought it might not
>> was because the default concurrency level was low.
> 
> You can end up serialising together all the I/O being done by NFS, AFS and
> anything else using FS-Cache.

Yeap, if the workload can be highly parallel, SINGLE_CPU won't fare
off very well.  Will take care of that.

>> Alright, so it can be very high.  This is slightly off topic but isn't
>> the know a bit too low level to export?  It will adjust concurrency
>> level of the whole slow-work facility which can be used by any number
>> of users.
> 
> 'The know'?

Ah... sorry about that, the knob.

> One thing I was trying to do was avoid the workqueue problem of
> having a static pool of threads per workqueue.  As CPU counts go up,
> that starts eating some serious resources.  What I was trying for
> was one pool that was dynamically sized.

Yeah, sure.  I was just wondering that it would be nice if the pool
can be dynamically sized without user specifying the concurrency level
directly.  I have no idea that would be possible or not.

> Tuning such a pool is tricky, however; you have a set of conflicting usage
> patterns - hence the two thread priorities (slow and very slow).
...
>> BTW, if we solve the yielding problem (I think we can retain the
>> original behavior by implementing it inside fscache) and the
>> reentrance issue, do you see any other obstacles in switching to cmwq?
> 
> I don't think so.  I'm not sure how you retain the original yield
> behaviour by doing it inside FS-Cache - slow-work knows about the
> congestion, not FS-Cache.

I'm thinking about how to solve it but it will be solved one way or
the other.  If it can't be done in fscache, I'll add some general hook
in wq code to tell fscache congestion conditions.  I was curious
whether you see other issues in converting to cmwq other than those
two discussed so far.  If not, I'll go ahead and prep the next round.

Thanks.

-- 
tejun
