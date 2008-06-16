Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYFPMmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYFPMmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYFPMm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:42:26 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51683 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYFPMmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:42:25 -0400
Date: Mon, 16 Jun 2008 18:12:22 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Madhava K R <madhavakr@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, bharathravi1@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       vatsa@in.ibm.com, balbir@in.ibm.com
Subject: Re: [PATCH] Delay accounting, fix incorrect delay time when
	constantly waiting on runqueue
Message-ID: <20080616124222.GC7434@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1213609261-9554-1-git-send-email-bharathravi1@gmail.com> <1213610109.16944.95.camel@twins> <f8c1374c0806160500p722dee55vf6f2084ecadf670c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8c1374c0806160500p722dee55vf6f2084ecadf670c@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 16, 2008 at 05:30:26PM +0530, Madhava K R wrote:
> Hello,
> 
> On Mon, Jun 16, 2008 at 3:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2008-06-16 at 15:11 +0530, bharathravi1@gmail.com wrote:
> >> From: Bharath Ravi <bharathravi1@gmail.com>
> >>
> >> This patch corrects the incorrect value of per process run-queue wait time
> >> reported by delay statistics. The anomaly was due to the following reason.
> >> When a process leaves the CPU and immediately starts waiting for CPU on
> >> the runqueue (which means it remains in the TASK_RUNNABLE state), the time
> >> of re-entry into the run-queue is never recorded. Due to this, the waiting time
> >> on the runqueue from this point of re-entry upto the next time it hits the CPU
> >> is not accounted for. This is solved by recording the time of re-entry of a
> >> process leaving the CPU in the sched_info_depart() function IF the process will
> >> go back to waiting on the run-queue. This IF condition is verified by checking
> >> whether the process is still in the TASK_RUNNABLE state.
> >>
> >> The patch was tested on 2.6.26-rc6 using two simple CPU hog programs. The
> >> values noted prior to the fix did not account for the time spent on the
> >> runqueue waiting. After the fix, the correct values were reported back
> >> to user space.
> >
> >
> > Have you considered: http://lkml.org/lkml/2008/6/5/10
> >
> > I'm sad to say it is still pending in my todo list :-( - sorry Ankita.
> >
> 
> It seems that Ankita's patch addresses the scenario where a process is
> already on the run-queue, and is shuffled about CPUs. This patch
> addresses the scenario where a process is pre-empted and returns to
> the run-queue, where the last_queued value is not recorded.
>

Right, so looks like the two patches are addressing different scenarios. 
The patch I had sent earlier was addressing the case where the accounting 
of the task had already begun and then it was migrated to another
runqueue, leading to skews. This patch addresses the issue that the task
delay accounting could potentially miss some delay stats, as explained by 
Madhava.
 
> I tried our test case with Ankita's patch, and the problem remains.
> Our test case involves running two tight loops on an idle CPU.
> Ideally, both should experience a run time of 50% and a delay time of
> 50%. But the results show negligible delay time for both processes.
> 
> The problems appear mutually exclusive...
> 
> >> Signed-off-by: Bharath Ravi <bharathravi1@gmail.com>
> >> Signed-off-by: Madhava K R  <madhavakr@gmail.com>
> >> ---
> >>  kernel/sched_stats.h |    6 ++++++
> >>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> >> index a38878e..80179ef 100644
> >> --- a/kernel/sched_stats.h
> >> +++ b/kernel/sched_stats.h
> >> @@ -198,6 +198,9 @@ static inline void sched_info_queued(struct task_struct *t)
> >>  /*
> >>   * Called when a process ceases being the active-running process, either
> >>   * voluntarily or involuntarily.  Now we can calculate how long we ran.
> >> + * Also, if the process is still in the TASK_RUNNING state, call
> >> + * sched_info_queued() to mark that it has now again started waiting on
> >> + * the runqueue.
> >>   */
> >>  static inline void sched_info_depart(struct task_struct *t)
> >>  {
> >> @@ -206,6 +209,9 @@ static inline void sched_info_depart(struct task_struct *t)
> >>
> >>       t->sched_info.cpu_time += delta;
> >>       rq_sched_info_depart(task_rq(t), delta);
> >> +
> >> +     if (t->state == TASK_RUNNING)
> >> +             sched_info_queued(t);
> >>  }
> >>
> >>  /*
> >
> >

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
