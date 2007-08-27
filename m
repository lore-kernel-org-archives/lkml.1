Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbXH0QZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbXH0QZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXH0QZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:25:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756866AbXH0QZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:25:28 -0400
Date: Mon, 27 Aug 2007 09:25:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com, oleg@tv-sign.ru,
       pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V3: hotplug cpu: migrate a task within its cpuset
Message-Id: <20070827092500.be762139.akpm@linux-foundation.org>
In-Reply-To: <20070827160703.GA2446@sgi.com>
References: <20070827160703.GA2446@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 11:07:03 -0500 Cliff Wickman <cpw@sgi.com> wrote:

> 
> Version 3 adds a missing task_rq_lock()/task_rq_unlock() pair. (Oleg found)
> 
> There was discussion about this patch among:
> Andrew Morton, Oleg Nesterov, Gautham Shenoy, Rusty Russell
> regarding other approaches:
>   refusing to offline a cpu with tasks pinned to it, or
>   providing an administrator the ability to assign such tasks to other cpus
> 
> There is indeed an "assumption" in my patch that the cpuset containing a
> pinned task's cpu is a better choice than any online cpu. I think that is
> a reasonable assumption given the typical construction of a cpuset and the
> reason a task is running in a cpuset.
> 
> And there will be coming cases, at least on some architectures, where a
> cpu is offlined as a kernel reaction to a hardware error.  In that case
> would it not be preferrable to re-pin such tasks and let them proceed?
> 
> 
> 
> When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
> that have been running on that cpu.
> 
> Currently, such a task is migrated:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any cpu which is both online and among that task's cpus_allowed
> 
> It is typical of a multithreaded application running on a large NUMA system
> to have its tasks confined to a cpuset so as to cluster them near the
> memory that they share. Furthermore, it is typical to explicitly place such
> a task on a specific cpu in that cpuset.  And in that case the task's
> cpus_allowed includes only a single cpu.
> 
> This patch would insert a preference to migrate such a task to some cpu within
> its cpuset (and set its cpus_allowed to its entire cpuset).
> 
> With this patch, migrate the task to:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any online cpu within the task's cpuset
>  3) to any cpu which is both online and among that task's cpus_allowed
> 

<looks at the No more Mr. Nice Guy. code>

OK, so we're no worse than we used to be, really.

>  include/linux/cpuset.h |    5 +++++
>  kernel/cpuset.c        |   15 ++++++++++++++-
>  kernel/sched.c         |   16 ++++++++++++++++

How do we communicate this new design/feature to our users? 
Documentation/cpusets.txt, perhaps?  Documentation/cpu-hotplug.txt? 
git-log?  ;)


