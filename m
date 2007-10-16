Return-Path: <linux-kernel-owner+w=401wt.eu-S1764801AbXJPFLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764801AbXJPFLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbXJPFL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:11:27 -0400
Received: from qsrv03sl.mx.bigpond.com ([144.140.92.183]:29546 "EHLO
	qsrv03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXJPFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:11:25 -0400
Message-ID: <471410EF.90808@bigpond.net.au>
Date: Tue, 16 Oct 2007 11:16:31 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
References: <20071015111132.GA3015@ff.dom.local>
In-Reply-To: <20071015111132.GA3015@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta08sl.mx.bigpond.com from [124.179.200.236] using ID pwil3058@bigpond.net.au at Tue, 16 Oct 2007 01:16:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 13-10-2007 03:29, Peter Williams wrote:
>> Jarek Poplawski wrote:
>>> On 12-10-2007 00:23, Peter Williams wrote:
>>> ...
>>>> The reason I was going that route was for modularity (which helps 
>>>> when adding plugsched patches).  I'll submit a revised patch for 
>>>> consideration.
>>> ...
>>>
>>> IMHO, it looks like modularity could suck here:
>>>
>>>> +static unsigned int default_timeslice_fair(struct task_struct *p)
>>>> +{
>>>> +    return NS_TO_JIFFIES(sysctl_sched_min_granularity);
>>>> +}
>>> If it's needed for outside and sched_fair will use something else
>>> (to avoid double conversion) this could be misleading. Shouldn't
>>> this be kind of private and return something usable for the class
>>> mainly?
>> This is supplying data for a system call not something for internal use 
>> by the class.  As far as the sched_fair class is concerned this is just 
>> a (necessary - because it's need by a system call) diversion.
> 
> So, now all is clear: this is the misleading case!
> 
>>> Why anything else than sched_fair should care about this?
>> sched_fair doesn't care so if nothing else does why do we even have 
>> sys_sched_rr_get_interval()?  Is this whole function an anachronism that 
>> can be expunged?  I'm assuming that the reason it exists is that there 
>> are user space programs that use this system call.  Am I correct in this 
>> assumption?  Personally, I can't think of anything it would be useful 
>> for other than satisfying curiosity.
> 
> Since this is for some special aim (not default for most classes, at
> least not for sched_fair) I'd suggest to change names:
> default_timeslice_fair() and .default_timeslice to something like eg.:
> rr_timeslice_fair() and .rr_timeslice or rr_interval_fair() and
> .rr_interval (maybe with this "default" before_"rr_" if necessary).
> 
> On the other hand man (2) sched_rr_get_interval mentions that:
> "The identified process should be running under the SCHED_RR
> scheduling policy".
> 
> Also this place seems to say about something simpler:
> http://www.gnu.org/software/libc/manual/html_node/Basic-Scheduling-Functions.html
> 
> So, I still doubt sched_fair's "notion" of timeslices should be
> necessary here.

As do I.  Even more so now that you've shown me the man page for 
sched_rr_get_interval().

I'd suggest that we modify sched_rr_get_interval() to return -EINVAL 
(with *interval set to zero) if the target task is not SCHED_RR.  That 
way we can save a lot of unnecessary code.  I'll work on a patch. 
Unless you want to do it?

> 
> Sorry for too harsh words.

I didn't consider them harsh.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
