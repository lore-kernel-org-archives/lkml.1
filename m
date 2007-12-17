Return-Path: <linux-kernel-owner+w=401wt.eu-S936302AbXLQXAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936302AbXLQXAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbXLQXAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:00:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760630AbXLQXAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:00:37 -0500
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
From: Jon Masters <jcm@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20071217234314.540b59bd@hammerfall>
References: <20071217234314.540b59bd@hammerfall>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Mon, 17 Dec 2007 18:00:26 -0500
Message-Id: <1197932426.18713.129.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 23:43 +0100, Michal Schmidt wrote:

> kthreadd, the creator of other kernel threads, runs as a normal
> priority task. This is a potential for priority inversion when a task
> wants to spawn a high-priority kernel thread. A middle priority
> SCHED_FIFO task can block kthreadd's execution indefinitely and thus
> prevent the timely creation of the high-priority kernel thread.
>     
> This causes a practical problem. When a runaway real-time task is
> eating 100% CPU and we attempt to put the CPU offline, sometimes we
> block while waiting for the creation of the highest-priority
> "kstopmachine" thread. 
> 
> The fix is to run kthreadd with the highest possible SCHED_FIFO
> priority. Its children must still run as slightly negatively reniced
> SCHED_NORMAL tasks.
>     
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index dcfe724..a7ce932 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -94,10 +94,17 @@ static void create_kthread(struct kthread_create_info *create)
>  	if (pid < 0) {
>  		create->result = ERR_PTR(pid);
>  	} else {
> +		struct sched_param param = { .sched_priority = 0 };
>  		wait_for_completion(&create->started);
>  		read_lock(&tasklist_lock);
>  		create->result = find_task_by_pid(pid);
>  		read_unlock(&tasklist_lock);
> +		/*
> +		 * We (kthreadd) run with SCHED_FIFO, but we don't want
> +		 * the kthreads we create to have it too by default.
> +		 */
> +		sched_setscheduler(create->result, SCHED_NORMAL, &param);
> +		set_user_nice(create->result, -5);
>  	}
>  	complete(&create->done);
>  }
> @@ -217,11 +224,12 @@ EXPORT_SYMBOL(kthread_stop);
>  int kthreadd(void *unused)
>  {
>  	struct task_struct *tsk = current;
> +	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
>  
>  	/* Setup a clean context for our children to inherit. */
>  	set_task_comm(tsk, "kthreadd");
>  	ignore_signals(tsk);
> -	set_user_nice(tsk, -5);
> +	sched_setscheduler(tsk, SCHED_FIFO, &param);
>  	set_cpus_allowed(tsk, CPU_MASK_ALL);
>  
>  	current->flags |= PF_NOFREEZE;

I looked at this internally over the weekend.

Acked-by: Jon Masters <jcm@redhat.com>


