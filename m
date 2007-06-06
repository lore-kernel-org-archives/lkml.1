Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXFFKv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXFFKv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXFFKvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:51:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57336 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXFFKvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:51:48 -0400
Date: Wed, 6 Jun 2007 16:29:50 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070606105950.GA32729@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu> <20070606074317.GB3274@in.ibm.com> <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com> <46668E4D.8060206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46668E4D.8060206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 04:07:01PM +0530, Balbir Singh wrote:
> Dmitry Adamushko wrote:
> > On 06/06/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> >> On Wed, Jun 06, 2007 at 09:01:43AM +0200, Ingo Molnar wrote:
> >> > [...] and my tree already contains the fixes for rt task's
> >> > exec_start.
> >>
> >> Can I have this snapshot pls? I have to deal with the same issue when
> >> the current task switches groups and I was planning to fix it by
> >> introducing a set_curr_task() method in fair_sched_class which
> >> initializes exec_start and other fields for that task.
> > 
> > Hum.. what about accounting 'exec_time' and updating 'exec_start' in
> > rt_sched :: dequeue_task_rt() instead (like update_curr() does it in
> > dequeue_task_fair())?

[For some reason Dimitry's mail has not made it to my inbox yet ..]

> > This way, on RT -> NORMAL transition.. some 'delta_exec' ( between
> > deactivate_task() ---> activate_task() ) will be accounted later as if
> > the task was 'sched_fair_class' during this time.. which I think makes
> > some sense. What do you think?
> > 
> 
> Why not do it explicitly in __setscheduler() if the new policy is SCHED_NORMAL
> or SCHED_BATCH. 

Yes this is the approach I prefer, because we burden the fast/normal
path less that way (RT->NORMAL transition is not common). That's why I
was considering a set_curr_task() method in fair_sched_class which will
be invoked in __setscheduler() if the new policy of currently running
task happens to be SCHED_NORMAL/BATCH. Alternately if the new policy of
currently running task happens to be SCHED_FIFO (and its old policy was
SCHED_NORMAL) we need to invoke put_prev_task() method (so that
fair_clock etc is updated based on outgoing task's execution time in
SCHED_NORMAL class).

>You could also add the smarts to deactivate_task()


-- 
Regards,
vatsa
