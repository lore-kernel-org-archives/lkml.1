Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbZDIBBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbZDIBBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZDIBBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 21:01:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbZDIBBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 21:01:24 -0400
Date: Wed, 8 Apr 2009 17:57:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH/RFC] do not count frozen tasks toward load
Message-Id: <20090408175702.8a99c803.akpm@linux-foundation.org>
In-Reply-To: <20090408194512.47a99b95@manatee.lan>
References: <20090408194512.47a99b95@manatee.lan>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 19:45:12 -0500 Nathan Lynch <ntl@pobox.com> wrote:

> Freezing tasks via the cgroup freezer causes the load average to climb
> because the freezer's current implementation puts frozen tasks in
> uninterruptible sleep (D state).
> 
> Some applications which perform job-scheduling functions consult the
> load average when making decisions.  If a cgroup is frozen, the load
> average does not provide a useful measure of the system's utilization
> to such applications.  This is especially inconvenient if the job
> scheduler employs the cgroup freezer as a mechanism for preempting low
> priority jobs.  Contrast this with using SIGSTOP for the same purpose:
> the stopped tasks do not count toward system load.
> 
> Change task_contributes_to_load() to return false if the task is
> frozen.  This results in /proc/loadavg behavior that better meets
> users' expectations.
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> ---
>  include/linux/sched.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 011db2f..f8af167 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -202,7 +202,8 @@ extern unsigned long long time_sync_thresh;
>  #define task_is_stopped_or_traced(task)	\
>  			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
>  #define task_contributes_to_load(task)	\
> -				((task->state & TASK_UNINTERRUPTIBLE) != 0)
> +				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
> +				 (task->flags & PF_FROZEN) == 0)
>  
>  #define __set_task_state(tsk, state_value)		\
>  	do { (tsk)->state = (state_value); } while (0)

Looks OK to me.  It should perhaps use !frozen(task), but the includes
are mucked up.

I suppose we should fix this in -stable too.
