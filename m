Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab0BMFpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 00:45:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:50999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0BMFpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 00:45:09 -0500
Message-ID: <4B763C17.5080707@kernel.org>
Date: Sat, 13 Feb 2010 14:43:51 +0900
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
References: <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com>
In-Reply-To: <24913.1265997809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Feb 2010 05:43:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/13/2010 03:03 AM, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
>> -			requeue = slow_work_sleep_till_thread_needed(
>> -				&object->fscache.work, &timeout);
>> -		} while (timeout > 0 && !requeue);
>> +			timeout = schedule_timeout(timeout);
>> +		} while (timeout > 0);
> 
> Okay, how do you stop the workqueue from having all its threads
> blocking on pending work?  The reason the code you've removed
> interacts with the slow work facility in this way is that there can
> be a dependency whereby an executing work item depends on something
> that is queued.  This code allows the thread to be given back to the
> pool and processing deferred.

How deep the dependency chain can be?  As I wrote in the patch
description, wake-me-up-on-another-enqueue can be implemented in
similar way but I wasn't sure how useful it would be.  If the
dependency chain is strictly bound and significantly shorter than the
allowed concurrency, it might be better to just leave them sleep.

If it's mainly because there can be many concurrent long waiters (but
no dependency), implementing staggered timeout might be better option.
I wasn't sure about the requirement there.

> Note that just creating more threads isn't a good answer - that can
> run you out of resources instead.

It depends.  The only resource taken up by an idle kthread is small
amount of memory and it can definitely be traded off against code
complexity and processing overhead.  Anyways, this really depends on
what is the concurrency requirement there, can you please explain what
would the bad cases be?

>> +	ret = -ENOMEM;
>> +	fscache_object_wq =
>> +		__create_workqueue("fscache_object", WQ_SINGLE_CPU, 99);
>> +	if (!fscache_object_wq)
>> +		goto error_object_wq;
>> +
> 
> What does fscache_object_wq being WQ_SINGLE_CPU imply?  Does that mean there
> can only be one CPU processing object state changes?

Yes.

> I'm not sure that's a good idea - something like a tar command can
> create thousands of objects, all of which will start undergoing
> state changes.

The default concurrency level for slow-work is pretty low.  Is it
expected to be tuned to a very high value in certain configurations?

> Why did you do this?  Is it because cmwq does _not_ prevent reentrance to
> executing work items?  I take it that's why you can get away with this:

and yes, I used it as a cheap way to avoid reentrance.  For most
cases, it works just fine.  For slow work, it might not be enough.

> 	-	slow_work_enqueue(&object->work);
> 	+	if (fscache_get_object(object) >= 0)
> 	+		if (!queue_work(fscache_object_wq, &object->work))
> 	+			fscache_put_object(object);
> 
> One of the reasons I _don't_ want to use the old workqueue facility is that it
> doesn't manage reentrancy.  That can end up tying up multiple threads for one
> long-duration work item.

Yeap, it's a drawback of the workqueue API although I don't think it
would be big enough to warrant a completely separate workpool
mechanism.  It's usually enough to implement synchronization from the
callback or guarantee that running works don't get queued some other
way.  What would happen if fscache object works are reentered?  Would
there be correctness issues?  How likely are they to get scheduled
while being executed?  If this is something critical, I have a draft
implementation which avoids reentrance.  I was gonna apply it for all
works but it would cause too much cross CPU access when the wq users
can already handle reentrance but it can be implemented as optional
behavior along with SINGLE_CPU.

>>  	seq_printf(m,
>> -		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx %1lx | ",
>> +		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx | ",
> 
> You've got to alter the printed header lines too and the documentation.

Yeap, sure.

> Note that it would still be useful to know whether an object was queued for
> work or being executed.

Adding wouldn't be difficult but would it justify having a dedicated
function for that in workqueue where fscache would be the only user?
Also please note that such information is only useful for debugging or
as hints due to lack of synchronization.

>> -/*
>> - * describe an object for slow-work debugging
>> - */
>> -#ifdef CONFIG_SLOW_WORK_PROC
>> -static void fscache_object_slow_work_desc(struct slow_work *work,
>> -					  struct seq_file *m)
>> -{
>> -	struct fscache_object *object =
>> -		container_of(work, struct fscache_object, work);
>> -
>> -	seq_printf(m, "FSC: OBJ%x: %s",
>> -		   object->debug_id,
>> -		   fscache_object_states_short[object->state]);
>> -}
>> -#endif
> 
> Please provide this facility as part of cmwq - it's been really
> useful, and I'd rather not dispense with it.

Hmmm... but yeah, right, it does make sense to beef up debugging
facility as wq's use cases are expanded.  I'll try to add them.

Thanks.

-- 
tejun
