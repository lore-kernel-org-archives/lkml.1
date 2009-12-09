Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZLIFYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZLIFYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZLIFYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:24:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:33391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbZLIFYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:24:46 -0500
Message-ID: <4B1F34B6.3090107@kernel.org>
Date: Wed, 09 Dec 2009 14:25:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>	 <1260272885.3935.1189.camel@laptop>  <4B1E3EE0.7030001@kernel.org>	 <1260274232.3935.1223.camel@laptop>  <4B1E4548.5040408@kernel.org> <1260279351.3935.1375.camel@laptop>
In-Reply-To: <1260279351.3935.1375.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 10:35 PM, Peter Zijlstra wrote:
>> Slow and indeterminism comes in different magnitudes.
> 
> Determinism does _not_ come in magnitudes, its a very binary property,
> either it is or it is not.

It's semantics, right?  The whole process is made closer to being
deterministic by making each component deterministic, so in that way
"more deterministic" is a meaningful expression or it also can
describe how deterministic it feels to human perception.

> As to the order of slowness for unplug, that is about maximal, its _the_
> slowest path in the whole kernel.

Long running works may run for minutes.  They're slow to wait for as
perceived by human beings, so we're talking about pretty different
scales.

> Ok, maybe, but that is not what I would call a generic thread pool.

Sure, it's not completely generic, not yet anyway.  The main focus is
to solve concurrency issues with the current workqueue implementation.
With concurrency issues solved, accomodating long running works
becomes quite easy - all we need to do is to migrate back unbound
workers during cup up - and as we have considerable number of users
which require such usage, it's reasonable to implement it.

> So the reason we have tons of idle workqueues around are purely because
> of deadlock scenarios? Or is there other crap about?

No, that's part of concurrency issues.  Works don't devour and compete
for CPU cycles but they overlap each other frequently.  Works are
often used to provide task context so that the users can use sleeping
synchronization constructs or wait for events.

> So why not start simple and only have one thread per cpu (lets call it
> events/#) and run all works there. Then when you enqueue a work and
> events/# is already busy with a work from anther wq, hand the work to a
> global event thread which will spawn a special single shot kthread for
> it, with a second exception for those reclaim wq's, for which you'll
> have this rescue thread which you'll bind to the right cpu for that
> work.
>
> That should get rid of all these gazillion threads we have, preserve the
> queue property and not be as invasive as your current thing.

That doesn't solve concurrency problem at all and we'll be ending up
bouncing around a LOT of works.

> If they're really as idle as reported you'll never need the fork-fest
> you currently propose, simply because there's not enough work.
>
> So basically, have events/# service the first non-empty cwq, when
> there's more non empty cwqs spawn them single shot threads, or use a
> rescue thread.

Idle doesn't mean they don't overlap.  They aren't cpu cycle hungry
but are context hungry.

It just isn't possible to implement shared worker pool which can scale
according to necessary level of concurrency without doing some sort of
dynamic worker management which necessarily involves forking new ones
when in need and killing some of them off when there are more than
enough.

As for the force_cpus_allowed() bit, I think it's a rather natural
interface to have and maybe we can replace kthread_bind() with it or
make kthread_bind() in terms of it.  It's the basic migration function
which adheres to the cpu hot plug/unplug synchronization rules.

>>   I thought about adding an unbound pool of workers
>> for cpu intensive works for completeness but I really couldn't find
>> much use for that.  If enough number of users would need something
>> like that, we can add an anonymous pool but for now I really don't see
>> the need to worry about that.
> 
> And I though I'd heard multiple parties express interesting in exactly
> that, btrfs, bdi and pohmelfs come to mind, also crypto looks like one
> that could actually do some work.

Yeah, anything cryptography related or crunches large chunk of data
would be a good candidate but still compared to the works and kthreads
we have just to have context and be able to wait for things, they're
minority.  Plus, it's something we can continue to work on if there
are enough reasons to do so.  If accomodating long running works there
makes more sense, we'll do that but for most of them whether bound to
certain cpu or not just isn't intersting at all and all we need to
serve them is the ability to migrate back the threads during CPU UP.
It's pretty isolated path.

Thanks.

-- 
tejun
