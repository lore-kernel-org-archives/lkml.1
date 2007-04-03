Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbXDCXYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbXDCXYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbXDCXYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:24:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48119 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbXDCXYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:24:36 -0400
Date: Tue, 3 Apr 2007 16:23:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: getting processor numbers
Message-Id: <20070403162349.583adf84.akpm@linux-foundation.org>
In-Reply-To: <4612DCA2.2090400@redhat.com>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<4612BB89.8040102@redhat.com>
	<20070403141348.9bcdb13e.akpm@linux-foundation.org>
	<4612D175.30604@redhat.com>
	<20070403154831.37bde672.akpm@linux-foundation.org>
	<4612DCA2.2090400@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 16:00:50 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> Andrew Morton wrote:
> > Now it could be argued that the current behaviour is that sane thing: we
> > allow the process to "pin" itself to not-present CPUs and just handle it in
> > the CPU scheduler.
> 
> As a stop-gap solution Jakub will likely implement the sched_getaffinity
> hack.  So, it would realy be best to get the masks updated.
> 
> 
> But all this of course does not solve the issue sysconf() has.  In
> sysconf we cannot use sched_getaffinity since all the systems CPUs must
> be reported.

OK.

This is excecptionally gruesome, but one could run sched_getaffinity()
against pid 1 (init).  Which will break nicely in the OS-virtualised future
when the system has multiple pid-1-inits running in containers...

> 
> > Is it kernel overhead, or userspace?  The overhead of counting the bits?
> 
> The overhead I meant is userland.
> 

OK.  Your cost of counting those bits is proportional to CONFIG_NR_CPUS.

It's a bit sad that sys_sched_get_get_affinity() returns sizeof(cpumask_t),
because that means that userspace must handle 256 or whatever CPUs on a
machine which only has two CPUs.

Does anyone see a reason why sys_sched_getaffinity() cannot be altered to
return maximum-possible-cpu-id-on-this-machine?  That way, your hweight
operation will be much faster on sane-sized machines.

> 
> > Because sched_getaffinity() could be easily sped up in the case where
> > it is operating on the current process.
> 
> If there is possibility to treat this case special and make it faster,
> please do so.  It would be best to allow pid==0 as a special case so
> that callers don't have to find out the TID (which they shouldn't have
> to know).
> 

OK.

Does anyone see a reason why we cannot do this?

--- a/kernel/sched.c~sched_getaffinity-speedup
+++ a/kernel/sched.c
@@ -4381,8 +4381,12 @@ long sched_getaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	lock_cpu_hotplug();
-	read_lock(&tasklist_lock);
+	if (pid) {
+		lock_cpu_hotplug();
+		read_lock(&tasklist_lock);
+	} else {
+		preempt_disable();	/* Prevent CPU hotplugging */
+	}
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -4396,12 +4400,13 @@ long sched_getaffinity(pid_t pid, cpumas
 	cpus_and(*mask, p->cpus_allowed, cpu_online_map);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
-	unlock_cpu_hotplug();
-	if (retval)
-		return retval;
-
-	return 0;
+	if (pid) {
+		read_unlock(&tasklist_lock);
+		unlock_cpu_hotplug();
+	} else {
+		preempt_enable();
+	}
+	return retval;
 }
 
 /**
_

> 
> > Anyway, where do we stand?  Assuming we can address the CPU hotplug issues,
> > does sched_getaffinity() look like it will be suitable?
> 
> It's only usable for the special case on the OpenMP code where the
> number of threads is used to determine the number of worker threads.
> For sysconf() we still need better support.  Maybe now somebody will
> step up and say they need faster sysconf as well.

I guess we could add a simple sys_get_nr_cpus().  If we want more than that
(ie: topology, SMT/MC/NUMA/numa-distance etc) then it gets much more complex
and sysfs is more appropriate for that.

