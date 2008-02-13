Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbYBMFEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbYBMFEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYBMFDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:03:49 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35836 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYBMFDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:03:48 -0500
Date: Wed, 13 Feb 2008 08:30:35 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in latest sched-git
Message-ID: <20080213030035.GA3402@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080212185355.GA6320@linux.vnet.ibm.com> <1202845208.6247.82.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202845208.6247.82.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:40:08PM +0100, Peter Zijlstra wrote:
> Yes, latency isolation is the one thing I had to sacrifice in order to
> get the normal latencies under control.

Hi Peter,
	I don't have easy solution in mind either to meet both fairness
and latency goals in a acceptable way.

But I am puzzled at the max latency numbers you have provided below:

> The problem with the old code is that under light load: a kernel make
> -j2 as root, under an otherwise idle X session, generates latencies up
> to 120ms on my UP laptop. (uid grouping; two active users: peter, root).

If it was just two active users, then max latency should be:

	latency to schedule user entity (~10ms?) +
	latency to schedule task within that user 

20-30 ms seems more reaonable max latency to expect in this scenario.
120ms seems abnormal, unless the user had large number of tasks.

On the same lines, I cant understand how we can be seeing 700ms latency
(below) unless we had: large number of active groups/users and large number of 
tasks within each group/user.

> Others have reported latencies up to 300ms, and Ingo found a 700ms
> latency on his machine.
> 
> The source for this problem is I think the vruntime driven wakeup
> preemption (but I'm not quite sure). The other things that rely on
> global vruntime are sleeper fairness and yield. Now while I can't
> possibly care less about yield, the loss of sleeper fairness is somewhat
> sad (NB. turning it off with the old group scheduling does improve life
> somewhat).
> 
> So my first attempt at getting a global vruntime was flattening the
> whole RQ structure, you can see that patch in sched.git (I really ought
> to have posted that, will do so tomorrow).

We will do some exhaustive testing with this approach. My main concern
with this is that it may compromise the level of isolation between two
groups (imagine one group does a fork-bomb and how it would affect
fairness for other groups).

> With the experience gained from doing that, I think it might be possible
> to construct a hierarchical RQ model that has synced vruntime; but
> thinking about that still makes my head hurt.
> 
> Anyway, yes, its not ideal, but it does the more common case of light
> load much better - I basically had to tell people to disable
> CONFIG_FAIR_GROUP_SCHED in order to use their computer, which is sad,
> because its the default and we want it to be the default in the cgroup
> future.
> 
> So yes, I share your concern, lets work on this together.

-- 
Regards,
vatsa
