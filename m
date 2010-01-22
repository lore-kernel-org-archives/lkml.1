Return-Path: <linux-kernel-owner+w=401wt.eu-S932159Ab0AVDFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0AVDFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302Ab0AVDFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:05:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0AVDFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:05:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=6AAhZGXoe_sA:10 a=7U3hwN5JcxgA:10 a=fLFfvtlb_kOzgpMt78MA:9 a=z02eVH3Am-tzs_jg_gUA:7 a=7MgBE_vhMlMTBopojKqSjed5564A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
 checks in tracing hot path
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20100122024332.GB8140@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
	 <1264122982-1553-4-git-send-regression-fweisbec@gmail.com>
	 <1264125917.31321.312.camel@gandalf.stny.rr.com>
	 <20100122024332.GB8140@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 22:05:06 -0500
Message-ID: <1264129506.31321.325.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 03:43 +0100, Frederic Weisbecker wrote:

> > Now for the reason I Cc'd Paul and Mathieu...
> > 
> > If we had a synchronize_sched() like function that would wait and return
> > when all preempted tasks have been scheduled again and went to either
> > userspace or called schedule directly, then we could actually do this.
> > 
> > After unregistering the function graph trace, you call this
> > "synchronize_tasks()" and it will guarantee that all currently preempted
> > tasks have either went to userspace or have called schedule() directly.
> > Then it would be safe to remove this check.
> 
> 
> 
> Good point!
> 
> I fear that would require heavy hooks in the scheduler though...
> 

Not a heavy one. We could add a field to the task_struct and just call
something if it is set.


At start of schedule()

	if (unlikely(current->pcount))
		handle_pcount_waiters(current);


void handle_pcount_waiters(struct task_struct *p)
{
	current->pcount = 0;
	wake_up(pcount_waiters);
}


and for the synchronize_tasks(), just search the task list for tasks
that are on the run queue but not running, and add a pcount timestamp
and record the list of tasks (allocated list).

After it is woken up, it checks the list of tasks and if a task does not
have the pcount timestamp that matches what was stored, it removes it
from the list. When it is finally woken up and does not have any more
tasks on the list, it continues.

This is just a basic idea, i left out a bunch of details, but I'm sure
it is feasible. This type of wait may work for other types of lockless
algorithms too.

-- Steve



