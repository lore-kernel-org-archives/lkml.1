Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab0BPDdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 22:33:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:45035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab0BPDdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 22:33:42 -0500
Message-ID: <4B7A13C6.4060402@kernel.org>
Date: Tue, 16 Feb 2010 12:40:54 +0900
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
References: <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com> <27102.1266246296@redhat.com>
In-Reply-To: <27102.1266246296@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 03:32:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/16/2010 12:04 AM, David Howells wrote:
>> How deep the dependency chain can be?
...
> So what happens is that the obsolete objects being deleted get
> executed to begin deletion, but the deletions then get deferred
> because the objects are still undergoing I/O - and so the objects
> get requeued *behind* the new objects that are going to wait for
> them.

I see, so the dependency chain isn't deep but can be very wide.

>>> Note that just creating more threads isn't a good answer - that can
>>> run you out of resources instead.
>>
>> It depends.  The only resource taken up by an idle kthread is small
>> amount of memory and it can definitely be traded off against code
>> complexity and processing overhead.
> 
> And PIDs...
>
> Also the definition of a 'small amount of memory' is dependent on how much
> memory you actually have.

I was thinking maybe low hundreds.

>> Anyways, this really depends on what is the concurrency requirement there,
>> can you please explain what would the bad cases be?
> 
> See above.  But I've come across this problem and dealt with it, generally
> without resorting to timeouts.

That doesn't necessarily mean it would be the best solution under
different circumstances, right?  I'm still quite unfamiliar with the
facache code and assumptions about workload in there.  So, you're
saying...

* There can be a lot of concurrent shallow dependency chains, so
  deadlocks can't realistically avoided by allowing larger number of
  theads in the pool.

* Such occurrences would be common enough that the 'yield' path would
  be essential in keeping the operation going smooth.

One problem I have with the slow work yield-on-queue mechanism is that
it may fit fscache well but generally doesn't make much sense.  What
would make more sense would be yield-under-pressure (ie. thread limit
reached or about to be reached and new work queued).  Would that work
for fscache?

>>> What does fscache_object_wq being WQ_SINGLE_CPU imply?  Does that mean there
>>> can only be one CPU processing object state changes?
>>
>> Yes.
> 
> That has scalability implications.

It might but I wasn't sure whether this could actually be a problem
for what fscache is doing.  Again, I just don't know what kind of
workload the code is expecting.  The reason why I thought it might not
was because the default concurrency level was low.

>>> I'm not sure that's a good idea - something like a tar command can
>>> create thousands of objects, all of which will start undergoing
>>> state changes.
>>
>> The default concurrency level for slow-work is pretty low.  Is it
>> expected to be tuned to a very high value in certain configurations?
> 
> That's why I have a tuning knob.  I don't really have the facilities
> for working up profiles of different loads, but I expect there's a
> sweet spot for any particular load.  You have to trade the amount of
> time and resources it takes to waggle the disk around off against
> the number of things you want to cache.

Alright, so it can be very high.  This is slightly off topic but isn't
the know a bit too low level to export?  It will adjust concurrency
level of the whole slow-work facility which can be used by any number
of users.

>> Yeap, it's a drawback of the workqueue API although I don't think it
>> would be big enough to warrant a completely separate workpool
>> mechanism.  It's usually enough to implement synchronization from the
>> callback or guarantee that running works don't get queued some other
>> way.  What would happen if fscache object works are reentered?  Would
>> there be correctness issues?
> 
> Definitely.  In the last rewrite, I started off by writing a thread
> pool that was non-reentrant, and then built everything on top of
> that assumption.  This means I don't have to do a whole bunch of
> locking because I _know_ each object can only be under execution by
> one thread at any one time.
>
>> How likely are they to get scheduled while being executed?
> 
> Reasonably likely, and the events aren't entirely within the control
> of the local system.

I see.

>> If this is something critical, I have a draft implementation which avoids
>> reentrance.
> 
> If you can provide it, I can simplify RxRPC and AFS too.  Those
> suffer from reentrancy issues too that I'd dearly like to avoid, but
> workqueues don't.
> 
>> I was gonna apply it for all works but it would cause too much cross CPU
>> access when the wq users can already handle reentrance but it can be
>> implemented as optional behavior along with SINGLE_CPU.
> 
> How many of them actually *handle* it?  For some of them it won't
> matter because they're only scheduled once, but I bet that some of
> them it *is* an issue that no one has considered, and the window of
> opportunity is small enough that it's not happened or the has not
> been reported or successfully pinpointed.

As the handlers are running asynchronously, for a lot of cases, they
require some form of synchronization anyway and that usually seems to
take care of the reentrance issue together.  But, yeah, it definitely
is possible that there are undiscovered buggy cases.

>> Adding wouldn't be difficult but would it justify having a dedicated
>> function for that in workqueue where fscache would be the only user?
>> Also please note that such information is only useful for debugging or
>> as hints due to lack of synchronization.
> 
> Agreed, but debugging still has to be done sometimes.  Of course, it's much
> easier for slow-work, since it has to manage reentrancy anyway, and so keeps
> hold of the object till afterwards.
> 
> Oh, btw, I've run up your patches with FS-Cache.  They quickly create a couple
> of hundred threads.  Is that right?  To be fair, the threads do go away again
> after a period of quiscence.

Heh... yeah, I wasn't sure about the dependency problem we were
talking above so just jacked up the concurrency level, so if there was
demand for high concurrency, cmwq would have created lots of workers.
It can be controlled by the max workers parameter.

Thanks.

-- 
tejun
