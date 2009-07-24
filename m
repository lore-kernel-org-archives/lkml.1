Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZGXNFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZGXNFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZGXNFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:05:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54342 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZGXNFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:05:20 -0400
Date: Fri, 24 Jul 2009 09:05:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
In-Reply-To: <4A698F90.90501@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com>
References: <4A698F90.90501@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Jul 2009, Zhaolei wrote:

> Hello, Steven
> 
> It is a prototype code to make ftrace display walltime of events.
> 
> It need to applys on my patch of:
> [PATCH v3 1/2] Add function to convert between calendar time and broken-down time for universal use
> 
> This code can run but need to be fixed, it only for demostrate what is result
> looks like.
> 
> I think display walltime is valuable for ftrace, it can provide more
> recognizable information to system manager that he can known "when"
> event happened.
> And it is also helpful for flight-recorder we are doing now, we can get
> walltime of events after panic for analyse.
> 
> We can get following result on this patch:
>  # cd /mnt/debugfs/tracing/
>  # echo sched_switch > current_tracer
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>              bash-2457  [000]   214.895446:   2457:120:S   + [000]  2457:120:S bash
>              bash-2457  [000]   214.898298:   2457:120:R   + [000]     5:115:S events/0
>              bash-2457  [000]   214.898684:   2457:120:R ==> [000]     5:115:R events/0
>          events/0-5     [000]   214.899458:      5:115:R   + [000]  2455:120:S sshd
>          events/0-5     [000]   214.899495:      5:115:S ==> [000]  2455:120:R sshd
>  ...
>  # echo 1 > options/walltime
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#                  TIMESTAMP  FUNCTION
>  #              | |       |                        |         |
>            <idle>-0     [000] 2009-07-25 18:01:00.848468:      0:140:R ==> [000]     5:115:R events/0
>          events/0-5     [000] 2009-07-25 18:01:00.848523:      5:115:S ==> [000]     0:140:R <idle>
>            <idle>-0     [000] 2009-07-25 18:01:01.613479:      0:140:R   + [000]  2455:120:S sshd
>            <idle>-0     [000] 2009-07-25 18:01:01.613678:      0:140:R ==> [000]  2455:120:R sshd
>              sshd-2455  [000] 2009-07-25 18:01:01.614015:   2455:120:S   + [000]  2455:120:S sshd
>  ...
> 
> This patch is prototype because we have following things to do:
> 1: function to get walltime is not near rb_time_stamp()
>    So walltime is not absolutely synchronize with trace time.
>    But if we place code to get walltime near rb_time_stamp(), it will be called
>    on every reserve-event and will make system slow.
> 2: We can't call getnstimeofday() freely in ring-buffer's code, because
>    it is possibility already hold xtime_lock. Prototype code used a ugly way
>    to get gid of this problem, maybe we need to ftrace_disable_cpu() before
>    every write_seqlock() instead.
> 3: People maybe change walltime when tracing, but current ring-buffer page's
>    walltime can not reflect this change. We need to add tracepoints to watch
>    this change, and add a walltime-change event(already reserved in
>    ring-buffer.c) to record this change.
> 
> I'll continue to finish remain steps, what is your opinion on it?

Hi Zhaolei,

Could you not just save the wall time in some 64bit format within the 
current timestamp?  Right now there's three clocks that can be used by 
ftrace. Two that you can really get two (I need to add access to the 
third).  The default clock is sched_clock. But there's an option to get to 
global_clock:

 debug/tracing/options/global-clock

# echo 1 > /debug/tracing/options/global-clock

Will enable the global clock. Perhaps we can add a "wall clock" version 
that will map the timestamps to the wall clock?

I really hate adding any more fields to the ring buffer headers. That 
takes away from the amount that you can record per page.

-- Steve

