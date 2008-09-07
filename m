Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYIGK2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYIGK2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 06:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYIGK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 06:28:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:46576 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYIGK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 06:28:36 -0400
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in
 kernel/sched.c
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080906235037.880702000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	 <20080906235037.880702000@polaris-admin.engr.sgi.com>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 12:24:47 +0200
Message-Id: <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 16:50 -0700, Mike Travis wrote:
> plain text document attachment (stack-hogs-kernel_sched_c)
> * Make the following changes to kernel/sched.c functions:
> 
>     - use node_to_cpumask_ptr in place of node_to_cpumask
>     - use get_cpumask_var for temporary cpumask_t variables
>     - use alloc_cpumask_ptr where available
> 
>   * Remove special code for SCHED_CPUMASK_ALLOC and use CPUMASK_ALLOC
>     from linux/cpumask.h.
> 
>   * The resultant stack savings are:
> 
>     ====== Stack (-l 100)
> 
> 	1 - initial
> 	2 - stack-hogs-kernel_sched_c
> 	'.' is less than the limit(100)
> 
>        .1.    .2.    ..final..
>       2216  -1536 680   -69%  __build_sched_domains
>       1592  -1592   .  -100%  move_task_off_dead_cpu
>       1096  -1096   .  -100%  sched_balance_self
>       1032  -1032   .  -100%  sched_setaffinity
>        616   -616   .  -100%  rebalance_domains
>        552   -552   .  -100%  free_sched_groups
>        512   -512   .  -100%  cpu_to_allnodes_group
>       7616  -6936 680   -91%  Totals
> 
> 
> Applies to linux-2.6.tip/master.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/sched.c |  151 ++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 81 insertions(+), 70 deletions(-)
> 
> --- linux-2.6.tip.orig/kernel/sched.c
> +++ linux-2.6.tip/kernel/sched.c
> @@ -70,6 +70,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> +#include <linux/cpumask_ptr.h>
>  #include <linux/ftrace.h>
>  #include <trace/sched.h>
>  
> @@ -117,6 +118,12 @@
>   */
>  #define RUNTIME_INF	((u64)~0ULL)
>  
> +/*
> + * temp cpumask variables
> + */
> +static DEFINE_PER_CPUMASK(temp_cpumask_1);
> +static DEFINE_PER_CPUMASK(temp_cpumask_2);

Yuck, that relies on turning preemption off everywhere you want to use
those.


> @@ -5384,11 +5400,14 @@ out_unlock:
>  
>  long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
>  {
> -	cpumask_t cpus_allowed;
> -	cpumask_t new_mask = *in_mask;
> +	cpumask_ptr cpus_allowed;
> +	cpumask_ptr new_mask;
>  	struct task_struct *p;
>  	int retval;
>  
> +	get_cpumask_var(cpus_allowed, temp_cpumask_1);
> +	get_cpumask_var(new_mask, temp_cpumask_2);
> +	*new_mask = *in_mask;
>  	get_online_cpus();
>  	read_lock(&tasklist_lock);

BUG!

get_online_cpus() can sleep, but you just disabled preemption with those
get_cpumask_var() horribles!

Couldn't be arsed to look through the rest, but I really hate this
cpumask_ptr() stuff that relies on disabling preemption.

NAK

