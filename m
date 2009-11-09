Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZKIMua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZKIMua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZKIMu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:50:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:34430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755733AbZKIMu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:50:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX193RjJcuPJ3LvDMxanrDrHKbIuBh0soHHm8YBbLR+
	hIAQyLoi61nqtr
Subject: Re: Kernel oops in resched_task() with 2.6.31.5
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1257770720.4108.195.camel@laptop>
References: <4AF80B8B.8080203@jp.fujitsu.com>
	 <1257770720.4108.195.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 13:50:28 +0100
Message-Id: <1257771028.6834.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 13:45 +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-09 at 21:31 +0900, Kenji Kaneshige wrote:
> > Hi,
> > 
> > I frequently encounter the kernel oops attached below in resched_task()
> > with 2.6.31.5. This kernel oops happens also with 2.6.32-rc5. I don't
> > know about other kernel.
> > 
> > Here is my analysis:
> > 
> > The immediate cause of this kernel oops is that NULL was passed to
> > resched_task() from resched_cpu(). From my investigation, this was
> > caused as follows:
> > 
> > - trigger_load_balance() caluculated cpu number of idle load balancer
> >   using find_new_ilb(), and find_new_ilb() returned *offline* CPU
> >   number (16 in my case). Note that I didn't do any CPU hotplug
> >   operation. On my system, present, online and offline under
> >   /sys/devices/system/cpu/ are
> > 
> >     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/present
> >     0-15
> >     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/online
> >     0-15
> >     [kanesige@localhost ~]$ cat /sys/devices/system/cpu/offline
> >     16-255
> > 
> >   And nr_cpu_ids is 256.
> > 
> > - resched_cpu() calculated current task by cpu_curr() with offline CPU
> >   number.
> > 
> > So this kernel oops seems to be caused by invalid CPU number returned
> > from find_new_ilb(). I don't know the find_new_ilb() implementation,
> > but I suspect the initialization of cpumasks used by find_new_ilb().
> > The patch attached below seems to fix the problem (With this patch,
> > the kernel oops doesn't happen). But I don't know if this is the
> > correct fix.
> 
> Please send patches against -tip.
> 
> You might find that Rusty has already fixed a similar issue there in
> commit: 49557e620339cb134127b5bfbcfecc06b77d0232.
> 
> Now, Rusty's patch does not clear the ilb mask, so maybe it doesn't
> fully cover your issue, please test.

Doesn't 31 need this too?  (for me it did)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..6e71932 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4032,7 +4049,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4195,7 +4212,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle


