Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYLPICp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYLPICp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYLPICh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:02:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57379 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYLPICg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:02:36 -0500
Message-ID: <49476049.7000403@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 16:01:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu> <4944754F.8050503@cn.fujitsu.com>
In-Reply-To: <4944754F.8050503@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> i merged it up in tip/master, could you please check whether it's ok?
>>
> 
> Sorry, though this patch avoids accessing a half-created cgroup, but I found
> current code may access a cgroup which has been destroyed.
> 
> The simplest fix is to take cgroup_lock() before for_each_leaf_cfs_rq.
> 
> Could you revert this patch and apply the following new one? My box has
> survived for 16 hours with it applied.
> 

Hi, Ingo

Can we have this bug fixed for 2.6.28 using this patch ? This patch is the
simplest fix and has been fully tested.

Since it's not a hot path, it's acceptable to hold cgroup_lock, and I've
checked the call chains to make sure it's deadlock free.

I'll remove this cgroup_lock for 2.6.29 in a way which is a bit tricky and
needs more testing.

This bug can trigger oops quite easily:

BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<c0457c66>] cgroup_path+0x34/0x8b
...
Call Trace:
 [<c041f12a>] ? print_cfs_rq+0x72/0x4f0
 [<c041ff09>] ? sched_debug_show+0x961/0xe52
 [<c04a6728>] ? seq_read+0x25/0x2a8
 [<c05f79bd>] ? mutex_lock_nested+0x20a/0x212
 [<c0447c60>] ? trace_hardirqs_on+0xb/0xd
 [<c04a6755>] ? seq_read+0x52/0x2a8
 [<c04a67f8>] ? seq_read+0xf5/0x2a8
 [<c04a6703>] ? seq_read+0x0/0x2a8
 [<c04bfcee>] ? proc_reg_read+0x60/0x74
 [<c04bfc8e>] ? proc_reg_read+0x0/0x74
 [<c04938fc>] ? vfs_read+0x8a/0x131
 [<c0493c5d>] ? sys_read+0x3b/0x60
 [<c04039a5>] ? sysenter_do_call+0x12/0x31
Code: ec 08 3d b4 d3 b5 c0 89 55 ec 75 0f 8b 45 ec ba 5e ec 6a c0 e8 dc 22 0a 00 eb 57 03 4d ec 89 c8 89 4d f0 48 c6 41 ff 00 8b 73 1c <8b> 56 38 29 d0 3b 45 ec 72 41 89 d1 8b 76 3c 89 c7 c1 e9 02 f3
EIP: [<c0457c66>] cgroup_path+0x34/0x8b SS:ESP 0068:e187fd84


> ==========
> 
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Sun, 14 Dec 2008 09:53:28 +0800
> Subject: [PATCH] sched: fix another race when reading /proc/sched_debug
> 
> I fixed an oops with the following commit:
> 
> | commit 24eb089950ce44603b30a3145a2c8520e2b55bb1
> | Author: Li Zefan <lizf@cn.fujitsu.com>
> | Date:   Thu Nov 6 12:53:32 2008 -0800
> |
> |    cgroups: fix invalid cgrp->dentry before cgroup has been completely removed
> |
> |    This fixes an oops when reading /proc/sched_debug.
> 
> The above commit fixed a race that reading /proc/sched_debug may access
> NULL cgrp->dentry if a cgroup is being removed (via cgroup_rmdir), but
> hasn't been destroyed (via cgroup_diput).
> 
> But I found there's another different race, in that reading sched_debug
> may access a cgroup which is being created or has been destroyed, and thus
> dereference NULL cgrp->dentry!
> 
> task_group is added to the global list while the cgroup is being created,
> and is removed from the global list while the cgroup is under destruction.
> So running through the list should be protected by cgroup_lock(), if
> cgroup data will be accessed (here by calling cgroup_path).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched_fair.c |    6 ++++++
>  kernel/sched_rt.c   |    6 ++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 98345e4..8b2965b 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1737,9 +1737,15 @@ static void print_cfs_stats(struct seq_file *m, int cpu)
>  {
>  	struct cfs_rq *cfs_rq;
>  
> +	/*
> +	 * Hold cgroup_lock() to avoid calling cgroup_path() with
> +	 * invalid cgroup.
> +	 */
> +	cgroup_lock();
>  	rcu_read_lock();
>  	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
>  		print_cfs_rq(m, cpu, cfs_rq);
>  	rcu_read_unlock();
> +	cgroup_unlock();
>  }
>  #endif
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index d9ba9d5..e84480d 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1538,9 +1538,15 @@ static void print_rt_stats(struct seq_file *m, int cpu)
>  {
>  	struct rt_rq *rt_rq;
>  
> +	/*
> +	 * Hold cgroup_lock() to avoid calling cgroup_path() with
> +	 * invalid cgroup.
> +	 */
> +	cgroup_lock();
>  	rcu_read_lock();
>  	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
>  		print_rt_rq(m, cpu, rt_rq);
>  	rcu_read_unlock();
> +	cgroup_unlock();
>  }
>  #endif /* CONFIG_SCHED_DEBUG */

