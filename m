Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZERPYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZERPYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZERPYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:24:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZERPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:24:08 -0400
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20090518160904.7df88425@skybase>
References: <20090518160904.7df88425@skybase>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 18 May 2009 17:24:03 +0200
Message-Id: <1242660243.26820.439.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 16:09 +0200, Martin Schwidefsky wrote:
> Hi Linus,
> 
> please pull from 'cputime' branch of
> 
> 	git://git390.marist.edu/pub/scm/linux-2.6.git cputime
> 
> to receive the following updates:
> 
> Michael Abbott (1):
>       Fix idle time field in /proc/uptime
> 
>  fs/proc/uptime.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
> index 0c10a0b..c0ac0d7 100644
> --- a/fs/proc/uptime.c
> +++ b/fs/proc/uptime.c
> @@ -4,13 +4,19 @@
>  #include <linux/sched.h>
>  #include <linux/seq_file.h>
>  #include <linux/time.h>
> +#include <linux/kernel_stat.h>
>  #include <asm/cputime.h>
>  
>  static int uptime_proc_show(struct seq_file *m, void *v)
>  {
>  	struct timespec uptime;
>  	struct timespec idle;
> -	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
> +	int len, i;
> +	cputime_t idletime = 0;

cputime_zero, I guess..

> +	for_each_possible_cpu(i)
> +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
> +	idletime = cputime64_to_clock_t(idletime);
>  
>  	do_posix_clock_monotonic_gettime(&uptime);
>  	monotonic_to_bootbased(&uptime);

This is a world readable proc file, adding a for_each_possible_cpu() in
there scares me a little (this wouldn't be the first and only such case
though).

Suppose you have lots of cpus, and all those cpus are dirtying those
cachelines (who's updating idle time when they're idle?), then this loop
can cause a massive cacheline bounce fest.

Then think about userspace doing: 
  while :; do cat /proc/uptime > /dev/null; done


