Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYDXLzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYDXLzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYDXLzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:55:45 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:16152 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYDXLzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:55:43 -0400
Message-Id: <48103D18.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 24 Apr 2008 05:56:08 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Gregory Haskins" <GHaskins@novell.com>
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: fix RT task-wakeup logic
References: <20080423111313.4981.37345.stgit@novell1.haskins.net>
 <20080423111329.4981.88455.stgit@novell1.haskins.net>
In-Reply-To: <20080423111329.4981.88455.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Apr 23, 2008 at  7:13 AM, in message
<20080423111329.4981.88455.stgit@novell1.haskins.net>, Gregory Haskins
<ghaskins@novell.com> wrote: 
> Dmitry Adamushko pointed out a logic error in task_wake_up_rt() where we
> will always evaluate to "true".  You can find the thread here:
> 
> http://lkml.org/lkml/2008/4/22/296
> 
> In reality, we only want to try to push tasks away when a wake up request is
> not going to preempt the current task.  So lets fix it.
> 
> Note: We introduce test_tsk_need_resched() instead of open-coding the flag
> check so that the merge-conflict with -rt should help remind us that we
> may need to support NEEDS_RESCHED_DELAYED in the future, too.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Steven Rostedt <rostedt@goodmis.org>


Hi Ingo,
  So based on the discussion and the sign-off on this patch from Dmitry and Steven, I would propose to move patch #1 from "RFC" to "Consider for inclusion" status.  Patch #2 should remain RFC pending further discussion.  I would recommend #1 to be considered for both 25.y stable as well as going into the 26 merge window  (pending positive testing results, and your discretion).

Regards,
-Greg


> ---
> 
>  include/linux/sched.h |    7 ++++++-
>  kernel/sched_rt.c     |    7 +++++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 949bd54..55d4bd4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1966,6 +1966,11 @@ static inline void clear_tsk_need_resched(struct 
> task_struct *tsk)
>  	clear_tsk_thread_flag(tsk,TIF_NEED_RESCHED);
>  }
>  
> +static inline int test_tsk_need_resched(struct task_struct *tsk)
> +{
> +	return unlikely(test_tsk_thread_flag(tsk,TIF_NEED_RESCHED));
> +}
> +
>  static inline int signal_pending(struct task_struct *p)
>  {
>  	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
> @@ -1980,7 +1985,7 @@ static inline int fatal_signal_pending(struct 
> task_struct *p)
>  
>  static inline int need_resched(void)
>  {
> -	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
> +	return unlikely(test_tsk_need_resched(current));
>  }
>  
>  /*
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 79e5ad5..ae6b0e6 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1058,11 +1058,14 @@ static void post_schedule_rt(struct rq *rq)
>  	}
>  }
>  
> -
> +/*
> + * If we are not running and we are not going to reschedule soon, we should
> + * try to push tasks away now
> + */
>  static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
>  {
>  	if (!task_running(rq, p) &&
> -	    (p->prio >= rq->rt.highest_prio) &&
> +	    !test_tsk_need_resched(rq->curr) &&
>  	    rq->rt.overloaded)
>  		push_rt_tasks(rq);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


