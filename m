Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZDIBWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZDIBWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZDIBV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 21:21:56 -0400
Received: from mail.crca.org.au ([67.207.131.56]:46007 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbZDIBV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 21:21:56 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH/RFC] do not count frozen tasks toward load
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>
In-Reply-To: <20090408194512.47a99b95@manatee.lan>
References: <20090408194512.47a99b95@manatee.lan>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 11:21:43 +1000
Message-Id: <1239240103.9869.1.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On Wed, 2009-04-08 at 19:45 -0500, Nathan Lynch wrote:
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

Tested-by: Nigel Cunningham <nigel@tuxonice.net>

Looks good to me (though I like Andrew's point about using task_frozen).

nigel@nigel-laptop:~$ cat /proc/loadavg 
0.34 0.27 0.12 1/251 9001
nigel@nigel-laptop:~$ sudo hibernate
nigel@nigel-laptop:~$ cat /proc/loadavg 
0.52 0.33 0.14 2/250 9807
nigel@nigel-laptop:~$ 


