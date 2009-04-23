Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZDWMTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZDWMTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZDWMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:19:11 -0400
Received: from thunk.org ([69.25.196.29]:47863 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZDWMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:19:09 -0400
Date: Thu, 23 Apr 2009 08:17:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090423121745.GC2723@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrea Righi <righi.andrea@gmail.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, randy.dunlap@oracle.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>,
	Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
	Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
	dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
	agk@sourceware.org, subrata@linux.vnet.ibm.com,
	Paul Menage <menage@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
	ngupta@google.com
References: <20090421191401.GF15541@mit.edu> <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com> <20090422102239.GA1935@linux> <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com> <20090423012254.GZ15541@mit.edu> <20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com> <20090423043547.GB2723@mit.edu> <20090423094423.GA9756@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423094423.GA9756@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 11:44:24AM +0200, Andrea Righi wrote:
> This is true in part. Actually io-throttle v12 has been largely tested,
> also in production environments (Matt and David in cc can confirm
> this) with quite interesting results.
> 
> I tested the previous versions usually with many parallel iozone, dd,
> using many different configurations.
> 
> In v12 writeback IO is not actually limited, what io-throttle did was to
> account and limit reads and direct IO in submit_bio() and limit and
> account page cache writes in balance_dirty_pages_ratelimited_nr().

Did the testing include what happened if the system was also
simultaneously under memory pressure?  What you might find happening
then is that the cgroups which have lots of dirty pages, which are not
getting written out, have their memory usage "protected", while
cgroups that have lots of clean pages have more of their pages
(unfairly) evicted from memory.  The worst case, of course, would be
if the memory pressure is coming from an uncapped cgroup.

> In a previous discussion (http://lkml.org/lkml/2008/11/4/565) we decided
> to split the problems: the decision was that IO controller should
> consider only IO requests and the memory controller should take care of
> the OOM / dirty pages problems. Distinct memcg dirty_ratio seemed to be
> a good start. Anyway, I think we're not so far from having an acceptable
> solution, also looking at the recent thoughts and discussions in this
> thread. For the implementation part, as pointed by Kamezawa per bdi /
> task dirty ratio is a very similar problem. Probably we can simply
> replicate the same concepts per cgroup.

I looked at that discussion, and it doesn't seem to be about splitting
the problem between the IO controller and the memory controller at
all.  Instead, Andrew is talking about how thottling dirty memory page
writeback on a per-cpuset basis (which is what Christoph Lamaeter
wanted for large SGI systems) made sense as compared to controlling
the rate at which pages got dirty, which is considered much higher
priority:

    Generally, I worry that this is a specific fix to a specific problem
    encountered on specific machines with specific setups and specific
    workloads, and that it's just all too low-level and myopic.

    And now we're back in the usual position where there's existing code and
    everyone says it's terribly wonderful and everyone is reluctant to step
    back and look at the big picture.  Am I wrong?

    Plus: we need per-memcg dirty-memory throttling, and this is more
    important than per-cpuset, I suspect.  How will the (already rather
    buggy) code look once we've stuffed both of them in there?
   
So that's basically the same worry I have; which is we're looking at
things at a too-low-level basis, and not at the big picture.

There wasn't discussion about the I/O controller on this thread at
all, at least as far as I could find; nor that splitting the problem
was the right way to solve the problem.  Maybe somewhere there was a
call for someone to step back and take a look at the "big picture"
(what I've been calling the high level design), but I didn't see it in
the thread.

It would seem to be much simpler if there was a single tuning knob for
the I/O controller and for dirty page writeback --- after all, why
*else* would you be trying to control the rate at which pages get
dirty?  And if you have a cgroup which sometimes does a lot of writes
via direct I/O, and sometimes does a lot of writes through the page
cache, and sometimes does *both*, it would seem to me that if you want
to be able to smoothly limit the amount of I/O it does, you would want
to account and charge for direct I/O and page cache I/O under the same
"bucket".   Is that what the user would want?   

Suppose you only have 200 MB/sec worth of disk bandwidth, and you
parcel it out in 50 MB/sec chunks to 4 cgroups.  But you also parcel
out 50MB/sec of dirty writepages quota to each of the 4 cgroups.  Now
suppose one of the cgroups, which was normally doing not much of
anything, suddenly starts doing a database backup which does 50 MB/sec
of direct I/O reading from the database file, and 50 MB/sec dirtying
pages in the page cache as it writes the backup file.  Suddenly that
one cgroup is using half of the system's I/O bandwidth!

And before you say this is "correct" from a definitional point of
view, is it "correct" from what a system administrator would want to
control?  Is it the right __feature__?  If you just say, well, we
defined the problem that way, and we're doing things the way we
defined it, that's a case of garbage in, garbage out.  You also have
to ask the question, "did we define the _problem_ in the right way?"
What does the user of this feature really want to do?  

It would seem to me that the system administrator would want a single
knob, saying "I don't know or care how the processes in a cgroup does
its I/O; I just want to limit things so that the cgroup can only hog
25% of the I/O bandwidth."

And note this is completely separate from the question of what happens
if you throttle I/O in the page cache writeback loop, and you end up
with an imbalance in the clean/dirty ratios of the cgroups.  And
looking at this thread, life gets even *more* amusing on NUMA machines
if you do this; what if you end up starving a cpuset as a result of
this I/O balancing decision, so a particular cpuset doesn't have
enough memory?  That's when you'll *definitely* start having OOM
problems.

So maybe someone has thought about all of these issues --- if so, may
I gently suggest that someone write all of this down?  The design
issues here are subtle, at least to my little brain, and relying on
people remembering that something was discussed on LKML six months ago
doesn't seem like a good long-term strategy.  Eventually this code
will need to be maintained, and maybe some of the engineers working on
it will have moved on to other projects.  So this is something that is
rather definitely deserves to be written up and dropped into
Documentation/ or in ample code code comments discussing on the
various subsystems interact.

Best regards,

					- Ted
