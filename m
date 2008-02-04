Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYBDGEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYBDGEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYBDGEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:04:46 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:52754 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYBDGEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:04:45 -0500
Message-ID: <47A6AABD.7080006@qualcomm.com>
Date: Sun, 03 Feb 2008 22:03:41 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	<1201511305.6149.30.camel@lappy>	<20080128085910.7d38e9f5.pj@sgi.com>	<479E20DA.2080403@qualcomm.com>	<20080128130637.60db148e.pj@sgi.com>	<47A21C53.2010502@qualcomm.com>	<20080202001612.98354ff2.pj@sgi.com>	<47A557E3.4080206@qualcomm.com> <20080203015315.6053d3dd.pj@sgi.com>
In-Reply-To: <20080203015315.6053d3dd.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> Paul, I actually mentioned at the beginning of my email that I did read that thread
>> started by Peter. I did learn quite a bit from it :)
> 
> Ah - sorry - I missed that part.  However, I'm still getting the feeling
> that there were some key points in that thread that we have not managed
> to communicate successfully.
I think you are assuming that I only need to deal with RT scheduler and scheduler
domains which is not correct. See below.

>> Sounds like at this point we're in agreement that sched_load_balance is not suitable
>> for what I'd like to achieve.
> 
> I don't think we're in agreement; I think we're in confusion ;)
Yeah. I don't believe I'm the confused side though ;-)

> Yes, sched_load_balance does not *directly* have anything to do with this.
> 
> But indirectly it is a critical element in what I think you'd like to
> achieve.  It affects how the cpuset code sets up sched_domains, and
> if I understand correctly, you require either (1) some sched_domains to
> only contain RT tasks, or (2) some CPUs to be in no sched_domain at all.
> 
> Proper configuration of the cpuset hierarchy, including the setting of
> the per-cpuset sched_load_balance flag, can provide either of these
> sched_domain partitions, as desired.
Again you're assuming that scheduling domain partitioning satisfies my requirements
or addresses my use case. It does not. See below for more details.
 
>> But how about making cpusets aware of the cpu_isolated_map ?
> 
> No.  That's confusing cpusets and the scheduler again.
> 
> The cpu_isolated_map is a file static variable known only within
> the kernel/sched.c file; this should not change.
I completely disagree. In fact I think all the cpu_xxx_map (online, present, isolated)
variables do not belong in the scheduler code. I'm thinking of submitting a patch that
factors them out into kernel/cpumask.c We already have cpumask.h.

> Presently, the boot parameter isolcpus= is just used to initialize
> what CPUs are isolated at boot, and then the sched_domain partitioning,
> as done in kernel/sched.c:partition_sched_domains() (the hook into
> the sched code that cpusets uses) determines which CPUs are isolated
> from that point forward.  I doubt that this should change either.
Sure, I did not even touch that part. I just proposed to extend the meaning of the 
'isolated' bit.

> In that thread referenced above, did you see the part where RT is
> achieved not by isolating CPUs from any scheduler, but rather by
> polymorphically having several schedulers available to operate on each
> sched_domain, and having RT threads self-select the RT scheduler?
Absolutely. Yes that is. I saw that part. But it has nothing to do with my use case.

Looks like I failed to explain what I'm trying to achieve. So let me try again.
I'd like to be able to run a CPU intensive (%100) RT task on one of the processors without 
adversely affecting or being affected by the other system activities. System activities 
here include _kernel_ activities as well. Hence the proposal is to extend current CPU 
isolation feature.

The new definition of the CPU isolation would be:
---
1. Isolated CPU(s) must not be subject to scheduler load balancing
   Users must explicitly bind threads in order to run on those CPU(s).

2. By default interrupts must not be routed to the isolated CPU(s)
   User must route interrupts (if any) explicitly.

3. In general kernel subsystems must avoid activity on the isolated CPU(s) as much as possible
   Includes workqueues, per CPU threads, etc.
   This feature is configurable and is disabled by default.  
---

#1 affects scheduler and scheduler domains. It's already supported either by using isolcpus= boot
option or by setting "sched_load_balance" in cpusets. I'm totally happy with the current behavior
and my original patch did not mess with this functionality in any way.

#2 and #3 have _nothing_ to do with the scheduler or scheduler domains. I've been trying to explain 
that for a few days now ;-). When you saw my patches for #2 and #3 you told me that you'd be interested 
to see them implemented on top of the "sched_load_balance" flag. Here is your original reply
	http://marc.info/?l=linux-kernel&m=120153260217699&w=2

So I looked into that and provided an explanation why it would not work or would work but would add 
lots of complexity (access to internal cpuset structures, locking, etc).
My email on that is here:
	http://marc.info/?l=linux-kernel&m=120180692331461&w=2

Now, I felt from the beginning that cpusets is not the right mechanism to address number #2 and #3.
The best mechanism IMO is to simply provide an access to the cpu_isolated_map to the rest of the kernel.
Again the fact that cpu_isolated_map currently lives in the scheduler code does not change anything 
here because as I explained I'm proposing to extend the meaning of the "CPU isolation". I provided 
dynamic access to the "isolated" bit only for convince, it does _not_ change existing scheduler/sched 
domain/cpuset logic in any way.

Hopefully we're on the same page with regards to the "CPU isolation" now.
If not please let me know what I missed from the earlier discussions or other scheduler related threads.

---

If you think that making cpusets aware of isolated cpus is not the right thing to do that's perfectly
fine by me. I think it'd be better if they were but we can keep things the way they are right now.

Max
