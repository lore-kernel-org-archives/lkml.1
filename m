Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXH1NqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXH1NqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXH1Np6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:45:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36477 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbXH1Np5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:45:57 -0400
Date: Tue, 28 Aug 2007 17:48:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: cpusets vs cpu-hotplug interaction is broken?
Message-ID: <20070828134853.GA204@tv-sign.ru>
References: <20070825162606.GA2630@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825162606.GA2630@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cpu-hotplug experts cc'ed)

On 08/25, Oleg Nesterov wrote:
>
> After the brief look at kernel/cpuset.c, it seems that attach_task() should
> guarantee that the task can't use CPUs outside of cpuset->cpus_allowed.
> 
> But this looks racy wrt sched_setaffinity() which does
> 
> 	cpus_allowed = cpuset_cpus_allowed(p);
> 	// callback_mutex is free
> 	set_cpus_allowed(p);
> 
> What if attach_task()->set_cpus_allowed() happens in between?

Actually, I think there is another problem, and cpuset_cpus_allowed() is
just broken wrt CONFIG_HOTPLUG_CPU.

Suppose that CONFIG_CPUSETS is true, but we don't use cpusets. In that
case all tasks in system belong to the top_cpuset (btw, why cpuset_init()
sets init_task.cpuset? this was already done by cpuset_init_early()), and
we should have the same behaviour as without CONFIG_CPUSETS.

By default, all tasks have ->cpus_allowed = CPU_MASK_ALL inherited from
kernel_init(). This means that the task can use the new CPU right after
cpu_up().

Now let's suppose that some task does sched_setaffinity(0, CPU_MASK_ALL).
In that case, cpuset_cpus_allowed() sets ->cpus_allowed = cpu_online_map,
and I think this is just wrong. Now that task doesn't see the new CPUs.

Of course, we have the similar problem with cpusets other than top_cpuset.

In short, unless I missed something, top_cpuset.cpus_allowed should be
cpu_possible_map, guarantee_online_cpus() shouldn't mix "allowed" and
"online" masks.

Oleg.

