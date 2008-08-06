Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbYHFDWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbYHFDWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbYHFDWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:22:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757967AbYHFDWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:22:34 -0400
Message-ID: <489918AB.7050803@sgi.com>
Date: Tue, 05 Aug 2008 20:21:15 -0700
From: Stephen Champion <schamp@sgi.com>
Organization: Silicon Graphics, Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20080715)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
References: <20080731193204.GG9663@sgi.com>	<m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com>	<m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>	<m1proszj3r.fsf@frodo.ebiederm.org> <20080801191336.GK10501@sgi.com>	<m14p64zetj.fsf@frodo.ebiederm.org> <4896FFFE.7080400@sgi.com>	<m17iawy0tl.fsf@frodo.ebiederm.org> <20080804235838.GJ7290@sgi.com> <m163qgpa73.fsf@frodo.ebiederm.org>
In-Reply-To: <m163qgpa73.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Robin Holt <holt@sgi.com> writes:
> 
>> But if we simply scale based upon num_possible_cpus(), we get a relatively
>> representative scaling function.  Usually, customers buy machines with 1,
>> 2, or 4GB per cpu.  I would expect a waste of 256k, 512k, or even 1m to
>> be acceptable at this size of machine.
> 
> For your customers, and your kernel thread workload, you get a
> reasonable representation.  For other different people and different
> workloads you don't.  I happen to know of a completely different
> class of workload that can do better.

Although Robin probably had broader experience, I think we have both had 
opportunity to examine the workloads and configuration of a reasonable 
sample of the active (and historical) large (>=512c) shared memory systems.

Some workloads and configurations are specialized, and perhaps less 
stressing that the mixed, volatile loads and array of services most of 
these systems are expected to handle, but the specialized loads have been 
the exceptions in my experience.  That may change as the price/core 
continues to go down and pseudo-shared memory systems based on cluster 
interconnects become more common and possibly even viable, but don't hold 
your breathe.

>> For 2.6.27, would you accept an upper cap based on the memory size
>> algorithm you have now and adjusted for num_possible_cpus()?  Essentially
>> the first patch I posted.
> 
> I want to throw a screaming hissy fit.

If those get more cycles to my users, I'll start reading the list religiously!

> The merge window has closed.  This is not a bug.  This is not a
> regression.  I don't see a single compelling reason to consider this
> for 2.6.27.  I asked for clarification so I could be certain you were
> solving the right problem.

Early in 2.6.28 might work for us.  2.6.27 would be nice.  Yes, we'd like a 
distribution vendor(s) to pull it.  If we ask nicely, the one which matters 
to me (and my users) is quite likely to take it if it has been accepted 
early in the next cycle.  They've been very good about that sort of thing 
(for which I'm very thankful).  So while it's extra administrivia, I'm not 
the one who has to fill out the forms and write up the justification ;-)

But the opposite question: Does the patch proposed have significant risk or 
drawbacks?  We know it offers a minor but noticeable performance 
improvement for at least some of the small set of systems it effects.  Is 
it an unreasonable risk for other systems - or is there a known group of 
systems it would have an affect on which would not benefit or might even 
harm?  Would a revision of it be acceptable, and if so, (based on answers 
to the prior questions) what criteria should a revision meet, and what time 
frame should we target?

> Why didn't these patches show up 3 months ago when the last merge
> window closed?  Why not even earlier?

It was not a high priority, and I didn't push on it until after the trouble 
with proc_pid_readdir was resolved (and the fix floated downstream to me). 
   Sorry, but it was lost in higher priority work, and not something 
nagging at me, as I had already made the change on the systems I build for.

> I totally agree that what we are doing could be done better, however
> at this point we should be looking at 2.6.28.  In which case looking
> at the general long term non-hack solution is the right way to go.  Can
> we scale to different workloads?
> 
> For everyone with less then 4K cpus the current behavior is fine, and
> with 4k cpus it results in a modest slowdown.  This sounds useable.

