Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0CCQsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:48:36 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43917 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754752Ab0CCQsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:48:31 -0500
Date: Wed, 3 Mar 2010 18:01:10 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: use EDF to throttle RT task groups v2
Message-ID: <20100303170110.GS2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <1267273991.22519.744.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267273991.22519.744.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Sat, Feb 27, 2010 01:33:11PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> >   - Since it is not easy to mix tasks and groups on the same scheduler
> >     queue (tasks have no deadlines), the bandwidth reserved to the tasks
> >     in a group is controlled with two additional cgroup attributes:
> >     rt_task_runtime_us and rt_task_period_us.  These attributes control,
> >     within a cgroup, how much bandwidth is reserved to the tasks it
> >     contains.  The old attributes, rt_runtime_us and rt_period_us, are
> >     still there, and control the bandwidth assigned to the cgroup.  They
> >     are used only for admission control. 
> 
> We could do this implicitly by simply setting the task_bandwidth to the
> cgroup bandwidth - \Sum_children bandwidth.
> 
> Having it explicit gives the administrator slightly more control at the
> cost of a more complex interface.
> 
> Just wondering if you thought about this trade-off?

I started with it, because I didn't like changing the interface and
because four files to manage the bandwidth *are* a nightmare from the
user perspective...  The problem with using only two files and assign
the residual bandwidth to the tasks in the group is that it makes really
hard to find out how much bw is allocated to the tasks, esp. when
the child groups have different periods.  In practice we would be
guaranteeing something but the user would have a hard time finding
out what...

The biggest problem with the four files used in the current implementation
is that bandwidth assignments should be atomic (because setting all the
parameters independently can force the system to go through non-feasible
assignments, and the order to use when assigning runtime and period
changes depending on the direction of the change).  I know this is a
dangerous question, but I'll try it anyway: are we ready for multi-valued
cgroup parameters?
