Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZKIMpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZKIMpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZKIMpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:45:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZKIMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:45:22 -0500
Subject: Re: Kernel oops in resched_task() with 2.6.31.5
From: Peter Zijlstra <peterz@infradead.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4AF80B8B.8080203@jp.fujitsu.com>
References: <4AF80B8B.8080203@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 13:45:20 +0100
Message-ID: <1257770720.4108.195.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 21:31 +0900, Kenji Kaneshige wrote:
> Hi,
> 
> I frequently encounter the kernel oops attached below in resched_task()
> with 2.6.31.5. This kernel oops happens also with 2.6.32-rc5. I don't
> know about other kernel.
> 
> Here is my analysis:
> 
> The immediate cause of this kernel oops is that NULL was passed to
> resched_task() from resched_cpu(). From my investigation, this was
> caused as follows:
> 
> - trigger_load_balance() caluculated cpu number of idle load balancer
>   using find_new_ilb(), and find_new_ilb() returned *offline* CPU
>   number (16 in my case). Note that I didn't do any CPU hotplug
>   operation. On my system, present, online and offline under
>   /sys/devices/system/cpu/ are
> 
>     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/present
>     0-15
>     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/online
>     0-15
>     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/offline
>     16-255
> 
>   And nr_cpu_ids is 256.
> 
> - resched_cpu() calculated current task by cpu_curr() with offline CPU
>   number.
> 
> So this kernel oops seems to be caused by invalid CPU number returned
> from find_new_ilb(). I don't know the find_new_ilb() implementation,
> but I suspect the initialization of cpumasks used by find_new_ilb().
> The patch attached below seems to fix the problem (With this patch,
> the kernel oops doesn't happen). But I don't know if this is the
> correct fix.

Please send patches against -tip.

You might find that Rusty has already fixed a similar issue there in
commit: 49557e620339cb134127b5bfbcfecc06b77d0232.

Now, Rusty's patch does not clear the ilb mask, so maybe it doesn't
fully cover your issue, please test.

> ---
>  kernel/sched.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.31.5/kernel/sched.c
> ===================================================================
> --- linux-2.6.31.5.orig/kernel/sched.c	2009-11-09 17:03:33.818457759 +0900
> +++ linux-2.6.31.5/kernel/sched.c	2009-11-09 18:02:39.619934041 +0900
> @@ -9386,8 +9386,8 @@
>  	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
>  #ifdef CONFIG_SMP
>  #ifdef CONFIG_NO_HZ
> -	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
> -	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
> +	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
> +	zalloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
>  #endif
>  	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
>  #endif /* SMP */
> 
> 


