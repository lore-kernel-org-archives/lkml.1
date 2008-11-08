Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYKHG54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYKHG54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 01:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYKHG5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 01:57:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52284 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYKHG5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 01:57:47 -0500
Message-ID: <491537C6.3050800@cn.fujitsu.com>
Date: Sat, 08 Nov 2008 14:55:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] sched: fix a bug in sched domain degenerate
References: <49124C2C.9080300@cn.fujitsu.com>
In-Reply-To: <49124C2C.9080300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I just read the modified changelog in the git-log, and it is
wrong (or maybe my fix is wrong?), I should have explained
the bug clearer. :(

I'm writing this mail to confirm if my thought and fix is
right or not.

> commit f29c9b1ccb52904ee442a933cf3dee628f9f4e62
> Author: Li Zefan <lizf@cn.fujitsu.com>
> Date:   Thu Nov 6 09:45:16 2008 +0800
> 
>     sched: fix a bug in sched domain degenerate
>     
>     Impact: re-add incorrectly eliminated sched domain layers
>     

This statement is wrong..

>     (1) on i386 with SCHED_SMT and SCHED_MC enabled
>     	# mount -t cgroup -o cpuset xxx /mnt
>     	# echo 0 > /mnt/cpuset.sched_load_balance
>     	# mkdir /mnt/0
>     	# echo 0 > /mnt/0/cpuset.cpus
>     	# dmesg
>     	CPU0 attaching sched-domain:
>     	 domain 0: span 0 level CPU
>     	  groups: 0
>     

I think this behavior is wrong.

>     (2) on i386 with SCHED_MC enabled but SCHED_SMT disabled
>     	# same with (1)
>     	# dmesg
>     	CPU0 attaching NULL sched-domain.
>     

And this is right. CPU domain has only 1 cpu so it does not contribute
to scheduling, so it can be removed.

>     The bug is that some sched domains may be skipped unintentionally when
>     degenerating (optimizing) sched domains.
>     

The bug is, some sched domains won't be checked in the for loop due
to the bug, so they have no chance to be removed.

In the for loop, we check if the parents domains can be removed:

cur_ptr
 |
 v
SMT--->MC--->CPU--->NULL

(parent MC is checked and can be removed)

=>

       cur_ptr
        |
        v
SMT--->CPU--->NULL

(break out of the for loop, because cur_ptr->parent == NULL)

so CPU domain won't be checked. When we delete MC domain, the pointer
should not move forwards, so the fix is:

cur_ptr
 |
 v
SMT--->CPU--->NULL

>     Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 82cc839..4c7e2bc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6877,15 +6877,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>  	struct sched_domain *tmp;
>  
>  	/* Remove the sched domains which do not contribute to scheduling. */
> -	for (tmp = sd; tmp; tmp = tmp->parent) {
> +	for (tmp = sd; tmp; ) {
>  		struct sched_domain *parent = tmp->parent;
>  		if (!parent)
>  			break;
> +
>  		if (sd_parent_degenerate(tmp, parent)) {
>  			tmp->parent = parent->parent;
>  			if (parent->parent)
>  				parent->parent->child = tmp;
> -		}
> +		} else
> +			tmp = tmp->parent;
>  	}
>  
>  	if (sd && sd_degenerate(sd)) {


