Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZLBP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZLBP6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZLBP6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:58:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:56783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZLBP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:58:19 -0500
Subject: Re: [PATCH -v2 2/2] sched, cputime: introduce thread_group_times()
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <4B162517.8040909@jp.fujitsu.com>
References: <4AFB9029.9000208@jp.fujitsu.com>
	 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
	 <1258038038.4039.467.camel@laptop>
	 <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
	 <4B01A8DB.6090002@bluehost.com>
	 <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
	 <1258464288.7816.305.camel@laptop>
	 <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
	 <4B05F835.10401@jp.fujitsu.com>
	 <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
	 <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
	 <4B162517.8040909@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 16:58:08 +0100
Message-ID: <1259769488.4003.1119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 17:28 +0900, Hidetoshi Seto wrote:
> This is a real fix for problem of utime/stime values decreasing
> described in the thread:
>    http://lkml.org/lkml/2009/11/3/522
> 
> Now cputime is accounted in the following way:
> 
>  - {u,s}time in task_struct are increased every time when the thread
>    is interrupted by a tick (timer interrupt).
> 
>  - When a thread exits, its {u,s}time are added to signal->{u,s}time,
>    after adjusted by task_times().
> 
>  - When all threads in a thread_group exits, accumulated {u,s}time
>    (and also c{u,s}time) in signal struct are added to c{u,s}time
>    in signal struct of the group's parent.
> 
> So {u,s}time in task struct are "raw" tick count, while {u,s}time
> and c{u,s}time in signal struct are "adjusted" values.
> 
> And accounted values are used by:
> 
>  - task_times(), to get cputime of a thread:
>    This function returns adjusted values that originates from raw
>    {u,s}time and scaled by sum_exec_runtime that accounted by CFS.
> 
>  - thread_group_cputime(), to get cputime of a thread group:
>    This function returns sum of all {u,s}time of living threads in
>    the group, plus {u,s}time in the signal struct that is sum of
>    adjusted cputimes of all exited threads belonged to the group.
> 
> The problem is the return value of thread_group_cputime(), because
> it is mixed sum of "raw" value and "adjusted" value:
> 
>   group's {u,s}time = foreach(thread){{u,s}time} + exited({u,s}time)
> 
> This misbehavior can break {u,s}time monotonicity.
> Assume that if there is a thread that have raw values greater than
> adjusted values (e.g. interrupted by 1000Hz ticks 50 times but only
> runs 45ms) and if it exits, cputime will decrease (e.g. -5ms).
> 
> To fix this, we could do:
> 
>   group's {u,s}time = foreach(t){task_times(t)} + exited({u,s}time)
> 
> But task_times() contains hard divisions, so applying it for every
> thread should be avoided.
> 
> This patch fixes the above problem in the following way:
> 
>  - Modify thread's exit (= __exit_signal()) not to use task_times().
>    It means {u,s}time in signal struct accumulates raw values instead
>    of adjusted values.  As the result it makes thread_group_cputime()
>    to return pure sum of "raw" values.
> 
>  - Introduce a new function thread_group_times(*task, *utime, *stime)
>    that converts "raw" values of thread_group_cputime() to "adjusted"
>    values, in same calculation procedure as task_times().
> 
>  - Modify group's exit (= wait_task_zombie()) to use this introduced
>    thread_group_times().  It make c{u,s}time in signal struct to
>    have adjusted values like before this patch.
> 
>  - Replace some thread_group_cputime() by thread_group_times().
>    This replacements are only applied where conveys the "adjusted"
>    cputime to users, and where already uses task_times() near by it.
>    (i.e. sys_times(), getrusage(), and /proc/<PID>/stat.)
> 
> This patch have a positive side effect:
> 
>  - Before this patch, if a group contains many short-life threads
>    (e.g. runs 0.9ms and not interrupted by ticks), the group's
>    cputime could be invisible since thread's cputime was accumulated
>    after adjusted: imagine adjustment function as adj(ticks, runtime),
>      {adj(0, 0.9) + adj(0, 0.9) + ....} = {0 + 0 + ....} = 0.
>    After this patch it will not happen because the adjustment is
>    applied after accumulated.
> 
> v2:
>  - remove if()s, put new variables into signal_struct.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


Thanks for taking care of this!

