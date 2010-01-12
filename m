Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693Ab0ALIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0ALIyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558Ab0ALIyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:54:20 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42554 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0ALIyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:54:19 -0500
Date: Tue, 12 Jan 2010 14:24:17 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100112085417.GA17299@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
 <20100112053559.GL5243@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100112053559.GL5243@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Frederic,


> 
> 
> So, as stated before, uprobe seems to handle too much standalone
> policies such as freeing on exec, always inherit on clone and never
> on fork. Such rules should be decided from uprobe clients not
> from uprobe itself and that makes it not enough flexible to
> be usable for now.

Lets say we were tracing process A and had inserted few breakpoints.
If this process were to peform an exec, we would be loading a new
process image. The old breakpoints are actually detrimental now 
and hence all the breakpoints that we had installed would
have to be removed anyway. And new breakpoints have to be installed at
different locations. 

If this process were to fork then we would have to create all the
per process uprobes book-keeping including one page per process 
instruction store. In most cases fork would be followed by exec.
which would mean we would have to trash the breakpoints that we
inherited.

Tracing a newly exec-ed process or a forked process is similar to
starting a new uprobes session.

Also uprobes would allow more than one kernel module/plugin to trace
the same process. i.e for the same process at the same breakpoint
one client may want a follow-on-fork, or follow-on-exec, the other one
may not be wanting it. 

But I understand your requirements for tracing a session rather than
just a process. And thats where the utrace based task-finder or
something similar finds its application. So this layer(task-finder)
would be able to tell uprobes to start tracing an process based on
certain criteria.

Since uprobes uses breakpoint instruction, all threads of a process
which is being traced would take an exception when passing thro a
breakpoint. Hence we have to always inherit on clone. If a client wants
to trace only certain threads of a process, then he could filter them in
the uprobe trace handler.

I feel the current uprobes + task finder would be much more flexible.
perf could probably use this combination. Also this approach would
reduce un-necessary creation of uprobes book-keeping for process where
we may never place probes. 

> 
> For example if we want it to be usable by perf, we have two ways:
> 
> - a trace event. Unfortunately, like I explained in a previous
>   mail, this doesn't seem to be a suitable interface for this
>   particular case.
> 
> - a performance monitoring unit, with the existing unified interface
>   struct pmu, usable by perf.
> 
> 
> Typically, to use it with perf toward a pmu, perf tools need to
> create a uprobe on perf process and activate its hook on the next exec.
> Thereafter, it's up to perf to decide if we inherit through clone
> and fork.
> 
> Here I fear utrace and perf are going to collide.

I am not sure why utrace and perf would collide. 
I think utrace is a layer below uprobes so perf could use utrace
directly(if it implements the task-finder logic) or use utrace thro
uprobes.

> 
> See how could be the final struct pmu (we need to extend it
> to support utrace):
> 
> struct pmu {
> 	enable() -> called we schedule in a context where we want
>                     a uprobe to be active. Called very often
>         disable() -> the above opposite
> 
>         /* Not yet existing callbacks */
> 
>         hook_task() -> called when a process is created which
>                        we want to activate our hook
>                        would be typically called once on
>                        exec if we have set enable_on_exec
>                        and also on clone()/fork()
>                        if we want to inherit.
> }
> 
> 
> The above hook_task (could be divided in more precise callback events
> like hook_on_exec, hook_on_clone, etc...) would be needed by perf
> to drive correctly utrace and this is going to collide with utrace
> callbacks that notify execs and forks.

As pointed by Ananth, this hook on exec, hook on fork is exactly what
the taskfinder/perf would provide using the utrace api's.

If there is any reason why utrace and perf could collide then can you
please put in more details. In such a case, Roland and others may have
more ideas on how to work around these issues.

Please let me know your thoughts.


--
Thanks and Regards
Srikar 
