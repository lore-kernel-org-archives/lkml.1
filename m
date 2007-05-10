Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbXEJXlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbXEJXlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760023AbXEJXlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:41:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928AbXEJXlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:41:03 -0400
Date: Thu, 10 May 2007 16:40:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomas Janousek <tjanouse@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: [PATCH] Use boot based time for process start time and boot
 time in /proc
Message-Id: <20070510164047.263a9524.akpm@linux-foundation.org>
In-Reply-To: <f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
	<f3c12bbf0772543db18c7a5251ce92f4f4f6758e.1178816485.git.tomi@nomi.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 19:10:42 +0200
Tomas Janousek <tjanouse@redhat.com> wrote:

> Commit 411187fb05cd11676b0979d9fbf3291db69dbce2 caused boot time to move and
> process start times to become invalid after suspend. Using boot based time for
> those restores the old behaviour and fixes the issue.
> 
> ..
>
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

Is the switch from --jif to ++jif a functional change?  If so, how come?

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

no, please prefer to do

	struct timespec start_time;
	struct timespec real_start_time;

which gives a nice place to add a comment documenting the field.

Please document fields.

What is the difference between start_time and real_start_time?


