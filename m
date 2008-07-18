Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYGRMmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYGRMmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYGRMmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:42:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbYGRMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:42:36 -0400
Subject: Re: [PATCH 2/2] sched: readjust the load whenever task_setprio()
	is invoked
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: stable@vger.kernel.org, linux-rt-users@vger.kernel.org,
       rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080703213716.1275.33324.stgit@lsg.lsg.lab.novell.com>
References: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
	 <20080703213716.1275.33324.stgit@lsg.lsg.lab.novell.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 14:43:03 +0200
Message-Id: <1216384984.28405.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 15:37 -0600, Gregory Haskins wrote:
> The load may change with the priority, so be sure to recompute its value.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>

Right, but in this case we'd need to do the dec/inc load game again
because otherwise we'll skew stuff - see the previuos mail on how
dequeue_task() doesn't actually do that.

Also, it looks like current mainline still has this issue.

OTOH - since prio boosting is a temporal feature, not changing the load
isn't too bad, we ought to get back to where we came from pretty
quickly.



> ---
> 
>  kernel/sched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b046754..c3f41b9 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4637,6 +4637,7 @@ void task_setprio(struct task_struct *p, int prio)
>  		p->sched_class = &fair_sched_class;
>  
>  	p->prio = prio;
> +	set_load_weight(p);
>  
>  //	trace_special_pid(p->pid, __PRIO(oldprio), PRIO(p));
>  	prev_resched = _need_resched();
> 

