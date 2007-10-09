Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbXJIPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbXJIPB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXJIPBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:01:16 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:50413 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbXJIPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:01:15 -0400
Date: Tue, 9 Oct 2007 11:00:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, kravetz@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, pmorreale@novell.com,
       sdietrich@novell.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] RT: scheduler fixes and rt_overload enhancements
In-Reply-To: <20071009142044.4941.65189.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710091054430.21404@gandalf.stny.rr.com>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Tue, 9 Oct 2007, Gregory Haskins wrote:
> Hi All,

Hi Gregory,

>
> The first two patches are from Mike and Steven on LKML, which the rest of my
> series is dependent on.  Patch #4 is a resend from earlier.
>
> Series Summary:
>
> 1) Send IPI on overload regardless of whether prev is an RT task

OK.

> 2) Set the NEEDS_RESCHED flag on reception of RESCHED_IPI

Peter Zijlstra and I have been discussing this IPI Resched change a bit.
It seems that it is too much overkill for what is needed. That is, the
send_reschedule is used elsewhere where we do not want to actually do a
schedule.

I'm thinking about trying out a method that each rq has the priority of
the current task that is running. On case where we get an rt overload
(like in the finish_task_switch) we do a scan of all CPUS (not taking any
locks) and find the CPU which the lowest priority. If that CPU has a lower
prioirty than a waiting task to run on the current CPU then we grab the
lock for that rq, check to see if the priority is still lower, and then
push the rt task over to that CPU.

If after taking the rq lock a schedule had taken place and a higher RT
task is running, then we would try again, two more times. If this
phenomenon happens two more times, we punt and wouldn't do anything else
(paranoid attempt to fall into trying over and over on a high context
switch RT system).


> 3) Fix a mistargeted IPI on overload
> 4) Track which CPUS are in overload for efficiency
> 5) Track which CPUs are eligible for rebalancing for efficiency

The above three may be obsoleted by this new algorithm.

-- Steve

