Return-Path: <linux-kernel-owner+w=401wt.eu-S934761AbXHZAQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761AbXHZAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 20:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXHZAQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 20:16:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35437 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765090AbXHZAQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 20:16:48 -0400
Date: Sun, 26 Aug 2007 05:46:25 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cliff Wickman <cpw@sgi.com>,
       mingo@elte.hu, vatsa@in.ibm.com, pj@sgi.com,
       linux-kernel@vger.kernel.org, ntl@in.ibm.com,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070826001625.GA17962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070824221806.GA3602@sgi.com> <20070824155455.cc161b61.akpm@linux-foundation.org> <20070825094740.GA106@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825094740.GA106@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 01:47:40PM +0400, Oleg Nesterov wrote:
> On 08/24, Andrew Morton wrote:
> >
> > On Fri, 24 Aug 2007 17:18:06 -0500
> > Cliff Wickman <cpw@sgi.com> wrote:
> > 
> > > When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
> > > that have been running on that cpu.
> > > 
> > > Currently, such a task is migrated:
> > >  1) to any cpu on the same node as the disabled cpu, which is both online
> > >     and among that task's cpus_allowed
> > >  2) to any cpu which is both online and among that task's cpus_allowed
> > > 
> > > It is typical of a multithreaded application running on a large NUMA system
> > > to have its tasks confined to a cpuset so as to cluster them near the
> > > memory that they share. Furthermore, it is typical to explicitly place such
> > > a task on a specific cpu in that cpuset.  And in that case the task's
> > > cpus_allowed includes only a single cpu.
> > 
> > operator error..
> > 
> > > This patch would insert a preference to migrate such a task to some cpu within
> > > its cpuset (and set its cpus_allowed to its entire cpuset).
> > > 
> > > With this patch, migrate the task to:
> > >  1) to any cpu on the same node as the disabled cpu, which is both online
> > >     and among that task's cpus_allowed
> > >  2) to any online cpu within the task's cpuset
> > >  3) to any cpu which is both online and among that task's cpus_allowed
> > 
> > Wouldn't it be saner to refuse the offlining request if the CPU has tasks
> > which cannot be migrated to any other CPU?  I mean, the operator has gone
> > and asked the machine to perform two inconsistent/incompatible things at
> > the same time.
> 
> I don't think so (regardless of this patch and CONFIG_CPUSETS). Any user
> can bind its process to (say) CPU 4. This shouldn't block cpu-unplug.
> 
> Now, let's suppose that this process is a member of some cpuset which
> contains CPUs 3 and 4, and CPU 4 goes down.
> 
> Before this patch, process leaves its ->cpuset and migrates to some "random"
> any_online_cpu(). With this patch it stays within ->cpuset and migrates to
> CPU 3.

The decision to bind a task to a specific cpu, was taken by the userspace
for a reason, which is _unknown_ to the kernel.
So logically, shouldn't the userspace decide what should be 
the fate of those exclusive-affined tasks, whose cpu is about to go
offline? After all, the reason to offline the cpu is, again, unknown to
the kernel.

Though we have been breaking such a task's affinity in  
/* No more Mr. Nice Guy. */ part, IMO a nicer way to do it would be to: 
- Fail the cpu-offline operation with -EBUSY, if there exist userspace tasks 
  exclusively affined to that cpu.
- Provide some kind of infrastructure like a sysfs file
  /sys/devices/system/cpu/cpuX/exclusive_tasks which will help
  the administrator take proactive steps before requesting a
  cpu offline, instead of the kernel taking the reactive step once the
  offline is done.

The side-effect, ofcourse would be that it would break some of the
existing applications, which are not used to cpu-offline failing unless
the cpu was already offline or there was only one online cpu. But is the
side effect so critical, that we continue with this funny contradiction in 
the kernel?! Or is there something important, I'm missing here?

> 
> > Look at it this way.  If we were to merge this patch then it would be
> > logical to also merge a patch which has the following description:
> >
> >   "if an process attempts to pin itself onto an presently-offlined CPU,
> >    the kernel will choose a different CPU according to <heuristics> and
> >    will pin the process to that CPU instead".
> 
> set_cpus_allowed() just returns -EINVAL in that case, this looks a bit
> more logical.
> 

Yup, it sure does!

> Oleg.
> 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
