Return-Path: <linux-kernel-owner+w=401wt.eu-S2992783AbXDDJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992783AbXDDJex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992786AbXDDJex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:34:53 -0400
Received: from mail.screens.ru ([213.234.233.54]:47007 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992783AbXDDJew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:34:52 -0400
Date: Wed, 4 Apr 2007 12:39:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: getting processor numbers
Message-ID: <20070404083927.GA100@tv-sign.ru>
References: <461286D6.2040407@redhat.com> <20070403131623.c6831607.akpm@linux-foundation.org> <4612BB89.8040102@redhat.com> <20070403141348.9bcdb13e.akpm@linux-foundation.org> <4612D175.30604@redhat.com> <20070403154831.37bde672.akpm@linux-foundation.org> <4612DCA2.2090400@redhat.com> <20070403162349.583adf84.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403162349.583adf84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Andrew Morton wrote:
>
> On Tue, 03 Apr 2007 16:00:50 -0700
> Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > If there is possibility to treat this case special and make it faster,
> > please do so.  It would be best to allow pid==0 as a special case so
> > that callers don't have to find out the TID (which they shouldn't have
> > to know).
> > 
> 
> OK.
> 
> Does anyone see a reason why we cannot do this?
> 
> --- a/kernel/sched.c~sched_getaffinity-speedup
> +++ a/kernel/sched.c
> @@ -4381,8 +4381,12 @@ long sched_getaffinity(pid_t pid, cpumas
>  	struct task_struct *p;
>  	int retval;
>  
> -	lock_cpu_hotplug();
> -	read_lock(&tasklist_lock);
> +	if (pid) {
> +		lock_cpu_hotplug();
> +		read_lock(&tasklist_lock);
> +	} else {
> +		preempt_disable();	/* Prevent CPU hotplugging */
> +	}

But we don't need tasklist_lock at all, we can use rcu_read_lock/unlock.

Q: don't we need task_rq_lock() to read ->cpus_allowed "atomically" ?

UNTESTED.

--- OLD/kernel/sched.c~	2007-04-03 13:05:02.000000000 +0400
+++ OLD/kernel/sched.c	2007-04-04 12:29:04.000000000 +0400
@@ -4433,22 +4433,17 @@ long sched_setaffinity(pid_t pid, cpumas
 	int retval;
 
 	mutex_lock(&sched_hotcpu_mutex);
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
 	if (!p) {
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		mutex_unlock(&sched_hotcpu_mutex);
 		return -ESRCH;
 	}
 
-	/*
-	 * It is not safe to call set_cpus_allowed with the
-	 * tasklist_lock held.  We will bump the task_struct's
-	 * usage count and then drop tasklist_lock.
-	 */
 	get_task_struct(p);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	retval = -EPERM;
 	if ((current->euid != p->euid) && (current->euid != p->uid) &&
@@ -4523,7 +4518,7 @@ long sched_getaffinity(pid_t pid, cpumas
 	int retval;
 
 	mutex_lock(&sched_hotcpu_mutex);
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -4537,7 +4532,7 @@ long sched_getaffinity(pid_t pid, cpumas
 	cpus_and(*mask, p->cpus_allowed, cpu_online_map);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	mutex_unlock(&sched_hotcpu_mutex);
 	if (retval)
 		return retval;

