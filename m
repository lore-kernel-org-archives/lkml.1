Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbXAWL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbXAWL2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 06:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXAWL2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 06:28:18 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:22445 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932412AbXAWL2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 06:28:17 -0500
Subject: Re: [patch] notifiers: fix blocking_notifier_call_chain()
	scalability
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070123094550.GA21105@elte.hu>
References: <20070123094550.GA21105@elte.hu>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 12:24:54 +0100
Message-Id: <1169551494.6197.209.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 10:45 +0100, Ingo Molnar wrote:
> Subject: [patch] notifiers: fix blocking_notifier_call_chain() scalability
> From: Ingo Molnar <mingo@elte.hu>
> 
> while lock-profiling the -rt kernel i noticed weird contention during 
> mmap-intense workloads, and the tracer showed the following gem, in one 
> of our MM hotpaths:
> 
>  threaded-2771  1....   65us : sys_munmap (sysenter_do_call)
>  threaded-2771  1....   66us : profile_munmap (sys_munmap)
>  threaded-2771  1....   66us : blocking_notifier_call_chain (profile_munmap)
>  threaded-2771  1....   66us : rt_down_read (blocking_notifier_call_chain)
> 
> ouch! a global rw-semaphore taken in one of the most 
> performance-sensitive codepaths of the kernel. And i dont even have 
> oprofile enabled! All distro kernels have CONFIG_PROFILING enabled, so 
> this scalability problem affects the majority of Linux users.
> 
> The fix is to enhance blocking_notifier_call_chain() to only take the 
> lock if there appears to be work on the call-chain.
> 
> With this patch applied i get nicely saturated system, and much higher 
> munmap performance, on SMP systems.
> 
> And as a bonus this also fixes a similar scalability bottleneck in the 
> thread-exit codepath: profile_task_exit() ...
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/sys.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> Index: linux/kernel/sys.c
> ===================================================================
> --- linux.orig/kernel/sys.c
> +++ linux/kernel/sys.c
> @@ -325,11 +325,18 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
>  int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
>  		unsigned long val, void *v)
>  {
> -	int ret;
> +	int ret = NOTIFY_DONE;
>  
> -	down_read(&nh->rwsem);
> -	ret = notifier_call_chain(&nh->head, val, v);
> -	up_read(&nh->rwsem);
> +	/*
> +	 * We check the head outside the lock, but if this access is
> +	 * racy then it does not matter what the result of the test
> +	 * is, we re-check the list after having taken the lock anyway:
> +	 */
> +	if (rcu_dereference(nh->head)) {
> +		down_read(&nh->rwsem);
> +		ret = notifier_call_chain(&nh->head, val, v);
> +		up_read(&nh->rwsem);
> +	}
>  	return ret;
>  }


