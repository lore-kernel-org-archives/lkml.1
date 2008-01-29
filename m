Return-Path: <linux-kernel-owner+w=401wt.eu-S1765022AbYA2Qso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765022AbYA2Qso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYA2Qsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:48:35 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:29105 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbYA2Qse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:48:34 -0500
Message-Id: <479F1118.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 09:42:16 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <rostedt@goodmis.org>, <menage@google.com>, <rientjes@google.com>,
       <tong.n.li@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <sgrubb@redhat.com>,
       <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <479F01AF.BA47.005A.0@novell.com> <20080129102836.be614579.pj@sgi.com>
In-Reply-To: <20080129102836.be614579.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at 11:28 AM, in message
<20080129102836.be614579.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Gregory wrote:
>>   I am a bit confused as to why you disable load-balancing in the
>>   RT cpuset?  It shouldn't be strictly necessary in order for the
>>   RT scheduler to do its job (unless I am misunderstanding what you
>>   are trying to accomplish?).  Do you do this because you *have*
>>   to in order to make real-time deadlines, or because its just a
>>   further optimization?
> 
> My primary motivation for cpusets originally, and for the
> sched_load_balance flag now, was not realtime, but "soft partitioning"
> of big NUMA systems, especially for batch schedulers.  They sometimes
> have large cpusets which are only being used to hold smaller, per-job,
> cpusets.  It is a waste of time (CPU cycles in the kernel sched code)
> to load balance those large cpusets.  Load balancing doesn't scale
> easily to high CPU counts, and it's nice to avoid doing that where
> not needed.

Understood, and that makes tons of sense.

> 
> See the following lkml message for a fuller explanation:
> 
>   http://lkml.org/lkml/2008/1/29/85
> 
> As a secondary motivation, I thought that disabling load balancing on
> the RT cpuset was the right thing to do for RT needs, but I make no
> claim to knowing much about RT.

Well, I make no claim to understand the large batch systems you work on either ;)  Everything you said made a ton of sense other than the RT/load-balance thing, but I think we are on the same page now.

> 
> I just now realized that you added a 'root_domain' in a patch in
> late Nov and early Dec.   I was on the road then, moving from
> California to Texas, and not paying much attention to Linux.

np (though I was wondering why you had no comment before ;)

> 
> A couple of questions on that patch, both involving a comment it adds
> to kernel/sched.c:
> 
> /*
>  * We add the notion of a root-domain which will be used to define per-domain
>  * variables. Each exclusive cpuset essentially defines an island domain by
>  * fully partitioning the member cpus from any other cpuset. Whenever a new
>  * exclusive cpuset is created, we also create and attach a new root-domain
>  * object.
>  */
> 
> 1) What are 'per-domain' variables?

s/per-domain/per-root-domain

> 
> 2) The mention of 'exclusive cpuset' is no longer correct.
> 
>    With the patch 'remove sched domain hooks from cpusets' cpusets
>    no longer defines sched domains using the cpu_exclusive flag.
> 
>    With the subsequent sched_load_balance patch (see
>    http://lkml.org/lkml/2007/10/6/19) cpusets uses a new per-cpuset
>    flag 'sched_load_balance' to define sched domains.

Doh!  Thanks for the heads up.  

> 
> The following revised comment might be more accurate:
> 
> /*
>  * We add the notion of a root-domain which will be used to define per-domain
>  * variables.  Each non-overlapping sched domain defines an island domain by
>  * fully partitioning the member cpus from any other cpuset. Whenever a new
>  * such a sched domain is created, we also create and attach a new 
> root-domain
>  * object.  These non-overlapping sched domains are determined by the cpuset
>  * configuration, via a call to partition_sched_domains().
>  */
> 
> It sounds like you (Gregory, others) want your RT CPUs to be in a sched
> domain, unlike the current way things are, where my cpuset code
> carefully avoids setting up a sched domain for those CPUs.  However I
> still have need, in the batch scheduler case explained above, to have
> some CPUs not in any sched domain.
> 
> If you require these RT sched domains to be setup differently somehow,
> in some way that is visible to partition_sched_domains, then that
> apparently means we need a per-cpuset flag to mark those RT cpusets.

I think we only need a plain-vanilla partition, so no flags should be necessary.

-Greg

> 
> If you just want an ordinary sched domain setup (just so long as it
> contains only the intended RT CPUs, not others) then I guess we don't
> technically need any more per-cpuset flags, but I'm worried, because
> the API we're presenting to users for this has just gone from subtle to
> bizarre.  I suspect I'll want to add a flag anyway, if by doing so, I
> can make the kernel-user API, via cpusets, easier to understand.



