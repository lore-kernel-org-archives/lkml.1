Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXEJSoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXEJSoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXEJSog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:44:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42486 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbXEJSof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:44:35 -0400
Subject: Re: [PATCH] Use boot based time for process start time and boot
	time in /proc
From: john stultz <johnstul@us.ibm.com>
To: Tomas Janousek <tjanouse@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
In-Reply-To: <f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
	 <f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz>
Content-Type: text/plain
Date: Thu, 10 May 2007 11:44:31 -0700
Message-Id: <1178822672.6011.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 19:10 +0200, Tomas Janousek wrote:
> Commit 411187fb05cd11676b0979d9fbf3291db69dbce2 caused boot time to move and
> process start times to become invalid after suspend. Using boot based time for
> those restores the old behaviour and fixes the issue.
> 
> Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
> Cc: Tomas Smetana <tsmetana@redhat.com>
> Cc: John Stultz <johnstul@us.ibm.com>

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  fs/proc/array.c       |    5 +++--
>  fs/proc/proc_misc.c   |    8 +++++---
>  include/linux/sched.h |    2 +-
>  kernel/fork.c         |    2 ++
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 74f30e0..e798e11 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -405,8 +405,9 @@ static int do_task_stat(struct task_struct *task, char * buffer, int whole)
> 
>  	/* Temporary variable needed for gcc-2.96 */
>  	/* convert timespec -> nsec*/
> -	start_time = (unsigned long long)task->start_time.tv_sec * NSEC_PER_SEC
> -				+ task->start_time.tv_nsec;
> +	start_time =
> +		(unsigned long long)task->real_start_time.tv_sec * NSEC_PER_SEC
> +				+ task->real_start_time.tv_nsec;
>  	/* convert nsec -> ticks */
>  	start_time = nsec_to_clock_t(start_time);
> 
> diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
> index 4636be7..0782d34 100644
> --- a/fs/proc/proc_misc.c
> +++ b/fs/proc/proc_misc.c
> @@ -445,12 +445,14 @@ static int show_stat(struct seq_file *p, void *v)
>  	unsigned long jif;
>  	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
>  	u64 sum = 0;
> +	struct timespec boottime;
> 
>  	user = nice = system = idle = iowait =
>  		irq = softirq = steal = cputime64_zero;
> -	jif = - wall_to_monotonic.tv_sec;
> -	if (wall_to_monotonic.tv_nsec)
> -		--jif;
> +	getboottime(&boottime);
> +	jif = boottime.tv_sec;
> +	if (boottime.tv_nsec)
> +		++jif;
> 
>  	for_each_possible_cpu(i) {
>  		int j;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 40645b4..386ff51 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -918,7 +918,7 @@ struct task_struct {
>  	unsigned int rt_priority;
>  	cputime_t utime, stime;
>  	unsigned long nvcsw, nivcsw; /* context switch counts */
> -	struct timespec start_time;
> +	struct timespec start_time, real_start_time;
>  /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
>  	unsigned long min_flt, maj_flt;
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4239de2..3aa82bc 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1059,6 +1059,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> 
>  	p->lock_depth = -1;		/* -1 = no lock */
>  	do_posix_clock_monotonic_gettime(&p->start_time);
> +	p->real_start_time = p->start_time;
> +	monotonic_to_bootbased(&p->real_start_time);
>  	p->security = NULL;
>  	p->io_context = NULL;
>  	p->io_wait = NULL;
> -- 
> 1.5.1.4
> 
> 

