Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZKMLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZKMLoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZKMLoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:44:16 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44702 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZKMLoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:44:15 -0500
Message-ID: <4AFD468B.5030602@in.ibm.com>
Date: Fri, 13 Nov 2009 17:14:11 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ego@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
References: <20091112195101.63263490.sfr@canb.auug.org.au> <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop> <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop> <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com> <1258107368.4039.1149.camel@laptop> <1258108281.22655.5.camel@laptop>
In-Reply-To: <1258108281.22655.5.camel@laptop>
Content-Type: multipart/mixed;
 boundary="------------050103040503050009000101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050103040503050009000101
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Peter Zijlstra wrote:
> Well, it boots for me, but then, I've not been able to reproduce any
> issues anyway :/
>
> /me goes try a PREEMPT=n kernel, since that is what Mike reports boot
> funnies with..
>   
With the suggested changes against -next the machine boots fine.
After multiple runs of hackbenck,kernbench,cpu_hotplug tests the
machine is still up and running. So at this point all is well.
I will continue to monitor the box for a while..

I just picked up the changes made to kernel/sched.c. Have attached
the changes here.

Thanks for all your help.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------050103040503050009000101
Content-Type: text/x-patch;
 name="sched-next.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched-next.patch"

diff -Naurp a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c	2009-11-13 16:53:19.000000000 +0530
+++ b/kernel/sched.c	2009-11-13 16:50:47.000000000 +0530
@@ -2372,13 +2372,22 @@ static int try_to_wake_up(struct task_st
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 
+again:
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (!cpu_online(cpu))
+		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	if (cpu >= nr_cpu_ids) {
+		printk(KERN_ERR "Breaking affinity on %d/%s\n", p->pid, p->comm);
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		goto again;
+	}
+	
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 
 	if (rq != orig_rq)
 		update_rq_clock(rq);

--------------050103040503050009000101--
