Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbXFURwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbXFURwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXFURv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:51:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58693 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755030AbXFURv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:51:56 -0400
Date: Thu, 21 Jun 2007 10:51:52 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@linux.vnet.ibm.com
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-Id: <20070621105152.8daf87ad.pj@sgi.com>
In-Reply-To: <20070621173232.GP10980@linux.vnet.ibm.com>
References: <20070621014935.GF10980@linux.vnet.ibm.com>
	<20070621121635.GB19811@elte.hu>
	<20070621100712.52a4784a.pj@sgi.com>
	<20070621173232.GP10980@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah .."allow movement if it doesn't result in changing kernel-threads's cpu 
> affinity" sounds good, except it is hard to implement in cpuset's
> context I think. For ex: we now have to take additional steps when
> changing 'cpus_allowed' of a cpuset such that it doesn't violate any cpu
> affinity of kernel threads bound to the cpuset. That itself makes the
> implementation complex I think.

Yes, that would be more complex than we need.  You're right.

The only problem comes with kernel tasks that are pinned to less than
the entire system, and that are in the top cpuset.

They should remain in the top cpuset.  Since the top cpuset is never
allowed to have less than all the cpus in the system, such kernel
threads can then be assured of being allowed to use the cpus they need
to use.

Could you try coding something like the following in kernel/cpuset.c,
Srivatsa?

/* Call with task_lock held on tsk */
is_pinned_kernel_thread(tsk)
{
	/* "pinned" means constrained to a strict subset of online cpus */
	int is_pinned = !cpus_subset(cpus_online_map, tsk->cpus_allowed);
	int is_kthread = !tsk->mm || (tsk->flags & PF_BORROWED_MM);

	return is_pinned && is_kthread;
}

Then call it from kernel/cpuset.c:attach_task() with:

	/* Don't moved pinned kernel threads out of top cpuset */
	if (is_pinned_kernel_thread(tsk) && oldcs == &top_cpuset && cs != oldcs) {
                task_unlock(tsk);
                mutex_unlock(&callback_mutex);
                put_task_struct(tsk);
		return -EINVAL;
	}

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
