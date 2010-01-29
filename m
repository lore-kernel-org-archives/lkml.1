Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642Ab0A2Dt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0A2Dt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 22:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152Ab0A2Dt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 22:49:26 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:48887 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab0A2DtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 22:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IlnV05oxh6ljrzjF+JfKvvl66zgO/T25yfbdUGkRjtKDXL6ovwQp0MzrcZwPkkrD8z
         S3I7tX6hWfPUdOnS9ukp+aqmnlQeqd+C5sDL+0mk98SSjOaBSKBce7x8+ludgKU4jqCz
         6eIiMAinNQUfuwz3M93TIlArNIA8KQNqSibiw=
MIME-Version: 1.0
In-Reply-To: <loom.20100108T214459-933@post.gmane.org>
References: <20100105075703.GE27899@in.ibm.com>
	 <loom.20100108T214459-933@post.gmane.org>
Date: Fri, 29 Jan 2010 09:19:24 +0530
Message-ID: <344eb09a1001281949p37cd6d1awbc561937fc8f04f5@mail.gmail.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
From: Bharata B Rao <bharata.rao@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>, bharata <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 9, 2010 at 2:15 AM, Paul Turner <pjt@google.com> wrote:
>
> Hi Bharata,

Hi Paul,

Sorry for the late reply. Since you removed the CC-list, I didn't get
this mail in my inbox and hence didn't notice this at all until this
time!

[Putting back the original CC list in this mail]

>
> Thanks for the updated patchset.  As discussed the other day briefly I have some
> concerns with the usage of the current RT bandwidth rate-limiting code as there
> are some assumptions made that I feel don't fit the general case well.
>
> The reason for this is that the borrowing logic in bandwidth rebalance appears
> to make the assumption that we wil will be able to converge rapidly to the
> period.  Indeed, in each iteration of redistribution we take only
> 1/weight(nrcpus) [assuming no cpuset partitions] of the time remaining.  This is
> a decreasing series, and if we can't exceed the period our convergence looks
> pretty slow [geometric series].
>
> In general it appears the following relation be satisfied for efficient
> execution:  (weight(nr_cpus) * runtime) >> period
>
> This assumption is well satisfied in the RT case since the available bandwidth
> is very high.  However I fear for the general case of user limits on tg usage
> lie at the other end of the spectrum.  Especially for those trying to partition
> large machines into many smaller well provisioned fractions, e.g. 0-2 cores out
> of a total 64.  The lock and re-distribution cost for each iteration is also
> going to be quite high in this case which will potentially compound on the
> number of iterations required above.

I see your point. Having a runtime which is much lesser than the
period will result in a lot of iterations of borrowing from every CPU
before the source CPU accumulates the maximum possible runtime.

Apart from this, I also see that after accumulating the maximum
possible runtime from all CPUs, the task sometimes moves to another
CPU due to load balancing. When this happens, the new CPU starts the
borrowing iterations all over again!

As you observe, borrowing just 1/n th (n = number of CPUs) of the
spare runtime from each CPU is not ideal for CFS if runtimes are going
to be much lesser than period unlike RT. This would involve iterating
through all the CPUs and acquiring/releasing a spinlock in each
iteration.

>
> What are your thoughts on using a separate mechanism for the general case.  A
> draft proposal follows:
>
> - Maintain a global run-time pool for each tg.  The runtime specified by the
>  user represents the value that this pool will be refilled to each period.
> - We continue to maintain the local notion of runtime/period in each cfs_rq,
>  continue to accumulate locally here.
>
> Upon locally exceeding the period acquire new credit from the global pool
> (either under lock or more likely using atomic ops).  This can either be in
> fixed steppings (e.g. 10ms, could be tunable) or following some quasi-curve
> variant with historical demand.
>
> One caveat here is that there is some over-commit in the system, the local
> differences of runtime vs period represent additional over the global pool.
> However it should not be possible to consistently exceed limits since the rate
> of refill is gated by the runtime being input into the system via the per-tg
> pool.
>

We borrow from what is actually available as spare (spare = unused or
remaining). With global pool, I see that would be difficult.
Inability/difficulty in keeping the global pool in sync with the
actual available spare time is the reason for over-commit ?

> This would also naturally associate with an interface change that would mean the
> runtime limit for a group would be the effective cpurate within the period.
>
> e.g. by setting a runtime of 200000us on a 100000us period it would effectively
> allow you to use 2 cpus worth of wall-time on a multicore system.
>
> I feel this is slightly more natural than the current definition which due to
> being local means that values set will not result in consistent behavior across
> machines of different core counts.  It also has the benefit of being consistent
> with observed exports of time consumed, e.g. rusage, (indirectly) time, etc.

Though runtimes are enforced locally per-cpu, that's only the
implementation. The definition of runtime and period is still
system-wide/global. A runtime/period=0.25/0.5 will mean 0.25s of
system wide runtime within a period of 0.5s. Talking about consistent
definition, I would say this consistently defines half of system wide
wall-time on all configurations :) If it means 2 CPUs worth wall-time
in 4 core machine, it would mean 4 CPUs on a 8 CPU machine.  At this
point, I am inclined to go with this and let the admins/tools work out
the actual CPUs part of it. However I would like to hear what others
think about this interface.

>
> For future scalability as machine size grows this could potentially be
> partitioned below the tg level along the boundaries of sched_domains (or
> something similar).  However for an initial draft given current machine sizes
> the contention on the global pool should hopefully be fairly low.

One of the alternatives I have in mind is to be more aggressive while
borrowing. While keeping the current algorithm (of iterating thro' all
CPUs when borrowing) intact, we could potentially borrow more from
those CPUs which don't have any running task from the given group. I
just experimented with borrowing half of the available runtime from
such CPUs and found that number of iterations are greatly reduced and
the source runtime quickly converges to its max possible value. Do you
see any issues with this ?

Thanks for your note.

Regards,
Bharata.
--
http://bharata.sulekha.com/blog/posts.htm, http://raobharata.wordpress.com/