I'd say the breakpoint - where increasing the size of the pid hash starts 
having a useful return - is more like 512 or 1024.  On NUMA boxes (which I 
think is most, if not all of the large processor count systems), running a 
list in the bucket (which more often than not will be remote) can be 
expensive, so we'd like to be closer to 1 process / bucket.

> You have hit an extremely sore spot with me.  Anytime someone makes an
> argument that I hear as RHEL is going to ship 2.6.27 so we _need_ this
> patch in 2.6.27 I want to stop listening.  I just don't care.  Unfortunately
> I have heard that argument almost once a day for the last week, and I am
> tired of it.

Only once a day?  Easy silly season, for having two major distributions 
taking a snapshot on 2.6.27...  I can see that getting annoying, and it's 
an unfortunate follow on effect of how Linux gets delivered to users who 
require commercial support and/or 3rd party application certifications for 
whatever reason (which unfortunately includes my users)...  Developers and 
users both need to push the major distributions to offer something 
reasonably current - we're both stuck with this silliness until users can 
count on new development being delivered in something a bit shorter than 
two years...

Caught in the middle, I ask both sides to push on the distributions at 
every opportunity! <push push>.

> Why hasn't someone complained that waitpid is still slow?

Is it?  I hadn't noticed, but I usually only go for the things users are in 
my cubicle complaining about, and I'm way downstream, so if it's not a 
problem there, I won't notice until I can get some time on a system to play 
with something current (within the next week or two, I hope).  I can look 
then, if you'd like.

> Why haven't we seen patches to reduce the number of kernel threads since
> last time you had problems with the pid infrastructure?
> 
> A very frustrated code reviewer.
> 
> So yes.  If you are not interested in 2.6.28 and in the general problem,
> I'm not interested in this problem.

Is there a general problem?

The last time we had trouble with the pid infrastructure, I believe it was 
the result of a patch leaking through, which, frankly, was quite poor.  I 
believe it's deficiencies have been addressed, and it looks like we now 
have a respectable implementation which should serve us well for a while.

There certainly is room for major architectural improvements.  Your ideas 
for moving from a hash to a radix are a good direction to take, and are 
something we should work on as processor counts continue to grow.  It is 
likely that we stand to gain in both raw cycles consumed as well as memory 
consumption - but we're not going to see that tomorrow.

I would think reducing process counts is also is a longer term project.  I 
wouldn't be looking at 2.6.28 for that, but rather 2.6.30 or so.  Most 
(possibly all) of the worst offenders appear to be using create_workqueue, 
which I don't expect will be trivial to change.  If someone picked up the 
task today, it might be ready for 2.6.29, but we may want more soak time, 
as it looks to me like an intrusive change with a high potential for 
unexpected consequences.

 From where I'm sitting, the current mechanism seems to do reasonably well, 
even with very large numbers of processes (hundreds of thousands), provided 
that the hash table is large enough to account for increased use.  The 
immediate barrier to adequate performance on large systems (that is, not 
unnecessarily wasting a significant portion of cycles) is the unreasonably 
low cap on the size of the hash table: it's an artificial limit, based on 
an outdated set of expectations about the sizes of systems.  As such, it's 
easy to extend the useful life of the current implementation with very 
little cost or effort.

A major rework with more efficient resource usage may be a higher priority 
for someone looking at higher processor counts with (relatively) tiny 
memory sizes.  If such people exist, it should not be difficult to take 
them into account when sizing the existing pid hash.

That's a short term (tomorrow-ish), very low risk project with immediate 
benefit: a small patch with no effect on systems <512c, which grows the pid 
hash when it is likely to be beneficial and there is plenty of memory to spare.

I'd really like to see an increased limit to the size of the pid hash in 
the near term.  If we can reduce process counts, we might revisit the 
sizing.  Better would be to start work on a more resource efficient 
implementation to eliminate it before we have to revisit it.  Ideal would 
be to move ahead with all three.  I don't see any (sensible) reason for any 
of these steps to be mutually exclusive.

-- 
Stephen Champion                           Silicon Graphics Site Team
schamp@(sgi.com|nas.nasa.gov)              NASA Advanced Supercomputing
