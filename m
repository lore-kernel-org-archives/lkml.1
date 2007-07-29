Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbXG2ClK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbXG2ClK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 22:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbXG2Ckz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 22:40:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbXG2Cky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 22:40:54 -0400
Message-ID: <46ABFE2D.1060505@redhat.com>
Date: Sat, 28 Jul 2007 22:40:45 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Tong Li <tong.n.li@intel.com>
CC: "Bill Huey (hui)" <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu> <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com> <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com> <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com> <46AA8171.2060400@redhat.com> <20070728005438.GE32582@gnuppy.monkey.org> <46AAB106.2030104@redhat.com> <Pine.LNX.4.64.0707281224100.22772@tongli.jf.intel.com>
In-Reply-To: <Pine.LNX.4.64.0707281224100.22772@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tong Li wrote:
> On Fri, 27 Jul 2007, Chris Snook wrote:
> 
>> Bill Huey (hui) wrote:
>>> You have to consider the target for this kind of code. There are 
>>> applications
>>> where you need something that falls within a constant error bound. 
>>> According
>>> to the numbers, the current CFS rebalancing logic doesn't achieve 
>>> that to
>>> any degree of rigor. So CFS is ok for SCHED_OTHER, but not for 
>>> anything more
>>> strict than that.
>>
>> I've said from the beginning that I think that anyone who desperately 
>> needs perfect fairness should be explicitly enforcing it with the aid 
>> of realtime priorities.  The problem is that configuring and tuning a 
>> realtime application is a pain, and people want to be able to 
>> approximate this behavior without doing a whole lot of dirty work 
>> themselves.  I believe that CFS can and should be enhanced to ensure 
>> SMP-fairness over potentially short, user-configurable intervals, even 
>> for SCHED_OTHER.  I do not, however, believe that we should take it to 
>> the extreme of wasting CPU cycles on migrations that will not improve 
>> performance for *any* task, just to avoid letting some tasks get ahead 
>> of others.  We should be as fair as possible but no fairer.  If we've 
>> already made it as fair as possible, we should account for the margin 
>> of error and correct for it the next time we rebalance.  We should not 
>> burn the surplus just to get rid of it.
> 
> Proportional-share scheduling actually has one of its roots in real-time 
> and having a p-fair scheduler is essential for real-time apps (soft 
> real-time).

Sounds like another scheduler class might be in order.  I find CFS to be 
fair enough for most purposes.  If the code that gives us near-perfect 
fairness at the expense of efficiency only runs when tasks have been 
given boosted priority by a privileged user, and only on the CPUs that 
have such tasks queued on them, the run time overhead and code 
complexity become much smaller concerns.

>>
>> On a non-NUMA box with single-socket, non-SMT processors, a constant 
>> error bound is fine.  Once we add SMT, go multi-core, go NUMA, and add 
>> inter-chassis interconnects on top of that, we need to multiply this 
>> error bound at each stage in the hierarchy, or else we'll end up 
>> wasting CPU cycles on migrations that actually hurt the processes 
>> they're supposed to be helping, and hurt everyone else even more.  I 
>> believe we should enforce an error bound that is proportional to 
>> migration cost.
>>
> 
> I think we are actually in agreement. When I say constant bound, it can 
> certainly be a constant that's determined based on inputs from the 
> memory hierarchy. The point is that it needs to be a constant 
> independent of things like # of tasks.

Agreed.

>> But this patch is only relevant to SCHED_OTHER.  The realtime 
>> scheduler doesn't have a concept of fairness, just priorities.  That 
>> why each realtime priority level has its own separate runqueue.  
>> Realtime schedulers are supposed to be dumb as a post, so they cannot 
>> heuristically decide to do anything other than precisely what you 
>> configured them to do, and so they don't get in the way when you're 
>> context switching a million times a second.
> 
> Are you referring to hard real-time? As I said, an infrastructure that 
> enables p-fair scheduling, EDF, or things alike is the foundation for 
> real-time. I designed DWRR, however, with a target of non-RT apps, 
> although I was hoping the research results might be applicable to RT.

I'm referring to the static priority SCHED_FIFO and SCHED_RR schedulers, 
which are (intentionally) dumb as a post, allowing userspace to manage 
CPU time explicitly.  Proportionally fair scheduling is a cool 
capability, but not a design goal of those schedulers.

	-- Chris
