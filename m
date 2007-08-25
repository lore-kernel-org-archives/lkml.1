Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbXHYJpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbXHYJpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763007AbXHYJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:45:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54495 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761666AbXHYJpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:45:05 -0400
Date: Sat, 25 Aug 2007 13:47:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cliff Wickman <cpw@sgi.com>, ego@in.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070825094740.GA106@tv-sign.ru>
References: <20070824221806.GA3602@sgi.com> <20070824155455.cc161b61.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824155455.cc161b61.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Andrew Morton wrote:
>
> On Fri, 24 Aug 2007 17:18:06 -0500
> Cliff Wickman <cpw@sgi.com> wrote:
> 
> > When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
> > that have been running on that cpu.
> > 
> > Currently, such a task is migrated:
> >  1) to any cpu on the same node as the disabled cpu, which is both online
> >     and among that task's cpus_allowed
> >  2) to any cpu which is both online and among that task's cpus_allowed
> > 
> > It is typical of a multithreaded application running on a large NUMA system
> > to have its tasks confined to a cpuset so as to cluster them near the
> > memory that they share. Furthermore, it is typical to explicitly place such
> > a task on a specific cpu in that cpuset.  And in that case the task's
> > cpus_allowed includes only a single cpu.
> 
> operator error..
> 
> > This patch would insert a preference to migrate such a task to some cpu within
> > its cpuset (and set its cpus_allowed to its entire cpuset).
> > 
> > With this patch, migrate the task to:
> >  1) to any cpu on the same node as the disabled cpu, which is both online
> >     and among that task's cpus_allowed
> >  2) to any online cpu within the task's cpuset
> >  3) to any cpu which is both online and among that task's cpus_allowed
> 
> Wouldn't it be saner to refuse the offlining request if the CPU has tasks
> which cannot be migrated to any other CPU?  I mean, the operator has gone
> and asked the machine to perform two inconsistent/incompatible things at
> the same time.

I don't think so (regardless of this patch and CONFIG_CPUSETS). Any user
can bind its process to (say) CPU 4. This shouldn't block cpu-unplug.

Now, let's suppose that this process is a member of some cpuset which
contains CPUs 3 and 4, and CPU 4 goes down.

Before this patch, process leaves its ->cpuset and migrates to some "random"
any_online_cpu(). With this patch it stays within ->cpuset and migrates to
CPU 3.

> Look at it this way.  If we were to merge this patch then it would be
> logical to also merge a patch which has the following description:
>
>   "if an process attempts to pin itself onto an presently-offlined CPU,
>    the kernel will choose a different CPU according to <heuristics> and
>    will pin the process to that CPU instead".

set_cpus_allowed() just returns -EINVAL in that case, this looks a bit
more logical.

Oleg.

