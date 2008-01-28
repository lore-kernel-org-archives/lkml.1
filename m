Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbYA1QgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbYA1QgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbYA1QgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:36:04 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:51380 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYA1QgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:36:01 -0500
Date: Mon, 28 Jan 2008 11:34:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Jackson <pj@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, srostedt@redhat.com,
       ghaskins@novell.com
Subject: Re: [CPUISOL] CPU isolation extensions
Message-ID: <20080128163450.GC12598@goodmis.org>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com> <1201511305.6149.30.camel@lappy> <20080128085910.7d38e9f5.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128085910.7d38e9f5.pj@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 08:59:10AM -0600, Paul Jackson wrote:
> Thanks for the CC, Peter.

Thanks from me too.

> Max wrote:
> > We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
> > I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
> 
> I recently added the per-cpuset flag 'sched_load_balance' for some
> other realtime folks, so that they can disable the kernel scheduler
> load balancing on isolated CPUs.  It essentially allows for dynamic
> control of which CPUs are isolated by the scheduler, using the cpuset
> hierarchy, rather than enhancing the 'isolated_cpus' mask.   That
> 'isolated_cpus' mask remained a minimal kernel boottime parameter.
> I believe this went to Linus's tree about Oct 2007.
> 
> It looks like you have three additional tweaks for realtime in this
> patch set, with your patches:
> 
>   [PATCH] [CPUISOL] Do not route IRQs to the CPUs isolated at boot

I didn't know we still routed IRQs to isolated CPUs. I guess I need to
look deeper into the code on this one. But I agree that isolated CPUs
should not have IRQs routed to them.

>   [PATCH] [CPUISOL] Support for workqueue isolation

The thing about workqueues is that they should only be woken on a CPU if
something on that CPU accessed them. IOW, the workqueue on a CPU handles
work that was called by something on that CPU. Which means that
something that high prio task did triggered a workqueue to do some work.
But this can also be triggered by interrupts, so by keeping interrupts
off the CPU no workqueue should be activated.

>   [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"

This I find very dangerous. We are making an assumption that tasks on an
isolated CPU wont be doing things that stopmachine requires. What stops
a task on an isolated CPU from calling something into the kernel that
stop_machine requires to halt?

-- Steve


> 
> It would be interesting to see a patchset with the above three realtime
> tweaks, layered on this new cpuset 'sched_load_balance' apparatus, rather
> than layered on changes to make 'isolated_cpus' more dynamic.  Some of us
> run realtime and cpuset-intensive loads on the same system, so like to
> have those two capabilities co-operate with each other.
> 
> Ingo - what's your sense of the value of the above three realtime tweaks
>        (the last three patches in Max's patch set)?
> 
