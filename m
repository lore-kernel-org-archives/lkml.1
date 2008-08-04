Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbYHDWL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbYHDWL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbYHDWK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:10:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58929 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbYHDWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:10:55 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5353"; a="5139485"
Message-ID: <48977E81.4040207@qualcomm.com>
Date: Mon, 04 Aug 2008 15:11:13 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com> <20080804010033.0d1b0549.pj@sgi.com>
In-Reply-To: <20080804010033.0d1b0549.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> So far as I can tell, the logic and design is ok.
> 
> I found some of the comments, function names and code factoring
> to be confusing or incomplete.  And I suspect that the rebuilding
> of sched domains in the case that sched_power_savings_store()
> is called in kernel/sched.c, on systems using cpusets, is not
> needed or desirable (I could easily be wrong here - beware!).
Actually we do need it. See below.

> I'm attaching a patch that has the changes that I would like
> to suggest for your consideration.  I have only recompiled this
> patch, for one configuration - x86_64 with CPUSETS.  I am hoping,
> Max, that you can complete the testing.
> 
> The patch below applies to 2.6.27-rc1, plus the first patch,
> "origin.patch" in Andrew's 2.6.27-rc1-mm1 quilt patch stack,
> plus your (Max's) latest:
>     [PATCH] cpuset: Rework sched domains and CPU hotplug handling (2.6.27-rc1)
> 
> Here's a description of most of what I noticed:
> 
>  1) Unrelated spacing tweak, changing:
>         LIST_HEAD(q);           /* queue of cpusets to be scanned*/
>     to:
>         LIST_HEAD(q);           /* queue of cpusets to be scanned */
Check.

>  2) The phrasing:
> 	Must be called with cgroup_lock held.
>     seems imprecise to me; "cgroup_lock" is the name of a wrapper
>     function, not of a lock.  The underlying lock is cgroup_mutex,
>     which is still mentioned by name in various kernel/cpuset.c
>     comments, even though cgroup_mutex is static in kernel/cgroup.c
>     So I fiddled with the wording of this phrasing.
Check.

>  3) You removed the paragraph:
> 	  * ...  May take callback_mutex during
> 	  * call due to the kfifo_alloc() and kmalloc() calls.  May nest
> 	  * a call to the get_online_cpus()/put_online_cpus() pair.
> 	  * Must not be called holding callback_mutex, because we must not
> 	  * call get_online_cpus() while holding callback_mutex.  Elsewhere
> 	  * the kernel nests callback_mutex inside get_online_cpus() calls.
> 	  * So the reverse nesting would risk an ABBA deadlock.
>    
>    But you didn't replace it with an updated locking description.
>    I expanded and tweaked various locking comments.
I think it it's covered by the top level comment that starts with
/*
 * There are two global mutexes guarding cpuset structures.  The first
 * is the main control groups cgroup_mutex, accessed via
 * cgroup_lock()/cgroup_unlock().
 ....

But I'm ok with your suggested version.

>  4) The alignment of the right side of consecutive assignment statements,
>     as in:
>         ndoms = 0;
>         doms  = NULL;
>         dattr = NULL;
>         csa   = NULL;
>     or
>         *domains    = doms;
>         *attributes = dattr;
>     is not usually done in kernel code.  I suggest obeying convention,
>     and not aligning these here either.
Check.

>  5) The rebuilding of sched domains in the sched_power_savings_store()
>     routine in kernel/sched.c struck me as inappropriate for systems
>     that were managing sched domains using cpusets.  So I made that
>     sched.c rebuild only apply if CONFIG_CPUSETS was not configured,
>     which in turn enabled me to remove rebuild_sched_domains() from
>     being externally visible outside kernel/cpuset.c
>     
>     I don't know if this change is correct, however.
Actually it is appropriate, and there is one more user of the
arch_reinit_sched_domains() which is S390 topology updates.
Those things (mc_power and topology updates) have to update domain flags based
on the mc/smt power and current topology settings.
This is done in the
  __rebuild_sched_domains()
       ...
       SD_INIT(sd, ALLNODES);
       ...
       SD_INIT(sd, MC);
       ...

SD_INIT(sd,X) uses one of SD initializers defined in the include/linux/topology.h
For example SD_CPU_INIT() includes BALANCE_FOR_PKG_POWER which expands to

#define BALANCE_FOR_PKG_POWER   \
        ((sched_mc_power_savings || sched_smt_power_savings) ?  \
         SD_POWERSAVINGS_BALANCE : 0)

Yes it's kind convoluted :). Anyway, the point is that we need to rebuild the
domains when those settings change. We could probably write a simpler version
that just iterates existing domains and updates the flags. Maybe some other dat :)

>  6) The renaming of rebuild_sched_domains() to generate_sched_domains()
>     was only partial, and along with the added similarly named routines
>     seemed confusing to me.  Also, that rename of rebuild_sched_domains()
>     was only partially accomplished, not being done in some comments
>     and in one printk kernel warning.
> 
>     I reverted that rename.
Actually it was not much of a rename. The only rename was
rebuild_sched_domains() -> async_rebuild_sched_domains() and yes looks like I
missed one or two comment.
The other stuff was basically factoring out the function that generates the
domain masks/attrs from the function that actually tells the scheduler to
rebuild them.
I'd be ok with some other name for generate_sched_domains() if you think it's
confusing.

btw With your current proposal we have
 rebuild_sched_domains()       - just generates domain masks/attrs
 async_rebuild_sched_domains() - generates domain masks/attrs and actually
                                 rebuilds the domains

That I think is more confusing. So I guess my preference would be to have the
generation part separate. And like I explained above we do need to be able to
call rebuild_sched_domains() from the scheduler code (at least at this point).

>     I also reduced by one the number of functions needed to handle
>     the asynchronous invocation of this rebuild, essentially collapsing
>     your routines rebuild_sched_domains() and rebuild_domains_callback()
>     into a single routine, named rebuild_sched_domains_thread().
> 
>     Thanks to the above change (5), the naming and structure of these
>     routines was no longer visible outside kernel/cpuset.c, making
>     this collapsing of two functions into one easier.
Yes if we did not have to call rebuild_sched_domains() from
arch_reinit_sched_domains() I would've done something similar.

Sounds like you're ok with the general approach and as I mentioned we do need
externally usable rebuild_sched_domains(). So how about this. I'll update
style/comments based on your suggestions but keep the generate_sched_domains()
 and partition_sched_domains() split. Or if you have a better name for
generate_sched_domains() we'll use that instead.

Max
